;;; init-c-c++.el ---                                -*- lexical-binding: t; -*-

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
;; if need dap mdoe for cpp, refer to here: https://emacs-lsp.github.io/dap-mode/page/configuration/

;; 

;;; Code:

(mark-time-here)

;; build ccls from source code: https://github.com/MaskRay/ccls/wiki/Build
;; install llvm-10 or above
;; Add the following code in your ~/.profile file and reboot
;; LLVM 10.0.0 is installed in /home/software/llvm
;; LLVM_HOME=/home/software/llvm
;; export PATH=$LLVM_HOME/bin:$PATH
;; export LD_LIBRARY_PATH=$LLVM_HOME/lib:$LD_LIBRARY_PATH
(use-package cc-mode
  :ensure t
  :defer t
  :init
  (add-to-list 'auto-mode-alist
	       `("\\.h\\'" . ,unicorn-default-mode-for-headers))

  ;; C/C++/Objective-C support
  (use-package ccls
    :defines projectile-project-root-files-top-down-recurring
    :hook ((c-mode c++-mode objc-mode cuda-mode) . (lambda () (require 'ccls)))
    :init
    (setq ccls-executable (file-truename "~/ccls/Release/ccls"))
    :config
    (with-eval-after-load 'projectile
      (setq projectile-project-root-files-top-down-recurring
            (append '("compile_commands.json" ".ccls")
                    projectile-project-root-files-top-down-recurring))))
  :hook ((c-mode c++-mode) . (lambda ()
			       "Format and add/delete imports."
			       (add-hook 'before-save-hook #'lsp-format-buffer t t)
			       (add-hook 'before-save-hook #'lsp-organize-imports t t)
			       ;; enable lsp
			       (lsp-deferred)))
  :config
  (require 'compile))

(use-package smart-semicolon
  :ensure t
  :defer t
  :hook ((c-mode-common . smart-semicolon-mode)))

(use-package modern-cpp-font-lock
  :ensure t
  :hook (c++-mode . modern-c++-font-lock-mode))

(use-package cmake-mode
  :ensure t
  :mode (("CMakeLists\\.txt\\'" . cmake-mode) ("\\.cmake\\'" . cmake-mode))
  :config
  (add-hook 'cmake-mode-hook (lambda()
                               (add-to-list (make-local-variable 'company-backends)
                                            'company-cmake))))
(use-package google-c-style
  :ensure t
  :init
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent))

;; run dap-cpptools-setup to setup automatically
(require 'dap-cpptools)

(provide 'init-c-c++)
(message "init-c-c++ loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-c-c++.el ends here
