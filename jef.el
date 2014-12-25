
(defvar starter-kit-extras '("haskell" "js" "misc-recommended" "org" "perl"))
(mapcar 'starter-kit-load starter-kit-extras)
;;(starter-kit-load "misc-recommended")

(setq user-full-name "James Fletcher"
      user-mail-address "m@jef.me.uk")

(defvar jamesf/packages '(auto-complete
                          autopair
                          deft
                          erlang
                          feature-mode
                          flycheck
                          gist
                          go-mode
                          graphviz-dot-mode
                          haml-mode
                          htmlize
                          magit
                          markdown-mode
                          marmalade
                          nodejs-repl
                          o-blog
                          paredit
                          restclient
                          smex
                          sml-mode
                          web-mode
                          writegood-mode
                          yaml-mode)
  "Default packages")

(defun jamesf/packages-installed-p ()
  (loop for pkg in jamesf/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (jamesf/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg jamesf/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(setq tab-width 2
      indent-tabs-mode nil)

(setq make-backup-files nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))))

(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))

(add-hook 'org-mode-hook
          (lambda ()
            (writegood-mode)))

(setq org-indent-mode t)

(setq org-todo-keywords "#+TODO: TODO(t) STARTED(s) WAITING(w) | DONE(d) CANCELED(c)")

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-show-log t
      org-agenda-todo-ignore-scheduled t
      org-agenda-todo-ignore-deadlines t)

(setq org-directory "~/Private/org")
(setq org-default-notes-file "~/Private/org/organizer.org")
(setq org-agenda-files (list "~/Private/org/fletcher.org"
                             "~/Private/org/todo.org"))

(require 'ob)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)
   (ditaa . t)
   (plantuml . t)
   (dot . t)
   (ruby . t)))

(add-to-list 'org-src-lang-modes (quote ("dot". graphviz-dot)))
(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
(add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

(defvar org-babel-default-header-args:clojure
  '((:results . "silent") (:tangle . "yes")))

(defun org-babel-execute:clojure (body params)
  (lisp-eval-string body)
  "Done!")

(provide 'ob-clojure)

(setq org-src-fontify-natively t
      org-confirm-babel-evaluate nil)

(add-hook 'org-babel-after-execute-hook (lambda ()
                                          (condition-case nil
                                              (org-display-inline-images)
                                            (error nil)))
          'append)

(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))

(define-skeleton skel-org-block-elisp
  "Insert an emacs-lisp block"
  ""
  "#+begin_src emacs-lisp\n"
  _ - \n
  "#+end_src\n")

(define-abbrev org-mode-abbrev-table "selisp" "" 'skel-org-block-elisp)

(define-skeleton skel-header-block
  "Creates my default header"
  ""
  "#+TITLE: " str "\n"
  "#+AUTHOR: James Fletcher\n"
  "#+EMAIL: m@jef.me.uk\n"
  "#+OPTIONS: toc:3 num:nil\n"
  "#+STYLE: <link rel=\"stylesheet\" type=\"text/css\" href=\"http://thomasf.github.io/solarized-css/solarized-light.min.css\" />\n")

(define-abbrev org-mode-abbrev-table "sheader" "" 'skel-header-block)

(setq org-ditaa-jar-path "~/Private/bin/ditaa.jar")

(setq org-plantuml-jar-path "~/Private/bin/plantuml.jar")

(setq deft-directory "~/Private/org/deft")
(setq deft-use-filename-as-title t)
(setq deft-extension "org")
(setq deft-text-mode 'org-mode)

(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

(setq column-number-mode t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(require 'autopair)

(require 'auto-complete-config)
(ac-config-default)

(setq flyspell-issue-welcome-flag nil)
(setq-default ispell-program-name "/usr/bin/aspell")
(setq ispell-local-dictionary "british")
(setq-default ispell-list-command "list")

(require 'shm)
  (add-hook 'haskell-mode-hook 'structured-haskell-mode)
;;  (set-face-background 'shm-current-face "NavyBlue")
;;  (set-face-background 'shm-quarantine-face "DarkSlateGray")

(load-theme 'wombat t)
(set-default-font "Terminus-10")
