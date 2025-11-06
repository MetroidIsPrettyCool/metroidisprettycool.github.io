;;; tidy-hook.el --- tidy hook for org html export  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Joseph Burke

;; This file is not part of GNU Emacs.

;; Any copyright is dedicated to the Public Domain.
;; http://creativecommons.org/publicdomain/zero/1.0/

;;; Commentary:

;;; Code:

(defun tidy-hook-do-it (text backend _info)
  (when (org-export-derived-backend-p backend 'html)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "tidy" t '(t nil) nil "-qin" "-utf8")
      (buffer-string))))

(provide 'tidy-hook)

;;; tidy-hook.el ends here
