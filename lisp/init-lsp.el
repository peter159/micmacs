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

;; (use-package lsp-mode
;;   :init
;;   (setq lsp-auto-guess-root nil)
;;   :hook ((c++-mode . lsp)
;; 	 (lsp-mode . lsp-enable-which-key-integration))
;;   :commands (lsp lsp-deferred))

(use-package lsp-mode
  :ensure t
  :diminish
  ;; :pin melpa-stable
  :preface
  (defun petmacs//lsp-avy-document-symbol (all)
    (interactive)
    (let ((line 0) (col 0) (w (selected-window))
	  (ccls (memq major-mode '(c-mode c++-mode objc-mode)))
	  (start-line (1- (line-number-at-pos (window-start))))
	  (end-line (1- (line-number-at-pos (window-end))))
	  ranges point0 point1
	  candidates)
      (save-excursion
	(goto-char 1)
	(cl-loop for loc in
		 (lsp--send-request (lsp--make-request
				     "textDocument/documentSymbol"
				     `(:textDocument ,(lsp--text-document-identifier)
						     :all ,(if all t :json-false)
						     :startLine ,start-line :endLine ,end-line)))
		 for range = (if ccls loc (->> loc (gethash "location") (gethash "range")))
		 for range_start = (gethash "start" range)
		 for range_end = (gethash "end" range)
		 for l0 = (gethash "line" range_start)
		 for c0 = (gethash "character" range_start)
		 for l1 = (gethash "line" range_end)
		 for c1 = (gethash "character" range_end)
		 while (<= l0 end-line)
		 when (>= l0 start-line)
		 do
		 (forward-line (- l0 line))
		 (forward-char c0)
		 (setq point0 (point))
		 (forward-line (- l1 l0))
		 (forward-char c1)
		 (setq point1 (point))
		 (setq line l1 col c1)
		 (push `((,point0 . ,point1) . ,w) candidates)))
      ;; (require 'avy)
      (avy-with avy-document-symbol
		(avy--process candidates
			      (avy--style-fn avy-style)))))

  (defun petmacs/lsp-avy-goto-word ()
    (interactive)
    (petmacs//lsp-avy-document-symbol t))


  (defun spacemacs/lsp-avy-goto-symbol ()
    (interactive)
    (petmacs//lsp-avy-document-symbol nil))

  (defun petmacs/lsp-ui-doc-func ()
    "Toggle the function signature in the lsp-ui-doc overlay"
    (interactive)
    (setq lsp-ui-doc-include-signature (not lsp-ui-doc-include-signature)))

  (defun petmacs/lsp-ui-sideline-symb ()
    "Toggle the symbol in the lsp-ui-sideline overlay.
    (generally redundant in C modes)"
    (interactive)
    (setq lsp-ui-sideline-show-symbol (not lsp-ui-sideline-show-symbol)))

  (defun petmacs/lsp-ui-sideline-ignore-duplicate ()
    "Toggle ignore duplicates for lsp-ui-sideline overlay"
    (interactive)
    (setq lsp-ui-sideline-ignore-duplicate (not lsp-ui-sideline-ignore-duplicate)))

  (defun petmacs/lsp-find-definition-other-window ()
    (interactive)
    (let ((pop-up-windows t))
      (pop-to-buffer (current-buffer) t))
    (lsp-find-definition))

  (defun petmacs/lsp-find-declaration-other-window ()
    (interactive)
    (let ((pop-up-windows t))
      (pop-to-buffer (current-buffer) t))
    (lsp-find-declaration))

  (defun petmacs/lsp-find-references-other-window ()
    (interactive)
    (let ((pop-up-windows t))
      (pop-to-buffer (current-buffer) t))
    (lsp-find-references))

  (defun petmacs/lsp-find-implementation-other-window ()
    (interactive)
    (let ((pop-up-windows t))
      (pop-to-buffer (current-buffer) t))
    (lsp-find-implementation))

  (defun petmacs/lsp-find-type-definition-other-window ()
    (interactive)
    (let ((pop-up-windows t))
      (pop-to-buffer (current-buffer) t))
    (lsp-find-type-definition))
  :hook (lsp-mode . (lambda ()
		      ;; Integrate `which-key'
		      (lsp-enable-which-key-integration)))
  :bind (:map lsp-mode-map
	      ("C-c C-d" . lsp-describe-thing-at-point)
	      ([remap xref-find-definitions] . lsp-find-definition)
	      ([remap xref-find-references] . lsp-find-references))
  :init
  ;; @see https://github.com/emacs-lsp/lsp-mode#performance
  (setq read-process-output-max (* 1024 1024)) ;; 1MB

  (setq lsp-keymap-prefix "C-c l"
	lsp-auto-guess-root nil
	lsp-keep-workspace-alive nil
	lsp-prefer-capf t
	lsp-signature-auto-activate nil

	lsp-enable-file-watchers nil
	lsp-enable-folding nil
	lsp-enable-indentation nil
	lsp-enable-on-type-formatting nil
	lsp-enable-symbol-highlighting nil)
  :config
  ;; Configure LSP clients
  (use-package lsp-clients
    :ensure nil
    :hook (go-mode . (lambda ()
		       "Format and add/delete imports."
		       (add-hook 'before-save-hook #'lsp-format-buffer t t)
		       (add-hook 'before-save-hook #'lsp-organize-imports t t)))))

(use-package pretty-hydra
  :ensure t
  :bind ("<f6>" . toggles-hydra/body)
  :init
  (with-no-warnings
    (cl-defun pretty-hydra-title (title &optional icon-type icon-name
                                        &key face height v-adjust)
      "Add an icon in the hydra title."
      (let ((face (or face `(:foreground ,(face-background 'highlight))))
            (height (or height 1.0))
            (v-adjust (or v-adjust 0.0)))
        (concat
         (when (and (display-graphic-p) icon-type icon-name)
           (let ((f (intern (format "all-the-icons-%s" icon-type))))
             (when (fboundp f)
               (concat
                (apply f (list icon-name :face face :height height :v-adjust v-adjust))
                " "))))
         (propertize title 'face face))))

    ;; Global toggles
    (pretty-hydra-define toggles-hydra (:title (pretty-hydra-title "Toggles" 'faicon "toggle-on")
					       :color amaranth :quit-key "q")
      ("Basic"
       (("n" (if (fboundp 'display-line-numbers-mode)
                 (display-line-numbers-mode (if display-line-numbers-mode -1 1))
               (global-linum-mode (if global-linum-mode -1 1)))
         "line number" :toggle (if (fboundp 'display-line-numbers-mode)
                                   display-line-numbers-mode
                                 global-linum-mode))
        ("a" global-aggressive-indent-mode "aggressive indent" :toggle t)
        ("h" global-hungry-delete-mode "hungry delete" :toggle t)
        ("e" electric-pair-mode "electric pair" :toggle t)
        ("c" flyspell-mode "spell check" :toggle t)
        ("S" prettify-symbols-mode "pretty symbol" :toggle t)
        ("L" global-page-break-lines-mode "page break lines" :toggle t)
        ("M" doom-modeline-mode "modern mode-line" :toggle t))
       "Highlight"
       (("l" global-hl-line-mode "line" :toggle t)
        ("P" show-paren-mode "paren" :toggle t)
        ("s" symbol-overlay-mode "symbol" :toggle t)
        ("r" rainbow-mode "rainbow" :toggle t)
        ("w" (setq-default show-trailing-whitespace (not show-trailing-whitespace))
         "whitespace" :toggle show-trailing-whitespace)
        ("d" rainbow-delimiters-mode "delimiter" :toggle t)
        ("i" highlight-indent-guides-mode "indent" :toggle t)
        ("T" global-hl-todo-mode "todo" :toggle t))
       "Coding"
       (("f" global-flycheck-mode "flycheck" :toggle t)
        ("F" flymake-mode "flymake" :toggle t)
        ("o" origami-mode "folding" :toggle t)
        ("O" hs-minor-mode "hideshow" :toggle t)
        ("u" subword-mode "subword" :toggle t)
        ("W" which-function-mode "which function" :toggle t)
        ("E" toggle-debug-on-error "debug on error" :toggle (default-value 'debug-on-error))
        ("Q" toggle-debug-on-quit "debug on quit" :toggle (default-value 'debug-on-quit)))
       "Version Control"
       (("v" global-diff-hl-mode "gutter" :toggle t)
        ("V" diff-hl-flydiff-mode "live gutter" :toggle t)
        ("m" diff-hl-margin-mode "margin gutter" :toggle t)
        ("D" diff-hl-dired-mode "dired gutter" :toggle t))
       "Theme"
       (("t d" (centaur-load-theme 'default) "default"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'default)))
        ("t c" (centaur-load-theme 'classic) "classic"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'classic)))
        ("t r" (centaur-load-theme 'colorful) "colorful"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'colorfult)))
        ("t k" (centaur-load-theme 'dark) "dark"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'dark)))
        ("t l" (centaur-load-theme 'light) "light"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'light)))
        ("t y" (centaur-load-theme 'day) "day"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'day)))
        ("t n" (centaur-load-theme 'night) "night"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'night)))
        ("t o" (ivy-read "Load custom theme: "
                         (mapcar #'symbol-name
                                 (custom-available-themes))
                         :predicate (lambda (candidate)
                                      (string-prefix-p "doom-" candidate))
                         :action #'counsel-load-theme-action
                         :caller 'counsel-load-theme)
         "others"))
       "Package Archive"
       (("p m" (progn (setq centaur-package-archives 'melpa)
                      (set-package-archives centaur-package-archives))
         "melpa" :toggle (eq centaur-package-archives 'melpa))
        ("p i" (progn (setq centaur-package-archives 'melpa-mirror)
                      (set-package-archives centaur-package-archives))
         "melpa mirror" :toggle (eq centaur-package-archives 'melpa-mirror))
        ("p c" (progn (setq centaur-package-archives 'emacs-china)
                      (set-package-archives centaur-package-archives))
         "emacs china" :toggle (eq centaur-package-archives 'emacs-china))
        ("p n" (progn (setq centaur-package-archives 'netease)
                      (set-package-archives centaur-package-archives))
         "netease" :toggle (eq centaur-package-archives 'netease))
        ("p t" (progn (setq centaur-package-archives 'tencent)
                      (set-package-archives centaur-package-archives))
         "tencent" :toggle (eq centaur-package-archives 'tencent))
        ("p u" (progn (setq centaur-package-archives 'tuna)
                      (set-package-archives centaur-package-archives))
         "tuna" :toggle (eq centaur-package-archives 'tuna)))))))

(use-package lsp-ui
  :ensure t
  :custom-face
  (lsp-ui-sideline-code-action ((t (:inherit warning))))
  :pretty-hydra
  ((:title (pretty-hydra-title "LSP UI" 'faicon "rocket")
  	   :color amaranth :quit-key "q")
   ("Doc"
    (("d e" (lsp-ui-doc-enable (not lsp-ui-doc-mode))
      "enable" :toggle lsp-ui-doc-mode)
     ("d s" (setq lsp-ui-doc-include-signature (not lsp-ui-doc-include-signature))
      "signature" :toggle lsp-ui-doc-include-signature)
     ("d t" (setq lsp-ui-doc-position 'top)
      "top" :toggle (eq lsp-ui-doc-position 'top))
     ("d b" (setq lsp-ui-doc-position 'bottom)
      "bottom" :toggle (eq lsp-ui-doc-position 'bottom))
     ("d p" (setq lsp-ui-doc-position 'at-point)
      "at point" :toggle (eq lsp-ui-doc-position 'at-point))
     ("d f" (setq lsp-ui-doc-alignment 'frame)
      "align frame" :toggle (eq lsp-ui-doc-alignment 'frame))
     ("d w" (setq lsp-ui-doc-alignment 'window)
      "align window" :toggle (eq lsp-ui-doc-alignment 'window)))
    "Sideline"
    (("s e" (lsp-ui-sideline-enable (not lsp-ui-sideline-mode))
      "enable" :toggle lsp-ui-sideline-mode)
     ("s h" (setq lsp-ui-sideline-show-hover (not lsp-ui-sideline-show-hover))
      "hover" :toggle lsp-ui-sideline-show-hover)
     ("s d" (setq lsp-ui-sideline-show-diagnostics (not lsp-ui-sideline-show-diagnostics))
      "diagnostics" :toggle lsp-ui-sideline-show-diagnostics)
     ("s s" (setq lsp-ui-sideline-show-symbol (not lsp-ui-sideline-show-symbol))
      "symbol" :toggle lsp-ui-sideline-show-symbol)
     ("s c" (setq lsp-ui-sideline-show-code-actions (not lsp-ui-sideline-show-code-actions))
      "code actions" :toggle lsp-ui-sideline-show-code-actions)
     ("s i" (setq lsp-ui-sideline-ignore-duplicate (not lsp-ui-sideline-ignore-duplicate))
      "ignore duplicate" :toggle lsp-ui-sideline-ignore-duplicate))
    "Action"
    (("h" backward-char "←")
     ("j" next-line "↓")
     ("k" previous-line "↑")
     ("l" forward-char "→")
     ("C-a" mwim-beginning-of-code-or-line nil)
     ("C-e" mwim-end-of-code-or-line nil)
     ("C-b" backward-char nil)
     ("C-n" next-line nil)
     ("C-p" previous-line nil)
     ("C-f" forward-char nil)
     ("M-b" backward-word nil)
     ("M-f" forward-word nil)
     ("c" lsp-ui-sideline-apply-code-actions "apply code actions"))))
  :bind (("C-c u" . lsp-ui-imenu)
         :map lsp-ui-mode-map
         ("M-<f6>" . lsp-ui-hydra/body)
         ("M-RET" . lsp-ui-sideline-apply-code-actions))
  :hook (lsp-mode . lsp-ui-mode)
  :init (setq lsp-ui-doc-enable t
              lsp-ui-doc-use-webkit nil
              lsp-ui-doc-delay 0.2
              lsp-ui-doc-include-signature t
              lsp-ui-doc-position 'top
              lsp-ui-doc-border (face-foreground 'default)
              lsp-eldoc-enable-hover nil ; Disable eldoc displays in minibuffer

              lsp-ui-sideline-enable t
              lsp-ui-sideline-show-hover nil
              lsp-ui-sideline-show-diagnostics nil
              lsp-ui-sideline-show-code-actions t
              lsp-ui-sideline-ignore-duplicate t

              lsp-ui-imenu-enable t
              lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                                    ,(face-foreground 'font-lock-string-face)
                                    ,(face-foreground 'font-lock-constant-face)
                                    ,(face-foreground 'font-lock-variable-name-face)))
  (evil-define-key 'normal lsp-ui-imenu-mode-map (kbd "q") 'lsp-ui-imenu--kill)
  (evil-define-key 'normal lsp-ui-imenu-mode-map (kbd "J") 'lsp-ui-imenu--next-kind)
  (evil-define-key 'normal lsp-ui-imenu-mode-map (kbd "K") 'lsp-ui-imenu--prev-kind)
  (evil-define-key 'normal lsp-ui-imenu-mode-map (kbd "<return>") 'lsp-ui-imenu--visit)
  (evil-define-key 'normal lsp-ui-imenu-mode-map (kbd "d") 'lsp-ui-imenu--view)
  :config
  (add-to-list 'lsp-ui-doc-frame-parameters '(right-fringe . 8))

  ;; `C-g'to close doc
  (advice-add #'keyboard-quit :before #'lsp-ui-doc-hide)

  ;; Reset `lsp-ui-doc-background' after loading theme
  (add-hook 'after-load-theme-hook
            (lambda ()
              (setq lsp-ui-doc-border (face-foreground 'default))
              (set-face-background 'lsp-ui-doc-background
                                   (face-background 'tooltip)))))

;; Ivy integration
(use-package lsp-ivy
  :ensure t
  :after lsp-mode
  :bind (:map lsp-mode-map
	      ([remap xref-find-apropos] . lsp-ivy-workspace-symbol)
	      ("C-s-." . lsp-ivy-global-workspace-symbol)))

;; Origami integration
(use-package lsp-origami
  :ensure t
  :after lsp-mode
  :hook (origami-mode . lsp-origami-mode))

;; `lsp-mode' and `treemacs' integration
(when (>= emacs-major-version 25)
  (use-package lsp-treemacs
    :ensure t
    :after lsp-mode
    :bind (:map lsp-mode-map
		("C-<f8>" . lsp-treemacs-errors-list)
		("M-<f8>" . lsp-treemacs-symbols)
		("s-<f8>" . lsp-treemacs-java-deps-list))
    :config
    (with-eval-after-load 'ace-window
      (when (boundp 'aw-ignored-buffers)
        (push 'lsp-treemacs-symbols-mode aw-ignored-buffers)
        (push 'lsp-treemacs-java-deps-mode aw-ignored-buffers)))

    (with-no-warnings
      (when (require 'all-the-icons nil t)
        (treemacs-create-theme "petmacs-colors"
			       :extends "doom-colors"
			       :config
			       (progn
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "repo" :height 1.0 :v-adjust -0.1 :face 'all-the-icons-blue))
				  :extensions (root))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "tag" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-lblue))
				  :extensions (boolean-data))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "settings_input_component" :height 0.95 :v-adjust -0.15 :face 'all-the-icons-orange))
				  :extensions (class))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "palette" :height 0.95 :v-adjust -0.15))
				  :extensions (color-palette))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "square-o" :height 0.95 :v-adjust -0.05))
				  :extensions (constant))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "file-text-o" :height 0.95 :v-adjust -0.05))
				  :extensions (document))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "storage" :height 0.95 :v-adjust -0.15 :face 'all-the-icons-orange))
				  :extensions (enumerator))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "format_align_right" :height 0.95 :v-adjust -0.15 :face 'all-the-icons-lblue))
				  :extensions (enumitem))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "bolt" :height 0.95 :v-adjust -0.05 :face 'all-the-icons-orange))
				  :extensions (event))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "tag" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-lblue))
				  :extensions (field))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "search" :height 0.95 :v-adjust -0.05))
				  :extensions (indexer))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "filter_center_focus" :height 0.95 :v-adjust -0.15))
				  :extensions (intellisense-keyword))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "share" :height 0.95 :v-adjust -0.15 :face 'all-the-icons-lblue))
				  :extensions (interface))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "tag" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-lblue))
				  :extensions (localvariable))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "cube" :height 0.95 :v-adjust -0.05 :face 'all-the-icons-purple))
				  :extensions (method))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "view_module" :height 0.95 :v-adjust -0.15 :face 'all-the-icons-lblue))
				  :extensions (namespace))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "format_list_numbered" :height 0.95 :v-adjust -0.15))
				  :extensions (numeric))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "control_point" :height 0.95 :v-adjust -0.2))
				  :extensions (operator))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "wrench" :height 0.8 :v-adjust -0.05))
				  :extensions (property))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "format_align_center" :height 0.95 :v-adjust -0.15))
				  :extensions (snippet))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "text-width" :height 0.9 :v-adjust -0.05))
				  :extensions (string))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "settings_input_component" :height 0.9 :v-adjust -0.15 :face 'all-the-icons-orange))
				  :extensions (structure))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "format_align_center" :height 0.95 :v-adjust -0.15))
				  :extensions (template))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "chevron-right" :height 0.75 :v-adjust 0.1 :face 'font-lock-doc-face))
				  :extensions (collapsed) :fallback "+")
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "chevron-down" :height 0.75 :v-adjust 0.1 :face 'font-lock-doc-face))
				  :extensions (expanded) :fallback "-")
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-binary" :height 0.9  :v-adjust 0.0 :face 'font-lock-doc-face))
				  :extensions (classfile))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'all-the-icons-blue))
				  :extensions (default-folder-opened))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-blue))
				  :extensions (default-folder))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'all-the-icons-green))
				  :extensions (default-root-folder-opened))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-green))
				  :extensions (default-root-folder))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-binary" :height 0.9 :v-adjust 0.0 :face 'font-lock-doc-face))
				  :extensions ("class"))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-zip" :height 0.9 :v-adjust 0.0 :face 'font-lock-doc-face))
				  :extensions (file-type-jar))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (folder-open))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'font-lock-doc-face))
				  :extensions (folder))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'all-the-icons-orange))
				  :extensions (folder-type-component-opened))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-orange))
				  :extensions (folder-type-component))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'all-the-icons-green))
				  :extensions (folder-type-library-opened))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-green))
				  :extensions (folder-type-library))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'all-the-icons-pink))
				  :extensions (folder-type-maven-opened))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-pink))
				  :extensions (folder-type-maven))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :height 0.9 :v-adjust -0.05 :face 'font-lock-type-face))
				  :extensions (folder-type-package-opened))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'font-lock-type-face))
				  :extensions (folder-type-package))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "plus" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (icon-create))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "list" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (icon-flat))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-material "share" :height 0.95 :v-adjust -0.2 :face 'all-the-icons-lblue))
				  :extensions (icon-hierarchical))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "link" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (icon-link))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "refresh" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (icon-refresh))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "chain-broken" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (icon-unlink))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-alltheicon "java" :height 1.0 :v-adjust 0.0 :face 'all-the-icons-orange))
				  :extensions (jar))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "book" :height 0.95 :v-adjust -0.05 :face 'all-the-icons-green))
				  :extensions (library))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "folder-open" :face 'all-the-icons-lblue))
				  :extensions (packagefolder-open))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "file-directory" :height 0.9 :v-adjust 0.0 :face 'all-the-icons-lblue))
				  :extensions (packagefolder))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-faicon "archive" :height 0.9 :v-adjust -0.05 :face 'font-lock-doc-face))
				  :extensions (package))
				 (treemacs-create-icon
				  :icon (format "%s " (all-the-icons-octicon "repo" :height 1.0 :v-adjust -0.1 :face 'all-the-icons-blue))
				  :extensions (java-project))))

        (setq lsp-treemacs-theme "petmacs-colors")))))

;; Enable LSP in org babel
;; https://github.com/emacs-lsp/lsp-mode/issues/377
(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (user-error "LSP:: specify `:file' property to enable"))

           (setq buffer-file-name file-name)
	   (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            "Enable lsp in the buffer of org source block (%s).")

       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))

(defvar org-babel-lang-list
  '("go" "python" "ipython" "ruby" "js" "css" "sass" "C" "rust" "java"))
(add-to-list 'org-babel-lang-list (if (>= emacs-major-version 26) "shell" "sh"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

(provide 'init-lsp)
(message "init-lsp loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp.el ends here
