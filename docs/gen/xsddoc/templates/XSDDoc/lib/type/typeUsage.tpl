<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-09-01 11:12:00'
LAST_UPDATE='2009-10-30 06:36:31'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ETS={'xs:complexType';'xs:simpleType'}
<TEMPLATE_PARAMS>
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
		param.name='show.localElementExt';
		param.title='Local Element Extensions';
		param.type='enum';
		param.enum.values='always;repeating;never';
	}
	PARAM={
		param.name='fmt.page.refs';
		param.title='Generate page references';
		param.type='boolean';
		param.default.value='true';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs3';
}
<STYLES>
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs1';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Derivation Method';
		style.id='cs2';
		text.font.name='Verdana';
		text.font.size='8';
		text.color.foreground='#FF9900';
	}
	PAR_STYLE={
		style.name='Detail Heading 2';
		style.id='s1';
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
		style.id='s2';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.bottom='8';
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
		style.id='s3';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Page Number Small';
		style.id='cs5';
		text.font.name='Courier New';
		text.font.size='8';
	}
</STYLES>
<ROOT>
	<FOLDER>
		DESCR='All KNOWN USAGE LOCATIONS'
		INIT_EXPR='thisContext.setVar (\n  "all_locations", \n  toVector (findElementsByKey ("type-usage", contextElement.id))\n)'
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
		<BODY>
			<FOLDER>
				DESCR='Usage in derivations of other global types'
				COND='e = filterElements (\n  thisContext.getVar ("all_locations").toEnum(), \n  BooleanQuery (\n    instanceOf ("xs:%extensionType | xs:%restrictionType | xs:list | xs:restriction | xs:union") \n    &&\n    findPredecessorByType (\n       "xs:%element|xs:%attribute|xs:simpleType|xs:complexType"\n    ).instanceOf ("xs:simpleType | xs:complexType")\n  )\n);\n\ne.hasNext() ? {\n\n  v = e.toVector();\n\n  // sort locations according to the containing type\'s qualified name\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (\n      el.toElement().findPredecessorByType ("xs:simpleType|xs:complexType"),\n      "XMLName"\n    ))\n  );\n\n  thisContext.setVar ("locations", v); \n  true; \n\n} : false'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one item in the list'
						COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
						FMT={
							sec.outputStyle='list';
							list.type='delimited';
						}
						TARGET_ET='<ANY>'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<SS_CALL>
								SS_NAME='Usage in global type'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
					<SS_CALL>
						DESCR='otherwise, print everything as two column list, so it will look more readable'
						SS_NAME='Two Column List'
						PARAMS_EXPR='Array (\n  thisContext.getVar("locations"),\n  "Usage in global type"\n)'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							par.style='s2';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='In derivations of other global types'
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
				DESCR='Usage as direct type of elements'
				COND='e = filterElements (\n      thisContext.getVar ("all_locations").toEnum(),\n      "xs:%element"\n    );\n\ne.hasNext() ? {\n\n  v = e.toVector();\n\n  // sort locations according to the containing element\'s name\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (el.toElement(), "XMLName"))\n  );\n\n  thisContext.setVar ("locations", v); \n  true; \n\n} : false'
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
							<SS_CALL>
								SS_NAME='Element Location'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
					<SS_CALL>
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
						SS_NAME='Two Column List'
						PARAMS_EXPR='Array (\n  thisContext.getVar("locations"),\n  "Element Location"\n)'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							par.style='s2';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='As direct type of elements'
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
				DESCR='Usage in deriviations of anonymous types of elements'
				COND='e = filterElements (\n      thisContext.getVar ("all_locations").toEnum(), \n      BooleanQuery (\n        instanceOf ("xs:%extensionType | xs:%restrictionType | xs:list | xs:restriction | xs:union") \n        &&\n        findPredecessorByType("xs:%attribute|xs:%element").instanceOf ("xs:%element")\n      )\n    );\n\ne.hasNext() ? {\n\n  v = e.toVector();\n\n  // sort locations according to the containing element\'s representation\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (\n      el.toElement().findPredecessorByType ("xs:%element"),\n      "XMLName"\n    ))\n  );\n\n  thisContext.setVar ("locations", v); \n  true; \n\n} : false'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one item in the list'
						COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
						FMT={
							sec.outputStyle='list';
							list.type='delimited';
						}
						TARGET_ET='<ANY>'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='thisContext.getVar("locations").toEnum()'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<SS_CALL>
								SS_NAME='Usage in anonymous type of element'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
					<SS_CALL>
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
						SS_NAME='Two Column List'
						PARAMS_EXPR='Array (\n  thisContext.getVar("locations"),\n  "Usage in anonymous type of element"\n)'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							par.style='s2';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='In derivations of anonymous types of elements'
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
				DESCR='Usage as direct type of attributes'
				COND='e = filterElements (\n  thisContext.getVar ("all_locations").toEnum(), \n  "xs:%attribute"\n);\n\ne.hasNext() ? {\n\n  v = e.toVector();\n\n  // sort locations according to the attribute\'s representation\n  v.sortVector (\n    @el,\n    FlexQuery (callStockSection (el.toElement(), "Attribute Location"))\n  );\n\n  thisContext.setVar ("locations", v); \n  true; \n\n} : false'
				FMT={
					sec.outputStyle='list-items';
				}
				COLLAPSED
				<BODY>
					<FOLDER>
						DESCR='global attributes'
						COND='e = filterElements (\n  thisContext.getVar ("locations").toEnum(), \n  "xs:%topLevelAttribute"\n);\n\ne.hasNext() ? {\n  thisContext.setVar ("attributes", e.toVector()); \n  true; \n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one item in the list'
								COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\nthisContext.getVar ("attributes").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									list.type='delimited';
								}
								TARGET_ET='xs:%attribute'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("attributes").toEnum()'
								BREAK_PARENT_BLOCK='when-executed'
								<BODY>
									<SS_CALL>
										SS_NAME='Attribute Location'
									</SS_CALL>
								</BODY>
							</ELEMENT_ITER>
							<SS_CALL>
								DESCR='otherwise, print everything as two column list, so it will look more readable'
								SS_NAME='Two Column List'
								PARAMS_EXPR='Array (\n  thisContext.getVar("attributes"),\n  "Attribute Location"\n)'
							</SS_CALL>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='As direct type of global attributes'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("attributes").toVector().size() + ")"'
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
						DESCR='in elements'
						COND='e = filterElements (\n  thisContext.getVar ("locations").toEnum(), \n  BooleanQuery (findPredecessorByType("xs:%element") != null)\n);\n\ne.hasNext() ? {\n  thisContext.setVar ("attributes", e.toVector()); \n  true; \n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one item in the list'
								COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\nthisContext.getVar ("attributes").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									list.type='delimited';
								}
								TARGET_ET='xs:%attribute'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("attributes").toEnum()'
								BREAK_PARENT_BLOCK='when-executed'
								<BODY>
									<SS_CALL>
										SS_NAME='Attribute Location'
									</SS_CALL>
								</BODY>
							</ELEMENT_ITER>
							<SS_CALL>
								DESCR='otherwise, print everything as two column list, so it will look more readable'
								SS_NAME='Two Column List'
								PARAMS_EXPR='Array (\n  thisContext.getVar("attributes"),\n  "Attribute Location"\n)'
							</SS_CALL>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='As direct type of attributes within elements'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("attributes").toVector().size() + ")"'
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
						DESCR='in complexTypes'
						COND='e = filterElements (\n  thisContext.getVar ("locations").toEnum(), \n  BooleanQuery (\n\n    // the filter condition ensures the attribute has been declared\n    // directly in a global complexType, but not within a local element\n    // belonging to a complexType\n\n    findPredecessorByType ("xs:%element|xs:complexType").instanceOf ("xs:complexType")\n  )\n);\n\ne.hasNext() ? {\n  thisContext.setVar ("attributes", e.toVector()); \n  true; \n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one item in the list'
								COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\nthisContext.getVar ("attributes").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									list.type='delimited';
								}
								TARGET_ET='xs:%attribute'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("attributes").toEnum()'
								BREAK_PARENT_BLOCK='when-executed'
								<BODY>
									<SS_CALL>
										SS_NAME='Attribute Location'
									</SS_CALL>
								</BODY>
							</ELEMENT_ITER>
							<SS_CALL>
								DESCR='otherwise, print everything as two column list, so it will look more readable'
								SS_NAME='Two Column List'
								PARAMS_EXPR='Array (\n  thisContext.getVar("attributes"),\n  "Attribute Location"\n)'
							</SS_CALL>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='As direct type of attributes within complexTypes'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("attributes").toVector().size() + ")"'
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
						DESCR='in attributeGroups'
						COND='e = filterElements (\n  thisContext.getVar ("locations").toEnum(), \n  BooleanQuery (findPredecessorByType("xs:attributeGroup") != null)\n);\n\ne.hasNext() ? {\n  thisContext.setVar ("attributes", e.toVector()); \n  true; \n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one item in the list'
								COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\nthisContext.getVar ("attributes").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									list.type='delimited';
								}
								TARGET_ET='xs:%attribute'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("attributes").toEnum()'
								BREAK_PARENT_BLOCK='when-executed'
								<BODY>
									<SS_CALL>
										SS_NAME='Attribute Location'
									</SS_CALL>
								</BODY>
							</ELEMENT_ITER>
							<SS_CALL>
								DESCR='otherwise, print everything as two column list, so it will look more readable'
								SS_NAME='Two Column List'
								PARAMS_EXPR='Array (\n  thisContext.getVar("attributes"),\n  "Attribute Location"\n)'
							</SS_CALL>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='As direct type of attributes within attributeGroups'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("attributes").toVector().size() + ")"'
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
			</FOLDER>
			<FOLDER>
				DESCR='Usage in derivations of anonymous types of attributes'
				COND='e = filterElements (\n      thisContext.getVar ("all_locations").toEnum(), \n      BooleanQuery (findPredecessorByType("xs:%attribute") != null)\n    );\n\ne.hasNext() ? {\n  thisContext.setVar ("locations", e.toVector());\n  true; \n} : false'
				FMT={
					sec.outputStyle='list-items';
				}
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='global attributes'
						TARGET_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='filterElements (\n  thisContext.getVar("locations").toEnum(),\n  BooleanQuery (\n    findPredecessorByType ("xs:%topLevelAttribute") != null\n  )\n)'
						SORTING='by-expr'
						SORTING_KEY={expr='findPredecessorByType ("xs:%attribute").callStockSection("Attribute Name")',ascending,case_sensitive}
						COLLAPSED
						<BODY>
							<AREA_SEC>
								DESCR='case of global attribute'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='Attribute Location'
												PASSED_ELEMENT_EXPR='findPredecessorByType ("xs:%attribute")'
												PASSED_ELEMENT_MATCHING_ET='xs:%attribute'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												SS_NAME='Used As'
												PASSED_ELEMENT_EXPR='iterator.element'
												PASSED_ELEMENT_MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='In derivations of anonymous types of global attributes'
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
					<ELEMENT_ITER>
						DESCR='in elements'
						TARGET_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='filterElements (\n  thisContext.getVar("locations").toEnum(),\n  BooleanQuery (\n    findPredecessorByType("xs:%element|xs:complexType").instanceOf ("xs:%element")\n  )\n)'
						SORTING='by-expr'
						SORTING_KEY={expr='callStockSection("Attribute Location")',ascending,case_sensitive}
						COLLAPSED
						<BODY>
							<AREA_SEC>
								DESCR='case of global attribute'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='Attribute Location'
												PASSED_ELEMENT_EXPR='findPredecessorByType ("xs:%attribute")'
												PASSED_ELEMENT_MATCHING_ET='xs:%attribute'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												SS_NAME='Used As'
												PASSED_ELEMENT_EXPR='iterator.element'
												PASSED_ELEMENT_MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='In derivations of anonymous types of attributes within elements'
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
					<ELEMENT_ITER>
						DESCR='in complexTypes'
						TARGET_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='filterElements (\n  thisContext.getVar("locations").toEnum(),\n\n  // the filter condition ensures the attribute has been declared\n  // directly in a global complexType, but not within a local element \n  // belonging to a complexType\n\n  BooleanQuery (\n    findPredecessorByType ("xs:%element|xs:complexType").instanceOf ("xs:complexType")\n  )\n)'
						SORTING='by-expr'
						SORTING_KEY={expr='callStockSection("Attribute Location")',ascending,case_sensitive}
						COLLAPSED
						<BODY>
							<AREA_SEC>
								DESCR='case of global attribute'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='Attribute Location'
												PASSED_ELEMENT_EXPR='findPredecessorByType ("xs:%attribute")'
												PASSED_ELEMENT_MATCHING_ET='xs:%attribute'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												SS_NAME='Used As'
												PASSED_ELEMENT_EXPR='iterator.element'
												PASSED_ELEMENT_MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='In derivations of anonymous types of attributes within complexTypes'
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
					<ELEMENT_ITER>
						DESCR='in attributeGroups'
						TARGET_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='filterElements (\n  thisContext.getVar("locations").toEnum(),\n  BooleanQuery (findPredecessorByType("xs:attributeGroup") != null)\n)'
						SORTING='by-expr'
						SORTING_KEY={expr='callStockSection("Attribute Location")',ascending,case_sensitive}
						COLLAPSED
						<BODY>
							<AREA_SEC>
								DESCR='case of global attribute'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='Attribute Location'
												PASSED_ELEMENT_EXPR='findPredecessorByType ("xs:%attribute")'
												PASSED_ELEMENT_MATCHING_ET='xs:%attribute'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												SS_NAME='Used As'
												PASSED_ELEMENT_EXPR='iterator.element'
												PASSED_ELEMENT_MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
						<HEADER>
							<AREA_SEC>
								FMT={
									par.style='s2';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='In derivations of anonymous types of attributes within attributeGroups'
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
				</BODY>
			</FOLDER>
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
								TEXT='Known Usage Locations'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
</ROOT>
<STOCK_SECTIONS>
	<AREA_SEC>
		DESCR='case of global attribute'
		MATCHING_ET='xs:%attribute'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
			par.option.nowrap='true';
		}
		SS_NAME='Attribute Location'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<PANEL>
						DESCR='in case of local attribute'
						CONTEXT_ELEMENT_EXPR='findPredecessorByType (\n  "xs:%element|xs:complexType|xs:attributeGroup"\n)'
						MATCHING_ETS={'xs:%element';'xs:attributeGroup';'xs:complexType'}
						FMT={
							ctrl.size.width='162';
							ctrl.size.height='38.3';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='XMLName'
									</SS_CALL_CTRL>
									<LABEL>
										TEXT='/@'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</PANEL>
					<SS_CALL_CTRL>
						SS_NAME='Attribute Name'
					</SS_CALL_CTRL>
					<PANEL>
						COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "local", "detail", "xml-source-location")\n))'
						FMT={
							ctrl.size.width='193.5';
							txtfl.delimiter.type='none';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<DELIMITER>
										FMT={
											txtfl.delimiter.type='nbsp';
										}
									</DELIMITER>
									<LABEL>
										FMT={
											text.style='cs5';
										}
										TEXT='['
									</LABEL>
									<DATA_CTRL>
										FMT={
											ctrl.option.noHLinkFmt='true';
											text.style='cs5';
											text.hlink.fmt='none';
										}
										<DOC_HLINK>
											HKEYS={
												'contextElement.id';
												'Array ("def", "local", "detail", "xml-source-location")',array;
											}
										</DOC_HLINK>
										DOCFIELD='page-htarget'
									</DATA_CTRL>
									<LABEL>
										FMT={
											text.style='cs5';
										}
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
	<AREA_SEC>
		MATCHING_ET='xs:%attribute'
		FMT={
			par.option.nowrap='true';
		}
		SS_NAME='Attribute Name'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						<DOC_HLINK>
							TITLE_EXPR='instanceOf ("xs:attribute") ? "global attribute" : "local attribute"'
							HKEYS={
								'contextElement.id';
								'Array ("def", "local", "detail", "xml-source-location")',array;
							}
						</DOC_HLINK>
						FORMULA='name = getAttrStringValue("name");\n\nschema = findAncestor ("xs:schema");\nnsURI = schema.getAttrStringValue("targetNamespace");\n\n// if this is a top-level attribute, it should be always qualified\n\nform = instanceOf ("xs:attribute") ? "qualified" :\n{\n  // in case of a local attribute\n\n  form = hasAttr("form") ? getAttrValue("form") :\n           schema.getAttrValue ("attributeFormDefault");\n};\n\n(form == "qualified") ?\n  toXMLName (nsURI, name, Enum (rootElement, contextElement)) : name'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		MATCHING_ET='xs:%element'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		SS_NAME='Element Location'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<SS_CALL_CTRL>
						SS_NAME='XMLName'
					</SS_CALL_CTRL>
					<PANEL>
						COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "def", "xml-source-location")\n))'
						FMT={
							ctrl.size.width='186';
							ctrl.size.height='38.3';
							txtfl.delimiter.type='none';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<DELIMITER>
										FMT={
											txtfl.delimiter.type='nbsp';
										}
									</DELIMITER>
									<LABEL>
										FMT={
											text.style='cs5';
										}
										TEXT='['
									</LABEL>
									<DATA_CTRL>
										FMT={
											ctrl.option.noHLinkFmt='true';
											text.style='cs5';
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
										FMT={
											text.style='cs5';
										}
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
	<ELEMENT_ITER>
		DESCR='params[0]: the vector of column items\nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item)\nparams[2]: the name of the stock-section to print each item'
		FMT={
			sec.outputStyle='pars';
			txtfl.delimiter.type='text';
			txtfl.delimiter.text=', ';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='<ANY>'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.params[0])'
		SS_NAME='List Column'
		<BODY>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME_EXPR='stockSection.params[2].toString()'
							</SS_CALL_CTRL>
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
	<FOLDER>
		DESCR='params[0]: vector of elements to be printed in the list; \nparams[1]: the name of the stock-section to print each list item'
		INIT_EXPR='// sort vector according to the list item string representations\n\nssName = stockSection.params[1].toString();\n\nsortVector (\n  toVector (stockSection.param), \n  @el,\n  FlexQuery (callStockSection (el.toElement(), ssName))\n)\n'
		SS_NAME='Two Column List'
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
									ctrl.size.width='217.5';
									ctrl.size.height='17.3';
								}
								SS_NAME='List Column'
								PARAMS_EXPR='v = stockSection.param.toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2), \n  N == 1,\n  stockSection.params[1]\n)'
							</SS_CALL_CTRL>
							<SS_CALL_CTRL>
								FMT={
									ctrl.size.width='282';
									ctrl.size.height='17.3';
									tcell.padding.extra.left='12';
								}
								SS_NAME='List Column'
								PARAMS_EXPR='v = stockSection.param.toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2), \n  true,\n  stockSection.params[1]\n)'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
	<AREA_SEC>
		DESCR='context element is a usage location within definition of anonymous type of element'
		MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
		SS_NAME='Usage in anonymous type of element'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<PANEL>
						CONTEXT_ELEMENT_EXPR='findPredecessorByType ("xs:%element")'
						MATCHING_ET='xs:%element'
						FMT={
							ctrl.size.width='304.5';
							ctrl.size.height='59.3';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='XMLName'
									</SS_CALL_CTRL>
									<PANEL>
										COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "def", "xml-source-location")\n))'
										FMT={
											ctrl.size.width='157.5';
											txtfl.delimiter.type='none';
										}
										<AREA>
											<CTRL_GROUP>
												<CTRLS>
													<LABEL>
														FMT={
															text.style='cs5';
														}
														TEXT='['
													</LABEL>
													<DATA_CTRL>
														FMT={
															ctrl.option.noHLinkFmt='true';
															text.style='cs5';
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
														FMT={
															text.style='cs5';
														}
														TEXT=']'
													</LABEL>
												</CTRLS>
											</CTRL_GROUP>
										</AREA>
									</PANEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</PANEL>
					<SS_CALL_CTRL>
						SS_NAME='Used As'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		DESCR='context element is a usage location within definition of a global type'
		MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
		SS_NAME='Usage in global type'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<PANEL>
						CONTEXT_ELEMENT_EXPR='findPredecessorByType ("xs:simpleType|xs:complexType")'
						MATCHING_ETS={'xs:complexType';'xs:simpleType'}
						FMT={
							ctrl.size.width='300.8';
							ctrl.size.height='59.3';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='XMLName'
									</SS_CALL_CTRL>
									<PANEL>
										COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
										FMT={
											ctrl.size.width='153';
											ctrl.size.height='38.3';
											text.style='cs5';
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
					</PANEL>
					<SS_CALL_CTRL>
						SS_NAME='Used As'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		MATCHING_ETS={'xs:%extensionType';'xs:%restrictionType';'xs:list';'xs:restriction';'xs:union'}
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		SS_NAME='Used As'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DELIMITER>
					</DELIMITER>
					<LABEL>
						MATCHING_ET='xs:%extensionType'
						FMT={
							text.style='cs2';
						}
						TEXT='(as extension base)'
					</LABEL>
					<LABEL>
						MATCHING_ETS={'xs:%restrictionType';'xs:restriction'}
						FMT={
							text.style='cs2';
						}
						TEXT='(as restriction base)'
					</LABEL>
					<LABEL>
						MATCHING_ET='xs:list'
						FMT={
							text.style='cs2';
						}
						TEXT='(as list item type)'
					</LABEL>
					<LABEL>
						MATCHING_ET='xs:union'
						FMT={
							text.style='cs2';
						}
						TEXT='(as union member)'
					</LABEL>
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
									TITLE_EXPR='instanceOf ("xs:simpleType") ? "simpleType" : \n  instanceOf ("xs:group") ? "group" : \n    instanceOf ("xs:attributeGroup") ? "attributeGroup" : \n      instanceOf ("xs:attribute") ? "global attribute" : ""'
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
CHECKSUM='8bpTM9KwhyPiy2WWNxWsx7PxHZppd0WbjXsZtwAB44c'
</DOCFLEX_TEMPLATE>