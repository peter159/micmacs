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

(use-package python
  :ensure nil
  :defines gud-pdb-command-name pdb-path
  :config
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)

  (add-hook 'inferior-python-mode-hook
            (lambda ()
              ;; (bind-key "C-c C-z" #'kill-buffer-and-window inferior-python-mode-map)
              (process-query-on-exit-flag (get-process "Python")))))

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

(provide 'init-python)
(message "init-python loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-python.el ends here
