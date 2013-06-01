;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; WEB
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
;; Configuration of network related applications.

;;; CODE
(message "=> lch-web: loading...")

(require 'lch-key-util)
;;; W3M
(require 'w3m)
;; (setq w3-default-stylesheet "~/.default.css")
;; (defvar w3m-buffer-name-prefix "*w3m" "Name prefix of w3m buffer")
;; (defvar w3m-buffer-name (concat w3m-buffer-name-prefix "*") "Name of w3m buffer")
;; (defvar w3m-bookmark-buffer-name (concat w3m-buffer-name-prefix "-bookmark*") "Name of w3m buffer")

;;; Setting
(defvar w3m-dir (concat emacs-var-dir "/w3m") "Dir of w3m.")

(setq w3m-icon-directory (concat w3m-dir "/icons"))
(setq w3m-default-save-directory "~/Downloads")

(setq w3m-use-cookies t)
(setq w3m-home-page "http://www.princeton.edu/~chaol")
(setq w3m-use-favicon nil)

(setq w3m-bookmark-file (concat w3m-dir "/w3m-bookmark.html"))
(setq w3m-cookie-file (concat w3m-dir "/w3m-cookie"))
(setq w3m-session-file (concat w3m-dir "/w3m-session"))

(setq w3m-session-load-crashed-sessions t)              
(setq w3m-session-deleted-save nil)                     
(setq w3m-session-time-format "%Y-%m-%d (%a) %H:%M")
(setq w3m-use-header-line-title t)
(add-hook 'w3m-display-hook
          (lambda (url)
            (rename-buffer
             (format "*w3m: %s*"
                     (beautify-string (or w3m-current-title
                                          w3m-current-url) 50)) t)))
;; (setq w3m-session-time-format "%Y-%m-%d %A %H:%M")
;;; Browse-url
;; Set browse function to be w3m
;; (setq browse-url-browser-function 'w3m-browse-url)
;; (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(defun firefox-browse-url (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process (concat "open -a Firefox" url) nil "open" url))

(defun chrome-browse-url (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process (concat "open -a Chrome" url) nil "open" url))
(setq browse-url-browser-function 'chrome-browse-url)

(defun safari-browse-url (url &optional new-window)
  (do-applescript
   (format
    "tell application \"Safari\"
	open location \"%s\"
end tell"
    url)))

;;; Util
(defun w3m-new-tab ()
  (interactive)
  (w3m-copy-buffer nil nil nil t))
(define-key w3m-mode-map (kbd "C-t") 'w3m-new-tab)

(defun lch-w3m-init ()
  "Switch to an existing w3m buffer or look at bookmarks."
  (interactive)
  (let ((buf (get-buffer "*w3m*")))
    (if buf
        (switch-to-buffer buf)
      (progn 
        (w3m)
        ;; (w3m-bookmark-view)
        )
      )))
(define-key global-map (kbd "<f3> <f3>") 'lch-w3m-init)

(defun lch-google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))
(define-key global-map (kbd "<f3> g") 'lch-google)

(defun beautify-string (string &optional after)
  "Strip starting and ending whitespace and beautify `STRING'.
Replace any chars after AFTER with '...'.
Argument STRING the string that need beauty."
  (let ((replace-map (list
                      (cons "^[ \t]*" "")
                      (cons "[ \t]*$" "")
                      (cons (concat "^\\(.\\{"
                                    (or (number-to-string after) "10")
                                    "\\}\\).*")
                            "\\1..."))))
    (dolist (replace replace-map)
      (when (string-match (car replace) string)
        (setq string (replace-match (cdr replace) nil nil string))))
    string))

(defun lch-view-current-url-external ()
  (interactive)
  (chrome-browse-url w3m-current-url))

(defun w3m-view-this-url-background-session ()
  (interactive)
  (let ((in-background-state w3m-new-session-in-background))
    (setq w3m-new-session-in-background t)
    (w3m-view-this-url-new-session)
    (setq w3m-new-session-in-background in-background-state)))

;;; Desktop
;; Use desktop to save w3m buffer between sessions.
(defun w3m-register-desktop-save ()
  "Set `desktop-save-buffer' to a function returning the current URL."
  (setq desktop-save-buffer (lambda (desktop-dirname) w3m-current-url)))

(add-hook 'w3m-mode-hook 'w3m-register-desktop-save)

(defun w3m-restore-desktop-buffer (d-b-file-name d-b-name d-b-misc)
  "Restore a `w3m' buffer on `desktop' load."
  (when (eq 'w3m-mode desktop-buffer-major-mode)
    (let ((url d-b-misc))
      (when url
        (require 'w3m)
        (if (string-match "^file" url)
            (w3m-find-file (substring url 7))
          (w3m-goto-url-new-session url))
        (current-buffer)))))

(add-to-list 'desktop-buffer-mode-handlers '(w3m-mode . w3m-restore-desktop-buffer))
;;; Binding
(lch-set-key
 '(
   ("C-<return>" . w3m-view-this-url-background-session)

   ("C-6" . w3m-view-parent-page)
   ("^" . w3m-view-parent-page)

   ("7" . w3m-previous-buffer)
   ("8" . w3m-next-buffer)

   ("[" . w3m-view-previous-page)
   ("]" . w3m-view-next-page)

   (";" . w3m-previous-buffer)
   ("'" . w3m-next-buffer)

   ("." . w3m-next-form)
   ("," . w3m-previous-form)

   ("/" . w3m-print-current-url)
   ("d" . w3m-delete-buffer)

   ("g" . w3m-search-google-web-en)

   ("H" . w3m-history)
   ("M-h" . w3m-db-history)

   ("m" . w3m-scroll-down-or-previous-url)

   ("n" . w3m-next-anchor)
   ("p" . w3m-previous-anchor)
   
   ("o" . w3m-goto-url)
   ("C-o" . lch-view-current-url-external)

   ("s" . one-key-menu-w3m-search)
   ("t" . w3m-new-tab)
   ("C-t" . w3m-new-tab)
   )
 w3m-mode-map
 )
;;; Search
;; File that contains the search func
(require 'lch-w3m-util)
(define-key global-map (kbd "<f7> <f7>") 'w3m-search-dict-cn)
(define-key global-map (kbd "<f7> <f8>") 'w3m-search-slang)
(defvar one-key-menu-w3m-search-alist nil
  "The `one-key' menu alist for W3M-SEARCH.")

(setq one-key-menu-w3m-search-alist
      '(
        (("a" . "Answer") . w3m-search-answers)
        (("b" . "Google Blog CN") . w3m-search-google-blog-cn)
        (("B" . "Google Blog EN") . w3m-search-google-blog-en)
        (("e" . "Google Web EN") . w3m-search-google-web-en)
        (("c" . "Google Code") . w3m-search-google-code)
        (("d" . "Dict CN") . w3m-search-dict-cn)
        (("D" . "Slang") . w3m-search-slang)
        (("f" . "Google File") . w3m-search-google-file)
        (("l" . "Lispdoc Basic") . w3m-search-lispdoc-basic)
        ;;(("L" . "Lispdoc Full") . w3m-search-lispdoc-full)
        (("L" . "Google Lucky") . w3m-search-google-lucky)
        (("g" . "Google Web CN") . w3m-search-google-web-cn)
        (("G" . "Google Group") . w3m-search-google-group)
        (("m" . "BaiDu MP3") . w3m-search-baidu-mp3)
        (("M" . "Google Music Search") . w3m-search-google-music)
        (("i" . "Google Image") . w3m-search-google-image)
        (("w" . "Emacs Wiki") . w3m-search-emacswiki)
        (("p" . "Wikipedia CN") . w3m-search-wikipedia-cn)
        (("P" . "Wikipedia EN") . w3m-search-wikipedia-en)
        (("r" . "Emacs Wiki Random") . w3m-search-emacswiki-random)
        (("t" . "Google News Sci/Tech CN") . w3m-search-google-news-cn-Sci/Tech)
        (("T" . "Google News Sci/Tech EN") . w3m-search-google-news-en-Sci/Tech)
        ))

(defun one-key-menu-w3m-search ()
  "The `one-key' menu for W3M-SEARCH."
  (interactive)
  (one-key-menu "W3M-SEARCH" one-key-menu-w3m-search-alist t nil nil
                '(lambda ()
                   (interactive)
                   (unless (eq major-mode 'w3m-mode)
                     (w3m)))))
(define-key global-map (kbd "<f3> s") 'one-key-menu-w3m-search)
;;; PROVIDE
(provide 'lch-web)
(message "~~ lch-web: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
