<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-04-26 03:31:00'
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
		param.name='fmt.page.refs';
		param.title='Generate page references';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
	}
	PARAM={
		param.name='doc.comp.lists.directSubtypes';
		param.title='List of Direct Subtypes';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.indirectSubtypes';
		param.title='List of Indirect Subtypes';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.basedElements';
		param.title='List of All Based Elements';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.basedAttributes';
		param.title='List of All Based Attributes';
		param.type='boolean';
		param.default.value='true';
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
	CHAR_STYLE={
		style.name='Name Modifier';
		style.id='cs3';
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
		style.name='Page Number Small';
		style.id='cs4';
		text.font.name='Courier New';
		text.font.size='8';
	}
</STYLES>
<ROOT>
	<FOLDER>
		DESCR='Known Direct Subtypes'
		COND='getBooleanParam("doc.comp.lists.directSubtypes") &&\n{\n  e = findElementsByKey ("direct-subtypes", contextElement.id);\n  e.hasNext() ?\n  {\n    v = e.toVector();\n\n    v.sortVector (\n       @el,\n       FlexQuery (callStockSection (el.toElement(), "XMLName"))\n    );\n\n    thisContext.setVar ("components", v);\n    true;\n\n  } : false\n}'
		COLLAPSED
		<BODY>
			<ELEMENT_ITER>
				DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
				COND='! hasParamValue("doc.comp.lists.layout", "two_columns")\n||\nthisContext.getVar ("components").toVector().size() == 1'
				FMT={
					sec.outputStyle='list';
					sec.indent.block='true';
					list.type='delimited';
				}
				TARGET_ETS={'xs:complexType';'xs:simpleType'}
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='thisContext.getVar ("components").toEnum()'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='XMLName'
									</SS_CALL_CTRL>
									<PANEL>
										COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
										FMT={
											ctrl.size.width='156';
											text.style='cs4';
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
				DESCR='otherwise, print everything as two column list, so it will look more readable'
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
										SS_NAME='Component List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
									</SS_CALL_CTRL>
									<SS_CALL_CTRL>
										FMT={
											ctrl.size.width='272.3';
											ctrl.size.height='17.3';
											tcell.padding.extra.left='12';
										}
										SS_NAME='Component List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
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
							<LABEL>
								TEXT='Known Direct Subtypes'
							</LABEL>
							<DATA_CTRL>
								FORMULA='"(" + thisContext.getVar ("components").toVector().size() + ")"'
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
		DESCR='Known Indirect Subtypes'
		COND='getBooleanParam("doc.comp.lists.indirectSubtypes") &&\n{\n  e = findElementsByKey ("indirect-subtypes", contextElement.id);\n  e.hasNext() ?\n  {\n    v = e.toVector();\n\n    v.sortVector (\n      @el,\n      FlexQuery (callStockSection (el.toElement(), "XMLName"))\n    );\n\n    thisContext.setVar ("components", v);\n    true;\n\n  } : false\n}'
		COLLAPSED
		<BODY>
			<ELEMENT_ITER>
				DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
				COND='! hasParamValue("doc.comp.lists.layout", "two_columns")\n||\nthisContext.getVar ("components").toVector().size() == 1'
				FMT={
					sec.outputStyle='list';
					sec.indent.block='true';
					list.type='delimited';
				}
				TARGET_ETS={'xs:complexType';'xs:simpleType'}
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='thisContext.getVar ("components").toEnum()'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='XMLName'
									</SS_CALL_CTRL>
									<PANEL>
										COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
										FMT={
											ctrl.size.width='156';
											text.style='cs4';
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
				DESCR='otherwise, print everything as two column list, so it will look more readable'
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
										SS_NAME='Component List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
									</SS_CALL_CTRL>
									<SS_CALL_CTRL>
										FMT={
											ctrl.size.width='272.3';
											ctrl.size.height='17.3';
											tcell.padding.extra.left='12';
										}
										SS_NAME='Component List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
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
							<LABEL>
								TEXT='Known Indirect Subtypes'
							</LABEL>
							<DATA_CTRL>
								FORMULA='"(" + thisContext.getVar ("components").toVector().size() + ")"'
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
		DESCR='All direct/indirect based elements'
		COND='getBooleanParam("doc.comp.lists.basedElements") &&\n{\n  e = findElementsByKey ("derived-elements", contextElement.id);\n  e.hasNext() ?\n  {\n    v = e.toVector();\n\n    v.sortVector (\n      @el,\n      FlexQuery (callStockSection (el.toElement(), "XMLName"))\n    );\n\n    thisContext.setVar ("components", v);\n    true;\n\n  } : false\n}'
		COLLAPSED
		<BODY>
			<ELEMENT_ITER>
				DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and there is no local elements (or local name extensions must be omitted)\n3). there is only one element in the list'
				COND='hasParamValue("doc.comp.lists.layout", "flow")\n||\n(v = thisContext.getVar ("components").toVector()).size() == 1\n||\nhasParamValue("doc.comp.lists.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByType (\n  "xs:%localElement",\n  BooleanQuery (\n    hasParamValue("show.localElementExt", "always") ||\n    {\n      schema = findAncestor ("xs:schema");\n\n      qName = QName (\n        ((hasAttr("form") ? getAttrValue("form") :\n            schema.getAttrValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : ""),\n        getAttrStringValue("name")\n      );\n\n      countElementsByKey ("global-elements", qName) +\n      countElementsByKey ("local-elements", qName) > 1\n    }\n  ) \n) == null)'
				FMT={
					sec.outputStyle='list';
					sec.indent.block='true';
					list.type='delimited';
				}
				TARGET_ET='xs:%element'
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='thisContext.getVar ("components").toEnum()'
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
											text.style='cs4';
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
				DESCR='otherwise, print everything as two column list, so it will look more readable'
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
										SS_NAME='Component List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
									</SS_CALL_CTRL>
									<SS_CALL_CTRL>
										FMT={
											ctrl.size.width='272.3';
											ctrl.size.height='17.3';
											tcell.padding.extra.left='12';
										}
										SS_NAME='Component List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
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
							<LABEL>
								TEXT='All Direct / Indirect Based Elements'
							</LABEL>
							<DATA_CTRL>
								FORMULA='"(" + thisContext.getVar ("components").toVector().size() + ")"'
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
		DESCR='All direct/indirect based attributes'
		COND='instanceOf("xs:simpleType") &&\ngetBooleanParam("doc.comp.lists.basedAttributes") &&\n{\n  e = findElementsByKey ("derived-attributes", contextElement.id);\n\n  e.hasNext() ?\n  {\n    v = e.toVector();\n\n    v.sortVector (\n      @el,\n      FlexQuery (callStockSection (el.toElement(), "Attribute Location"))\n    );\n\n    thisContext.setVar ("components", v);\n    true;\n\n  } : false\n}'
		COLLAPSED
		<BODY>
			<ELEMENT_ITER>
				DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n3). there is only one attribute in the list'
				COND='hasParamValue("doc.comp.lists.layout", "flow")\n||\nthisContext.getVar ("components").toVector().size() == 1'
				FMT={
					sec.outputStyle='list';
					sec.indent.block='true';
					list.type='delimited';
				}
				TARGET_ET='xs:%attribute'
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='thisContext.getVar ("components").toEnum()'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<SS_CALL>
						SS_NAME='Attribute Location'
					</SS_CALL>
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
											ctrl.size.width='207.8';
											ctrl.size.height='17.3';
										}
										SS_NAME='Attribute List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
									</SS_CALL_CTRL>
									<SS_CALL_CTRL>
										FMT={
											ctrl.size.width='273.8';
											ctrl.size.height='17.3';
											tcell.padding.extra.left='12';
										}
										SS_NAME='Attribute List Column'
										PARAMS_EXPR='v = thisContext.getVar ("components").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
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
							<LABEL>
								TEXT='All Direct / Indirect Based Attributes'
							</LABEL>
							<DATA_CTRL>
								FORMULA='"(" + thisContext.getVar ("components").toVector().size() + ")"'
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
		TARGET_ET='xs:%attribute'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
		SS_NAME='Attribute List Column'
		<BODY>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME='Attribute Location'
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
						CONTEXT_ELEMENT_EXPR='findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup")'
						MATCHING_ETS={'xs:%element';'xs:attributeGroup';'xs:complexType'}
						FMT={
							ctrl.size.width='162.8';
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
							ctrl.size.width='191.3';
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
											text.style='cs4';
										}
										TEXT='['
									</LABEL>
									<DATA_CTRL>
										FMT={
											ctrl.option.noHLinkFmt='true';
											text.style='cs4';
											text.hlink.fmt='none';
										}
										<DOC_HLINK>
											TITLE_EXPR='instanceOf ("xs:attribute") ? "global attribute" : "local attribute"'
											HKEYS={
												'contextElement.id';
												'Array ("def", "local", "detail", "xml-source-location")',array;
											}
										</DOC_HLINK>
										DOCFIELD='page-htarget'
									</DATA_CTRL>
									<LABEL>
										FMT={
											text.style='cs4';
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
	<ELEMENT_ITER>
		DESCR='params[0]: vector of column components; \nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item)'
		FMT={
			sec.outputStyle='pars';
			txtfl.delimiter.type='text';
			txtfl.delimiter.text=', ';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='<ANY>'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
		SS_NAME='Component List Column'
		<BODY>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME='XMLName'
							</SS_CALL_CTRL>
							<PANEL>
								COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "def", "xml-source-location")\n))'
								FMT={
									ctrl.size.width='191.3';
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
													text.style='cs4';
												}
												TEXT='['
											</LABEL>
											<DATA_CTRL>
												FMT={
													ctrl.option.noHLinkFmt='true';
													text.style='cs4';
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
													text.style='cs4';
												}
												TEXT=']'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
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
							text.style='cs3';
						}
						FORMULA='redef_no = getServiceAttr ("redefinition").toInt();\n\n" (redef" + (redef_no > 0 ? redef_no : "") + ")"'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<FOLDER>
		DESCR='prints the XML (qualified or local) name of any global schema component (passed as the stock-section context element)'
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
								FORMULA='toXMLName (\n  findAncestor("xs:schema").getAttrStringValue("targetNamespace"), \n  getAttrStringValue("name"),\n  Enum (rootElement, contextElement)\n)'
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
								FORMULA='toXMLName (\n  findAncestor("xs:schema").getAttrStringValue("targetNamespace"), \n  getAttrStringValue("name"),\n  Enum (rootElement, contextElement)\n)'
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
								FORMULA='toXMLName (\n  findAncestor("xs:schema").getAttrStringValue("targetNamespace"), \n  getAttrStringValue("name"),\n  Enum (rootElement, contextElement)\n)'
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
CHECKSUM='eayH71vYulSDSG8fPB1AsiUXf27H8gNh3jKzOKqsdxk'
</DOCFLEX_TEMPLATE>