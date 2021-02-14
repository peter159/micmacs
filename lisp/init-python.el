;;; init-python.el ---                               -*- lexical-binding: t; -*-

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

;;; python

(defun unicorn/pyenv-executable-find (command)
  "Find executable taking pyenv shims into account.
If the executable is a system executable and not in the same path
as the pyenv version then also return nil. This works around https://github.com/pyenv/pyenv-which-ext
"
  (if (executable-find "pyenv")
      (progn
        (let ((pyenv-string (shell-command-to-string (concat "pyenv which " command)))
              (pyenv-version-names (split-string (string-trim (shell-command-to-string "pyenv version-name")) ":"))
              (executable nil)
              (i 0))
          (if (not (string-match "not found" pyenv-string))
              (while (and (not executable)
                          (< i (length pyenv-version-names)))
                (if (string-match (elt pyenv-version-names i) (string-trim pyenv-string))
                    (setq executable (string-trim pyenv-string)))
                (if (string-match (elt pyenv-version-names i) "system")
                    (setq executable (string-trim (executable-find command))))
                (setq i (1+ i))))
          executable))
    (executable-find command)))

(defun unicorn/python-execute-file (arg)
  "Execute a python script in a shell."
  (interactive "P")
  ;; set compile command to buffer-file-name
  ;; universal argument put compile buffer in comint mode
  (let ((universal-argument t)
        (compile-command (format "%s %s"
                                 (unicorn/pyenv-executable-find python-shell-interpreter)
                                 (shell-quote-argument (file-name-nondirectory buffer-file-name)))))
    (if arg
        (call-interactively 'compile)
      (compile compile-command t)
      (with-current-buffer (get-buffer "*compilation*")
        (inferior-python-mode)))))

(defun unicorn/python-execute-file-focus (arg)
  "Execute a python script in a shell and switch to the shell buffer in
 `insert state'."
  (interactive "P")
  (unicorn/python-execute-file arg)
  (switch-to-buffer-other-window "*compilation*")
  (end-of-buffer)
  (evil-insert-state))

(defun unicorn/python-start-or-switch-repl ()
  "Start and/or switch to the REPL."
  (interactive)
  (let ((shell-process
         (or (python-shell-get-process)
             ;; `run-python' has different return values and different
             ;; errors in different emacs versions. In 24.4, it throws an
             ;; error when the process didn't start, but in 25.1 it
             ;; doesn't throw an error, so we demote errors here and
             ;; check the process later
             (with-demoted-errors "Error: %S"
               ;; in Emacs 24.5 and 24.4, `run-python' doesn't return the
               ;; shell process
               (call-interactively #'run-python)
               (python-shell-get-process)))))
    (unless shell-process
      (error "Failed to start python shell properly"))
    (pop-to-buffer (process-buffer shell-process))
    (evil-insert-state)))

(defun unicorn/error-delegate ()
  "Decide which error API to delegate to.

Delegates to flycheck if it is enabled and the next-error buffer
is not visible. Otherwise delegates to regular Emacs next-error."
  (if (and (bound-and-true-p flycheck-mode)
           (let ((buf (ignore-errors (next-error-find-buffer))))
             (not (and buf (get-buffer-window buf)))))
      'flycheck
    'emacs))

(defun unicorn/next-error (&optional n reset)
  "Dispatch to flycheck or standard emacs error."
  (interactive "P")
  (let ((sys (unicorn/error-delegate)))
    (cond
     ((eq 'flycheck sys) (call-interactively 'flycheck-next-error))
     ((eq 'emacs sys) (call-interactively 'next-error)))))

(defun unicorn/previous-error (&optional n reset)
  "Dispatch to flycheck or standard emacs error."
  (interactive "P")
  (let ((sys (unicorn/error-delegate)))
    (cond
     ((eq 'flycheck sys) (call-interactively 'flycheck-previous-error))
     ((eq 'emacs sys) (call-interactively 'previous-error)))))


(defun unicorn/treemacs-project-toggle ()
  "Toggle and add the current project to treemacs if not already added."
  (interactive)
  (if (eq (treemacs-current-visibility) 'visible)
      (delete-window (treemacs-get-local-window))
    (let ((path (projectile-project-root))
          (name (projectile-project-name)))
      (unless (treemacs-current-workspace)
        (treemacs--find-workspace))
      (treemacs-do-add-project-to-workspace path name)
      (treemacs-select-window))))


(defun unicorn/toggle-flycheck-error-list ()
  "Toggle flycheck's error list window.
If the error list is visible, hide it.  Otherwise, show it."
  (interactive)
  (-if-let (window (flycheck-get-error-list-window))
      (quit-window nil window)
    (flycheck-list-errors)))

;;;; python

(defun unicorn/quit-subjob ()
  "quit runing job in python buffer"
  (interactive)
  (save-excursion
    (setq unicorn--current-buffer-name (buffer-name))
    (previous-buffer)

    (setq unicorn--previous-buffer-name (buffer-name))
    (switch-to-buffer "*compilation*")
    (comint-quit-subjob)
    (switch-to-buffer unicorn--previous-buffer-name)
    (switch-to-buffer unicorn--current-buffer-name)
    (set-language-environment unicorn-default-language-env)))

(defun unicorn/windows-python-execute-file (arg)
  "execute python file & produce correct chinese outputs"
  (interactive "P")
  (set-language-environment 'Chinese-GB18030)
  (save-some-buffers t)
  (unicorn/python-execute-file arg)
  (set-language-environment unicorn-default-language-env))

(defun unicorn/windows-python-execute-file-focus (arg)
  "EXECUTE PYTHON FILE & SWITCH TO THE SHELL BUFFER IN INSERT STATE & PRODUCE CORRECT CHINESE OUTPUTS"
  (interactive "P")
  (set-language-environment 'Chinese-GB18030)
  (save-some-buffers t)
  (unicorn/python-execute-file-focus arg)
  (set-language-environment unicorn-default-language-env))

(defun unicorn/windows-python-start-or-switch-repl ()
  (interactive)
  (set-language-environment 'Chinese-GB18030)
  (unicorn/python-start-or-switch-repl)
  (other-window -1))

(defun unicorn/python-quit-repl ()
  (interactive)
  (switch-to-buffer "*Python*")
  (comint-quit-subjob)
  (kill-buffer-and-window)
  (set-language-environment unicorn-default-language-env))

(defun unicorn/python-interrupt-repl ()
  (interactive)
  (switch-to-buffer "*Python*")
  (comint-interrupt-subjob)
  (other-window -1))

(defun unicorn/pyvenv-workon ()
  "switch python virtualenvironment and restart anaconda server"
  (interactive)
  (call-interactively 'pyvenv-workon)
  ;; (setq python-shell-virtualenv-path pyvenv-virtual-env)
  (pythonic-activate pyvenv-virtual-env)
  )

(defun unicorn/pyvenv-activate ()
  "switch python virtualenvironment and restart anaconda server"
  (interactive)
  (call-interactively 'pyvenv-activate)
  ;; (setq python-shell-virtualenv-path pyvenv-virtual-env)
  (pythonic-activate pyvenv-virtual-env)
  )

(defun unicorn/pyvenv-deactivate ()
  "deactivate pyvenv & anaconda virtual enironment"
  (interactive)
  (pyvenv-deactivate)
  (pythonic-deactivate))

(defun unicorn/python-highlight-breakpoint ()
  "highlight a break point"
  (interactive)
  (highlight-lines-matching-regexp "^[ ]*import ipdb" 'hi-pink)
  (highlight-lines-matching-regexp "^[ ]*ipdb.set_trace()" 'hi-pink))

(defun unicorn/python-insert-breakpoint ()
  "Add a break point, highlight it."
  (interactive)
  (let ((trace  "import ipdb; ipdb.set_trace() # XXX BREAKPOINT")
	(line (thing-at-point 'line)))
    (if (and line (string-match trace line))
	(kill-whole-line)
      (progn
	(back-to-indentation)
	(insert trace)
	(insert "\n")
	(python-indent-line)
	(unicorn/python-highlight-breakpoint)))))

(defun unicorn/python-delete-breakpoint ()
  "delete break point"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (flush-lines "^[ ]*import ipdb")
    (flush-lines "^[ ]*ipdb.set_trace()")))

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(use-package python
  :ensure nil
  :defines gud-pdb-command-name pdb-path
  :config
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)

  (add-hook 'inferior-python-mode-hook
            (lambda ()
              ;; (bind-key "C-c C-z" #'kill-buffer-and-window inferior-python-mode-map)
              (process-query-on-exit-flag (get-process "Python"))))
  (define-key python-mode-map (kbd "C-c C-b") 'unicorn/python-execute-file))

(use-package pyvenv :ensure t)

;; ;; Format using YAPF
;; ;; Install: pip install yapf
;; (use-package yapfify
;;   :ensure t
;;   :diminish yapf-mode
;;   :hook (python-mode . yapf-mode))

(use-package anaconda-mode
  :ensure t
  :defines anaconda-mode-localhost-address
  :diminish anaconda-mode
  :hook ((python-mode . anaconda-mode)
         (python-mode . anaconda-eldoc-mode))
  :config
  ;; WORKAROUND: https://github.com/proofit404/anaconda-mode#faq
  ;; (when (eq system-type 'darwin)
  ;;   (setq anaconda-mode-localhost-address "localhost"))
  (setq anaconda-mode-localhost-address "localhost"))

(use-package company-anaconda
  :ensure t
  :after company
  :defines company-backends
  :init (cl-pushnew 'company-anaconda company-backends)
  :config
  (evil-define-minor-mode-key 'normal 'anaconda-mode (kbd "C-M-i") 'company-anaconda)
  (evil-define-minor-mode-key 'insert 'anaconda-mode (kbd "C-M-i") 'company-anaconda))

(use-package virtualenvwrapper :ensure t)

(provide 'init-python)
(message "init-python loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-python.el ends here
