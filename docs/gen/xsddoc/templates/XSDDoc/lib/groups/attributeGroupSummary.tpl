<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2004-06-21 01:50:00'
LAST_UPDATE='2009-10-30 06:36:30'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ETS={'#DOCUMENTS';'xs:schema'}
<TEMPLATE_PARAMS>
	PARAM={
		param.name='nsURI';
		param.title='Namespace URI';
		param.type='string';
	}
	PARAM={
		param.name='scope';
		param.description='Indicates the scope of the main document for which this template is called:\n"any" - unspecified;\n"namespace" - namespace overview;\n"schema" - schema overview';
		param.type='enum';
		param.enum.values='any;namespace;schema';
	}
	PARAM={
		param.name='page.heading.left';
		param.title='Page Heading (on the left)';
		param.type='string';
	}
	PARAM={
		param.name='item.annotation';
		param.title='Annotation';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
	}
	PARAM={
		param.name='gen.doc.for.schemas';
		param.title='For Schemas';
		param.title.style.italic='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='gen.doc.for.schemas.initial';
		param.title='Initial';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.for.schemas.imported';
		param.title='Imported';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.for.schemas.included';
		param.title='Included';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.for.schemas.redefined';
		param.title='Redefined';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile';
		param.title='Component Profile';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.namespace';
		param.title='Namespace';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.content';
		param.title='Content';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.defined';
		param.title='Defined';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.includes';
		param.title='Includes';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.redefines';
		param.title='Redefines';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.redefined';
		param.title='Redefined';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.used';
		param.title='Used';
		param.type='boolean';
	}
	PARAM={
		param.name='fmt.allowNestedTables';
		param.title='Allow nested tables';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='fmt.page.columns';
		param.title='Generate page columns';
		param.type='boolean';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs3';
}
<STYLES>
	CHAR_STYLE={
		style.name='Code';
		style.id='cs1';
		text.font.name='Courier New';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs2';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs3';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='Main Heading';
		style.id='s1';
		text.font.name='Verdana';
		text.font.size='13';
		text.font.style.bold='true';
		text.color.foreground='#4477AA';
		par.bkgr.opaque='true';
		par.bkgr.color='#EEEEEE';
		par.border.style='solid';
		par.border.color='#4477AA';
		par.margin.top='0';
		par.margin.bottom='9';
		par.padding.left='5';
		par.padding.right='5';
		par.padding.top='3';
		par.padding.bottom='3';
		par.page.keepTogether='true';
		par.page.keepWithNext='true';
	}
	CHAR_STYLE={
		style.name='Name Modifier';
		style.id='cs4';
		text.font.name='Verdana';
		text.font.size='7';
		text.color.foreground='#B2B2B2';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s2';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Normal Smaller';
		style.id='cs5';
		text.font.name='Arial';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Page Header Font';
		style.id='cs6';
		text.font.name='Arial';
		text.font.style.italic='true';
	}
	CHAR_STYLE={
		style.name='Page Number';
		style.id='cs7';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Summary Heading Font';
		style.id='cs8';
		text.font.size='12';
		text.font.style.bold='true';
	}
</STYLES>
<PAGE_HEADER>
	<AREA_SEC>
		FMT={
			sec.outputStyle='table';
			text.style='cs6';
			table.sizing='Relative';
			table.cellpadding.horz='1';
			table.cellpadding.vert='0';
			table.border.style='none';
			table.border.bottom.style='solid';
		}
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						FMT={
							ctrl.size.width='398.3';
							ctrl.size.height='17.3';
						}
						FORMULA='getStringParam("page.heading.left")'
					</DATA_CTRL>
					<LABEL>
						FMT={
							ctrl.size.width='101.3';
							ctrl.size.height='17.3';
							tcell.align.horz='Right';
							tcell.option.nowrap='true';
						}
						TEXT='Attribute Group Summary'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</PAGE_HEADER>
<ROOT>
	<ELEMENT_ITER>
		INIT_EXPR='output.format.supportsPageRefs ?\n{\n  showPageColumn = false;\n\n  getBooleanParam("fmt.page.columns") && output.generating ?\n  {\n    index = 0;\n    repeat (BooleanQuery ({\n\n      (el = iterator.itemAt (index).toElement()) != null ?\n      {\n        showPageColumn = hyperTargetExists (ArgumentList (\n          el.id, Array ("detail", "xml-source-location")\n        ));\n\n        index = index + 1;\n        ! showPageColumn\n\n      } : false;\n    }));\n  };\n\n  thisContext.setVar ("showPageColumn", showPageColumn)\n}'
		FMT={
			sec.outputStyle='table';
			table.sizing='Relative';
			table.cellpadding.both='3';
		}
		TARGET_ET='xs:attributeGroup'
		SCOPE='advanced-location-rules'
		RULES={
			'#DOCUMENTS[hasParamValue("scope", "any")] -> #DOCUMENT[hasAttr ("initial") &&\ngetBooleanParam("gen.doc.for.schemas.initial")\n||\nhasAttr ("imported") &&\ngetBooleanParam("gen.doc.for.schemas.imported")\n||\nhasAttr ("included") &&\ngetBooleanParam("gen.doc.for.schemas.included")\n||\nhasAttr ("redefined") &&\ngetBooleanParam("gen.doc.for.schemas.redefined")]/xs:schema';
			'#DOCUMENTS[hasParamValue("scope", "namespace")] -> {findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema';
			'xs:schema -> xs:attributeGroup',recursive;
			'xs:schema -> xs:redefine/xs:attributeGroup',recursive;
		}
		SORTING='by-compound-key'
		SORTING_KEY={
			{expr='toXMLName (\n  findPredecessorByType("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue ("name")\n)',ascending};
			{expr='hasServiceAttr ("redefinition") ?\n  getServiceAttr ("redefinition").toInt() : -1',ascending};
		}
		<BODY>
			<AREA_SEC>
				FMT={
					trow.page.keepTogether='true';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<SS_CALL_CTRL>
								FMT={
									ctrl.size.width='150';
									ctrl.size.height='17.3';
									tcell.align.vert='Top';
									text.style='cs1';
									text.font.style.bold='true';
								}
								SS_NAME='Group Name'
							</SS_CALL_CTRL>
							<SS_CALL_CTRL>
								FMT={
									ctrl.size.width='318.8';
									ctrl.size.height='17.3';
									tcell.sizing='Relative';
								}
								SS_NAME='Group Info'
							</SS_CALL_CTRL>
							<DATA_CTRL>
								COND='output.format.supportsPageRefs &&\nthisContext.getBooleanVar ("showPageColumn")'
								FMT={
									ctrl.size.width='30.8';
									ctrl.size.height='17.3';
									ctrl.option.noHLinkFmt='true';
									tcell.align.horz='Center';
									tcell.align.vert='Top';
									text.style='cs7';
									text.hlink.fmt='none';
								}
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								DOCFIELD='page-htarget'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					trow.page.keepTogether='true';
					trow.page.keepWithNext='true';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							trow.bkgr.color='#CCCCFF';
						}
						<CTRLS>
							<LABEL>
								FMT={
									ctrl.size.width='468';
									ctrl.size.height='17.3';
									tcell.sizing='Relative';
									text.style='cs8';
								}
								TEXT='Attribute Group Summary'
							</LABEL>
							<LABEL>
								COND='output.format.supportsPageRefs &&\nthisContext.getBooleanVar ("showPageColumn")'
								FMT={
									ctrl.size.width='31.5';
									ctrl.size.height='17.3';
									tcell.align.horz='Center';
									text.style='cs7';
									text.font.style.bold='true';
								}
								TEXT='Page'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</ELEMENT_ITER>
</ROOT>
<STOCK_SECTIONS>
	<FOLDER>
		MATCHING_ET='xs:attributeGroup'
		SS_NAME='Group Info'
		<BODY>
			<TEMPLATE_CALL>
				COND='hasParamValue("item.annotation", "first_sentence")'
				OUTPUT_CHECKER_EXPR='getValuesByLPath(\n  "xs:annotation/xs:documentation//(#TEXT | #CDATA)"\n).isBlank() ? -1 : 1'
				FMT={
					text.style='cs5';
				}
				TEMPLATE_FILE='../ann/firstSentence.tpl'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				COND='getBooleanParam("doc.comp.profile") &&\ngetBooleanParam("fmt.allowNestedTables")'
				FMT={
					sec.spacing.before='6';
				}
				TEMPLATE_FILE='attributeGroupProfile.tpl'
				PASSED_PARAMS={
					'nsURI','findPredecessorByType("xs:schema").getAttrStringValue("targetNamespace")';
				}
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				COND='getBooleanParam("doc.comp.profile") &&\n! getBooleanParam("fmt.allowNestedTables")'
				FMT={
					sec.spacing.before='6';
				}
				TEMPLATE_FILE='attributeGroupProfile2.tpl'
				PASSED_PARAMS={
					'nsURI','findPredecessorByType("xs:schema").getAttrStringValue("targetNamespace")';
				}
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				DESCR='full annotation'
				COND='hasParamValue("item.annotation", "full")'
				OUTPUT_CHECKER_EXPR='getValuesByLPath(\n  "xs:annotation/xs:documentation//(#TEXT | #CDATA)"\n).isBlank() ? -1 : 1'
				FMT={
					sec.spacing.before='8';
					text.style='cs5';
				}
				TEMPLATE_FILE='../ann/annotation.tpl'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
	<AREA_SEC>
		SS_NAME='Group Name'
		<AREA>
			<CTRL_GROUP>
				FMT={
					txtfl.delimiter.type='none';
				}
				<CTRLS>
					<DATA_CTRL>
						<DOC_HLINK>
							TITLE_EXPR='"attributeGroup"'
							HKEYS={
								'contextElement.id';
								'Array ("detail", "xml-source-location")',array;
							}
						</DOC_HLINK>
						FORMULA='toXMLName (\n  findPredecessorByType ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue ("name")\n)'
					</DATA_CTRL>
					<SS_CALL_CTRL>
						COND='hasServiceAttr ("redefinition")'
						FMT={
							text.style='cs4';
							text.font.style.bold='false';
						}
						SS_NAME='redefinition'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='redefinition'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT=' (redefinition'
					</LABEL>
					<DELIMITER>
						FMT={
							txtfl.delimiter.type='nbsp';
						}
					</DELIMITER>
					<DATA_CTRL>
						COND='getServiceAttr("redefinition").toInt() > 0'
						FORMULA='getServiceAttr ("redefinition")'
					</DATA_CTRL>
					<DELIMITER>
						FMT={
							txtfl.delimiter.type='none';
						}
					</DELIMITER>
					<LABEL>
						TEXT=')'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</STOCK_SECTIONS>
CHECKSUM='CvtpGV6hS?KytDbddCGw98bCHaR?3P9HPCfMpOookLw'
</DOCFLEX_TEMPLATE>