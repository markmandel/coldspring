<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2008-11-15 02:13:28'
LAST_UPDATE='2009-10-30 06:36:30'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ET='xs:element'
DESCR='Prints summary info about the involvement of the element in substitution groups:\n<ul>\n<li>The list of substitution groups, which this element is affiliated to.</li>\n<li>The number of known elements (or the name of the element if it is only one) which may substitute for this element.</li>\n</ul>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='list.heads';
		param.title='List Heads';
		param.type='boolean';
	}
	PARAM={
		param.name='list.members';
		param.title='List Members';
		param.type='boolean';
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
		DESCR='if the element is affiliated to a substitution group'
		COND='getAttrValue("substitutionGroup") != null'
		<BODY>
			<AREA_SEC>
				DESCR='when the element is not a member of the substitution group it is affiliated to'
				CONTEXT_ELEMENT_EXPR='directHead = findElementByKey (\n  "global-elements",\n  getAttrQNameValue("substitutionGroup")\n);\n\ncheckElementByKey (\n  "substitution-group-members",\n  directHead.id,\n  contextElement\n) ? null : directHead'
				MATCHING_ET='xs:element'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='affiliated to substitution group'
							</LABEL>
							<SS_CALL_CTRL>
								FMT={
									text.style='cs1';
								}
								SS_NAME='Global Element'
							</SS_CALL_CTRL>
							<PANEL>
								COND='output.format.supportsPageRefs &&\ngetBooleanParam("fmt.page.refs") &&\nhyperTargetExists (Array (contextElement.id, "detail"))'
								FMT={
									ctrl.size.width='148.5';
									ctrl.size.height='38.3';
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
														'"detail"';
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
									txtfl.delimiter.type='text';
									txtfl.delimiter.text='; ';
								}
							</DELIMITER>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<FOLDER>
				DESCR='if the element is a member of one or more substitution groups'
				COND='headCount = countElementsByKey (\n  "substitution-group-heads",\n  contextElement.id\n);\n\nheadCount > 0 ? {\n  setVar ("headCount", headCount);\n  true\n} : false'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<ELEMENT_ITER>
						DESCR='list of all susbtitutable elements (i.e. the heads of the substitution groups this element belongs to)'
						COND='getBooleanParam("list.heads")'
						TARGET_ET='xs:element'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='findElementsByKey (\n  "substitution-group-heads",\n  contextElement.id\n)'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<SS_CALL_CTRL>
												FMT={
													text.style='cs1';
												}
												SS_NAME='Global Element'
											</SS_CALL_CTRL>
											<PANEL>
												COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
												FMT={
													ctrl.size.width='148.5';
													ctrl.size.height='38.3';
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
												TEXT='may substitute for'
											</LABEL>
											<LABEL>
												COND='iterator.numItems == 1'
												TEXT='element'
											</LABEL>
											<LABEL>
												COND='iterator.numItems > 1'
												TEXT='elements:'
											</LABEL>
											<DELIMITER>
											</DELIMITER>
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
											<DELIMITER>
												FMT={
													txtfl.delimiter.type='text';
													txtfl.delimiter.text='; ';
												}
											</DELIMITER>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</FOOTER>
					</ELEMENT_ITER>
					<AREA_SEC>
						DESCR='otherwise, print only the number of substitutable elements'
						INIT_EXPR='setVar (\n  "headCount", \n  countElementsByKey ("substitution-group-heads", \n                      contextElement.id)\n)'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='may substitute for'
									</LABEL>
									<DATA_CTRL>
										FORMULA='getVar("headCount")'
									</DATA_CTRL>
									<LABEL>
										COND='getVar("headCount").toInt() == 1'
										<DOC_HLINK>
											HKEYS={
												'contextElement.id';
												'"substitution-group-heads"';
											}
										</DOC_HLINK>
										TEXT='element'
									</LABEL>
									<LABEL>
										COND='getVar("headCount").toInt() > 1'
										<DOC_HLINK>
											HKEYS={
												'contextElement.id';
												'"substitution-group-heads"';
											}
										</DOC_HLINK>
										TEXT='elements'
									</LABEL>
									<DELIMITER>
										FMT={
											txtfl.delimiter.type='text';
											txtfl.delimiter.text='; ';
										}
									</DELIMITER>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<AREA_SEC>
				DESCR='otherwise, the element\'s substitution group head cannot be resolved'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='affiliated to substitution group'
							</LABEL>
							<DATA_CTRL>
								FMT={
									text.style='cs1';
								}
								ATTR='substitutionGroup'
							</DATA_CTRL>
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='text';
									txtfl.delimiter.text='; ';
								}
							</DELIMITER>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
	<FOLDER>
		DESCR='if the element is the head of a substitution group'
		COND='memberCount = countElementsByKey (\n  "substitution-group-members",\n  contextElement.id\n);\n\nmemberCount > 0 ? {\n  setVar ("memberCount", memberCount);\n  true\n} : false'
		<BODY>
			<ELEMENT_ITER>
				COND='getBooleanParam("list.members")'
				TARGET_ET='xs:element'
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='findElementsByKey (\n  "substitution-group-members",\n  contextElement.id\n)'
				SORTING='by-expr'
				SORTING_KEY={expr='callStockSection("Global Element")',ascending}
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<SS_CALL_CTRL>
										FMT={
											text.style='cs1';
										}
										SS_NAME='Global Element'
									</SS_CALL_CTRL>
									<PANEL>
										COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
										FMT={
											ctrl.size.width='148.5';
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
										TEXT='may be substituted with'
									</LABEL>
									<LABEL>
										COND='iterator.numItems == 1'
										TEXT='element'
									</LABEL>
									<LABEL>
										COND='iterator.numItems > 1'
										TEXT='elements:'
									</LABEL>
									<DELIMITER>
									</DELIMITER>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='may be substituted with'
							</LABEL>
							<DATA_CTRL>
								FORMULA='getVar("memberCount")'
							</DATA_CTRL>
							<LABEL>
								COND='getVar("memberCount").toInt() == 1'
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'"substitution-group-members"';
									}
								</DOC_HLINK>
								TEXT='element'
							</LABEL>
							<LABEL>
								COND='getVar("memberCount").toInt() > 1'
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'"substitution-group-members"';
									}
								</DOC_HLINK>
								TEXT='elements'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
</ROOT>
<STOCK_SECTIONS>
	<AREA_SEC>
		DESCR='prints the qualified name a global element component (passed as the stock-section context element)'
		MATCHING_ET='xs:element'
		FMT={
			par.option.nowrap='true';
		}
		SS_NAME='Global Element'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						COND='! getAttrBooleanValue ("abstract")'
						<DOC_HLINK>
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
							HKEYS={
								'contextElement.id';
								'Array ("detail", "xml-source-location")',array;
							}
						</DOC_HLINK>
						FORMULA='toXMLName (\n  findAncestor("xs:schema").getAttrStringValue("targetNamespace"), \n  getAttrStringValue("name"),\n  Enum (rootElement, contextElement)\n)'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</STOCK_SECTIONS>
CHECKSUM='buFCl7kTS26Jjhw3eqg5aUe?wm?iQZMUWf3OLEiE?JQ'
</DOCFLEX_TEMPLATE>