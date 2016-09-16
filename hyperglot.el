;;; hyperglot --- navigate hyperglotglot.org from emacs -*- lexical-binding: t -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/hyperglot
;; Package-Requires: 
;; Copyright (C) 2016, Noah Peart, all rights reserved.
;; Created: 16 September 2016

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:

;;  Navigate hyperpolyglot.org from emacs.

;;; Code:

(defgroup hyperglot nil
  "Jump around hyperpolyglot"
  :group 'convenience
  :prefix "hyperglot-")

(defvar hyperglot-rb nil)
(setq hyperglot-rb
      (when load-file-name
        (expand-file-name "build/main.rb" (file-name-directory load-file-name))))

;;;###autoload
(defun hyperglot (&optional arg)
  (interactive "P")
  (let* ((args (or arg (read-from-minibuffer "Hyperpolyglot lookup: ")))
         (out (shell-command-to-string (format "ruby %s %s" hyperglot-rb args))))
    (if (string-prefix-p "http://" out)
        (browse-url out)
      (let ((new-arg (ido-completing-read
                  "Section/ID: " (split-string out "\n" t "\\s-*"))))
        (hyperglot (concat args " " new-arg))))))

(provide 'hyperglot)

;;; hyperglot.el ends here
