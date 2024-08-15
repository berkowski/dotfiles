(define-module (zb packages mavlink)
    #:use-module (guix packages)
    #:use-module (guix download)
    #:use-module (guix git-download)
    #:use-module (guix build-system python)
    #:use-module (guix build-system pyproject)
    #:use-module ((guix licenses) #:prefix license:)
    #:use-module (gnu packages version-control)
    #:use-module (gnu packages python-xyz)
    #:use-module (gnu packages xml)
    #:use-module (gnu packages python-web)
    #:use-module (gnu packages image-processing)
    #:use-module (gnu packages game-development)
    #:use-module (gnu packages wxwidgets)
    #:use-module (gnu packages compression))

(define-public python-pymavlink
  (package
    (name "python-pymavlink")
    (version "2.4.41")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pymavlink" version))
       (sha256
        (base32 "1kb63z5slk6ywyakkixmdlfqma847n4gq6i5mcx101jxk372acpd"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-future python-lxml))
    (home-page "https://github.com/ArduPilot/pymavlink/")
    (synopsis "Python MAVLink code")
    (description "Python MAVLink code.")
    (license license:lgpl3)))

(define-public python-mavproxy
  (package
    (name "python-mavproxy")
    (version "1.8.70")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "MAVProxy" version))
       (sha256
        (base32 "07sa9rpiv2xh2rg9154jqc43nkljrk2drj9r27q1nv29bk9bx4jk"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-numpy 
                             python-pymavlink 
                             python-pyserial 
                             python-pygame 
                             python-lxml
                             python-matplotlib
                             python-wxpython))
    (inputs (list opencv))
    (home-page "https://github.com/ArduPilot/MAVProxy")
    (synopsis "MAVProxy MAVLink ground station")
    (description "MAVProxy MAVLink ground station.")
    (license license:gpl3)))

