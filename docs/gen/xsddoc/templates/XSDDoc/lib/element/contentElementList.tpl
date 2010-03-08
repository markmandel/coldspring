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
ROOT_ETS={'xs:%element';'xs:complexType';'xs:group'}
<TEMPLATE_PARAMS>
	PARAM={
		param.name='contentModelKey';
		param.description='The key by which the content elements are obtained from the "content-model-elements" element map';
		param.type='Object';
		param.default.expr='contextElement.id';
	}
	PARAM={
		param.name='caption';
		param.type='string';
		param.default.value='Content Model Elements';
	}
	PARAM={
		param.name='doc.comp.lists.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
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
	doc.hlink.style.link='cs2';
}
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
		style.name='List Heading 1';
		style.id='s1';
		text.font.name='Arial';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.top='12';
		par.margin.bottom='8';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s2';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Page Number Small';
		style.id='cs3';
		text.font.name='Courier New';
		text.font.size='8';
	}
</STYLES>
<ROOT>
	<FOLDER>
		COND='e = findElementsByKey (\n      "content-model-elements",\n      getParam("contentModelKey"),\n      BooleanQuery (! instanceOf ("xs:any"))\n    );\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (el.toElement(), "List Item")),\n     true\n  );\n\n  thisContext.setVar ("elements", v);\n  true;\n\n} : false'
		<BODY>
			<ELEMENT_ITER>
				DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and there is no local elements (or local name extensions must be omitted)\n3). there is only one element in the list'
				COND='hasParamValue("doc.comp.lists.layout", "flow")\n||\n(v = thisContext.getVar ("elements").toVector()).size() == 1\n||\nhasParamValue("doc.comp.lists.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByType (\n  "xs:%localElement",\n  BooleanQuery (\n    getAttrValue("ref") == null && \n    (\n      hasParamValue("show.localElementExt", "always") ||\n      {\n        schema = findAncestor ("xs:schema");\n\n        qName = QName (\n          ((hasAttr("form") ? getAttrValue("form") :\n              schema.getAttrValue ("elementFormDefault")) == "qualified" \n                ? schema.getAttrStringValue("targetNamespace") : ""),\n          getAttrStringValue("name")\n        );\n\n        countElementsByKey ("global-elements", qName) +\n        countElementsByKey ("local-elements", qName) > 1\n      }\n    )\n  ) \n) == null)'
				FMT={
					sec.outputStyle='list';
					sec.indent.block='true';
					list.type='delimited';
				}
				TARGET_ET='xs:%element'
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='thisContext.getVar ("elements").toEnum()'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='List Item'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</ELEMENT_ITER>
			<FOLDER>
				DESCR='otherwise, print everything as two column list, so the modifers will look more readable'
				FMT={
					sec.indent.block='true';
				}
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
											ctrl.size.width='209.3';
											ctrl.size.height='17.3';
										}
										SS_NAME='List Column'
										PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
									</SS_CALL_CTRL>
									<SS_CALL_CTRL>
										FMT={
											ctrl.size.width='272.3';
											ctrl.size.height='17.3';
											tcell.padding.extra.left='12';
										}
										SS_NAME='List Column'
										PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
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
					par.style='s1';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FORMULA='getStringParam("caption")'
							</DATA_CTRL>
							<DATA_CTRL>
								FORMULA='"(" + thisContext.getVar ("elements").toVector().size() + ")"'
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
</ROOT>
<STOCK_SECTIONS>
	<ELEMENT_ITER>
		DESCR='params[0]: vector of column elements; \nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item)'
		FMT={
			sec.outputStyle='pars';
			txtfl.delimiter.type='text';
			txtfl.delimiter.text=', ';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='xs:%element'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
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
								SS_NAME='List Item'
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
	<FOLDER>
		MATCHING_ET='xs:%element'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='List Item'
		<BODY>
			<AREA_SEC>
				DESCR='case of a reference to the global element'
				COND='getAttrValue("ref") != null'
				INIT_EXPR='stockSection.setVar (\n  "globalElement", \n  findElementByKey (\n    "global-elements", getAttrQNameValue("ref")\n  )\n)'
				FMT={
					txtfl.delimiter.type='none';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								DESCR='case of global element'
								COND='! stockSection.getElementVar (\n  "globalElement"\n).getAttrBooleanValue("abstract")'
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'stockSection.getElementVar("globalElement").id';
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
										'"local"';
										'rootElement.id';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
										'"def"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'stockSection.getElementVar("globalElement").id';
										'"xml-source-location"';
									}
								</DOC_HLINK>
								FORMULA='toXMLName (getAttrQNameValue("ref"))'
							</DATA_CTRL>
							<DATA_CTRL>
								DESCR='case of global element'
								COND='stockSection.getElementVar (\n  "globalElement"\n).getAttrBooleanValue("abstract")'
								FMT={
									text.font.style.italic='true';
								}
								<DOC_HLINK>
									TITLE_EXPR='"abstract global element"'
									HKEYS={
										'stockSection.getElementVar("globalElement").id';
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"abstract global element"'
									HKEYS={
										'contextElement.id';
										'"local"';
										'rootElement.id';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"abstract global element"'
									HKEYS={
										'contextElement.id';
										'"def"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'stockSection.getElementVar("globalElement").id';
										'"xml-source-location"';
									}
								</DOC_HLINK>
								FORMULA='toXMLName (getAttrQNameValue("ref"))'
							</DATA_CTRL>
							<PANEL>
								COND='output.format.supportsPageRefs &&\ngetBooleanParam("fmt.page.refs") &&\n(\n  hyperTargetExists (\n    Array (stockSection.getElementVar("globalElement").id, "detail")\n  ) ||\n  hyperTargetExists (\n    Array (contextElement.id, "local", rootElement.id)\n  ) ||\n  hyperTargetExists (\n    Array (contextElement.id, "def")\n  ) ||\n  hyperTargetExists (\n    Array (stockSection.getElementVar("globalElement").id, "xml-source-location")\n  )\n)'
								FMT={
									ctrl.size.width='192';
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
													text.style='cs3';
												}
												TEXT='['
											</LABEL>
											<DATA_CTRL>
												FMT={
													ctrl.option.noHLinkFmt='true';
													text.style='cs3';
													text.hlink.fmt='none';
												}
												<DOC_HLINK>
													HKEYS={
														'stockSection.getElementVar("globalElement").id';
														'"detail"';
													}
												</DOC_HLINK>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'"local"';
														'rootElement.id';
													}
												</DOC_HLINK>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'"def"';
													}
												</DOC_HLINK>
												<DOC_HLINK>
													TITLE_EXPR='"global element"'
													HKEYS={
														'stockSection.getElementVar("globalElement").id';
														'"xml-source-location"';
													}
												</DOC_HLINK>
												DOCFIELD='page-htarget'
											</DATA_CTRL>
											<LABEL>
												FMT={
													text.style='cs3';
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
				DESCR='case of a local element'
				FMT={
					txtfl.delimiter.type='none';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'"local"';
										'rootElement.id';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'Array ("def", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='name = getAttrStringValue("name");\nschema = findAncestor ("xs:schema");\n\n(hasAttr("form") ? getAttrValue("form") :\n  schema.getAttrValue ("elementFormDefault")) == "qualified" \n    ? toXMLName (schema.getAttrStringValue("targetNamespace"), name, rootElement) : name'
							</DATA_CTRL>
							<TEMPLATE_CALL_CTRL>
								COND='hasParamValue("show.localElementExt", "always")\n||\nhasParamValue("show.localElementExt", "repeating") &&\n{\n  schema = findAncestor ("xs:schema");\n\n  qName = QName (\n    ((hasAttr("form") ? getAttrValue("form") :\n        schema.getAttrValue ("elementFormDefault")) == "qualified" \n          ? schema.getAttrStringValue("targetNamespace") : ""),\n    getAttrStringValue("name")\n  );\n\n  countElementsByKey ("global-elements", qName) +\n  countElementsByKey ("local-elements", qName) > 1\n}'
								TEMPLATE_FILE='localElementExt.tpl'
							</TEMPLATE_CALL_CTRL>
							<PANEL>
								COND='output.format.supportsPageRefs &&\ngetBooleanParam("fmt.page.refs") &&\n(\n  hyperTargetExists (\n    ArgumentList (contextElement.id, "detail")\n  ) ||\n  hyperTargetExists (\n    ArgumentList (contextElement.id, "local", rootElement.id)\n  ) ||\n  hyperTargetExists (\n    ArgumentList (contextElement.id, Array ("def", "xml-source-location"))\n  )\n)'
								FMT={
									ctrl.size.width='192';
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
													text.style='cs3';
												}
												TEXT='['
											</LABEL>
											<DATA_CTRL>
												FMT={
													ctrl.option.noHLinkFmt='true';
													text.style='cs3';
													text.hlink.fmt='none';
												}
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'"detail"';
													}
												</DOC_HLINK>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'"local"';
														'rootElement.id';
													}
												</DOC_HLINK>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'Array ("def", "xml-source-location")',array;
													}
												</DOC_HLINK>
												DOCFIELD='page-htarget'
											</DATA_CTRL>
											<LABEL>
												FMT={
													text.style='cs3';
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
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='D3jHnNb9tRo1flHXHkM6ArmUYDiEw2uAu4?hUAZXYlQ'
</DOCFLEX_TEMPLATE>