#lang racket

(provide render-page)

(define (render-page title body-content)
  `(html
    (head
     (title ,title)
     (link ((rel "stylesheet") (href "/style.css"))))
    (body
     (nav ((class "navbar"))
          (a ((href "/home")) "Home") " | "
          (a ((href "/info")) "Information") " | "
          (a ((href "/about")) "About") " | "
          (a ((href "/contact")) "Contact"))
     ,body-content
     (footer ((class "footer"))
             (p "© 2025 Racket Web App")))))
