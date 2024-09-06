(define-module (zb guix systems base)
  #:use-module (zb guix substitutes)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu system)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(define %zb-zac-user
  (user-account
   (name "zac")
   (comment "Zac Berkowitz")
   (group "users")
   (supplementary-groups '("audio" "netdev" "video" "wheel" "dialout"))))

(define %zb-keyboard-layout
  (keyboard-layout "us"))

(define %zb-base-bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets (list "/boot/efi"))
   (keyboard-layout %zb-keyboard-layout)))

(define %zb-base-services
  (modify-services (cons* ;; (service firmware-service-type)
			  (service network-manager-service-type)
			  (service wpa-supplicant-service-type)
			  %base-services)
		   ;;(console-font-service-type config => (console-font-terminus config))
		   (guix-service-type config => (append-substitutes config))))

(define %zb-base-user-accounts
  (cons %zb-zac-user %base-user-accounts))

(define %zb-base-file-systems
  (cons* (file-system
          (mount-point "/tmp")
          (device "none")
          (type "tmpfs")
          (check? #f))
         %base-file-systems))

(define-public zb-base-os
  (operating-system
   (host-name "zb-guix")
   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout %zb-keyboard-layout)
   (bootloader %zb-base-bootloader)
   (kernel linux)
   (initrd microcode-initrd)
   (file-systems %zb-base-file-systems)
   (firmware (list linux-firmware))
   (services %zb-base-services)
   (users %zb-base-user-accounts)))
