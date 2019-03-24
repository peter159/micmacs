;;; init-ibuffer.el ---                              -*- lexical-binding: t; -*-

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

(use-package ibuffer
  :ensure nil
  :functions (all-the-icons-icon-for-buffer
              all-the-icons-icon-for-mode
              all-the-icons-icon-family)
  :commands (ibuffer-current-buffer
             ibuffer-find-file
             ibuffer-do-sort-by-alphabetic)
  :bind ("C-x C-b" . ibuffer)
  :init
  (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold)))

  ;; Display buffer icons on GUI
  (when (display-graphic-p)
    (define-ibuffer-column icon (:name " ")
      (let ((icon (all-the-icons-icon-for-buffer)))
        (if (symbolp icon)
            (setq icon (all-the-icons-icon-for-mode 'fundamental-mode)))
        (unless (symbolp icon)
          (propertize icon
                      'face `(
                              :height 1.1
                              :family ,(all-the-icons-icon-family icon)
                              :inherit
                              )))))

    (setq ibuffer-formats '((mark modified read-only locked
                                  " " (icon 2 2 :left :elide) (name 18 18 :left :elide)
                                  " " (size 9 -1 :right)
                                  " " (mode 16 16 :left :elide) " " filename-and-process)
                            (mark " " (name 16 -1) " " filename))))
  :config
  (with-eval-after-load 'counsel
    (defalias 'ibuffer-find-file 'counsel-find-file))
  (define-key ibuffer-mode-map (kbd "j") 'evil-next-line)
  (define-key ibuffer-mode-map (kbd "k") 'evil-previous-line)
  (define-key ibuffer-mode-map (kbd "h") 'evil-backward-char)
  (define-key ibuffer-mode-map (kbd "l") 'evil-forward-char)

  ;; Group ibuffer's list by project root
  (use-package ibuffer-projectile
    :functions all-the-icons-octicon
    :hook ((ibuffer . (lambda ()
                        (ibuffer-projectile-set-filter-groups)
                        (unless (eq ibuffer-sorting-mode 'alphabetic)
                          (ibuffer-do-sort-by-alphabetic)))))
    :config
    (setq ibuffer-projectile-prefix
          (if (display-graphic-p)
              (concat
               (all-the-icons-octicon "file-directory"
                                      :face ibuffer-filter-group-name-face
                                      :v-adjust -0.04
                                      :height 1.1)
               " ")
            "Project: "))))

(provide 'init-ibuffer)
(message "init-ibuffer loaded in %.2f second ..." (get-time-diff time-marked))
;;; init-ibuffer.el ends here
