;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; LCH-W3M-UTIL
;; Author:  Charles LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Collected from web and modified.
;; No copyright.

;;; CODE
;;; W3m-search
(defvar w3m-search-advance-prettyfy-string-length 25
  "The length of `SEARCH-OBJECT' show in function `w3m-search-advance'.")

(defun w3m-search-advance (search-url prompt-string
                                      &optional coding
                                      prefix-input-string postfix-input-string
                                      search-url-follow search-url-last
                                      foreground
                                      upcase-p downcase-p capitalize-p)
  "Advance w3m search function.
Default, if mark active, will set `SEARCH-OBJECT' with current mark region,
otherwise, set current word to `SEARCH-OBJECT'.

Set `SEARCH-URL' for special search.
Set `PROMPT-STRING' to prompt to user.
If `CODING' is set, encode `SEARCH-OBJECT' with this coding, default is nil.
`PREFIX-INPUT-STRING' is for add before `SEARCH-OBJECT'
`POSTFIX-INPUT-STRING' is for append after `SEARCH-OBJECT'
`SEARCH-URL-FOLLOW' is a url that follow `SEARCH-URL' for decorate
`SEARCH-URL-LAST' is a url that at last for decorate `SEARCH-URL'.
If `FOREGROUND' is non-nil, make search page open foreground, otherwise search in background.
If `UPCASE-P' is non-nil, upcase `SEARCH-OBJECT'.
If `downcase-p' is non-nil, downcase `SEARCH-OBJECT'.
If `capitalize-p' is non-nil, capitalize `SEARCH-OBJECT'."
  (let (search-string
        input-string)
    (setq search-string
          (if mark-active
              ;; when mark active get mark region
              (prog1
                  (buffer-substring (region-beginning) (region-end))
                (deactivate-mark))
            ;; or get current word
            (current-word)))
    ;; kill `search-string' for make user can edit it convenient
    ;; If you want to edit `search-string' by default when input in `read-string'
    ;; just use `w3m-search-advance-insert-search-object' yank and edit. :)
    (if search-string
        (setq w3m-search-advance-search-object search-string)
      (setq search-string ""))
    (setq input-string (read-string (concat prompt-string
                                            (format " (%-s): " (prettyfy-string
                                                                search-string w3m-search-advance-prettyfy-string-length)))))
    ;; set `input-string' with `search-string' if user input nothing
    (if (equal input-string "")
        (setq input-string search-string))
    ;; `input-string' transform.
    (setq input-string
          (cond (upcase-p
                 (upcase input-string))
                (downcase-p
                 (downcase input-string))
                (capitalize-p
                 (capitalize input-string))
                (t input-string)))
    ;; encode `input-string' with `coding'
    (or prefix-input-string (setq prefix-input-string ""))
    (or postfix-input-string (setq postfix-input-string ""))
    (or search-url-follow (setq search-url-follow ""))
    (or search-url-last (setq search-url-last ""))
    (setq input-string (w3m-url-encode-string (concat prefix-input-string input-string postfix-input-string) coding))
    (setq search-url (concat search-url search-url-follow input-string search-url-last))
    (if foreground
        (w3m-browse-url search-url t)         ;search foreground
      (w3m-view-this-url-1 search-url nil t)) ;search background
    ))

(defun w3m-search-slang ()
  "Translate input word and search from urbandictionary.com."
  (interactive)
  (w3m-search-advance "http://www.urbandictionary.com/define.php?term=" "English Slang" 'utf-8))

(defun w3m-search-dict-cn ()
  "Translate input word and search from dict.cn."
  (interactive)
  (w3m-search-advance "http://dict.cn/search/?q=" "English Dict.cn" 'gbk))

(defun w3m-search-google-code ()
  "Use Google Code search for WHAT."
  (interactive)
  (w3m-search-advance "http://www.google.com/codesearch?hl=zh-CN&lr=&q=" "Google Code" 'utf-8))

(defun w3m-search-google-lucky ()
  "Use Google Lucky search for WHAT."
  (interactive)
  (w3m-search-advance "http://www.google.com/search?btnI=I%27m+Feeling+Lucky&q=" "Google Lucky" 'utf-8))

(defun w3m-search-google-image ()
  "Use Google image search for WHAT."
  (interactive)
  (w3m-search-advance "http://images.google.com/images?sa=N&tab=wi&q=" "Google Image" 'utf-8))

(defun w3m-search-google-blog-cn ()
  "Use Google (Chinese) blog search for WHAT."
  (interactive)
  (w3m-search-advance "http://blogsearch.google.com/blogsearch?hl=zh-CN&ie=UTF-8&oe=UTF-8&q=" "Google Blog CN" 'utf-8))

(defun w3m-search-google-blog-en ()
  "Use Google (English) blog search for WHAT."
  (interactive)
  (w3m-search-advance "http://blogsearch.google.com/blogsearch?hl=en&ie=UTF-8&oe=UTF-8&q=" "Google Blog EN" 'utf-8))

(defun w3m-search-google-group ()
  "Use Google group search for WHAT."
  (interactive)
  (w3m-search-advance "http://groups.google.com/groups?hl=zh-CN&ie=UTF-8&oe=UTF-8&q=" "Google Group" 'utf-8))

(defun w3m-search-google-file ()
  "Use Google to search for a file named FILE.
This function add little Google search syntax, make search file simply.
Example, your want search pdf of chm about Emacs, you just type emacs pdf|chm."
  (interactive)
  (w3m-search-advance "http://www.google.com/search?&ie=UTF-8&oe=UTF-8&q=" "Google File" 'utf-8
                      "+intitle:(\"index of\"\|\"last modified\"\|\"parent of\") -inurl:htm -inurl:html -inurl:php -inurl:asp "))

(defun w3m-search-baidu-mp3 ()
  "Search mp3 from mp3.baidu.com."
  (interactive)
  (w3m-search-advance "http://mp3.baidu.com/m?f=ms&tn=baidump3&ct=134217728&lf=&rn=&lm=0&word=" "Baidu Mp3 Search" 'gbk))

(defun w3m-search-google-music ()
  "Search music from http://www.google.cn/music/."
  (interactive)
  (w3m-search-advance "http://www.google.cn/music/search?q=" "Google Music" 'utf-8))

(defun w3m-search-emacswiki ()
  "Search from EmacsWiki's Google Custom Search."
  (interactive)
  (w3m-search-advance "http://www.google.com/cse?cx=004774160799092323420:6-ff2s0o6yi&q=" "Emacswiki" 'utf-8))

(defun w3m-search-emacswiki-random ()
  "Get the random pages from emacswiki."
  (interactive)
  (w3m-view-this-url-1 "http://www.emacswiki.org/cgi-bin/wiki?action=random" nil t))

(defun w3m-search-haskell-wiki ()
  "Search from HaskellWiki's Google Custom Search."
  (interactive)
  (w3m-search-advance "http://www.google.com/cse?cx=014102838545582129901%3Anhonl7a8bw8&q=" "Haskell Wiki" 'utf-8))

(defun w3m-search-rfc-number ()
  "Search RFC number from www.ietf.org."
  (interactive)
  (w3m-search-advance "http://www.ietf.org/rfc/rfc" "RFC Number" 'utf-8 nil ".txt"))

(defun w3m-search-lispdoc-basic ()
  "Search object in lispdoc.com with `basic-search'."
  (interactive)
  (w3m-search-advance "http://lispdoc.com?q=" "Lispdoc basic search" nil nil nil nil "&search=Basic+search/"))

(defun w3m-search-lispdoc-full ()
  "Search object in lispdoc.com with `full-search'."
  (interactive)
  (w3m-search-advance "http://lispdoc.com?q=" "Lispdoc basic search" nil nil nil nil "&search=Full+search/"))

(defun w3m-search-google-web-cn ()
  "Search object in www.google.cn."
  (interactive)
  (w3m-search-advance "http://www.google.cn/search?&hl=zh-CN&lr=lang_zh-CN%7Clang_zh-TW&inlang=zh-CN&q=" "Google Web CN" 'utf-8))

(defun w3m-search-google-web-en ()
  "Use Google (English) to search for WHAT."
  (interactive)
  (w3m-search-advance "http://www.google.com/search?&ie=UTF-8&oe=UTF-8&q=" "Google Web EN" 'utf-8))

(defun w3m-search-answers ()
  "Search object in www.answers.com."
  (interactive)
  (w3m-search-advance "http://www.answers.com/" "answers.com" 'utf-8))

(defun w3m-search-haskell-hoogle ()
  "Search object in haskell.org/hoogle/."
  (interactive)
  (w3m-search-advance "http://haskell.org/hoogle/?hoogle=" "Haskell Hoogle" 'utf-8))

(defun w3m-search-wikipedia-cn ()
  "Search object in zh.wikipedia.org."
  (interactive)
  (w3m-search-advance "http://zh.wikipedia.org/wiki/" "zh.wikipedia.org" 'utf-8))

(defun w3m-search-wikipedia-en ()
  "Search object in en.wikipedia.org."
  (interactive)
  (w3m-search-advance "http://en.wikipedia.org/wiki/" "en.wikipedia.org" 'utf-8))

(defun w3m-search-google-news-cn-Sci/Tech ()
  "Look up Google technology news."
  (interactive)
  (w3m-view-this-url-1 "http://news.google.cn/nwshp?tab=wn&ned=tcn&topic=t" nil t))

(defun w3m-search-google-news-en-Sci/Tech ()
  "Use Google news search for WHAT."
  (interactive)
  (w3m-view-this-url-1 "http://news.google.com/news?ned=tus&topic=t" nil t))

;;; PROVIDE
(provide 'lch-w3m-util)


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
