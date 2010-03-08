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
ROOT_ETS={'xs:%complexType';'xs:%simpleType'}
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs5';
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
		style.name='Derivation Method';
		style.id='cs4';
		text.font.name='Verdana';
		text.font.size='8';
		text.color.foreground='#FF9900';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs5';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s1';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='XML Source';
		style.id='cs6';
		text.font.name='Verdana';
		text.font.size='8';
	}
</STYLES>
<ROOT>
	<FOLDER>
		FMT={
			sec.outputStyle='text-par';
		}
		<BODY>
			<SS_CALL>
				MATCHING_ET='xs:%complexType'
				SS_NAME='complexType Derivation'
			</SS_CALL>
			<SS_CALL>
				MATCHING_ET='xs:%simpleType'
				SS_NAME='simpleType Derivation'
			</SS_CALL>
		</BODY>
		<HEADER>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='('
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
	<ELEMENT_ITER>
		MATCHING_ET='xs:%complexType'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='space';
		}
		TARGET_ETS={'xs:%extensionType';'xs:%restrictionType'}
		SCOPE='advanced-location-rules'
		RULES={
			'* -> xs:complexContent/(xs:extension|xs:restriction)';
			'* -> xs:simpleContent/(xs:extension|xs:restriction)';
		}
		SS_NAME='complexType Derivation'
		STEP_EXPR='typeQName = adaptQName (\n  getAttrQNameValue("base"),\n  rootElement\n);\n\nsetVar ("typeQName", typeQName);\n\nsetVar (\n  "type", \n  findElementByKey (\n    "types",\n    hasServiceAttr ("redefined") ? HashKey (typeQName, getServiceAttr ("redefined")) : typeQName\n  )\n)'
		<BODY>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								MATCHING_ET='xs:%restrictionType'
								FMT={
									text.style='cs4';
								}
								TEXT='restriction of'
							</LABEL>
							<LABEL>
								MATCHING_ET='xs:%extensionType'
								FMT={
									text.style='cs4';
								}
								TEXT='extension of'
							</LABEL>
							<DATA_CTRL>
								COND='! getElementVar("type").getAttrBooleanValue ("abstract")'
								FMT={
									text.style='cs2';
								}
								<DOC_HLINK>
									HKEYS={
										'getElementVar("type").id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='getQNameVar("typeQName").toXMLName()'
							</DATA_CTRL>
							<DATA_CTRL>
								COND='getElementVar("type").getAttrBooleanValue ("abstract")'
								FMT={
									text.style='cs2';
									text.font.style.italic='true';
								}
								<DOC_HLINK>
									HKEYS={
										'getElementVar("type").id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='getQNameVar("typeQName").toXMLName()'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</ELEMENT_ITER>
	<ELEMENT_ITER>
		MATCHING_ET='xs:%simpleType'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='space';
		}
		TARGET_ETS={'xs:list';'xs:restriction';'xs:union'}
		SCOPE='simple-location-rules'
		RULES={
			'* -> (xs:list|xs:restriction|xs:union)';
		}
		SS_NAME='simpleType Derivation'
		<BODY>
			<FOLDER>
				MATCHING_ET='xs:restriction'
				<BODY>
					<AREA_SEC>
						COND='getAttrValue("base") != null'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.style='cs4';
										}
										TEXT='restriction of'
									</LABEL>
									<DATA_CTRL>
										FMT={
											text.style='cs2';
										}
										<DOC_HLINK>
											HKEYS={
												'qName = getAttrQNameValue("base");\n\nfindElementByKey (\n  "types",\n  hasServiceAttr ("redefined") ?\n    HashKey (qName, getServiceAttr ("redefined")) : qName\n).id';
												'Array ("detail", "xml-source-location")',array;
											}
										</DOC_HLINK>
										FORMULA='toXMLName (getAttrQNameValue("base"))'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.style='cs4';
										}
										TEXT='restriction of'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='simpleType Derivation'
										PASSED_ELEMENT_EXPR='findChild("xs:simpleType")'
										PASSED_ELEMENT_MATCHING_ET='xs:%localSimpleType'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<FOLDER>
				MATCHING_ET='xs:list'
				<BODY>
					<AREA_SEC>
						COND='getAttrValue("itemType") != null'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.style='cs4';
										}
										TEXT='list of'
									</LABEL>
									<DATA_CTRL>
										FMT={
											text.style='cs2';
										}
										<DOC_HLINK>
											HKEYS={
												'findElementByKey ("types", getAttrQNameValue("itemType")).id';
												'Array ("detail", "xml-source-location")',array;
											}
										</DOC_HLINK>
										FORMULA='toXMLName (getAttrQNameValue("itemType"))'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.style='cs4';
										}
										TEXT='list of'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='simpleType Derivation'
										PASSED_ELEMENT_EXPR='findChild("xs:simpleType")'
										PASSED_ELEMENT_MATCHING_ET='xs:%localSimpleType'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<FOLDER>
				MATCHING_ET='xs:union'
				FMT={
					txtfl.delimiter.type='text';
					txtfl.delimiter.text=' | ';
				}
				<BODY>
					<ATTR_ITER>
						SCOPE='attr-values'
						ATTR='memberTypes'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FMT={
													text.style='cs2';
												}
												<DOC_HLINK>
													HKEYS={
														'findElementByKey ("types", toQName (iterator.value)).id';
														'Array ("detail", "xml-source-location")',array;
													}
												</DOC_HLINK>
												FORMULA='toXMLName (iterator.value.toQName())'
											</DATA_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
					</ATTR_ITER>
					<ELEMENT_ITER>
						TARGET_ET='xs:%localSimpleType'
						SCOPE='simple-location-rules'
						RULES={
							'* -> xs:%localSimpleType';
						}
						<BODY>
							<SS_CALL>
								SS_NAME='simpleType Derivation'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								FMT={
									txtfl.delimiter.type='space';
								}
								<CTRLS>
									<LABEL>
										FMT={
											text.style='cs4';
										}
										TEXT='union of'
									</LABEL>
									<LABEL>
										TEXT='('
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
		</BODY>
	</ELEMENT_ITER>
</STOCK_SECTIONS>
CHECKSUM='EO0lI4RZ5v?7zrjhCsP3k1ZNFCY?ZE0CzWOC4HfZbwc'
</DOCFLEX_TEMPLATE>