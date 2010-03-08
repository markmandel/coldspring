<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-01-18 01:00:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xmldoc'
ROOT_ET='#DOCUMENTS'
DESCR='<b>XML File Documentor Template</b> -- allows to compile any number of XML files of any possible types into a single document with the fancy formatting and table of contents, which can be especially suitable for printing.'
TITLE_EXPR='title = getStringParam("docTitle");\ntitle != "" ? title : getAttrStringValue("xmlName")'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='docTitle';
		param.title='Documentation Title';
		param.description='Specify the title for the documentation. For a single XML file,\nby default, the title will be the XML\'s name.';
		param.type='string';
		param.trimSpaces='true';
	}
	PARAM={
		param.name='sorting';
		param.title='Sorting';
		param.description='Specify how XML files should be sorted.';
		param.type='enum';
		param.enum.values='none;by name;by path';
	}
	PARAM={
		param.name='include';
		param.title='Include';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='include.toc';
		param.title='Table of Contents';
		param.description='Include Table of Contents';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='include.nsb';
		param.title='Namespace Bindings';
		param.description='Include Namespace Bindings report';
		param.type='boolean';
	}
	PARAM={
		param.name='fmt.page.breakBefore';
		param.title='Start from new page';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='fmt.page.breakBefore.file';
		param.title='Each XML file';
		param.description='Start each XML file from a new page';
		param.type='boolean';
	}
	PARAM={
		param.name='fmt.page.breakBefore.nsb';
		param.title='Namespace Bindings';
		param.description='Start Namespace Bindings report from a new page';
		param.type='boolean';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs2';
	doc.page.margin.top='42.5';
}
<STYLES>
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs1';
		style.default='true';
	}
	PAR_STYLE={
		style.name='Heading 1';
		style.id='s1';
		text.font.name='Arial';
		text.font.size='16';
		text.font.style.bold='true';
		par.level='1';
		par.page.keepWithNext='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs2';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s2';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Page header / footer';
		style.id='cs3';
		text.font.name='Arial';
		text.font.style.italic='true';
	}
	CHAR_STYLE={
		style.name='TOC';
		style.id='cs4';
		text.font.name='Verdana';
	}
	PAR_STYLE={
		style.name='TOC Heading 1';
		style.id='s3';
		text.font.name='Arial';
		text.font.size='16';
		text.font.style.bold='true';
		text.font.style.italic='true';
		par.margin.bottom='12';
		par.page.keepWithNext='true';
	}
</STYLES>
<PAGE_FOOTER>
	<AREA_SEC>
		FMT={
			sec.outputStyle='table';
			text.style='cs3';
			table.sizing='Relative';
			table.cellpadding.horz='1';
			table.border.style='none';
			table.border.top.style='solid';
		}
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						FMT={
							ctrl.size.width='303';
							ctrl.size.height='39.8';
						}
						FORMULA='getStringParam("docTitle")'
					</DATA_CTRL>
					<PANEL>
						FMT={
							content.outputStyle='text-par';
							ctrl.size.width='196.5';
							ctrl.size.height='39.8';
							tcell.align.horz='Right';
							table.border.style='none';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='Page'
									</LABEL>
									<DATA_CTRL>
										DOCFIELD='page'
									</DATA_CTRL>
									<LABEL>
										TEXT='of'
									</LABEL>
									<DATA_CTRL>
										DOCFIELD='num-pages'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</PANEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</PAGE_FOOTER>
<ROOT>
	<FOLDER>
		DESCR='TABLE OF CONTENTS'
		COND='getBooleanParam("include.toc")'
		<BODY>
			<AREA_SEC>
				FMT={
					par.style='s3';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FORMULA='(title = getParam("docTitle")) != "" ? title : "Table of Contents"'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='TOC (for RTF output)'
				COND='output.format.supportsPagination'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								DOCFIELD='toc'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<FOLDER>
				DESCR='generates an alternative TOC (for non-framed HTML output)'
				COND='! output.format.supportsPagination'
				FMT={
					sec.outputStyle='list';
					text.style='cs4';
					list.type='ordered';
				}
				<BODY>
					<ELEMENT_ITER>
						FMT={
							sec.outputStyle='list-items';
							list.type='ordered';
						}
						TARGET_ET='#DOCUMENT'
						SCOPE='simple-location-rules'
						RULES={
							'* -> #DOCUMENT';
						}
						SORTING='by-expr'
						SORTING_KEY={expr='(sorting = getStringParam("sorting")) == "by name" \n  ? getAttrStringValue("xmlName") \n  :  sorting == "by path" ? getAttrStringValue("xmlURI") : ""',ascending}
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'"detail"';
													}
												</DOC_HLINK>
												ATTR='xmlName'
											</DATA_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</ELEMENT_ITER>
					<AREA_SEC>
						COND='hyperTargetExists ("xmlns-bindings")'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										<DOC_HLINK>
											HKEYS={
												'"xmlns-bindings"';
											}
										</DOC_HLINK>
										TEXT='Namespace Bindings'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
		</BODY>
	</FOLDER>
	<ELEMENT_ITER>
		DESCR='DOC FOR EACH XML FILE'
		TARGET_ET='#DOCUMENT'
		SCOPE='simple-location-rules'
		RULES={
			'* -> #DOCUMENT';
		}
		SORTING='by-expr'
		SORTING_KEY={expr='(sorting = getStringParam("sorting")) == "by name" \n  ? getAttrStringValue("xmlName") \n  :  sorting == "by path" ? getAttrStringValue("xmlURI") : ""',ascending}
		<BODY>
			<TEMPLATE_CALL>
				DESCR='(start from a new page)'
				COND='getBooleanParam("fmt.page.breakBefore.file")'
				FMT={
					sec.spacing.before='18';
					sec.page.breakBefore='true';
				}
				TEMPLATE_FILE='lib/Document.tpl'
				BREAK_PARENT_BLOCK='when-executed'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				FMT={
					sec.spacing.before='18';
				}
				TEMPLATE_FILE='lib/Document.tpl'
			</TEMPLATE_CALL>
		</BODY>
	</ELEMENT_ITER>
	<FOLDER>
		DESCR='NAMESPACE BINDINGS'
		COND='getBooleanParam("include.nsb")'
		FMT={
			sec.spacing.before='18';
		}
		<BODY>
			<TEMPLATE_CALL>
				DESCR='(start from a new page)'
				COND='getBooleanParam("fmt.page.breakBefore.nsb")'
				FMT={
					sec.page.breakBefore='true';
				}
				TEMPLATE_FILE='lib/xmlns-bindings.tpl'
				OUTPUT_DIR_EXPR='output.filesDir'
				BREAK_PARENT_BLOCK='when-executed'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				DESCR='(continue on the same page)'
				TEMPLATE_FILE='lib/xmlns-bindings.tpl'
				OUTPUT_DIR_EXPR='output.filesDir'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
	<TEMPLATE_CALL>
		DESCR='Bottom Message'
		TEMPLATE_FILE='lib/about.tpl'
	</TEMPLATE_CALL>
</ROOT>
CHECKSUM='9wEQfquWtIuN5PX7RDTpzUyjktgBBTOFht2YCUoYXwM'
</DOCFLEX_TEMPLATE>