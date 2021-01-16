;;; init-lsp-ess.el ---                              -*- lexical-binding: t; -*-

;; Copyright (C) 2021  linyi

;; Author: linyi <linyi@ubun-born-0>
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
;; install R and build essential, this needs a lot of packages, be care to read install.package error

;; # install.packages("devtools")
;; devtools::install_github("REditorSupport/languageserver")")

;; 

;;; Code:

(mark-time-here)

(use-package ess
  :ensure t
  :init
  ;; (setq inferior-ess-r-program "/usr/bin/R") ;inferior-R-program-name
  (setq ess-nuke-trailing-whitespace-p t
	ess-ask-for-ess-directory nil
	ess-set-style 'RStudio	;'Rstudio-
	ess-help-own-frame t
	ess-help-reuse-window nil
	ess-indent-offset 2)
  :config
  (require 'ess-site)
  (setq ess-offset-continued 'cascade)
  (setq ess-smart-operators t)
  (add-hook 'ess-r-package-mode-hook 'electric-pair-mode)
  (define-key ess-mode-map (kbd "M--") '(lambda()(interactive)(insert " <- ")))
  (define-key ess-mode-map (kbd "C--") '(lambda()(interactive)(insert "-")))
  )

(provide 'init-lsp-ess)
(message "init-lsp-ess loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp-ess.el ends here
