<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-04-26 03:31:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ETS={'xs:%annotated';'xs:schema'}
<TEMPLATE_PARAMS>
	PARAM={
		param.name='proc.annotation';
		param.title='Annotations';
		param.title.style.bold='true';
		param.description='This group of parameters controls processing and formatting of annotations (the content of <b><code>&lt;xs:annotation&gt;</code></b> elements specified in XML schemas).\n<p>\nThe annotation text, which appears in a particular <i>"Annotation"</i> section of the generate documentation, is produced from all &lt;xs:documentation&gt; elements found by the path:\n<dl><dd>\n<code><b><i>xs:annotated</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nwhere <code><i>\'xs:annotated\'</i></code> is the XSD element which defines either the XML schema itself (<code>\'xs:schema\'</code>) or a schema component (e.g. <code>\'xs:complexType\'</code>) being documented.\n<p>\nMultiple &lt;xs:documentation&gt; elements will produce different sections of the annotation text.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='proc.annotation.appinfo';
		param.title='<appinfo>';
		param.title.style.bold='true';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='proc.annotation.appinfo.source';
		param.title='Source URI';
		param.type='enum';
		param.enum.values='as_see_link;as_title;no';
	}
	PARAM={
		param.name='proc.annotation.documentation';
		param.title='<documentation>';
		param.title.style.bold='true';
		param.grouping='true';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='proc.annotation.documentation.lang';
		param.title='Language';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='string';
		param.trimSpaces='true';
		param.noEmptyString='true';
		param.list='true';
		param.list.noEmptyList='true';
	}
	PARAM={
		param.name='proc.annotation.documentation.lang.alt';
		param.title='Alternative Language';
		param.type='string';
		param.trimSpaces='true';
		param.noEmptyString='true';
		param.list='true';
		param.list.noEmptyList='true';
	}
	PARAM={
		param.name='proc.annotation.documentation.source';
		param.title='Source URI';
		param.type='enum';
		param.enum.values='as_see_link;as_title;no';
	}
	PARAM={
		param.name='proc.annotation.tags';
		param.title='Tags';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml';
		param.title='XHTML';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas';
		param.title='For schemas';
		param.title.style.italic='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas.include';
		param.title='Include';
		param.title.style.italic='true';
		param.type='string';
		param.trimSpaces='true';
		param.collapseSpaces='true';
		param.noEmptyString='true';
		param.list='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas.exclude';
		param.title='Exclude';
		param.title.style.italic='true';
		param.type='string';
		param.trimSpaces='true';
		param.collapseSpaces='true';
		param.noEmptyString='true';
		param.list='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas.this';
		param.title='This schema';
		param.title.style.italic='true';
		param.description='Indicates if processing of XHTML tags is enabled for this particular schema (to which the annotated definition belongs).\n\nThis parameter is calculated dynamically from other parameters and the context element passed to the template.';
		param.type='boolean';
		param.default.expr='getBooleanParam("proc.annotation.tags.xhtml")\n&&\n{\n  schemaFileName = getXMLDocument().getAttrValue("xmlName");\n\n  includeFiles = getArrayParam("proc.annotation.tags.xhtml.schemas.include");\n  excludeFiles = getArrayParam("proc.annotation.tags.xhtml.schemas.exclude");\n\n  (includeFiles.isEmpty() || includeFiles.contains (schemaFileName)) &&\n  ! excludeFiles.contains (schemaFileName)\n}';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.images';
		param.title='Include Images';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.images.copy';
		param.title='Copy Images';
		param.type='boolean';
	}
	PARAM={
		param.name='proc.annotation.tags.other';
		param.title='Other Tags';
		param.type='enum';
		param.enum.values='show;xhtml;no';
	}
	PARAM={
		param.name='proc.annotation.encode.markup.chars';
		param.title='Encode markup characters';
		param.type='boolean';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs3';
}
<STYLES>
	CHAR_STYLE={
		style.name='Code Smaller';
		style.id='cs1';
		text.font.name='Courier New';
		text.font.size='8';
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
		style.name='Normal';
		style.id='s1';
		style.default='true';
	}
</STYLES>
<ROOT>
	<FOLDER>
		DESCR='find the first <xs:annotation> child and set it as the context element\n(see "Context Element" tab)'
		CONTEXT_ELEMENT_EXPR='findChild ("xs:annotation")'
		MATCHING_ET='xs:annotation'
		<BODY>
			<AREA_SEC>
				COND='getBooleanParam("proc.annotation.tags.xhtml.schemas.this")'
				FMT={
					sec.outputStyle='text-par';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FMT={
									ctrl.option.text.collapseSpaces='true';
									ctrl.option.text.trimSpaces='true';
									ctrl.option.text.noBlankOutput='true';
									text.option.renderNLs='false';
									txtfl.option.renderEmbeddedHTML='true';
								}
								FORMULA='firstSentence (\n  callStockSection ("HTMLDoc"),\n  true,\n  output.format.renderEmbeddedHTML\n)'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				FMT={
					sec.outputStyle='text-par';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FMT={
									ctrl.option.text.collapseSpaces='true';
									ctrl.option.text.trimSpaces='true';
									ctrl.option.text.noBlankOutput='true';
									text.option.renderNLs='false';
									txtfl.option.renderEmbeddedHTML='true';
								}
								FORMULA='proc_documentation = getBooleanParam("proc.annotation.documentation");\nproc_appinfo = getBooleanParam("proc.annotation.appinfo");\n\n// the following works basically the same as the content of "HTMLDoc" stock-section;\n// the produced pieces of text are received in the \'texts\' array variable\n\ntexts = Vector();\n\n(proc_documentation &&\n  (langs = getArrayParam("proc.annotation.documentation.lang")) != null) ?\n{\n  // filtering by languages specified\n\n  iterate (\n    findChildren (\n      "xs:appinfo|xs:documentation",\n      BooleanQuery (\n        instanceOf("xs:documentation") ?\n          langs.containsIgnoreCase (getAttrStringValue("xml:lang")) : proc_appinfo\n      )\n    ),\n    @el,\n    FlexQuery ({\n      values = el.toElement().getValuesByLPath ("descendant::(#TEXT|#CDATA)");\n      ! isBlank (values) ? texts.addElement (collapseSpaces (mergeStrings (values)));\n    })\n  );\n\n  (texts.isEmpty() &&\n    (langs = getArrayParam("proc.annotation.documentation.lang.alt")) != null) ? \n  {\n    iterate (\n      findChildren (\n        "xs:documentation",\n        BooleanQuery (langs.containsIgnoreCase (getAttrStringValue("xml:lang")))\n      ),\n      @el,\n      FlexQuery ({\n        values = el.toElement().getValuesByLPath ("descendant::(#TEXT|#CDATA)");\n        ! isBlank (values) ? texts.addElement (collapseSpaces (mergeStrings (values)));\n      })\n    )\n  }\n\n} : {  // otherwise, no filtering by languages was specified\n\n  iterate (\n    findChildren (\n      "xs:appinfo|xs:documentation",\n      BooleanQuery (\n        instanceOf("xs:documentation") ? proc_documentation : proc_appinfo\n      )\n    ),\n    @el,\n    FlexQuery ({\n      values = el.toElement().getValuesByLPath ("descendant::(#TEXT|#CDATA)");\n      ! isBlank (values) ? texts.addElement (collapseSpaces (mergeStrings (values)));\n    })\n  )\n};\n\n// merge all text blocks into a single string\ntext = mergeStrings (texts, \' \');\n\n// extract the first sentence\n\noutput.format.renderEmbeddedHTML\n ? firstSentence (text, ! getBooleanParam ("proc.annotation.encode.markup.chars"), true)\n : firstSentence (text, false)'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
</ROOT>
<STOCK_SECTIONS>
	<ATTR_ITER>
		DESCR='generates the list of the element\'s attributes'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		SCOPE='enumerated-attrs'
		EXCL_PASSED=false
		FILTER='name = iterator.attr.name;\nname != "xmlns" && ! name.startsWith ("xmlns:")'
		SS_NAME='AttrList'
		<BODY>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DELIMITER>
							</DELIMITER>
							<DATA_CTRL>
								FORMULA='iterator.attr.name'
							</DATA_CTRL>
							<LABEL>
								TEXT='="'
							</LABEL>
							<DATA_CTRL>
								FORMULA='encodeXMLChars (\n  iterator.attr.dsmAttr.rawValue,\n  true, true, true, false\n)'
							</DATA_CTRL>
							<LABEL>
								TEXT='"'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</ATTR_ITER>
	<FOLDER>
		DESCR='generates a single HTML output from the annotation passed in the context element'
		MATCHING_ET='xs:annotation'
		SS_NAME='HTMLDoc'
		<BODY>
			<ELEMENT_ITER>
				DESCR='execute when no filtering by language needed:\nIterate by all <xs:appinfo> and/or <xs:documentation> elements found in the annotation\n(see "Processing | Scope" tab)'
				COND='! getBooleanParam("proc.annotation.documentation") ||\ngetParam("proc.annotation.documentation.lang") == null'
				FMT={
					sec.outputStyle='text-par';
				}
				TARGET_ETS={'xs:appinfo';'xs:documentation'}
				SCOPE='simple-location-rules'
				RULES={
					'* -> (xs:appinfo|xs:documentation)';
				}
				FILTER='instanceOf("xs:documentation")\n ? getBooleanParam("proc.annotation.documentation")\n : getBooleanParam("proc.annotation.appinfo")'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<ELEMENT_ITER>
						DESCR='iterate by all nodes contained in <xs:documentation>/<xs:appinfo> element'
						FMT={
							txtfl.delimiter.type='none';
						}
						TARGET_ET='<ANY>'
						SCOPE='simple-location-rules'
						RULES={
							'* -> *';
						}
						<BODY>
							<SS_CALL>
								DESCR='processing of each node'
								FMT={
									sec.indent.left='10';
								}
								SS_NAME='Node'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='otherwise, filtering by language specified:\n\nIterates by all <xs:documentation> (and possibly <xs:appinfo>) elements which are found by the location path \'xs:annotation/xs:(documentation|xs:appinfo)\' \n(see "Processing | Scope" tab).\n\n<xs:documentation> elements must have the \'xml:lang\' attribute with the needed value. Filtering is specified directly within the location path.'
				FMT={
					sec.outputStyle='text-par';
				}
				TARGET_ETS={'xs:appinfo';'xs:documentation'}
				SCOPE='simple-location-rules'
				RULES={
					'* -> (xs:appinfo|xs:documentation)';
				}
				FILTER='instanceOf("xs:documentation") ? \n{\n  getArrayParam(\n    "proc.annotation.documentation.lang"\n  ).containsIgnoreCase (getAttrStringValue("xml:lang"))\n} : {\n getBooleanParam("proc.annotation.appinfo")\n}'
				BREAK_PARENT_BLOCK='when-output'
				<BODY>
					<ELEMENT_ITER>
						DESCR='iterate by all nodes contained in <xs:documentation>/<xs:appinfo> element'
						FMT={
							txtfl.delimiter.type='none';
						}
						TARGET_ET='<ANY>'
						SCOPE='simple-location-rules'
						RULES={
							'* -> *';
						}
						<BODY>
							<SS_CALL>
								DESCR='processing of each node'
								FMT={
									sec.indent.left='10';
								}
								SS_NAME='Node'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='otherwise, no output generated still, seek documentation by alternative language\n--\nexecute when filtering by alternative language is specified; see "Component | Enabling" tab.'
				COND='getParam("proc.annotation.documentation.lang.alt") != null'
				TARGET_ET='xs:documentation'
				SCOPE='simple-location-rules'
				RULES={
					'* -> xs:documentation';
				}
				FILTER='getArrayParam(\n  "proc.annotation.documentation.lang.alt"\n).containsIgnoreCase (getAttrStringValue("xml:lang"))'
				<BODY>
					<ELEMENT_ITER>
						DESCR='iterate by all nodes contained in <xs:documentation> element'
						FMT={
							txtfl.delimiter.type='none';
						}
						TARGET_ET='<ANY>'
						SCOPE='simple-location-rules'
						RULES={
							'* -> *';
						}
						<BODY>
							<SS_CALL>
								DESCR='processing of each node'
								FMT={
									sec.indent.left='10';
								}
								SS_NAME='Node'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</ELEMENT_ITER>
		</BODY>
	</FOLDER>
	<FOLDER>
		DESCR='processing the documentation node'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		SS_NAME='Node'
		<BODY>
			<AREA_SEC>
				DESCR='case of text or character data node'
				MATCHING_ETS={'#CDATA';'#TEXT'}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FMT={
									ctrl.option.text.noEmptyOutput='true';
								}
								FORMULA='text = contextElement.value.toString();\n\ntext = stockSection.recursionDepth > 0 \n         ? text.collapseSpaces (false)\n         : text.collapseSpaces (iterator.isFirstItem, iterator.isLastItem);\n\ngetBooleanParam ("proc.annotation.encode.markup.chars") ?\n  encodeXMLChars (text) : text'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<ELEMENT_ITER>
				DESCR='otherwise, if the current element belongs to the XHTML namespace and processing of XHTML tags is enabled, reprint the element\'s tags so as they look as an ordinary HTML and process the element\'s content.'
				COND='getBooleanParam("proc.annotation.tags.xhtml.schemas.this")\n&&\n(contextElement.belongsToNS ("xhtml") ||\n hasParamValue("proc.annotation.tags.other", "xhtml"))'
				TARGET_ET='<ANY>'
				SCOPE='simple-location-rules'
				RULES={
					'* -> *';
				}
				FILTER='! contextElement.dsmElement.pseudoElement ||\ninstanceOf ("#TEXT | #CDATA")'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<SS_CALL>
						DESCR='calls this stock-section recursively'
						FMT={
							sec.indent.left='10';
						}
						SS_NAME='Node'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='<'
									</LABEL>
									<DATA_CTRL>
										FORMULA='contextElement.dsmElement.localName'
									</DATA_CTRL>
									<SS_CALL_CTRL>
										SS_NAME='AttrList'
									</SS_CALL_CTRL>
									<LABEL>
										TEXT='>'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
				<FOOTER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='</'
									</LABEL>
									<DATA_CTRL>
										FORMULA='contextElement.dsmElement.localName'
									</DATA_CTRL>
									<LABEL>
										TEXT='>'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</FOOTER>
				<ELSE>
					DESCR='this is executed when no child nodes encountered -- the case of a simple element'
					<AREA_SEC>
						COND='! contextElement.dsmElement.localName.equalsIgnoreCase ("img")'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='<'
									</LABEL>
									<DATA_CTRL>
										FORMULA='contextElement.dsmElement.localName'
									</DATA_CTRL>
									<SS_CALL_CTRL>
										SS_NAME='AttrList'
									</SS_CALL_CTRL>
									<LABEL>
										TEXT='>'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</ELSE>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='otherwise, in case of any non-XHTML element, only process the element content'
				TARGET_ET='<ANY>'
				SCOPE='simple-location-rules'
				RULES={
					'* -> *';
				}
				FILTER='! contextElement.dsmElement.pseudoElement ||\ninstanceOf ("#TEXT | #CDATA")'
				<BODY>
					<SS_CALL>
						DESCR='calls this stock-section recursively'
						FMT={
							sec.indent.left='10';
						}
						SS_NAME='Node'
					</SS_CALL>
				</BODY>
			</ELEMENT_ITER>
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='S5Vaj6hjK07V2tN6bRvo3IVDPpTIAaXtVnFQJi1jjeI'
</DOCFLEX_TEMPLATE>