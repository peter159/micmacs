;; init-font.el --- Setup fonts.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; (set-default-font "Fira Code Retina 14.5" nil t)
(set-face-attribute 'default nil :font (format "Fira Code Retina-%S" 11))

;; fix the delay when showing text in chinese
(dolist (charset '(kana han cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family "Microsoft Yahei" :size 11))
		    ;; (font-spec :family "等距更纱黑体 SC" :size 12))
  )

(use-package fontify-face
  :ensure t)

(provide 'init-font)

;;; init-font.el ends here
