#lang racket

(require web-server/http
         web-server/http/xexpr
         web-server/http/bindings
         web-server/servlet-env)

;; Function to calculate BMI
(define (calculate-bmi weight height)
  (if (> height 0)
      (/ weight (* height height))
      0))

;; Function to interpret BMI value
(define (interpret-bmi bmi)
  (cond
    [(< bmi 18.5) "Underweight"]
    [(< bmi 25) "Normal weight"]
    [(< bmi 30) "Overweight"]
    [else "Obese"]))

;; Function to render BMI result
(define (render-bmi-result weight height)
  (let* ([bmi (calculate-bmi weight height)]
         [category (interpret-bmi bmi)])
    `(div ((class "result"))
          (h2 "Your BMI Result")
          (p ,(format "BMI: ~a" (real->decimal-string bmi 2)))
          (p ,(format "Category: ~a" category))
          (p ((class "description"))
             ,(format "A BMI of ~a is considered ~a." 
                      (real->decimal-string bmi 2) 
                      (string-downcase category))))))

;; Helper function to format decimal numbers (fixed implementation without string-position)
(define (real->decimal-string n places)
  (define str (number->string (exact->inexact n)))
  (define parts (string-split str "."))
  
  (if (= (length parts) 2)
      (let* ([int-part (first parts)]
             [dec-part (second parts)]
             [needed-length (min places (string-length dec-part))]
             [trimmed-dec (substring dec-part 0 needed-length)]
             [padding (make-string (max 0 (- places needed-length)) #\0)])
        (string-append int-part "." trimmed-dec padding))
      (string-append str "." (make-string places #\0))))

;; Add current date and user information to the page
(define (get-current-date)
  (let* ([now (current-seconds)]
         [date (seconds->date now #t)]  ;; #t for UTC time
         [year (date-year date)]
         [month (date-month date)]
         [day (date-day date)]
         [hour (date-hour date)]
         [minute (date-minute date)]
         [second (date-second date)])
    (format "~a-~a-~a ~a:~a:~a" 
            year
            (if (< month 10) (format "0~a" month) month)
            (if (< day 10) (format "0~a" day) day)
            (if (< hour 10) (format "0~a" hour) hour)
            (if (< minute 10) (format "0~a" minute) minute)
            (if (< second 10) (format "0~a" second) second))))

;; Main handler function
(define (bmi-app req)
  ;; Extract form data
  (define bindings
    (request-bindings/raw req))
  
  (define weight-str
    (if (exists-binding? 'weight bindings)
        (extract-binding/single 'weight bindings)
        ""))
  
  (define height-str
    (if (exists-binding? 'height bindings)
        (extract-binding/single 'height bindings)
        ""))
  
  ;; Convert to numbers if possible
  (define weight 
    (if (and (not (string=? weight-str ""))
             (string->number weight-str))
        (string->number weight-str)
        0))
  
  (define height 
    (if (and (not (string=? height-str ""))
             (string->number height-str))
        (string->number height-str)
        0))
  
  ;; Check if we have valid input
  (define have-valid-input?
    (and (> weight 0) (> height 0)))
  
  ;; Current date and user info
  (define current-date (get-current-date))
  (define current-user "naingseiha")
  
  ;; Create the HTML response
  (define content
    `(html
      (head 
       (title "BMI Calculator")
       (style 
        "body { font-family: Arial, sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 20px; }
         h1 { color: #333; }
         .form-group { margin-bottom: 15px; }
         label { display: block; margin-bottom: 5px; font-weight: bold; }
         input { padding: 8px; width: 100%; box-sizing: border-box; }
         button { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; cursor: pointer; }
         button:hover { background-color: #45a049; }
         .result { margin-top: 20px; padding: 15px; background-color: #f2f2f2; border-radius: 5px; }
         .note { color: #666; font-size: 0.9em; margin-top: 20px; }
         .error { color: red; }
         .user-info { background-color: #f8f9fa; padding: 10px; border-radius: 5px; margin-bottom: 20px; }"))
      (body
       (div ((class "user-info"))
            (p ,(format "Current Date and Time (UTC): ~a" current-date))
            (p ,(format "Current User: ~a" current-user)))
            
       (h1 "BMI Calculator")
       (p "Calculate your Body Mass Index (BMI) by entering your weight in kilograms and height in meters.")
       (form ((method "POST"))
             (div ((class "form-group"))
                  (label "Weight (kg): ")
                  (input ((type "text") (name "weight") (value ,weight-str) (placeholder "Enter weight"))))
             (div ((class "form-group"))
                  (label "Height (m): ")
                  (input ((type "text") (name "height") (value ,height-str) (placeholder "Enter height (e.g., 1.75)"))))
             (button ((type "submit")) "Calculate BMI"))
       
       ,@(if have-valid-input?
             (list (render-bmi-result weight height))
             (if (and (not (string=? weight-str "")) (not (string=? height-str "")))
                 '((p ((class "error")) "Please enter valid weight and height values."))
                 '()))
       
       (div ((class "note"))
            (h3 "About BMI")
            (p "Body Mass Index (BMI) is a simple calculation using a person's height and weight. The formula is BMI = kg/m2 where kg is a person's weight in kilograms and m2 is their height in meters squared.")
            (p "BMI Categories:")
            (ul
             (li "Underweight: Below 18.5")
             (li "Normal weight: 18.5 - 24.9")
             (li "Overweight: 25 - 29.9")
             (li "Obesity: 30 or higher"))
            (p "Note: BMI is a screening tool and does not diagnose body fatness or health.")))))
  
  (response/xexpr content))

;; Start the server
(serve/servlet bmi-app
               #:port 8080
               #:servlet-path "/"
               #:launch-browser? #t)