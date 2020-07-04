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

(use-package evil-leader
  :ensure t
  :defer nil
  :init
  (global-evil-leader-mode))

;; (message "    ---- 1/12 of init-evil loaded using '%.2f' seconds ..." (get-time-diff time-marked))
;; (mark-time-here)

(use-package evil-major-leader
  :ensure nil
  :quelpa
  (evil-major-leader 
    :repo "Peter-Chou/evil-major-leader" 
    :fetcher github)
  :init
  (global-evil-major-leader-mode))

;; (message "    ---- 1/6 of init-evil loaded using '%.2f' seconds ..." (get-time-diff time-marked))
;; (mark-time-here)

;; (use-package evil-leader :ensure t :defer nil)
(use-package evil-anzu :ensure t)
(use-package evil
  :ensure t
  :init
  ;; (require 'evil-leader)
  ;; (global-evil-leader-mode t)

  ;; (setq evil-want-C-u-scroll t)
  ;; (when evil-want-C-u-scroll
  ;;   (define-key evil-insert-state-map (kbd "C-u") 'evil-scroll-up)
  ;;   (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  ;;   (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  ;;   (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up))

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
    (define-key evil-visual-state-map (kbd ">") 'petmacs//evil-visual-shift-right)
    (define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
    (define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
    (define-key evil-normal-state-map (kbd "C-a") 'move-beginning-of-line)
    (define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line) 
    (define-key evil-visual-state-map (kbd "C-a") 'move-beginning-of-line)
    (define-key evil-visual-state-map (kbd "C-e") 'move-end-of-line) 
    (define-key evil-insert-state-map (kbd "C-k") 'kill-line)
    (define-key evil-insert-state-map (kbd "C-p") 'previous-line)
    (define-key evil-insert-state-map (kbd "C-n") 'next-line)
    (define-key evil-insert-state-map (kbd "C-y") 'yank)
    (define-key evil-insert-state-map (kbd "C-d") 'delete-char)))

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
  :ensure t
  :commands (evil-visualstar/begin-search-forward
             evil-visualstar/begin-search-backward)
  :init
  (progn
    (define-key evil-visual-state-map (kbd "*")
      'evil-visualstar/begin-search-forward)
    (define-key evil-visual-state-map (kbd "#")
      'evil-visualstar/begin-search-backward)))

(use-package evil-fringe-mark
  :ensure t
  :config
  (setq-default right-fringe-width 25)
  (setq-default evil-fringe-mark-side 'right-fringe)
  (global-evil-fringe-mark-mode))

(use-package evil-magit
  :ensure t
  :hook (magit-mode . evil-magit-init))

;; using outline-minor-mode for evil folding
(use-package outline-mode
  :ensure nil
  :hook (prog-mode . outline-minor-mode)
  :init
  ;; (evil-define-key 'normal outline-mode-map (kbd "zK") 'outline-show-branches) ; Show all children recursively but no body.
  ;; (evil-define-key 'normal outline-mode-map (kbd "zk") 'outline-show-children) ; Direct children only unlike `outline-show-branches'
  (define-key evil-normal-state-map (kbd "zB") 'outline-hide-body) ; Hide all bodies
  (define-key evil-normal-state-map (kbd "zb") 'outline-show-all)  ; Hide current body
  (define-key evil-normal-state-map (kbd "ze") 'outline-show-entry) ; Show current body only, not subtree, reverse of outline-hide-entry
  (define-key evil-normal-state-map (kbd "zl") 'outline-hide-leaves) ; Like `outline-hide-body' but for current subtree only
  (define-key evil-normal-state-map (kbd "zp") 'outline-hide-other)    ; Hide all nodes and bodies except current body.
  (define-key evil-normal-state-map (kbd "zj") 'outline-forward-same-level)
  (define-key evil-normal-state-map (kbd "zk") 'outline-backward-same-level)
  (define-key evil-normal-state-map (kbd "M-j") 'outline-move-subtree-down)
  (define-key evil-normal-state-map (kbd "M-k") 'outline-move-subtree-up))

(provide 'init-evil)
(message "init-evil loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-evil.el ends here
