;;; init-python-elpy.el ---                          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  

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

(use-package elpy
  :ensure t
  :config
  ;; (setq elpy-rpc-python-command "d:/Anaconda3/envs/pytorch/python.exe")
  (setq elpy-rpc-python-command (petmacs/pyenv-executable-find python-shell-interpreter))
  ;; :init
  ;; (elpy-enable)
  :hook (python-mode . elpy-mode)
  )

(provide 'init-python-elpy)
(message "init-python-elpy loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-python-elpy.el ends here
