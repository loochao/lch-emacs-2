;; -*- coding:utf-8; -*-

;;; ENVIRONMENTS
;;
;; Copyright (c) Charles Lu 2006-2011
;;
;; Author:  Charles Lu <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Environmental settings.

;;; CODE
(message "=> lch-env: loading...")
(setenv "LANG" "en_US.UTF-8" )
(setenv "LC_ALL" "en_US.UTF-8" )

;;; LOAD-PATH
;; emacs-dir defined in .emacs
(defconst emacs-lisp-dir (concat emacs-dir "/lisp"))
(defconst emacs-rc-dir (concat emacs-dir "/rc"))
(defconst emacs-lib-dir (concat emacs-dir "/lib"))
(defconst emacs-doc-dir (concat emacs-dir "/doc"))
(defconst emacs-info-dir (concat emacs-dir "/info"))

;; ;; If you have a pkg outside site-lisp
;; (mapc (lambda (path) (add-to-list 'load-path path))
;;       (append
;;        ;; essential
;;        (list emacs-rc-dir emacs-site-lisp)
;;        ;; optional -- put your pkg path here.
;;        ;; (list "/path/to/pkg")
;;        ))

;; Automatically add all the elisp in emacs.d/lisp into load-path
(defun lch-add-subdirs-to-load-path (dir)
 (let ((default-directory (concat dir "/")))
  (setq load-path (cons dir load-path))
  (normal-top-level-add-subdirs-to-load-path)))

(lch-add-subdirs-to-load-path emacs-lisp-dir)
(lch-add-subdirs-to-load-path emacs-rc-dir)

(when lch-mac-p
    (progn
      (setenv "PATH" (concat (getenv "PATH")
                             ":/usr/texbin"
                             ":/opt/local/bin"
                             ":/Applications/Documents/Emacs.app/Contents/MacOS/bin"
                             ":/Applications/Mathematics/MATLAB_R2010b.app/bin"
                             ))
      (setq exec-path (append exec-path
                              '(
                                "/Applications/Mathematics/MATLAB_R2010b.app/bin"
                                "/Applications/Documents/Emacs.app/Contents/MacOS/bin"
                                "/usr/texbin"
                                "/opt/local/bin"
                                "/usr/local/bin"
                                )))))

;;; FLAGs
(defconst lch-cygwin-p (eq system-type 'cygwin) "Are we on cygwin")
(defconst lch-mbp-win (and (eq system-type 'windows-nt) (string-match (system-name) "LCH-MBP")) "Are we on MBP-WIN?")
(defconst lch-mbp-x61 (and (eq system-type 'windows-nt) (string-match (system-name) "LCH-X61")) "Are we on X61")
(defconst lch-gnuemacs-p (string-match "GNU" (emacs-version)))
(defconst lch-xemacs-p (not lch-gnuemacs-p))
(defconst lch-aquamacs-p (string-match "Aquamacs" (emacs-version)))

(defconst is-before-emacs-21 (>= 21 emacs-major-version) "Is Emacs older than 21")
(defconst is-after-emacs-23  (<= 23 emacs-major-version) "Is Emacs newer than 23")


;;; VARs
(defconst git-dir (concat dropbox-path "/REPO/GIT") "git dir")
(setq emacs-var-dir (concat emacs-path "/.emacs.d/var"))
(if lch-aquamacs-p
    (setq custom-file (concat emacs-dir "/rc/lch-aqua-custom.el"))
    (setq custom-file (concat emacs-dir "/rc/lch-custom.el")))
(if (file-exists-p custom-file) (load-file custom-file))

(setq default-directory "~/")
;; (setq gnus-startup-file  (concat emacs-dir "/gnus/.gnus.el"))
;; (load (concat emacs-lib-dir "/emacs-starter-kit/init.el"))
;; (load (concat emacs-lib-dir "/conf/dea-read-only/.emacs"))


;;; INFO
;; (add-to-list 'Info-default-directory-list emacs-info-dir)
(dolist (dir `(,emacs-info-dir
               "/usr/share/lib/info"
               "/usr/local/share/lib/info"
               "~/local/share/info"))
  (add-to-list 'Info-default-directory-list dir))


;;; KEYMAP
(define-prefix-command 'm-f1-map)
(define-key global-map (kbd "M-<f1>") 'm-f1-map)

(define-prefix-command 'm-f2-map)
(define-key global-map (kbd "M-<f2>") 'm-f2-map)

(define-prefix-command 'm-k-map)
(define-key global-map (kbd "M-k") 'm-k-map)

(define-prefix-command 'm-8-map)
(define-key global-map (kbd "M-8") 'm-8-map)

(define-prefix-command 'f1-map)
(define-key global-map (kbd "<f1>") 'f1-map)

(define-prefix-command 'f2-map)
(define-key global-map (kbd "<f2>") 'f2-map)

(define-prefix-command 'f3-map)
(define-key global-map (kbd "<f3>") 'f3-map)

(define-prefix-command 'f4-map)
(define-key global-map (kbd "<f4>") 'f4-map)

(define-prefix-command 'f5-map)
(define-key global-map (kbd "<f5>") 'f5-map)

(define-prefix-command 'f6-map)
(define-key global-map (kbd "<f6>") 'f6-map)

(define-prefix-command 'f7-map)
(define-key global-map (kbd "<f7>") 'f7-map)

(define-prefix-command 'f8-map)
(define-key global-map (kbd "<f8>") 'f8-map)

(define-prefix-command 'f9-map)
(define-key global-map (kbd "<f9>") 'f9-map)

(define-prefix-command 'f10-map)
(define-key global-map (kbd "<f10>") 'f10-map)

(define-prefix-command 'ctrl-f10-map)
(define-key global-map (kbd "C-<f10>") 'ctrl-f10-map)

(define-prefix-command 'f11-map)
(define-key global-map (kbd "<f11>") 'f11-map)

(define-prefix-command 'f12-map)
(define-key global-map (kbd "<f12>") 'f12-map)

(define-prefix-command 'Ctrl-z-map)
(define-key global-map (kbd "C-z") 'Ctrl-z-map)

(define-prefix-command 'Ctrl-/-map)
(define-key global-map (kbd "C-/") 'Ctrl-/-map)

(define-prefix-command 'Super-z-map)
(define-key global-map (kbd "s-z") 'Super-z-map)

;;; PROVIDE
(provide 'lch-env)
(message "~~ lch-env: done.")

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; ispell-local-dictionary: "en_US"
;; End:
