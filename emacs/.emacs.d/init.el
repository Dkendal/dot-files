;;; Bootstrap
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'load-path "~/.emacs.d/elisp/")

(setq package-enable-at-startup nil)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;;; Pkgs

;;;; Misc
(use-package general :ensure t :init (general-evil-setup))

(use-package multiple-cursors :ensure t)

(use-package xclip
  :ensure t
  :config (xclip-mode t))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode t))

(use-package exec-path-from-shell
  :ensure t
  :config (exec-path-from-shell-initialize))

(use-package gruvbox-theme
  :ensure t
  :config (enable-theme 'gruvbox))

(use-package restart-emacs :ensure t)

;;;; Emacs development
(use-package cask :ensure t)

(use-package el-mock :ensure t)

;;;; Language features
(use-package vimrc-mode :ensure t)

(use-package typescript-mode
  :ensure t
  :mode "\\.tsx?$"
  :custom
  (typescript-indent-level 2))

(use-package json-mode :ensure t)

(use-package web-mode
  :ensure t
  :mode ("\\.tsx"))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . gfm-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-command "pandoc -t html5")
  (markdown-fontify-code-blocks-natively t)
  (markdown-code-lang-modes
   '(("ocaml" . tuareg-mode)
     ("elisp" . emacs-lisp-mode)
     ("ditaa" . artist-mode)
     ("asymptote" . asy-mode)
     ("dot" . fundamental-mode)
     ("sqlite" . sql-mode)
     ("calc" . fundamental-mode)
     ("C" . c-mode)
     ("cpp" . c++-mode)
     ("C++" . c++-mode)
     ("screen" . shell-script-mode)
     ("shell" . sh-mode)
     ("bash" . sh-mode)
     ("tsx" . typescript-mode)
     ("ts" . typescript-mode)
     ("json" . json-mode))))

(use-package simple-httpd
  :ensure t
  :config
  (setq httpd-port 7070)
  (setq httpd-host (system-name)))

(use-package impatient-mode
  :ensure t
  :commands impatient-mode)

(use-package lispyville
  :ensure t
  :ghook '(lisp-mode-hook emacs-lisp-mode-hook)
  :config
  (lispyville-set-key-theme
   '(operators
     c-w
     additional
     additional-movement
     movement
     visual)))

;;;; Org
(use-package org
  :straight t
  :load-path "straight/repos/org/testing/"
  :custom
  (org-src-tab-acts-natively t)

  (org-image-actual-width nil)

  (org-refile-targets
   '((nil :maxlevel . 1)
     (org-agenda-files :maxlevel . 1)))
  
  (org-capture-templates
   '(("f" "Fleeting entry"
      entry (file+olp "~/org/index.org" "Fleeting")
      "** %?\n   :PROPERTIES:\n   :CREATED: %T\n   :END:"
      :empty-lines 1)))
  
  (org-refile-use-outline-path t)

  (org-todo-keywords
   '((sequence "TODO(t)" "STARTED(s!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

  :hook ((org-babel-after-execute-hook . org-redisplay-inline-images))

  :config
  (require 'org-tempo)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t)
     (sql . t)
     (shell . t)))

  (require 'ol)

  (org-link-set-parameters "gh" :follow #'my/org-github-follow)
  ;; (org-link-set-parameters "jira" :follow #'my/org-jira-follow)
  )

;;;;; ID
(use-package org-id
  :custom
  (org-id-link-to-org-use-id t))

;;;;; Super agenda
(use-package org-super-agenda
  :ensure t
  :config
  (org-super-agenda-mode 1)
  :custom
  (org-super-agenda-groups
   '(;; Views
     (:tag "support")

     (:name "Done today" :and (:regexp "State \"DONE\"" :log t)
	    :order 0)

     (:name "Clocked today" :log t :order 1)

     (:tag "HAS")

     (:tag "jsx-lite")

     (:tag "builder")

     (:tag "personal")

     (:auto-todo t)

     ;; (:discard (:anything t))
     ;;
     )))

;;;;; roam
(use-package org-roam
  :ensure t
  :ghook 'after-init-hook
  :custom
  (org-roam-directory "~/notes")
  (org-roam-index-file "~/notes/index.org")

  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      #'org-roam-capture--get-point
      "* %?"
      :file-name "daily/%<%Y-%m-%d>"
      :head "#+title: %<%Y-%m-%d>\n\n")))

  (org-roam-graph-viewer "/Applications/Firefox Developer Edition.app/Contents/MacOS//firefox")
  (org-roam-graph-viewer nil)
  (org-roam-graph-executable "dot")
  (org-roam-graph-extra-config '(("rankdir" . "LR") ("overlap" . "false")))

  :config
  (require 'org-roam-protocol))

;;;;; Journal
(use-package org-journal
  :ensure t
  :custom
  (org-journal-dir "~/notes")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-time-prefix "* ")
  (org-journal-date-format "%Y-%m-%d %a"))

;;;;; Bullets
(use-package org-bullets :ensure t)

;;;;; Download
(use-package org-download :ensure t)

;;;;; QL
(use-package org-ql :ensure t)

;;;;; Pomodoro
(use-package org-pomodoro :ensure t :after org)

;;;;; Jira
(use-package org-jira
  :ensure t :after org
  :custom
  (jiralib-url "https://builder-io.atlassian.net")
  (org-jira-use-status-as-todo nil)
  (org-jira-priority-to-org-priority-alist
   '(("Highest" . ?A)
     ("High" . ?B)
     ("Medium" . ?C)
     ("Low" . ?D)
     ("Lowest" . ?E)))
  (org-jira-jira-status-to-org-keyword-alist
   '(("Open" . "TODO")
     ("To Do" . "TODO")
     ("In Progress" . "STARTED")
     ("In Review" . "STARTED")
     ("Closed" . "CANCELLED")
     ("Done" . "DONE")
     ("Merged" . "DONE")
     ("In Review" . "DONE")))
  (org-jira-progress-issue-flow
   '(("Open" . "To Do")
     ("To Do" . "In Progress")
     ("In Progress" . "In Review")
     ("In Progress" . "Blocked")
     ("In Progress" . "Closed")
     ("In Review" . "Merged")
     ("Merged" . "Done")
     ("Done" . "Closed")))
  (org-jira-custom-jqls
   '((:jql "assignee = currentUser() AND NOT status in (CLOSED, DONE) order by updated DESC"
           :filename "my-work"))))

(use-package company-emoji
  :ensure t
  :defer t
  :custom
  (company-emoji-insert-unicode t))

(use-package emojify :ensure t)

(use-package emoji-cheat-sheet-plus
  :ensure t
  :commands (emoji-cheat-sheet-plus-insert
	     emoji-cheat-sheet-plus-buffer
	     emoji-cheat-sheet-plus-display-mode)
  :defer t
  :ghook ('org-mode-hook #'emoji-cheat-sheet-plus-display-mode))

(use-package unicode-fonts
  :ensure t
  :config
  (unicode-fonts-setup))

(use-package hydra :ensure t)

(use-package ivy
  :ensure t
  :diminish
  :custom 
  (ivy-use-selectable-prompt t)
  :init
  (ivy-mode t))

(use-package default-text-scale :ensure t)

(use-package magit :ensure t)

;;;; Origami
(use-package origami
  :straight (origami :type git
		     :host github
		     :repo "emacs-origami/origami.el"))

(use-package gist :straight t)

(use-package rainbow-delimiters :ensure t)

(use-package ox-pandoc
  :ensure t
  :after ox)

(use-package ox-hugo
  :ensure t
  :after ox)

(use-package counsel :ensure t)

(use-package swiper :ensure t)

;;;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode t)
  (counsel-projectile-mode t)
  (setq projectile-enable-caching t)
  (setq projectile-indexing-method 'alien))

(use-package counsel-projectile :ensure t)

(use-package which-key
  :ensure t
  :diminish
  :init (which-key-mode t))

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode t)

  :general
  (general-define-key
   :keymaps 'company-active-map
   "C-n" 'company-select-next
   "C-p" 'company-select-previous
   ))

(use-package elisp-slime-nav :ensure t)

(use-package diminish :ensure t)

(use-package deadgrep
  :ensure t
  :general
  ('normal
   'deadgrep-mode-map
   "RET" 'deadgrep-visit-result
   "o" 'deadgrep-visit-result-other-window
   "R" 'deadgrep-restart
   "TAB" 'deadgrep-toggle-file-results
   "C-c C-k" 'deadgrep-kill-process
   "n" 'deadgrep-forward
   "p" 'deadgrep-backward
   "N" 'deadgrep-forward-match
   "P" 'deadgrep-backward-match
   "M-n" 'deadgrep-forward-filename
   "M-p" 'deadgrep-backward-filename
   ))

;;;; Evil
(use-package evil
  :ensure t

  :custom
  (evil-undo-system 'undo-tree)
  (evil-shift-width 2)

  :init
  (evil-mode t)

  :config
  (global-evil-visualstar-mode t))

;;;;; Org
(use-package evil-org
  :ensure t
  :after org
  :ghook 'org-mode-hook
  :config
  (evil-org-set-key-theme))

(use-package evil-escape :ensure t :after evil)

(use-package evil-visualstar :ensure t :after evil)

(use-package evil-surround
  :ensure t
  :after evil
  :init (global-evil-surround-mode t))

(use-package evil-commentary
  :ensure t
  :after evil
  :init (evil-commentary-mode t))

;;
;; End of plugins
;;

(defun my/markdown-preview ()
  "Preview markdown."
  (interactive)
  (unless (process-status "httpd")
    (httpd-start))
  (impatient-mode)
  (imp-set-user-filter 'my/markdown-filter)
  (imp-visit-buffer))

(defun my/markdown-filter (buffer)
  (princ
   (with-temp-buffer
     (let ((tmp (buffer-name)))
       (set-buffer buffer)
       (set-buffer (markdown tmp))
       (format "<!DOCTYPE html><html><title>Markdown preview</title><link rel=\"stylesheet\" href = \"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\"/>
<body><article class=\"markdown-body\" style=\"box-sizing: border-box;min-width: 200px;max-width: 980px;margin: 0 auto;padding: 45px;\">%s</article></body></html>" (buffer-string))))
   (current-buffer)))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun delete-buffer-file ()
  "Delete the current file"
  (interactive)
  (delete-file buffer-file-name)
  (kill-buffer-and-window))

(defmacro save-column (&rest body)
  `(let ((column (current-column)))
     (unwind-protect
	 (progn ,@body)
       (move-to-column column))))

(put 'save-column 'lisp-indent-function 0)

(defun move-line-up ()
  (interactive)
  (save-column
    (transpose-lines 1)
    (forward-line -2)))

(defun move-line-down ()
  (interactive)
  (save-column
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1)))

(require 'ert)
(require 'org-test)
(require 'el-mock)

;; org-id
(defun my/write-to-org-pomodoro-log (text)
  (write-region
   text
   nil "/tmp/org-pomodoro-timer"
   nil 'quiet))

(defun my/show-buffer-file-name ()
  "Show the full path to the current file in the minibuffer."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
	(progn
	  (message file-name)
	  (kill-new file-name))
      (error "Buffer not visiting a file"))))

(defun my/org-pomodoro-format ()
  "Formatted string output of the current pomodoro state"
  (if (eq org-pomodoro-state :none)
      " "
    (let ((s (cl-case org-pomodoro-state
	       (:pomodoro org-pomodoro-format)
	       (:overtime org-pomodoro-overtime-format)
	       (:short-break org-pomodoro-short-break-format)
	       (:long-break org-pomodoro-long-break-format))))
      (when (and (org-pomodoro-active-p) (> (length s) 0))
	(concat (format s (org-pomodoro-format-seconds))
		(org-clock-get-clock-string))))))

(defun my/org-jira-follow (term _)
  "Open a link to a Jira ticket"
  (let ((url (concat "https://builder-io.atlassian.net/browse/" term)))
    (browse-url url))) 

(defun my/org-github-follow (term _)
  "Open a link to a Jira ticket"
  (let ((url (concat "https://github.com/" term)))
    (browse-url url))) 



;;; Hooks
(defun show-projects ()
  (interactive)
  (switch-to-buffer "*projects*")
  (org-mode t)
  (insert "#+TITLE: Projects\n\n")
  (dolist (project (projectile-relevant-known-projects))
    (insert (concat "* " project " [[" project "]] " "\n")))
  (goto-char (point-min)))

(general-add-hook
 '(org-pomodoro-tick-hook
   org-pomodoro-break-finished-hook
   org-pomodoro-finished-hook
   org-pomodoro-killed-hook
   org-pomodoro-overtime-hook
   org-pomodoro-short-break-finished-hook
   org-pomodoro-long-break-finished-hook)
 (lambda () (my/write-to-org-pomodoro-log (my/org-pomodoro-format))))

(defun my/org-mode-hook ()
  (require 'org-tempo)
  (require 'org-expiry)
  (require 'org-download)
  (require 'org-bullets)
  (require 'evil-org)
  ;; (org-expiry-insinuate)
  (org-indent-mode)
  (org-download-enable)
  (org-bullets-mode t)
  (evil-org-mode t))

(setq narrow-to-defun-include-comments t)
(setq global-face-height--default 130)
(setq global-face-height global-face-height--default)

;;; Functions
(defun my/indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun my/inc-global-face-height ()
  (interactive)
  (my/relative-set-global-face-height 10))

(defun my/dec-global-face-height ()
  (interactive)
  (my/relative-set-global-face-height -10))

(defun my/reset-global-face-height ()
  (interactive)
  (setq global-face-height global-face-height--default)
  (my/set-global-face-height global-face-height))

(defun my/relative-set-global-face-height (value)
  (setq global-face-height (+ global-face-height value))
  (my/set-global-face-height global-face-height))

(defun my/set-global-face-height (value)
  (set-face-attribute 'default nil :height value))

(general-add-hook '(org-mode-hook) 'my/org-mode-hook)

(general-add-hook '(emacs-lisp-mode-hook lisp-mode-hook)
		  #'rainbow-delimiters-mode)
;;; Setup

;;; Variables

(setq indent-tabs-mode nil)

(setq server-window 'pop-to-buffer)
;; delete excess backup versions silently
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq backup-by-copying t)
;; use version control
(setq version-control t) 		
;; make backups file even when in version controlled dir
(setq vc-make-backup-files t) 
;; which directory to put backups file
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))) 
;; don't ask for confirmation when opening symlinked file
(setq vc-follow-symlinks t) 
;;transform backups file name
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) )
;; inhibit useless and old-school startup screen
(setq inhibit-startup-screen t) 
;; silent bell when you make a mistake
(setq ring-bell-function 'ignore) 
;; use utf-8 by default
(setq coding-system-for-read 'utf-8) 
(setq coding-system-for-write 'utf-8) 
;; sentence SHOULD end with only a point.
(setq sentence-end-double-space nil)
;; toggle wrapping text at the 80th character
(setq default-fill-column 80)
;; print a default message in the empty scratch buffer opened at startup
(setq initial-scratch-message "")

;;; Faces
(set-face-attribute 'default nil :height global-face-height)
(set-face-attribute 'default nil :font "Input Mono")

;;;; OS window UI
(cond
 ((eq system-type 'darwin)
  ;; required for yabai to tile Emacs
  (menu-bar-mode t))
 ((eq system-type 'gnu/linux)
  (menu-bar-mode -1)))

(unless (display-graphic-p)
  (xterm-mouse-mode 1))

(scroll-bar-mode -1)
(tool-bar-mode -1)

;;; Config

;;; Smooth scroll
(require 'pixel-scroll)
(pixel-scroll-mode t)
(setq pixel-dead-time 0)
(setq pixel-resolution-fine-flag t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq jit-lock-defer-time 0)
(setq fast-but-imprecise-scrolling t)
(setq mouse-wheel-progressive-speed nil)

;;; Keymaps
(require 'hydra)
(require 'general)

(general-evil-setup t)

;;;; Global
(general-define-key
 :keymaps 'override
 "<mouse-4>" 'mwheel-scroll
 "<mouse-5>" 'mwheel-scroll
 "C-c C-e" 'emoji-cheat-sheet-plus-insert
 "C-c C-g" 'evil-escape
 "C-c a"  'org-agenda
 "C-c l" 'org-store-link
 "M-c" 'kill-ring-save
 "M-v" 'yank
 "s-[" 'previous-multiframe-window
 "s-]" 'next-multiframe-window
 ;;
 )

;;;;; Normal
(transient-define-prefix my/global-face-height ()
  "Buffer zoom"
  :transient-suffix 'transient--do-stay
  :transient-non-suffix 'transient--do-warn
  [("n" "zoom in" my/inc-global-face-height)
   ("p" "zoom out" my/dec-global-face-height)
   ("." "reset zoom level" my/reset-global-face-height)])

(nmap "SPC =" 'my/global-face-height)

(nmap
  "-" 'dired
  "C-+" 'my/inc-global-face-height
  "C--" 'my/dec-global-face-height
  "C-=" 'my/reset-global-face-height
  "C-u" 'evil-scroll-page-up
  "M-/" 'swiper-thing-at-point
  "M-u" 'universal-argument
  "SPC ;" 'evil-commentary-line
  "SPC C c" 'org-capture
  "SPC m g" 'magit-status
  "[ b" 'evil-prev-buffer
  "[ e" 'move-line-up
  "] b" 'evil-next-buffer
  "] e" 'move-line-down
  "g O" 'counsel-outline
  ;;
  )

;;;;; Narrow
(nmap :prefix "SPC n"
  "F" 'narrow-to-defun
  "R" 'narrow-to-region
  "w" 'widen)

(nmap 'emoji-cheat-sheet-plus-buffer-mode-map
  "<RET>" 'emoji-cheat-sheet-plus-echo-and-copy)

;;;;; Org-agenda
(nmap
  :prefix "SPC a"
  "#" 'org-agenda-list-stuck-projects
  "/" 'org-occur-in-agenda-files
  "O" 'org-clock-out
  "I" 'org-clock-in
  "a" 'org-agenda-list
  "c" 'org-capture
  "e" 'org-store-agenda-views
  "y" 'org-store-link
  "p" 'org-insert-last-stored-link
  "m" 'org-tags-view
  "o" 'org-agenda
  "s" 'org-search-view
  "t" 'org-todo-list)

;;;; Org-mode
;; reference: https://www.spacemacs.org/layers/+emacs/org/README.html#org
(nmap
  'org-mode-map
  "SPC m :" 'org-set-tags-command
  "SPC m A" 'org-archive-subtree
  "SPC m P" 'org-set-property
  "SPC m ^" 'org-sort
  "SPC m b" org-babel-map
  "SPC m e e" 'org-export-dispatch
  "SPC m i c" 'org-expiry-insert-created
  "SPC m i h" 'org-insert-heading
  "SPC m i l" 'org-insert-link
  "SPC m i p" 'org-download-clipboard
  "SPC m p" 'org-pomodoro
  "SPC m s" 'org-sort
  "SPC m t i" 'org-toggle-inline-images
  "SPC m t l" 'org-toggle-link-display
  "SPC m R" 'org-refile
  "SPC m y" 'org-store-link

  ;; insert element
  "SPC m h i"	'org-insert-heading-after-current
  "SPC m h I"	'org-insert-heading
  "SPC m h s"	'org-insert-subheading
  "SPC m i f"	'org-insert-footnote
  "SPC m i l"	'org-insert-link
  "SPC m i L"	'org-insert-last-stored-link

  ;; time stamps
  "SPC m ."	'org-time-stamp-inactive
  "SPC m !"	'org-time-stamp

  ;; Movement
  "M-H" 'org-shiftmetaleft
  "M-J" 'org-shiftmetadown
  "M-K" 'org-shiftmetaup
  "M-L" 'org-shiftmetaright
  "M-h" 'org-metaleft
  "M-j" 'org-metadown
  "M-k" 'org-metaup
  "M-l" 'org-metaright
  "S-TAB" 'org-shifttab
  "SPC i ," 'org-insert-structure-template
  "SPC i h" 'org-insert-heading-after-current

  ;; Outline
  "T" 'org-insert-todo-heading-respect-content
  "TAB" 'org-cycle
  "s-j" 'org-move-subtree-down
  "s-k" 'org-move-subtree-up
  "t" 'org-todo

  ;; narrow
  "SPC n t" 'org-narrow-to-subtree
  "SPC n b" 'org-narrow-to-block
  "SPC n e" 'org-narrow-to-element

  ;; Org roam
  "SPC n :" 'org-roam-tag-add
  "SPC n ;" 'org-roam-tag-delete
  "SPC n I" 'org-roam-insert-immediate
  "SPC n g" 'org-roam-graph
  "SPC n i" 'org-roam-insert
  "SPC n l" 'org-roam
  "SPC t h" 'org-toggle-heading

  "SPC m c" (defhydra hydras/org/clock ()
	      ("g" (lambda () (interactive) org-clock-goto-may-find-recent-task) "goto recent task" :column "Jump")
	      ("j" org-clock-goto "goto clock")
	      ("i" org-clock-in "clock in" :column "Edit")
	      ("k" org-clock-cancel "cancel clock")
	      ("o" org-clock-out "clock out")
	      ("e" org-pomodoro-extend-last-clock "extend last clock" :column "Pomodoro"))
  ;;
  )

(imap 'org-mode-map
  "M-i" 'org-roam-insert)

;;;; Org-agenda-mode
(general-define-key
 :state 'emacs
 :keymaps 'org-agenda-mode-map
 "j" 'org-agenda-next-item
 "k" 'org-agenda-previous-item
 ":" 'evil-ex
 "SPC" nil
 "SPC SPC" 'counsel-M-x
 "SPC h d b" 'counsel-descbinds)

(setq org-super-agenda-header-map (make-sparse-keymap))

(set-keymap-parent org-super-agenda-header-map org-agenda-mode-map)

;;;; Org-Roam
(nmap 'org-roam-mode-map
  "[ f" 'org-roam-dailies-find-previous-note
  "] f" 'org-roam-dailies-find-next-note
  "SPC n i" 'org-roam-jump-to-index
  "SPC n c" 'org-roam-capture
  "SPC n D" 'org-roam-db-build-cache
  "SPC n f" 'org-roam-find-file
  "SPC n d d" 'org-roam-dailies-find-date
  "SPC n d t" 'org-roam-dailies-find-today
  "SPC n d T" 'org-roam-dailies-find-tomorrow
  "SPC n d y" 'org-roam-dailies-find-yesterday)


;;;; Text formatting
(general-define-key
 :modes '(visual insert)
 :keymaps 'org-mode-map
 "s-b" '(lambda () (interactive) (org-emphasize ?\*)) ;; Bold
 "s-i" '(lambda () (interactive) (org-emphasize ?\/)) ;; Italic
 "s-u" '(lambda () (interactive) (org-emphasize ?\_)) ;; Underline
 "s-s" '(lambda () (interactive) (org-emphasize ?\+)) ;; Strike-through
 "s-c" '(lambda () (interactive) (org-emphasize ?\=)) ;; Code
 )


(nmap
  :prefix "SPC"
  :non-normal-prefix "C-SPC"
  "p" 'projectile-command-map
  "s s" 'swiper
  "SPC" 'counsel-M-x
  "p f" 'counsel-projectile-find-file
  "f f" 'counsel-find-file
  "f r" 'counsel-recentf
  "f y" 'my/show-buffer-file-name
  "f e d" (lambda () (interactive) (find-file user-init-file))
  "f e R" (lambda () (interactive) (load-file user-init-file))
  ;;
  ;; text editing
  ;;
  ";" 'evil-commentary-line
  ;;
  ;; window movement
  ;;
  "w h" 'evil-window-left
  "w j" 'evil-window-down
  "w k" 'evil-window-up
  "w l" 'evil-window-right
  "w d" 'evil-window-delete
  "w o" 'only
  ;;
  ;; window layout
  ;;
  "w H" 'evil-window-move-far-left
  "w J" 'evil-window-very-bottom
  "w K" 'evil-window-move-very-top
  "w L" 'evil-window-move-far-right
  ;;
  ;; buffer
  ;;
  "b s" (lambda () (switch-to-buffer "*scratch*"))
  "b d" 'kill-current-buffer
  "b a d" 'kill-other-buffers
  "b n" 'evil-next-buffer
  "b p" 'evil-prev-buffer
  "b b" 'counsel-switch-buffer
  ;; search
  "/" 'deadgrep
  ;; toggles
  "t s" 'flyspell-mode
  "t n" 'counsel-load-theme

  ;; help maps
  "h h" 'counsel-apropos
  "h d m" 'describe-mode
  "h d p" 'describe-package
  "h d b" 'counsel-descbinds
  "h d k" 'describe-key
  "h d v" 'counsel-describe-variable
  "h d f" 'counsel-describe-function)

;;;; Visual mode maps
(vmap
  "SPC SPC" 'counsel-M-x
  "SPC ;" 'evil-commentary
  "<" 'evil-shift-left
  ">" 'evil-shift-right)

;;;; epa-key-list
(nmap 'epa-key-list-mode-map
  "<down-mouse-1>"	'widget-button-click
  "<down-mouse-2>"	'widget-button-click
  "TAB"			'widget-forward
  "RET"			'widget-button-press
  "q"			'epa-exit-buffer
  "SPC m"		'epa-mark-key
  "SPC u"		'epa-unmark-key
  "q"			'epa-exit-buffer
  "," (defhydra hyrdras/epa-key-list ()
	("d" epa-decrypt-file "decrypt file" :column "Action")
	("e" epa-encrypt-file "encrypt file" :column "Action")
	("i" epa-import-keys "import keys" :column "Action")
	("o" epa-export-keys "export keys" :column "Action")
	("v" epa-verify-file "verify file" :column "Action")
	("s" epa-sign-file "sign file" :column "Action")
	("g" revert-buffer "revert buffer" :column "Edit")
	("q" epa-exit-buffer "exit buffer" :column "Edit")
	("m" epa-mark-key "mark key" :column "Select")
	("n" next-line "next line" :column "Move")
	("p" previous-line "previous line" :column "Move")
	("u" epa-unmark-key "unmark key" :column "Select")))
;;;; Emacs Lisp
(nmap
  'emacs-lisp-mode-map
  "H" 'backward-sexp
  "K" 'elisp-slime-nav-describe-elisp-thing-at-point
  "L" 'forward-sexp
  ", l" 'forward-list
  ", h" 'backward-list
  ", j" 'up-list
  ", k" 'down-list
  ", =" 'indent-sexp
  ", t" 'transpose-sexps)
;; end of keymaps

(server-start)

;;; Easy customization

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/notes/gtd.org" "~/notes/tickler.org" "~/notes/someday.org" "~/notes/20210224170635-builder_documentation_list.org" "~/notes/20210507143046-builder_on_call.org" "~/.org-jira/my-work.org" "~/notes/20210215102829-builder_io.org" "~/notes/20210225223856-jsx_lite.org" "~/notes/index.org" "~/notes/20210225183538-headless_app_store.org"))
 '(org-log-into-drawer t)
 '(org-src-lang-modes
   '(("C" . c)
     ("C++" . c++)
     ("asymptote" . asy)
     ("bash" . sh)
     ("beamer" . latex)
     ("calc" . fundamental)
     ("cpp" . c++)
     ("ditaa" . artist)
     ("dot" . fundamental)
     ("elisp" . emacs-lisp)
     ("ocaml" . tuareg)
     ("screen" . shell-script)
     ("shell" . sh)
     ("sqlite" . sql)
     ("vim" . vimrc)))
 '(package-selected-packages
   '(gist diminish diminsh org-pomodoro evil-visualstar evil-visual-star evil-commentary evil-surround counsel-projectile projectile gruvbox-theme evil-org which-key counsel swiper ivy use-package helm general evil-visual-mark-mode))
 '(safe-local-variable-values
   '((org-latex-classes
      ("resume" "\\documentclass[]{resume}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" "" "\\section*{%s}" "")
       ("%s \\begin{entrydesc}" "\\end{entrydesc}" "%s \\begin{entrydesc}" "\\end{entrydesc}")
       ("\\subsubsection{%s}" "" "\\subsubsection{%s}" "")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("resume" "\\documentclass[]{resume}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" "" "\\section*{%s}" "")
       ("%s \\begin{entrydesc}"
	(\, "\\end{entrydesc}")
	(\, "%s \\begin{entrydesc}")
	(\, "\\end{entrydesc}"))
       ("\\subsubsection{%s}" "" "\\subsubsection{%s}" "")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("resume" "\\documentclass[]{resume}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" "" "\\section*{%s}" "")
       ("%s egin{entrydesc}"
	(\, "nd{entrydesc}")
	(\, "%s egin{entrydesc}")
	(\, "nd{entrydesc}"))
       ("\\subsubsection{%s}" "" "\\subsubsection{%s}" "")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("resume" "\\documentclass[]{resume}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("resume" "\\documentclass{resume}
\\usepackage{textcomp}
\\fontdir[fonts/]
\\newcommand*{\\sectiondir}{resume/}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("article" "\\documentclass[]{article}
\\usepackage{textcomp}
\\fontdir[fonts/]
\\newcommand*{\\sectiondir}{resume/}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("awesome-cv" "\\documentclass[]{awesome-cv}
\\usepackage{textcomp}
\\fontdir[fonts/]
\\newcommand*{\\sectiondir}{resume/}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\cventry{%s}" . "\\cventry*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("awesome-cv" "\\documentclass[]{awesome-cv}
\\usepackage{textcomp}
\\fontdir[fonts/]
\\newcommand*{\\sectiondir}{resume/}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("awesome-cv" "\\documentclass[]{awesome-cv}
\\usepackage{textcomp}
\\fontdir[fonts/]
\\newcommand*{ ectiondir}{resume/}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("awesome-cv" "\\documentclass[11pt]{article}
\\usepackage{textcomp}
\\fontdir[fonts/]
\\newcommand*{ ectiondir}{resume/}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
     (org-latex-classes
      ("awesome-cv" "\\documentclass[11pt]{article}"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
       ("\\paragraph{%s}" . "\\paragraph*{%s}")
       ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
      ("report" "\\documentclass[11pt]{report}"
       ("\\part{%s}" . "\\part*{%s}")
       ("\\chapter{%s}" . "\\chapter*{%s}")
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
      ("book" "\\documentclass[11pt]{book}"
       ("\\part{%s}" . "\\part*{%s}")
       ("\\chapter{%s}" . "\\chapter*{%s}")
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
     (org-todo-keywords quote
			((sequence "TODO" "BLOCKED" "DONE")))
     (org-download-image-dir . "./images"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t nil))))
(put 'narrow-to-region 'disabled nil)
