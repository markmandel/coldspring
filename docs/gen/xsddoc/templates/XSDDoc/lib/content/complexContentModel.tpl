<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-05-03 12:32:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ETS={'xs:%complexType';'xs:group'}
<TEMPLATE_PARAMS>
	PARAM={
		param.name='owner_id';
		param.description='The element identifier of the schema component containing this model';
		param.type='Object';
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
		style.name='Normal';
		style.id='s1';
		style.default='true';
	}
</STYLES>
<ROOT>
	<FOLDER>
		MATCHING_ET='xs:%complexType'
		FMT={
			sec.outputStyle='text-par';
		}
		BREAK_PARENT_BLOCK='when-executed'
		<BODY>
			<AREA_SEC>
				COND='// see "Context Element" tab'
				CONTEXT_ELEMENT_EXPR='el = (el = findChild("xs:complexContent")) != null && el.hasAttr ("mixed")\n     ? el : contextElement;\n\nel.getAttrBooleanValue("mixed") ? el : null'
				MATCHING_ETS={'xs:%complexType';'xs:complexContent'}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'"xml-source-location"';
									}
								</DOC_HLINK>
								TEXT='{text}'
							</LABEL>
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=' \u00d7 ';
								}
							</DELIMITER>
							<SS_CALL_CTRL>
								SS_NAME='complexType'
								PASSED_ELEMENT_EXPR='sectionBlock.contextElement'
								PASSED_ELEMENT_MATCHING_ET='xs:%complexType'
								PARAMS_EXPR='Array("mixed_context")'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME='complexType'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
	<SS_CALL>
		MATCHING_ET='xs:group'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='group'
	</SS_CALL>
</ROOT>
<STOCK_SECTIONS>
	<ELEMENT_ITER>
		MATCHING_ET='xs:%all'
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='text';
			txtfl.delimiter.text=' \u00d7 ';
		}
		TARGET_ET='xs:element%xs:narrowMaxMin'
		SCOPE='simple-location-rules'
		RULES={
			'* -> xs:element%xs:narrowMaxMin';
		}
		SS_NAME='all'
		<BODY>
			<AREA_SEC>
				DESCR='when this is a reference to a global element'
				COND='getAttrValue("ref") != null'
				INIT_EXPR='stockSection.setVar (\n  "globalElement", \n  findElementByKey (\n    "global-elements", getAttrQNameValue("ref")\n  )\n)'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								DESCR='case of global element'
								COND='! stockSection.getElementVar (\n  "globalElement"\n).getAttrBooleanValue("abstract")'
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
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
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
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
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
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
									TITLE_EXPR='"abstract global element"'
									HKEYS={
										'stockSection.getElementVar("globalElement").id';
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
										'"xml-source-location"';
									}
								</DOC_HLINK>
								FORMULA='toXMLName (getAttrQNameValue("ref"))'
							</DATA_CTRL>
							<LABEL>
								COND='getAttrIntValue("minOccurs") == 0 &&\ngetAttrStringValue("maxOccurs") == "1"'
								TEXT='?'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='otherwise, this is a local element'
				INIT_EXPR='stockSection.setVar (\n  "globalElement", \n  findElementByKey (\n    "global-elements", getAttrQNameValue("ref")\n  )\n)'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								FMT={
									ctrl.size.width='481.5';
									ctrl.size.height='17.3';
								}
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'Array ("def", "detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='name = getAttrStringValue("name");\nschema = findAncestor ("xs:schema");\n\n(hasAttr("form") ? getAttrValue("form") :\n  schema.getAttrValue ("elementFormDefault")) == "qualified" \n    ? toXMLName (schema.getAttrStringValue("targetNamespace"), name) : name'
							</DATA_CTRL>
							<LABEL>
								COND='getAttrIntValue("minOccurs") == 0 &&\ngetAttrStringValue("maxOccurs") == "1"'
								TEXT='?'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
		<HEADER>
			<AREA_SEC>
				COND='getAttrIntValue("minOccurs") == 0'
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
				COND='getAttrIntValue("minOccurs") == 0'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT=')?'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</FOOTER>
	</ELEMENT_ITER>
	<FOLDER>
		MATCHING_ET='xs:any'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='any'
		<BODY>
			<AREA_SEC>
				COND='checkStockSectionOutput ("Occurrence Operator")'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<LABEL>
								COND='stockSection.param == "occurrence_context"'
								TEXT='('
							</LABEL>
							<LABEL>
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'Array ("def", "xml-source-location")',array;
									}
								</DOC_HLINK>
								TEXT='{any}'
							</LABEL>
							<SS_CALL_CTRL>
								SS_NAME='Occurrence Operator'
							</SS_CALL_CTRL>
							<LABEL>
								COND='stockSection.param == "occurrence_context"'
								TEXT=')'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<LABEL>
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'Array ("def", "xml-source-location")',array;
									}
								</DOC_HLINK>
								TEXT='{any}'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
	<FOLDER>
		MATCHING_ETS={'xs:choice';'xs:choice%xs:simpleExplicitGroup'}
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='text';
			txtfl.delimiter.text=' | ';
		}
		SS_NAME='choice'
		<BODY>
			<ELEMENT_ITER>
				COND='checkStockSectionOutput ("Occurrence Operator")'
				TARGET_ETS={'xs:%element';'xs:%group';'xs:any'}
				SCOPE='simple-location-rules'
				RULES={
					'* -> (xs:%element|xs:%group|xs:any)';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<SS_CALL>
						MATCHING_ET='xs:any'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='any'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "choice_context" : "occurrence_context")'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%element'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='element'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%groupRef'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='groupRef'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "choice_context" : "occurrence_context")'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:choice'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='choice'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "choice_context" : "occurrence_context")'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:sequence'
						SS_NAME='sequence'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "choice_context" : "occurrence_context")'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										COND='stockSection.param == "occurrence_context"'
										TEXT='('
									</LABEL>
									<LABEL>
										COND='iterator.numItems > 1'
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
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										COND='iterator.numItems > 1'
										TEXT=')'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='Occurrence Operator'
									</SS_CALL_CTRL>
									<LABEL>
										COND='stockSection.param == "occurrence_context"'
										TEXT=')'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</FOOTER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				TARGET_ETS={'xs:%element';'xs:%group';'xs:any'}
				SCOPE='simple-location-rules'
				RULES={
					'* -> (xs:%element|xs:%group|xs:any)';
				}
				<BODY>
					<SS_CALL>
						MATCHING_ET='xs:any'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='any'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("choice_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%element'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='element'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%groupRef'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='groupRef'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("choice_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:choice'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='choice'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("choice_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:sequence'
						SS_NAME='sequence'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("choice_context") : stockSection.params'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										COND='iterator.numItems > 1 &&\n(stockSection.param != "choice_context" && stockSection.param != "")'
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
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										COND='iterator.numItems > 1 &&\n(stockSection.param != "choice_context" && stockSection.param != "")'
										TEXT=')'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</FOOTER>
			</ELEMENT_ITER>
		</BODY>
	</FOLDER>
	<FOLDER>
		MATCHING_ET='xs:complexContent'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='complexContent'
		<BODY>
			<ELEMENT_ITER>
				DESCR='DERIVATION BY EXTENSION\n--\nif content model is defined both by the base type and by the locally defined particle,\nthen treat the whole thing as a sequence'
				FMT={
					txtfl.delimiter.type='text';
					txtfl.delimiter.text=', ';
				}
				TARGET_ET='xs:extension%xs:extensionType'
				SCOPE='simple-location-rules'
				RULES={
					'* -> xs:extension%xs:extensionType';
				}
				<BODY>
					<SS_CALL>
						SS_NAME='complexType'
						PASSED_ELEMENT_EXPR='baseQName = getAttrQNameValue("base");\n\nfindElementByKey (\n  "types",\n  hasServiceAttr ("redefined") ?\n    HashKey (baseQName, getServiceAttr ("redefined")) : baseQName\n)'
						PASSED_ELEMENT_MATCHING_ET='xs:%complexType'
						PARAMS_EXPR='checkStockSectionOutput ("contentParticle") ?\n  Array ("sequence_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						SS_NAME='contentParticle'
						PARAMS_EXPR='sectionBlock.outputSecNone ?\n  stockSection.params : Array ("sequence_context")'
					</SS_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='DERIVATION BY RESTRICTION'
				TARGET_ET='xs:restriction%xs:complexRestrictionType'
				SCOPE='simple-location-rules'
				RULES={
					'* -> xs:restriction%xs:complexRestrictionType';
				}
				<BODY>
					<SS_CALL>
						SS_NAME='contentParticle'
						PARAMS_EXPR='stockSection.params'
					</SS_CALL>
				</BODY>
			</ELEMENT_ITER>
		</BODY>
	</FOLDER>
	<FOLDER>
		MATCHING_ET='xs:%complexType'
		OUTPUT_CHECKER_EXPR='checkElementsByKey (\n  "content-model-elements", contextElement.id\n) ? 1 : -1'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='complexType'
		<BODY>
			<SS_CALL>
				SS_NAME='complexContent'
				PASSED_ELEMENT_EXPR='findChild("xs:complexContent")'
				PASSED_ELEMENT_MATCHING_ET='xs:complexContent'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				SS_NAME='contentParticle'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
		</BODY>
	</FOLDER>
	<ELEMENT_ITER>
		MATCHING_ETS={'xs:%complexType';'xs:extension%xs:extensionType';'xs:restriction%xs:complexRestrictionType'}
		TARGET_ET='xs:%group'
		SCOPE='simple-location-rules'
		RULES={
			'* -> xs:%group';
		}
		SS_NAME='contentParticle'
		<BODY>
			<SS_CALL>
				MATCHING_ET='xs:%groupRef'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='groupRef'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				MATCHING_ET='xs:%all'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='all'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				MATCHING_ET='xs:choice'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='choice'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				MATCHING_ET='xs:sequence'
				SS_NAME='sequence'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
		</BODY>
	</ELEMENT_ITER>
	<FOLDER>
		MATCHING_ET='xs:%localElement'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='element'
		<BODY>
			<AREA_SEC>
				DESCR='when this is a reference to the global element'
				COND='getAttrValue("ref") != null'
				INIT_EXPR='stockSection.setVar (\n  "globalElement", \n  findElementByKey (\n    "global-elements", getAttrQNameValue("ref")\n  )\n)'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								DESCR='case of global element'
								COND='! stockSection.getElementVar (\n  "globalElement"\n).getAttrBooleanValue("abstract")'
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
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
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
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
										'contextElement.id';
										'"local"';
										'getParam("owner_id")';
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
									TITLE_EXPR='"abstract global element"'
									HKEYS={
										'stockSection.getElementVar("globalElement").id';
										'"detail"';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"global element"'
									HKEYS={
										'contextElement.id';
										'"xml-source-location"';
									}
								</DOC_HLINK>
								FORMULA='toXMLName (getAttrQNameValue("ref"))'
							</DATA_CTRL>
							<SS_CALL_CTRL>
								SS_NAME='Occurrence Operator'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='otherwise, this is a local element'
				INIT_EXPR='stockSection.setVar (\n  "globalElement", \n  findElementByKey (\n    "global-elements", getAttrQNameValue("ref")\n  )\n)'
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
										'"local"';
										'getParam("owner_id")';
									}
								</DOC_HLINK>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									HKEYS={
										'contextElement.id';
										'Array ("def", "detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='name = getAttrStringValue("name");\nschema = findAncestor ("xs:schema");\n\n(hasAttr("form") ? getAttrValue("form") :\n  schema.getAttrValue ("elementFormDefault")) == "qualified" \n    ? toXMLName (schema.getAttrStringValue("targetNamespace"), name) : name'
							</DATA_CTRL>
							<SS_CALL_CTRL>
								SS_NAME='Occurrence Operator'
							</SS_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
	<ELEMENT_ITER>
		MATCHING_ET='xs:group'
		OUTPUT_CHECKER_EXPR='checkElementsByKey (\n  "content-model-elements", contextElement.id\n) ? 1 : -1'
		TARGET_ET='xs:%group'
		SCOPE='simple-location-rules'
		RULES={
			'* -> xs:%group';
		}
		SS_NAME='group'
		<BODY>
			<SS_CALL>
				MATCHING_ET='xs:choice%xs:simpleExplicitGroup'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='choice'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				MATCHING_ET='xs:sequence%xs:simpleExplicitGroup'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='sequence'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				SS_NAME='all'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
		</BODY>
	</ELEMENT_ITER>
	<FOLDER>
		MATCHING_ET='xs:%groupRef'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='groupRef'
		<BODY>
			<FOLDER>
				COND='checkStockSectionOutput ("Occurrence Operator")'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<SS_CALL>
						SS_NAME='group'
						PASSED_ELEMENT_EXPR='qName = getAttrQNameValue("ref");\n\nfindElementByKey (\n  "groups",\n  hasServiceAttr ("redefined") ?\n    HashKey (qName, getServiceAttr ("redefined")) : qName\n)'
						PASSED_ELEMENT_MATCHING_ET='xs:group'
						PARAMS_EXPR='Array ("occurrence_context")'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										COND='stockSection.param == "occurrence_context"'
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
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<SS_CALL_CTRL>
										SS_NAME='Occurrence Operator'
									</SS_CALL_CTRL>
									<LABEL>
										COND='stockSection.param == "occurrence_context"'
										TEXT=')'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</FOOTER>
			</FOLDER>
			<FOLDER>
				<BODY>
					<SS_CALL>
						SS_NAME='group'
						PASSED_ELEMENT_EXPR='qName = getAttrQNameValue("ref");\n\nfindElementByKey (\n  "groups",\n  hasServiceAttr ("redefined") ?\n    HashKey (qName, getServiceAttr ("redefined")) : qName\n)'
						PASSED_ELEMENT_MATCHING_ET='xs:group'
						PARAMS_EXPR='stockSection.params'
					</SS_CALL>
				</BODY>
			</FOLDER>
		</BODY>
	</FOLDER>
	<FOLDER>
		COND='(hasAttr("minOccurs") ||  hasAttr("maxOccurs")) &&\n(getAttrIntValue("minOccurs") != 1 ||  getAttrIntValue("maxOccurs") != 1)'
		MATCHING_ETS={'xs:%element';'xs:%group';'xs:any'}
		SS_NAME='Occurrence Operator'
		<BODY>
			<AREA_SEC>
				BREAK_PARENT_BLOCK='when-output'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								COND='getAttrIntValue("minOccurs") == 0 &&\ngetAttrIntValue("maxOccurs") == 1'
								TEXT='?'
							</LABEL>
							<LABEL>
								COND='getAttrIntValue("minOccurs") == 1 &&\ngetAttrStringValue("maxOccurs") == "unbounded"'
								TEXT='+'
							</LABEL>
							<LABEL>
								COND='getAttrIntValue("minOccurs") == 0 &&\ngetAttrStringValue("maxOccurs") == "unbounded"'
								TEXT='*'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<LABEL>
								TEXT='['
							</LABEL>
							<DATA_CTRL>
								ATTR='minOccurs'
							</DATA_CTRL>
							<LABEL>
								TEXT='..'
							</LABEL>
							<DATA_CTRL>
								FORMULA='(maxOccurs = getAttrStringValue("maxOccurs")) == "unbounded" ? \n"*" : maxOccurs'
							</DATA_CTRL>
							<LABEL>
								TEXT=']'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
	<FOLDER>
		MATCHING_ETS={'xs:sequence';'xs:sequence%xs:simpleExplicitGroup'}
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='text';
			txtfl.delimiter.text=', ';
		}
		SS_NAME='sequence'
		<BODY>
			<ELEMENT_ITER>
				COND='checkStockSectionOutput ("Occurrence Operator")'
				TARGET_ETS={'xs:%element';'xs:%group';'xs:any'}
				SCOPE='simple-location-rules'
				RULES={
					'* -> (xs:%element|xs:%group|xs:any)';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<SS_CALL>
						MATCHING_ET='xs:any'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='any'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "sequence_context" : "occurrence_context")'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%element'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='element'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%groupRef'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='groupRef'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "sequence_context" : "occurrence_context")'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:choice'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='choice'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "sequence_context" : "occurrence_context")'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:sequence'
						SS_NAME='sequence'
						PARAMS_EXPR='Array (iterator.numItems > 1 ? \n  "sequence_context" : "occurrence_context")'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										COND='stockSection.param == "occurrence_context"'
										TEXT='('
									</LABEL>
									<LABEL>
										COND='iterator.numItems > 1'
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
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										COND='iterator.numItems > 1'
										TEXT=')'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='Occurrence Operator'
									</SS_CALL_CTRL>
									<LABEL>
										COND='stockSection.param == "occurrence_context"'
										TEXT=')'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</FOOTER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				TARGET_ETS={'xs:%element';'xs:%group';'xs:any'}
				SCOPE='simple-location-rules'
				RULES={
					'* -> (xs:%element|xs:%group|xs:any)';
				}
				<BODY>
					<SS_CALL>
						MATCHING_ET='xs:any'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='any'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("sequence_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%element'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='element'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:%groupRef'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='groupRef'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("sequence_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:choice'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='choice'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("sequence_context") : stockSection.params'
					</SS_CALL>
					<SS_CALL>
						MATCHING_ET='xs:sequence'
						SS_NAME='sequence'
						PARAMS_EXPR='iterator.numItems > 1 ? \n  Array ("sequence_context") : stockSection.params'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										COND='iterator.numItems > 1 && \n(stockSection.param != "sequence_context" && stockSection.param != "")'
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
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										COND='iterator.numItems > 1 &&\n(stockSection.param != "sequence_context" && stockSection.param != "")'
										TEXT=')'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</FOOTER>
			</ELEMENT_ITER>
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='MoA2wmTAfOeR1xa?o5fqfEYiB58HBYkP?J3cxuBSYpM'
</DOCFLEX_TEMPLATE>