;; init-evil.el 

;;; Commentary:

;;; Code:
(use-package evil-leader
  :ensure t
  :defer nil
  :config
  (global-evil-leader-mode))

(use-package evil-major-leader
  :quelpa (evil-major-leader :repo "Peter-Chou/evil-major-leader" :fetcher github)
  :config (global-evil-major-leader-mode))

(use-package evil-anzu
  :ensure t)
(use-package evil
  :config
  (require 'evil-anzu)
  (evil-mode t)
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

(provide 'init-evil)

;;; init-evil.el ends here

