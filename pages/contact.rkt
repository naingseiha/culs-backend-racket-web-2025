#lang racket

(require "../templates/layout.rkt"
         web-server/http
         web-server/http/xexpr)


(define (contact-page req)
  (render-page
   "Contact"
   (div ((class "content"))
        (h1 "Contact Us")
        (p "You can contact us at: ")
        (ul
         (li "Email: contact@racketapp.com")
         (li "Twitter: @racketapp")))))
