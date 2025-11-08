;;; metroidisprettycool-github-io.el --- configuration for my wabsite  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Joseph Burke

;; This file is not part of GNU Emacs.

;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.

;;; Commentary:

;; YouTube embedding code adapted from
;; <https://endlessparentheses.com/embedding-youtube-videos-with-org-mode-links.html>

;; REQUIRES: tidy, as well as all other the typical org backend requirements.

;;; Code:

(require 'ol)
(require 'ox)
(require 'url)
(require 'xmltok)

(org-link-set-parameters
 "yt"
 :follow (lambda (path _) (browse-url-xdg-open (concat "https://www.youtube.com/embed/" path)))
 :export
 (lambda (path desc backend _)
   (pcase backend
     (`html (format (concat
                     "<iframe width=\"600\""
                     " height=\"338\""
                     " src=\"https://www.youtube.com/embed/%s\""
                     " style=\"margin-left:auto; margin-right:auto\""
                     ">%s</iframe>")
                    path (or desc "")))
     (`latex (format "\href{%s}{%s}" path (or desc "video")))
     (_ path))))

(defun metroidisprettycool-github-io--normalize-urls-in-buffer (xhtml-file-dir normalize-to-dir)
  "Normalizes URLs in an XHTML buffer to be relative to NORMALIZE-TO-DIR.

Simply replaces the value of any href or src attribute that isn't a
fully-qualified URL, doesn't have a URL scheme, doesn't have a URL path
that already starts with /, and isn't just a bare fragment.

Any rewritten paths that end in a / character will be suffixed
\"index.xhtml\".

In addition, when rewriting tags with href attributes, a check is
performed to see if the tag's only content is text equal to that href
attribute's value (e.g. <a href=\"./foo.txt\">./foo.txt</a>), optionally
surrounded on either side with arbitrary whitespace. If it is, the
content of the tag will be rewritten to match the href attribute value.

Assumes buffer already contains well-formed, valid XHTML; that
XHTML-FILE-DIR is equal to or a subdirectory of NORMALIZE-TO-DIR, and
that no relative path points to anything outside NORMALIZE-TO-DIR.

In other words, we're not really bothering with error-checking or
defensive programming, besides whatever error checking we got for free
from our library calls."
  (goto-char (point-min))
  (xmltok-forward-prolog)

  (while (xmltok-forward)
    (dolist (attr xmltok-attributes)
      (let ((name (xmltok-attribute-local-name attr)))
        (when (or (string-equal name "href") (string-equal name "src"))
          (let* ((attr-value (xmltok-attribute-value attr))
                 (url (url-generic-parse-url attr-value))
                 (filename (or (url-filename url) "")))
            (unless (or (url-fullness url)
                        (url-type url)
                        (string-match-p (rx bos ?/) filename)
                        (and (string-empty-p filename) (url-target url)))
              (let* ((attr-start (xmltok-attribute-value-start attr))
                     (attr-end (xmltok-attribute-value-end attr))
                     (attr-len (- attr-start attr-end))
                     (relative-path (concat "/" (file-relative-name (expand-file-name filename xhtml-file-dir)
                                                                    normalize-to-dir)))
                     (new-path (if (string-suffix-p "/" relative-path) (concat relative-path "index.xhtml")
                                 relative-path)))
                (goto-char attr-start)
                (delete-region attr-start attr-end)
                (insert new-path)
                (goto-char xmltok-start)
                (xmltok-forward)
                (when (and (string-equal name "href") (eq xmltok-type 'start-tag))
                  (save-excursion
                    (xmltok-save
                      (let* ((child-type (xmltok-forward))
                             (child-start xmltok-start)
                             (child-end (point)))
                        (when (and (eq child-type 'data) (eq (xmltok-forward) 'end-tag))
                          (let* ((child-content
                                  (buffer-substring-no-properties child-start child-end))
                                 (child-len
                                  (length child-content))
                                 (child-content-tr-left
                                  (string-trim-left child-content))
                                 (child-content-tr-left-len
                                  (length child-content-tr-left))
                                 (child-content-left-whitespace
                                  (- child-len child-content-tr-left-len))
                                 (child-content-tr-both
                                  (string-trim-right child-content-tr-left))
                                 (child-content-tr-both-len
                                  (length child-content-tr-both))
                                 (child-content-right-whitespace
                                  (- child-content-tr-left-len child-content-tr-both-len)))
                            (when (string-equal attr-value child-content-tr-both)
                              (goto-char     (+ child-start child-content-left-whitespace))
                              (delete-region (+ child-start child-content-left-whitespace)
                                             (- child-end child-content-right-whitespace))
                              (insert new-path))))))))))))))))

(defun metroidisprettycool-github-io--normalize-urls (xhtml-file normalize-to-dir)
  (with-temp-buffer
    (insert-file-contents xhtml-file)

    (metroidisprettycool-github-io--normalize-urls-in-buffer (file-name-directory xhtml-file) normalize-to-dir)

    (write-region nil nil xhtml-file)))

(defun metroidisprettycool-github-io--completion-fn (project-plist)
  (let* ((publishing-directory (plist-get project-plist :publishing-directory))
         (xhtml-files (directory-files-recursively publishing-directory (rx ".xhtml"))))
    (dolist (xhtml-file xhtml-files)
      (metroidisprettycool-github-io--normalize-urls xhtml-file publishing-directory))
    (let ((tidy-result (with-temp-buffer
                         (apply #'call-process "tidy" nil t t
                                (mapcan (lambda (file)
                                          (list
                                           "-modify"
                                           "--gnu-emacs"              "yes"
                                           "--show-filename"          "yes"
                                           "-language"                "en"
                                           "--add-meta-charset"       "no"
                                           "--add-xml-decl"           "yes"
                                           "--add-xml-space"          "yes"
                                           "--output-xhtml"           "yes"
                                           "--char-encoding"          "utf8"
                                           "--output-bom"             "no"
                                           "--clean"                  "yes"
                                           "--drop-empty-elements"    "yes"
                                           "--drop-empty-paras"       "yes"
                                           "--merge-divs"             "yes"
                                           "--merge-spans"            "yes"
                                           "--numeric-entities"       "yes"
                                           "--fix-style-tags"         "yes"
                                           "--fix-uri"                "yes"
                                           "--lower-literals"         "yes"
                                           "--repeated-attributes"    "keep-last"
                                           "--strict-tags-attributes" "yes"
                                           "--escape-cdata"           "no"
                                           "--join-styles"            "yes"
                                           "--merge-emphasis"         "yes"
                                           "--replace-color"          "yes"
                                           "--indent"                 "yes"
                                           "--indent-with-tabs"       "no"
                                           "--keep-tabs"              "no"
                                           "--tidy-mark"              "yes"
                                           file))
                                        xhtml-files))
                         (buffer-string))))
      (run-at-time 0.1 nil (lambda ()
                             (with-current-buffer-window "*tidy-results*"
                                 '((display-buffer-reuse-window
                                    display-buffer-pop-up-window
                                    display-buffer-use-least-recent-window
                                    display-buffer-use-some-window
                                    display-buffer-same-window)
                                   .
                                   ((inhibit-switch-frame . t)
                                    (inhibit-same-window . t)
                                    (reusable-frames . nil)
                                    (some-window . lru)))
                                 nil
                               (insert tidy-result)))))))

(let* ((current-project      (project-current t))
       (current-project-root (project-root current-project))
       (base-directory       (expand-file-name "src/" current-project-root))
       (publishing-directory (expand-file-name "docs/" current-project-root)))

  (add-to-list 'org-publish-project-alist
               `("metroidisprettycool.github.io"
                 :base-directory ,base-directory

                 :recursive t

                 :with-smart-quotes t

                 :publishing-function org-html-publish-to-html

                 :completion-function metroidisprettycool-github-io--completion-fn

                 :publishing-directory ,publishing-directory

                 :html-link-home "/index.xhtml"

                 :html-link-up "./index.xhtml"

                 :html-doctype "xhtml5"

                 :html-head-extra ,(concat
                                    "<link rel=\"icon\" type=\"image/png\" href=\"/favicon.ico\" />"
                                    "<style type=\"text/css\">"
                                    "/*<![CDATA[*/"
                                    "pre.src { background-color: black; color: white; }"
                                    "pre.src-rust:before { content: 'Rust'; }"
                                    "/*]]>*/"
                                    "</style>"))))

(provide 'metroidisprettycool-github-io)

;;; metroidisprettycool-github-io.el ends here
