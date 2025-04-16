#lang racket

(require web-server/http
         web-server/http/xexpr
         web-server/http/bindings
         web-server/servlet-env)

;; Define xexpr-response manually (fix for Racket 8.15)
(define (xexpr-response x)
  (response/xexpr x))

(define (home-page req)
  ;; Extract form data properly using request-bindings
  (define bindings
    (request-bindings/raw req))
  
  (define input-text 
    (if (exists-binding? 'input-text bindings)
        (extract-binding/single 'input-text bindings)
        #f))
  
  ;; Create the base content
  (define content
    `(html
      (head (title "Home - Racket Web App"))
      (body
       (div ((class "content"))
            (h1 "Welcome to Racket Web App")
            (p "Racket is a general-purpose, multi-paradigm programming language based on Scheme.")
            (h2 "Enter something below:")
            ;; Form for user input
            (form ((method "POST"))
                  (label "Enter some text: ")
                  (input ((type "text") (name "input-text")))
                  (button ((type "submit")) "Submit"))
            ,@(if input-text
                  `((p ,(string-append "You entered: " input-text)))
                  '())))))
  
  (xexpr-response content))

;; Start the server
(serve/servlet home-page
               #:port 8080
               #:servlet-path "/"
               #:launch-browser? #t)