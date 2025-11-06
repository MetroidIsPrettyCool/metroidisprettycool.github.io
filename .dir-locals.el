;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 120)))
 (org-mode . ((eval . (require 'yt-embed (concat (project-root (project-current)) ".emacs/yt-embed.el")))
              (eval . (require 'tidy-hook (concat (project-root (project-current)) ".emacs/tidy-hook.el")))
              (org-html-extension . "xhtml")
              (org-export-filter-final-output-functions . (tidy-hook-do-it))
              (org-export-global-macros . (("citation-footer" . "(eval (format \"* Citations:
:PROPERTIES:
:UNNUMBERED: notoc
:END:

#+CITE_EXPORT: csl %ssrc/3rdparty/apa.csl
#+PRINT_BIBLIOGRAPHY:

-----

These formatted citations were generated with the [[https://github.com/citation-style-language/styles/blob/master/apa.csl][APA CSL style]] from the Citation Style Language Project, licensed under
the [[https://creativecommons.org/licenses/by-sa/3.0/][Creative Commons Attribution-ShareAlike 3.0 Unported license]] 🅭🅯🄎.

Learn more about the CSL project at their home page: [[https://citationstyles.org/]].
\" (project-root (project-current))))")
                                           ("license-footer" . "* License:
:PROPERTIES:
:UNNUMBERED: notoc
:END:
Copyright $1 [[https://github.com/MetroidIsPrettyCool][Joseph Burke]]. All original content published to this website is licensed under a [[https://creativecommons.org/licenses/by-sa/4.0/][CC BY-SA 4.0]] 🅭🅯🄎
license, unless explicitly stated otherwise.
")))
              (eval .
                    (setq-local
                     org-publish-project-alist
                     `(("metroidisprettycool.github.io"
                        :base-directory ,(concat (project-root (project-current)) "src/")

                        :recursive t

                        :publishing-function org-html-publish-to-html

                        :publishing-directory ,(concat (project-root (project-current)) "docs/")

                        :html-link-home "/index.xhtml"

                        :html-link-up "./index.xhtml"

                        :html-doctype "xhtml5"

                        :html-head-extra "<link rel=\"icon\" type=\"image/png\" href=\"/favicon.ico\" />")))))))
