(define-module (zb guix packages kakoune)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages text-editors))

(define-public zb/kakoune
  (package
    (inherit kakoune)
    ;; (name "kakoune-sp")
    (native-search-paths
      (list (search-path-specification
              (variable "KAKOUNE_RUNTIME")
              (files (list "share/kak")))))))
