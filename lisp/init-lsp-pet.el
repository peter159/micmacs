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
  :diminish
  :defines (lsp-clients-python-library-directories
            lsp-rust-server)
  :commands (lsp-enable-which-key-integration
             lsp-format-buffer
             lsp-organize-imports
             lsp-install-server)

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

  :hook ((prog-mode . (lambda ()
			(unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode)
			  (lsp-deferred))))
	 (lsp-mode . (lambda ()
                       ;; Integrate `which-key'
                       (lsp-enable-which-key-integration)

                       ;; Format and organize imports
                       (add-hook 'before-save-hook #'lsp-format-buffer t t)
                       (add-hook 'before-save-hook #'lsp-organize-imports t t))))
  :bind (:map lsp-mode-map
              ("C-c C-d" . lsp-describe-thing-at-point)
              ([remap xref-find-definitions] . lsp-find-definition)
              ([remap xref-find-references] . lsp-find-references))
  :init
  ;; @see https://emacs-lsp.github.io/lsp-mode/page/performance
  (setq read-process-output-max (* 1024 1024)) ;; 1MB

  (setq lsp-keymap-prefix "C-c l"
        lsp-auto-guess-root nil
        lsp-keep-workspace-alive nil
	lsp-completion-provider t
        lsp-signature-auto-activate nil
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil
	lsp-modeline-workspace-status-enable nil

        lsp-enable-file-watchers nil
        lsp-enable-folding nil
        lsp-enable-symbol-highlighting nil
        lsp-enable-text-document-color nil

        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil)
  :config
  (with-no-warnings
    (defun my-lsp--init-if-visible (func &rest args)
      "Not enabling lsp in `git-timemachine-mode'."
      (unless (bound-and-true-p git-timemachine-mode)
        (apply func args)))
    (advice-add #'lsp--init-if-visible :around #'my-lsp--init-if-visible))

  (defun lsp-update-server ()
    "Update LSP server."
    (interactive)
    ;; Equals to `C-u M-x lsp-install-server'
    (lsp-install-server t)))

(use-package lsp-ui
  :custom-face
  (lsp-ui-sideline-code-action ((t (:inherit warning))))
  :bind (("C-c u" . lsp-ui-imenu)
         :map lsp-ui-mode-map
         ("M-<f6>" . lsp-ui-hydra/body)
         ("M-RET" . lsp-ui-sideline-apply-code-actions))
  :hook (lsp-mode . lsp-ui-mode)
  :init (setq lsp-ui-sideline-show-diagnostics nil
              lsp-ui-sideline-ignore-duplicate t
              lsp-ui-doc-border (face-foreground 'font-lock-comment-face)
              lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                                    ,(face-foreground 'font-lock-string-face)
                                    ,(face-foreground 'font-lock-constant-face)
                                    ,(face-foreground 'font-lock-variable-name-face)))
  :config
  ;; `C-g'to close doc
  (advice-add #'keyboard-quit :before #'lsp-ui-doc-hide)

  ;; Reset `lsp-ui-doc-background' after loading theme
  (add-hook 'after-load-theme-hook
            (lambda ()
              (setq lsp-ui-doc-border (face-foreground 'font-lock-comment-face))
              (set-face-background 'lsp-ui-doc-background
                                   (face-background 'tooltip)))))

(provide 'init-lsp-pet)
(message "init-lsp loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp.el ends here
