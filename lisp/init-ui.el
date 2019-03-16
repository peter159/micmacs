;;; init-ui.el --- default user interface!!          -*- lexical-binding: t; -*-

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


;;; Code:

(mark-time-here)

;; hide menu-bar, tool-bar, scroll-bar and open with global line number mode
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-linum-mode 1)
(scroll-bar-mode -1)
(electric-pair-mode 1)
(setq-default make-backup-files nil)

(require 'recentf)
(recentf-mode 1)

;; forbid emacs startup screen and make full screen default
(setq inhibit-splash-screen t)
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; display time
(display-time-mode t) 
(setq display-time-24hr-format t) 
(setq display-time-day-and-date t)

;; switch some words to icons, like folder etc.
;; (require 'quelpa-use-package)
;; (use-package font-lock+
;;   :ensure nil
;;   :quelpa (font-lock+
;;    :repo "emacsmirror/font-lock-plus"
;;    :fetcher github))

(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f2>") 'open-init-file)

(provide 'init-ui)
(message "init-ui loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-ui.el ends here
