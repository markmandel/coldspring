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
ROOT_ET='#DOCUMENTS'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='nsURI';
		param.title='Namespace URI';
		param.type='string';
	}
	PARAM={
		param.name='gen.doc';
		param.title='Include Details';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='gen.doc.element';
		param.title='Elements';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.element.local';
		param.title='Local Elements';
		param.type='enum';
		param.enum.values='all;complexType;none';
	}
	PARAM={
		param.name='gen.doc.complexType';
		param.title='Complex Types';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.simpleType';
		param.title='Simple Types';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.group';
		param.title='Element Groups';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.attribute';
		param.title='Global Attributes';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.attributeGroup';
		param.title='Attribute Groups';
		param.type='boolean';
	}
	PARAM={
		param.name='show.localElementExt';
		param.title='Local Element Extensions';
		param.type='enum';
		param.enum.values='always;repeating;never';
	}
</TEMPLATE_PARAMS>
<HTARGET>
	HKEYS={
		'getStringParam("nsURI")';
		'"summary"';
	}
</HTARGET>
FMT={
	doc.lengthUnits='pt';
}
<STYLES>
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs1';
		style.default='true';
	}
	PAR_STYLE={
		style.name='Frame Heading';
		style.id='s1';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.top='7';
		par.margin.bottom='3';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Heading Note';
		style.id='s2';
		text.font.name='Tahoma';
		text.font.size='6';
		text.font.style.bold='true';
		par.margin.top='0';
		par.margin.bottom='4';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Item';
		style.id='s3';
		text.font.size='9';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Title 2';
		style.id='s4';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.bottom='4';
		par.option.nowrap='true';
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
	PAR_STYLE={
		style.name='Normal';
		style.id='s5';
		style.default='true';
	}
</STYLES>
<ROOT>
	<FOLDER>
		<BODY>
			<ELEMENT_ITER>
				COND='getBooleanParam("gen.doc.element")'
				TARGET_ET='xs:%element'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema/descendant::xs:%element[instanceOf("xs:element") || ! hasAttr("ref") &&\n{\n  form = hasAttr("form") ? getAttrValue("form") :\n           findAncestor ("xs:schema").getAttrStringValue ("elementFormDefault");\n\n  (form == "qualified" || getStringVar("nsURI") == "")\n}]';
					'*[getVar("nsURI") == ""] -> {findElementsByKey ("namespaces", "")}::xs:%localElement';
				}
				FILTER_BY_KEY='/* Local elements with the same {namespace:name:type} signature\nmay appear in the initially generated scope many times,\nas many as the number of such element components. However,\nsince all local elements with the same name and global type\nare documented as a single quasi-global element, \nmultiple {namespace:name:type} entries must be reduced to only one. \nAll global elements and local elements with anonymous type\nmust be preserved in the list. So, for them the key must be \nunique for each component (e.g. GOMElement.id). \nThe following expression generates a necessary key. */\n\ninstanceOf ("xs:%localElement") &&\n  (typeQName = getAttrQNameValue("type")) != null ?\n{\n  HashKey (\n    getAttrStringValue("name"),\n    typeQName\n  )\n} : contextElement.id'
				FILTER='(instanceOf("xs:element") ||\n{\n  // case of local element\n\n  local = getStringParam("gen.doc.element.local");\n  \n  local == "complexType" ?\n    ((typeQName = getAttrQNameValue("type")) != null) ?\n      findElementByKey ("types", typeQName).instanceOf("xs:complexType")\n    : hasChild("xs:complexType")\n  :\n  local == "all"\n})'
				SORTING='by-expr'
				SORTING_KEY={expr='callStockSection("Element Location")',ascending}
				<BODY>
					<SS_CALL>
						FMT={
							par.style='s3';
						}
						SS_NAME='Element Location'
					</SS_CALL>
				</BODY>
				<HEADER>
					<AREA_SEC>
						FMT={
							sec.spacing.after='3';
							par.style='s1';
						}
						<AREA>
							<CTRL_GROUP>
								FMT={
									par.margin.bottom='0';
								}
								<CTRLS>
									<LABEL>
										COND='hasParamValue("gen.doc.element.local", "all")'
										TEXT='All'
									</LABEL>
									<LABEL>
										COND='hasParamValue("gen.doc.element.local", "none")'
										TEXT='Global'
									</LABEL>
									<LABEL>
										TEXT='Elements'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
							<CTRL_GROUP>
								FMT={
									par.style='s2';
								}
								<CTRLS>
									<LABEL>
										COND='hasParamValue("gen.doc.element.local", "complexType")'
										TEXT='(global + local with complex types)'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				COND='getBooleanParam("gen.doc.complexType")'
				TARGET_ET='xs:complexType'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema';
					'xs:schema -> xs:complexType',recursive;
					'xs:schema -> xs:redefine/xs:complexType',recursive;
				}
				SORTING='by-compound-key'
				SORTING_KEY={
					{expr='getAttrStringValue("name")',ascending};
					{expr='hasServiceAttr ("redefinition") ?\n  getServiceAttr ("redefinition").toInt() : -1',ascending};
				}
				<BODY>
					<SS_CALL>
						FMT={
							par.style='s3';
						}
						SS_NAME='XMLName'
					</SS_CALL>
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
										TEXT='Complex Types'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				COND='getBooleanParam("gen.doc.simpleType")'
				TARGET_ET='xs:simpleType'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema';
					'xs:schema -> xs:simpleType',recursive;
					'xs:schema -> xs:redefine/xs:simpleType',recursive;
				}
				SORTING='by-compound-key'
				SORTING_KEY={
					{expr='getAttrStringValue("name")',ascending};
					{expr='hasServiceAttr ("redefinition") ?\n  getServiceAttr ("redefinition").toInt() : -1',ascending};
				}
				<BODY>
					<SS_CALL>
						FMT={
							par.style='s3';
						}
						SS_NAME='XMLName'
					</SS_CALL>
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
										TEXT='Simple Types'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				COND='getBooleanParam("gen.doc.group")'
				TARGET_ET='xs:group'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema';
					'xs:schema -> xs:group',recursive;
					'xs:schema -> xs:redefine/xs:group',recursive;
				}
				SORTING='by-compound-key'
				SORTING_KEY={
					{expr='getAttrStringValue("name")',ascending};
					{expr='hasServiceAttr ("redefinition") ?\n  getServiceAttr ("redefinition").toInt() : -1',ascending};
				}
				<BODY>
					<SS_CALL>
						FMT={
							par.style='s3';
						}
						SS_NAME='XMLName'
					</SS_CALL>
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
										TEXT='Element Groups'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				COND='getBooleanParam("gen.doc.attribute")'
				TARGET_ET='xs:attribute'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema/xs:attribute';
				}
				SORTING='by-attr'
				SORTING_KEY={lpath='@name',ascending}
				<BODY>
					<SS_CALL>
						FMT={
							par.style='s3';
						}
						SS_NAME='XMLName'
					</SS_CALL>
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
										TEXT='Attributes'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				COND='getBooleanParam("gen.doc.attributeGroup")'
				TARGET_ET='xs:attributeGroup'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema';
					'xs:schema -> xs:attributeGroup',recursive;
					'xs:schema -> xs:redefine/xs:attributeGroup',recursive;
				}
				SORTING='by-compound-key'
				SORTING_KEY={
					{expr='getAttrStringValue("name")',ascending};
					{expr='hasServiceAttr ("redefinition") ?\n  getServiceAttr ("redefinition").toInt() : -1',ascending};
				}
				<BODY>
					<SS_CALL>
						FMT={
							par.style='s3';
						}
						SS_NAME='XMLName'
					</SS_CALL>
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
										TEXT='Attribute Groups'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s4';
					par.option.nowrap='true';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='(nsURI = getStringParam("nsURI")) != "" ?\n  \'Namespace "\' + nsURI + \'"\': "Global Namespace"'
									TARGET_FRAME_EXPR='"detailFrame"'
									HKEYS={
										'getStringParam("nsURI")';
										'"detail"';
									}
								</DOC_HLINK>
								FORMULA='(nsURI = getStringParam("nsURI")) != "" ? nsURI : "{global namespace}"'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
</ROOT>
<STOCK_SECTIONS>
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
					<TEMPLATE_CALL_CTRL>
						COND='instanceOf("xs:%localElement") &&\n(\n  hasParamValue("show.localElementExt", "always")\n  ||\n  hasParamValue("show.localElementExt", "repeating") &&\n  {\n    qName = QName (\n      getStringParam("nsURI"),\n      getAttrStringValue("name")\n    );\n\n    countElementsByKey ("global-elements", qName) +\n    countElementsByKey ("local-elements", qName) > 1\n  }\n)'
						TEMPLATE_FILE='../element/localElementExt.tpl'
						PASSED_PARAMS={
							'targetFrame','"detailFrame"';
						}
					</TEMPLATE_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
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
									TARGET_FRAME_EXPR='"detailFrame"'
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
									TARGET_FRAME_EXPR='"detailFrame"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name")\n)'
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
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='"local element"'
									TARGET_FRAME_EXPR='"detailFrame"'
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
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									TITLE_EXPR='instanceOf ("xs:simpleType") ? "simpleType" : \n  instanceOf ("xs:group") ? "group" : \n    instanceOf ("xs:attributeGroup") ? "attributeGroup" : \n      instanceOf ("xs:attribute") ? "global attribute" : ""'
									TARGET_FRAME_EXPR='"detailFrame"'
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name")\n)'
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
CHECKSUM='P0C?rsJqGRNTSn51Hqqgu4bW9hPnLb3oFAimlDgchWs'
</DOCFLEX_TEMPLATE>