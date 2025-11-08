;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 120)))
 (org-mode . ((eval . (require 'metroidisprettycool-github-io
                               (expand-file-name "metroidisprettycool-github-io.el" (project-root (project-current)))))
              (org-html-extension . "xhtml")
              (org-export-global-macros . (("citation-footer" . "(eval (format \"* Citations:
:PROPERTIES:
:UNNUMBERED: notoc
:END:

#+CITE_EXPORT: csl %ssrc/3rdparty/apa.csl
#+PRINT_BIBLIOGRAPHY:

-----

These formatted citations were generated with the
[[https://github.com/citation-style-language/styles/blob/master/apa.csl][APA CSL style]] from the Citation Style
Language Project, licensed under the [[https://creativecommons.org/licenses/by-sa/3.0/][Creative Commons
Attribution-ShareAlike 3.0 Unported license]] 🅭🅯🄎.

Learn more about the CSL project at their home page: [[https://citationstyles.org/]].
\" (project-root (project-current t))))")
                                           ("license-footer" . "* License:
:PROPERTIES:
:UNNUMBERED: notoc
:END:

Copyright $1 [[https://github.com/MetroidIsPrettyCool][Joseph Burke]]. All original content published to this website is
licensed under a [[https://creativecommons.org/licenses/by-sa/4.0/][CC BY-SA 4.0]] 🅭🅯🄎 license, unless explicitly stated
otherwise.
"))))))
