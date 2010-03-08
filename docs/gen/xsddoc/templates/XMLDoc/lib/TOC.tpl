<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-03-04 07:58:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xmldoc'
ROOT_ET='#DOCUMENTS'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='docTitle';
		param.title='Documentation Title';
		param.type='string';
	}
	PARAM={
		param.name='sorting';
		param.title='Sorting';
		param.type='enum';
		param.enum.values='none;by name';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs2';
}
<STYLES>
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs1';
		style.default='true';
	}
	PAR_STYLE={
		style.name='Frame Heading';
		style.id='s1';
		text.font.size='11';
		text.font.style.bold='true';
		par.margin.bottom='6';
	}
	PAR_STYLE={
		style.name='Frame Item';
		style.id='s2';
		text.font.size='9';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Subheading';
		style.id='s3';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.top='10';
		par.margin.bottom='6';
		par.option.nowrap='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs2';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s4';
		style.default='true';
	}
</STYLES>
<ROOT>
	<AREA_SEC>
		FMT={
			par.style='s1';
		}
		<AREA>
			<CTRL_GROUP>
				FMT={
					txtfl.delimiter.type='none';
				}
				<CTRLS>
					<DATA_CTRL>
						FMT={
							txtfl.option.renderEmbeddedHTML='true';
						}
						FORMULA='getStringParam("docTitle")'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		COND='documentByTemplate("xmlns-bindings") != ""'
		FMT={
			par.style='s2';
		}
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						<DOC_HLINK>
							TARGET_FRAME_EXPR='"detailFrame"'
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
	<ELEMENT_ITER>
		TARGET_ET='#DOCUMENT'
		SCOPE='simple-location-rules'
		RULES={
			'* -> #DOCUMENT';
		}
		SORTING='by-expr'
		SORTING_KEY={expr='getStringParam("sorting") == "by name" ? getAttrStringValue("xmlName")  :  ""',ascending}
		<BODY>
			<AREA_SEC>
				FMT={
					par.style='s2';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							par.option.nowrap='true';
						}
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TARGET_FRAME_EXPR='"detailFrame"'
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
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s3';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='XML Files'
							</LABEL>
							<DATA_CTRL>
								FORMULA='"(" + iterator.numItems + ")"'
							</DATA_CTRL>
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='none';
								}
							</DELIMITER>
							<LABEL>
								TEXT=':'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</ELEMENT_ITER>
</ROOT>
CHECKSUM='Sif7qNjalVLwW+PyqNdQzm3cDU5whFkoKnISV9teQoE'
</DOCFLEX_TEMPLATE>