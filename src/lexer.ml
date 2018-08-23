# 1 "src/lexer.mll"
  
        open Parser        (* The type token is defined in parser.mli *)
        open Utils
(*		exception Eof
*)
 
# 9 "src/lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\227\255\228\255\229\255\230\255\003\000\235\255\236\255\
    \030\000\238\255\239\255\240\255\241\255\014\000\048\000\075\000\
    \123\000\003\000\133\000\145\000\018\000\254\255\255\255\036\000\
    \038\000\001\000\253\255\244\255\002\000\252\255\243\255\227\000\
    \155\000\247\000\212\000\001\001\127\000\095\000\246\255\245\255\
    \234\255\237\255\233\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\255\255\024\000\255\255\255\255\
    \023\000\255\255\255\255\255\255\255\255\028\000\028\000\008\000\
    \007\000\028\000\013\000\004\000\028\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\005\000\005\000\255\255\255\255\006\000\255\255\255\255\
    \255\255\255\255\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\000\000\000\000\255\255\000\000\000\000\
    \255\255\000\000\000\000\000\000\000\000\255\255\255\255\255\255\
    \255\255\036\000\255\255\255\255\025\000\000\000\000\000\028\000\
    \028\000\025\000\000\000\000\000\028\000\000\000\000\000\255\255\
    \255\255\255\255\255\255\255\255\036\000\255\255\000\000\000\000\
    \000\000\000\000\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\022\000\021\000\026\000\029\000\255\255\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\000\000\000\000\000\000\
    \022\000\000\000\000\000\000\000\000\000\020\000\000\000\017\000\
    \011\000\010\000\037\000\004\000\012\000\003\000\018\000\007\000\
    \019\000\019\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\014\000\039\000\008\000\009\000\005\000\013\000\
    \042\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\040\000\041\000\038\000\030\000\006\000\
    \027\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\023\000\036\000\000\000\
    \024\000\255\255\000\000\000\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\037\000\000\000\
    \000\000\000\000\015\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\032\000\
    \000\000\019\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\000\000\031\000\000\000\
    \000\000\000\000\016\000\000\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\031\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\255\255\255\255\255\255\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\035\000\000\000\
    \035\000\000\000\255\255\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\000\000\255\255\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\000\000\031\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\031\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\025\000\028\000\017\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\020\000\255\255\255\255\255\255\
    \000\000\255\255\255\255\255\255\255\255\000\000\255\255\000\000\
    \000\000\000\000\017\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\013\000\000\000\000\000\000\000\000\000\
    \005\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\008\000\008\000\014\000\023\000\000\000\
    \024\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\020\000\037\000\255\255\
    \020\000\036\000\255\255\255\255\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\036\000\255\255\
    \255\255\255\255\015\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\019\000\
    \255\255\019\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\032\000\032\000\032\000\032\000\032\000\
    \032\000\032\000\032\000\032\000\032\000\255\255\019\000\255\255\
    \255\255\255\255\016\000\255\255\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\019\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\025\000\028\000\017\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\031\000\255\255\
    \031\000\255\255\020\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\031\000\031\000\031\000\031\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\023\000\255\255\024\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\035\000\035\000\035\000\035\000\035\000\035\000\035\000\
    \035\000\035\000\035\000\255\255\033\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\033\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\036\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 9 "src/lexer.mll"
                         ( token lexbuf )
# 185 "src/lexer.ml"

  | 1 ->
# 10 "src/lexer.mll"
                         ( Lexing.new_line lexbuf; token lexbuf )
# 190 "src/lexer.ml"

  | 2 ->
# 11 "src/lexer.mll"
                                             ( Lexing.new_line lexbuf; token lexbuf )
# 195 "src/lexer.ml"

  | 3 ->
# 12 "src/lexer.mll"
                                              ( Lexing.new_line lexbuf; token lexbuf )
# 200 "src/lexer.ml"

  | 4 ->
let
# 13 "src/lexer.mll"
                    lxm
# 206 "src/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 13 "src/lexer.mll"
                           ( INT (int_of_string lxm) )
# 210 "src/lexer.ml"

  | 5 ->
let
# 14 "src/lexer.mll"
                                                                 lxm
# 216 "src/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 14 "src/lexer.mll"
                                                                      ( FLOAT (float_of_string (lxm)) )
# 220 "src/lexer.ml"

  | 6 ->
let
# 15 "src/lexer.mll"
                                           lxm
# 226 "src/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 15 "src/lexer.mll"
                                                ( STRING(lxm) )
# 230 "src/lexer.ml"

  | 7 ->
let
# 16 "src/lexer.mll"
                                       lxm
# 236 "src/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 16 "src/lexer.mll"
                                            ( match lxm with 
                            | "and" -> AND 
                            | "not" -> NOT 
                            | _ -> RELNAME(lxm) )
# 243 "src/lexer.ml"

  | 8 ->
let
# 20 "src/lexer.mll"
                                       lxm
# 249 "src/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 20 "src/lexer.mll"
                                            ( match lxm with
						    | "AND" -> AND
						    | "NOT" -> NOT
						    | _     -> VARNAME(lxm)
						)
# 257 "src/lexer.ml"

  | 9 ->
# 25 "src/lexer.mll"
                        ( IMPLIEDBY )
# 262 "src/lexer.ml"

  | 10 ->
# 26 "src/lexer.mll"
                          ( QMARK )
# 267 "src/lexer.ml"

  | 11 ->
# 27 "src/lexer.mll"
                           ( QMARK )
# 272 "src/lexer.ml"

  | 12 ->
# 28 "src/lexer.mll"
                                    (UMARK)
# 277 "src/lexer.ml"

  | 13 ->
# 29 "src/lexer.mll"
                         ( DOT )
# 282 "src/lexer.ml"

  | 14 ->
# 30 "src/lexer.mll"
                         ( SEP )
# 287 "src/lexer.ml"

  | 15 ->
# 31 "src/lexer.mll"
                         ( LPAREN )
# 292 "src/lexer.ml"

  | 16 ->
# 32 "src/lexer.mll"
                         ( RPAREN )
# 297 "src/lexer.ml"

  | 17 ->
# 33 "src/lexer.mll"
                         ( EQ )
# 302 "src/lexer.ml"

  | 18 ->
# 34 "src/lexer.mll"
                          ( NE )
# 307 "src/lexer.ml"

  | 19 ->
# 35 "src/lexer.mll"
                         ( EOP )
# 312 "src/lexer.ml"

  | 20 ->
# 36 "src/lexer.mll"
                                                ( ANONVAR )
# 317 "src/lexer.ml"

  | 21 ->
# 37 "src/lexer.mll"
                                                ( LE )
# 322 "src/lexer.ml"

  | 22 ->
# 38 "src/lexer.mll"
                                                ( GE )
# 327 "src/lexer.ml"

  | 23 ->
# 39 "src/lexer.mll"
                                                ( LT )
# 332 "src/lexer.ml"

  | 24 ->
# 40 "src/lexer.mll"
                                                ( GT )
# 337 "src/lexer.ml"

  | 25 ->
# 41 "src/lexer.mll"
                                                ( PLUS )
# 342 "src/lexer.ml"

  | 26 ->
# 42 "src/lexer.mll"
                                                ( MINUS )
# 347 "src/lexer.ml"

  | 27 ->
# 43 "src/lexer.mll"
                  ( EOF )
# 352 "src/lexer.ml"

  | 28 ->
# 44 "src/lexer.mll"
                          ( spec_lex_error lexbuf )
# 357 "src/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

;;

