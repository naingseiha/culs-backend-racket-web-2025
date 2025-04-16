#lang racket

(require web-server/http
         web-server/http/xexpr
         "../templates/layout.rkt")

;; define xexpr-response manually (fix for Racket 8.15)
(define (xexpr-response x)
  (response/xexpr x))

(define (home-page req)
  (xexpr-response
   (render-page
    "Home - Racket Web App"
    `(div ((class "content"))
          (h1 "Welcome to Racket Web App")
          (p "Racket is a general-purpose, multi-paradigm programming language based on Scheme.")
          (h2 "Key Features:")
          (ul
           (li "Powerful macro system")
           (li "Great for scripting, web development, and education")
           (li "Built-in web server")
           (li "Rich documentation and package system"))))))
