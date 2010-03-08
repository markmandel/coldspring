<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-03-04 07:50:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
TEMPLATE_TYPE='FramesetTemplate'
DSM_TYPE_ID='xmldoc'
ROOT_ET='#DOCUMENTS'
DESCR='<b>XML File Documentor Template (framed version)</b> -- allows to compile any number of XML files of any possible types into a framed documentation with the fancy formatting and table of contents frame.'
TITLE_EXPR='getStringParam("docTitle")'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='docTitle';
		param.title='Documentation Title';
		param.description='Specify the title for the documentation.';
		param.type='string';
	}
	PARAM={
		param.name='sorting';
		param.title='Sorting';
		param.description='Specify the order in which XML files are sorted in table of contents frame.';
		param.type='enum';
		param.enum.values='none;by name';
	}
	PARAM={
		param.name='include';
		param.title='Include';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='include.nsb';
		param.title='Namespace Bindings';
		param.description='Include Namespace Bindings report';
		param.type='boolean';
		param.default.value='true';
	}
</TEMPLATE_PARAMS>
<FRAMESET>
	LAYOUT='columns'
	<FRAME>
		PERCENT_SIZE=20
		NAME='listFrame'
		SOURCE_EXPR='documentByTemplate("TOC")'
	</FRAME>
	<FRAME>
		PERCENT_SIZE=80
		NAME='detailFrame'
		SOURCE_EXPR='documentByTemplate("Document")'
	</FRAME>
</FRAMESET>
<STYLES>
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs1';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs2';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s1';
		style.default='true';
	}
</STYLES>
<ROOT>
	<ELEMENT_ITER>
		DESCR='iterates by all XML documents'
		TARGET_ET='#DOCUMENT'
		SCOPE='simple-location-rules'
		RULES={
			'* -> child-or-self::#DOCUMENT';
		}
		SORTING='by-expr'
		SORTING_KEY={expr='getStringParam("sorting") == "by name" ? getAttrStringValue("xmlName")  :  ""',ascending}
		<BODY>
			<TEMPLATE_CALL>
				DESCR='generates a single-file doc for each XML document'
				TEMPLATE_FILE='lib/Document.tpl'
				OUTPUT_TYPE='document'
				OUTPUT_DIR_EXPR='output.filesDir'
				FILE_NAME_EXPR='getAttrStringValue("xmlName").replace(".", "_")'
			</TEMPLATE_CALL>
		</BODY>
	</ELEMENT_ITER>
	<TEMPLATE_CALL>
		COND='getBooleanParam("include.nsb")'
		TEMPLATE_FILE='lib/xmlns-bindings.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		DESCR='generates index of XML files'
		TEMPLATE_FILE='lib/TOC.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
	</TEMPLATE_CALL>
</ROOT>
CHECKSUM='PhXuI1Qi6+AaEMWU1zZ3+kN3ccWG0zd8KtcwrcRiGX4'
</DOCFLEX_TEMPLATE>