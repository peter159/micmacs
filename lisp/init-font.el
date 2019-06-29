;;; init-font.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2019  

;; Author:  <peter.linyi@DESKTOP-PMTGUNT>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(mark-time-here)

;; setup english word font and size
(set-face-attribute 'default nil :font (format "Fira Code Retina-%S" 12)) ; Fira Code Retina-%S

;; fix the delay when showing text in chinese
(dolist (charset '(kana han cjk-misc bopomofo))
  (if (display-graphic-p)		;to avoid error 'fontset tty' in linux shell environment
      (set-fontset-font (frame-parameter nil 'font) charset
			;; (font-spec :family "Microsoft Yahei" :size 12))
			(font-spec :family "等距更纱黑体 SC" :size 14)))
  )

(use-package fontify-face :ensure t)

(provide 'init-font)
(message "init-font loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-font.el ends here
