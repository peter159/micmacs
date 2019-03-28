;;; init-shell.el ---                                -*- lexical-binding: t; -*-

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

;; (setq comint-move-point-for-output t) ;; move point to the end of buffer on new output

(setq shell-pop-window-position 'bottom
      shell-pop-window-size     30
      shell-pop-term-shell      'shell-file-name
      shell-pop-full-span       t)

(use-package multi-term :ensure t)
(use-package eshell :ensure nil)

(defun spacemacs//init-eshell ()
  "Stuff to do when enabling eshell."
  (setq pcomplete-cycle-completions nil)
  (if (bound-and-true-p linum-mode) (linum-mode -1))
  (unless shell-enable-smart-eshell
    ;; we don't want auto-jump to prompt when smart eshell is enabled.
    ;; Idea: maybe we could make auto-jump smarter and jump only if
    ;; point is not on a prompt line
    (add-hook 'evil-insert-state-entry-hook
              'spacemacs//eshell-auto-end nil t)
    (add-hook 'evil-hybrid-state-entry-hook
              'spacemacs//eshell-auto-end nil t))
  (when (configuration-layer/package-used-p 'semantic)
    (semantic-mode -1))
  ;; This is an eshell alias
  (defun eshell/clear ()
    (let ((inhibit-read-only t))
      (erase-buffer)))
  ;; This is a key-command
  (defun spacemacs/eshell-clear-keystroke ()
    "Allow for keystrokes to invoke eshell/clear"
    (interactive)
    (eshell/clear)
    (eshell-send-input))
  ;; Caution! this will erase buffer's content at C-l
  (define-key eshell-mode-map (kbd "C-l") 'spacemacs/eshell-clear-keystroke)
  (define-key eshell-mode-map (kbd "C-d") 'eshell-delchar-or-maybe-eof)

  ;; These don't work well in normal state
  ;; due to evil/emacs cursor incompatibility
  (evil-define-key 'insert eshell-mode-map
    (kbd "C-k") 'eshell-previous-matching-input-from-input
    (kbd "C-j") 'eshell-next-matching-input-from-input))

(defun shell/init-eshell ()
  (use-package eshell
    :defer t
    :init
    (progn
      (spacemacs/register-repl 'eshell 'eshell)
      (setq eshell-cmpl-cycle-completions nil
            ;; auto truncate after 20k lines
            eshell-buffer-maximum-lines 20000
            ;; history size
            eshell-history-size 350
            ;; no duplicates in history
            eshell-hist-ignoredups t
            ;; buffer shorthand -> echo foo > #'buffer
            eshell-buffer-shorthand t
            ;; my prompt is easy enough to see
            eshell-highlight-prompt nil
            ;; treat 'echo' like shell echo
            eshell-plain-echo-behavior t
            ;; cache directory
            eshell-directory-name (concat spacemacs-cache-directory "eshell/"))

      (when shell-protect-eshell-prompt
        (add-hook 'eshell-after-prompt-hook 'spacemacs//protect-eshell-prompt))

      (autoload 'eshell-delchar-or-maybe-eof "em-rebind")

      (add-hook 'eshell-mode-hook 'spacemacs//init-eshell)
      (add-hook 'eshell-mode-hook 'spacemacs/disable-hl-line-mode))
    :config
    (progn

      ;; Work around bug in eshell's preoutput-filter code.
      ;; Eshell doesn't call preoutput-filter functions in the context of the eshell
      ;; buffer. This breaks the xterm color filtering when the eshell buffer is updated
      ;; when it's not currently focused.
      ;; To remove if/when fixed upstream.
      (defun eshell-output-filter@spacemacs-with-buffer (fn process string)
        (let ((proc-buf (if process (process-buffer process)
                          (current-buffer))))
          (when proc-buf
            (with-current-buffer proc-buf
              (funcall fn process string)))))
      (advice-add
       #'eshell-output-filter
       :around
       #'eshell-output-filter@spacemacs-with-buffer)

      (require 'esh-opt)

      ;; quick commands
      (defalias 'eshell/e 'find-file-other-window)
      (defalias 'eshell/d 'dired)
      (setenv "PAGER" "cat")

      ;; support `em-smart'
      (when shell-enable-smart-eshell
        (require 'em-smart)
        (setq eshell-where-to-jump 'begin
              eshell-review-quick-commands nil
              eshell-smart-space-goes-to-end t)
        (add-hook 'eshell-mode-hook 'eshell-smart-initialize))

      ;; Visual commands
      (require 'em-term)
      (mapc (lambda (x) (add-to-list 'eshell-visual-commands x))
            '("el" "elinks" "htop" "less" "ssh" "tmux" "top"))

      ;; automatically truncate buffer after output
      (when (boundp 'eshell-output-filter-functions)
        (add-hook 'eshell-output-filter-functions #'eshell-truncate-buffer)))))

(defun open-mintty-terminal ()
  (interactive)
  (progn
    ;; (shell-command "c:/msys64/usr/bin/mintty --window=max /bin/env MSYSTEM=MINGW64 /bin/bash --login -i &")
    ;; (w32-shell-execute "runas" "d:\\msys64\\usr\\bin\\mintty.exe" "/bin/env MSYSTEM=64 CHERE_INVOKING=1 DISABLE_AWESOME_FONT=1 /bin/bash --login -i")
    (w32-shell-execute "runas" "c:\\msys64\\usr\\bin\\mintty.exe" "/bin/env MSYSTEM=64 CHERE_INVOKING=1 /bin/bash --login -i")
    ;; (w32-shell-execute "runas" "d:\\msys64\\usr\\bin\\mintty.exe" "/bin/env MSYSTEM=64 CHERE_INVOKING=1 /bin/bash --login -i") ;home computer
    ;; (w32-send-sys-command)
    (delete-window)))

;; (define-key emacs-lisp-mode-map (kbd "C-S-c") 'open-mintty-terminal)
(define-key global-map (kbd "C-S-c") 'open-mintty-terminal)

(defun my-shell-here()
  "open shell here and automatically close window when quiting the shell"
  (interactive)
  (let ((file-name-directory (buffer-file-name)))
    (call-interactively 'spacemacs/default-pop-shell)
    ;; (other-buffer -1)
    ;; (recenter 11)
    ;; (message "end of line: %s" (window-body-height))
    ))

(defvar shell-default-shell (if (eq window-system 'w32)
                                'shell
			      'ansi-term)
  "Default shell to use in Spacemacs. Possible values are `eshell', `shell',
`term', `ansi-term' and `multi-term'.")

(defun spacemacs/default-pop-shell ()
  "Open the default shell in a popup."
  (interactive)
  (let ((shell (case shell-default-shell
                 ('multi-term 'multiterm)
                 ('shell 'inferior-shell)
                 (t shell-default-shell))))
    (call-interactively (intern (format "spacemacs/shell-pop-%S" shell)))))

(defun inferior-shell (&optional ARG)
  "Wrapper to open shell in current window"
  (interactive)
  (switch-to-buffer "*shell*")
  (shell "*shell*"))

(use-package shell-pop :ensure t)

(defmacro make-shell-pop-command (func &optional shell)
  "Create a function to open a shell via the function FUNC.
SHELL is the SHELL function to use (i.e. when FUNC represents a terminal)."
  (let* ((name (symbol-name func)))
    `(defun ,(intern (concat "spacemacs/shell-pop-" name)) (index)
       ,(format (concat "Toggle a popup window with `%S'.\n"
			"Multiple shells can be opened with a numerical prefix "
			"argument. Using the universal prefix argument will "
			"open the shell in the current buffer instead of a "
			"popup buffer.") func)
       (interactive "P")
       (require 'shell-pop)
       (if (equal '(4) index)
	   ;; no popup
	   (,func ,shell)
	 (shell-pop--set-shell-type
	  'shell-pop-shell-type
	  (backquote (,name
		      ,(concat "*" name "*")
		      (lambda nil (,func ,shell)))))
	 (shell-pop index)
	 (spacemacs/resize-shell-to-desired-width)
	 ;; (recenter (window-body-height)) ; TODO hope to move focus to end of screen, but doesn't work
	 ))))

(make-shell-pop-command eshell)
(make-shell-pop-command term shell-pop-term-shell)
(make-shell-pop-command ansi-term shell-pop-term-shell)
(make-shell-pop-command inferior-shell)
(make-shell-pop-command multiterm)

(defun spacemacs/resize-shell-to-desired-width ()
  (when (and (string= (buffer-name) shell-pop-last-shell-buffer-name)
	     (memq shell-pop-window-position '(left right)))
    (enlarge-window-horizontally (- (/ (* (frame-width) shell-default-width)
				       100)
				    (window-width)))))

(provide 'init-shell)
;;; init-shell.el ends here
