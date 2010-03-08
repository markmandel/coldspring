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
		style.name='Normal Smaller';
		style.id='cs3';
		text.font.name='Arial';
		text.font.size='9';
	}
	PAR_STYLE={
		style.name='Profile Subheading';
		style.id='s2';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
	}
</STYLES>
<ROOT>
	<ELEMENT_ITER>
		FMT={
			sec.outputStyle='list';
			text.style='cs3';
			list.type='delimited';
			list.margin.block='true';
		}
		TARGET_ET='xs:schema'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='findElementsByKey ("namespaces", getParam("nsURI"))'
		SORTING='by-expr'
		SORTING_KEY={expr='getXMLDocument().getAttrStringValue("xmlName")',ascending}
		<BODY>
			<AREA_SEC>
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								<DOC_HLINK>
									HKEYS={
										'contextElement.id';
										'"detail"';
									}
								</DOC_HLINK>
								FORMULA='getXMLDocument().getAttrStringValue("xmlName")'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s2';
					par.margin.top='0';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								FORMULA='"Targeting Schemas (" + iterator.numItems + "):"'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</ELEMENT_ITER>
	<FOLDER>
		DESCR='all components defined in this namesapace'
		FMT={
			sec.spacing.before='6';
		}
		<BODY>
			<AREA_SEC>
				FMT={
					sec.outputStyle='text-par';
					sec.indent.block='true';
					text.style='cs3';
					txtfl.delimiter.type='text';
					txtfl.delimiter.text=', ';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<PANEL>
								COND='count = countElementsByLPath(\n  \'{findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema / xs:element\'\n);\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='197.3';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"element-summary"';
													}
												</DOC_HLINK>
												TEXT='global element'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"element-summary"';
													}
												</DOC_HLINK>
												TEXT='global elements'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='(nsURI = getStringParam("nsURI")) != "" ?\n{\n  count = countElementsByLPath (\n    \'{findElementsByKey ("namespaces", nsURI)}::xs:schema / descendant::xs:%localElement\',\n    BooleanQuery (\n      ! hasAttr("ref") &&\n      {\n        form = hasAttr("form") ? getAttrValue("form") :\n                 findPredecessorByType("xs:schema").getAttrStringValue ("elementFormDefault");\n\n        (form == "qualified")\n      }\n    )\n  )\n} : {\n\n  count = countElementsByLPath (\n    \'{findElementsByKey ("namespaces", "")}::xs:schema / descendant::xs:%localElement\',\n    BooleanQuery (\n      ! hasAttr("ref")\n    )\n  ) + countElementsByKey ("namespaces", "", BooleanQuery (instanceOf ("xs:%localElement")))\n};\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='189';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"element-summary"';
													}
												</DOC_HLINK>
												TEXT='local element'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"element-summary"';
													}
												</DOC_HLINK>
												TEXT='local elements'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='count = countElementsByLPath (\n  \'{findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema /\n   descendant::xs:complexType\'\n);\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='190.5';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"complexType-summary"';
													}
												</DOC_HLINK>
												TEXT='complexType'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"complexType-summary"';
													}
												</DOC_HLINK>
												TEXT='complexTypes'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='count = countElementsByLPath (\n  \'{findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema /\n   descendant::xs:simpleType\'\n);\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='177.8';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"simpleType-summary"';
													}
												</DOC_HLINK>
												TEXT='simpleType'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"simpleType-summary"';
													}
												</DOC_HLINK>
												TEXT='simpleTypes'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='count = countElementsByLPath (\n  \'{findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema /\n   descendant::xs:group\'\n);\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='194.3';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"group-summary"';
													}
												</DOC_HLINK>
												TEXT='element group'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"group-summary"';
													}
												</DOC_HLINK>
												TEXT='element groups'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='count = countElementsByLPath (\n  \'{findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema / xs:attribute\'\n);\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='198';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"attribute-summary"';
													}
												</DOC_HLINK>
												TEXT='global attribute'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"attribute-summary"';
													}
												</DOC_HLINK>
												TEXT='global attributes'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='count = countElementsByLPath (\n  \'{findElementsByKey ("namespaces", getParam("nsURI"))}::xs:schema /\n   descendant::xs:attributeGroup\'\n);\n\ncount > 0 ? { setVar ("count", count); true } : false'
								FMT={
									ctrl.size.width='196.5';
									text.option.nbsps='true';
									txtfl.delimiter.type='nbsp';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<DATA_CTRL>
												FORMULA='getVar("count")'
											</DATA_CTRL>
											<LABEL>
												COND='getVar("count").toInt() == 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"attributeGroup-summary"';
													}
												</DOC_HLINK>
												TEXT='attribute group'
											</LABEL>
											<LABEL>
												COND='getVar("count").toInt() > 1'
												<DOC_HLINK>
													HKEYS={
														'getStringParam("nsURI")';
														'"attributeGroup-summary"';
													}
												</DOC_HLINK>
												TEXT='attribute groups'
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
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s2';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='Targeting Components:'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
</ROOT>
CHECKSUM='SeZ5ZhmWjrToPiXwuQi5U9Bkn2Muq3TqMFL351lpC6I'
</DOCFLEX_TEMPLATE>