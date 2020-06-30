;;; init-ui.el --- default user interface!!          -*- lexical-binding: t; -*-

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


;;; Code:

(mark-time-here)

;; hide menu-bar, tool-bar, scroll-bar and open with global line number mode
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-linum-mode -1)
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
(electric-pair-mode 1)
(setq-default make-backup-files nil)

(use-package recentf
  :ensure nil
  :config
  (recentf-mode 1))

;; forbid emacs startup screen and make full screen default
(setq inhibit-splash-screen t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(defun make-full-screen()
  "make full screen"
  (modify-frame-parameters nil `((fullscreen . fullboth) (maximized . fullscreen))))
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
;; (add-hook 'focus-in-hook 'make-full-screen) ;make full screen even when server killed frame
(add-hook 'after-focus-change-function 'make-full-screen) ;make full screen even when server killed frame

;; display time
(display-time-mode t) 
;; (setq display-time-24hr-format t) ;; void variable?
(setq display-time-day-and-date t)

;; switch some words to icons, like folder etc.
(use-package font-lock+
  :ensure nil
  :quelpa
  (font-lock+
   :repo "emacsmirror/font-lock-plus"
   :fetcher github))

(use-package doom-modeline
  :ensure t
  :hook ((after-init . doom-modeline-mode)
         (doom-modeline-mode . setup-custom-doom-modeline))
  :custom-face
  (doom-modeline-buffer-file ((t (:inherit font-lock-string-face :weight bold))))
  :config
  (progn
    (setq
     find-file-visit-truename t  ; display the real names for symlink files
     doom-modeline-height 10
     doom-modeline-lsp nil
     doom-modeline-persp-name nil
     doom-modeline-github nil
     ;; doom-modeline-buffer-file-name-style 'truncate-with-project ;cause stuck
     doom-modeline-buffer-file-name-style 'file-name
     doom-modeline-major-mode-color-icon t
     doom-modeline-enable-word-count t
     doom-modeline-minor-modes nil
     doom-modeline-env-version t
     doom-modeline-env-enable-python t)

    (doom-modeline-def-segment my-python-venv
      "The current python virtual environment state."
      (when (eq major-mode 'python-mode)
	(if (eq python-shell-virtualenv-root nil)
	    ""
	  (propertize
	   ;; (let ((base-dir-name (file-name-nondirectory (substring python-shell-virtualenv-root 0 -1))))
	   (let ((base-dir-name (file-name-nondirectory python-shell-virtualenv-root)))
	     (if (< 10 (length base-dir-name))
		 (format " (%s..)" (substring base-dir-name 0 8))
	       (format " (%s)" base-dir-name)))
	   'face (if (doom-modeline--active) 'doom-modeline-buffer-major-mode)))))

    (doom-modeline-def-modeline 'my-modeline-layout
      ;; '(bar workspace-name window-number evil-state god-state ryo-modal xah-fly-keys matches buffer-info remote-host buffer-position parrot selection-info)
      '(bar workspace-name window-number modals matches buffer-info remote-host buffer-position word-count parrot selection-info)
      ;; '(misc-info persp-name lsp irc mu4e github debug minor-modes input-method buffer-encoding my-python-venv process vcs checker)
      '(objed-state misc-info persp-name battery grip irc mu4e gnus github debug repl input-method indent-info buffer-encoding my-python-venv process vcs checker))

    (defun setup-custom-doom-modeline ()
      (doom-modeline-set-modeline 'my-modeline-layout 'default))))

;; A minor-mode menu for mode-line
(when (>= emacs-major-version 25)
  (use-package minions
    :ensure t
    :hook (doom-modeline-mode . minions-mode)))

(use-package doom-themes
  :ensure t
  :defer nil
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :config
  (progn
    ;; enable custom treemacs themes
    ;; (doom-themes-treemacs-config)
    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config)))

(use-package spacemacs-theme
  :ensure t)

(load-theme 'spacemacs-dark t)

(use-package display-line-numbers-mode
  :ensure nil
  :init
  (setq-default display-line-numbers-type 'relative)
  (global-display-line-numbers-mode 1))

;; Highlight current line number
(use-package hlinum
  :ensure t
  :defines linum-highlight-in-all-buffersp
  :hook (global-linum-mode . hlinum-activate)
  :init
  (setq linum-highlight-in-all-buffersp t)
  (custom-set-faces
   `(linum-highlight-face
     ((t (:inherit 'default :background ,(face-background 'default) :foreground ,(face-foreground 'default)))))))

;; (use-package vim-empty-lines-mode	;TODO cause conflict with shell mode
;;   :ensure t
;;   :hook ((eshell-mode . (lambda () (vim-empty-lines-mode -1))))
;;   :init
;;   (global-vim-empty-lines-mode))

(use-package hide-mode-line		;hide modeline in specified mode when not needed
  :ensure t
  :hook (((completion-list-mode
           completion-in-region-mode
           lsp-ui-imenu-mode
	   imenu-list-minor-mode
           neotree-mode
           treemacs-mode)
          . hide-mode-line-mode)))

(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f2>") 'open-init-file)

(provide 'init-ui)
(message "init-ui loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-ui.el ends here
