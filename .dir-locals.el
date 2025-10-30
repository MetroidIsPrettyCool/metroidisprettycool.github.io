;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 120)))
 (org-mode . ((eval . (require 'yt-embed (concat (project-root (project-current)) ".emacs/yt-embed.el")))))
 (org-mode
  .
  ((eval .
         (setq-local
          org-publish-project-alist
          `(("metroidisprettycool.github.io"
             :base-directory ,(concat (project-root (project-current)) "src/")

             :recursive t

             :publishing-function org-html-publish-to-html

             :publishing-directory ,(concat (project-root (project-current)) "docs/")

             :html-link-home "/index.html"

             :html-link-up "./index.html"

             :html-doctype "xhtml-frameset"

             :html-head-extra "<link rel=\"icon\" type=\"image/png\" href=\"/favicon.ico\" />")))))))
