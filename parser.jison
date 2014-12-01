/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
([^<>!|&\^]+)         return 'VALUE'
"<"                   return 'LT'
">"                   return 'GT'
"!"                   return 'NOT'
"|"                   return 'OR'
"^"                   return 'RANGE'
"&"                   return 'AND'

/lex
/* operator associations and precedence */

%left 'OR'
%left 'AND'
%left UMINUS
%left 'RANGE'

%start expressions

%parse-param sanitize

%% /* language grammar */

expressions
 
 : e { return $$; };


 e  : val
        {return $$;}

    |  obj
        {return $$;}
   
    |  term_obj
        {return $$;}
    ;

term_obj

   : 'NOT' obj %prec UMINUS
        { $$ = { $not : $2} }
  
   |  val 'AND' obj { $$ = { $and : [$1,$3] } }
   |  obj 'AND' obj { $$ = { $and : [$1,$3] } }
   |  obj 'AND' val { $$ = { $and : [$1,$3] } }
 
   |  val 'OR' obj { $$ = { $or : [$1,$3] } }
   |  obj 'OR' obj { $$ = { $or : [$1,$3] } }
   |  obj 'OR' val { $$ = { $or : [$1,$3] } }
   ;

obj
 
    : 'GT' val %prec UMINUS
        { $$ = { $gt : $2 } }

    | val 'AND' val
        {$$ = {$and : [$1, $3] };}

    | val 'OR' val
        {$$ = {$or : [$1, $3] };}

    | val 'RANGE' val
        {$$ = {$gte : $1, $lt : $3 };}

    | 'LT' val %prec UMINUS
        { $$ = { $lt : $2 }; }

    | 'NOT' val %prec UMINUS
        { $$ = { $ne : $2 } }
    ;


val : VALUE { typeof sanitize === 'function'? $$ = sanitize($$) : $$ ; };
