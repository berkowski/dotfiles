(define-module (zb guix packages kicad)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gl))

(define-public kicad-8
  (package
   (inherit kicad)
   (name "kicad")
   (version "8.0.5")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/kicad/code/kicad.git")
                  (commit version)))
            (sha256
             (base32
              "1g0w3g1gq6p72gg0jikdrh5mczcv5y16jmqi79bkp6nfl8gbx4l5"))
            (file-name (git-file-name name version))))
   (inputs (modify-inputs (package-inputs kicad)
			  (append libglvnd)
			  (append libgit2)
			  (append libsecret)))))

(define-public kicad-symbols-8
  (package
   (inherit kicad-symbols)
   (name "kicad-symbols")
   (version (package-version kicad-8))
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://gitlab.com/kicad/libraries/kicad-symbols.git")
		  (commit version)))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32
	      "12v8g48fgbalp0xrlgn3vm3ld79ymmwccv5aib6jz2qycdjxmznf"))))))

(define-public kicad-footprints-8
  (package
   (inherit kicad-symbols-8)
   (name "kicad-footprints")
   (version (package-version kicad-8))
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/kicad/libraries/kicad-footprints.git")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "0ixfiraahi09gvszzxsdz21mdr9wsxyby5qp3n57pzid42gs35a1"))))))

(define-public kicad-packages3d-8
  (package
   (inherit kicad-symbols-8)
   (name "kicad-packages3d")
   (version (package-version kicad-8))
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/kicad/libraries/kicad-packages3D.git")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "03yicqv36zx0wrb0njpkk45l4ysvv3dlsjlpi4j8j75gla060mai"))))))

(define-public kicad-templates-8
  (package
   (inherit kicad-symbols-8)
   (name "kicad-templates")
   (version (package-version kicad-8))
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/kicad/libraries/kicad-templates.git")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "03idwrk3vj9h2az8j8lqpbdbnfxdbkzh4db68kq3644yj3cnlcza"))))))

(define-public kicad-doc-8
  (package
   (inherit kicad-doc)
   (name "kicad-doc")
   (version (package-version kicad-8))
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/kicad/services/kicad-doc.git")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "1l4dsrmc6axw31v472i9p4g3yx1isn25a8drf6v6j85j6vs3y6h9"))))))

