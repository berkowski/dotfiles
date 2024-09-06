(use-modules (zb guix systems desktop)
	     (gnu))

(define %agemochi-swap-space
  (swap-space (target (uuid "c0da19ae-e309-46f3-9f10-7e26383f5754"))))

(define %agemochi-file-system-boot
  (file-system (mount-point "/boot/efi")
	       (device (uuid "80F9-1DF2" 'fat16))
	       (type "vfat")))

(define %agemochi-file-system-root
  (file-system (mount-point "/")
               (device (uuid "b20fccfb-010d-4a57-8edd-994724b4ad0c" 'ext4))
               (type "ext4")))
  
(operating-system
 (inherit zb-sway-os)
 (host-name "agemochi")
 (swap-devices (list %agemochi-swap-space))
 (file-systems (cons* %agemochi-file-system-boot
		      %agemochi-file-system-root
		      %base-file-systems)))


