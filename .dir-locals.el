;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((org-hugo-base-dir . "~/proj/notes.cashpw.com")
         (org-hugo-section . "posts")
         (eval . (setq-local
                  org-default-properties (append
                                          org-default-properties
                                          org-roam-recipe--properties)
                 org-roam-directory (if (file-exists-p (concat default-directory ".dir-locals.el"))
                                                        (expand-file-name (locate-dominating-file default-directory ".dir-locals.el"))
                                                    nil)
                  org-attach-directory (file-truename (format
                                         "%s/attachments/"
                                         org-roam-directory))
                  org-roam-db-location (expand-file-name "org-roam.db"
                                        org-roam-directory)
                  org-hugo-auto-set-lastmod t
                  org-directory org-roam-directory
                  cashpw/org-roam--file-path-exceptions-to-export-after-save `(,(format "%sunread.org"
                                                                                            org-roam-directory)
                                                                                   ,(format "%sunread.org_archive"
                                                                                            org-roam-directory))
                  cashpw/org-roam--file-path-exceptions-to-add-bibliography `(,(format "%sunread.org"
                                                                                           org-roam-directory)
                                                                                  ,(format "%sunread.org_archive"
                                                                                           org-roam-directory))))
         (eval .
               (add-hook
                'cashpw/org-mode-done-cut-hook
                'org-roam-file-p)
               )))

 (org-mode . ((eval . (setq-local
                       org-export-with-priority nil
                       org-export-with-todo-keywords nil))
              (eval . (progn


(defun cashpw/format-days-hours-minutes (days hours minutes)
  (string-join
   (remove nil
           `(
             ,(if (> days 0)
                  (s-lex-format "${days}d"))
             ,(if (> hours 0)
                  (s-lex-format "${hours}h"))
             ,(if (> minutes 0)
                  (s-lex-format "${minutes}m"))
             ))
   " "))

(defun cashpw/get-property (property)
  (save-excursion
    (goto-char (point-min))
    (org-entry-get (point)
                   property)))

(defun cashpw/split-aliases-to-string (roam-aliases)
  (mapcar
   (lambda (roam-alias)
     (downcase
      (replace-regexp-in-string
       "\""
       ""
       (replace-regexp-in-string
        " "
        "-"
        roam-alias))))
   (split-string roam-aliases
                 "\" \""
                 nil)))

(defun cashpw/get-aliases ()
  (interactive)
  (let* ((roam-aliases (cashpw/get-property "ROAM_ALIASES"))
         (aliases
          (if roam-aliases
              (cashpw/split-aliases-to-string
               roam-aliases)
            '())))
    (string-join
     (mapcar
      (lambda (roam-alias)
        (s-lex-format "/posts/${roam-alias}"))
      aliases)
     " ")))

(defun cashpw/org-hugo--get-custom-front-matter ()
  "Return custom front-matter as a string."
  (string-join (mapcar
                (lambda (item)
                  (destructuring-bind (label . value) item
                    (s-lex-format
                     ":${label} \"${value}\"")))
                (cl-remove-if (lambda (item)
                                (not (cdr item)))
                              `(("prep_time" . ,(org-recipe-get-prep-duration (point-min)))
                                ("cook_time" . ,(org-recipe-get-cook-duration (point-min)))
                                ("total_time" . ,(org-recipe-get-total-duration (point-min)))
                                ("servings" . ,(org-recipe-get-servings (point-min)))
                                ("yield" . ,(org-recipe-get-yield (point-min)))
                                ("slug" . ,(save-excursion
                                             (org-entry-get (point-min) "ID"))))))
               " "))

(defun cashpw/org-hugo--set-custom-front-matter ()
  "Set custom hugo front-matter."
  (org-roam-set-keyword "HUGO_CUSTOM_FRONT_MATTER"
                        (cashpw/org-hugo--get-custom-front-matter)))


                        (add-hook! 'before-save-hook
                                 :local
                                 #'cashpw/org-roam-before-save)
                    (add-hook! 'before-save-hook
                                 :local
                                 #'cashpw/org-set-last-modified)
                        (add-hook! 'before-save-hook
                                :local
                                #'cashpw/org-hugo--set-custom-front-matter))))))
