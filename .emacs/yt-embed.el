;;; yt-embed.el --- org-mode links to embed YouTube videos  -*- lexical-binding: t; -*-

;;; Commentary:

;; THIS CODE IS NOT MY WORK! COPIED FROM
;; <https://endlessparentheses.com/embedding-youtube-videos-with-org-mode-links.html>

;;; Code:

(defvar yt-iframe-format
  ;; You may want to change your width and height.
  (concat "<iframe width=\"600\""
          " height=\"338\""
          " src=\"https://www.youtube.com/embed/%s\""
          " frameborder=\"0\""
          ">%s</iframe>"))

(org-add-link-type
 "yt"
 (lambda (handle)
   (browse-url
    (concat "https://www.youtube.com/embed/"
            handle)))
 (lambda (path desc backend)
   (cl-case backend
     (html (format yt-iframe-format
                   path (or desc "")))
     (latex (format "\href{%s}{%s}"
                    path (or desc "video"))))))

;;; yt-embed.el ends here
