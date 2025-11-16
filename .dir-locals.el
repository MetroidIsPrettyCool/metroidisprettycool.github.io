;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 120)))
 (org-mode . ((eval . (setq-local
                       org-publish-project-alist
                       `(("metroidisprettycool.github.io"
                          :base-directory ,(expand-file-name "src/" (project-root (project-current)))
                          :recursive t
                          :exclude "common/"

                          :publishing-function org-html-publish-to-html
                          :publishing-directory ,(expand-file-name "docs/" (project-root (project-current)))

                          :with-entities     t
                          :with-smart-quotes t
                          :html-extension "xhtml"

                          :completion-function
                          ,(lambda (project-plist)
                             "Check for errors in exported HTML with tidy."
                             (let* ((publishing-directory (plist-get project-plist :publishing-directory))
                                    (extension (or (plist-get project-plist :html-extension) org-html-extension))
                                    (published-files (if (plist-get project-plist :recursive)
                                                         (directory-files-recursively publishing-directory
                                                                                      (rx (literal extension) eos))
                                                       (directory-files t publishing-directory
                                                                        (rx (literal extension) eos))))
                                    (tidy-args (append '("--gnu-emacs" "yes" "--markup" "no" "--show-filename" "yes")
                                                       published-files)))
                               (let ((tidy-result-buffer (compilation-start
                                                          (mapconcat #'shell-quote-argument (cons "tidy" tidy-args) " ")
                                                          'compilation-mode
                                                          (lambda (mode-name) "*tidy-results*"))))
                                 (run-at-time 0.1 nil (lambda () (display-buffer tidy-result-buffer)))))))))))))
