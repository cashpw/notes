# roam-notes

My personal my personal notes and thoughts. Published at: [notes.cashpw.com](http://notes.cashpw.com)

## `unread.org`

A list of unread articles/etc pulled, in most part, from my starred items in [Inoreader](http://inoreader.com).

### Create New Roam Node

1. Move `point` onto the heading for which you want to create a node.
1. Run `cashpw/org-roam-new-node-from-link-heading-at-point` (see [Emacs configuration](https://github.com/cashpw/dotfiles/blob/main/config/doom/config.org))

### Add Stars From Inoreader

1. Click "Download full archive" in Inoreader and unzip the file.
1. Run 
    ```
    eval "$(cat starred.json | jq -r '.items[] | [ "printf", "* TODO [[%s][%s]] :unlabeled:\\n:PROPERTIES:\\n:CREATED: [%s]\\n:END:\\n", .canonical[0].href, .title, (.published | strftime("%Y-%m-%d %R")) ] | @sh')" | \
      sed 's/\(&rdquo;\|&ldquo;\|&quot;\)/"/g' | \
      sed 's/[“”]/"/g' | \
      sed "s/[’‘]/'/g" | \
      sed 's/&ndash;/-/g' \
      >> unread.org
    ```
1. Run
    ```
    #+begin_src emacs-lisp :results none
    (org-map-entries
     (lambda ()
       (org-fc-type-normal-init)
       (org-set-tags ":fc:reading:")
       (org-priority 2)
       ))
    #+end_src
    ```

## Workflow

Refer to my [Emacs configuration file](https://github.com/cashpw/dotfiles/blob/main/config/doom/config.org) for specific details; particularly, at time of writing, `cashpw/org-roam--mirror-roam-refs-to-front-matter` and my override for `org-hugo-export-wim-to-md-after-save`.
