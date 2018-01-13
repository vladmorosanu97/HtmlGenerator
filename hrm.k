module HRM-SYNTAX

    syntax Content  ::= String
                    | Id
                    |Int

    syntax Style   ::= Style Style          [left,prefer]
                    | "**" Content
                    | "e" Content
                    | "~~" Content
                    | "[" Style "]"
                    | "![" Style "]"
                    | "ft"
                    | "ff."
                    | "s" Content
                    | "s."
                    | "c" Content
                    | Content
                    | ".i."
                    | "mk" Content
                    | "mk."
                    | "e."


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
                      | "p"
                      | "p."
                      | "addr"
                      | "addr."
                      | "___"
                      | "B"
                      | "B."
                      | "$"
                      | "$."
                      | "@"
                      | "@."
                      | "HH"
                      | "HH."
                      | "L"
                      | "L."
                      | "lk"
                      | "st"
                      | "st."
                      | "tx"
                      | "tx."


    syntax Block ::= ">"
                    | ">."
                    | "u" 
                    | "u."
                    | "o" 
                    | "o."
                    | "<a"
                    | "a>"
                    | "i"
                    | "a"
                    | "a."
                    | "<d"
                    | "d>"
                    | "<f"
                    | "f>"
                    | "<h"
                    | "h>"
                    | "<m"
                    | "m>"
                    | "<n"
                    | "n>"
                    | "<s"
                    | "s>"
                    | "ti"
                    | "ti."
                    | "V"
                    | "V."
                    | "&"
                    | "A"
                    | "A."
                    | "Y"
                    | "Y."
                    | "y"
                    | "y."
                     


    syntax Table  ::= "!" 
                    | "!."
                    | "|" Style
                    | "||" Style
                    | "|."
                    | "||."
                    | "%"
                    | "%." 
                    | "T"
                    | "T."

    syntax ListAttributes ::= "w" Content
                            | "h" Content
                            | "["
                            | "]"
                            | ":"
                            | ListAttributes ListAttributes [left]


    syntax Stmt ::= Content
                | Symbol
                | ListAttributes
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

///////////////////////////////////////////////////////////////////////// Regula pentru Stmt

    rule S1:Stmt S2:Stmt => S1 ~> S2

//////////////////////////////////////////////////////////////////////// Regula pentru string

    rule Str1 Str2 => Str1 +String Str2

//////////////////////////////////////////////////////////////////////// Html
    
    rule <k> (+  => .) ...</k>
        <out>... (.List => ListItem("<html"))</out>

    rule <k> (-  => .) ...</k>
        <out>... (.List => ListItem("\n</html>")) </out>  

//////////////////////////////////////////////////////////////////////// Head

    rule <k> (HH  => .) ...</k>
        <out>... (.List => ListItem("<head"))</out>

    rule <k> (HH.  => .) ...</k>
        <out>... (.List => ListItem("\n</head>")) </out>  

//////////////////////////////////////////////////////////////////////// Link
    
    rule <k> (lk => .) ...</k>
        <out>... (.List => ListItem("\n<link")) </out>

//////////////////////////////////////////////////////////////////////// Style
    
    rule <k> (st => .) ...</k>
        <out>... (.List => ListItem("\n<style")) </out>

    rule <k> (st. => .) ...</k>
        <out>... (.List => ListItem("\n</style>")) </out>


//////////////////////////////////////////////////////////////////////// Body

    rule <k> (start  => .) ...</k>
        <out>... (.List => ListItem("\n<body")) </out>

    rule <k> (end  => .) ...</k>
        <out>... (.List => ListItem("\n</body>")) </out>

////////////////////////////////////////////////////////////////////////// blockquote
    rule <k> (>  => .) ... </k>
        <out>... (.List => ListItem("\n<blockquote")) </out>
    
    rule <k> (>. => . ) ... </k>
        <out>... (.List => ListItem("\n</blockquote>")) </out>

///////////////////////////////////////////////////////////////////////// Article

    rule <k> (<a => . ) ...</k>
        <out>... (.List => ListItem("\n<article")) </out>
    
    rule <k> ((a>) => .) ...</k>
        <out>... (.List => ListItem("\n</article>")) </out>

///////////////////////////////////////////////////////////////////////// Div
    
    rule <k> (<d => . ) ...</k>
        <out>... (.List => ListItem("\n<div")) </out>
    
    rule <k> ((d>) => .) ...</k>
        <out>... (.List => ListItem("\n</div>")) </out>

////////////////////////////////////////////////////////////////////////// Footer

    rule <k> (<f => .) ...</k>
        <out>... (.List => ListItem("\n<footer")) </out>

    rule <k> (f> => .) ...</k>
        <out>... (.List => ListItem("\n</footer>")) </out>


////////////////////////////////////////////////////////////////////////// Header

    rule <k> (<h => .) ...</k>
        <out>... (.List => ListItem("\n<header")) </out>
    
    rule <k> (h> => .) ...</k>
        <out>... (.List => ListItem("\n</header>")) </out>

////////////////////////////////////////////////////////////////////////// Main

    rule <k> (<m => .) ...</k>
        <out>... (.List => ListItem("\n<main")) </out>
    
    rule <k> (m> => .) ...</k>
        <out>... (.List => ListItem("\n</main>")) </out>

////////////////////////////////////////////////////////////////////////// Navigation

    rule <k> (<n => .) ...</k>
        <out>... (.List => ListItem("\n<nav")) </out>
    
    rule <k> (n> => .) ...</k>
        <out>... (.List => ListItem("\n</nav>")) </out>



///////////////////////////////////////////////////////////////////////// Liste neordonate

    rule <k> (u => . ) ...</k>
        <out>... (.List => ListItem("\n<ul")) </out>
    
    rule <k> ((u.) => .) ...</k>
        <out>... (.List => ListItem("\n</ul>")) </out>

///////////////////////////////////////////////////////////////////////// Liste ordonate

    rule <k> (o => . ) ...</k>
        <out>... (.List => ListItem("\n<ol")) </out>
    
    rule <k> ((o.) => .) ...</k>
        <out>... (.List => ListItem("\n</ol>")) </out>

////////////////////////////////////////////////////////////////////////// Tabele

    rule <k> (T => .) ... </k>
         <out>... (.List => ListItem("\n<table")) </out>

    rule <k> (T. => .) ... </k>
         <out>... (.List => ListItem("\n</table>")) </out>

    rule <k> (! => .) ... </k>
         <out>... (.List => ListItem("\n<thead>\n<tr")) </out>

    rule <k> (|| I:Style => .) ... </k>
        <out>... (.List => ListItem("\n<th>")) (.List => ListItem(I)) (.List => ListItem("\n</th>"))</out>

    rule <k> (!. => .) ... </k>
        <out>... (.List => ListItem("\n</tr>\n</thead>")) </out>

    rule <k> (% => .) ... </k>
         <out>... (.List => ListItem("\n<tbody>\n<tr")) </out>

    rule <k> (| I:Style => .) ... </k>
        <out>... (.List => ListItem("\n<td>")) (.List => ListItem(I)) (.List => ListItem("\n</td>"))</out>

    rule <k> (|. => .) ... </k>
        <out>... (.List => ListItem("\n</tr>\n<tr>\n")) </out>

    rule <k> (%. => .) ... </k>
        <out>... (.List => ListItem("\n</tr>\n</tbody>")) </out>

//////////////////////////////////////////////////////////////////////// H1 - H6

    rule <k> (###### I:Style => I ######.) ...</k>
        <out>... (.List => ListItem("\n<h6>")) </out>
    
    rule <k> ((######.) => .) ...</k>
        <out>... (.List => ListItem("\n</h6>\n")) </out>
    
    rule <k> (##### I:Style => I #####.) ...</k>
        <out>... (.List => ListItem("\n<h5>")) </out>
    
    rule <k> ((#####.) => .) ...</k>
        <out>... (.List => ListItem("\n</h5>\n")) </out>
    
    rule <k> (#### I:Style => I ####.) ...</k>
        <out>... (.List => ListItem("\n<h4>")) </out>
    
    rule <k> ((####.) => .) ...</k>
        <out>... (.List => ListItem("\n</h4>\n")) </out>
    
    rule <k> (### I:Style => I ###.) ...</k>
        <out>... (.List => ListItem("\n<h3>")) </out>
    
    rule <k> ((###.) => .) ...</k>
        <out>... (.List => ListItem("\n</h3>\n")) </out>
    
    rule <k> (## I:Style => I ##.) ...</k>
        <out>... (.List => ListItem("\n<h2>")) </out>
    
    rule <k> ((##.) => .) ...</k>
        <out>... (.List => ListItem("\n</h2>\n")) </out>
    
    rule <k> (# I:Style => I #.) ...</k>
        <out>... (.List => ListItem("\n<h1>")) </out>
    
    rule <k> (#. => .) ...</k>
        <out>... (.List => ListItem("\n</h1>\n")) </out>

//////////////////////////////////////////////////////////////////// Paragraphs

    rule <k> (p => .) ...</k>
        <out>... (.List => ListItem("\n<p")) </out>
    
    rule <k> (p. => .) ...</k>
        <out>... (.List => ListItem("\n</p>")) </out>

//////////////////////////////////////////////////////////////////// Video

    rule <k> (V => .) ...</k>
        <out>... (.List => ListItem("\n<video controls")) </out>
    
    rule <k> (V. => .) ...</k>
        <out>... (.List => ListItem("\n</video>")) </out>

//////////////////////////////////////////////////////////////////// Audio

    rule <k> (A => .) ...</k>
        <out>... (.List => ListItem("\n<audio controls")) </out>
    
    rule <k> (A. => .) ...</k>
        <out>... (.List => ListItem("</audio>")) </out>

//////////////////////////////////////////////////////////////////// Select

    rule <k> (Y => .) ...</k>
        <out>... (.List => ListItem("\n<select")) </out>
    
    rule <k> (Y. => .) ...</k>
        <out>... (.List => ListItem("\n</select>")) </out>

//////////////////////////////////////////////////////////////////// Option

    rule <k> (y => .) ...</k>
        <out>... (.List => ListItem("\n<option")) </out>
    
    rule <k> (y. => .) ...</k>
        <out>... (.List => ListItem("\n</option>")) </out>

////////////////////////////////////////////////////////////////////// Textarea

    rule <k> (tx => .) ...</k>
        <out>... (.List => ListItem("\n<textarea"))</out>
    
    rule <k> (tx.  => .) ...</k>
        <out>... (.List => ListItem("\n</textarea>")) </out>

////////////////////////////////////////////////////////////////////// Title

    rule <k> (ti => .) ...</k>
        <out>... (.List => ListItem("\n<title"))</out>
    
    rule <k> (ti.  => .) ...</k>
        <out>... (.List => ListItem("\n</title>")) </out>

//////////////////////////////////////////////////////////////////// Code format

    rule <k> ($ => .) ...</k>
        <out>... (.List => ListItem("\n<code")) </out>
    
    rule <k> ($. => .) ...</k>
        <out>... (.List => ListItem("\n</code>")) </out>
    

//////////////////////////////////////////////////////////////////// Font

    rule <k> (ft => .) ...</k>
        <out>... (.List => ListItem("\n<font")) </out>
    
    rule <k> (ft. => .) ...</k>
        <out>... (.List => ListItem("\n</font>")) </out>

//////////////////////////////////////////////////////////////////// Ancor

    rule <k> (a => .) ...</k>
        <out>... (.List => ListItem("\n<a"))</out>

    rule <k> (a. => .)...</k>
        <out>... (.List => ListItem("\n</a>"))</out>

//////////////////////////////////////////////////////////////////// Image

    rule <k> (i => .) ...</k>
        <out>... (.List => ListItem("\n<img"))</out>

/////////////////////////////////////////////////////////////////// Br

    rule <k> (/  => .) ...</k>
        <out>... (.List => ListItem("\n<br>")) </out> 

///////////////////////////////////////////////////////////////////Hr

    rule <k> (___  => .) ...</k>
        <out>... (.List => ListItem("\n<hr>")) </out> 

/////////////////////////////////////////////////////////////////// Button    
    
    rule <k> (B => .) ...</k>
        <out>... (.List => ListItem("\n<button")) </out>

    rule <k> (B. => .) ...</k>
        <out>... (.List => ListItem("\n</button>")) </out>

/////////////////////////////////////////////////////////////////// Formular
    
    rule <k> (@ => .) ...</k>
        <out>... (.List => ListItem("\n<form")) </out>

    rule <k> (@. => .) ...</k>
        <out>... (.List => ListItem("\n</form>")) </out>

////////////////////////////////////////////////////////////////// Label

    rule <k> (L => .) ...</k>
        <out>... (.List => ListItem("\n<label")) </out>

    rule <k> (L. => .) ...</k>
        <out>... (.List => ListItem("\n</label>")) </out>

//////////////////////////////////////////////////////////////////// Li

    rule <k> (^ I:Style => I ^.) ...</k>
        <out>... (.List => ListItem("\n<li>")) </out>
    
    rule <k> (^. => .) ...</k>
        <out>... (.List => ListItem("\n</li>")) </out>

////////////////////////////////////////////////////////////////////// Adresa

    rule <k> (addr => .) ...</k>
        <out>... (.List => ListItem("\n<addres>")) </out>
    
    rule <k> (addr. => .) ...</k>
        <out>... (.List => ListItem("\n</addres>")) </out>

///////////////////////////////////////////////////////////////////// Content strong

    rule <k> (** C:Content => C **.) ...</k>
        <out>... (.List => ListItem("<strong>"))</out>
    
    rule <k> (**.  => .) ...</k>
        <out>... (.List => ListItem("</strong>")) </out>

////////////////////////////////////////////////////////////////////// Content italic

    rule <k> (e C:Content => C e.) ...</k>
        <out>... (.List => ListItem("<em>"))</out>
    
    rule <k> (e.  => .) ...</k>
        <out>... (.List => ListItem("</em>")) </out>

////////////////////////////////////////////////////////////////////// Content subliniat

    rule <k> (s C:Content => C s.) ...</k>
        <out>... (.List => ListItem("<ins>"))</out>
    
    rule <k> (s.  => .) ...</k>
        <out>... (.List => ListItem("</ins>")) </out>

////////////////////////////////////////////////////////////////////// Content marcat

    rule <k> (mk C:Content => C mk.) ...</k>
        <out>... (.List => ListItem("<mark>"))</out>
    
    rule <k> (mk.  => .) ...</k>
        <out>... (.List => ListItem("</mark>")) </out>

///////////////////////////////////////////////////////////////////// Input

    rule <k> (.i. => . ) ...</k>
        <out>... (.List => ListItem("\n<input"))</out>

/////////////////////////////////////////////////////////////////////Cite
    
    rule <k> (c C:Content => .) ...</k>
        <out>... (.List => ListItem("\n<cite>"))(.List => ListItem(C))(.List => ListItem("\n</cite>"))</out>

//////////////////////////////////////////////////////////////////// Delete
    
    rule <k> (~~ C:Content => C ~~.) ...</k>
        <out>... (.List => ListItem("<del>"))</out>

    rule <k> (~~.  => .) ...</k>
        <out>... (.List => ListItem("</del>")) </out>


///////////////////////////////////////////////////////////////////////// Attributes
    
    rule <k> ( [ => .) ... </k>

    rule <k> ( ] => .) ... </k>
    
    rule <k> (w C:Content => C ) ...</k>
        <out>... (.List => ListItem(" width=")) </out>
    
    rule <k> (h C:Content => C ) ...</k>
        <out>... (.List => ListItem(" height=")) </out>

    rule <k> (: => .) ...</k>
        <out>... (.List => ListItem(">\n")) </out>
    
/////////////////////////////////////////////////////////////////// Regula pentru content
    
    rule <k>((C:Content) => .) ...</k>
        <out>... (.List => ListItem(C)) </out>


endmodule