;;; init-ess.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2019  

;; Author:  <lipe6002@SHA-LPC-03254>
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

(use-package ess
  :ensure t
  :init
  (setq inferior-R-program-name "C:/Program Files/R/R-3.4.4/bin/x64/Rterm.exe")
  (setq ess-enable-smart-equal nil)
  (setq ess-ask-for-ess-directory nil)
  (setq ess-default-style 'RStudio-)
  (setq ess-help-own-frame nil)
  (setq ess-help-reuse-window nil)
  (setq ess-indent-offset 2)
  (setq ess-offset-continued 'straight)
  
  (use-package electric-spacing
    :ensure t)

  :hook (after-init . electric-spacing-mode)

  :config
  (require 'ess-site)
  (add-hook 'ess-mode-hook #'electric-spacing-mode)
  (add-hook 'inferior-ess-mode-hook 'electric-spacing-mode)
  (add-hook 'inferior-ess-mode-hook 'electric-pair-mode)
  (add-hook 'ess-r-package-mode-hook 'electric-spacing-mode)
  (add-hook 'ess-r-package-mode-hook 'electric-pair-mode)
  (define-key ess-mode-map (kbd "M--") '(lambda()(interactive)(insert " <- ")))
  (define-key ess-mode-map (kbd ".") '(lambda()(interactive)(insert ".")))
  (define-key ess-mode-map (kbd "C--") '(lambda()(interactive)(insert "-")))
  )

(provide 'init-ess)
(message "init-ess loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-ess.el ends here
