;;; init-golang.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2020  linyi

;; Author: linyi <linyi@ubun-born-0>
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
;; ref :https://dreamerjonson.com/2019/11/24/emacs-package-for-golang/index.html
;; 

;;; Code:

(mark-time-here)

(defun golang-mode-show-doc ()
  "Show documentation for context at point."
  (interactive)
  (let ((pop-up-windows t))
    (pop-to-buffer (current-buffer) t))
  (godoc-at-point))

;; Golang
(use-package go-mode
  :ensure t
  :init
  (use-package go-imenu
    :ensure t)
  (setq gofmt-command "goimports"
	indent-tabs-mode t)
  :functions (go-packages-gopkgs go-update-tools)
  :bind (:map go-mode-map
              ([remap xref-find-definitions] . godef-jump)
              ("C-c R" . go-remove-unused-imports)
              ("<f1>" . godoc-at-point))
  :hook (go-mode . (lambda ()
		     (lsp-deferred)))
  :config
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'gofmt-before-save)
              (setq tab-width 4)))
  (add-hook 'go-mode-hook 'go-imenu-setup)
  ;; Env vars
  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-envs '("GOPATH" "GO111MODULE" "GOPROXY")))

  ;; Install or update tools
  (defvar go--tools '("golang.org/x/tools/cmd/goimports"
                      "github.com/go-delve/delve/cmd/dlv"
                      "github.com/josharian/impl"
                      "github.com/cweill/gotests/..."
                      "github.com/fatih/gomodifytags"
                      "github.com/davidrjenni/reftools/cmd/fillstruct")
    "All necessary go tools.")

  ;; Do not use the -u flag for gopls, as it will update the dependencies to incompatible versions
  ;; https://github.com/golang/tools/blob/master/gopls/doc/user.md#installation
  (defvar go--tools-no-update '("golang.org/x/tools/gopls@latest")
    "All necessary go tools without update the dependencies.")

  (defun go-update-tools ()
    "Install or update go tools."
    (interactive)
    (unless (executable-find "go")
      (user-error "Unable to find `go' in `exec-path'!"))

    (message "Installing go tools...")
    (shell-command "go env -w GO111MODULE=on") ; enable go get for go--tools
    (let ((proc-name "go-tools")
          (proc-buffer "*Go Tools*"))
      (dolist (pkg go--tools-no-update)
        (set-process-sentinel
         (start-process proc-name proc-buffer "go" "get" "-v" pkg)
         (lambda (proc _)
           (let ((status (process-exit-status proc)))
             (if (= 0 status)
                 (message "Installed %s" pkg)
               (message "Failed to install %s: %d" pkg status))))))

      (dolist (pkg go--tools)
        (set-process-sentinel
         (start-process proc-name proc-buffer "go" "get" "-u" "-v" pkg)
         (lambda (proc _)
           (let ((status (process-exit-status proc)))
             (if (= 0 status)
                 (message "Installed %s" pkg)
               (message "Failed to install %s: %d" pkg status)))))))
    (shell-command "go env -w GO111MODULE=auto"))

  ;; Try to install go tools if `gopls' is not found
  (unless (executable-find "gopls")
    (go-update-tools))

  ;; Misc
  (use-package go-dlv
    :ensure t)
  (use-package go-fill-struct
    :ensure t)
  (use-package go-impl
    :ensure t)

  ;; Install: See https://github.com/golangci/golangci-lint#install
  (use-package flycheck-golangci-lint
    :ensure t
    :if (executable-find "golangci-lint")
    :after flycheck
    :defines flycheck-disabled-checkers
    :hook (go-mode . (lambda ()
                       "Enable golangci-lint."
                       (setq flycheck-disabled-checkers '(go-gofmt
                                                          go-golint
                                                          go-vet
                                                          go-build
                                                          go-test
                                                          go-errcheck))
                       (flycheck-golangci-lint-setup))))

  (use-package go-tag
    :ensure t
    :bind (:map go-mode-map
		("C-c t t" . go-tag-add)
		("C-c t T" . go-tag-remove))
    :init (setq go-tag-args (list "-transform" "camelcase")))

  (use-package go-gen-test
    :ensure t
    :bind (:map go-mode-map
		("C-c t g" . go-gen-test-dwim)))

  (use-package gotest
    :ensure t
    :bind (:map go-mode-map
		("C-c t a" . go-test-current-project)
		("C-c t m" . go-test-current-file)
		("C-c t ." . go-test-current-test)
		("C-c t x" . go-run))))

;; Local Golang playground for short snippets
(use-package go-playground
  :ensure t
  :diminish)

(provide 'init-lsp-golang)
(message "init-lsp-golang loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-golang.el ends here
