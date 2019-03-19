;;; init-company.el ---                              -*- lexical-binding: t; -*-

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

(use-package company
  :ensure t
  :diminish company-mode
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :commands company-abort
  :bind (("M-/" . company-complete)
	 ("<backtab>" . company-yasnippet)
	 :map company-active-map
	 ("C-p" . company-select-previous)
	 ("C-n" . company-select-next)
	 ("<tab>" . company-complete-selection)
	 ("C-/" . counsel-company)
	 ;; ("C-M-/" . company-filter-candidates)
	 ("C-d" . company-show-doc-buffer)
	 :map company-search-map
	 ("C-p" . company-select-previous)
	 ("C-n" . company-select-next)
	 ;; ("C-/" . company-search-candidates)
	 ;; ("C-M-/" . company-filter-candidates)
	 ("C-d" . company-show-doc-buffer))
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-align-annotations nil ; when t, aligns annotation to the right
	company-tooltip-limit 12	      ; bigger popup window
	company-idle-delay .1		      ; decrease delay before autocompletion popup shows
	company-echo-delay 0		      ; remove annoying blinking
	company-minimum-prefix-length 2
	company-require-match nil
	company-dabbrev-ignore-case nil
	company-dabbrev-downcase nil)
  (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete))

(when (>= emacs-major-version 25) 
  (use-package company-box
    :ensure t
    :diminish
    :functions (all-the-icons-faicon
                all-the-icons-material
                all-the-icons-octicon
                all-the-icons-alltheicon)
    :hook (company-mode . company-box-mode)
    :init
    ;; (use-package all-the-icons :ensure t :defer nil)
    (require 'all-the-icons)		;FIXME maybe all-the-icons not support auto-loads?
    (setq company-box-enable-icon nil) ;(display-graphic-p)
    (setq company-box-doc-enable nil)  ;do not show tooltip at popup
    :config
    (setq company-box-backends-colors nil)
    (define-key emacs-lisp-mode-map (kbd "M-h") 'company-box-doc-manually)))

(provide 'init-company)
(message "init-company loaded in '%.2f' seconds" (get-time-diff time-marked))
;;; init-company.el ends here
