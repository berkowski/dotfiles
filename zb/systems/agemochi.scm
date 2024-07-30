(define-module (zb systems agemochi)
  #:use-module (zb systems base)
  #:use-module (gnu)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems))

(operating-system
 (inherit base-operating-system)
 (host-name "agemochi")

 (swap-devices (list (swap-space
                        (target (uuid
                                 "c0da19ae-e309-46f3-9f10-7e26383f5754")))))

 (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "80F9-1DF2"
                                       'fat16))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "b20fccfb-010d-4a57-8edd-994724b4ad0c"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))


