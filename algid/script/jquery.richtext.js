;(function($){
	$.algid = $.algid || {};
	
	$.algid.richtext = {
		useRichText: true,
		contextSelector: 'body',
		types: {
			css: {
				nameSpace: 'css',
				onEnter: {},
				onShiftEnter: {keepDefault:false, placeHolder:'Your comment here', openWith:'\n\/* ', closeWith:' *\/'},
				onCtrlEnter: {keepDefault:false, placeHolder:"classname", openWith:'\n.', closeWith:' { \n'},
				onTab: {keepDefault:false, openWith:'  '},
				markupSet:  [	
					{name:'Class', className:'class', key:'N', placeHolder:'Properties here...', openWith:'.[![Class name]!] {\n', closeWith:'\n}'},
					{separator:'---------------' },
					{name:'Bold', className:'bold', key:'B', replaceWith:'font-weight:bold;'},
					{name:'Italic', className:'italic', key:'I', replaceWith:'font-style:italic;'},
					{name:'Stroke through',  className:'stroke', key:'S', replaceWith:'text-decoration:line-through;'},
					{separator:'---------------' },
					{name:'Lowercase', className:'lowercase', key:'L', replaceWith:'text-transform:lowercase;'},
					{name:'Uppercase', className:'uppercase', key:'U', replaceWith:'text-transform:uppercase;'},
					{separator:'---------------' },
					{name:'Text indent', className:'indent', openWith:'text-indent:', placeHolder:'5px', closeWith:';' },
					{name:'Letter spacing', className:'letterspacing', openWith:'letter-spacing:', placeHolder:'5px', closeWith:';' },
					{name:'Line height', className:'lineheight', openWith:'line-height:', placeHolder:'1.5', closeWith:';' },
					{separator:'---------------' },
					{name:'Alignments', className:'alignments', dropMenu:[
						{name:'Left', className:'left', replaceWith:'text-align:left;'},
						{name:'Center', className:'center', replaceWith:'text-align:center;'},
						{name:'Right', className:'right', replaceWith:'text-align:right;'},
						{name:'Justify', className:'justify', replaceWith:'text-align:justify;'}
						]
					},
					{name:'Padding/Margin', className:'padding', dropMenu:[
							{name:'Top', className:'top', openWith:'(!(padding|!|margin)!)-top:', placeHolder:'5px', closeWith:';' },
							{name:'Left', className:'left', openWith:'(!(padding|!|margin)!)-left:', placeHolder:'5px', closeWith:';' },
							{name:'Right', className:'right', openWith:'(!(padding|!|margin)!)-right:', placeHolder:'5px', closeWith:';' },
							{name:'Bottom', className:'bottom', openWith:'(!(padding|!|margin)!)-bottom:', placeHolder:'5px', closeWith:';' }
						]
					},
					{separator:'---------------' },
					{name:'Background Image', className:'background', replaceWith:'background:url([![Source:!:http://]!]) no-repeat 0 0;' },
					{separator:'---------------' },
					{name:'Import CSS file',  className:'css', replaceWith:'@import "[![Source file:!:.css]!]";' }
				]
			},
			html: {
				nameSpace: 'html',
				onShiftEnter: {keepDefault:false, replaceWith:'<br />\n'},
				onCtrlEnter: {keepDefault:false, openWith:'\n<p>', closeWith:'</p>\n'},
				onTab: {keepDefault:false, openWith:'	 '},
				markupSet: [
					{name:'Heading 1', key:'1', openWith:'<h1(!( class="[![Class]!]")!)>', closeWith:'</h1>', placeHolder:'Your title here...' },
					{name:'Heading 2', key:'2', openWith:'<h2(!( class="[![Class]!]")!)>', closeWith:'</h2>', placeHolder:'Your title here...' },
					{name:'Heading 3', key:'3', openWith:'<h3(!( class="[![Class]!]")!)>', closeWith:'</h3>', placeHolder:'Your title here...' },
					{name:'Heading 4', key:'4', openWith:'<h4(!( class="[![Class]!]")!)>', closeWith:'</h4>', placeHolder:'Your title here...' },
					{name:'Heading 5', key:'5', openWith:'<h5(!( class="[![Class]!]")!)>', closeWith:'</h5>', placeHolder:'Your title here...' },
					{name:'Heading 6', key:'6', openWith:'<h6(!( class="[![Class]!]")!)>', closeWith:'</h6>', placeHolder:'Your title here...' },
					{name:'Paragraph', openWith:'<p(!( class="[![Class]!]")!)>', closeWith:'</p>' },
					{separator:'---------------' },
					{name:'Bold', key:'B', openWith:'(!(<strong>|!|<b>)!)', closeWith:'(!(</strong>|!|</b>)!)' },
					{name:'Italic', key:'I', openWith:'(!(<em>|!|<i>)!)', closeWith:'(!(</em>|!|</i>)!)' },
					{name:'Stroke through', key:'S', openWith:'<del>', closeWith:'</del>' },
					{separator:'---------------' },
					{name:'Ul', openWith:'<ul>\n', closeWith:'</ul>\n' },
					{name:'Ol', openWith:'<ol>\n', closeWith:'</ol>\n' },
					{name:'Li', openWith:'<li>', closeWith:'</li>' },
					{separator:'---------------' },
					{name:'Picture', key:'P', replaceWith:'<img src="[![Source:!:http://]!]" alt="[![Alternative text]!]" />' },
					{name:'Link', key:'L', openWith:'<a href="[![Link:!:http://]!]"(!( title="[![Title]!]")!)>', closeWith:'</a>', placeHolder:'Your text to link...' },
					{separator:'---------------' },
					{name:'Clean', className:'clean', replaceWith:function(markitup) { return markitup.selection.replace(/<(.*?)>/g, "") } },
					//{name:'Preview', className:'preview', call:'preview' }
				]
			},
			markdown: {
				nameSpace: 'markdown',
				onShiftEnter: {keepDefault:false, openWith:'\n\n'},
				markupSet: [
					{name:'Heading 1', key:'1', openWith:'# ', placeHolder:'Your title here...' },
					{name:'Heading 2', key:'2', openWith:'## ', placeHolder:'Your title here...' },
					{name:'Heading 3', key:'3', openWith:'### ', placeHolder:'Your title here...' },
					{name:'Heading 4', key:'4', openWith:'#### ', placeHolder:'Your title here...' },
					{name:'Heading 5', key:'5', openWith:'##### ', placeHolder:'Your title here...' },
					{name:'Heading 6', key:'6', openWith:'###### ', placeHolder:'Your title here...' },
					{separator:'---------------' },		
					{name:'Bold', key:'B', openWith:'**', closeWith:'**'},
					{name:'Italic', key:'I', openWith:'_', closeWith:'_'},
					{separator:'---------------' },
					{name:'Bulleted List', openWith:'- ' },
					{name:'Numeric List', openWith:function(markItUp) {
						return markItUp.line+'. ';
					}},
					{separator:'---------------' },
					{name:'Picture', key:'P', replaceWith:'![[![Alternative text]!]]([![Url:!:http://]!] "[![Title]!]")'},
					{name:'Link', key:'L', openWith:'[', closeWith:']([![Url:!:http://]!] "[![Title]!]")', placeHolder:'Your text to link here...' },
					{separator:'---------------'},	
					{name:'Quotes', openWith:'> '},
					{name:'Code Block / Code', openWith:'(!(\t|!|`)!)', closeWith:'(!(`)!)'}
				]
			},
			textile: {
				nameSpace: 'textile',
				onShiftEnter: {keepDefault:false, replaceWith:'\n\n'},
				markupSet: [
					{name:'Heading 1', key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
					{name:'Heading 2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
					{name:'Heading 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
					{name:'Heading 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
					{name:'Heading 5', key:'5', openWith:'h5(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
					{name:'Heading 6', key:'6', openWith:'h6(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
					{name:'Paragraph', key:'P', openWith:'p(!(([![Class]!]))!). '},
					{separator:'---------------' },
					{name:'Bold', key:'B', closeWith:'*', openWith:'*'},
					{name:'Italic', key:'I', closeWith:'_', openWith:'_'},
					{name:'Stroke through', key:'S', closeWith:'-', openWith:'-'},
					{separator:'---------------' },
					{name:'Bulleted list', openWith:'(!(* |!|*)!)'},
					{name:'Numeric list', openWith:'(!(# |!|#)!)'}, 
					{separator:'---------------' },
					{name:'Picture', replaceWith:'![![Source:!:http://]!]([![Alternative text]!])!'}, 
					{name:'Link', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Your text to link here...' },
					{separator:'---------------' },
					{name:'Quotes', openWith:'bq(!(([![Class]!]))!). '},
					{name:'Code', openWith:'@', closeWith:'@'},
					//{separator:'---------------' },
					//{name:'Preview', call:'preview', className:'preview'}
				]
			},
			wiki: {
				nameSpace: 'wiki',
				onShiftEnter: {keepDefault:false, replaceWith:'\n\n'},
				markupSet: [
					{name:'Heading 1', key:'1', openWith:'== ', closeWith:' ==', placeHolder:'Your title here...' },
					{name:'Heading 2', key:'2', openWith:'=== ', closeWith:' ===', placeHolder:'Your title here...' },
					{name:'Heading 3', key:'3', openWith:'==== ', closeWith:' ====', placeHolder:'Your title here...' },
					{name:'Heading 4', key:'4', openWith:'===== ', closeWith:' =====', placeHolder:'Your title here...' },
					{name:'Heading 5', key:'5', openWith:'====== ', closeWith:' ======', placeHolder:'Your title here...' },
					{separator:'---------------' },		
					{name:'Bold', key:'B', openWith:"'''", closeWith:"'''"}, 
					{name:'Italic', key:'I', openWith:"''", closeWith:"''"}, 
					{name:'Stroke through', key:'S', openWith:'<s>', closeWith:'</s>'}, 
					{separator:'---------------' },
					{name:'Bulleted list', openWith:'(!(* |!|*)!)'}, 
					{name:'Numeric list', openWith:'(!(# |!|#)!)'}, 
					{separator:'---------------' },
					{name:'Picture', key:"P", replaceWith:'[[Image:[![Url:!:http://]!]|[![name]!]]]'}, 
					{name:'Link', key:"L", openWith:"[[![Link]!] ", closeWith:']', placeHolder:'Your text to link here...' },
					{name:'Url', openWith:"[[![Url:!:http://]!] ", closeWith:']', placeHolder:'Your text to link here...' },
					{separator:'---------------' },
					{name:'Quotes', openWith:'(!(> |!|>)!)', placeHolder:''},
					{name:'Code', openWith:'(!(<source lang="[![Language:!:php]!]">|!|<pre>)!)', closeWith:'(!(</source>|!|</pre>)!)'}, 
					//{separator:'---------------' },
					//{name:'Preview', call:'preview', className:'preview'}
				]
			}
		}
	};
	
	$(function() {
		$('textarea', $($.algid.richtext.contextSelector)).richtext();
	});
	
	$.fn.richtext = function() {
		// Check if enabled
		if($.algid.richtext.useRichText) {
			// Remove any previous markdown editor
			this.markItUpRemove();
			
			// Find all supported editors
			for( type in $.algid.richtext.types ) {
				this.filter('.editor-' + type).each(function(){
					var editor = $(this);
					var settings = $.extend({}, $.algid.richtext.types[type], editor.data('settings'));
					var extraSettings = editor.data('extraSettings');
					
					editor.markItUp(settings, extraSettings);
					
					editor.removeClass('editor-' + type);
				}).end;
			}
		}
	};
})(jQuery);
