
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))

(deftemplate state-list
   (slot current)
   (multislot sequence))

(deffacts startup
   (state-list))

;;;****************
;;;* STARTUP RULE *
;;;****************


(defrule system-banner ""

  =>

  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))
;;;==================================================================================
(defrule q-startowe

	(logical (start))

   =>

   (assert (UI-state (display StartQuestion)
                     (relation-asserted startowe)
                     (response Bankroll)
                     (valid-answers Bankroll Whining Neverlookup Smashes Onephone)))
)
;;;==================================================================================
(defrule q-Bankroll
	(or 	(logical (startowe Bankroll))
		(logical (Whining WhiningStop)))
   =>
   (assert (UI-state (display Bankroll)
                     (relation-asserted Bankroll)
                     (response Half)
                     (valid-answers Half BankrollYes BankrollNo)))
)
(defrule q-Whining
   (logical (startowe Whining))

   =>

   (assert (UI-state (display Whining)
                     (relation-asserted Whining)
                     (response WhiningYes)
                     (valid-answers WhiningYes WhiningNo WhiningStop)))
)

(defrule q-Neverlookup
   (logical (startowe Neverlookup))

   =>

   (assert (UI-state (display Neverlookup)
                     (relation-asserted Neverlookup)
                     (response NeverlookupYes)
                     (valid-answers NeverlookupYes NeverlookupNo)))
)
(defrule q-Neverlookup
   (logical (startowe Neverlookup))

   =>

   (assert (UI-state (display Neverlookup)
                     (relation-asserted Neverlookup)
                     (response NeverlookupYes)
                     (valid-answers NeverlookupYes NeverlookupNo)))
)
(defrule q-Smashes
   (logical (startowe Smashes))

   =>

   (assert (UI-state (display Smashes)
                     (relation-asserted Smashes)
                     (response SmashesMyPhone)
                     (valid-answers SmashesMyPhone SmashesExcuse SmashesFine)))
)
(defrule q-Onephone
   (logical (startowe Onephone))

   =>

   (assert (UI-state (display Onephone)
                     (relation-asserted Onephone)
                     (response OnephoneDude)
                     (valid-answers OnephoneDude)))
)
;;;==================================================================================
(defrule q-HardEarned
   (or (and (logical (startowe Bankroll)) (logical (Bankroll Half)))
	(and (logical(startowe Bankroll)) (logical(Bankroll BankrollYes)))
	(and (logical (Whining WhiningStop)) (logical (Bankroll Half)))
	(and (logical(Whining WhiningStop)) (logical(Bankroll BankrollYes)))
	)

   =>

   (assert (UI-state (display HardEarned)
                     (relation-asserted HardEarned)
                     (response HardEarnedGestIt)
                     (valid-answers HardEarnedGestIt HumanATM)))
)

(defrule q-HAHA
(or (logical (Neverlookup NeverlookupYes)))

   =>
   (assert (UI-state (display HAHA)
                     (relation-asserted HAHA)
                     (response HAHAYEAH)
                     (valid-answers HAHAYEAH HAHAangel)))
)
(defrule q-HAHA2
 ?x <- (UrgentCalls UrgentCallsAgreement)

   =>
   (retract ?x)
   (assert (UI-state (display HAHA)
                     (relation-asserted HAHA)
                     (response HAHAYEAH)
                     (valid-answers HAHAYEAH HAHAangel)))
)
(defrule q-LITERALLYlosing
(or 		(and 	(logical (startowe Neverlookup))
			        (logical(Neverlookup NeverlookupNo)))

		    (and    (logical (startowe Neverlookup))
   			        (logical (Neverlookup NeverlookupYes))
			        (logical (HAHA HAHAYEAH))
			        (logical (UrgentCalls UrgentCallsNo)))
)
   =>
   (assert (UI-state (display LITERALLYlosing)
                     (relation-asserted LITERALLYlosing)
		     (response LITERALLYlosingHangOn)
                     (valid-answers LITERALLYlosingHangOn LITERALLYlosingSHUTDOWN)))
)
(defrule q-ShockedLost
(or 		(and 	(logical (startowe Neverlookup))
			        (logical(Neverlookup NeverlookupNo))
			(or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
				    (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
				)
			)

		    (and    (logical (startowe Neverlookup))
   			        (logical (Neverlookup NeverlookupYes))
			        (logical (HAHA HAHAYEAH))
			        (logical (UrgentCalls UrgentCallsNo))
			        (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
				            (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
				        )
			)
)
   =>
   (assert (UI-state (display ShockedLost)
                     (relation-asserted ShockedLost)
		     (response ShockedLostGuessNot)
                     (valid-answers ShockedLostGuessNot ShockedLostFirstDay)))
)
;
(defrule q-UrgentCalls
    ?x <- (HAHA HAHAYEAH)
   =>
   (retract ?x)
   (assert (UI-state (display UrgentCalls)
                     (relation-asserted UrgentCalls)
		             (response UrgentCallsNo)
                     (valid-answers UrgentCallsNo UrgentCallsAgreement)))
)

(defrule q-Bullying
  (logical (startowe Whining))
  (logical (Whining WhiningYes))
   =>
   (assert (UI-state (display Bullying)
                     (relation-asserted Bullying)
                     (response BullyingYes)
                     (valid-answers BullyingYes)))
)
(defrule q-PonyUp
    (or     (and   (logical (startowe Smashes))
                    (or 	(logical (Smashes SmashesMyPhone))
         	                (logical (Smashes SmashesExcuse))
         	                (logical (Smashes SmashesFine))))

         	    (and        (or
         	                        (and 	(logical (startowe Neverlookup))
                 			                (logical(Neverlookup NeverlookupNo))
                 			                (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
                 				                    (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
                 				            )
                 			        )

                 		            (and        (logical (startowe Neverlookup))
                    			                (logical (Neverlookup NeverlookupYes))
                 			                    (logical (HAHA HAHAYEAH))
                 			                    (logical (UrgentCalls UrgentCallsNo))
                 			                    (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
                 				                        (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
                 				                )
                 			        )
                            )
                            (logical (ShockedLost ShockedLostGuessNot))
                )


    )

   =>

   (assert (UI-state (display PonyUp)
                     (relation-asserted PonyUp)
                     (response PonyUpYes)
                     (valid-answers PonyUpYes PonyUpNo HumanATM)))
)

(defrule q-MmmHmm
  (logical (startowe Onephone))
  (logical (Onephone OnephoneDude))
   =>
   (assert (UI-state (display MmmHmm)
                     (relation-asserted MmmHmm)
                     (response MmmHmmStory)
                     (valid-answers MmmHmmStory HumanATM)))
)
(defrule q-HUMANkid
	(or
		(or 	(and (logical (startowe Bankroll)) (logical (Bankroll Half)) (logical (HardEarned HardEarnedGestIt)))
			(and (logical(startowe Bankroll)) (logical(Bankroll BankrollYes)) (logical (HardEarned HardEarnedGestIt)))
			(and (logical (Whining WhiningStop)) (logical (Bankroll Half)) (logical (HardEarned HardEarnedGestIt)))
			(and (logical(Whining WhiningStop)) (logical(Bankroll BankrollYes)) (logical (HardEarned HardEarnedGestIt)))
			)

		(or 	(and    (logical (startowe Neverlookup))
   				(logical (Neverlookup NeverlookupYes))
				(logical (HAHA HAHAangel)))
			(and    (logical (startowe Neverlookup))
   				(logical (Neverlookup NeverlookupYes))
				(logical (HAHA HAHAYEAH))
				(logical (UrgentCalls UrgentCallsAgreement))
				(logical (HAHA HAHAangel))))
	)
   =>
   (assert (UI-state (display HUMANkid)
                     (relation-asserted HUMANkid)
                     (response HUMANkidKinda)
                     (valid-answers HUMANkidKinda)))
)
(defrule q-Bullied
  (logical (startowe Whining))
  (logical (Whining WhiningYes))
  (logical (Bullying BullyingYes))
   =>
   (assert (UI-state (display Bullied)
                     (relation-asserted Bullied)
                     (response BulliedYes)
                     (valid-answers BulliedYes BulliedUsual)))
)

(defrule q-GetSomething
	(or 	(and   	(logical (startowe Whining))
  			        (logical (Whining WhiningYes))
  			        (logical (Bullying BullyingYes))
			        (logical (Bullied BulliedUsual))
		    )
		    (and   	(logical (startowe Whining))
  			        (logical (Whining WhiningYes))
  			        (logical (Bullying BullyingYes))
			        (logical (Bullied BulliedYes))
			        (logical (Puppy PuppyIDK))
		    )
    )
   =>
   (assert (UI-state (display GetSomething)
                     (relation-asserted GetSomething)
                     (response GetSomethingSweet)
                     (valid-answers GetSomethingSweet)))
)

(defrule q-Puppy
	(logical (startowe Whining))
  	(logical (Whining WhiningYes))
  	(logical (Bullying BullyingYes))
	(logical (Bullied BulliedYes))
   =>
   (assert (UI-state (display Puppy)
                     (relation-asserted Puppy)
                     (response PuppyIDK)
                     (valid-answers PuppyIDK PuppyYes)))
)
(defrule q-AppleCare
	(or 	(and
			(logical (startowe Onephone))
  			(logical (Onephone OnephoneDude))
			(logical (MmmHmm MmmHmmStory)))
		(and	(logical (startowe Smashes))
  			(or 	(and (logical (Smashes SmashesMyPhone))(logical (PonyUp PonyUpYes)))
				(and (logical (Smashes SmashesExcuse))(logical (PonyUp PonyUpYes)))
				(and (logical (Smashes SmashesFine))(logical (PonyUp PonyUpYes))))
			)
	)
   =>
   (assert (UI-state (display AppleCare)
                     (relation-asserted AppleCare)
                     (response AppleCareUnbreakable)
                     (valid-answers AppleCareUnbreakable HumanATM)))
)

(defrule q-BuyAI
	(or
		(or 	(and (logical (startowe Bankroll)) (logical (Bankroll Half)) (logical (HardEarned HardEarnedGestIt)))
			(and (logical(startowe Bankroll)) (logical(Bankroll BankrollYes)) (logical (HardEarned HardEarnedGestIt)))
			(and (logical (Whining WhiningStop)) (logical (Bankroll Half)) (logical (HardEarned HardEarnedGestIt)))
			(and (logical(Whining WhiningStop)) (logical(Bankroll BankrollYes)) (logical (HardEarned HardEarnedGestIt)))
			)


		(or 	(and    (logical (startowe Neverlookup))
   				(logical (Neverlookup NeverlookupYes))
				(logical (HAHA HAHAangel)))
			(and    (logical (startowe Neverlookup))
   				(logical (Neverlookup NeverlookupYes))
				(logical (HAHA HAHAYEAH))
				(logical (UrgentCalls UrgentCallsAgreement))
				(logical (HAHA HAHAangel))))
	)
	(logical (HUMANkid HUMANkidKinda))
=>
(assert (UI-state 	(display BuyAI)
			(state final)))
			)



(defrule q-WhyAsking
	(or
		(and 	(logical (startowe Whining))
  			    (logical (Whining WhiningYes))
  			    (logical (Bullying BullyingYes))
			    (logical (Bullied BulliedYes))
			    (logical (Puppy PuppyYes))
	    )

		(and	(or 	(logical (startowe Bankroll))
				        (logical (Whining WhiningStop))
				)
			    (logical (Bankroll BankrollNo))
	    )

	)
=>
(assert (UI-state 	(display WhyAsking)
			(state final)))
			)


(defrule q-DontGetPhone
(or
       (and
            (logical (startowe Whining))
            (logical (Whining WhiningNo))
       )
       (and    (or     (and   (logical (startowe Smashes))
                            (or 	(logical (Smashes SmashesMyPhone))
                 	                (logical (Smashes SmashesExcuse))
                 	                (logical (Smashes SmashesFine))))

                 	    (and        (or
                 	                        (and 	(logical (startowe Neverlookup))
                         			                (logical(Neverlookup NeverlookupNo))
                         			                (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
                         				                    (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
                         				            )
                         			        )
                         		            (and        (logical (startowe Neverlookup))
                            			                (logical (Neverlookup NeverlookupYes))
                         			                    (logical (HAHA HAHAYEAH))
                         			                    (logical (UrgentCalls UrgentCallsNo))
                         			                    (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
                         				                        (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
                         				                )
                         			        )
                                    )
                                    (logical (ShockedLost ShockedLostGuessNot))
                        )
            )
            (logical (PonyUp PonyUpNo))
       )
       (and	(or 	(and
        			(logical (startowe Onephone))
          			(logical (Onephone OnephoneDude))
        			(logical (MmmHmm MmmHmmStory)))
        		(and	(logical (startowe Smashes))
          			(or 	(and (logical (Smashes SmashesMyPhone))(logical (PonyUp PonyUpYes)))
        				(and (logical (Smashes SmashesExcuse))(logical (PonyUp PonyUpYes)))
        				(and (logical (Smashes SmashesFine))(logical (PonyUp PonyUpYes))))
        			)
        	)
        	(logical (AppleCare AppleCareUnbreakable))
       )
)
=>
(assert (UI-state 	(display DontGetPhone)
			        (state final)))
)


(defrule q-DontLookBack
(or
    (and   (or (and (logical (startowe Bankroll)) (logical (Bankroll Half)))
     	    (and (logical(startowe Bankroll)) (logical(Bankroll BankrollYes)))
     	    (and (logical (Whining WhiningStop)) (logical (Bankroll Half)))
     	    (and (logical(Whining WhiningStop)) (logical(Bankroll BankrollYes)))
     	)
     	(logical (HardEarned HumanATM))

    )
    (and    (or     (and   (logical (startowe Smashes))
                         (or 	(logical (Smashes SmashesMyPhone))
              	                (logical (Smashes SmashesExcuse))
              	                (logical (Smashes SmashesFine))))

              	    (and        (or
              	                        (and 	(logical (startowe Neverlookup))
                      			                (logical(Neverlookup NeverlookupNo))
                      			                (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
                      				                    (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
                      				            )
                      			        )

                      		            (and        (logical (startowe Neverlookup))
                         			                (logical (Neverlookup NeverlookupYes))
                      			                    (logical (HAHA HAHAYEAH))
                      			                    (logical (UrgentCalls UrgentCallsNo))
                      			                    (or 	(logical (LITERALLYlosing LITERALLYlosingHangOn))
                      				                        (logical (LITERALLYlosing LITERALLYlosingSHUTDOWN))
                      				                )
                      			        )
                                 )
                                 (logical (ShockedLost ShockedLostGuessNot))
                     )


         )
         (logical (PonyUp HumanATM))

    )
    (and	(or 	(and
     			(logical (startowe Onephone))
       			(logical (Onephone OnephoneDude))
     			(logical (MmmHmm MmmHmmStory)))
     		(and	(logical (startowe Smashes))
       			(or 	(and (logical (Smashes SmashesMyPhone))(logical (PonyUp PonyUpYes)))
     				(and (logical (Smashes SmashesExcuse))(logical (PonyUp PonyUpYes)))
     				(and (logical (Smashes SmashesFine))(logical (PonyUp PonyUpYes))))
     			)
     	)
     	(logical (AppleCare HumanATM))

    )
    (and (or 	(and   	(logical (startowe Whining))
       			        (logical (Whining WhiningYes))
       			        (logical (Bullying BullyingYes))
     			        (logical (Bullied BulliedUsual))
     		    )
     		    (and   	(logical (startowe Whining))
       			        (logical (Whining WhiningYes))
       			        (logical (Bullying BullyingYes))
     			        (logical (Bullied BulliedYes))
     			        (logical (Puppy PuppyIDK))
     		    )
         )
         (logical (GetSomething GetSomethingSweet))

    )
    (and   (logical (startowe Onephone))
           (logical (Onephone OnephoneDude))
           (logical (MmmHmm HumanATM))

    )

)
=>
(assert (UI-state 	(display DontLookBack)
			        (state final)))
)




;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))

   (UI-state (id ?id))

   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))

   =>

   (modify ?f (current ?id)
              (sequence ?id ?s))

   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))

   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))

   =>

   (retract ?f1)

   (modify ?f2 (current ?nid))

   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))

   ?f <- (next ?id)

   (state-list (sequence ?id $?))

   (UI-state (id ?id)
             (relation-asserted ?relation))

   =>

   (retract ?f)

   (assert (add-response ?id)))

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))

   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))

   (UI-state (id ?id) (response ?response))

   =>

   (retract ?f1)

   (modify ?f2 (current ?nid))

   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))

   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))

   (UI-state (id ?id) (response ~?response))

   ?f2 <- (UI-state (id ?nid))

   =>

   (modify ?f1 (sequence ?b ?id ?e))

   (retract ?f2))

(defrule handle-next-response-end-of-chain

   (declare (salience 10))

   ?f1 <- (next ?id ?response)

   (state-list (sequence ?id $?))

   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))

   =>

   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))

   (assert (add-response ?id ?response)))

(defrule handle-add-response

   (declare (salience 10))

   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))

   ?f1 <- (add-response ?id ?response)

   =>

   (str-assert (str-cat "(" ?relation " " ?response ")"))

   (retract ?f1))

(defrule handle-add-response-none

   (declare (salience 10))

   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))

   ?f1 <- (add-response ?id)

   =>

   (str-assert (str-cat "(" ?relation ")"))

   (retract ?f1))

(defrule handle-prev

   (declare (salience 10))

   ?f1 <- (prev ?id)

   ?f2 <- (state-list (sequence $?b ?id ?p $?e))

   =>

   (retract ?f1)

   (modify ?f2 (current ?p))

   (halt))

