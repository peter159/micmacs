;;; init-default.el ---                              -*- lexical-binding: t; -*-

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

(eval-when-compile
  (require 'init-const))

;; ;; use exec-path-from-shell in linux / mac
;; (when (or (eq system-type 'gnu/linux) (eq system-type 'darwin))
;;   (use-package exec-path-from-shell
;;     :init
;;     (setq exec-path-from-shell-check-startup-files nil)
;;     (setq exec-path-from-shell-variables '("PATH" "MANPATH" "PYTHONPATH" "GOPATH"))
;;     (setq exec-path-from-shell-arguments '("-l"))
;;     (exec-path-from-shell-initialize)))

;; ;; maximize emacs after initialization
;; (toggle-frame-maximized)

;; ;; use UTF-8 as default encoding
;; (set-language-environment petmacs-default-language-env)
;; (set-default-coding-systems petmacs-default-coding-env)

;; (fset 'yes-or-no-p 'y-or-n-p)
;; (setq inhibit-startup-screen t)
;; (setq visible-bell t)

(setq delete-by-moving-to-trash t)         ; Deleting files go to OS's trash folder
(setq make-backup-files nil)               ; Forbide to make backup files
(setq auto-save-default nil)               ; Disable auto save
(setq create-lockfiles nil)                ; Disable lock files .#filename

(setq-default major-mode 'text-mode)

(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;; Line and Column
(setq-default fill-column 80)
;; (tool-bar-mode -1)
;; (menu-bar-mode -1)
(setq column-number-mode t)
(setq line-number-mode t)

;; Don't open a file in a new frame
(when (boundp 'ns-pop-up-frames)
  (setq ns-pop-up-frames nil))

;; Don't use GTK+ tooltip
(when (boundp 'x-gtk-use-system-tooltips)
  (setq x-gtk-use-system-tooltips nil))

;; (setq recenter-positions '(middle top bottom))

;; Mouse & Smooth Scroll
;; Scroll one line at a time (less "jumpy" than defaults)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;; (setq mouse-wheel-progressive-speed nil)
;; (setq scroll-step 1
;;       scroll-margin 0
;;       scroll-conservatively 100000)

;; Basic modes

;; Start server
(use-package server
  :ensure nil
  :config
  (defun server-ensure-safe-dir (dir) "Noop" t)
  (server-start)
  :hook (after-init . server-mode))

;; History
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

;; Automatically reload files was modified by external program
(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

;; Pass a URL to a WWW browser
(use-package browse-url
  :ensure nil
  :defines dired-mode-map
  :bind (("C-c C-z ." . browse-url-at-point)
         ("C-c C-z b" . browse-url-of-buffer)
         ("C-c C-z r" . browse-url-of-region)
         ("C-c C-z u" . browse-url)
         ("C-c C-z v" . browse-url-of-file))
  :init
  (with-eval-after-load 'dired
    (bind-key "C-c C-z f" #'browse-url-of-file dired-mode-map)))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :init
  (setq recentf-max-saved-items 200)
  (setq recentf-exclude '((expand-file-name package-user-dir)
                          ".cache"
                          ".cask"
                          ".elfeed"
                          "bookmarks"
                          "cache"
                          "ido.*"
                          "persp-confs"
                          "recentf"
                          "url"
                          "COMMIT_EDITMSG\\'")))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
					      global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300))

;; Show number of matches in mode-line while searching
(use-package anzu
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (after-init . global-anzu-mode))

;; A comprehensive visual interface to diff & patch
(use-package ediff
  :ensure nil
  :hook(;; show org ediffs unfolded
        (ediff-prepare-buffer . outline-show-all)
        ;; restore window layout when done
        (ediff-quit . winner-undo))
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-merge-split-window-function 'split-window-horizontally))

;; Automatic parenthesis pairing
(use-package elec-pair
  :ensure nil
  :hook (after-init . electric-pair-mode)
  :init (setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit))

;; Make bindings that stick around
(use-package hydra :ensure t)

;; Treat undo history as a tree
;; (use-package undo-tree
;;   :ensure nil
;;   :diminish
;;   :quelpa
;;   (undo-tree
;;    :repo "apchamberlain/undo-tree"
;;    :fetcher github)
;;   :hook (after-init . global-undo-tree-mode))

(use-package undo-tree
  :ensure t
  :diminish
  :hook (after-init . global-undo-tree-mode))

;; Handling capitalized subwords in a nomenclature
(use-package subword
  :ensure nil
  :diminish
  :hook ((prog-mode . subword-mode)
         (minibuffer-setup . subword-mode)))

(provide 'init-default)
(message "init-default loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-default.el ends here
