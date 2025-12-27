;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 120)))
 (js-json-mode . ((js-indent-level . 2)))
 (org-mode . ((eval . (progn (load-file (expand-file-name
                                         "project.el"
                                         (expand-file-name
                                          "common"
                                          (expand-file-name
                                           "src"
                                           (project-root (project-current))))))
                             (metroidisprettycoolgithubio--set-project-alist))))))
