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

(defun petmacs/pyenv-executable-find (command)
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

(defun petmacs/python-execute-file (arg)
  "Execute a python script in a shell."
  (interactive "P")
  ;; set compile command to buffer-file-name
  ;; universal argument put compile buffer in comint mode
  (let ((universal-argument t)
        (compile-command (format "%s %s"
                                 (petmacs/pyenv-executable-find python-shell-interpreter)
                                 (shell-quote-argument (file-name-nondirectory buffer-file-name)))))
    (if arg
        (call-interactively 'compile)
      (compile compile-command t)
      (with-current-buffer (get-buffer "*compilation*")
        (inferior-python-mode)))))

(defun petmacs/python-execute-file-focus (arg)
  "Execute a python script in a shell and switch to the shell buffer in
 `insert state'."
  (interactive "P")
  (petmacs/python-execute-file arg)
  (switch-to-buffer-other-window "*compilation*")
  (end-of-buffer)
  (evil-insert-state))

(defun petmacs/python-start-or-switch-repl ()
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

(defun petmacs/error-delegate ()
  "Decide which error API to delegate to.

Delegates to flycheck if it is enabled and the next-error buffer
is not visible. Otherwise delegates to regular Emacs next-error."
  (if (and (bound-and-true-p flycheck-mode)
           (let ((buf (ignore-errors (next-error-find-buffer))))
             (not (and buf (get-buffer-window buf)))))
      'flycheck
    'emacs))

(defun petmacs/next-error (&optional n reset)
  "Dispatch to flycheck or standard emacs error."
  (interactive "P")
  (let ((sys (petmacs/error-delegate)))
    (cond
     ((eq 'flycheck sys) (call-interactively 'flycheck-next-error))
     ((eq 'emacs sys) (call-interactively 'next-error)))))

(defun petmacs/previous-error (&optional n reset)
  "Dispatch to flycheck or standard emacs error."
  (interactive "P")
  (let ((sys (petmacs/error-delegate)))
    (cond
     ((eq 'flycheck sys) (call-interactively 'flycheck-previous-error))
     ((eq 'emacs sys) (call-interactively 'previous-error)))))


(defun petmacs/treemacs-project-toggle ()
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


(defun petmacs/toggle-flycheck-error-list ()
  "Toggle flycheck's error list window.
If the error list is visible, hide it.  Otherwise, show it."
  (interactive)
  (-if-let (window (flycheck-get-error-list-window))
      (quit-window nil window)
    (flycheck-list-errors)))

;;;; python

(defun petmacs/quit-subjob ()
  "quit runing job in python buffer"
  (interactive)
  (save-excursion
    (setq petmacs--current-buffer-name (buffer-name))
    (previous-buffer)

    (setq petmacs--previous-buffer-name (buffer-name))
    (switch-to-buffer "*compilation*")
    (comint-quit-subjob)
    (switch-to-buffer petmacs--previous-buffer-name)
    (switch-to-buffer petmacs--current-buffer-name)
    (set-language-environment petmacs-default-language-env)))

(defun petmacs/windows-python-execute-file (arg)
  "execute python file & produce correct chinese outputs"
  (interactive "P")
  (set-language-environment 'Chinese-GB18030)
  (save-some-buffers t)
  (petmacs/python-execute-file arg)
  (set-language-environment petmacs-default-language-env))

(defun petmacs/windows-python-execute-file-focus (arg)
  "EXECUTE PYTHON FILE & SWITCH TO THE SHELL BUFFER IN INSERT STATE & PRODUCE CORRECT CHINESE OUTPUTS"
  (interactive "P")
  (set-language-environment 'Chinese-GB18030)
  (save-some-buffers t)
  (petmacs/python-execute-file-focus arg)
  (set-language-environment petmacs-default-language-env))

(defun petmacs/windows-python-start-or-switch-repl ()
  (interactive)
  (set-language-environment 'Chinese-GB18030)
  (petmacs/python-start-or-switch-repl)
  (other-window -1))

(defun petmacs/python-quit-repl ()
  (interactive)
  (switch-to-buffer "*Python*")
  (comint-quit-subjob)
  (kill-buffer-and-window)
  (set-language-environment petmacs-default-language-env))

(defun petmacs/python-interrupt-repl ()
  (interactive)
  (switch-to-buffer "*Python*")
  (comint-interrupt-subjob)
  (other-window -1))

(defun petmacs/pyvenv-workon ()
  "switch python virtualenvironment and restart anaconda server"
  (interactive)
  (call-interactively 'pyvenv-workon)
  ;; (setq python-shell-virtualenv-path pyvenv-virtual-env)
  (pythonic-activate pyvenv-virtual-env)
  )

(defun petmacs/pyvenv-activate ()
  "switch python virtualenvironment and restart anaconda server"
  (interactive)
  (call-interactively 'pyvenv-activate)
  ;; (setq python-shell-virtualenv-path pyvenv-virtual-env)
  (pythonic-activate pyvenv-virtual-env)
  )

(defun petmacs/pyvenv-deactivate ()
  "deactivate pyvenv & anaconda virtual enironment"
  (interactive)
  (pyvenv-deactivate)
  (pythonic-deactivate))

(defun petmacs/python-highlight-breakpoint ()
  "highlight a break point"
  (interactive)
  (highlight-lines-matching-regexp "^[ ]*import ipdb" 'hi-pink)
  (highlight-lines-matching-regexp "^[ ]*ipdb.set_trace()" 'hi-pink))

(defun petmacs/python-insert-breakpoint ()
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
	(petmacs/python-highlight-breakpoint)))))

(defun petmacs/python-delete-breakpoint ()
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
  (define-key python-mode-map (kbd "C-c C-b") 'petmacs/python-execute-file))

(use-package pyvenv :ensure t)

;; Format using YAPF
;; Install: pip install yapf
(use-package yapfify
  :ensure t
  :diminish yapf-mode
  :hook (python-mode . yapf-mode))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;docstring
(defun chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (let ((s (if (symbolp str) (symbol-name str) str)))
    (replace-regexp-in-string
     "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" s)))
(defun get-function-definition(sentence)
  (if (string-match "def.*(.*):" sentence)
      (match-string 0 sentence)))
(defun get-parameters(sentence)
  (setq y (get-function-definition sentence))
  (if y
      (if (string-match "(.*)" y)
          (match-string 0 y))))
(autoload 'thing-at-point "thingatpt" nil t) ;; build-in librairie
(defun python-insert-docstring()
  (interactive)
  (setq p (get-parameters (thing-at-point 'sentence)))
  (forward-line 1)
  (insert "    \"\"\"\n")
  (insert "\tArgs:\n")
  (setq params (split-string p "[?\,?\(?\)?\ ]"))
  (while params
    (if (/= (length (chomp (car params))) 0)
        (progn
          (insert "        ")
          (insert (chomp (car params)))
          (insert ": \n")))
    (setq params (cdr params)))
  (insert "    Returns:\n    \"\"\"\n"))
(global-set-key (kbd "<f9>") 'python-insert-docstring)

;; TODO need docstring

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;send region to shell
;; (defun sh-send-line-or-region (&optional step)
;;   (interactive ())
;;   (let ((proc (get-process "shell"))
;;         pbuf min max command)
;;     (unless proc
;;       (let ((currbuff (current-buffer)))
;;         (shell)
;;         (switch-to-buffer currbuff)
;;         (setq proc (get-process "shell"))
;;         ))
;;     (setq pbuff (process-buffer proc))
;;     (if (use-region-p)
;;         (setq min (region-beginning)
;;               max (region-end))
;;       (setq min (point-at-bol)
;;             max (point-at-eol)))
;;     (setq command (concat (buffer-substring min max) "\n"))
;;     (with-current-buffer pbuff
;;       (goto-char (process-mark proc))
;;       (insert command)
;;       (move-marker (process-mark proc) (point))
;;       ) ;;pop-to-buffer does not work with save-current-buffer -- bug?
;;     (process-send-string  proc command)
;;     (display-buffer (process-buffer proc) t)
;;     (when step 
;;       (goto-char max)
;;       (next-line))
;;     ))

;; (defun sh-send-line-or-region-and-step ()
;;   (interactive)
;;   (sh-send-line-or-region t))
;; (defun sh-switch-to-process-buffer ()
;;   (interactive)
;;   (pop-to-buffer (process-buffer (get-process "shell")) t))

;; (define-key sh-mode-map [(control ?j)] 'sh-send-line-or-region-and-step)
;; (define-key sh-mode-map [(control ?c) (control ?z)] 'sh-switch-to-process-buffer)

(provide 'init-python)
(message "init-python loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-python.el ends here
