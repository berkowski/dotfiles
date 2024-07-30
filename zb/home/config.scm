(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services sound)
             (gnu home services shells)
             (gnu services)
             (guix gexp))

(use-package-modules text-editors)

(home-environment
 ;; (packages (list (specification->package "pavucontrol")))
 (services
  (list
   (service home-fish-service-type
            (home-fish-configuration
             (environment-variables
              `(("EDITOR" . ,(file-append kakoune "/bin/kak"))))))
   (service home-dbus-service-type)
   (service home-pipewire-service-type))))
