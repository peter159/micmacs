;; init-ui.el --- Setup UI.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; Font
(defun font-installed-p (font-name)
    "Check if font with FONT-NAME is available."
      (find-font (font-spec :name font-name)))

(when sys/mac-x-p
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-hook 'after-load-theme-hook
            (lambda ()
              (let ((bg (frame-parameter nil 'background-mode)))
                (set-frame-parameter nil 'ns-appearance bg)
                (setcdr (assq 'ns-appearance default-frame-alist) bg)))))

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; Menu/Tool/Scroll bars
(unless emacs/>=27p
  (push '(menu-bar-lines . 0) default-frame-alist)
  (push '(tool-bar-lines . 0) default-frame-alist)
  (push '(vertical-scroll-bars) default-frame-alist))

;; Icons
;; NOTE: Must run `M-x all-the-icons-install-fonts', and install fonts manually on Windows
(use-package all-the-icons
  :if (display-graphic-p)
  :init (unless (or sys/win32p (font-installed-p "all-the-icons"))
          (all-the-icons-install-fonts t))
  :config
  (with-no-warnings
    ;; FIXME: Align the directory icons
    ;; @see https://github.com/domtronn/all-the-icons.el/pull/173
    (defun all-the-icons-icon-for-dir (dir &optional chevron padding)
      "Format an icon for DIR with CHEVRON similar to tree based directories."
      (let* ((matcher (all-the-icons-match-to-alist (file-name-base (directory-file-name dir)) all-the-icons-dir-icon-alist))
             (path (expand-file-name dir))
             (chevron (if chevron (all-the-icons-octicon (format "chevron-%s" chevron) :height 0.8 :v-adjust -0.1) ""))
             (padding (or padding "\t"))
             (icon (cond
                    ((file-symlink-p path)
                     (all-the-icons-octicon "file-symlink-directory" :height 1.0 :v-adjust 0.0))
                    ((all-the-icons-dir-is-submodule path)
                     (all-the-icons-octicon "file-submodule" :height 1.0 :v-adjust 0.0))
                    ((file-exists-p (format "%s/.git" path))
                     (format "%s" (all-the-icons-octicon "repo" :height 1.1 :v-adjust 0.0)))
                    (t (apply (car matcher) (list (cadr matcher) :v-adjust 0.0))))))
        (format "%s%s%s%s%s" padding chevron padding icon padding)))

    (defun all-the-icons-reset ()
      "Reset (unmemoize/memoize) the icons."
      (interactive)
      (dolist (f '(all-the-icons-icon-for-file
                   all-the-icons-icon-for-mode
                   all-the-icons-icon-for-url
                   all-the-icons-icon-family-for-file
                   all-the-icons-icon-family-for-mode
                   all-the-icons-icon-family))
        (ignore-errors
          (memoize-restore f)
          (memoize f)))
      (message "Reset all-the-icons")))

  (add-to-list 'all-the-icons-icon-alist
               '("\\.go$" all-the-icons-fileicon "go" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(go-mode all-the-icons-fileicon "go" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(bongo-playlist-mode all-the-icons-material "playlist_play" :height 1.2 :v-adjust -0.2 :face 'all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(bongo-library-mode all-the-icons-material "library_music" :height 1.1 :v-adjust -0.2 :face 'all-the-icons-dgreen))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(gnus-group-mode all-the-icons-fileicon "gnu" :face 'all-the-icons-silver))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(gnus-summary-mode all-the-icons-octicon "inbox" :height 1.0 :v-adjust 0.0 :face 'all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(gnus-article-mode all-the-icons-octicon "mail" :height 1.1 :v-adjust 0.0 :face 'all-the-icons-lblue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(diff-mode all-the-icons-octicon "git-compare" :v-adjust 0.0 :face all-the-icons-lred))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(flycheck-error-list-mode all-the-icons-octicon "checklist" :height 1.1 :v-adjust 0.0 :face all-the-icons-lred))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(elfeed-search-mode all-the-icons-faicon "rss-square" :v-adjust -0.1 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(elfeed-show-mode all-the-icons-octicon "rss" :height 1.1 :v-adjust 0.0 :face all-the-icons-lorange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(newsticker-mode all-the-icons-faicon "rss-square" :v-adjust -0.1 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(newsticker-treeview-mode all-the-icons-faicon "rss-square" :v-adjust -0.1 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(newsticker-treeview-list-mode all-the-icons-octicon "rss" :height 1.1 :v-adjust 0.0 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(newsticker-treeview-item-mode all-the-icons-octicon "rss" :height 1.1 :v-adjust 0.0 :face all-the-icons-lorange))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.[bB][iI][nN]$" all-the-icons-octicon "file-binary" :v-adjust 0.0 :face all-the-icons-yellow))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.c?make$" all-the-icons-fileicon "gnu" :face all-the-icons-dorange))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.conf$" all-the-icons-octicon "settings" :v-adjust 0.0 :face all-the-icons-yellow))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.toml$" all-the-icons-octicon "settings" :v-adjust 0.0 :face all-the-icons-yellow))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(conf-mode all-the-icons-octicon "settings" :v-adjust 0.0 :face all-the-icons-yellow))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(conf-space-mode all-the-icons-octicon "settings" :v-adjust 0.0 :face all-the-icons-yellow))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(forge-topic-mode all-the-icons-alltheicon "git" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.xpm$" all-the-icons-octicon "file-media" :v-adjust 0.0 :face all-the-icons-dgreen))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(help-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1 :face all-the-icons-purple))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(helpful-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1 :face all-the-icons-purple))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(Info-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1))
  (add-to-list 'all-the-icons-icon-alist
               '("NEWS$" all-the-icons-faicon "newspaper-o" :height 0.9 :v-adjust -0.2))
  (add-to-list 'all-the-icons-icon-alist
               '("Cask\\'" all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(cask-mode all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-blue))
  (add-to-list 'all-the-icons-icon-alist
               '(".*\\.ipynb\\'" all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(ein:notebooklist-mode all-the-icons-faicon "book" :face all-the-icons-lorange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(ein:notebook-mode all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(ein:notebook-multilang-mode all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-dorange))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.epub\\'" all-the-icons-faicon "book" :height 1.0 :v-adjust -0.1 :face all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(nov-mode all-the-icons-faicon "book" :height 1.0 :v-adjust -0.1 :face all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(gfm-mode all-the-icons-octicon "markdown" :face all-the-icons-lblue)))

(use-package font-lock+
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(use-package all-the-icons-ivy
  :hook (after-init . all-the-icons-ivy-setup))

(use-package doom-modeline
  :hook ((after-init . doom-modeline-mode)
         (doom-modeline-mode . setup-custom-doom-modeline))
  :custom-face
  (doom-modeline-buffer-file ((t (:inherit font-lock-string-face :weight bold))))
  :init
  ;; prevent flash of unstyled modeline at startup
  (unless after-init-time
    (setq doom-modeline--old-format mode-line-format)
    (setq-default mode-line-format nil))
  (setq
   find-file-visit-truename t  ; display the real names for symlink files
   ;; doom-modeline-height 21
   doom-modeline-lsp t
   doom-modeline-persp-name nil
   doom-modeline-github nil
   doom-modeline-minor-modes t
   doom-modeline-mu4e nil
   doom-modeline-buffer-file-name-style 'relative-to-project
   ;; doom-modeline-buffer-file-name-style 'file-name
   doom-modeline-icon (display-graphic-p)
   doom-modeline-major-mode-icon t
   doom-modeline-major-mode-color-icon t
   doom-modeline-buffer-state-icon t
   doom-modeline-buffer-modification-icon t
   doom-modeline-indent-info nil)
  :config
  (doom-modeline-def-segment petmacs||python-venv
    "The current python virtual environment state."
    (when (eq major-mode 'python-mode)
      (if (eq python-shell-virtualenv-root nil)
	  ""
	(propertize
	 (let ((base-dir-name (file-name-nondirectory (substring python-shell-virtualenv-root 0 -1))))
	   (if (< 10 (length base-dir-name))
	       (format " (%s..)" (substring base-dir-name 0 15))
	     (format " (%s)" base-dir-name)))
	 'face (if (doom-modeline--active) 'doom-modeline-buffer-major-mode)))))

  (doom-modeline-def-modeline 'my-modeline-layout
  '(bar workspace-name window-number modals matches buffer-info remote-host buffer-position parrot selection-info)
  '(objed-state misc-info persp-name grip irc mu4e github debug lsp minor-modes input-method indent-info buffer-encoding petmacs||python-venv process vcs checker))

  (defun setup-custom-doom-modeline ()
    (doom-modeline-set-modeline 'my-modeline-layout 'default))
  )

;; A minor-mode menu for mode-line
(when emacs/>=25.2p
  (use-package minions
    :hook (doom-modeline-mode . minions-mode)))

(use-package doom-themes
  :defer nil
  :defines doom-themes-treemacs-theme
  :functions doom-themes-hide-modeline
  :hook (after-load-theme . (lambda ()
			      (set-face-foreground
			       'mode-line
			       (face-foreground 'default))))
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :config
  ;; FIXME: @see https://github.com/hlissner/emacs-doom-themes/issues/317.
  (set-face-foreground 'mode-line (face-foreground 'default))

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable customized theme (`all-the-icons' must be installed!)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)
  (with-eval-after-load 'treemacs
    (remove-hook 'treemacs-mode-hook #'doom-themes-hide-modeline)))

(use-package chocolate-theme)

(load-theme petmacs--default-theme t)
;;; Disable theme before load a new theme
(defadvice load-theme
    (before theme-dont-propagate activate)
  "Disable theme before load theme."
  (mapc #'disable-theme custom-enabled-themes))

(use-package display-line-numbers-mode
  :ensure nil
  :init
  (setq-default display-line-numbers-type 'relative)
  (global-display-line-numbers-mode 1))

;; Highlight current line number
(use-package hlinum
  :defines linum-highlight-in-all-buffersp
  :custom-face (linum-highlight-face ((t (:inherit default :background nil :foreground nil))))
  :hook (global-linum-mode . hlinum-activate)
  :init
  (setq linum-highlight-in-all-buffersp t))

;; Display Time
(use-package time
  :ensure nil
  :unless (display-graphic-p)
  :hook (after-init . display-time-mode)
  :init
  (setq display-time-24hr-format t
        display-time-day-and-date t))

(use-package hide-mode-line
  :hook (((completion-list-mode completion-in-region-mode) . hide-mode-line-mode)))

(use-package yascroll
  :hook (after-init . global-yascroll-bar-mode))

;; Suppress GUI features
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(fset 'yes-or-no-p 'y-or-n-p)
(setq visible-bell t)
(setq inhibit-compacting-font-caches t) ; Don’t compact font caches during GC.

(add-hook 'window-setup-hook #'size-indication-mode)

(provide 'init-ui)

;;; init-ui.el ends here
