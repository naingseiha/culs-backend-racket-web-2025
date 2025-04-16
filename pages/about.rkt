#lang racket

(require web-server/http
         web-server/response
         "../templates/layout.rkt")

(define (about-page req)
  (render-page
   "About"
   @xhtml
   (div ((class "content"))
        (h1 "About This App")
        (p "This is a simple web application created to demonstrate Racket’s web capabilities.")
        (p "Built using:")
        (ul
         (li "Racket's built-in web server")
         (li "Modular file structure")
         (li "Reusable page templates")))))
