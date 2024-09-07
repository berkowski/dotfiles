(define-module (zb guix home services shells)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (guix gexp))

(define-public home-shell-service-type
  (service home-bash-service-type))
