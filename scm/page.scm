;;
;; page.scm -- implement Page stuff.
;;
;; source file of the GNU LilyPond music typesetter
;;
;; (c) 2006 Han-Wen Nienhuys <hanwen@xs4all.nl>
;;

(define-module (scm page)

  #:export (make-page
	    page-property
	    page-set-property!
	    page-prev
	    page-printable-height
	    layout->page-init
	    page-lines
	    page-force 
	    page-penalty
	    page-configuration
	    page-lines
	    page-page-number
	    page-system-numbers
	    page-stencil
	    page-free-height
	    page? 
	    ))

(use-modules (lily)
	     (scm paper-system)
	     (srfi srfi-1))


(define (annotate? layout)
  (eq? #t (ly:output-def-lookup layout 'annotatespacing)))


(define page-module (current-module))

(define (make-page init  . args)
  (let*
      ((p (apply ly:make-prob (append
			       (list 'page init)
			       args))))

    (page-set-property! p 'head-stencil (page-header p))
    (page-set-property! p 'foot-stencil (page-footer p))
    
    p))
	
(define page-property ly:prob-property)
(define page-set-property! ly:prob-set-property!)
(define (page-property? page sym)
  (eq? #t (page-property page sym)))
(define (page? x)  (ly:prob-type? x 'page))


;; define accessors. 
(for-each
 (lambda (j)
   (module-define!
    page-module
    (string->symbol (format "page-~a" j))
    (lambda (pg)
      (page-property pg j))))
 
 '(page-number prev lines force penalty lines))

(define (page-system-numbers page)
  (map (lambda (ps) (ly:prob-property ps 'number))
       (page-lines page)))

(define (page-translate-systems page)
  (for-each

   (lambda (sys-off)
     (let*
	 ((sys (car sys-off))
	  (off (cadr sys-off)))

       (if (not (number? (ly:prob-property sys 'Y-offset)))
	   (ly:prob-set-property! sys 'Y-offset off))))
   
   (zip (page-property page 'lines)
	(page-property page 'configuration))))

(define (annotate-page layout stencil)
  (let*
      ((topmargin (ly:output-def-lookup layout 'topmargin))
       (vsize (ly:output-def-lookup layout 'vsize))
       (bottommargin (ly:output-def-lookup layout 'bottommargin))
       (add-stencil (lambda (y)
		      (set! stencil
			    (ly:stencil-add stencil y))
		      )))

    (add-stencil
     (ly:stencil-translate-axis 
      (annotate-y-interval layout "vsize"
			   (cons (- vsize) 0)
			   #t)
      1 X))
    

    (add-stencil
     (ly:stencil-translate-axis 
      (annotate-y-interval layout "topmargin"
			   (cons (- topmargin) 0)
			   #t)
      2 X))
    
    (add-stencil
     (ly:stencil-translate-axis 
      (annotate-y-interval layout "bottommargin"
			   (cons (- vsize) (- bottommargin vsize))
			   #t)
      2 X))
    
    stencil))

(define (annotate-space-left page)
  (let*
      ((p-book (page-property page 'paper-book))
       (layout (ly:paper-book-paper p-book))
       (arrow (annotate-y-interval layout
				   "space left"
				   (cons (- (page-property page 'bottom-edge))
					 (page-property page  'bottom-system-edge))
				   #t)))

    (set! arrow (ly:stencil-translate-axis arrow 8 X))

    arrow))




(define (page-headfoot layout scopes number
		       sym separation-symbol dir last?)
  
  "Create a stencil including separating space."

  (let* ((header-proc (ly:output-def-lookup layout sym))
	 (sep (ly:output-def-lookup layout separation-symbol))
	 (stencil (ly:make-stencil "" '(0 . 0) '(0 . 0)))
	 (head-stencil
	  (if (procedure? header-proc)
	      (header-proc layout scopes number last?)
	      #f))
	 )
    
    (if (and (number? sep)
	     (ly:stencil? head-stencil)
	     (not (ly:stencil-empty? head-stencil)))

	(begin
	  (set! head-stencil
		(ly:stencil-combine-at-edge
		 stencil Y dir head-stencil
		 sep 0.0))

	  
	  ;; add arrow markers 
	  (if (or (annotate? layout)
		  (ly:output-def-lookup layout 'annotateheaders #f)) 
	      (set! head-stencil
		    (ly:stencil-add
		     (ly:stencil-translate-axis
		      (annotate-y-interval layout 
					   (symbol->string separation-symbol)
					   (cons (min 0 (* dir sep))
						 (max 0 (* dir sep)))
					   #t)
		      (/ (ly:output-def-lookup layout 'linewidth) 2)
		      X)
		     (if (= dir UP)
			 (ly:stencil-translate-axis
			  (annotate-y-interval layout
					      "pagetopspace"
					      (cons
					       (- (min 0 (* dir sep))
						  (ly:output-def-lookup layout 'pagetopspace))
					       (min 0 (* dir sep)))
					      #t)
			  (+ 7 (interval-center (ly:stencil-extent head-stencil X))) X)
			 empty-stencil
			 )
		     head-stencil
		     ))
	      )))

    head-stencil))

(define (page-header-or-footer page dir)
    (let*
      ((p-book (page-property page 'paper-book))
       (layout (ly:paper-book-paper p-book))
       (scopes (ly:paper-book-scopes p-book))
       (lines (page-lines page))
       (number (page-page-number page))
       (last? (page-property page 'is-last))
       )
       
      (page-headfoot layout scopes number
		(if (= dir UP)
		    'make-header
		    'make-footer)
		(if (= dir UP)
		    'headsep
		    'footsep)
		dir last?)))

(define (page-header page)
  (page-header-or-footer page UP))

(define (page-footer page)
  (page-header-or-footer page DOWN))

(define (layout->page-init layout)
  "Alist of settings for page layout"
  (let*
      ((vsize (ly:output-def-lookup layout 'vsize))
       (hsize (ly:output-def-lookup layout 'hsize))

       (lmargin (ly:output-def-lookup layout 'leftmargin))
       (leftmargin (if lmargin
		       lmargin
		       (/ (- hsize
			     (ly:output-def-lookup layout 'linewidth)) 2)))
       
       (bottom-edge (- vsize
		       (ly:output-def-lookup layout 'bottommargin)))
       (top-margin (ly:output-def-lookup layout 'topmargin))
       )
    
    `((vsize . ,vsize)
      (hsize . ,hsize)
      (left-margin . ,leftmargin)
      (top-margin . ,top-margin)
      (bottom-edge . ,bottom-edge)
      )))

(define (make-page-stencil page)
  "Construct a stencil representing the page from LINES.

 Offsets is a list of increasing numbers. They must be negated to
create offsets.
"

  

  (page-translate-systems page)
  (let*
      ((p-book (page-property page 'paper-book))
       (prop (lambda (sym) (page-property page sym)))
       (layout (ly:paper-book-paper p-book))
       (scopes (ly:paper-book-scopes p-book))
       (lines (page-lines page))
       (number (page-page-number page))

       ;; TODO: naming vsize/hsize not analogous to TeX.

       
       (system-xoffset (ly:output-def-lookup layout 'horizontalshift 0.0))
       (system-separator-markup (ly:output-def-lookup layout 'systemSeparatorMarkup))
       (system-separator-stencil (if (markup? system-separator-markup)
				     (interpret-markup layout
						       (layout-extract-page-properties layout)
						       system-separator-markup)
				     #f))
       
       (head-height (if (ly:stencil? (prop 'head-stencil))
			(interval-length (ly:stencil-extent (prop 'head-stencil) Y))
			0.0))

       (page-stencil (ly:make-stencil
		      '()
		      (cons (prop 'left-margin) (prop 'hsize))
		      (cons (- (prop 'top-margin)) 0)))

       (last-system #f)
       (last-y 0.0)
       (add-to-page (lambda (stencil x y)
		      (set! page-stencil
			    (ly:stencil-add page-stencil
					    (ly:stencil-translate stencil
								  (cons
								   (+ system-xoffset x)
								   (- 0 head-height y (prop 'top-margin)))

								  )))))
       (add-system
	(lambda (system)
	  (let* ((stencil (paper-system-stencil system))
		 (y (ly:prob-property system 'Y-offset))
		 (is-title (paper-system-title?
			    system)))
	    (add-to-page stencil
			 (ly:prob-property system 'X-offset 0.0)
			 y)
	    (if (and (ly:stencil? system-separator-stencil)
		     last-system
		     (not (paper-system-title? system))
		     (not (paper-system-title? last-system)))
		(add-to-page
		 system-separator-stencil
		 0
		 (average (- last-y
			     (car (paper-system-staff-extents last-system)))
			  (- y
			     (cdr (paper-system-staff-extents system))))))
	    (set! last-system system)
	    (set! last-y y))))
       (head (prop 'head-stencil))
       (foot (prop 'foot-stencil))
       )

    (if (or (annotate? layout)
	    (ly:output-def-lookup layout 'annotatesystems #f))

	(begin
	  (for-each (lambda (sys) (paper-system-annotate sys layout))
		    lines)
	  (paper-system-annotate-last (car (last-pair lines)) layout)))
    
    (set! page-stencil (ly:stencil-combine-at-edge
			page-stencil Y DOWN
			(if (and
			     (ly:stencil? head)
			     (not (ly:stencil-empty? head)))
			    head
			    (ly:make-stencil "" (cons 0 0) (cons 0 0)))
			    0. 0.))

    (map add-system lines)

    (ly:prob-set-property! page 'bottom-system-edge
			   (car (ly:stencil-extent page-stencil Y)))
    (ly:prob-set-property! page 'space-left
			   (car (ly:stencil-extent page-stencil Y)))

    (if (annotate? layout)
	(set! page-stencil
	      (ly:stencil-add page-stencil
			      (annotate-space-left page))))
    
    (if (and (ly:stencil? foot)
	     (not (ly:stencil-empty? foot)))
	(set! page-stencil
	      (ly:stencil-add
	       page-stencil
	       (ly:stencil-translate
		foot
		(cons 0
		      (+ (- (prop 'bottom-edge))
			 (- (car (ly:stencil-extent foot Y)))))))))

    (set! page-stencil
	  (ly:stencil-translate page-stencil (cons (prop 'left-margin) 0)))

    ;; annotation.
    (if (or (annotate? layout)
	    (ly:output-def-lookup layout 'annotatepage #f))
	(set! page-stencil (annotate-page layout page-stencil)))

    page-stencil))
              

(define (page-stencil page)
  (if (not (ly:stencil? (page-property page 'stencil)))

      ;; todo: make tweakable.
      ;; via property + callbacks.
      
      (page-set-property! page 'stencil (make-page-stencil page)))
  (page-property page 'stencil))

(define (calc-printable-height page)
  "Printable area for music and titles; matches default-page-make-stencil."
  (let*
      ((p-book (page-property page 'paper-book))
       (layout (ly:paper-book-paper p-book))
       (scopes (ly:paper-book-scopes p-book))
       (number (page-page-number page))
       (last? (page-property page 'is-last))
       (h (- (ly:output-def-lookup layout 'vsize)
	       (ly:output-def-lookup layout 'topmargin)
	       (ly:output-def-lookup layout 'bottommargin)))
       
       (head (page-property page 'head-stencil))
       (foot (page-property page 'foot-stencil))
       (available
	(- h (if (ly:stencil? head)
		 (interval-length (ly:stencil-extent head Y))
		 0)
	   (if (ly:stencil? foot)
	       (interval-length (ly:stencil-extent foot Y))
	       0))))
    
    ;; (display (list "\n available" available head foot))
    available))

(define (page-printable-height page)
  (if (not (number? (page-property page 'printable-height)))
      (page-set-property! page 'printable-height (calc-printable-height page)))
  
  (page-property page 'printable-height))

