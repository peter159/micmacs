;; init-dired.el --- Setup dired  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; Directory operations
(use-package dired
  :ensure nil
  :hook (dired-mode . dired-omit-mode)
  :preface
  (defun petmacs/dired-goto-parent-directory ()
    "go up a level using same buffer"
    (interactive)
    (find-alternate-file ".."))

  ;; show diectory first
  (defun petmacs//dired-sort ()
    "Sort dired listings with directories first."
    (save-excursion
      (let (buffer-read-only)
	(forward-line 2) ;; beyond dir. header
	(sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
      (set-buffer-modified-p nil)))

  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'top)  ;; “top” means ask once
  (setq dired-recursive-copies 'always)

  (when sys/macp
    ;; Suppress the warning: `ls does not support --dired'.
    (setq dired-use-ls-dired nil)

    (when (executable-find "gls")
      ;; Use GNU ls as `gls' from `coreutils' if available.
      (setq insert-directory-program "gls")))

  (when (or (and sys/macp (executable-find "gls"))
            (and (not sys/win32p) (and (not sys/macp) (executable-find "ls"))))
    ;; Using `insert-directory-program'
    (setq ls-lisp-use-insert-directory-program t)
    ;; Show directory first
    (setq dired-listing-switches "-alh --group-directories-first"))

  (when sys/win32p
    (setq dired-listing-switches "-alh")  ;; show human readable file size
    (defadvice dired-readin
	(after dired-after-updating-hook first () activate)
      "Sort dired listings with directories first before adding marks."
      (petmacs//dired-sort)))

  (evil-define-key 'normal dired-mode-map (kbd "RET") 'dired-find-alternate-file) 
  ;; was dired-advertised-find-file
  (evil-define-key 'normal dired-mode-map (kbd "f") 'dired-find-alternate-file) 
  ;; was dired-up-director
  (evil-define-key 'normal dired-mode-map (kbd "^") 'petmacs/dired-goto-parent-directory)  
  ;; kill current buffer when leaving dired mode
  (evil-define-key 'normal dired-mode-map (kbd "q") 'kill-this-buffer)
  :init
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key evil-normal-state-map (kbd "-") 'dired-jump))

;; Quick sort dired buffers via hydra
(use-package dired-quick-sort
  :bind (:map dired-mode-map
              ("S" . hydra-dired-quick-sort/body)))

;; Shows icons
(use-package all-the-icons-dired
  :diminish
  :if (icons-displayable-p)
  :hook (dired-mode . all-the-icons-dired-mode)
  :init
  (require 'font-lock+)
  :config
  (with-no-warnings
    (defun my-all-the-icons-dired--display ()
      "Display the icons of files in a dired buffer."
      (when dired-subdir-alist
        (let ((inhibit-read-only t))
            ;; NOTE: don't display icons it too many items
            (if (<= (count-lines (point-min) (point-max)) 1000)
                (save-excursion
                  ;; TRICK: Use TAB to align icons
                  (setq-local tab-width 1)

                  ;; Insert icons before the filenames
                  (goto-char (point-min))
                  (while (not (eobp))
                    (when (dired-move-to-filename nil)
                      (insert " ")
                      (let ((file (dired-get-filename 'verbatim t)))
                        (unless (member file '("." ".."))
                          (let ((filename (dired-get-filename nil t)))
                            (if (file-directory-p filename)
                                (insert (all-the-icons-icon-for-dir filename nil ""))
                              (insert (all-the-icons-icon-for-file file :v-adjust -0.05))))
                          ;; Align and keep one space for refeshing after some operations
                          (insert "\t "))))
                    (forward-line 1)))
              (message "Not display icons because of too many items.")))))
      (advice-add #'all-the-icons-dired--display
                  :override #'my-all-the-icons-dired--display)))

;; Allow rsync from dired buffers
(use-package dired-rsync
  :bind (:map dired-mode-map
                ("C-c C-r" . dired-rsync)))

(use-package diredfl
  :init
  (diredfl-global-mode 1))

(use-package dired-aux :ensure nil)
(use-package dired-x
  :ensure nil
  :demand
  :config
  (let ((cmd (cond
              ((and (display-graphic-p) sys/macp) "open")
              ((and (display-graphic-p) sys/linuxp) "xdg-open")
              (sys/win32p "start")
              (t ""))))
    (setq dired-guess-shell-alist-user
          `(("\\.pdf\\'" ,cmd)
            ("\\.docx\\'" ,cmd)
            ("\\.\\(?:djvu\\|eps\\)\\'" ,cmd)
            ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" ,cmd)
            ("\\.\\(?:xcf\\)\\'" ,cmd)
            ("\\.csv\\'" ,cmd)
            ("\\.tex\\'" ,cmd)
	    ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|rm\\|rmvb\\|ogv\\)\\(?:\\.part\\)?\\'" ,cmd)
            ("\\.\\(?:mp3\\|flac\\)\\'" ,cmd)
            ("\\.html?\\'" ,cmd)
            ("\\.md\\'" ,cmd))))

  (setq dired-omit-files
        (concat dired-omit-files
                "\\|^.DS_Store$\\|^.projectile$\\|^.git$\\|^.svn$\\|^.vscode$\\|\\.js\\.meta$\\|\\.meta$\\|\\.elc$\\|^.emacs.*")))

(use-package ranger
  :diminish
  :commands (ranger deer deer-jump-other-window ranger-override-dired-mode)
  :init
  (setq ranger-override-dired t)
  (setq ranger-deer-show-details t)
  (setq ranger-cleanup-on-disable t)
  (setq ranger-show-hidden t)
  (setq ranger-parent-depth 1)
  (setq ranger-width-parents 0.12)
  (ranger-override-dired-mode t)  ;; use ranger as default directory handler
  (setq ranger-ignored-extensions '("mkv" "iso" "mp4"))
  ;; set the max files size (in MB) to preview
  (setq ranger-max-preview-size 5)
  ;; allow '-' to enter ranger
  (define-key evil-normal-state-map (kbd "-") 'deer)
  :config
  (define-key ranger-mode-map (kbd "-") 'ranger-up-directory)
  (with-eval-after-load 'counsel-projectile
    ;; open deer when switch into one project
    (counsel-projectile-modify-action
     'counsel-projectile-switch-project-action
     '((add ("." deer "open ‘deer’ at the root of the project") 1)))))

(provide 'init-dired)

;;; init-dired.el ends here
