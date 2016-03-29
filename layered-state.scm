; EECS 345 Project #2
; Jonah Raider-Roth (jer135)
; Zachary Palumbo (ztp3)

; Language: Pretty Big
; To run a program, run (interpret <filename>)

(load "layer.scm")

(define new-state '( ( () () ) ))
(define new-layer '(()()))
(define sample-state '(((x z)(2 4))((y a)(3 5))))

(define add-layer (lambda (state) (cons new-layer state)))
(define top-layer car)
(define other-layers cdr)

(define state-get
  (lambda (name state)
    (cond
      ((null? state) (error name "Unknown expression"))
      ((layer-get name (top-layer state)) (layer-get name (top-layer state))) ; if the top layer contains the variable, just return it
      (else (state-get name (other-layers state))))))

(define state-set
  (lambda (name value state)
    (cond
      ((null? state) (error name "Unknown expression"))
      ((layer-get name (top-layer state)) (cons (layer-set name value (top-layer state)) (other-layers state)))
      (else (cons (top-layer state) (state-set name value (other-layers state)))))))

(define state-declare
 (lambda (name state)
   (cons (layer-declare name (top-layer state)) (other-layers state))))

(define state-declare-and-set
  (lambda (name value state)
    (state-set name value (state-declare name state))))

(define state-add-bottom-return
  (lambda (value state)
    (cond
      ((null? (other-layers state)) (list (layer-add-return value (top-layer state))))
      (else (cons (top-layer state) (state-add-bottom-return value (other-layers state)))))))

(define state-add-bottom-break
  (lambda (state)
    (cond
      ((null? (other-layers state)) (list (layer-add-break (top-layer state))))
      (else (cons (top-layer state) (state-add-bottom-break (other-layers state)))))))

(define state-add-bottom-continue
  (lambda (state)
    (cond
      ((null? (other-layers state)) (list (layer-add-continue (top-layer state))))
      (else (cons (top-layer state) (state-add-bottom-continue (other-layers state)))))))

(define state-add-bottom-thrown
  (lambda (value state)
    (cond
      ((null? (other-layers state)) (list (layer-add-thrown value (top-layer state))))
      (else (cons (top-layer state) (state-add-bottom-thrown value (other-layers state)))))))

(define state-has-return?
  (lambda (state)
    (cond
      ((null? state) #f)
      ((layer-has-return? (top-layer state)) #t)
      (else (state-has-return? (other-layers state))))))

(define state-has-break?
  (lambda (state)
    (cond
      ((null? state) #f)
      ((layer-has-break? (top-layer state)) #t)
      (else (state-has-break? (other-layers state))))))

(define state-has-continue?
  (lambda (state)
    (cond
      ((null? state) #f)
      ((layer-has-continue? (top-layer state)) #t)
      (else (state-has-continue? (other-layers state))))))

(define state-has-thrown?
  (lambda (state)
    (cond
      ((null? state) #f)
      ((layer-has-thrown? (top-layer state)) #t)
      (else (state-has-thrown? (other-layers state))))))

(define state-remove-break
  (lambda (state)
    (cond
      ((null? state) (error "The state contains no break indicator."))
      ((layer-has-break? (top-layer state)) (list (layer-remove-break (top-layer state))))
      (else (cons (top-layer state) (state-remove-break (other-layers state)))))))

(define state-remove-continue
  (lambda (state)
    (cond
      ((null? state) (error "The state contains no continue indicator."))
      ((layer-has-continue? (top-layer state)) (list (layer-remove-continue (top-layer state))))
      (else (cons (top-layer state) (state-remove-continue (other-layers state)))))))