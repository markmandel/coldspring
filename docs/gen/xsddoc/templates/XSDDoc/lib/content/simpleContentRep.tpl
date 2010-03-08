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
ROOT_ETS={'xs:%complexType';'xs:%simpleType'}
<TEMPLATE_PARAMS>
	PARAM={
		param.name='highlight_markup';
		param.description='highlight XML markup (quotes) with blue color';
		param.type='boolean';
	}
	PARAM={
		param.name='apply_brackets';
		param.description='indicates that all brackets must be applied';
		param.type='boolean';
	}
	PARAM={
		param.name='abbreviate_enum';
		param.description='indicates that when a simple content representation consists of the only enumeration, it should be abbreviated (shown as "enumeration of ...")';
		param.type='boolean';
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
	CHAR_STYLE={
		style.name='XML Markup';
		style.id='cs3';
		text.color.foreground='#0000FF';
		text.option.nbsps='true';
	}
</STYLES>
<ROOT>
	<FOLDER>
		DESCR='in case of a global simpleType, first obtain the type\'s QName (see Processing). If this QName points to an XSD predefined type, print it as is'
		MATCHING_ET='xs:simpleType'
		INIT_EXPR='setVar ("typeQName", QName (\n  findAncestor("xs:schema").getAttrStringValue ("targetNamespace"),\n  getAttrStringValue("name")\n))'
		BREAK_PARENT_BLOCK='when-executed'
		<BODY>
			<AREA_SEC>
				COND='isXSPredefinedType (getQNameVar ("typeQName"))'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FMT={
									ctrl.option.text.noBlankOutput='true';
								}
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='getQNameVar("typeQName").toXMLName()'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<SS_CALL>
				DESCR='otherwise, look into the type\'s inside'
				SS_NAME='simpleType'
				PARAMS_EXPR='Array ("", getBooleanParam("apply_brackets"))'
			</SS_CALL>
		</BODY>
	</FOLDER>
	<SS_CALL>
		MATCHING_ET='xs:%localSimpleType'
		BREAK_PARENT_BLOCK='when-executed'
		SS_NAME='simpleType'
		PARAMS_EXPR='Array ("", getBooleanParam("apply_brackets"))'
	</SS_CALL>
	<SS_CALL>
		MATCHING_ET='xs:%complexType'
		SS_NAME='complexType'
		PARAMS_EXPR='Array ("", getBooleanParam("apply_brackets"))'
	</SS_CALL>
</ROOT>
<STOCK_SECTIONS>
	<ELEMENT_ITER>
		DESCR='this should be a complexType with simple content only;\n\nparams[0]: indicates the expression context\nparams[1]: indicates that all brackets must be applied'
		MATCHING_ET='xs:%complexType'
		TARGET_ETS={'xs:extension%xs:simpleExtensionType';'xs:restriction%xs:simpleRestrictionType'}
		SCOPE='advanced-location-rules'
		RULES={
			'* -> xs:simpleContent/(xs:extension|xs:restriction)';
		}
		SS_NAME='complexType'
		<BODY>
			<SS_CALL>
				DESCR='process the restriction contained in it'
				MATCHING_ET='xs:%simpleRestrictionType'
				SS_NAME='restriction'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				DESCR='process the extension contained in it;\nproceed with the base type (see "Call Settings | Passed Parameters" tab)'
				MATCHING_ET='xs:%simpleExtensionType'
				SS_NAME='typeByQName'
				PARAMS_EXPR='Array (\n  stockSection.params[0],\n  stockSection.params[1],\n  getAttrQNameValue("base"),\n  getServiceAttr ("redefined")\n)'
			</SS_CALL>
		</BODY>
	</ELEMENT_ITER>
	<FOLDER>
		DESCR='params[0]: indicates the expression context. Possible values: \n\n"" -- no context, what\'s generated will be the whole expression;\n"expr_inside" -- what\'s generated will be enclodes in a bigger expression produced by this template;\n"enum" -- this is both the "expression-inside" and indicates that the "enumeration of ..." has been started (so as to pass over another enumeration within the ancestor type)\n\nparams[1]: indicates that all brackets must be applied'
		MATCHING_ETS={'xs:%simpleRestrictionType';'xs:restriction'}
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='restriction'
		<BODY>
			<FOLDER>
				DESCR='if there are enumeration facets, they override any enumerations defined in supertypes, therefore we are not interested in them'
				COND='hasChild("xs:enumeration")'
				<BODY>
					<AREA_SEC>
						DESCR='if the enumeration should be abbreviated'
						COND='stockSection.param != "expr_inside" && \ngetBooleanParam("abbreviate_enum")'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										COND='stockSection.param == ""'
										FMT={
											text.font.style.italic='true';
										}
										TEXT='enumeration of'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='typeByQName'
										PARAMS_EXPR='Array (\n  "enum",\n  true,\n  getAttrQNameValue("base"),\n  getServiceAttr ("redefined")\n)'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<ELEMENT_ITER>
						DESCR='otherwise, print all enumeration values'
						FMT={
							txtfl.delimiter.type='text';
							txtfl.delimiter.text=' | ';
						}
						TARGET_ET='xs:enumeration'
						SCOPE='simple-location-rules'
						RULES={
							'* -> xs:enumeration';
						}
						<BODY>
							<AREA_SEC>
								COND='getBooleanParam("highlight_markup")'
								BREAK_PARENT_BLOCK='when-executed'
								<AREA>
									<CTRL_GROUP>
										FMT={
											txtfl.delimiter.type='none';
										}
										<CTRLS>
											<LABEL>
												FMT={
													text.style='cs3';
												}
												TEXT='"'
											</LABEL>
											<DATA_CTRL>
												ATTR='value'
											</DATA_CTRL>
											<LABEL>
												FMT={
													text.style='cs3';
												}
												TEXT='"'
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
												TEXT='"'
											</LABEL>
											<DATA_CTRL>
												ATTR='value'
											</DATA_CTRL>
											<LABEL>
												TEXT='"'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</BODY>
						<HEADER>
							<AREA_SEC>
								COND='stockSection.params[1].toBoolean() &&\niterator.numItems > 1'
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
								COND='stockSection.params[1].toBoolean() &&\niterator.numItems > 1'
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
					</ELEMENT_ITER>
				</BODY>
			</FOLDER>
		</BODY>
		<ELSE>
			DESCR='if no enumeration facets, look what\'s defined in the anonymous type or supertype'
			<SS_CALL>
				DESCR='if there\'s an anonymous simple type'
				CONTEXT_ELEMENT_EXPR='findChild ("xs:simpleType")'
				MATCHING_ET='xs:%localSimpleType'
				SS_NAME='simpleType'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<SS_CALL>
				DESCR='otherwise, process the base type'
				COND='sectionBlock.execSecNone && getAttrStringValue("base") != ""'
				SS_NAME='typeByQName'
				PARAMS_EXPR='Array (\n  stockSection.params[0],\n  stockSection.params[1],\n  getAttrQNameValue("base"),\n  getServiceAttr ("redefined")\n)'
			</SS_CALL>
		</ELSE>
	</FOLDER>
	<ELEMENT_ITER>
		DESCR='params[0]: indicates the expression context. Possible values: \n\n"" -- no context, what\'s generated will be the whole expression;\n"expr_inside" -- what\'s generated will be enclodes in a bigger expression produced by this template;\n"enum" -- this is both the "expression-inside" and indicates that the "enumeration of ..." has been started (so as to pass over another enumeration within the ancestor type)\n\nparams[1]: indicates that all brackets must be applied'
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
		SS_NAME='simpleType'
		<BODY>
			<SS_CALL>
				MATCHING_ET='xs:restriction'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='restriction'
				PARAMS_EXPR='stockSection.params'
			</SS_CALL>
			<FOLDER>
				MATCHING_ET='xs:list'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						COND='getAttrValue("itemType") != null'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.font.style.italic='true';
										}
										TEXT='list of'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='typeByQName'
										PARAMS_EXPR='Array ("expr_inside", true, getAttrQNameValue("itemType"))'
									</SS_CALL_CTRL>
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
											text.font.style.italic='true';
										}
										TEXT='list of'
									</LABEL>
									<SS_CALL_CTRL>
										SS_NAME='simpleType'
										PASSED_ELEMENT_EXPR='findChild("xs:simpleType")'
										PASSED_ELEMENT_MATCHING_ET='xs:%simpleType'
										PARAMS_EXPR='Array ("expr_inside", true)'
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
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<ATTR_ITER>
						SCOPE='attr-values'
						ATTR='memberTypes'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<SS_CALL_CTRL>
												SS_NAME='typeByQName'
												PARAMS_EXPR='Array ("expr_inside", true, toQName (iterator.value))'
											</SS_CALL_CTRL>
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
								SS_NAME='simpleType'
								PARAMS_EXPR='Array ("expr_inside", true)'
							</SS_CALL>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
				<HEADER>
					<AREA_SEC>
						COND='stockSection.params[1].toBoolean()'
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
						COND='stockSection.params[1].toBoolean()'
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
	<FOLDER>
		DESCR='params[0]: indicates the expression context\nparams[1]: indicates that all brackets must be applied\nparams[2]: QName of the global type\nparams[3]: the value of \'redefined\' service attribute; non-null value indicates that this type has been redefined, however the original type is referenced here'
		SS_NAME='typeByQName'
		<BODY>
			<FOLDER>
				DESCR='if this is not a predefined XSD type, switch to an element representing it'
				COND='! isXSPredefinedType (toQName (stockSection.params [2]))'
				CONTEXT_ELEMENT_EXPR='qName = stockSection.params[2];\n\nfindElementByKey (\n  "types", \n  ((redefined = stockSection.params[3]) != null ?\n    HashKey (qName, redefined) : qName)\n)'
				MATCHING_ETS={'xs:complexType';'xs:simpleType'}
				<BODY>
					<SS_CALL>
						DESCR='process a simpleType'
						MATCHING_ET='xs:simpleType'
						BREAK_PARENT_BLOCK='when-executed'
						SS_NAME='simpleType'
						PARAMS_EXPR='stockSection.params'
					</SS_CALL>
					<SS_CALL>
						DESCR='process a complexType'
						MATCHING_ET='xs:complexType'
						SS_NAME='complexType'
						PARAMS_EXPR='stockSection.params'
					</SS_CALL>
				</BODY>
			</FOLDER>
		</BODY>
		<ELSE>
			DESCR='if no output has been produced, just print the type\'s QName itself'
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									HKEYS={
										'qName = stockSection.params[2];\n\nfindElementByKey (\n  "types", \n  ((redefined = stockSection.params[3]) != null ?\n    HashKey (qName, redefined) : qName)\n).id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='(typeQName = stockSection.params[2].toQName()) != null\n  ? toXMLName (typeQName)\n  : toXMLName (getNamespaceURI("xs"), "anySimpleType")'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</ELSE>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='PqhSCENXiaGBLYYE7Np3XS1NwbMUcRAmQIWUPsYhvL8'
</DOCFLEX_TEMPLATE>