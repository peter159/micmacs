;;; init-lsp.el ---                                  -*- lexical-binding: t; -*-

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

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(use-package lsp-mode
  :ensure t
  :diminish
  :defines (lsp-clients-python-library-directories
            lsp-rust-server)
  :commands (lsp-enable-which-key-integration
             lsp-format-buffer
             lsp-organize-imports
             lsp-install-server)
  :init
  (setq read-process-output-max (* 1024 1024)) ; @see https://github.com/emacs-lsp/lsp-mode#performance
  (setq lsp-keymap-prefix "C-c l"
	lsp-auto-guess-root nil
	lsp-keep-workspace-alive nil
	lsp-completion-provider t
	lsp-signature-auto-activate nil
	lsp-headerline-breadcrumb-enable t ;https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
	lsp-ui-doc-enable t
	lsp-enable-file-watchers nil
	lsp-enable-folding nil
	lsp-enable-indentation nil
	lsp-enable-on-type-formatting nil
	lsp-enable-symbol-highlighting nil)
  :hook ((prog-mode . (lambda ()
			(unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode)
			  (lsp-deferred))))
	 (lsp-mode . (lambda ()
                       ;; Integrate `which-key'
                       (lsp-enable-which-key-integration)))
	 )
  :bind (:map lsp-mode-map
              ("C-c C-d" . lsp-describe-thing-at-point)
              ([remap xref-find-definitions] . lsp-find-definition)
              ([remap xref-find-references] . lsp-find-references))
  :custom-face
  (lsp-headerline-breadcrumb-path-error-face
   ((t :underline (:style line :color ,(face-foreground 'error))
       :inherit lsp-headerline-breadcrumb-path-face)))
  (lsp-headerline-breadcrumb-path-warning-face
   ((t :underline (:style line :color ,(face-foreground 'warning))
       :inherit lsp-headerline-breadcrumb-path-face)))
  (lsp-headerline-breadcrumb-path-info-face
   ((t :underline (:style line :color ,(face-foreground 'success))
       :inherit lsp-headerline-breadcrumb-path-face)))
  (lsp-headerline-breadcrumb-path-hint-face
   ((t :underline (:style line :color ,(face-foreground 'success))
       :inherit lsp-headerline-breadcrumb-path-face)))
  (lsp-headerline-breadcrumb-symbols-error-face
   ((t :inherit lsp-headerline-breadcrumb-symbols-face
       :underline (:style line :color ,(face-foreground 'error)))))
  (lsp-headerline-breadcrumb-symbols-warning-face
   ((t :inherit lsp-headerline-breadcrumb-symbols-face
       :underline (:style line :color ,(face-foreground 'warning)))))
  (lsp-headerline-breadcrumb-symbols-info-face
   ((t :inherit lsp-headerline-breadcrumb-symbols-face
       :underline (:style line :color ,(face-foreground 'success)))))
  (lsp-headerline-breadcrumb-symbols-hint-face
   ((t :inherit lsp-headerline-breadcrumb-symbols-face
       :underline (:style line :color ,(face-foreground 'success)))))
  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-doc-mode)

;; if you are ivy user
(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :ensure t
  :preface
  (defun toggle-lsp-treemacs-symbols ()
    "Toggle the lsp-treemacs-symbols buffer."
    (interactive)
    (if (get-buffer "*LSP Symbols List*")
	(kill-buffer "*LSP Symbols List*")
      (progn (lsp-treemacs-symbols)
             (other-window -1))))
  :commands lsp-treemacs-errors-list
  :config
  (define-key prog-mode-map (kbd "<f7>") 'toggle-lsp-treemacs-symbols)
  )

(use-package format-all
  :ensure t
  :hook
  (lsp-mode . format-all-mode)
  :config
  (define-key lsp-mode-map (kbd "M-f") 'format-all-buffer))

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(provide 'init-lsp)
(message "init-lsp loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp.el ends here 
