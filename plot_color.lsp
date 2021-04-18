(defun plot_color (a / sl_get_active_doc_ ss lstLen res1 res2  lst printer marka nom pline_gab te regenmode)	
	
	(vla-startundomark *sl-activedoc*)	
	
	(defun *error* (msg)
		(_sl-error-sysvar-restore nil)
		(princ msg);ke
	) 
	
	(_sl-error-sysvar-save
		(list
			(list "pickstyle" 0)
			(list "osmode" 0)
			(list "DYNMODE" 0)
			(list "CMDECHO" 0)
			(list "REGENMODE" 0)
			(list "FILEDIA" 0)			
		)
	)
	
	(vla-put-freeze (vla-item (vla-get-layers *sl-activedoc*) "¿ –_tile_contour") :vlax-false)
	(vla-regen (vla-get-activedocument (vlax-get-acad-object)) 1)	;ke
	
	(setq pline_gab a )
	
	(setq lstlen (vl-remove-if-not
		(function (lambda (x) 
			(wcmatch (gbn x) " –_Œ— _‘ÓÏ‡ÚÍ‡_v1*,Ramka_v4*,‘ÓÏ‡Ú¿ –*")
			
		))
		(sl_conv_pickset_to_list_ (setq ss (ssget "_X" 
			(list (cons 0 "INSERT") 
				(cons -4 "<AND")
				(cons -4 ">,>,*")
				(cons 10 (car pline_gab))
				(cons -4 "<,<,*")
				(cons 10 (cadr pline_gab))
				(cons -4 "AND>")
			)			
		)) )
	)
	ss nil 
	)
	
	(setq regenmode (getvar "REGENMODE")) ;;ke
	(setvar "REGENMODE" 1);;ke
	(command "_.zoom" "10");;ke	
	;;(setvar "REGENMODE" 0);;ke
	
	(foreach ent lstlen
		(setq te (sl_get_2pts_by_bb_ ent))
		(setq marka_lst 
			(vl-sort 		
				(sl_conv_pickset_to_list_ (setq ss (ssget "_X" 
					(list (cons 0 "TEXT") 
						(cons -4 "<AND")
						(cons -4 ">,>,*")
						(cons 10 (one_move_xy (dx ent 10) -3000. 375.))
						(cons -4 "<,<,*")
						(cons 10 (one_move_xy (dx ent 10) -1250. 750.))
						(cons -4 "AND>")
					)				
				)) 
				)
				(function (lambda (e1 e2) (< (cadr (dx  e1 10)) (cadr (dx  e2 10))) ))
			)		
			ss nil 
			marka (if (equal (length marka_lst) 3) (strcat (vl-string-right-trim "," (dx (cadr marka_lst) 1)) "_"
			(dx (car marka_lst) 1)) (dx (car marka_lst) 1))
		)		
		
		(setq nom (car 
			(vl-sort 
				(sl_conv_pickset_to_list_ (setq ss (ssget "_X" 
					(list (cons 0 "TEXT") 
						(cons -4 "<AND")
						(cons -4 ">,>,*")
						(cons 10 (one_move_xy (dx ent 10) -875. 375.))
						(cons -4 "<,<,*")
						(cons 10 (one_move_xy (dx ent 10) -500. 625.))
						(cons -4 "AND>")
					)			
				)
				) 
				)
				(function (lambda (e1 e2) (< (cadr (dx  e1 10)) (cadr (dx  e2 10))) ))
			)
		)			
		ss nil 
		)
		
		(if (wcmatch (dx nom 1) "*.1")			
			(command "_-plot" "_Yes" "Model" 
				"PDF_flexBricks.pc3" 
				"U3" "_M" "_L" "_N" "_w" (car te) (cadr te) "_F" "_c" "_y" "monochrome.ctb" "_y" "_A" 
				(strcat (vl-filename-directory (vla-get-fullname *sl-activedoc*)) "\\" (sl_string_align_0 (dx nom 1) 6 "0" T) "_mir_" marka)
			"_n"  "_y")			
			(command "_-plot" "_Yes" "Model" 
				"PDF_flexBricks.pc3" 
				"U3" "_M" "_L" "_N" "_w" (car te) (cadr te) "_F" "_c" "_y" "monochrome.ctb" "_y" "_A" 
				; (strcat (dx nom 1) "_f_" (dx marka 1))
				(strcat (vl-filename-directory (vla-get-fullname *sl-activedoc*)) "\\" (sl_string_align_0 (dx nom 1) 4 "0" T)  ".0_f_" marka)
			"_n"  "_y")
		)		
	)
	
	(setvar "REGENMODE" 1);;ke
	(command "_.zoom" "_P");;ke
	(setvar "REGENMODE" regenmode);;ke
	
	(_sl-error-sysvar-restore nil)
	(vla-endundomark *sl-activedoc*)
	(princ)
)