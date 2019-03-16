;;; init-evil.el ---                                 -*- lexical-binding: t; -*-

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

(defun mark-time-start()
  "return current time in float, this used as a mark time star"
  (interactive)
  (setq mark-time (float-time)))
(mark-time-start)

(defun get-time-diff(time-start)
  "return seconds passed from current to `time-start'"
  (interactive)
  (setq diff (time-subtract (float-time) time-start))
  (float-time diff))

(get-time-diff mark-time)

(use-package evil-leader :ensure t)
(use-package evil-anzu :ensure t)
(use-package evil
  :init
  (require 'evil-leader)
  (global-evil-leader-mode)

  (setq evil-want-C-u-scroll t)
  (when evil-want-C-u-scroll
    (define-key evil-insert-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up))

  :config
  (require 'evil-anzu)
  (evil-mode)
  (progn
    (defun petmacs//evil-visual-shift-left ()
      "evil left shift without losing selection"
      (interactive)
      (call-interactively 'evil-shift-left)
      (evil-normal-state)
      (evil-visual-restore))

    (defun petmacs//evil-visual-shift-right ()
      "evil right shift without losing selection"
      (interactive)
      (call-interactively 'evil-shift-right)
      (evil-normal-state)
      (evil-visual-restore))
    ;; Overload shifts so that they don't lose the selection
    (define-key evil-visual-state-map (kbd "<") 'petmacs//evil-visual-shift-left)
    (define-key evil-visual-state-map (kbd ">") 'petmacs//evil-visual-shift-right)))

;; use 'fd' to escape nearly everything from evil-mode
(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-delay 0.3)
  (evil-escape-mode))

;; comment/uncomment, use 'gd' to see how it works
(use-package evil-commentary
  :ensure t
  :hook
  (after-init . evil-commentary-mode))

;; surrounding text shortcut, see: https://github.com/emacs-evil/evil-surround
(use-package evil-surround
  :ensure t
  :init
  (global-evil-surround-mode))

(use-package evil-visualstar
  :commands (evil-visualstar/begin-search-forward
             evil-visualstar/begin-search-backward)
  :init
  (progn
    (define-key evil-visual-state-map (kbd "*")
      'evil-visualstar/begin-search-forward)
    (define-key evil-visual-state-map (kbd "#")
      'evil-visualstar/begin-search-backward)))

(use-package evil-magit
  :ensure t
  :hook (magit-mode . evil-magit-init))

(provide 'init-evil)
(message "init-evil loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-evil.el ends here
