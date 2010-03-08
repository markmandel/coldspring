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
ROOT_ET='xs:%localElement'
DESCR='prints extension for the local element name which is allows it to be distinguished it from others'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='targetFrame';
		param.type='string';
	}
</TEMPLATE_PARAMS>
FMT={
	doc.lengthUnits='pt';
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
	CHAR_STYLE={
		style.name='Name Modifier';
		style.id='cs3';
		text.font.name='Verdana';
		text.font.size='7';
		text.color.foreground='#B2B2B2';
	}
	CHAR_STYLE={
		style.name='Name Modifier Hyperlink';
		style.id='cs4';
		text.decor.underline='true';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s1';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Underline';
		style.id='cs5';
		text.decor.underline='true';
	}
</STYLES>
<ROOT>
	<AREA_SEC>
		DESCR='when the element may be contained in only one other element'
		COND='// see "Context Element" tab'
		CONTEXT_ELEMENT_EXPR='key = (typeQName = getAttrQNameValue ("type")) != null ?\n  HashKey (\n    findAncestor("xs:schema").getAttrStringValue("targetNamespace"),\n    getAttrValue("name"),\n    typeQName\n  )\n: contextElement.id;\n\ncountElementsByKey ("containing-elements", key) == 1 ? \n  findElementByKey ("containing-elements", key) : null'
		MATCHING_ET='xs:%element'
		FMT={
			sec.outputStyle='text-par';
			text.style='cs3';
			txtfl.delimiter.type='none';
		}
		BREAK_PARENT_BLOCK='when-executed'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT=' (in '
					</LABEL>
					<SS_CALL_CTRL>
						FMT={
							text.hlink.fmt='style';
							text.hlink.style='cs5';
						}
						SS_NAME='XMLName'
					</SS_CALL_CTRL>
					<SS_CALL_CTRL>
						COND='instanceOf("xs:%localElement") && \n{\n  schema = findAncestor ("xs:schema");\n\n  qName = QName (\n    ((hasAttr("form") ? getAttrValue("form") :\n        schema.getAttrValue ("elementFormDefault")) == "qualified" \n          ? schema.getAttrStringValue("targetNamespace") : ""),\n    getAttrStringValue("name")\n  );\n\n  countElementsByKey ("global-elements", qName) +\n  countElementsByKey ("local-elements", qName) > 1\n}'
						SS_NAME='Local Name Extension'
					</SS_CALL_CTRL>
					<LABEL>
						TEXT=')'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		DESCR='otherwise, when the \'type\' attribute is specified'
		COND='getAttrValue("type") != ""'
		FMT={
			sec.outputStyle='text-par';
			text.style='cs3';
			txtfl.delimiter.type='none';
		}
		BREAK_PARENT_BLOCK='when-executed'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT=' (type '
					</LABEL>
					<SS_CALL_CTRL>
						FMT={
							text.hlink.fmt='style';
							text.hlink.style='cs5';
							txtfl.delimiter.type='text';
							txtfl.delimiter.text=', ';
						}
						SS_NAME='Type By QName'
						PARAMS_EXPR='Array (getAttrQNameValue("type"))'
					</SS_CALL_CTRL>
					<LABEL>
						TEXT=')'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<FOLDER>
		DESCR='otherwise, the element has anonymous type and may be contained\nin multiple other elements'
		FMT={
			sec.outputStyle='text-par';
			text.style='cs3';
			txtfl.delimiter.type='none';
		}
		<BODY>
			<FOLDER>
				DESCR='when the element has anonymous type'
				COND='hasChild ("xs:simpleType | xs:complexType")'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						DESCR='the extension of a global type'
						CONTEXT_ELEMENT_EXPR='findElementByLPath("\n  xs:complexType/xs:simpleContent/xs:extension |\n  xs:complexType/xs:complexContent/xs:extension\n")'
						MATCHING_ET='xs:%extensionType'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='extension of '
									</LABEL>
									<SS_CALL_CTRL>
										FMT={
											text.hlink.fmt='style';
											text.hlink.style='cs5';
											txtfl.delimiter.type='text';
											txtfl.delimiter.text=', ';
										}
										SS_NAME='Type By QName'
										PARAMS_EXPR='Array (getAttrQNameValue("base"))'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						DESCR='the restriction of a global type'
						CONTEXT_ELEMENT_EXPR='findElementByLPath("\n  xs:simpleType/xs:restriction |\n  xs:complexType/xs:simpleContent/xs:restriction |\n  xs:complexType/xs:complexContent/xs:restriction\n")'
						MATCHING_ETS={'xs:%restrictionType';'xs:restriction'}
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='restriction of '
									</LABEL>
									<SS_CALL_CTRL>
										FMT={
											text.hlink.fmt='style';
											text.hlink.style='cs5';
											txtfl.delimiter.type='text';
											txtfl.delimiter.text=', ';
										}
										SS_NAME='Type By QName'
										PARAMS_EXPR='Array (getAttrQNameValue("base"))'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						DESCR='the restriction of a global type'
						CONTEXT_ELEMENT_EXPR='findElementByLPath (\n \'xs:simpleType/xs:list [getAttrValue("itemType") != null]\'\n)'
						MATCHING_ET='xs:list'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='list of '
									</LABEL>
									<SS_CALL_CTRL>
										FMT={
											text.hlink.fmt='style';
											text.hlink.style='cs5';
											txtfl.delimiter.type='text';
											txtfl.delimiter.text=', ';
										}
										SS_NAME='Type By QName'
										PARAMS_EXPR='Array (getAttrQNameValue("itemType"))'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						DESCR='just anonymous type -- no extension or restriction'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='anonymous'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<AREA_SEC>
				DESCR='otherwise, no type information specified; assume \'anyType\''
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								FMT={
									text.font.style.italic='true';
								}
								TEXT='anyType'
							</LABEL>
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
								TEXT=' (type '
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
								TEXT=')'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</FOOTER>
	</FOLDER>
</ROOT>
<STOCK_SECTIONS>
	<FOLDER>
		MATCHING_ET='xs:%localElement'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		SS_NAME='Local Name Extension'
		<BODY>
			<AREA_SEC>
				DESCR='when the element may be contained in the only other element'
				COND='// see "Context Element" tab'
				CONTEXT_ELEMENT_EXPR='key = (typeQName = getAttrQNameValue ("type")) != null ?\n  HashKey (\n    findAncestor("xs:schema").getAttrStringValue("targetNamespace"),\n    getAttrValue("name"),\n    typeQName\n  )\n: contextElement.id;\n\ncountElementsByKey ("containing-elements", key) == 1 ? \n  findElementByKey ("containing-elements", key) : null'
				MATCHING_ET='xs:%element'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT=' in '
							</LABEL>
							<SS_CALL_CTRL>
								FMT={
									text.hlink.fmt='style';
									text.hlink.style='cs5';
								}
								SS_NAME='XMLName'
							</SS_CALL_CTRL>
							<SS_CALL_CTRL>
								COND='instanceOf("xs:%localElement") && \n{\n  schema = findAncestor ("xs:schema");\n\n  qName = QName (\n    ((hasAttr("form") ? getAttrValue("form") :\n        schema.getAttrValue ("elementFormDefault")) == "qualified" \n          ? schema.getAttrStringValue("targetNamespace") : ""),\n    getAttrStringValue("name")\n  );\n\n  countElementsByKey ("global-elements", qName) +\n  countElementsByKey ("local-elements", qName) > 1\n}'
								SS_NAME='Local Name Extension'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='otherwise, when the \'type\' attribute is specified'
				COND='getAttrValue("type") != ""'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT=' : '
							</LABEL>
							<SS_CALL_CTRL>
								FMT={
									text.hlink.fmt='style';
									text.hlink.style='cs5';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
								}
								SS_NAME='Type By QName'
								PARAMS_EXPR='Array (getAttrQNameValue("type"))'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<FOLDER>
				DESCR='otherwise, the element has anonymous type and may be contained\nin multiple other elements'
				<BODY>
					<FOLDER>
						DESCR='when the element has anonymous type'
						COND='hasChild ("xs:simpleType | xs:complexType")'
						BREAK_PARENT_BLOCK='when-executed'
						<BODY>
							<AREA_SEC>
								DESCR='the extension of a global type'
								CONTEXT_ELEMENT_EXPR='findElementByLPath("\n  xs:complexType/xs:simpleContent/xs:extension |\n  xs:complexType/xs:complexContent/xs:extension\n")'
								MATCHING_ET='xs:%extensionType'
								BREAK_PARENT_BLOCK='when-executed'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='extension of '
											</LABEL>
											<SS_CALL_CTRL>
												FMT={
													text.hlink.fmt='style';
													text.hlink.style='cs5';
													txtfl.delimiter.type='text';
													txtfl.delimiter.text=', ';
												}
												SS_NAME='Type By QName'
												PARAMS_EXPR='Array (getAttrQNameValue("base"))'
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
							<AREA_SEC>
								DESCR='the restriction of a global type'
								CONTEXT_ELEMENT_EXPR='findElementByLPath("\n  xs:simpleType/xs:restriction |\n  xs:complexType/xs:simpleContent/xs:restriction |\n  xs:complexType/xs:complexContent/xs:restriction\n")'
								MATCHING_ETS={'xs:%restrictionType';'xs:restriction'}
								BREAK_PARENT_BLOCK='when-executed'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='restriction of '
											</LABEL>
											<SS_CALL_CTRL>
												FMT={
													text.hlink.fmt='style';
													text.hlink.style='cs5';
													txtfl.delimiter.type='text';
													txtfl.delimiter.text=', ';
												}
												SS_NAME='Type By QName'
												PARAMS_EXPR='Array (getAttrQNameValue("base"))'
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
							<AREA_SEC>
								DESCR='the restriction of a global type'
								CONTEXT_ELEMENT_EXPR='findElementByLPath (\n \'xs:simpleType/xs:list [getAttrValue("itemType") != null]\'\n)'
								MATCHING_ET='xs:list'
								BREAK_PARENT_BLOCK='when-executed'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='list of '
											</LABEL>
											<SS_CALL_CTRL>
												FMT={
													text.hlink.fmt='style';
													text.hlink.style='cs5';
													txtfl.delimiter.type='text';
													txtfl.delimiter.text=', ';
												}
												SS_NAME='Type By QName'
												PARAMS_EXPR='Array (getAttrQNameValue("itemType"))'
											</SS_CALL_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
							<AREA_SEC>
								DESCR='just anonymous type -- no extension or restriction'
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='anonymous'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</FOLDER>
					<AREA_SEC>
						DESCR='otherwise, no type information specified; assume \'anyType\''
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.font.style.italic='true';
										}
										TEXT='anyType'
									</LABEL>
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
										TEXT=' : '
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
		DESCR='param: QName of the type'
		SS_NAME='Type By QName'
		<BODY>
			<AREA_SEC>
				DESCR='if type can be resolved'
				CONTEXT_ELEMENT_EXPR='findElementByKey ("types", stockSection.param.toQName())'
				MATCHING_ETS={'xs:complexType';'xs:simpleType'}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								COND='! getAttrBooleanValue ("abstract")'
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:complexType") ? "complexType" : "simpleType"'
									TARGET_FRAME_EXPR='getStringParam("targetFrame")'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (stockSection.param.toQName())'
							</DATA_CTRL>
							<DATA_CTRL>
								COND='getAttrBooleanValue ("abstract")'
								FMT={
									text.font.style.italic='true';
								}
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:complexType") ?\n  "abstract complexType" : "abstract simpleType"'
									TARGET_FRAME_EXPR='getStringParam("targetFrame")'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (stockSection.param.toQName())'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FORMULA='toXMLName (stockSection.param.toQName())'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
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
									TARGET_FRAME_EXPR='getStringParam("targetFrame")'
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
									TARGET_FRAME_EXPR='getStringParam("targetFrame")'
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
									TARGET_FRAME_EXPR='getStringParam("targetFrame")'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
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
									TARGET_FRAME_EXPR='getStringParam("targetFrame")'
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
CHECKSUM='EvsrxJNxIkU+TzVfZkULwzEnm1yuIk18iD157Ffk+fY'
</DOCFLEX_TEMPLATE>