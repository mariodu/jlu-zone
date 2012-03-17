mySettings = {
	previewParserPath:	'',
	onShiftEnter:		{keepDefault:false, openWith:'\n\n'},
	markupSet: [
		{name:'Heading 1', key:'1', openWith:'# ', placeHolder:'' },
		{name:'Heading 2', key:'2', openWith:'## ', placeHolder:'' },
		{name:'Heading 3', key:'3', openWith:'### ', placeHolder:'' },
		{name:'Heading 4', key:'4', openWith:'#### ', placeHolder:'' },
		{name:'Heading 5', key:'5', openWith:'##### ', placeHolder:'' },
		{name:'Heading 6', key:'6', openWith:'###### ', placeHolder:'' },
		{separator:'---------------' },		
		{name:'Bold', key:'B', openWith:'**', closeWith:'**'},
		{name:'Italic', key:'I', openWith:"''", closeWith:"''"},
		{separator:'---------------' },
		{name:'Bulleted List', openWith:'- ' },
		{name:'Numeric List', openWith:'+' },
		{separator:'---------------' },
		{name:'Picture', key:'P', replaceWith:'[[[![Alternative text]!] [![Url:!:http://]!] center]]'},
		{name:'Link', key:'L', openWith:'[[', closeWith:' [![Url:!:http://]!]]]', placeHolder:'Your text to link here...' },
		{separator:'---------------'},
		{name:'Quotes', openWith:'-------\n', closeWith:'\n-------\n'},
		{name:'Code Block / Code', openWith:'``', closeWith:'``'},
	]
}

// mIu nameSpace to avoid conflict.
miu = {
    markminTitle: function(markItUp, char) {
	heading = '';
	n = $.trim(markItUp.selection||markItUp.placeHolder).length;
	for(i = 0; i < n; i++) {
	    heading += char;
	}
	return '\n'+heading;
    }
}

$(document).ready(function() {  
    $('textarea').markItUp(mySettings);  
}); 