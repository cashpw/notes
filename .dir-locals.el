;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((org-hugo-base-dir . "~/proj/notes.cashpw.com")
         (org-hugo-section . "posts")
         (eval . (setq-local
                  org-default-properties '("PREP_MINUTES"
                                           "COOK_MINUTES"
                                           "SERVINGS"
                                           "STARS")
                 org-roam-directory (if (file-exists-p (concat default-directory ".dir-locals.el"))
                                                        (expand-file-name (locate-dominating-file default-directory ".dir-locals.el"))
                                                    nil)
                  org-attach-directory (file-truename (format
                                         "%s/attachments/"
                                         org-roam-directory))
                  org-roam-db-location (expand-file-name "org-roam.db"
                                        org-roam-directory)
                  org-hugo-auto-set-lastmod t
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

(defun cashpw/get-prep-minutes ()
  (string-to-number (or (save-excursion
                          (goto-char (point-min))
                          (org-entry-get (point)
                                         "PREP_MINUTES"))
                        "0")))

(defun cashpw/get-cook-minutes ()
  (string-to-number (or (save-excursion
                          (goto-char (point-min))
                          (org-entry-get (point)
                                         "COOK_MINUTES"))
                        "0")))

(defun cashpw/get-cook-time ()
  (let ((cook-minutes (cashpw/get-cook-minutes)))
    (cashpw/get-recipe-time cook-minutes)))

(defun cashpw/get-prep-time ()
  (let ((prep-minutes (cashpw/get-prep-minutes)))
    (cashpw/get-recipe-time prep-minutes)))

(defun cashpw/get-total-time ()
  (let* ((prep-minutes (cashpw/get-prep-minutes))
        (cook-minutes (cashpw/get-cook-minutes))
        (total-minutes (+ prep-minutes
                          cook-minutes)))
    (cashpw/get-recipe-time total-minutes)))

(defun cashpw/get-recipe-time (minutes)
  (let* ((minutes-in-hour 60)
         (minutes-in-day (* 24
                            minutes-in-hour))
         (days (/ minutes
                  minutes-in-day))
         (minutes (if days
                      (- minutes
                         (* minutes-in-day
                            days))
                    minutes))
         (hours (/ minutes
                   minutes-in-hour))
         (minutes (if hours
                      (- minutes
                         (* minutes-in-hour
                            hours))
                    minutes)))
    (cashpw/format-days-hours-minutes days
                                            hours
                                            minutes)))

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

(defun cashpw/set-custom-front-matter ()
  (interactive)
  (let* ((prep-time (cashpw/get-prep-time))
         (cook-time (cashpw/get-cook-time))
         (total-time (cashpw/get-total-time))
         (servings (cashpw/get-property "SERVINGS"))
         (id (cashpw/get-property "ID"))
         ;; (aliases (cashpw/get-aliases))
         (stars (cashpw/get-property "STARS"))
         (front-matter (-filter
                        (lambda (item)
                          (destructuring-bind (label . value) item
                            (length> value 0)))
                        `(("prep_time" . ,prep-time)
                          ("cook_time" . ,cook-time)
                          ("total_time" . ,total-time)
                          ("servings" . ,servings)
                          ;; ("aliases" . ,aliases)
                          ("slug" . ,id)
                          ("stars" . ,stars)
                          ))))
    (cashpw/org-hugo--set-custom-front-matter
     (string-join
      (mapcar
       (lambda (item)
         (destructuring-bind (label . value) item
           (s-lex-format
            ":${label} \"${value}\"")))
       front-matter)
      " "))))


                        ;; (org-hugo-auto-export-mode)
                        ;; (cashpw/enable-anki-editor-mode)
                        (add-hook! 'before-save-hook
                                 :local
                                 #'cashpw/org-roam-before-save)
                    (add-hook! 'before-save-hook
                                 :local
                                 #'cashpw/org-set-last-modified)
                        (add-hook! 'before-save-hook
                                :local
                                #'cashpw/set-custom-front-matter))))))
