;;; init-version-control.el ---                      -*- lexical-binding: t; -*-

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

;; ;; set socks proxy
;; (setq url-proxy-services `(("http" . ,"10.137.133.20:1080")
;; 			   ("https" . ,"10.137.133.20:1080")
;; 			   ("no_proxy" . "^\\(localhost\\|192.168.*\\|10.*\\)")))

;; ;; set socks proxy
;; (setq url-proxy-services `(("http" . ,"127.0.0.1:12333")
;; 			   ("https" . ,"127.0.0.1:12333")
;; 			   ("no_proxy" . "^\\(localhost\\|192.168.*\\|10.*\\)")))


(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch)
         ("C-c M-g" . magit-file-popup))
  :config
  (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (add-to-list 'magit-log-arguments "--color")

  ;; When 'C-c C-c' is pressed in the magit commit message buffer,
  ;; delete the magit-diff buffer related to the current repo.
  (defun kill-magit-diff-buffer-in-current-repo (&rest _)
    "Delete the magit-diff buffer related to the current repo"
    (let ((magit-diff-buffer-in-current-repo
           (magit-mode-get-buffer 'magit-diff-mode)))
      (kill-buffer magit-diff-buffer-in-current-repo)))

  (add-hook 'git-commit-setup-hook
            (lambda ()
              (add-hook 'with-editor-post-finish-hook
			#'kill-magit-diff-buffer-in-current-repo
			nil t))) ; the t is important

  ;; kill magit status buffer when quitting magit status
  (define-key magit-mode-map (kbd "q") (lambda()
					 (interactive)
					 (magit-mode-bury-buffer t)))

  ;; (define-key magit-mode-map (kbd "M-1") 'winum-select-window-1)
  ;; (define-key magit-mode-map (kbd "M-2") 'winum-select-window-2)
  ;; (define-key magit-mode-map (kbd "M-3") 'winum-select-window-3)
  ;; (define-key magit-mode-map (kbd "M-4") 'winum-select-window-4)
  ;; (define-key magit-mode-map (kbd "M-5") 'winum-select-window-5)
  ;; (define-key magit-mode-map (kbd "M-6") 'winum-select-window-6)
  ;; (define-key magit-mode-map (kbd "M-7") 'winum-select-window-7)
  ;; (define-key magit-mode-map (kbd "M-8") 'winum-select-window-8)

  ;; Show tasks
  (use-package magit-todos
    :ensure t
    :hook (ater-init . magit-todos-mode))

  ;; Walk through git revisions of a file
  (use-package git-timemachine
    :ensure t
    :custom-face
    (git-timemachine-minibuffer-author-face ((t (:inherit font-lock-string-face))))
    (git-timemachine-minibuffer-detail-face ((t (:inherit warning))))
    :bind (:map vc-prefix-map
		("t" . git-timemachine)))

  ;; Pop up last commit information of current line
  (use-package git-messenger
    :ensure t
    :bind (:map vc-prefix-map
		("p" . git-messenger:popup-message)
		:map git-messenger-map
		("m" . git-messenger:copy-message))
    :init
    ;; Use magit-show-commit for showing status/diff commands
    (setq git-messenger:use-magit-popup t))

  ;; Resolve diff3 conflicts
  (use-package smerge-mode
    :ensure nil
    :diminish
    :preface
    (with-eval-after-load 'hydra
      (defhydra smerge-hydra
	(:color pink :hint nil :post (smerge-auto-leave))
	"
^Move^       ^Keep^               ^Diff^                 ^Other^
^^-----------^^-------------------^^---------------------^^-------
_n_ext       _b_ase               _<_: upper/base        _C_ombine
_p_rev       _u_pper              _=_: upper/lower       _r_esolve
^^           _l_ower              _>_: base/lower        _k_ill current
^^           _a_ll                _R_efine
^^           _RET_: current       _E_diff
"
	("n" smerge-next)
	("p" smerge-prev)
	("b" smerge-keep-base)
	("u" smerge-keep-upper)
	("l" smerge-keep-lower)
	("a" smerge-keep-all)
	("RET" smerge-keep-current)
	("\C-m" smerge-keep-current)
	("<" smerge-diff-base-upper)
	("=" smerge-diff-upper-lower)
	(">" smerge-diff-base-lower)
	("R" smerge-refine)
	("E" smerge-ediff)
	("C" smerge-combine-with-next)
	("r" smerge-resolve)
	("k" smerge-kill-current)
	("ZZ" (lambda ()
		(interactive)
		(save-buffer)
		(bury-buffer))
	 "Save and bury buffer" :color blue)
	("q" nil "cancel" :color blue)))
    :hook ((find-file . (lambda ()
                          (save-excursion
                            (goto-char (point-min))
                            (when (re-search-forward "^<<<<<<< " nil t)
                              (smerge-mode 1)))))
           (magit-diff-visit-file . (lambda ()
                                      (when smerge-mode
					(smerge-hydra/body))))))

  ;; Open github/gitlab/bitbucket page
  (use-package browse-at-remote
    :ensure t
    :bind (:map vc-prefix-map
		("B" . browse-at-remote))))

(use-package git-gutter
  :ensure t
  :hook (prog-mode . git-gutter-mode)
  :custom
  (git-gutter:modified-sign " ")
  (git-gutter:added-sign    "+")
  (git-gutter:deleted-sign  "-")
  :custom-face
  (git-gutter:modified ((t (:background "#f1fa8c"))))
  (git-gutter:added    ((t (:background "#50fa7b"))))
  (git-gutter:deleted  ((t (:background "#ff79c6"))))
  :init
  (run-with-idle-timer 1 nil 'global-git-gutter-mode)
  (setq git-gutter:update-interval 2
        ;; git-gutter:modified-sign " "
        ;; git-gutter:added-sign "+"
        ;; git-gutter:deleted-sign "-"
        ;; git-gutter:diff-option "-w"
        git-gutter:ask-p nil
        git-gutter:verbosity 0
        git-gutter:handled-backends '(git hg bzr svn)
        git-gutter:hide-gutter t)
  )

;; Git related modes
(use-package gitattributes-mode :ensure t)
(use-package gitignore-mode :ensure t)
(use-package gitconfig-mode :ensure t)
(use-package git-commit :ensure t)

(provide 'init-version-control)
(message "init-version-control loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-version-control.el ends here
