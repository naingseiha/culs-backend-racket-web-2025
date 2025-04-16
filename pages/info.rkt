#lang racket

(require "../templates/layout.rkt"
         web-server/http
         web-server/http/xexpr)

(define (xexpr-response x)
  (response/xexpr x))

(define (info-page req)
  (xexpr-response
   (render-page
    "Information - Racket Web App"
    `(div ((class "content"))
          (h1 "Information Page")
          (p "Learn more about Racket and its features.")))))
