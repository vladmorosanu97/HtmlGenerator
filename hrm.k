module HRM-SYNTAX

    syntax Content  ::= String
                    | Id
                    |Int

    syntax Style   ::= Style Style          [left,prefer]
                    | "**" Content
                    | "i" Content
                    | "~~" Content
                    | "[" Style "]"
                    | "![" Style "]"
                    | "c" Content
                    | Content

    syntax Lista ::= Lista Lista   [left,prefer]
                    | "^" Style
                    | "^."
                    | Block

    syntax Symbol   ::= "+"
                      | "start"
                      | "######" Style
                      | "######."
                      | "#####" Style
                      | "#####."
                      | "####" Style
                      | "####."
                      | "###" Style
                      | "###."
                      | "##" Style
                      | "##."
                      | "#" Style                                 
                      | "#."                   
                      | "end"
                      | "**."
                      | "i."
                      | "~~."
                      | "-"
                      | "/"
                      | "p" Style
                      | "p."
                      | "addr" Style
                      | "addr."
                      | "___"
                      | "B" Style
                      | "B."
                      | "$" Style
                      | "$."

    syntax Block ::= ">" Symbol
                    | ">."
                    | "u" Lista
                    | "u."
                    | "o" Lista
                    | "o."
                    | "a" Symbol
                    | "a."

    syntax Table  ::= "!" 
                    | "!."
                    | "|" Style
                    | "||" Style
                    | "|."
                    | "||."
                    | "%"
                    | "%." 

    syntax Stmt ::= Symbol
                | Style
                | Lista
                | Block
                | Table
                > Stmt Stmt                     [left]
 
 
endmodule
 
module HRM
    imports HRM-SYNTAX

    syntax KResult ::= String | Int | Id

    configuration   <T>
                        <k> $PGM:Stmt </k>
                        <out stream="stdout"> .List </out>
                    </T>
                    
    rule S1:Stmt S2:Stmt => S1 ~> S2
    rule Str1 Str2 => Str1 +String Str2



    rule <k> (+  => .) ...</k>
        <out>... (.List => ListItem("<html>\n"))</out>

    rule <k> (start  => .) ...</k>
        <out>... (.List => ListItem("<body>\n")) </out>
    




    rule <k> (> R:Symbol => R >.) ...</k>
        <out>... (.List => ListItem("<blockquote>\n")) </out>
    rule <k> ((>.) => .) ...</k>
        <out>... (.List => ListItem("</blockquote>\n")) </out>

    rule <k> (a R:Symbol => R ) ...</k>
        <out>... (.List => ListItem("<article>\n")) </out>
    rule <k> ((a.) => .) ...</k>
        <out>... (.List => ListItem("</article>\n")) </out>


    rule <k> (u L:Lista => L ) ...</k>
        <out>... (.List => ListItem("<ul>\n")) </out>
    rule <k> ((u.) => .) ...</k>
        <out>... (.List => ListItem("</ul>\n")) </out>

    rule <k> (o L:Lista => L ) ...</k>
        <out>... (.List => ListItem("<ol>\n")) </out>
    rule <k> ((o.) => .) ...</k>
        <out>... (.List => ListItem("</ol>\n")) </out>




    rule <k> (! => .) ... </k>
         <out>... (.List => ListItem("<table>\n<thead>\n<tr>\n")) </out>

    rule <k> (|| I:Style => .) ... </k>
        <out>... (.List => ListItem("<th>")) (.List => ListItem(I)) (.List => ListItem("</th>\n"))</out>

    rule <k> (!. => .) ... </k>
        <out>... (.List => ListItem("</tr>\n</thead>\n")) </out>

    rule <k> (% => .) ... </k>
         <out>... (.List => ListItem("<tbody>\n<tr>\n")) </out>

    rule <k> (|. => .) ... </k>
        <out>... (.List => ListItem("</tr>\n<tr>\n")) </out>

    rule <k> (%. => .) ... </k>
        <out>... (.List => ListItem("</tr>\n</tbody>\n</table>\n")) </out>
    
    rule <k> (| I:Style => .) ... </k>
        <out>... (.List => ListItem("<td>")) (.List => ListItem(I)) (.List => ListItem("</td>\n"))</out>




    rule <k> (###### I:Style => I ######.) ...</k>
        <out>... (.List => ListItem("<h6>")) </out>
    rule <k> ((######.) => .) ...</k>
        <out>... (.List => ListItem("</h6>\n")) </out>
    rule <k> (##### I:Style => I #####.) ...</k>
        <out>... (.List => ListItem("<h5>")) </out>
    rule <k> ((#####.) => .) ...</k>
        <out>... (.List => ListItem("</h5>\n")) </out>
    rule <k> (#### I:Style => I ####.) ...</k>
        <out>... (.List => ListItem("<h4>")) </out>
    rule <k> ((####.) => .) ...</k>
        <out>... (.List => ListItem("</h4>\n")) </out>
    rule <k> (### I:Style => I ###.) ...</k>
        <out>... (.List => ListItem("<h3>")) </out>
    rule <k> ((###.) => .) ...</k>
        <out>... (.List => ListItem("</h3>\n")) </out>
    rule <k> (## I:Style => I ##.) ...</k>
        <out>... (.List => ListItem("<h2>")) </out>
    rule <k> ((##.) => .) ...</k>
        <out>... (.List => ListItem("</h2>\n")) </out>
    rule <k> (# I:Style => I #.) ...</k>
        <out>... (.List => ListItem("<h1>")) </out>
    rule <k> (#. => .) ...</k>
        <out>... (.List => ListItem("</h1>\n")) </out>





    rule <k> (p I:Style => I) ...</k>
        <out>... (.List => ListItem("<p>")) </out>
    rule <k> (p. => .) ...</k>
        <out>... (.List => ListItem("</p>\n")) </out>

    rule <k> ($ I:Style => I) ...</k>
        <out>... (.List => ListItem("<code>")) </out>
    rule <k> ($. => .) ...</k>
        <out>... (.List => ListItem("</code>\n")) </out>
    
    

    rule <k> ([C1:Style C2:Style] => .) ...</k>
        <out>... (.List => ListItem("<a href="))(.List => ListItem(C1))(.List => ListItem(">"))(.List => ListItem(C2))(.List => ListItem("</a>")) </out>

    rule <k> (![C1:Style C2:Style] => .) ...</k>
        <out>... (.List => ListItem("<img src="))(.List => ListItem(C1))(.List => ListItem(" alt="))(.List => ListItem(C2))(.List => ListItem(">")) </out>

    rule <k> (/  => .) ...</k>
        <out>... (.List => ListItem("<br>\n")) </out> 

    rule <k> (___  => .) ...</k>
        <out>... (.List => ListItem("<hr>\n")) </out> 
    
    rule <k> (B I:Style => I B.) ...</k>
        <out>... (.List => ListItem("<button>")) </out>
    rule <k> (B. => .) ...</k>
        <out>... (.List => ListItem("</button>\n")) </out>
    

    rule <k> (^ I:Style => I ^.) ...</k>
        <out>... (.List => ListItem("<li>")) </out>
    rule <k> (^. => .) ...</k>
        <out>... (.List => ListItem("</li>\n")) </out>


    rule <k> (addr I:Style => I) ...</k>
        <out>... (.List => ListItem("<addres>")) </out>
    rule <k> (addr. => .) ...</k>
        <out>... (.List => ListItem("</addres>\n")) </out>


    rule <k> (** C:Content => C **.) ...</k>
        <out>... (.List => ListItem("<strong>"))</out>
    rule <k> (**.  => .) ...</k>
        <out>... (.List => ListItem("</strong>")) </out>

    rule <k> (i C:Content => C i.) ...</k>
        <out>... (.List => ListItem("<em>"))</out>
    rule <k> (i.  => .) ...</k>
        <out>... (.List => ListItem("</em>")) </out>

    rule <k> (c C:Content => .) ...</k>
        <out>... (.List => ListItem("<cite>"))(.List => ListItem(C))(.List => ListItem("</cite>"))</out>

    rule <k> (~~ C:Content => C ~~.) ...</k>
        <out>... (.List => ListItem("<del>"))</out>
    rule <k> (~~.  => .) ...</k>
        <out>... (.List => ListItem("</del>")) </out>

    rule <k>((C:Content) => .) ...</k>
        <out>... (.List => ListItem(C)) </out>






    rule <k> (end  => .) ...</k>
        <out>... (.List => ListItem("</body>\n")) </out>   

    rule <k> (-  => .) ...</k>
        <out>... (.List => ListItem("</html>\n")) </out>
    

endmodule