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
  ;; (setq inferior-ess-r-program "D:/R-3.5.1/bin/x64/Rterm.exe") ;inferior-R-program-name
  ;; (setq inferior-ess-r-program "c:/Users/peter.lin/R-3.6.2/bin/x64/Rterm.exe") ;inferior-R-program-name
  (setq inferior-ess-r-program "/usr/bin/R") ;inferior-R-program-name
  (setq ess-enable-smart-equal nil
	ess-first-continued-statement-offset 2
	ess-continued-statement-offset 0
        ess-expression-offset 2
	ess-nuke-trailing-whitespace-p t
	ess-ask-for-ess-directory nil
	ess-default-style 'default	;'Rstudio-
	ess-help-own-frame nil
	ess-help-reuse-window nil
	ess-indent-offset 2
	ess-offset-continued 'straight)
  (use-package electric-spacing
    :ensure t)

  :hook
  (after-init . electric-spacing-mode)

  :config
  (require 'ess-site)
  (add-hook 'ess-mode-hook #'electric-spacing-mode)
  (add-hook 'inferior-ess-mode-hook 'electric-spacing-mode)
  (add-hook 'inferior-ess-mode-hook 'electric-pair-mode)
  (add-hook 'ess-r-package-mode-hook 'electric-spacing-mode)
  (add-hook 'ess-r-package-mode-hook 'electric-pair-mode)
  (define-key ess-mode-map (kbd "M--") '(lambda()(interactive)(insert " <- ")))
  (define-key ess-mode-map (kbd ".") '(lambda()(interactive)(insert ".")))
  (define-key inferior-ess-mode-map (kbd ".") '(lambda()(interactive)(insert ".")))
  (define-key ess-mode-map (kbd "C--") '(lambda()(interactive)(insert "-")))
  )

(provide 'init-ess)
(message "init-ess loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-ess.el ends here
