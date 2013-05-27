;; -*- Emacs-Lisp -*-
;;; dired-extension.el ---

;; Copyright (C) 2013 wuxch zhengyu li
;;
;; Keywords: none

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This library mainly merges extensions from wuxch-dired-extension and emacs wiki

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'dired-extension)

;;; Code:

(require 'cl)
(require 'dired)
(require 'dired-aux)

(defface wuxch-dired-exe-face
  '((t (:foreground "RoyalBlue"))) "exe files")
(defface wuxch-dired-media-face
  '((t (:foreground "DeepPink"))) "media files")

(defvar dired-quickview-buffer nil)
(defvar static-wuxch-first-line-of-buffer)
(defvar static-wuxch-max-line-of-buffer)
(defvar dired-copied-cutted-files-pool nil
  "global variable to store copied or cutted files")
(defvar dired-is-copied nil "t:copy  nil:cut")
(defconst wuxch-dired-add-addtional-line 1)

(defun wuxch-dired-move-beginning-of-line (arg)
  ""
  (interactive "p")
  (move-beginning-of-line arg)
  (dired-move-to-filename))

(defun wuxch-dired-move-end-of-line (arg)
  ""
  (interactive "p")
  (move-end-of-line arg)
  (dired-move-to-filename))

(defun wuxch-dired-set-exe-face ()
  "wuxch-dired-set-exe-face:"
  (font-lock-add-keywords
   nil '(("^  .*\\.\\([eE][xX][eE]\\)$"
          (".+"
           (dired-move-to-filename)
           nil
           (0 'wuxch-dired-exe-face))))))

(defun wuxch-dired-set-media-face ()
  "wuxch-dired-set-media-face:"
  (font-lock-add-keywords
   nil '(("^  .*\\.\\([aA][vV][iI]\\|[mM][kK][vV]\\|[rR][mM][vV][bB]\\|[rR][mM]\\|[mM][pP]4\\|[mM][pP]3\\|[wW][mM][vV]\\|[wW][mM][aA]\\|[mM]4[vV]\\|[mM][oO][vV]\\)$"
          (".+"
           (dired-move-to-filename)
           nil
           (0 'wuxch-dired-media-face))))))

(defun wuxch-dired-mode-hook-fun ()
  "settingsfor dired file face"
  (wuxch-dired-set-exe-face)
  (wuxch-dired-set-media-face))

(defun do-wuxch-get-file-name (with-full-path only-path)
  ""
  (let ((clipboard))
    (if only-path
        (if (equal 'windows-nt system-type)
            (setq clipboard (dired-replace-in-string "/" "\\" (dired-current-directory)))
          (setq clipboard (dired-current-directory)))
      (let ((file (dired-get-file-for-visit)))
        (if with-full-path
            (progn
              (if (file-directory-p file)
                  (setq file (concat file "/")))
              (if(equal 'windows-nt system-type)
                  (setq clipboard (dired-replace-in-string "/" "\\" file))
                (setq clipboard file)))
          (if (file-directory-p file)
              (setq clipboard (file-name-nondirectory file))
            (setq clipboard (file-name-nondirectory file))))))

    (kill-new clipboard)
    (message "copy string \"%s\" to clipboard" clipboard)))

(defun wuxch-get-file-name-with-path ()
  ""
  (interactive)
  (do-wuxch-get-file-name t nil))

(defun wuxch-get-file-name-without-path ()
  ""
  (interactive)
  (do-wuxch-get-file-name nil nil))

(defun wuxch-get-file-name-only-path ()
  ""
  (interactive)
  (do-wuxch-get-file-name t t))

(defun wuxch-dired-tab-process ()
  "open a new dired window same as the current one"
  (interactive)
  (let ((buf (current-buffer)))
    (if (one-window-p)
        (progn
          (split-window-horizontally)
          (other-window 1)
          (set-window-buffer (selected-window) buf))
      (other-window 1))))

(defun wuxch-get-first-line-of-dired ()
  ""
  (if (local-variable-p 'static-wuxch-first-line-of-buffer)
      (progn)
    (progn
      (setq-default static-wuxch-first-line-of-buffer
                    (wuxch-get-first-line-of-dired-by-search-double-dot))
      (make-local-variable 'static-wuxch-first-line-of-buffer)))
  static-wuxch-first-line-of-buffer)

(defun wuxch-dired-max-line-by-count ()
  ""
  (+ (count-lines (point-min) (point-max)) wuxch-dired-add-addtional-line))

(defun wuxch-dired-max-line ()
  ""
  (if (local-variable-p 'static-wuxch-max-line-of-buffer)
      (progn)
    (progn
      (setq-default static-wuxch-max-line-of-buffer
                    (wuxch-dired-max-line-by-count))
      (make-local-variable 'static-wuxch-max-line-of-buffer)))
  (+ static-wuxch-max-line-of-buffer 0))

(defun update-dired-static-variables ()
  ""
  (save-excursion
    (if (local-variable-p 'static-wuxch-first-line-of-buffer)
        (kill-local-variable 'static-wuxch-first-line-of-buffer))
    (if (local-variable-p 'static-wuxch-max-line-of-buffer)
        (kill-local-variable 'static-wuxch-max-line-of-buffer))
    (setq-default static-wuxch-first-line-of-buffer
                  (wuxch-get-first-line-of-dired-by-search-double-dot))
    (make-local-variable 'static-wuxch-first-line-of-buffer)
    (setq-default static-wuxch-max-line-of-buffer (wuxch-dired-max-line-by-count))
    (make-local-variable 'static-wuxch-max-line-of-buffer)))

(defun wuxch-dired-revert ()
  ""
  (interactive)
  (revert-buffer)
  (update-dired-static-variables)
  (dired-move-to-filename))

(defun wuxch-get-first-line-of-dired-by-search-double-dot ()
  ""
  (goto-char (point-min))
  (if (search-forward ".." nil t)
      (+ (line-number-at-pos) 1)
    (+ (line-number-at-pos) 1)))

(defun wuxch-dired-goto-first-line ()
  "moving to the last line"
  (interactive)
  (goto-line (+ (wuxch-get-first-line-of-dired) 1))
  (dired-move-to-filename))

(defun wuxch-dired-goto-last-line ()
  "moving to the last line"
  (interactive)
  (goto-line (- (wuxch-dired-max-line) 1))
  (dired-move-to-filename))

(defun wuxch-dired-previous-line (arg)
  "moving to the previous line with wrapping"
  (interactive "p")
  (dired-previous-line arg)
  (let ((temp-current-line (line-number-at-pos))
        (temp-max-line (wuxch-dired-max-line))
        (temp-first-line-of-dried (wuxch-get-first-line-of-dired)))
    (goto-line temp-current-line)
    (dired-move-to-filename)
    (if (eq temp-current-line (- temp-first-line-of-dried 1))
        (progn
          (goto-line (- temp-max-line 1))
          (dired-move-to-filename)))))

(defun wuxch-dired-next-line (arg)
  "moving to the next line with wrapping"
  (interactive "p")
  (dired-next-line arg)
  (let ((temp-current-line (line-number-at-pos))
        (temp-max-line (wuxch-dired-max-line)))
    (if (eq temp-current-line temp-max-line)
        (progn
          (goto-line (wuxch-get-first-line-of-dired))
          (dired-move-to-filename)))))

(defun wuxch-dired-create-directory (directory)
  "Create a directory called DIRECTORY, with current date as suffix"
  (interactive
   (list (read-file-name "Create directory(with Date as suffix)): "
                         (dired-current-directory))))
  (let ((expanded (directory-file-name
                   (expand-file-name
                    (concat directory (format-time-string "%Y%m%d"))))))
    (make-directory expanded)
    (dired-add-file expanded)
    (dired-move-to-filename)))

(defun wuxch-dired-copy()
  ""
  (interactive)
  (wuxch-dired-do-copy-cut t))

(defun wuxch-dired-cut()
  ""
  (interactive)
  (wuxch-dired-do-copy-cut nil))

(defun wuxch-dired-do-copy-cut(is-copy)
  "wuxch-dired-do-copy-cut:"
  (wuxch-clear-copied-cutted-files-pool)
  (wuxch-put-marked-files-name-to-pool)
  (let ((copy-cut-string)(num (safe-length dired-copied-cutted-files-pool)))
    (setq dired-is-copied is-copy)
    (if is-copy
        (setq copy-cut-string "copied")
      (setq copy-cut-string "cut"))
    (if (eq num 1)
        (progn
          (message "%s is %s" (car dired-copied-cutted-files-pool) copy-cut-string))
      (progn
        (message "%d file/dir(s) %s" num copy-cut-string)))))

(defun wuxch-dired-paste()
  "wuxch-dired-paste:"
  (interactive)
  (if (not (eq dired-copied-cutted-files-pool nil))
      (let ((copy-cut-string)
            (current-file-number 0)
            (file-number (safe-length dired-copied-cutted-files-pool)))
        (if dired-is-copied
            (setq copy-cut-string "copied")
          (setq copy-cut-string "moved"))
        (dolist (src-file dired-copied-cutted-files-pool)
          (let ((dst-file))
            (setq dst-file (concat (dired-current-directory)
                                   (file-name-nondirectory src-file)))
            (if dired-is-copied
                (dired-copy-file src-file dst-file t)
              (dired-rename-file src-file dst-file t))
            ;; revert buffer
            (wuxch-dired-revert)
            (dired-goto-file dst-file)
            ;; 不mark
            ;; (dired-mark-files-regexp (file-name-nondirectory src-file))
            ;; show some information
            (setq current-file-number (+ current-file-number 1))
            (message "%d of %d file/dir(s) %s"
                     current-file-number file-number copy-cut-string)))
        (if (not dired-is-copied)
            (wuxch-clear-copied-cutted-files-pool)))))

(defun wuxch-clear-copied-cutted-files-pool()
  "wuxch-clear-copied-cutted-files-pool: clear the pool if it's not nil"
  (if (not (eq dired-copied-cutted-files-pool nil))
      (progn
        (setq dired-copied-cutted-files-pool nil))))

(defun wuxch-put-marked-files-name-to-pool()
  "wuxch-put-marked-files-name-to-pool:"
  (let ((files))
    (setq files (dired-get-marked-files t))
    (if (listp files)
        (dolist (element files)
          (setq dired-copied-cutted-files-pool
                (append dired-copied-cutted-files-pool
                        (list (concat (dired-current-directory) element))))))))

(defun his-dired-sort ()
  "show directories first in dired mode"
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2)
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (set-buffer-modified-p nil))

(defun dired-sort-by-size ()
  "sort by Size"
  (interactive)
  (dired-sort-other (concat dired-listing-switches "S")))

(defun dired-sort-by-extension ()
  "sort by eXtension"
  (interactive)
  (dired-sort-other (concat dired-listing-switches "X")))

(defun dired-sort-by-time ()
  "sort by Time"
  (interactive)
  (dired-sort-other (concat dired-listing-switches "t")))

(defun dired-sort-by-name ()
  "sort by Name"
  (interactive)
  (dired-sort-other dired-listing-switches))

(defun dired-scroll-half-page-backward ()
  "Scroll backward a \"half page\" lines in dired-mode.
See also `dired-scroll-half-page-forward'."
  (interactive)
  (call-interactively 'View-scroll-half-page-backward)
  (dired-move-to-filename))

(defun dired-scroll-half-page-forward ()
  "Scroll forward a \"half page\" lines in dired-mode.
See also `dired-scroll-half-page-backward'."
  (interactive)
  (call-interactively 'View-scroll-half-page-forward)
  (dired-move-to-filename))

(defun dired-scroll-up ()
  "Scroll up in dired-mode.
See also `dired-scroll-down'."
  (interactive)
  (call-interactively 'scroll-up)
  (dired-move-to-filename))

(defun dired-scroll-down ()
  "Scroll down in dired-mode.
See also `dired-scroll-down'."
  (interactive)
  (call-interactively 'scroll-down)
  (dired-move-to-filename))

(defun dired-filter-regexp (regexp &optional arg)
  "dired mode filter display"
  (interactive
   (list (dired-read-regexp
          (concat (if current-prefix-arg "Not show " "Only show ") "(Regexp): "))
         current-prefix-arg))
  (dired-mark-files-regexp regexp)
  (or arg (if (fboundp 'dired-do-toggle) (dired-do-toggle) (dired-toggle-marks)))
  (dired-do-kill-lines))

(defun dired-filter-extension (extension &optional arg)
  "dired mode filter extension display"
  (interactive
   (list (read-from-minibuffer
          (concat "Show with (extension)" (if current-prefix-arg "" "") ": "))
         current-prefix-arg))
  (dired-filter-regexp (concat "\\." extension "\\'") arg))

(defun dired-quickview ()
  "dired quickview"
  (interactive)
  (if (buffer-live-p dired-quickview-buffer)
      (kill-buffer dired-quickview-buffer))
  (setq dired-quickview-buffer
        (find-file-noselect (dired-get-file-for-visit)))
  (display-buffer dired-quickview-buffer))

(defun dired-up-directory-same-buffer ()
  "Goto parent directory in the smae buffer."
  (interactive)
  (let* ((dir (dired-current-directory))
         (dir-file-name (directory-file-name dir)))
    (unless (string= dir dir-file-name)
      (find-alternate-file "..")
      (dired-goto-file dir-file-name))))

(defadvice dired-run-shell-command (around dired-run-shell-command-async activate)
  "Postfix COMMAND argument of `dired-run-shell-command' with an ampersand.
If there is none yet, so that it is run asynchronously."
  (let* ((cmd (ad-get-arg 0))
         (cmd-length (length cmd))
         (last-cmd-char (substring cmd
                                   (max 0 (- cmd-length 1))
                                   cmd-length)))
    (unless (string= last-cmd-char "&")
      (ad-set-arg 0 (concat cmd "&")))
    (save-window-excursion ad-do-it)))

(defun dired-get-size ()
  "Get total size of marked files with `du' command.
If not marked any files, default is current file or directory."
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*\\(total\\|总用量\\)$")
                 (match-string 1))))))

(defun dired-up-directory-single ()
  "Return up directory in single window.
When others visible window haven't current buffer, kill old buffer after `dired-up-directory'.
Otherwise, just `dired-up-directory'."
  (interactive)
  (let ((old-buffer (current-buffer))
        (current-window (selected-window)))
    (dired-up-directory)
    (catch 'found
      (walk-windows
       (lambda (w)
         (with-selected-window w
           (when (and (not (eq current-window (selected-window)))
                      (equal old-buffer (current-buffer)))
             (throw 'found "Found current dired buffer in others visible window.")))))
      (kill-buffer old-buffer))))

(defun dired-gnome-open-file ()
  "Opens the current file in a Dired buffer."
  (interactive)
  (gnome-open-file (dired-get-file-for-visit)))

(defun gnome-open-file (filename)
  "gnome-opens the specified file."
  (interactive "fFile to open: ")
  (let ((process-connection-type nil))
    (start-process "" nil "/usr/bin/gnome-open" filename)))

;;; provide features
(provide 'dired-extension)

;;; dired-extension.el ends here
