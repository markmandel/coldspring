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
		param.name='doc.schema.xml';
		param.title='XML Source';
		param.title.style.bold='true';
		param.description='Specifies whether to includes in the <i>Schema Overview</i> documentation the reproduced XML source of the whole XML schema.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls how the reproduced XML source will look and what it should include.\n</dd></dl>';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
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
		param.default.expr='"Namespace " + ((ns = getStringParam("nsURI")) != "" ? \'"\' + ns + \'"\' : "{global namespace}")';
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
		param.name='elements.local';
		param.title='Local Elements';
		param.type='enum';
		param.enum.values='all;complexType;none';
	}
	PARAM={
		param.name='item.annotation';
		param.title='Annotation';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
	}
	PARAM={
		param.name='fmt.page.refs';
		param.title='Generate page references';
		param.type='boolean';
		param.default.value='true';
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
		param.name='doc.comp.profile.type';
		param.title='Type';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.content';
		param.title='Content';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.abstract';
		param.title='Abstract';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.block';
		param.title='Block';
		param.grouping='true';
		param.type='enum';
		param.enum.values='any;non_default;none';
	}
	PARAM={
		param.name='doc.comp.profile.block.value';
		param.title='Value';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.block.meaning';
		param.title='Meaning';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.final';
		param.title='Final';
		param.grouping='true';
		param.type='enum';
		param.enum.values='any;non_default;none';
	}
	PARAM={
		param.name='doc.comp.profile.final.value';
		param.title='Value';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.final.meaning';
		param.title='Meaning';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.subst';
		param.title='Subst.Gr';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.subst.heads';
		param.title='List of group heads';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.subst.members';
		param.title='List of group members';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.nillable';
		param.title='Nillable';
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
	PARAM={
		param.name='show';
		param.title='Show';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='show.localElementExt';
		param.title='Local Element Extensions';
		param.type='enum';
		param.enum.values='always;repeating;never';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs4';
}
<STYLES>
	CHAR_STYLE={
		style.name='Code';
		style.id='cs1';
		text.font.name='Courier New';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Code Smaller';
		style.id='cs2';
		text.font.name='Courier New';
		text.font.size='8';
	}
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs3';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs4';
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
		style.name='Note Font';
		style.id='cs6';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='false';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Page Header Font';
		style.id='cs7';
		text.font.name='Arial';
		text.font.style.italic='true';
	}
	CHAR_STYLE={
		style.name='Page Number';
		style.id='cs8';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Property Title Font';
		style.id='cs9';
		text.font.size='8';
		text.font.style.bold='true';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Property Value Font';
		style.id='cs10';
		text.font.name='Verdana';
		text.font.size='8';
		par.lineHeight='11';
	}
	CHAR_STYLE={
		style.name='Summary Heading Font';
		style.id='cs11';
		text.font.size='12';
		text.font.style.bold='true';
	}
</STYLES>
<PAGE_HEADER>
	<AREA_SEC>
		FMT={
			sec.outputStyle='table';
			text.style='cs7';
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
							ctrl.size.width='403.5';
							ctrl.size.height='17.3';
						}
						FORMULA='getStringParam("page.heading.left")'
					</DATA_CTRL>
					<LABEL>
						FMT={
							ctrl.size.width='96';
							ctrl.size.height='17.3';
							tcell.align.horz='Right';
							tcell.option.nowrap='true';
						}
						TEXT='Element Summary'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</PAGE_HEADER>
<ROOT>
	<ELEMENT_ITER>
		INIT_EXPR='output.format.supportsPageRefs ?\n{\n  showPageColumn = false;\n\n  getBooleanParam("fmt.page.columns") && output.generating ?\n  {\n    index = 0;\n    repeat (BooleanQuery ({\n\n      (el = iterator.itemAt (index).toElement()) != null ?\n      {\n        showPageColumn = hyperTargetExists (ArgumentList (\n          el.id, Array ("detail", "def", "xml-source-location")\n        ));\n\n        index = index + 1;\n        ! showPageColumn\n\n      } : false;\n    }));\n  };\n\n  thisContext.setVar ("showPageColumn", showPageColumn)\n}'
		FMT={
			sec.outputStyle='table';
			table.sizing='Relative';
			table.cellpadding.both='3';
		}
		TARGET_ET='xs:%element'
		SCOPE='advanced-location-rules'
		RULES={
			'#DOCUMENTS[hasParamValue("scope", "any")] -> #DOCUMENT[hasAttr ("initial") &&\ngetBooleanParam("gen.doc.for.schemas.initial")\n||\nhasAttr ("imported") &&\ngetBooleanParam("gen.doc.for.schemas.imported")\n||\nhasAttr ("included") &&\ngetBooleanParam("gen.doc.for.schemas.included")\n||\nhasAttr ("redefined") &&\ngetBooleanParam("gen.doc.for.schemas.redefined")]/xs:schema/descendant::xs:%element';
			'#DOCUMENTS[hasParamValue("scope", "namespace")] -> {findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema/descendant::xs:%element[instanceOf("xs:element") || ! hasAttr("ref") &&\n{\n  form = hasAttr("form") ? getAttrValue("form") :\n           findPredecessorByType("xs:schema").getAttrStringValue ("elementFormDefault");\n\n  (form == "qualified" || getParam("nsURI") == "")\n}]';
			'#DOCUMENTS[hasParamValue("scope", "namespace") &&\ngetParam("nsURI") == ""] -> {findElementsByKey ("namespaces", "")}::xs:%localElement';
			'xs:schema -> descendant::xs:%element';
		}
		FILTER_BY_KEY='/* Local elements with the same {name:type} signature\nmay appear in the initially generated scope many times,\nas many as the number of such element components. However,\nsince all local elements with the same name and global type\nare documented as a single quasi-global element, \nmultiple {name:type} entries must be reduced to only one. \nAll global elements and local elements with anonymous type\nmust be preserved in the list. So, for them the key must be \nunique for each component (e.g. GOMElement.id). \nThe following expression generates a necessary key. */\n\ninstanceOf ("xs:%localElement") &&\n  (typeQName = getAttrQNameValue("type")) != null ?\n{\n  schema = findAncestor ("xs:schema");\n\n  HashKey (\n    ((hasAttr("form") ? getAttrValue("form") :\n       schema.getAttrValue ("elementFormDefault")) == "qualified" \n         ? schema.getAttrStringValue("targetNamespace") : ""),\n    getAttrStringValue("name"),\n    typeQName\n  )\n} : contextElement.id'
		FILTER='instanceOf("xs:element") || ! hasAttr("ref") &&\n{\n  // case of local element\n\n  local = getStringParam("elements.local");\n  \n  local == "complexType" ?\n    ((typeQName = getAttrQNameValue("type")) != null) ?\n      findElementByKey ("types", typeQName).instanceOf("xs:complexType")\n    : hasChild("xs:complexType")\n  :\n  local == "all"\n}'
		SORTING='by-expr'
		SORTING_KEY={expr='callStockSection("Element Name")',ascending}
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
								SS_NAME='Element Name'
							</SS_CALL_CTRL>
							<SS_CALL_CTRL>
								FMT={
									ctrl.size.width='318';
									ctrl.size.height='17.3';
									tcell.sizing='Relative';
								}
								SS_NAME='Element'
							</SS_CALL_CTRL>
							<DATA_CTRL>
								COND='output.format.supportsPageRefs &&\nthisContext.getBooleanVar ("showPageColumn")'
								FMT={
									ctrl.size.width='31.5';
									ctrl.size.height='17.3';
									ctrl.option.noHLinkFmt='true';
									tcell.align.horz='Center';
									tcell.align.vert='Top';
									text.style='cs8';
									text.hlink.fmt='none';
								}
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'Array ("detail", "def", "xml-source-location")',array;
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
							<PANEL>
								FMT={
									ctrl.size.width='467.3';
									ctrl.size.height='41.3';
									text.style='cs11';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												COND='hasParamValue("elements.local", "all")'
												TEXT='All'
											</LABEL>
											<LABEL>
												COND='hasParamValue("elements.local", "none")'
												TEXT='Global'
											</LABEL>
											<LABEL>
												FMT={
													tcell.sizing='Relative';
													text.style='cs11';
												}
												TEXT='Element Summary'
											</LABEL>
											<DELIMITER>
												FMT={
													text.style='cs1';
												}
											</DELIMITER>
											<LABEL>
												COND='hasParamValue("elements.local", "complexType")'
												FMT={
													text.style='cs6';
												}
												TEXT='(global + local with complex types)'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<LABEL>
								COND='output.format.supportsPageRefs &&\nthisContext.getBooleanVar ("showPageColumn")'
								FMT={
									ctrl.size.width='32.3';
									ctrl.size.height='41.3';
									tcell.align.horz='Center';
									text.style='cs8';
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
		SS_NAME='annotation'
		<BODY>
			<TEMPLATE_CALL>
				OUTPUT_CHECKER_EXPR='getValuesByLPath(\n  "xs:annotation/xs:documentation//(#TEXT | #CDATA)"\n).isBlank() ? -1 : 1'
				FMT={
					text.style='cs5';
				}
				TEMPLATE_FILE='../ann/annotation.tpl'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
	<FOLDER>
		MATCHING_ET='xs:%element'
		INIT_EXPR='schema = findPredecessorByType ("xs:schema");\n\nnsURI = instanceOf ("xs:element") ? schema.getAttrStringValue("targetNamespace") :\n          (hasAttr("form") ? getAttrValue("form") :\n            schema.getAttrStringValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : "";\n\nusageMapKey = instanceOf ("xs:%localElement") && \n                (typeQName = getAttrQNameValue("type")) != null\n  ? HashKey (nsURI, getAttrStringValue("name"), typeQName) : contextElement.id;\n\nstockSection.setVar ("nsURI", nsURI);\nstockSection.setVar ("usageMapKey", usageMapKey);\nstockSection.setVar ("usageCount", countElementsByKey ("element-usage", usageMapKey));'
		SS_NAME='Element'
		<BODY>
			<TEMPLATE_CALL>
				COND='hasParamValue ("item.annotation", "first_sentence")\n&&\n(instanceOf("xs:element") || stockSection.getIntVar("usageCount") == 1)'
				OUTPUT_CHECKER_EXPR='getValuesByLPath(\n  "xs:annotation/xs:documentation//(#TEXT | #CDATA)"\n).isBlank() ? -1 : 1'
				FMT={
					text.style='cs5';
				}
				TEMPLATE_FILE='../ann/firstSentence.tpl'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				COND='getBooleanParam("doc.comp.profile")\n&&\ngetBooleanParam("fmt.allowNestedTables")'
				FMT={
					sec.spacing.before='6';
				}
				TEMPLATE_FILE='elementProfile.tpl'
				PASSED_PARAMS={
					'nsURI','stockSection.getStringVar("nsURI")';
					'usageMapKey','stockSection.getVar("usageMapKey")';
					'usageCount','stockSection.getIntVar("usageCount")';
				}
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				COND='getBooleanParam("doc.comp.profile")\n&&\n! getBooleanParam("fmt.allowNestedTables")'
				FMT={
					sec.spacing.before='6';
				}
				TEMPLATE_FILE='elementProfile2.tpl'
				PASSED_PARAMS={
					'nsURI','stockSection.getStringVar("nsURI")';
					'usageMapKey','stockSection.getVar("usageMapKey")';
					'usageCount','stockSection.getIntVar("usageCount")';
				}
			</TEMPLATE_CALL>
			<FOLDER>
				DESCR='full annotation'
				COND='hasParamValue("item.annotation", "full")'
				FMT={
					sec.spacing.before='8';
				}
				COLLAPSED
				<BODY>
					<SS_CALL>
						DESCR='case of global element or local element defined in one location\n-\nprint the only annotation'
						COND='instanceOf("xs:element") || \nstockSection.getIntVar("usageCount") == 1'
						FMT={
							text.style='cs5';
						}
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='annotation'
					</SS_CALL>
					<ELEMENT_ITER>
						DESCR='case of "quasi-global" local element defined at multiple locations\n--\nprint all annotations by definition locations'
						OUTPUT_CHECKER_EXPR='checkElementsByKey (\n  "element-usage",\n  stockSection.getVar ("usageMapKey"),\n  BooleanQuery (checkStockSectionOutput ("annotation"))\n) ? 1 : -1'
						FINISH_EXPR='removeElementMap ("local-annotations")'
						TARGET_ET='#CUSTOM'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='prepareElementMap (\n  "local-annotations",\n  findElementsByKey ("element-usage", stockSection.getVar ("usageMapKey")),\n  FlexQuery ({\n    ann = callStockSection ("annotation");\n    (ann != "") ? ann : null\n  })\n);\n\nCustomElements (getElementMapKeys ("local-annotations"))'
						<BODY>
							<ELEMENT_ITER>
								DESCR='iterate by all locations with the same (current) annotation'
								OUTPUT_CHECKER_EXPR='1 // the output always exists'
								FMT={
									sec.outputStyle='text-par';
									sec.spacing.before='8';
									list.type='delimited';
									list.margin.block='true';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='findElementsByKey ("local-annotations", contextElement.value)'
								<BODY>
									<AREA_SEC>
										FMT={
											text.style='cs10';
										}
										<AREA>
											<CTRL_GROUP>
												<CTRLS>
													<LABEL>
														<DOC_HLINK>
															HKEYS={
																'contextElement.id';
																'"def"';
															}
														</DOC_HLINK>
														TEXT='within'
													</LABEL>
													<PANEL>
														CONTEXT_ELEMENT_EXPR='findPredecessorByType("xs:%element|xs:complexType|xs:group")'
														MATCHING_ETS={'xs:%element';'xs:complexType';'xs:group'}
														FMT={
															ctrl.size.width='260.3';
															ctrl.size.height='38.3';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		MATCHING_ET='xs:%element'
																		TEXT='element'
																	</LABEL>
																	<LABEL>
																		MATCHING_ET='xs:complexType'
																		TEXT='complexType'
																	</LABEL>
																	<LABEL>
																		MATCHING_ET='xs:group'
																		TEXT='group'
																	</LABEL>
																	<SS_CALL_CTRL>
																		FMT={
																			text.style='cs2';
																		}
																		SS_NAME='XMLName'
																	</SS_CALL_CTRL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<DELIMITER>
														FMT={
															txtfl.delimiter.type='text';
															txtfl.delimiter.text=', ';
														}
													</DELIMITER>
												</CTRLS>
											</CTRL_GROUP>
										</AREA>
									</AREA_SEC>
								</BODY>
								<HEADER>
									<AREA_SEC>
										<AREA>
											<CTRL_GROUP>
												<CTRLS>
													<LABEL>
														FMT={
															text.style='cs9';
															text.decor.underline='true';
														}
														TEXT='Annotation'
													</LABEL>
													<LABEL>
														FMT={
															text.style='cs10';
														}
														TEXT='('
													</LABEL>
												</CTRLS>
											</CTRL_GROUP>
										</AREA>
									</AREA_SEC>
								</HEADER>
								<FOOTER>
									<AREA_SEC>
										FMT={
											text.style='cs10';
										}
										<AREA>
											<CTRL_GROUP>
												<CTRLS>
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
								</FOOTER>
							</ELEMENT_ITER>
							<SS_CALL>
								FMT={
									sec.spacing.before='8';
									text.style='cs5';
								}
								SS_NAME='annotation'
								PASSED_ELEMENT_EXPR='findElementByKey ("local-annotations", contextElement.value)'
								PASSED_ELEMENT_MATCHING_ET='xs:%element'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</FOLDER>
		</BODY>
	</FOLDER>
	<AREA_SEC>
		MATCHING_ET='xs:%element'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		SS_NAME='Element Name'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<SS_CALL_CTRL>
						SS_NAME='XMLName'
					</SS_CALL_CTRL>
					<TEMPLATE_CALL_CTRL>
						COND='instanceOf("xs:%localElement") &&\n(\n  hasParamValue("show.localElementExt", "always")\n  ||\n  hasParamValue("show.localElementExt", "repeating") &&\n  {\n    schema = findAncestor ("xs:schema");\n\n    qName = QName (\n      ((hasAttr("form") ? getAttrValue("form") :\n          schema.getAttrValue ("elementFormDefault")) == "qualified" \n            ? schema.getAttrStringValue("targetNamespace") : ""),\n      getAttrStringValue("name")\n    );\n\n    countElementsByKey ("global-elements", qName) +\n    countElementsByKey ("local-elements", qName) > 1\n  }\n)'
						MATCHING_ET='xs:%localElement'
						FMT={
							text.font.style.bold='false';
						}
						TEMPLATE_FILE='localElementExt.tpl'
					</TEMPLATE_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<FOLDER>
		DESCR='prints the qualified name of any global schema component and local element (passed as the stock-section context element)'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='XMLName'
		<BODY>
			<AREA_SEC>
				DESCR='case of global element or global complexType'
				MATCHING_ETS={'xs:complexType';'xs:element'}
				FMT={
					par.option.nowrap='true';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								COND='! getAttrBooleanValue ("abstract")'
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:element") ? "global element" : "complexType"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name")\n)'
							</DATA_CTRL>
							<DATA_CTRL>
								COND='getAttrBooleanValue ("abstract")'
								FMT={
									text.font.style.italic='true';
								}
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:element") ?\n  "abstract global element" : "abstract complexType"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name")\n)'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='case of a local element'
				MATCHING_ET='xs:%localElement'
				FMT={
					txtfl.delimiter.type='none';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "def", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='name = getAttrStringValue("name");\nschema = findAncestor ("xs:schema");\n\n(hasAttr("form") ? getAttrValue("form") :\n  schema.getAttrValue ("elementFormDefault")) == "qualified" \n    ? toXMLName (schema.getAttrStringValue("targetNamespace"), name) : name'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='any other (global) component'
				FMT={
					txtfl.delimiter.type='none';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:simpleType") ? "simpleType" : \n  instanceOf ("xs:group") ? "group" : \n    instanceOf ("xs:attributeGroup") ? "attributeGroup" : \n      instanceOf ("xs:attribute") ? "global attribute" : ""'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name")\n)'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='pqMnAbIc8Jfl?uPq6LKTaawwjK72Q8w0ARf4PiwQmuE'
</DOCFLEX_TEMPLATE>