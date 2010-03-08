<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-04-26 03:31:00'
LAST_UPDATE='2009-10-30 06:36:30'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ET='xs:attributeGroup'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='nsURI';
		param.title='Target Namespace URI';
		param.type='string';
		param.default.expr='findAncestor("xs:schema").getAttrStringValue("targetNamespace")';
		param.hidden='true';
	}
	PARAM={
		param.name='xmlName';
		param.description='Displayed XML name (qualified or local) of the attributeGroup';
		param.type='string';
		param.default.expr='toXMLName (getStringParam("nsURI"), getAttrStringValue("name"))';
		param.hidden='true';
	}
	PARAM={
		param.name='usageCount';
		param.description='number of locations where this attribute group is used';
		param.type='integer';
		param.default.expr='countElementsByKey ("attributeGroup-usage", contextElement.id)';
		param.hidden='true';
	}
	PARAM={
		param.name='contentModelKey';
		param.title='"content-model-attributes" map key';
		param.description='The key for "content-model-attributes" map to find items associated with this component';
		param.type='Object';
		param.default.expr='contextElement.id';
	}
	PARAM={
		param.name='attributeCount';
		param.title='number of all attributes';
		param.description='total number of attributes declared for this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n   ! instanceOf ("xs:anyAttribute") &&\n   getAttrValue("use") != "prohibited"\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='attributeWildcardCount';
		param.title='number of all attr. wildcards';
		param.description='total number of attribute wildcards declared for this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (instanceOf ("xs:anyAttribute"))\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeCount';
		param.title='number of attributes defined in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    ! instanceOf ("xs:anyAttribute") &&\n    getAttrValue("use") != "prohibited" &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup").id\n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeWildcardCount';
		param.title='number of attr. wildcards defined in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    instanceOf ("xs:anyAttribute") &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup").id\n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeProhibitionCount';
		param.title='number of attr. prohibitions specified in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    getAttrValue("use") == "prohibited" &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup").id\n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='fmt.page.refs';
		param.title='Generate page references';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp';
		param.title='Component Documentation';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.profile';
		param.title='Component Profile';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep';
		param.title='XML Representation Summary';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.attributeGroup';
		param.title='Generate For Attribute Groups';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep.sorting';
		param.title='Sorting';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage';
		param.title='Usage / Definition Locations';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
		param.default.value='optimal';
	}
	PARAM={
		param.name='doc.comp.annotation';
		param.title='Annotation';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.annotation.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xml';
		param.title='XML Source';
		param.title.style.bold='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xml.box';
		param.title='Enclose in Box';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xml.remove.anns';
		param.title='Remove Annotations';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.attributes';
		param.title='Attribute Detail';
		param.title.style.bold='true';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.attributes.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.attributes.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
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
	PARAM={
		param.name='show.about';
		param.title='About (footer)';
		param.type='enum';
		param.enum.values='full;short;none';
	}
</TEMPLATE_PARAMS>
<HTARGET>
	HKEYS={
		'contextElement.id';
		'"detail"';
	}
</HTARGET>
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
	PAR_STYLE={
		style.name='Detail Heading 1';
		style.id='s1';
		text.font.size='12';
		text.font.style.bold='true';
		par.bkgr.opaque='true';
		par.bkgr.color='#CCCCFF';
		par.border.style='solid';
		par.border.color='#666666';
		par.margin.top='12';
		par.margin.bottom='10';
		par.padding.left='2.5';
		par.padding.right='2.5';
		par.padding.top='2';
		par.padding.bottom='2';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Detail Heading 2';
		style.id='s2';
		text.font.size='10';
		text.font.style.bold='true';
		par.bkgr.opaque='true';
		par.bkgr.color='#EEEEFF';
		par.border.style='solid';
		par.border.color='#666666';
		par.margin.top='12';
		par.margin.bottom='10';
		par.padding.left='2';
		par.padding.right='2';
		par.padding.top='2';
		par.padding.bottom='2';
		par.page.keepWithNext='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs3';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='List Heading 2';
		style.id='s3';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.bottom='8';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Main Heading';
		style.id='s4';
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
		style.id='s5';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Note Font';
		style.id='cs5';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='false';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Page Header Font';
		style.id='cs6';
		text.font.name='Arial';
		text.font.style.italic='true';
	}
	CHAR_STYLE={
		style.name='Page Number Small';
		style.id='cs7';
		text.font.name='Courier New';
		text.font.size='8';
	}
</STYLES>
<PAGE_HEADER>
	<AREA_SEC>
		FMT={
			text.style='cs6';
			table.cellpadding.both='0';
			table.border.style='none';
			table.border.bottom.style='solid';
		}
		<AREA>
			<CTRL_GROUP>
				FMT={
					par.border.bottom.style='solid';
				}
				<CTRLS>
					<LABEL>
						TEXT='attributeGroup'
					</LABEL>
					<DATA_CTRL>
						FMT={
							text.font.style.italic='true';
						}
						FORMULA='\'"\' + getParam("xmlName") + \'"\''
					</DATA_CTRL>
					<SS_CALL_CTRL>
						COND='hasServiceAttr ("redefinition")'
						SS_NAME='redefinition'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</PAGE_HEADER>
<ROOT>
	<AREA_SEC>
		FMT={
			par.style='s4';
		}
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT='attributeGroup'
					</LABEL>
					<DATA_CTRL>
						FMT={
							text.font.style.italic='true';
						}
						FORMULA='\'"\' + getParam("xmlName") + \'"\''
					</DATA_CTRL>
					<SS_CALL_CTRL>
						COND='hasServiceAttr ("redefinition")'
						SS_NAME='redefinition'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<TEMPLATE_CALL>
		DESCR='Attribute Group Profile'
		COND='getBooleanParam("doc.comp.profile")'
		TEMPLATE_FILE='attributeGroupProfile.tpl'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		DESCR='XML Representation Summary'
		COND='getBooleanParam("doc.comp.xmlRep") &&\ngetBooleanParam("doc.comp.xmlRep.for.attributeGroup")'
		FMT={
			sec.spacing.before='12';
			sec.spacing.after='12';
		}
		<HTARGET>
			COND='output.type == "document"'
			HKEYS={
				'contextElement.id';
				'"xml-rep-summary"';
			}
			NAME_EXPR='"xml_rep_summary"'
		</HTARGET>
		TEMPLATE_FILE='../content/xmlRep.tpl'
		PASSED_PARAMS={
			'sorting','getBooleanParam("doc.comp.xmlRep.sorting")';
		}
	</TEMPLATE_CALL>
	<FOLDER>
		DESCR='Annotation'
		COND='getBooleanParam("doc.comp.annotation") &&\ngetBooleanParam("doc.comp.annotation.for.attributeGroup")'
		COLLAPSED
		<BODY>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='../ann/annotation.tpl'
			</TEMPLATE_CALL>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s2';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							trow.bkgr.color='#CCCCFF';
						}
						<CTRLS>
							<LABEL>
								TEXT='Annotation'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<FOLDER>
		DESCR='Usage locations'
		COND='getBooleanParam("doc.comp.usage") &&\ngetBooleanParam("doc.comp.usage.for.attributeGroup")\n&&\ngetIntParam("usageCount") > 0'
		FMT={
			sec.outputStyle='list';
			list.item.margin.top='10';
			list.item.margin.bottom='10';
		}
		<HTARGET>
			HKEYS={
				'contextElement.id';
				'"usage-locations"';
			}
		</HTARGET>
		COLLAPSED
		<BODY>
			<FOLDER>
				DESCR='in other attributeGroups'
				COND='e = findElementsByKey (\n      "attributeGroup-usage",\n      contextElement.id,\n      BooleanQuery (instanceOf ("xs:attributeGroup"))\n    );\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (el.toElement(), "XMLName"))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow or optimal\n3). there is only one item in the list'
						COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
						FMT={
							sec.outputStyle='list';
							list.type='delimited';
						}
						TARGET_ET='xs:attributeGroup'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='thisContext.getVar("locations").toEnum()'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										FMT={
											txtfl.delimiter.type='nbsp';
										}
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='XMLName'
											</SS_CALL_CTRL>
											<PANEL>
												COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
												FMT={
													ctrl.size.width='159.8';
													text.style='cs7';
													txtfl.delimiter.type='none';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<LABEL>
																TEXT='['
															</LABEL>
															<DATA_CTRL>
																FMT={
																	ctrl.option.noHLinkFmt='true';
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
															<LABEL>
																TEXT=']'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</ELEMENT_ITER>
					<FOLDER>
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
						<BODY>
							<AREA_SEC>
								FMT={
									sec.outputStyle='table';
									table.cellpadding.both='0';
									table.border.style='none';
								}
								<AREA>
									<CTRL_GROUP>
										FMT={
											trow.align.vert='Top';
										}
										<CTRLS>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='208.5';
													ctrl.size.height='17.3';
												}
												SS_NAME='Usage Location List Column'
												PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='273';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Usage Location List Column'
												PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</FOLDER>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							par.style='s3';
						}
						<HTARGET>
							HKEYS={
								'contextElement.id';
								'"usage-locations"';
							}
						</HTARGET>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='In definitions of other attributeGroups'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
			</FOLDER>
			<FOLDER>
				DESCR='in global complexTypes'
				COND='e = findElementsByKey (\n      "attributeGroup-usage",\n      contextElement.id,\n      BooleanQuery (instanceOf ("xs:complexType"))\n    );\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (el.toElement(), "XMLName"))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow or optimal\n3). there is only one item in the list'
						COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
						FMT={
							sec.outputStyle='list';
							list.type='delimited';
						}
						TARGET_ET='xs:complexType'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='thisContext.getVar("locations").toEnum()'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										FMT={
											txtfl.delimiter.type='nbsp';
										}
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='XMLName'
											</SS_CALL_CTRL>
											<PANEL>
												COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
												FMT={
													ctrl.size.width='159.8';
													text.style='cs7';
													txtfl.delimiter.type='none';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<LABEL>
																TEXT='['
															</LABEL>
															<DATA_CTRL>
																FMT={
																	ctrl.option.noHLinkFmt='true';
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
															<LABEL>
																TEXT=']'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</ELEMENT_ITER>
					<FOLDER>
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
						<BODY>
							<AREA_SEC>
								FMT={
									sec.outputStyle='table';
									table.cellpadding.both='0';
									table.border.style='none';
								}
								<AREA>
									<CTRL_GROUP>
										FMT={
											trow.align.vert='Top';
										}
										<CTRLS>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='208.5';
													ctrl.size.height='17.3';
												}
												SS_NAME='Usage Location List Column'
												PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='273';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Usage Location List Column'
												PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</FOLDER>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							par.style='s3';
						}
						<HTARGET>
							HKEYS={
								'contextElement.id';
								'"usage-locations"';
							}
						</HTARGET>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='In definitions of global complexTypes'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
			</FOLDER>
			<FOLDER>
				DESCR='in anonymous complexTypes of elements'
				COND='e = findElementsByKey (\n      "attributeGroup-usage",\n      contextElement.id,\n      BooleanQuery (instanceOf ("xs:%element"))\n    );\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (el.toElement(), "XMLName"))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and there is no local elements (or local name extensions must be omitted)\n3). there is only one element in the list'
						COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\n(v = thisContext.getVar ("locations").toVector()).size() == 1\n||\nhasParamValue("doc.comp.usage.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByType (\n  "xs:%localElement",\n  BooleanQuery (\n    hasParamValue("show.localElementExt", "always") ||\n    {\n      schema = findAncestor ("xs:schema");\n\n      qName = QName (\n        ((hasAttr("form") ? getAttrValue("form") :\n            schema.getAttrValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : ""),\n        getAttrStringValue("name")\n      );\n\n      countElementsByKey ("global-elements", qName) +\n      countElementsByKey ("local-elements", qName) > 1\n    }\n  ) \n) == null)'
						FMT={
							sec.outputStyle='list';
							list.type='delimited';
						}
						TARGET_ET='xs:%element'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='thisContext.getVar("locations").toEnum()'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										FMT={
											txtfl.delimiter.type='nbsp';
										}
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='XMLName'
											</SS_CALL_CTRL>
											<PANEL>
												COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "def", "xml-source-location")\n))'
												FMT={
													ctrl.size.width='159.8';
													text.style='cs7';
													txtfl.delimiter.type='none';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<LABEL>
																TEXT='['
															</LABEL>
															<DATA_CTRL>
																FMT={
																	ctrl.option.noHLinkFmt='true';
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
															<LABEL>
																TEXT=']'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</ELEMENT_ITER>
					<FOLDER>
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
						<BODY>
							<AREA_SEC>
								FMT={
									sec.outputStyle='table';
									table.cellpadding.both='0';
									table.border.style='none';
								}
								<AREA>
									<CTRL_GROUP>
										FMT={
											trow.align.vert='Top';
										}
										<CTRLS>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='208.5';
													ctrl.size.height='17.3';
												}
												SS_NAME='Usage Location List Column'
												PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='273';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Usage Location List Column'
												PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</FOLDER>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							par.style='s3';
						}
						<HTARGET>
							HKEYS={
								'contextElement.id';
								'"usage-locations"';
							}
						</HTARGET>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='In definitions of anonymous complexTypes of elements'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
			</FOLDER>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s2';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							trow.bkgr.color='#CCCCFF';
						}
						<CTRLS>
							<LABEL>
								TEXT='Known Usage Locations'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<FOLDER>
		DESCR='XML SOURCE'
		COND='getBooleanParam("doc.comp.xml")'
		<HTARGET>
			HKEYS={
				'contextElement.id';
				'"xml-source"';
			}
			NAME_EXPR='output.type == "document" ? "xml_source" : ""'
		</HTARGET>
		COLLAPSED
		<BODY>
			<AREA_SEC>
				COND='getBooleanParam("doc.comp.xml.box")'
				FMT={
					sec.outputStyle='table';
					table.sizing='Relative';
					table.autofit='false';
					table.cellpadding.both='4';
					table.bkgr.color='#F5F5F5';
					table.border.style='solid';
					table.border.color='#999999';
					table.option.borderStylesInHTML='true';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<TEMPLATE_CALL_CTRL>
								FMT={
									ctrl.size.width='499.5';
									ctrl.size.height='17.3';
								}
								TEMPLATE_FILE='../xml/nodeSource.tpl'
								PASSED_PARAMS={
									'remove.anns','getBooleanParam("doc.comp.xml.remove.anns")';
								}
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='../xml/nodeSource.tpl'
				PASSED_PARAMS={
					'remove.anns','getBooleanParam("doc.comp.xml.remove.anns")';
				}
			</TEMPLATE_CALL>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s1';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							trow.bkgr.color='#CCCCFF';
						}
						<CTRLS>
							<LABEL>
								TEXT='XML Source'
							</LABEL>
							<DELIMITER>
								FMT={
									text.style='cs1';
								}
							</DELIMITER>
							<TEMPLATE_CALL_CTRL>
								FMT={
									text.style='cs5';
								}
								TEMPLATE_FILE='../xml/sourceNote.tpl'
								PASSED_PARAMS={
									'remove.anns','getBooleanParam("doc.comp.xml.remove.anns")';
								}
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<TEMPLATE_CALL>
		DESCR='ATTRIBUTE DETAIL'
		COND='getBooleanParam("doc.comp.attributes") &&\ngetBooleanParam("doc.comp.attributes.for.attributeGroup")'
		TEMPLATE_FILE='../attribute/attributes.tpl'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		DESCR='Bottom Message'
		COND='output.type == "document" &&\n! hasParamValue("show.about", "none")'
		TEMPLATE_FILE='../about.tpl'
	</TEMPLATE_CALL>
</ROOT>
<STOCK_SECTIONS>
	<AREA_SEC>
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='redef'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						FMT={
							text.style='cs4';
						}
						FORMULA='redef_no = getServiceAttr ("redefinition").toInt();\n\n" (redef" + (redef_no > 0 ? redef_no : "") + ")"'
					</DATA_CTRL>
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
						TEXT='(redefinition'
					</LABEL>
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
	<ELEMENT_ITER>
		DESCR='params[0]: vector of components; \nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item)'
		FMT={
			sec.outputStyle='pars';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='<ANY>'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
		SS_NAME='Usage Location List Column'
		<BODY>
			<AREA_SEC>
				FMT={
					txtfl.delimiter.type='none';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='nbsp';
						}
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME='XMLName'
							</SS_CALL_CTRL>
							<PANEL>
								COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "def", "xml-source-location")\n))'
								FMT={
									ctrl.size.width='156';
									text.style='cs7';
									txtfl.delimiter.type='none';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='['
											</LABEL>
											<DATA_CTRL>
												FMT={
													ctrl.option.noHLinkFmt='true';
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
											<LABEL>
												TEXT=']'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='none';
								}
							</DELIMITER>
							<LABEL>
								COND='! iterator.isLastItem ||\n! stockSection.params[1].toBoolean()'
								TEXT=','
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</ELEMENT_ITER>
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
						FMT={
							txtfl.delimiter.type='none';
						}
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
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name"),\n  rootElement\n)'
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
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name"),\n  rootElement\n)'
							</DATA_CTRL>
							<SS_CALL_CTRL>
								COND='hasServiceAttr ("redefinition")'
								SS_NAME='redef'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='case of a local element'
				MATCHING_ET='xs:%localElement'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "def", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='name = getAttrStringValue("name");\nschema = findAncestor ("xs:schema");\n\n(hasAttr("form") ? getAttrValue("form") :\n  schema.getAttrValue ("elementFormDefault")) == "qualified" \n    ? toXMLName (schema.getAttrStringValue("targetNamespace"), name, rootElement) : name'
							</DATA_CTRL>
							<TEMPLATE_CALL_CTRL>
								COND='instanceOf("xs:%localElement") &&\n(\n  hasParamValue("show.localElementExt", "always")\n  ||\n  hasParamValue("show.localElementExt", "repeating") &&\n  {\n    schema = findAncestor ("xs:schema");\n\n    qName = QName (\n      ((hasAttr("form") ? getAttrValue("form") :\n          schema.getAttrValue ("elementFormDefault")) == "qualified" \n            ? schema.getAttrStringValue("targetNamespace") : ""),\n      getAttrStringValue("name")\n    );\n\n    countElementsByKey ("global-elements", qName) +\n    countElementsByKey ("local-elements", qName) > 1\n  }\n)'
								TEMPLATE_FILE='../element/localElementExt.tpl'
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='any other (global) component'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:simpleType") ? "simpleType" : \n  instanceOf ("xs:group") ? "group" : \n    instanceOf ("xs:attributeGroup") ? "attributeGroup" : \n      "global attribute"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name"),\n  rootElement\n)'
							</DATA_CTRL>
							<SS_CALL_CTRL>
								COND='hasServiceAttr ("redefinition")'
								SS_NAME='redef'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='u72ADULPrArRKlTjmp1uMZvmLO6cJk0wYk702lxfpQs'
</DOCFLEX_TEMPLATE>