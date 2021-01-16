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
  ;; :preface
  ;; (defun ess--kill-rterm-buffer-and-window (process event)
  ;;   "Kill buffer and window on ess rterm process termination."
  ;;   (when (not (process-live-p process))
  ;;     (let ((buf (process-buffer process)))
  ;; 	(when (buffer-live-p buf)
  ;;         (with-current-buffer buf
  ;;           (kill-buffer)
  ;;           (ignore-errors (delete-window))
  ;;           (message "*R* term closed."))))))
  :init
  ;; (setq inferior-ess-r-program "/usr/bin/R") ;inferior-R-program-name
  (setq ess-nuke-trailing-whitespace-p t
	ess-ask-for-ess-directory nil
	ess-set-style 'RStudio	;'Rstudio-
	ess-smart-operators t
	ess-help-own-frame t
	ess-help-reuse-window nil
	ess-indent-level 2
	ess-indent-offset 2
	ess-offset-continued 'cascade)
  :hook
  (ess-r-package-mode . electric-operator-mode)
  :config
  (require 'ess-site)
  (define-key ess-mode-map (kbd "=") '(lambda()(interactive)(insert " = ")))
  (define-key ess-mode-map (kbd "S-.") '(lambda()(interactive)(insert " > ")))
  (define-key ess-mode-map (kbd "M->") '(lambda()(interactive)(insert " %>% ")))
  (define-key ess-mode-map (kbd "M--") '(lambda()(interactive)(insert " <- ")))
  (define-key ess-mode-map (kbd "C--") '(lambda()(interactive)(insert "-")))
  ;; (add-hook 'ess-r-mode (lambda()
  ;; 			  (set-process-sentinel (get-buffer-process (buffer-name))
  ;; 						#'ess--kill-rterm-buffer-and-window)))
  )

(provide 'init-lsp-ess)
(message "init-lsp-ess loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp-ess.el ends here
