; Definition of backend properties (aka. element properties).

;; See documentation of Item::visibility_lambda_
(define (begin-of-line-visible d) (if (= d 1) '(#f . #f) '(#t . #t)))
(define (spanbar-begin-of-line-invisible d) (if (= d -1) '(#t . #t) '(#f . #f)))
(define (all-visible d) '(#f . #f))
(define (all-invisible d) '(#t . #t))
(define (begin-of-line-invisible d) (if (= d 1) '(#t . #t) '(#f . #f)))
(define (end-of-line-invisible d) (if (= d -1) '(#t . #t) '(#f . #f)))


(define mark-visibility end-of-line-invisible)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  BEAMS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (default-beam-space-function multiplicity)
  (if (<= multiplicity 3) 0.816 0.844)
  )

;
; width in staff space.
;
(define (default-beam-flag-width-function type)
  (cond
   ((eq? type 1) 1.98)
   ((eq? type 1) 1.65)
   (else 1.32)
   ))


; This is a mess : global namespace pollution. We should wait
;  till guile has proper toplevel environment support.


;; Beams should be prevented to conflict with the stafflines, 
;; especially at small slopes
;;    ----------------------------------------------------------
;;                                                   ########
;;                                        ########
;;                             ########
;;    --------------########------------------------------------
;;       ########
;;
;;       hang       straddle   sit        inter      hang

;; inter seems to be a modern quirk, we don't use that

  
;; Note: quanting period is take as quants.top () - quants[0], 
;; which should be 1 (== 1 interline)
(define (mean a b) (* 0.5 (+ a  b)))
(define (default-beam-dy-quants beam stafflinethick)
  (let ((thick (ly-get-elt-property beam 'thickness))
	)
    
    (list 0 (mean thick stafflinethick) (+ thick stafflinethick) 1)
    ))

;; two popular veritcal beam quantings
;; see params.ly: #'beam-vertical-quants

; (todo: merge these 2 funcs ? )

(define (default-beam-y-quants beam multiplicity dy staff-line)
  (let* ((beam-straddle 0)
	 (thick (ly-get-elt-property beam 'thickness))
	 (beam-sit (/ (+ thick staff-line) 2))
	 (beam-hang (- 1 (/ (- thick staff-line) 2)))
	 (quants (list beam-hang))
	 )
    
    (if (or (<= multiplicity 1) (>= (abs dy) (/ staff-line 2)))
	(set! quants (cons beam-sit quants)))
    (if (or (<= multiplicity 2) (>= (abs dy) (/ staff-line 2)))
	(set! quants (cons beam-straddle quants)))
    ;; period: 1 (interline)
    (append quants (list (+ 1 (car quants))))))

(define (beam-traditional-y-quants beam multiplicity dy staff-line)
  (let* ((beam-straddle 0)
	(thick (ly-get-elt-property beam 'thickness))
	(beam-sit (/ (+ thick staff-line) 2))
	(beam-hang (- 1 (/ (- thick staff-line) 2)))
	(quants '())
	)
    (if (>= dy (/ staff-line -2))
	(set! quants (cons beam-hang quants)))
    (if (and (<= multiplicity 1) (<= dy (/ staff-line 2)))
	(set! quants (cons beam-sit quants)))
    (if (or (<= multiplicity 2) (>= (abs dy) (/ staff-line 2)))
	(set! quants (cons beam-straddle quants)))
    ;; period: 1 (interline)
    (append quants (list (+ 1 (car quants))))))


;; There are several ways to calculate the direction of a beam
;;
;; * majority: number count of up or down notes
;; * mean    : mean centre distance of all notes
;; * median  : mean centre distance weighted per note

(define (dir-compare up down)
  (sign (- up down)))

;; arguments are in the form (up . down)
(define (beam-dir-majority count total)
  (dir-compare (car count) (cdr count)))

(define (beam-dir-mean count total)
  (dir-compare (car total) (cdr total)))

(define (beam-dir-median count total)
  (if (and (> (car count) 0)
	   (> (cdr count) 0))
      (dir-compare (/ (car total) (car count)) (/ (cdr total) (cdr count)))
      (dir-compare (car count) (cdr count))))
	    


;; [Ross] states that the majority of the notes dictates the
;; direction (and not the mean of "center distance")
;;
;; But is that because it really looks better, or because he wants
;; to provide some real simple hands-on rules?
;;     
;; We have our doubts, so we simply provide all sensible alternatives.





;; array index multiplicity, last if index>size
;; beamed stems


;; TODO
;;  - take #forced stems into account (now done in C++)?
;;  - take y-position of chord or beam into account

;;;;;;;;;;;;;;;;;;;;;;;


;
; todo: clean this up a bit: the list is getting rather long.
; 
(define basic-beam-properties
  `(
    (interfaces . (beam-interface))
    (molecule-callback . ,Beam::brew_molecule)
    (thickness . 0.42) ; in staff-space, should use stafflinethick?
    (before-line-breaking-callback . ,Beam::before_line_breaking)
    (after-line-breaking-callback . ,Beam::after_line_breaking)
    (default-neutral-direction . 1)
    (dir-function . ,beam-dir-majority)
    (height-quants .  ,default-beam-dy-quants)
    (vertical-position-quant-function . ,default-beam-y-quants)
    (beamed-stem-shorten . (0.5))
    (outer-stem-length-limit . 0.2)
    (slope-limit . 0.2)
    (flag-width-function . ,default-beam-flag-width-function)
    (space-function . ,default-beam-space-function)
    (damping . 1)
    (name . "beam")
    )
  )
