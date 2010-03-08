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
ROOT_ET='xs:simpleType'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='nsURI';
		param.title='Target Namespace URI';
		param.type='string';
		param.default.expr='findAncestor("xs:schema").getAttrStringValue("targetNamespace")';
		param.hidden='true';
	}
	PARAM={
		param.name='xmlName';
		param.description='Displayed XML name (qualified or local) of the simpleType';
		param.type='string';
		param.default.expr='toXMLName (\n  getStringParam("nsURI"),\n  getAttrStringValue("name")\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='usageCount';
		param.description='number of locations where this type is used';
		param.type='integer';
		param.default.expr='countElementsByKey ("type-usage", contextElement.id)';
		param.hidden='true';
	}
	PARAM={
		param.name='attributeCount';
		param.title='number of all attributes';
		param.description='total number of attributes declared for this component';
		param.type='integer';
		param.hidden='true';
	}
	PARAM={
		param.name='elementCount';
		param.title='number of all content elements';
		param.description='total number of content elements declared for this component';
		param.type='integer';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeCount';
		param.title='number of component\'s own attributes';
		param.description='number of attributes defined within this component';
		param.type='integer';
		param.hidden='true';
	}
	PARAM={
		param.name='ownElementCount';
		param.title='number of component\'s own content elements';
		param.description='number of content elements defined within this component';
		param.type='integer';
		param.hidden='true';
	}
	PARAM={
		param.name='anyAttribute';
		param.title='component has any-attribute';
		param.description='indicates that the component allows any attributes';
		param.type='boolean';
		param.hidden='true';
	}
	PARAM={
		param.name='anyElement';
		param.title='component has any-content-element';
		param.description='indicates that the component allows any content elements';
		param.type='boolean';
		param.hidden='true';
	}
	PARAM={
		param.name='doc.comp';
		param.title='Component Documentation';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.profile';
		param.title='Component Profile';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep';
		param.title='XML Representation Summary';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.simpleType';
		param.title='Generate For Simple Types';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.simpleContent';
		param.title='Simple Content Detail';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.simpleContent.restrictions';
		param.title='Restrictions';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.simpleContent.restrictions.annotation';
		param.title='Annotations';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage';
		param.title='Usage / Definition Locations';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage.for.simpleType';
		param.title='Simple Types';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.annotation';
		param.title='Annotation';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.annotation.for.simpleType';
		param.title='Simple Types';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type';
		param.title='Type Definition Detail';
		param.title.style.bold='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.type.for.type';
		param.title='Global Types';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type.deriv.tree';
		param.title='Type Derivation Tree';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type.annotation';
		param.title='Annotation';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type.deriv.simpleContent';
		param.title='Simple Content Derivation';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='local;full;none';
	}
	PARAM={
		param.name='doc.comp.type.deriv.simpleContent.facets';
		param.title='Facets';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type.deriv.simpleContent.annotations';
		param.title='Annotations';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xml';
		param.title='XML Source';
		param.title.style.bold='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xml.box';
		param.title='Enclose in Box';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xml.remove.anns';
		param.title='Remove Annotations';
		param.type='boolean';
	}
	PARAM={
		param.name='show';
		param.title='Show';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='show.about';
		param.title='About (footer)';
		param.type='enum';
		param.enum.values='full;short;none';
	}
</TEMPLATE_PARAMS>
<HTARGET>
	HKEYS={
		'contextElement.id';
		'"detail"';
	}
</HTARGET>
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
	PAR_STYLE={
		style.name='Detail Heading 1';
		style.id='s1';
		text.font.size='12';
		text.font.style.bold='true';
		par.bkgr.opaque='true';
		par.bkgr.color='#CCCCFF';
		par.border.style='solid';
		par.border.color='#666666';
		par.margin.top='12';
		par.margin.bottom='10';
		par.padding.left='2.5';
		par.padding.right='2.5';
		par.padding.top='2';
		par.padding.bottom='2';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Detail Heading 2';
		style.id='s2';
		text.font.size='9';
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
	PAR_STYLE={
		style.name='Detail Heading 3';
		style.id='s3';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.top='10';
		par.margin.bottom='8';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs3';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='List Heading 1';
		style.id='s4';
		text.font.name='Arial';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.top='12';
		par.margin.bottom='8';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='List Heading 2';
		style.id='s5';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.bottom='8';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Main Heading';
		style.id='s6';
		text.font.name='Verdana';
		text.font.size='13';
		text.font.style.bold='true';
		text.color.foreground='#4477AA';
		par.bkgr.opaque='true';
		par.bkgr.color='#EEEEEE';
		par.border.style='solid';
		par.border.color='#4477AA';
		par.margin.top='0';
		par.margin.bottom='9';
		par.padding.left='5';
		par.padding.right='5';
		par.padding.top='3';
		par.padding.bottom='3';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s7';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Note Font';
		style.id='cs4';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='false';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Page Header Font';
		style.id='cs5';
		text.font.name='Arial';
		text.font.style.italic='true';
	}
	PAR_STYLE={
		style.name='Property Title';
		style.id='s8';
		text.font.size='8';
		text.font.style.bold='true';
		par.lineHeight='11';
		par.margin.right='7';
	}
</STYLES>
<PAGE_HEADER>
	<AREA_SEC>
		FMT={
			text.style='cs5';
			table.cellpadding.both='0';
			table.border.style='none';
			table.border.bottom.style='solid';
		}
		<AREA>
			<CTRL_GROUP>
				FMT={
					par.border.bottom.style='solid';
				}
				<CTRLS>
					<LABEL>
						TEXT='simpleType'
					</LABEL>
					<DATA_CTRL>
						FMT={
							text.font.style.italic='true';
						}
						FORMULA='\'"\' + getParam("xmlName") + \'"\''
					</DATA_CTRL>
					<SS_CALL_CTRL>
						COND='hasServiceAttr ("redefinition")'
						SS_NAME='redefinition'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</PAGE_HEADER>
<ROOT>
	<AREA_SEC>
		FMT={
			par.style='s6';
		}
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT='simpleType'
					</LABEL>
					<DATA_CTRL>
						FMT={
							text.font.style.italic='true';
						}
						FORMULA='\'"\' + getParam("xmlName") + \'"\''
					</DATA_CTRL>
					<SS_CALL_CTRL>
						COND='hasServiceAttr ("redefiniton")'
						SS_NAME='redefinition'
					</SS_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<TEMPLATE_CALL>
		DESCR='Type Profile'
		COND='getBooleanParam("doc.comp.profile")'
		TEMPLATE_FILE='typeProfile.tpl'
		ON_OUTPUT_EXPR='thisContext.setVar ("has-profile", true)'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		DESCR='XML Representation Summary'
		COND='getBooleanParam("doc.comp.xmlRep") &&\ngetBooleanParam("doc.comp.xmlRep.for.simpleType")'
		FMT={
			sec.spacing.before='12';
			sec.spacing.after='8';
		}
		<HTARGET>
			COND='output.type == "document"'
			HKEYS={
				'contextElement.id';
				'"xml-rep-summary"';
			}
			NAME_EXPR='"xml_rep_summary"'
		</HTARGET>
		TEMPLATE_FILE='../content/xmlRep.tpl'
		PASSED_PARAMS={
			'abbreviateSimpleContent','getBooleanParam("doc.comp.simpleContent") &&\ngetBooleanParam("doc.comp.simpleContent.restrictions")';
		}
		ON_OUTPUT_EXPR='thisContext.setVar ("has-xml-rep-summary", true)'
	</TEMPLATE_CALL>
	<FOLDER>
		DESCR='Simple Content Restrictions'
		COND='getBooleanParam("doc.comp.simpleContent")'
		ON_OUTPUT_EXPR='thisContext.setVar ("has-simple-content-detail", true)'
		COLLAPSED
		<BODY>
			<ELEMENT_ITER>
				DESCR='Iterate By Actual Facets\n--\nThe iterated elements are produced as the following:\n\n1. First, all facet elements that are declared both in the context type and all its ancestor types (global and anonymous) are collected. (This will work, however, until a derivation by list or union is reached.) \n\nWhat\'s important is that how the facets will follow in the result sequence. The facets from the same restriction will appear in the same order as they were declared. The facets from different restrictions will appear according to the remoteness of their parent restrictions from the context type.\n\nThis everything is determined with the Location Rules (and their ordering) specified in "Processing | Iteration Scope" tab.\n\n2. Once the initial sequence is produced, the filtering by key will be applied (see "Processing | Filtering | Filter By Key" tab). The purpose of the filtering is to remove those facets that are overridden in the descendant types.  There are two special cases:\n\n(1) All <xs:enumeration> facets will be removed except the first (valid) one. That will be enough to obtain all valid enumeration facets from the <xs:restriction> parent of the left one. This is done in "facet.tpl" template (called to print a facet value).\n\n(2) All <xs:pattern> facets will be left because they all are valid.\n\nAll those conditions are specified in the "Expression For Unique Key". In the case of <xs:pattern>, the key will be the element ID, which is always unique (therefore, no <xs:pattern> element will be removed.\n\nThe "Preference Condition" expression determines if a given element should replace the already passed element with the same key. That will be so when the expression returns true. We specify to return the value of the facet\'s \'fixed\' attribute. The \'fixed\' attribute overrides anything that might be specified about that facet in the descendant types. (However, actually, doing this is not allowed in XSD!)\n\n3. In the "Processing | Sorting" tab we specify sorting the result facets according to the facet type names. This is done primarily to ensure that all "pattern" facets are printed together.'
				COND='getBooleanParam("doc.comp.simpleContent.restrictions")'
				FMT={
					sec.outputStyle='table';
					table.cellpadding.both='0';
					table.border.style='none';
					table.option.borderStylesInHTML='true';
				}
				TARGET_ET='xs:%facet'
				SCOPE='advanced-location-rules'
				RULES={
					'xs:%simpleType -> xs:restriction',recursive;
					'xs:restriction -> (xs:%facet|xs:simpleType)',recursive;
					'xs:restriction -> {baseQName = getAttrQNameValue("base");\n(baseQName != null && ! baseQName.isXSPredefinedType()) ? \n{\n  findElementsByKey (\n    "types",\n    hasServiceAttr ("redefined") ?\n      HashKey (baseQName, getServiceAttr ("redefined")) : baseQName\n  )\n}}::xs:simpleType',recursive;
				}
				FILTER_BY_KEY='instanceOf("xs:pattern") ?\n  contextElement.id : contextElement.dsmElement.qName\n'
				FILTER_BY_KEY_COND='getAttrBooleanValue("fixed")'
				SORTING='by-name'
				SORTING_KEY={expr='contextElement.name',ascending}
				<BODY>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<DATA_CTRL>
										FMT={
											ctrl.size.width='32.3';
											ctrl.size.height='17.3';
											tcell.align.vert='Top';
											par.style='s8';
										}
										FORMULA='name = contextElement.dsmElement.qName.localName;\nname.charAt(0).toUpperCase() + name.substring(1) + \':\''
									</DATA_CTRL>
									<TEMPLATE_CALL_CTRL>
										FMT={
											ctrl.size.width='467.3';
											ctrl.size.height='17.3';
											tcell.align.vert='Bottom';
											tcell.padding.extra.top='0.5';
										}
										TEMPLATE_FILE='../content/facet.tpl'
										PASSED_PARAMS={
											'facet.annotation','getBooleanParam("doc.comp.simpleContent.restrictions.annotation")';
										}
									</TEMPLATE_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</ELEMENT_ITER>
		</BODY>
		<HEADER>
			<AREA_SEC>
				COND='thisContext.checkVar ("has-profile")\n&&\n! thisContext.checkVar ("has-xml-rep-summary")'
				FMT={
					sec.outputStyle='pars';
				}
				<AREA>
					<HR>
						FMT={
							par.margin.top='12';
							par.margin.bottom='12';
						}
					</HR>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				FMT={
					par.style='s3';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='Simple Content Restrictions:'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<FOLDER>
		DESCR='Lists of related elements'
		COLLAPSED
		<BODY>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='typeRelatedCompLists.tpl'
			</TEMPLATE_CALL>
		</BODY>
		<HEADER>
			<AREA_SEC>
				COND='thisContext.checkVar ("has-simple-content-detail")\n||\nthisContext.checkVar ("has-profile")\n&&\n! thisContext.checkVar ("has-xml-rep-summary")'
				FMT={
					sec.outputStyle='pars';
				}
				<AREA>
					<HR>
						FMT={
							par.margin.top='12';
							par.margin.bottom='12';
						}
					</HR>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<TEMPLATE_CALL>
		DESCR='Usage Locations'
		COND='getBooleanParam("doc.comp.usage") &&\ngetBooleanParam("doc.comp.usage.for.simpleType")\n&&\ngetIntParam("usageCount") > 0'
		TEMPLATE_FILE='typeUsage.tpl'
	</TEMPLATE_CALL>
	<FOLDER>
		DESCR='Annotation'
		COND='getBooleanParam("doc.comp.annotation") &&\ngetBooleanParam("doc.comp.annotation.for.simpleType")'
		FMT={
			sec.spacing.before='12';
		}
		COLLAPSED
		<BODY>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='../ann/annotation.tpl'
			</TEMPLATE_CALL>
		</BODY>
		<HEADER>
			<AREA_SEC>
				FMT={
					par.style='s2';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							trow.bkgr.color='#CCCCFF';
						}
						<CTRLS>
							<LABEL>
								TEXT='Annotation'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<FOLDER>
		DESCR='TYPE DEFINITION DETAIL'
		COND='getBooleanParam("doc.comp.type") &&\ngetBooleanParam("doc.comp.type.for.type")'
		<HTARGET>
			HKEYS={
				'contextElement.id';
				'"type-def-detail"';
			}
			NAME_EXPR='output.type == "document" ? "type_def_detail" : ""'
		</HTARGET>
		COLLAPSED
		<BODY>
			<AREA_SEC>
				COND='getBooleanParam("doc.comp.type.deriv.tree")'
				FMT={
					sec.outputStyle='table';
					sec.spacing.before='10';
					sec.spacing.after='10';
					table.sizing='Relative';
					table.autofit='false';
					table.cellpadding.both='4';
					table.bkgr.color='#F5F5F5';
					table.border.style='solid';
					table.border.color='#999999';
					table.page.keepTogether='true';
					table.option.borderStylesInHTML='true';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<TEMPLATE_CALL_CTRL>
								FMT={
									ctrl.size.width='499.5';
									ctrl.size.height='17.3';
								}
								TEMPLATE_FILE='typeDerivationTree.tpl'
								PASSED_PARAMS={
									'xml_source_link','! getBooleanParam("doc.comp.xml")';
								}
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<TEMPLATE_CALL>
				COND='! hasParamValue("doc.comp.type.deriv.simpleContent", "none")'
				TEMPLATE_FILE='../content/simpleContentDerivation.tpl'
				PASSED_PARAMS={
					'deriv.simpleContent','getStringParam("doc.comp.type.deriv.simpleContent")';
					'deriv.simpleContent.facets','getBooleanParam("doc.comp.type.deriv.simpleContent.facets")';
					'deriv.simpleContent.annotations','getBooleanParam("doc.comp.type.deriv.simpleContent.annotations")';
				}
			</TEMPLATE_CALL>
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
								TEXT='Type Definition Detail'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<FOLDER>
		DESCR='XML SOURCE'
		COND='getBooleanParam("doc.comp.xml")'
		<HTARGET>
			HKEYS={
				'contextElement.id';
				'"xml-source"';
			}
			NAME_EXPR='output.type == "document" ? "xml_source" : ""'
		</HTARGET>
		COLLAPSED
		<BODY>
			<AREA_SEC>
				COND='getBooleanParam("doc.comp.xml.box")'
				FMT={
					sec.outputStyle='table';
					table.sizing='Relative';
					table.autofit='false';
					table.cellpadding.both='4';
					table.bkgr.color='#F5F5F5';
					table.border.style='solid';
					table.border.color='#999999';
					table.option.borderStylesInHTML='true';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<TEMPLATE_CALL_CTRL>
								FMT={
									ctrl.size.width='499.5';
									ctrl.size.height='17.3';
								}
								TEMPLATE_FILE='../xml/nodeSource.tpl'
								PASSED_PARAMS={
									'remove.anns','getBooleanParam("doc.comp.xml.remove.anns")';
								}
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='../xml/nodeSource.tpl'
				PASSED_PARAMS={
					'remove.anns','getBooleanParam("doc.comp.xml.remove.anns")';
				}
			</TEMPLATE_CALL>
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
								TEXT='XML Source'
							</LABEL>
							<DELIMITER>
							</DELIMITER>
							<TEMPLATE_CALL_CTRL>
								FMT={
									text.style='cs4';
								}
								TEMPLATE_FILE='../xml/sourceNote.tpl'
								PASSED_PARAMS={
									'remove.anns','getBooleanParam("doc.comp.xml.remove.anns")';
								}
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<TEMPLATE_CALL>
		DESCR='Bottom Message'
		COND='output.type == "document" &&\n! hasParamValue("show.about", "none")'
		TEMPLATE_FILE='../about.tpl'
	</TEMPLATE_CALL>
</ROOT>
<STOCK_SECTIONS>
	<AREA_SEC>
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='redefinition'
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT='(redefinition'
					</LABEL>
					<DATA_CTRL>
						COND='getServiceAttr("redefinition").toInt() > 0'
						FORMULA='getServiceAttr ("redefinition")'
					</DATA_CTRL>
					<DELIMITER>
						FMT={
							txtfl.delimiter.type='none';
						}
					</DELIMITER>
					<LABEL>
						TEXT=')'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</STOCK_SECTIONS>
CHECKSUM='NNiQgXddbErFgM6uezwFODosLh7ElQIViNTb6J8EH7M'
</DOCFLEX_TEMPLATE>