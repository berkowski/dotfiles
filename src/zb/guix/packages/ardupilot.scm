(define-module (zb guix packages ardupilot)
    #:use-module (guix packages)
    #:use-module (guix download)
    #:use-module (guix git-download)
    #:use-module (guix build-system waf)
    #:use-module (guix build-system python)
    #:use-module (guix build-system pyproject)
    #:use-module (guix utils)
    #:use-module (guix gexp)
    #:use-module ((guix licenses) #:prefix license:)
    #:use-module (gnu packages version-control)
    #:use-module (gnu packages python-xyz)
    #:use-module (gnu packages python-web)
    #:use-module (gnu packages image-processing)
    #:use-module (gnu packages game-development)
    #:use-module (gnu packages wxwidgets)
    #:use-module (gnu packages xml)
    #:use-module (zb guix packages mavlink))

(define-public python-ratelim
  (package
    (name "python-ratelim")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ratelim" version))
       (sha256
        (base32 "07dirdd8y23706110nb0lfz5pzbrcvd9y74h64la3y8igqbk4vc2"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-decorator))
    (home-page "http://github.com/themiurgo/ratelim")
    (synopsis "Makes it easy to respect rate limits.")
    (description "Makes it easy to respect rate limits.")
    (license license:expat)))

(define-public python-geocoder
  (package
    (name "python-geocoder")
    (version "1.38.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "geocoder" version))
       (sha256
        (base32 "1rvpgapvwxhclw6g04gh2gcp26gaz3k0jfs0xq57smv1r5s574n9"))))
    (build-system pyproject-build-system)
    (arguments
      `(#:tests? #f))
    (propagated-inputs (list python-click python-future python-ratelim
                             python-requests python-six))
    (home-page "https://github.com/DenisCarriere/geocoder")
    (synopsis "Geocoder is a simple and consistent geocoding library.")
    (description "Geocoder is a simple and consistent geocoding library.")
    (license license:expat)))

(define-public ardupilot-rover
    (package 
       (name "ardupilot-rover")
       (version "4.5.5")
       (source 
          (origin 
             (method git-fetch)
             (uri (git-reference 
                     (url "https://github.com/ArduPilot/ardupilot.git")
                     (commit (string-append (string-titlecase "rover") "-" version))
                     (recursive? #t)))
             (sha256
                (base32
                   "1qzm9p8skakz5sah327rrxlfslg70d4nwkx9s1ww66i9phawfb3r"))
             (modules '((guix build utils)))
             (snippet
               '(begin (substitute* "Tools/ardupilotwaf/git_submodule.py"
                                    (("return _git_head_hash.+$") "return \"9064e22\"\n"))))))
       (build-system waf-build-system)
       (arguments
          `(#:configure-flags (list "--board=linux")
            #:phases (modify-phases %standard-phases
                        (replace 'build
                                 (lambda* _ (apply invoke "python" "waf" "rover" '()))))))
        
       (native-inputs (list git python-empy))
       (propagated-inputs (list python-pexpect
                                python-geocoder
                                python-ptyprocess
                                python-mavproxy
                                python-lxml
                                python-future))

       (synopsis "A reliable open source autopilot")
       (description "A reliable open source autopilot")
       (home-page "https://ardupilot.org")
       (license #f)))

