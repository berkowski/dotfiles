;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(define-module (zb systems base)
    #:use-module (gnu)
    #:use-module (nongnu packages linux)
    #:use-module (nongnu system linux-initrd))

(use-service-modules cups desktop networking ssh xorg)
(use-package-modules shells gnome)

(define-public base-operating-system
  (operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "agemochi")
  ;; (packages (cons* fish %base-packages))

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "zac")
                  (comment "Zac")
                  (group "users")
                  (home-directory "/home/zac")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "dialout")))
                %base-user-accounts))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service gnome-desktop-service-type)

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service openssh-service-type)
                 (service cups-service-type)
                 (service bluetooth-service-type
                          (bluetooth-configuration
                           (auto-enable? #t)))
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           (modify-services %desktop-services
             (guix-service-type config => 
                                (guix-configuration
                                 (inherit config)
                                 (substitute-urls
                                  (append (list "https://substitutes.nonguix.org")
                                          %default-substitute-urls))
                                 (authorized-keys
                                  (append (list (plain-file "nonguix.pub" "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                          %default-authorized-guix-keys))))

              (gdm-service-type config => (gdm-configuration
                 (inherit config)
                 (wayland? #t)
                 (auto-suspend? #f))))))
 
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  
  (file-systems (cons*
                 (file-system
                  (mount-point "/tmp")
                  (device "none")
                  (type "tmpfs")
                  (check? #f))
                 %base-file-systems))))
