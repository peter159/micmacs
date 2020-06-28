;;; init.el --- MainEntry                            -*- lexical-binding: t; -*-

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

;;; require package manager, config archives source and initialize all
(require 'package)

;; use mirror
(setq package-check-signature nil)
(setq-default package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
				 ("melpa" . "http://elpa.emacs-china.org/melpa/")
				 ("melpa-stable" . "http://elpa.emacs-china.org/melpa-stable/")))

;; Load path
;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
(defun update-load-path (&rest _)
  "Update `load-path'."
  (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
  (push (expand-file-name "lisp" user-emacs-directory) load-path)
  (push (expand-file-name "list/init-shell" user-emacs-directory) load-path))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'."
  (let ((default-directory
	  (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)

(update-load-path)
(add-subdirs-to-load-path)

;; Initialize packages
(package-initialize)

;; ;; Display the total loading time in the minibuffer
(defun display-startup-echo-area-message ()
  "Display startup echo area message."
  (message "Initialized in %s" (emacs-init-time)))

;; (profiler-cpu-start)
;; (profiler-memory-start)

;; requre features from lisp

(require 'init-general-functions)
(require 'init-package-management)
(require 'init-default)
(require 'init-font)
(require 'init-ui)

(require 'init-evil)
(require 'init-company)
(require 'init-dired)
(require 'init-tool)
(require 'init-ivy)
(require 'init-ibuffer)
(require 'init-window)
(require 'init-layout)

(require 'init-highlight)
(require 'init-version-control)
(require 'init-project)
(require 'init-yasnippet)
(require 'init-treemacs)

(require 'init-program-basis)
(require 'init-flycheck)
(require 'init-lsp)
;; (require 'init-eglot)
(require 'init-elisp)
(require 'init-c-c++)
(require 'init-java)
(require 'init-python)
(require 'init-ess)
(require 'init-org)
(require 'init-html)
(require 'init-markdown)
(require 'init-json)
(require 'init-yaml)
(require 'init-sql)

(require 'init-shell)
(require 'init-misc)

(require 'leader-core-functions)
(require 'leader-key-binding)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(package-selected-packages
   '(yasnippet-snippets yapfify yaml-mode winum which-key web-mode virtualenvwrapper vim-empty-lines-mode unicode-fonts treemacs-projectile treemacs-evil toc-org symbol-overlay sqlup-mode sql-indent spacemacs-theme smart-semicolon shell-pop rg restart-emacs ranger rainbow-delimiters quelpa-use-package pyvenv pretty-hydra prettify-utils prettier-js pos-tip popwin persp-mode-projectile-bridge org-preview-html org-pomodoro org-dashboard org-bullets olivetti ob-ipython mvn multi-web-mode multi-term markdown-toc magit-todos lsp-ui lsp-java json-mode ivy-yasnippet ivy-xref ivy-hydra imenu-list hungry-delete hlinum highlight-indent-guides hide-mode-line go-mode gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-gutter fontify-face font-lock+ flycheck flx fill-column-indicator expand-region evil-visualstar evil-surround evil-major-leader evil-magit evil-fringe-mark evil-escape evil-commentary evil-anzu esup ess eshell-z eshell-prompt-extras esh-help emmet-mode elisp-refs electric-spacing electric-operator eglot editorconfig doom-themes doom-modeline diredfl diminish diffview default-text-scale daemons counsel-tramp counsel-projectile company-statistics company-lsp company-box company-anaconda centered-cursor-mode ccls carbon-now-sh browse-at-remote beacon amx all-the-icons-dired aggressive-indent)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c"))))
 '(doom-modeline-buffer-file ((t (:inherit font-lock-string-face :weight bold))))
 '(git-gutter:added ((t (:background "#50fa7b"))))
 '(git-gutter:deleted ((t (:background "#ff79c6"))))
 '(git-gutter:modified ((t (:background "#f1fa8c"))))
 '(hl-todo ((t (:box t :inherit 'hl-todo))))
 '(linum-highlight-face ((t (:inherit 'default :background "#292b2e" :foreground "#b2b2b2"))))
 '(lsp-ui-sideline-code-action ((t (:inherit warning)))))
