;;; yt-embed.el --- org-mode links to embed YouTube videos  -*- lexical-binding: t; -*-

;;; Commentary:

;; ADAPTED FROM <https://endlessparentheses.com/embedding-youtube-videos-with-org-mode-links.html>

;;; Code:

(require 'ol)

(let ((yt-iframe-format
       (concat
        "<iframe width=\"600\""
        " height=\"338\""
        " src=\"https://www.youtube.com/embed/%s\""
        " frameborder=\"0\""
        ">%s</iframe>")))
  (org-link-set-parameters
   "yt"
   :follow (lambda (path _) (browse-url-xdg-open (concat "https://www.youtube.com/embed/" path)))
   :export
   (lambda (path desc backend _)
     (pcase backend
       (`html (format yt-iframe-format path (or desc "")))
       (`latex (format "\href{%s}{%s}" path (or desc "video")))
       (_ path)))))

(provide 'yt-embed)

;;; yt-embed.el ends here
