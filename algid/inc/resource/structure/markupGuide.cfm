<div id="markupguide">
	<h2 id="headerexamples">Header <a href="#">Examples</a></h2>
	<p>The secondary header above is an <code>h2</code> element, which may be used for any form of important page-level header. More than one may be used per page. Consider using an <code>h2</code> unless you need a header level of less importance, or as a sub-header to an existing <code>h2</code> element. Any header level may include links, as depicted in the example.</p>
	
	<h3>Third-Level Header</h3>
	<p>The header above is an <code>h3</code> element, which may be used for any form of page-level header which falls below the <code>h2</code> header in a document hierarchy. More than one may be used per page.</p>
	
	<h4>Fourth-Level Header</h4>
	
	<p>For all headers below third-level, follow the guidelines listed above. Only use lower header levels when necessary.</p>
	
	<h5>Fifth-Level Header</h5>
	<p>For all headers below third-level, follow the guidelines listed above. Only use lower header levels when necessary.</p>
	
	<h6>Sixth-Level Header</h6>
	<p>For all headers below third-level, follow the guidelines listed above. Only use lower header levels when necessary.</p>
	
	<hr />
	<h2 id="paragraphs">Paragraphs</h2>
	<p>All paragraphs are wrapped in <code>p</code> tags. Additionally, <code>p</code> elements can be wrapped with a <code>blockquote</code> element <em>if the <code>p</code> element is indeed a quote</em>. Historically, <code>blockquote</code> has been used purely to force indents, but this is now achieved using CSS. Reserve <code>blockquote</code> for quotes. Here's an example of correct usage:</p>
	
	<blockquote cite="http://lipsum.com/feed/html">
		<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Cras euismod fringilla arcu. Integer posuere. Aliquam ipsum. Donec eget massa ac orci tempus euismod. Donec quis neque nec neque consequat sollicitudin. Donec commodo tempor nulla. Suspendisse venenatis. Ut ut leo. Nunc placerat urna at libero. Nunc suscipit lacus.</p>
		<p><cite><a href="http://lipsum.com/feed/html">lipsum.com</a></cite></p>
	</blockquote>
	
	<p>Additionally, you might wish to cite the source, as in the above example. (The correct method involves the <code>cite</code> attribute directly applied to the <code>blockquote</code> element, but since no browser makes any use of that information whatsoever, it's useful to also specify the standalone <code>cite</code> element.)</p>
	
	<hr />
	<h2 id="inlinetext">Inline Text</h2>
	<p>You might have noticed all the monospaced text in this guide. There are a number of inline <abbr title="HyperText Markup Language">HTML</abbr> elements you may use anywhere within other elements, including <abbr title="Abbreviation">abbr</abbr>, <acronym title="Acronym">acronym</acronym>, <cite>cite</cite>, <code>code</code>, <del>del</del>, <em>em</em>, <ins>ins</ins>, <kbd>kbd</kbd>, <strong>strong</strong>, and <var>var</var>.</p>
	
	<dl>
		<dt><abbr title="Abbreviation">abbr</abbr></dt>
		<dd>Used for any abbreviated text, whether it be acronym, initialism, or otherwise. Generally, it's less work and useful (enough) to mark up only the first occurence of any particular abbreviation on a page, and ignore the rest. Any text in the <code>title</code> attribute will appear when the user's mouse hovers the abbreviation (although notably, this does not work in Internet Explorer for Windows). Example abbreviations and usage: <abbr title="National Aeronautics and Space Administration">NASA</abbr>, <abbr title="HyperText Markup Language">HTML</abbr>, and <abbr title="Massachusetts">Mass.</abbr></dd>
		
		<dt><acronym title="Acronym">acronym</acronym></dt>
		<dd>
			<p>Used for only specific abbreviations. Like <code>abbr</code>, any text in the <code>title</code> attribute will appear when the user's mouse hovers the acronym (unlike <code>abbr</code>, however, this <em>does</em> work in Internet Explorer for Windows.) According to <a href="http://m-w.com/cgi-bin/dictionary?book=Dictionary&amp;va=acronym">Mirriam Webster</a>, acronyms are:</p>
			
			<blockquote cite="http://m-w.com/cgi-bin/dictionary?book=Dictionary&amp;va=acronym"><p>...a word (as <acronym title="North Atlantic Treaty Organization">NATO</acronym>, <acronym title="RAdio Detecting And Ranging">radar</acronym> [...] ) formed from the initial letter or letters of each of the successive parts or major parts of a compound term; also : an abbreviation (as <acronym title="Federeal Bureau of Investigation">FBI</acronym>) formed from initial letters.</p></blockquote>
			<p>If you think the difference between <code>acronym</code> and <code>abbr</code> is esoteric, you're probably right.</p>
		</dd>
		
		<dt><code>code</code></dt>
		<dd>
		 <p>Used for computer code samples. Useful for technology-oriented sites, not so useful otherwise. Example code and usage:</p>
		 <pre><code>function getJello() {
	echo $aDeliciousSnack;
}</code></pre>
		 <p>Inline usage: just like elsewhere in this document, <abbr title="HyperText Markup Language">HTML</abbr> elements like <code>em</code> or <code>code</code> can be considered code, and marked up as such.</p>
		</dd>
		
		<dt><cite>cite</cite></dt>
		<dd>Used for defining a citation or reference to other information sources. Example cited text and usage: More information can be found in <cite>[ISO-0000]</cite></dd>
		
		<dt><del datetime="2005-05-30T13:00:00">del</del></dt>
		<dd>Used for deleted or retracted text which still must remain on the page for some reason. Since the default style includes a strikethrough line, it's preferable to the <code>s</code> element. The <code>del</code> element also has a <code>datetime</code> attribute which allows you to include a timestamp directly in the element. Example deleted text and usage: She bought <del datetime="2005-05-30T13:00:00">two</del> <ins datetime="2005-05-30T13:00:00">five</ins> pairs of shoes.</dd>
		
		<dt><em>em</em></dt>
		<dd>Used for denoting emphasized text. In most instances where you'd want to italicize text (using the <abbr title="HyperText Markup Language">HTML</abbr> element <code>i</code> or otherwise) you should use the <code>em</code> element instead. Notable exceptions are stylistic italicizing of proper titles, foreign languages, etc. where italicizing is used for differentiation instead of emphasis. In those cases, no proper <abbr title="HyperText Markup Language">HTML</abbr> elements exist, so an <code>i</code> element or a <code>span</code> element with a custom class may be preferable. Example emphasized text and usage: You simply <em>must</em> try the negitoro maki!</dd>
		
		<dt><ins datetime="2005-05-30T13:00:00">ins</ins></dt>
		<dd>Used for inserted text and counterpart to the <code>del</code> element. Like <code>del</code>, <code>ins</code> has a <code>datetime</code> attribute which allows you to include a timestamp directly in the element. Example inserted text and usage: She bought <del datetime="2005-05-30T13:00:00">two</del> <ins datetime="2005-05-30T13:00:00">five</ins> pairs of shoes.</dd>
		
		<dt><kbd>kbd</kbd></dt>
		<dd>Used for text which should be typed by the user. Mainly useful for computer instructions. Example keyboard text and usage: Please press <kbd>Enter</kbd> to continue.</dd>
		
		<dt><strong>strong</strong></dt>
		<dd>Used for denoting stronger emphasis than the <code>em</code> element. In most instances where you'd want to bold text (using the <abbr title="HyperText Markup Language">HTML</abbr> element <code>b</code> or otherwise) you should use the <code>strong</code> element instead. Notable exceptions are stylistic bolding of examples, first occurences of names in an article, etc. where bolding is used for differentiation instead of emphasis. In those cases, no proper <abbr title="HyperText Markup Language">HTML</abbr> elements exist, so <code>b</code> element or a <code>span</code> element with a custom class may be preferable. Example strong text and usage: <strong>Don't</strong> stick nails in the electrical outlet.</dd>
		
		<dt><var>var</var></dt>
		<dd>Used for variables within computer code snippets. Useful for technology-oriented sites, not so useful otherwise. Example code and usage: Add 5 to <var>$result</var> and recalculate.</dd>
	</dl>
	
	<hr />
	
	<h2 id="lists">Lists</h2>
	<p>Then there are the lists. <code>ul</code> denotes an unordered list (ie. a list of loose items that don't require numbering, or a bulleted list). <code>ol</code> denotes an ordered list, and various numbering schemes are available through the CSS (including 1,2,3... a,b,c... i,ii,iii... and so on). Each item within the <code>ul</code> or <code>ol</code> requires a surrounding <code>&lt;li&gt;</code> and <code>&lt;/li&gt;</code> tag, to denote individual items within the list (as you may have guessed, <code>li</code> stands for list item).</p>
	
	<p>Additionally, <code>dl</code> is another list type called a definition list. Instead of list items, the content of a <code>dl</code> consists of <code>dt</code> (Definition Term) and <code>dd</code> (Definition description) pairs. Though it may be called a "definition list", <code>dl</code> can apply to other scenarios where a parent/child relationship is applicable. For example, it may be used for marking up dialogues, with each <code>dt</code> naming a speaker, and each <code>dd</code> containing his or her words.</p>
	
	<p>Example lists and usage:</p>
	
	<ul>
		<li>This is an unordered list.</li>
		<li>It has two items.</li>
	</ul>
	
	<ol>
		<li>This is an ordered list.</li>
		<li>It has two items.</li>
		<li>No, I lied, it has three.</li>
	</ol>
	
	<dl>
		<dt>This is a term.</dt>
		<dd>This is the definition of that term, which both live in a <code>dl</code>.</dd>
		
		<dt>Here is another term.</dt>
		<dd>And it gets a definition too, which is this line.</dd>
		
		<dt>Here is term that shares a definition with the term below.</dt>
		<dt>Here is a defined term.</dt>
		<dd><code>dt</code> terms may stand on their own without an accompanying <code>dd</code>, but in that case they <em>share</em> descriptions with the next available <code>dt</code>. You may not have a <code>dd</code> without a parent <code>dt</code>.</dd>
	</dl>
</div>