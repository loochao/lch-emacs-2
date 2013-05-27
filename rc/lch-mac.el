;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; MAC
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
(message "=> lch-mac: loading...")

;;; Super-and-meta
;; Emacs users obviously have little need for Command and Option keys,
;; but they do need Meta and Super.
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'super)
  (setq mac-option-modifier 'meta))

;;; Spotlight-as-locate-OSX
(setq locate-command "mdfind")

;;; PATH-to-OSX
;; Fix path
;; Emacs does not always properly catch the system and user paths at
;; launch on OS X. I rely on code lifted from Aquamacs to fix this.
;; Cost: 1 second at launch time.
;; (require 'fixpath)

(defun my-add-path (path-element)
"Add the specified path element to the Emacs PATH"
   (interactive "DEnter directory to be added to path: ")
       (if (file-directory-p path-element)
          (setenv "PATH"
            (concat (expand-file-name path-element)
              path-separator (getenv "PATH")))))

(if (fboundp 'my-add-path)
    (let ((my-paths (list
                     "/opt/local/bin"
                     "/usr/local/bin"
                     "/usr/local/sbin"
                     "~/bin")))
      (dolist (path-to-add my-paths (getenv "PATH"))
        (my-add-path path-to-add))))

;;; Domain-name
;; Work around a bug on OS X where system-name is a fully qualified
(setq system-name (car (split-string system-name "\\.")))

;;; PROVIDE
(provide 'lch-mac)
(message "~~ lch-mac: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
