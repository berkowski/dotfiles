(use-modules (zb guix systems desktop)
	     (gnu))

(define %mochi-swap-space
  (swap-space (target (uuid "3350c476-c1b8-437b-8dde-ab57ae6f10bf"))))

(define %mochi-file-system-boot
  (file-system (mount-point "/boot/efi")
	       (device (uuid "8376-1DED" 'fat16))
	       (type "vfat")))

(define %mochi-file-system-root
  (file-system (mount-point "/")
               (device (uuid "e458208c-a917-429d-8147-476386324a51" 'ext4))
               (type "ext4")))
  
(operating-system
 (inherit zb-sway-os)
 (host-name "mochi")
 (swap-devices (list %mochi-swap-space))
 (file-systems (cons* %mochi-file-system-boot
		      %mochi-file-system-root
		      %base-file-systems)))


