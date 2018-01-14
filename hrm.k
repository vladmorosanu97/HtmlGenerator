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
                    | "--" Id
                    | Content "=" Content                   [strict(2)]


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
                    | "<as"
                    | "as>"
                    | "<fg"
                    | "fg>"
                    | "M"
                    | "M."
                    | "D"
                    | "D."
                    | "P"
                    | "P."
                     


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
                    | ";"
                    | ";."

    syntax ListAttributes ::= "w" Content
                            | "h" Content
                            | "t" Content
                            | "n" Content
                            | "ac" Content
                            | "v" Content
                            | "sr" Content
                            | "hr" Content
                            | "cl" Content
                            | "id" Content
                            | "ro" Content
                            | "co" Content
                            | "sz" Content
                            | "sy" Content
                            | "tt" Content
                            | "mn" Content
                            | "mx" Content
                            | "d"
                            | "["
                            | "]"
                            | ":"
                            | ListAttributes ListAttributes [left]


    syntax Stmt ::= "TableRows" Int Int
                | "TableCols" Int Int
                | "TableLines" Int Int
                | Content
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

////////////////////////////////////////////////////////////////////////// Scadere

    rule I1:Int - I2:Int => I1 -Int I2

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

////////////////////////////////////////////////////////////////////////// Aside

    rule <k> (<as => .) ...</k>
        <out>... (.List => ListItem("\n<aside")) </out>
    
    rule <k> (as> => .) ...</k>
        <out>... (.List => ListItem("\n</aside>")) </out>

////////////////////////////////////////////////////////////////////////// Figure

    rule <k> (<fg => .) ...</k>
        <out>... (.List => ListItem("\n<figure")) </out>
    
    rule <k> (fg> => .) ...</k>
        <out>... (.List => ListItem("\n</figure>")) </out>

////////////////////////////////////////////////////////////////////////// Meter

    rule <k> (M => .) ...</k>
        <out>... (.List => ListItem("\n<meter")) </out>
    
    rule <k> (M. => .) ...</k>
        <out>... (.List => ListItem("\n</meter>")) </out>

////////////////////////////////////////////////////////////////////////// Details

    rule <k> (D => .) ...</k>
        <out>... (.List => ListItem("\n<details")) </out>
    
    rule <k> (D. => .) ...</k>
        <out>... (.List => ListItem("\n</details>")) </out>

////////////////////////////////////////////////////////////////////////// Progress

    rule <k> (P => .) ...</k>
        <out>... (.List => ListItem("\n<progress")) </out>
    
    rule <k> (P. => .) ...</k>
        <out>... (.List => ListItem("\n</progress>")) </out>



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
        <out>... (.List => ListItem("<\n</tr>\n</thead>")) </out>

    rule <k> (% => .) ... </k>
         <out>... (.List => ListItem("\n<tbody>\n<tr")) </out>

     rule <k> (; => .) ... </k>
         <out>... (.List => ListItem("\n<tr>")) </out>

    rule <k> (| I:Style => .) ... </k>
        <out>... (.List => ListItem("\n<td>")) (.List => ListItem(I)) (.List => ListItem("\n</td>"))</out>

    rule <k> (|. => .) ... </k>
        <out>... (.List => ListItem("\n</tr>\n<tr>\n")) </out>

     rule <k> (;. => .) ... </k>
        <out>... (.List => ListItem("\n</tr>")) </out>
    rule <k> (%. => .) ... </k>
        <out>... (.List => ListItem("\n</tbody>")) </out>

/////////////////////////////////////////////////////////////////////////////////////// Generare tabel head


    rule <k> (TableCols Z Z => .) ... </k>
        <out>... (.List => ListItem("\n<th>"))(.List => ListItem("Coloana nr. ")) (.List => ListItem( Z )) (.List => ListItem("</th>"))</out>

    rule <k> ((TableCols X:Int Z:Int )  => TableCols X +Int 1 Z) ...</k>
         <out>... (.List => ListItem("\n<th>"))(.List => ListItem("Coloana nr. ")) (.List => ListItem( X )) (.List => ListItem("</th>"))</out>  when X =/=Int Z


////////////////////////////////////////////////////////////////////////////////////// Generare tabel body

    rule <k> (TableRows Z Z => .) ... </k>
        <out>... (.List => ListItem("\n<td>"))(.List => ListItem("Linia pentru col nr. ")) (.List => ListItem( Z )) (.List => ListItem("</td>"))</out>

    rule <k> ((TableRows X:Int Z:Int )  => TableRows X +Int 1 Z) ...</k>
         <out>... (.List => ListItem("\n<td>"))(.List => ListItem("Linia pentru col nr. ")) (.List => ListItem( X )) (.List => ListItem("</td>"))</out>  when X =/=Int Z

    rule <k> (TableLines 0 Z:Int => .) ... </k>
        <out>... (.List => ListItem("\n</tr>"))</out>

    rule <k> ((TableLines X:Int Z:Int ) =>  (TableRows 0 Z) TableLines X -Int 1 Z ) ... </k>
        <out>... (.List => ListItem("\n</tr>"))(.List => ListItem("\n<tr>")) </out> when X =/=Int 0

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

/////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////// Attributes
/////////////////////////////////////////////////////////////////////////

    rule <k> ( [ => .) ... </k>

    rule <k> ( ] => .) ... </k>

///////////////////////////////////////////////////////////////////////// Width

    rule <k> (w C:Content => C ) ...</k>
        <out>... (.List => ListItem(" width=")) </out>
    
/////////////////////////////////////////////////////////////////////////// Height
    
    rule <k> (h C:Content => C ) ...</k>
        <out>... (.List => ListItem(" height=")) </out>

//////////////////////////////////////////////////////////////////////////// Type

    rule <k> (t C:Content => C ) ...</k>
        <out>... (.List => ListItem(" type=")) </out>

//////////////////////////////////////////////////////////////////////////// Name

    rule <k> (n C:Content => C ) ...</k>
        <out>... (.List => ListItem(" name=")) </out>

//////////////////////////////////////////////////////////////////////////// Action

    rule <k> (ac C:Content => C ) ...</k>
        <out>... (.List => ListItem(" action=")) </out>

//////////////////////////////////////////////////////////////////////////// Value

    rule <k> (v C:Content => C ) ...</k>
        <out>... (.List => ListItem(" value=")) </out>
    
//////////////////////////////////////////////////////////////////////////// Src

    rule <k> (sr C:Content => C ) ...</k>
        <out>... (.List => ListItem(" src=")) </out>

//////////////////////////////////////////////////////////////////////////// Href

    rule <k> (hr C:Content => C ) ...</k>
        <out>... (.List => ListItem(" href=")) </out>

//////////////////////////////////////////////////////////////////////////// Clasa

    rule <k> (cl C:Content => C ) ...</k>
        <out>... (.List => ListItem(" class=")) </out>
    
//////////////////////////////////////////////////////////////////////////// Id

    rule <k> (id C:Content => C ) ...</k>
        <out>... (.List => ListItem(" id=")) </out>

//////////////////////////////////////////////////////////////////////////// Row

    rule <k> (ro C:Content => C ) ...</k>
        <out>... (.List => ListItem(" rows=")) </out>

//////////////////////////////////////////////////////////////////////////// Col

    rule <k> (co C:Content => C ) ...</k>
        <out>... (.List => ListItem(" cols=")) </out>
    
//////////////////////////////////////////////////////////////////////////// Download

    rule <k> (d => . ) ...</k>
        <out>... (.List => ListItem(" download")) </out>

//////////////////////////////////////////////////////////////////////////// Size

    rule <k> (sz C:Content => C ) ...</k>
        <out>... (.List => ListItem(" size=")) </out>
    
    rule <k> (: => .) ...</k>
        <out>... (.List => ListItem(">\n")) </out>

/////////////////////////////////////////////////////////////////////////// Style

    rule <k> (sy C:Content => C ) ...</k>
        <out>... (.List => ListItem(" style=")) </out>
    
/////////////////////////////////////////////////////////////////////////// Title

    rule <k> (tt C:Content => C ) ...</k>
        <out>... (.List => ListItem(" title=")) </out>
    
/////////////////////////////////////////////////////////////////////////// Min

    rule <k> (mn C:Content => C ) ...</k>
        <out>... (.List => ListItem(" min=")) </out>

/////////////////////////////////////////////////////////////////////////// Max

    rule <k> (mx C:Content => C ) ...</k>
        <out>... (.List => ListItem(" max=")) </out>
    
    rule <k> (: => .) ...</k>
        <out>... (.List => ListItem(">\n")) </out>
    
/////////////////////////////////////////////////////////////////// Regula pentru content
    
    rule <k>((C:Content) => .) ...</k>
        <out>... (.List => ListItem(C)) </out>







    

    
   







endmodule