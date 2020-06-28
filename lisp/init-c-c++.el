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

;; 

;;; Code:

(mark-time-here)

;; install llvm-10 or above
;; Add the following code in your ~/.profile file and reboot
;; LLVM 10.0.0 is installed in /home/software/llvm
;; LLVM_HOME=/home/software/llvm
;; export PATH=$LLVM_HOME/bin:$PATH
;; export LD_LIBRARY_PATH=$LLVM_HOME/lib:$LD_LIBRARY_PATH
(defvar petmacs-default-mode-for-headers 'c++-mode
  "default default mode for .h header files, Can be `c-mode' or `c++-mode'")

(use-package cc-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist
	       `("\\.h\\'" . ,petmacs-default-mode-for-headers))
  (setq lsp-clients-clangd-args
	'("-j=4" "-log=verbose" "-background-index"
	  ;; -cross-file-rename is vaild since clangd-10
	  "-cross-file-rename"
	  ;; "--compile-commands-dir=/work/DomainDrivenConsulting/masd/dogen/integration/build/output/clang7/Release"
	  ))

  :hook ((c-mode c++-mode) . (lambda ()
			       "Format and add/delete imports."
			       (add-hook 'before-save-hook #'lsp-format-buffer t t)
			       (add-hook 'before-save-hook #'lsp-organize-imports t t)
			       ;; enable lsp
			       (lsp-deferred)))
  :config
  (require 'compile))

(use-package smart-semicolon
  :defer t
  :hook ((c-mode-common . smart-semicolon-mode)))

(use-package modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))

(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode) ("\\.cmake\\'" . cmake-mode))
  :config
  (add-hook 'cmake-mode-hook (lambda()
                               (add-to-list (make-local-variable 'company-backends)
                                            'company-cmake))))
(use-package google-c-style
  :init
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent))

(provide 'init-c-c++)
(message "init-c-c++ loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-c-c++.el ends here
