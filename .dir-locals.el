;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 120)))
 (org-mode . ((eval . (load-file (concat (car (dir-locals-find-file ".")) ".emacs/yt-embed.el")))))
 (org-mode . ((eval . (setq-local org-publish-project-alist `(("metroidisprettycool.github.io"
                                                               :base-directory
                                                               ,(concat (car (dir-locals-find-file "."))
                                                                        "src/")

                                                               :recursive
                                                               t

                                                               :publishing-function
                                                               org-html-publish-to-html

                                                               :publishing-directory
                                                               ,(concat (car (dir-locals-find-file "."))
                                                                        "docs/")

                                                               :html-link-home
                                                               "/index.html"

                                                               :html-link-up
                                                               "./index.html"

                                                               :html-doctype
                                                               "xhtml-frameset"

                                                               :html-head-extra
                                                               ,(concat "<link rel=\"icon\""
                                                                        " type=\"image/png\""
                                                                        " href=\"/favicon.ico\" />"))))))))
