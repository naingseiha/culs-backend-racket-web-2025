#lang racket

(require web-server/servlet
         web-server/servlet-env
         "pages/home.rkt"
         "pages/info.rkt"
         "pages/contact.rkt"
         "pages/about.rkt")

(define-values (start dispatcher)
  (dispatch-rules
   [("home") home-page]
   [("info") info-page]
   [("contact") contact-page]
   [("about") about-page]
   [else home-page]))

(serve/servlet dispatcher
               #:launch-browser? #t
               #:servlet-path "/"
               #:port 8080
               #:servlet-regexp #rx""
               #:extra-files-paths (list "static"))
