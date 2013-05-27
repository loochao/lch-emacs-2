;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; NETWORKIGURATION
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author:  Chao LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Control file of which one to load

;;; CODE
(message "=> lch-network: loading...")

;;; ERC
;; Part of GNU Emacs
(require 'erc)

;; utf-8 always and forever
(setq erc-server-coding-system '(utf-8 . utf-8))

(setq erc-nick "loochao")
(defun lch-erc-init ()
  "Connect to IRC."
  (interactive)
  ;;(when (y-or-n-p "Do you want to start IRC? ")
  (erc :server "irc.freenode.net" :port 6667 :nick erc-nick))
(define-key global-map (kbd "<f2> e") 'lch-erc-init)
(define-key global-map (kbd "<f6> <f6>") 'lch-erc-init)

(defun lch-erc-emacs ()
  (interactive)
  (try-to-switch-buffer "#emacs"))
(define-key global-map (kbd "<f6> e") 'lch-erc-emacs)

(defun lch-erc-quit ()
  (interactive)
  (kill-buffers-by-mode 'erc-mode))
(define-key global-map (kbd "<f6> q") 'lch-erc-quit)

;; Instead of #c, use ##c.
(setq erc-autojoin-channels-alist
      '(("freenode.net" "#emacs")))
;'(("freenode.net" "#emacs" "#perl" "#python" "#ruby" "#java" "##c")))
;; If you wanna join two servers at start
;; (erc :server "irc.freenode.net" :port 6667 :nick "yournick")
;; (erc :server "irc.oftc.net" :port 6667 :nick "yournick")

(defun filter-server-buffers ()
  (delq nil
        (mapcar
         (lambda (x) (and (erc-server-buffer-p x) x))
         (buffer-list))))

;; ERC-one-key-menu
(require 'one-key)

(defvar one-key-menu-irc-channel-alist nil
  "The `one-key' menu alist for IRC-CHANNEL.")

(setq one-key-menu-irc-channel-alist
      '(
        (("e" . "#emacs") . (lambda () (interactive) (try-to-switch-buffer "#emacs")))
        (("h" . "#haskell") . (lambda () (interactive) (try-to-switch-buffer "#haskell")))
        (("l" . "#lisp") . (lambda () (interactive) (try-to-switch-buffer "#lisp")))
        (("d" . "#debian") . (lambda () (interactive) (try-to-switch-buffer "#debian")))
        (("u" . "#ubuntu") . (lambda () (interactive) (try-to-switch-buffer "#ubuntu")))
        (("s" . "##English") . (lambda () (interactive) (try-to-switch-buffer "##English")))
        (("p" . "#python") . (lambda () (interactive) (try-to-switch-buffer "#python")))
	))

(defun one-key-menu-irc-channel ()
  "The `one-key' menu for IRC-CHANNEL."
  (interactive)
  (one-key-menu "IRC-CHANNEL" one-key-menu-irc-channel-alist t))
(define-key global-map (kbd "M-6") 'one-key-menu-irc-channel)
;;; SSH
;; use ssh through this mode will enable auto-completion
(require 'ssh)


;;; TRAMP
;; Transparent Remote Access, Multiple Protocols
;; Part of GNU Emacs
;; (other protocols than just FTP)
;; (info "(emacs)Remote Files")
;; (info "(tramp)Top")
;; (info "(tramp)Configuration")
;; (info "(tramp)Traces and Profiles")
;;
;; Example:
;; C-x C-f /method:user@host:/path/file
;; C-x C-f /ssh:loochao@server:/home/loochao/.bashrc
;; C-x C-f /plink:loochao@server:/home/loochao/.bashrc (from Windows)
;; C-x C-f /sudo:root@localhost:/etc/group
;; C-x C-f /su::/etc/hosts (Please note the double)
(require 'tramp)

;; Conf
(setq tramp-verbose 9)  ;default is 0

;; Default transfer method (info "(tramp)Default Method")
;; You might try out the `rsync' method, which saves the remote files
;; quite a bit faster than SSH. It's based on SSH, so it works the same,
;; just saves faster.
(setq tramp-default-method  ;`scpc' by default
      (cond (lch-win32-p
             ;; (issues with Cygwin `ssh' which does not cooperate with
             ;; Emacs processes -> use `plink' from PuTTY, it definitely
             ;; does work under Windows)
             ;; C-x C-f /plink:myuser@host:/some/directory/file
             "plink")
            (t
             "ssh")))

;; How many seconds passwords are cached
;; (info "(tramp)Password handling") for several connections
(setq password-cache-expiry 36000)  ;default is 16

;; Faster auto saves (info "(tramp)Auto-save and Backup") configuration
(setq tramp-auto-save-directory temporary-file-directory)

;;; PROVIDE
(provide 'lch-network)
(message "~~ lch-network: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
