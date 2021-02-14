;;; init-lsp-python.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2020  linyi

;; Author: linyi <linyi@ubu-born-0>
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

;; Python Mode
;; Install:
;;   pip install yapf
;;   pip install isort
;;   pip install autoflake

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

(defun unicorn/python-highlight-breakpoint ()
  "highlight a break point"
  (interactive)
  (highlight-lines-matching-regexp "^[ ]*import ipdb" 'hi-salmon)
  (highlight-lines-matching-regexp "^[ ]*ipdb.set_trace()" 'hi-salmon))

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

(use-package python
  :ensure nil
  :init
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)
  (setq python-indent-guess-indent-offset-verbose nil)
  :hook
  ((python-mode . (lambda ()
		    (setq-local flycheck-checkers '(python-pylint))
		    (pyvenv-mode 1)))
   (inferior-python-mode . (lambda ()
			     (process-query-on-exit-flag
			      (get-process "Python")))))
  :config
  ;; Env vars
  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-env "PYTHONPATH"))
  ;; Default to Python 3. Prefer the versioned Python binaries since some
  ;; systems stupidly make the unversioned one point at Python 2.
  (when (and (executable-find "python")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python"))
  (define-key inferior-python-mode-map (kbd "C-j") 'comint-next-input)
  (define-key inferior-python-mode-map (kbd "<up>") 'comint-next-input)
  (define-key inferior-python-mode-map (kbd "C-k") 'comint-previous-input)
  (define-key inferior-python-mode-map (kbd "<down>") 'comint-previous-input)
  (define-key inferior-python-mode-map (kbd "C-r") 'comint-history-isearch-backward)
  (define-key python-mode-map (kbd "C-c C-b") 'unicorn/python-execute-file))

;; (use-package py-isort :ensure t)

(use-package pyvenv
  :ensure t
  :preface
  ;; autoload virtual environment if project_root/.env file exists, consistent to lsp-python-ms: lsp-python-ms--parse-dot-env
  ;; .env file only has the name of the virtual environment.
  (defun pyvenv-autoload ()
    (require 'projectile)
    (let* ((pdir (projectile-project-root)) (pfile (concat pdir ".env")))
      (if (file-exists-p pfile)
          (pyvenv-workon (with-temp-buffer
                           (insert-file-contents pfile)
                           (nth 0 (split-string (buffer-string))))))))
  :hook (python-mode . pyvenv-autoload))

;; (use-package pipenv
;;   :ensure t
;;   :commands (pipenv-activate
;;              pipenv-deactivate
;;              pipenv-shell
;;              pipenv-open
;;              pipenv-install
;;              pipenv-uninstall))
;; (use-package virtualenvwrapper :ensure t)

;; ;; Format using YAPF
;; ;; Install: pip install yapf
;; (use-package yapfify
;;   :ensure t
;;   :diminish yapf-mode
;;   :hook (python-mode . yapf-mode))

(if (member 'python-mode unicorn-lsp-active-modes)
    (progn
      (use-package lsp-python-ms
	:ensure t
	:hook (pyvenv-mode . (lambda ()
			       (require 'lsp-python-ms)
			       (lsp-deferred)
			       ))
	:init
	(setq lsp-python-ms-auto-install-server t
	      lsp-python-ms-nupkg-channel "stable"
	      lsp-python-ms-guess-env nil ; set to nil so that `'lsp-python-ms-locate-python`' can work right
	      ;; lsp-python-ms-python-executable-cmd "python"
	      ;; lsp-python-ms-python-executable "/home/linyi/anaconda3/envs/transformers/bin"
	      )
	))
  (progn
    (use-package anaconda-mode
      :ensure t
      :defines anaconda-mode-localhost-address
      :diminish anaconda-mode
      :hook ((python-mode . anaconda-mode)
	     (python-mode . anaconda-eldoc-mode))
      :config
      ;; WORKAROUND: https://github.com/proofit404/anaconda-mode#faq
      (setq anaconda-mode-localhost-address "localhost"))
    (use-package company-anaconda
      :ensure t
      :after company
      :defines company-backends
      :init (cl-pushnew 'company-anaconda company-backends)
      :config
      (evil-define-minor-mode-key 'normal 'anaconda-mode (kbd "C-M-i") 'company-anaconda)
      (evil-define-minor-mode-key 'insert 'anaconda-mode (kbd "C-M-i") 'company-anaconda))))
;; (message "not ready for anaconda"))

(provide 'init-lsp-python)
(message "init-python loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp-python.el ends here
