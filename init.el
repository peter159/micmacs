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

;; Speed up startup
(defvar petmacs-gc-cons-threshold (if (display-graphic-p) 8000000 800000)
  "The default value to use for `gc-cons-threshold'. If you experience freezing,
decrease this. If you experience stuttering, increase this.")

(defvar petmacs-gc-cons-upper-limit (if (display-graphic-p) 400000000 100000000)
  "The temporary value for `gc-cons-threshold' to defer it.")

(defvar petmacs-gc-timer (run-with-idle-timer 10 t #'garbage-collect)
  "Run garbarge collection when idle 10s.")

(defvar default-file-name-handler-alist file-name-handler-alist)

;; accpet 1024 * 1024 bytes from subprocess, this way json rpc wont need to split
(setq read-process-output-max (* 1024 1024))

(setq file-name-handler-alist nil)
(setq gc-cons-threshold petmacs-gc-cons-upper-limit)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Restore defalut values after startup."
            (setq file-name-handler-alist default-file-name-handler-alist)
            (setq gc-cons-threshold petmacs-gc-cons-threshold)

            ;; GC automatically while unfocusing the frame
            ;; `focus-out-hook' is obsolete since 27.1
            (if (boundp 'after-focus-change-function)
                (add-function :after after-focus-change-function
			      (lambda ()
				(unless (frame-focus-state)
				  (garbage-collect))))
              (add-hook 'focus-out-hook 'garbage-collect))

            ;; Avoid GCs while using `ivy'/`counsel'/`swiper' and `helm', etc.
            ;; @see http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/
            (defun my-minibuffer-setup-hook ()
              (setq gc-cons-threshold petmacs-gc-cons-upper-limit))

            (defun my-minibuffer-exit-hook ()
              (setq gc-cons-threshold petmacs-gc-cons-threshold))

            (add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
            (add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)))

;; use mirror
(setq package-check-signature nil)
(setq-default package-archives '(;; ("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
				 ;; ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
				 ;; ("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
				 ("gnu" . "http://elpa.emacs-china.org/gnu/")
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
;; (require 'init-lsp-python) ;; this one only let python work
;; (require 'init-lsp)
(require 'init-eglot)
(require 'init-elisp)
(require 'init-c-c++)
(require 'init-java)
(require 'init-python-anaconda) ;; not use lsp but anaconda to work
;; (require 'init-python-lsp) ;; uncomment with `init-lsp' to get python work
;; (require 'init-python-elpy) ;; working with elpy, not really ready
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
