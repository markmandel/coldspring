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
ROOT_ET='xs:%element'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='nsURI';
		param.title='Target Namespace URI';
		param.type='string';
		param.default.expr='schema = findAncestor ("xs:schema");\n\ninstanceOf ("xs:element") ? \n  schema.getAttrStringValue("targetNamespace")\n:\n  (hasAttr("form") ? getAttrValue("form") :\n     schema.getAttrStringValue ("elementFormDefault")) == "qualified" \n       ? schema.getAttrStringValue("targetNamespace") : ""';
		param.hidden='true';
	}
	PARAM={
		param.name='xmlName';
		param.description='Displayed XML name (qualified or local) of the element';
		param.type='string';
		param.default.expr='name = getAttrStringValue("name");\nnsURI = getStringParam("nsURI");\n\ninstanceOf ("xs:%localElement") ? \n{\n  form = hasAttr("form") ? getAttrValue ("form") :\n     findAncestor ("xs:schema").getAttrValue ("elementFormDefault");\n\n  (form != "qualified") ? name : toXMLName (nsURI, name)\n} \n: toXMLName (nsURI, name)';
		param.hidden='true';
	}
	PARAM={
		param.name='usageMapKey';
		param.description='The key for "element-usage" map to find items associated with this element';
		param.type='Object';
		param.default.expr='instanceOf ("xs:%localElement") &&\n  (typeQName = getAttrQNameValue("type")) != null ?\n{\n  HashKey (\n    getStringParam("nsURI"),\n    getAttrStringValue("name"),\n    typeQName\n  )\n} : contextElement.id';
	}
	PARAM={
		param.name='usageCount';
		param.description='number of locations where this element is used (by reference)\nor declared locally';
		param.type='integer';
		param.default.expr='countElementsByKey ("element-usage", getParam("usageMapKey"))';
		param.hidden='true';
	}
	PARAM={
		param.name='elementType';
		param.title='element type component';
		param.description='this is either global or anonymous type or null (when type cannot be resolved)';
		param.type='Object';
		param.default.expr='findElementByKey ("element-types", contextElement.id)';
	}
	PARAM={
		param.name='elementTypeQName';
		param.title='element type qualified name';
		param.description='for an anonymous this will be null';
		param.type='Object';
		param.default.expr='elementType = getParam("elementType").toElement();\n\nelementType.instanceOf("#CUSTOM")\n?\n  adaptQName (elementType.value.toQName(), rootElement)\n: \n  QName (\n    getAttrStringValue (\n      elementType.findAncestor ("xs:schema"),\n      "targetNamespace"\n    ),\n    elementType.getAttrStringValue("name"),\n    Enum (rootElement, elementType)\n  )';
	}
	PARAM={
		param.name='contentModelKey';
		param.title='"content-model-attributes", "content-model-elements" map key';
		param.description='The key for "content-model-attributes" and "content-model-elements" maps to find items associated with this element';
		param.type='Object';
		param.default.expr='getParam("elementType").toElement().id';
	}
	PARAM={
		param.name='attributeCount';
		param.title='number of all attributes';
		param.description='total number of attributes declared for this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n   ! instanceOf ("xs:anyAttribute") &&\n   getAttrValue("use") != "prohibited"\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='attributeWildcardCount';
		param.title='number of all attr. wildcards';
		param.description='total number of attribute wildcards declared for this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (instanceOf ("xs:anyAttribute"))\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeCount';
		param.title='number of attributes defined in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    ! instanceOf ("xs:anyAttribute") &&\n    getAttrValue("use") != "prohibited" &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup").id\n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeWildcardCount';
		param.title='number of attr. wildcards defined in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    instanceOf ("xs:anyAttribute") &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup").id\n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownAttributeProhibitionCount';
		param.title='number of attr. prohibitions specified in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-attributes", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    getAttrValue("use") == "prohibited" &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:attributeGroup").id\n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='elementCount';
		param.title='number of all content elements';
		param.description='total number of content elements declared for this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-elements", \n  getParam("contentModelKey"),\n  BooleanQuery (! instanceOf ("xs:any"))\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='elementWildcardCount';
		param.title='number of all element wildcards';
		param.description='total number of element wildcards declared for this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-elements", \n  getParam("contentModelKey"),\n  BooleanQuery (instanceOf ("xs:any"))\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownElementCount';
		param.title='number of elements defined in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-elements", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    ! instanceOf ("xs:any") &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:group").id \n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='ownElementWildcardCount';
		param.title='number of element wildcards defined in this component';
		param.type='integer';
		param.default.expr='countElementsByKey (\n  "content-model-elements", \n  getParam("contentModelKey"),\n  BooleanQuery (\n    instanceOf ("xs:any") &&\n    findPredecessorByType("xs:%element|xs:complexType|xs:group").id \n    == rootElement.id\n  )\n)';
		param.hidden='true';
	}
	PARAM={
		param.name='fmt.page.refs';
		param.title='Generate page references';
		param.type='boolean';
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
		param.name='doc.comp.diagram';
		param.title='Content Model Diagram';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep';
		param.title='XML Representation Summary';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.element';
		param.title='Generate For Elements';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.xmlRep.sorting';
		param.title='Sorting';
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
		param.name='doc.comp.simpleContent.default';
		param.title='Default Value';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.simpleContent.fixed';
		param.title='Fixed Value';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.lists';
		param.title='Lists of Related Components';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.lists.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
	}
	PARAM={
		param.name='doc.comp.lists.contentElements';
		param.title='Content Elements';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.lists.containingElements';
		param.title='Containing Elements';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.lists.substitutableElements';
		param.title='Substitutable Elements';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.lists.substitutingElements';
		param.title='Substituting Elements';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.lists.childrenBySubst';
		param.title='Children By Substitutions';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.lists.parentsBySubst';
		param.title='Parents By Substitutions';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage';
		param.title='Usage / Definition Locations';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage.for.element.global';
		param.title='Global Elements';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.usage.for.element.local';
		param.title='Local Elements';
		param.title.style.italic='true';
		param.type='enum';
		param.enum.values='always;multiple;never';
	}
	PARAM={
		param.name='doc.comp.usage.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
		param.default.value='optimal';
	}
	PARAM={
		param.name='doc.comp.annotation';
		param.title='Annotation';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.annotation.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.type';
		param.title='Type Detail';
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
		param.name='doc.comp.type.for.element.type';
		param.title='Elements With Types';
		param.title.style.italic='true';
		param.type='enum';
		param.enum.values='anonymous;any;none';
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
		param.name='doc.comp.attributes';
		param.title='Attribute Detail';
		param.title.style.bold='true';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.attributes.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.attributes.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.contentElements';
		param.title='Content Element Detail';
		param.title.style.bold='true';
		param.grouping='true';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.contentElements.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='show';
		param.title='Show';
		param.title.style.bold='true';
		param.grouping='true';
	}
	PARAM={
		param.name='show.localElementExt';
		param.title='Local Element Extensions';
		param.type='enum';
		param.enum.values='always;repeating;never';
	}
	PARAM={
		param.name='show.about';
		param.title='About (footer)';
		param.type='enum';
		param.enum.values='full;short;none';
	}
</TEMPLATE_PARAMS>
<HTARGET>
	COND='instanceOf("xs:%topLevelElement") || getAttrValue("type") == ""'
	HKEYS={
		'contextElement.id';
		'"detail"';
	}
</HTARGET>
<HTARGET>
	COND='instanceOf("xs:%localElement") && getAttrValue("type") != ""'
	HKEYS={
		'getElementIds (findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey")\n))',array;
		'"detail"';
	}
</HTARGET>
FMT={
	doc.lengthUnits='pt';
	doc.hlink.style.link='cs5';
}
<STYLES>
	CHAR_STYLE={
		style.name='Annotation Smaller';
		style.id='cs1';
		text.font.name='Arial';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Code';
		style.id='cs2';
		text.font.name='Courier New';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Code Smaller';
		style.id='cs3';
		text.font.name='Courier New';
		text.font.size='8';
	}
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs4';
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
		par.margin.top='14';
		par.margin.bottom='10';
		par.padding.left='2';
		par.padding.right='2';
		par.padding.top='2';
		par.padding.bottom='2';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Detail Heading 2';
		style.id='s2';
		text.font.size='10';
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
		par.page.keepWithNext='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs5';
		text.font.style.bold='false';
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
		par.margin.bottom='8';
		par.padding.left='5';
		par.padding.right='5';
		par.padding.top='3';
		par.padding.bottom='3';
		par.page.keepWithNext='true';
	}
	CHAR_STYLE={
		style.name='Name Modifier';
		style.id='cs6';
		text.font.name='Verdana';
		text.font.size='7';
		text.color.foreground='#B2B2B2';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s7';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Note Font';
		style.id='cs7';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='false';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Page Header Font';
		style.id='cs8';
		text.font.name='Arial';
		text.font.style.italic='true';
	}
	CHAR_STYLE={
		style.name='Page Number Small';
		style.id='cs9';
		text.font.name='Courier New';
		text.font.size='8';
	}
	PAR_STYLE={
		style.name='Property Title';
		style.id='s8';
		text.font.size='8';
		text.font.style.bold='true';
		par.lineHeight='11';
		par.margin.right='7';
	}
	PAR_STYLE={
		style.name='Property Value';
		style.id='s9';
		text.font.name='Verdana';
		text.font.size='8';
		par.lineHeight='11';
	}
</STYLES>
<PAGE_HEADER>
	<AREA_SEC>
		FMT={
			text.style='cs8';
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
						TEXT='element'
					</LABEL>
					<DATA_CTRL>
						FORMULA='\'<\' + getParam("xmlName") + \'>\''
					</DATA_CTRL>
					<DATA_CTRL>
						COND='instanceOf("xs:%localElement") &&\n(\n  hasParamValue("show.localElementExt", "always")\n  ||\n  hasParamValue("show.localElementExt", "repeating") &&\n  {\n    schema = findAncestor ("xs:schema");\n\n    qName = QName (\n      ((hasAttr("form") ? getAttrValue("form") :\n          schema.getAttrValue ("elementFormDefault")) == "qualified" \n            ? schema.getAttrStringValue("targetNamespace") : ""),\n      getAttrStringValue("name")\n    );\n\n    countElementsByKey ("global-elements", qName) +\n    countElementsByKey ("local-elements", qName) > 1\n  }\n)'
						FORMULA='callStockSection("localElementExt")'
					</DATA_CTRL>
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
						TEXT='element'
					</LABEL>
					<DATA_CTRL>
						FORMULA='\'<\' + getParam("xmlName") + \'>\''
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<TEMPLATE_CALL>
		DESCR='Element Profile'
		COND='getBooleanParam("doc.comp.profile")'
		TEMPLATE_FILE='elementProfile.tpl'
		ON_OUTPUT_EXPR='thisContext.setVar ("has-profile", true)'
	</TEMPLATE_CALL>
	<FOLDER>
		DESCR='Content Model Representation'
		FMT={
			sec.spacing.before='12';
			sec.spacing.after='12';
		}
		COLLAPSED
		<BODY>
			<TEMPLATE_CALL>
				DESCR='Content Model Diagram'
				COND='getBooleanParam("doc.comp.diagram")'
				<HTARGET>
					COND='output.type == "document"'
					HKEYS={
						'contextElement.id';
						'"content-model-diagram"';
					}
					NAME_EXPR='"content_model_diagram"'
				</HTARGET>
				TEMPLATE_FILE='../content/diagram.tpl'
				ON_OUTPUT_EXPR='thisContext.setVar ("has-content-model-diagram", true)'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				DESCR='XML Representation Summary'
				COND='getBooleanParam("doc.comp.xmlRep") &&\ngetBooleanParam("doc.comp.xmlRep.for.element")'
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
					'sorting','getBooleanParam("doc.comp.xmlRep.sorting")';
					'abbreviateSimpleContent','getBooleanParam("doc.comp.simpleContent") &&\ngetBooleanParam("doc.comp.simpleContent.restrictions")';
				}
				ON_OUTPUT_EXPR='thisContext.setVar ("has-xml-rep-summary", true)'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
	<FOLDER>
		DESCR='Simple Content Detail'
		COND='getBooleanParam("doc.comp.simpleContent") &&\n{\n  et = getParam("elementType").toElement();\n  et != null || et.hasChild("xs:simpleContent")\n}'
		FMT={
			sec.outputStyle='table';
			table.cellpadding.both='0';
			table.border.style='none';
			table.option.borderStylesInHTML='true';
		}
		ON_OUTPUT_EXPR='thisContext.setVar ("has-simple-content-detail", true)'
		COLLAPSED
		<BODY>
			<ELEMENT_ITER>
				DESCR='Iterate By Actual Facets\n--\nThe iterated elements are produced as the following:\n\n1. First, all facet elements that are declared both in the context type and all its ancestor types (global and anonymous) are collected. (This will work, however, until a derivation by list or union is reached.) \n\nWhat\'s important is that how the facets will follow in the result sequence. The facets from the same restriction will appear in the same order as they were declared. The facets from different restrictions will appear according to the remoteness of their parent restrictions from the context type.\n\nThis everything is determined with the Location Rules (and their ordering) specified in "Processing | Iteration Scope" tab.\n\n2. Once the initial sequence is produced, the filtering by key will be applied (see "Processing | Filtering | Filter By Key" tab). The purpose of the filtering is to remove those facets that are overridden in the descendant types.  There are two special cases:\n\n(1) All <xs:enumeration> facets will be removed except the first (valid) one. That will be enough to obtain all valid enumeration facets from the <xs:restriction> parent of the left one. This is done in "facet.tpl" template (called to print a facet value).\n\n(2) All <xs:pattern> facets will be left because they all are valid.\n\nAll those conditions are specified in the "Expression For Unique Key". In the case of <xs:pattern>, the key will be the element ID, which is always unique (therefore, no <xs:pattern> element will be removed.\n\nThe "Preference Condition" expression determines if a given element should replace the already passed element with the same key. That will be so when the expression returns true. We specify to return the value of the facet\'s \'fixed\' attribute. The \'fixed\' attribute overrides anything that might be specified about that facet in the descendant types. (However, actually, doing this is not allowed in XSD!)\n\n3. In the "Processing | Sorting" tab we specify sorting the result facets according to the facet type names. This is done primarily to ensure that all "pattern" facets are printed together.'
				COND='getBooleanParam("doc.comp.simpleContent.restrictions")'
				CONTEXT_ELEMENT_EXPR='getParam("elementType").toElement()'
				MATCHING_ETS={'xs:%complexType';'xs:%simpleType'}
				FMT={
					table.cellpadding.both='0';
					table.border.style='none';
					table.option.borderStylesInHTML='true';
				}
				TARGET_ET='xs:%facet'
				SCOPE='advanced-location-rules'
				RULES={
					'xs:%simpleType -> xs:restriction',recursive;
					'xs:%complexType -> xs:simpleContent/(xs:extension|xs:restriction)',recursive;
					'(xs:restriction|xs:restriction%xs:simpleRestrictionType) -> (xs:%facet|xs:simpleType)',recursive;
					'(xs:extension%xs:simpleExtensionType|xs:restriction|xs:restriction%xs:simpleRestrictionType) -> {baseQName = getAttrQNameValue("base");\n(baseQName != null && ! baseQName.isXSPredefinedType()) ? \n{\n  findElementsByKey (\n    "types",\n    hasServiceAttr ("redefined") ?\n      HashKey (baseQName, getServiceAttr ("redefined")) : baseQName\n  )\n}}::(xs:complexType|xs:simpleType)',recursive;
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
											ctrl.size.width='33.8';
											ctrl.size.height='17.3';
											tcell.align.vert='Top';
											par.style='s8';
										}
										FORMULA='name = contextElement.dsmElement.qName.localName;\nname.charAt(0).toUpperCase() + name.substring(1) + \':\''
									</DATA_CTRL>
									<TEMPLATE_CALL_CTRL>
										FMT={
											ctrl.size.width='465.8';
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
			<AREA_SEC>
				COND='getBooleanParam("doc.comp.simpleContent.default")\n&&\n{\n  defaultValue = getAttrValue("default");\n\n  // When this is a pseudo-global element (identified by\n  // {namespace:name:type}) defined locally at > 1 locations,\n  // check if the value of \'default\' attribute is the same\n  // at all locations.\n\n  instanceOf("xs:%localElement")\n  &&\n  getIntParam("usageCount") > 1\n  &&\n  countElementsByKey (\n    "element-usage",\n    getParam("usageMapKey"),\n    BooleanQuery (\n      getAttrValue("default") == defaultValue\n    )\n  ) != getIntParam("usageCount") ? {\n\n    setVar ("variesByLocation", true);\n    true\n\n  } : {\n\n    defaultValue != null ?\n    {\n      setVar ("variesByLocation", false);\n      true;\n    } : false\n  }\n}'
				FMT={
					trow.align.vert='Top';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								FMT={
									ctrl.size.width='33.8';
									ctrl.size.height='59.3';
									par.style='s8';
								}
								TEXT='Default:'
							</LABEL>
							<PANEL>
								FMT={
									ctrl.size.width='465.8';
									ctrl.size.height='59.3';
									par.style='s9';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<PANEL>
												COND='getBooleanVar ("variesByLocation")'
												FMT={
													ctrl.size.width='122.3';
													ctrl.size.height='38.3';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<LABEL>
																FMT={
																	text.style='cs3';
																}
																TEXT='???'
															</LABEL>
															<LABEL>
																TEXT='(varies by location)'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
											<DATA_CTRL>
												COND='! getBooleanVar ("variesByLocation")'
												FMT={
													text.style='cs3';
												}
												FORMULA='\'"\' + getAttrValue("default") + \'"\''
											</DATA_CTRL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				COND='getBooleanParam("doc.comp.simpleContent.fixed")\n&&\n{\n  fixedValue = getAttrValue("fixed");\n\n  // When this is a pseudo-global element (identified by\n  // {namespace:name:type}) defined locally at > 1 locations,\n  // check if the value of \'fixed\' attribute is the same\n  // at all locations.\n\n  instanceOf("xs:%localElement")\n  &&\n  getIntParam("usageCount") > 1\n  &&\n  countElementsByKey (\n    "element-usage",\n    getParam("usageMapKey"),\n    BooleanQuery (\n      getAttrValue("fixed") == fixedValue\n    )\n  ) != getIntParam("usageCount") ? {\n\n    setVar ("variesByLocation", true);\n    true\n\n  } : {\n\n    fixedValue != null ?\n    {\n      setVar ("variesByLocation", false);\n      true;\n    } : false\n  }\n}'
				FMT={
					trow.align.vert='Top';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								FMT={
									ctrl.size.width='33.8';
									ctrl.size.height='59.3';
									par.style='s8';
								}
								TEXT='Fixed:'
							</LABEL>
							<PANEL>
								FMT={
									ctrl.size.width='465.8';
									ctrl.size.height='59.3';
									par.style='s9';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<PANEL>
												COND='getBooleanVar ("variesByLocation")'
												FMT={
													ctrl.size.width='122.3';
													ctrl.size.height='38.3';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<LABEL>
																FMT={
																	text.style='cs3';
																}
																TEXT='???'
															</LABEL>
															<LABEL>
																TEXT='(varies by location)'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
											<DATA_CTRL>
												COND='! getBooleanVar ("variesByLocation")'
												FMT={
													text.style='cs3';
												}
												FORMULA='\'"\' + getAttrValue("fixed") + \'"\''
											</DATA_CTRL>
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
				COND='(thisContext.checkVar ("has-profile") ||\n thisContext.checkVar ("has-content-model-diagram"))\n&&\n! thisContext.checkVar ("has-xml-rep-summary")'
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
					sec.outputStyle='pars';
					par.style='s3';
				}
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								FMT={
									ctrl.size.width='499.5';
									ctrl.size.height='17.3';
								}
								TEXT='Simple Content Detail:'
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
				DESCR='List of Content Model Elements'
				COND='getBooleanParam("doc.comp.lists.contentElements") &&\ngetIntParam("elementCount") > 0'
				TEMPLATE_FILE='contentElementList.tpl'
				PASSED_PARAMS={
					'caption','"Content model elements"';
				}
			</TEMPLATE_CALL>
			<FOLDER>
				DESCR='List of Containing Elements'
				COND='getBooleanParam("doc.comp.lists.containingElements") &&\n{\n  e = findElementsByKey ("containing-elements", getParam("usageMapKey"));\n\n  e.hasNext() ?\n  {\n    v = e.toVector();\n\n    v.sortVector (\n       @el,\n       FlexQuery (callStockSection (el.toElement(), "XMLName"))\n    );\n\n    thisContext.setVar ("elements", v);\n    true;\n\n  } : false\n}'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and there is no local elements (or local name extensions must be omitted)\n3). there is only one element in the list'
						COND='hasParamValue("doc.comp.lists.layout", "flow")\n||\n(v = thisContext.getVar ("elements").toVector()).size() == 1\n||\nhasParamValue("doc.comp.lists.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByType (\n  "xs:%localElement",\n  BooleanQuery (\n    hasParamValue("show.localElementExt", "always") ||\n    {\n      schema = findAncestor ("xs:schema");\n\n      qName = QName (\n        ((hasAttr("form") ? getAttrValue("form") :\n            schema.getAttrValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : ""),\n        getAttrStringValue("name")\n      );\n\n      countElementsByKey ("global-elements", qName) +\n      countElementsByKey ("local-elements", qName) > 1\n    }\n  ) \n) == null)'
						FMT={
							sec.outputStyle='list';
							sec.indent.block='true';
							list.type='delimited';
						}
						TARGET_ET='xs:%element'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='thisContext.getVar("elements").toEnum()'
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
													text.style='cs9';
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
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
												SS_NAME='Element List Column'
												PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='272.3';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Element List Column'
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
							par.style='s4';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='Included in content model of elements'
									</LABEL>
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
			<FOLDER>
				DESCR='List of elements this element may substitute for'
				COND='getBooleanParam("doc.comp.lists.substitutableElements")\n&&\ngetAttrValue("substitutionGroup") != null &&\n{\n  e = findElementsByKey ("substitution-group-heads", contextElement.id);\n\n  e.hasNext() ? \n  {\n    v = e.toVector();\n\n    v.sortVector (\n       @el,\n       FlexQuery (el.toElement().callStockSection ("XMLName"))\n    );\n\n    thisContext.setVar ("elements", v);\n    true;\n\n  } : false\n}'
				<HTARGET>
					HKEYS={
						'contextElement.id';
						'"substitution-group-heads"';
					}
				</HTARGET>
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
						COND='! hasParamValue("doc.comp.lists.layout", "two_columns")\n||\nthisContext.getVar ("elements").toVector().size() == 1'
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
													text.style='cs9';
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
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
												SS_NAME='Element List Column'
												PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='272.3';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Element List Column'
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
							par.style='s4';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='May substitute for elements'
									</LABEL>
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
			<FOLDER>
				DESCR='List of elements this element may be substituted with'
				COND='getBooleanParam("doc.comp.lists.substitutingElements")\n&&\ninstanceOf("xs:element") &&\n{\n  e = findElementsByKey ("substitution-group-members", contextElement.id);\n\n  e.hasNext() ? \n  {\n    v = e.toVector();\n\n    v.sortVector (\n       @el,\n       FlexQuery (el.toElement().callStockSection ("XMLName"))\n    );\n\n    thisContext.setVar ("elements", v);\n    true;\n\n  } : false\n}'
				<HTARGET>
					HKEYS={
						'contextElement.id';
						'"substitution-group-members"';
					}
				</HTARGET>
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
						COND='! hasParamValue("doc.comp.lists.layout", "two_columns")\n||\nthisContext.getVar ("elements").toVector().size() == 1'
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
													text.style='cs9';
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
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
												SS_NAME='Element List Column'
												PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='272.3';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Element List Column'
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
							par.style='s4';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='May be substituted with elements'
									</LABEL>
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
			<FOLDER>
				DESCR='List of possible children by substitutions'
				COND='getBooleanParam("doc.comp.lists.childrenBySubst") &&\n{\n  e = findElementsByKey ("children-by-substitutions", contextElement.id);\n\n  e.hasNext() ? \n  {\n    v = e.toVector();\n\n    v.sortVector (\n       @el,\n       FlexQuery (el.toElement().callStockSection ("XMLName"))\n    );\n\n    thisContext.setVar ("elements", v);\n    true;\n\n  } : false\n}'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
						COND='! hasParamValue("doc.comp.lists.layout", "two_columns")\n||\nthisContext.getVar ("elements").toVector().size() == 1'
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
													text.style='cs9';
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
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
												SS_NAME='Element List Column'
												PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='272.3';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Element List Column'
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
							par.style='s4';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='May contain elements by substitutions'
									</LABEL>
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
			<FOLDER>
				DESCR='List of possible parents by substitutions'
				COND='getBooleanParam("doc.comp.lists.parentsBySubst")\n&&\ngetAttrValue("substitutionGroup") != null &&\n{\n  e = findElementsByKey ("parents-by-substitutions", contextElement.id);\n\n  e.hasNext() ? \n  {\n    v = e.toVector();\n\n    v.sortVector (\n       @el,\n       FlexQuery (callStockSection (el.toElement(), "XMLName"))\n    );\n\n    thisContext.setVar ("elements", v);\n    true;\n\n  } : false\n}'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and there is no local elements (or local name extensions must be omitted)\n3). there is only one element in the list'
						COND='hasParamValue("doc.comp.lists.layout", "flow")\n||\n(v = thisContext.getVar ("elements").toVector()).size() == 1\n||\nhasParamValue("doc.comp.lists.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByType (\n  "xs:%localElement",\n  BooleanQuery (\n    hasParamValue("show.localElementExt", "always") ||\n    {\n      schema = findAncestor ("xs:schema");\n\n      qName = QName (\n        ((hasAttr("form") ? getAttrValue("form") :\n            schema.getAttrValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : ""),\n        getAttrStringValue("name")\n      );\n\n      countElementsByKey ("global-elements", qName) +\n      countElementsByKey ("local-elements", qName) > 1\n    }\n  ) \n) == null)'
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
													text.style='cs9';
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
						DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
												SS_NAME='Element List Column'
												PARAMS_EXPR='v = thisContext.getVar ("elements").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
											</SS_CALL_CTRL>
											<SS_CALL_CTRL>
												FMT={
													ctrl.size.width='272.3';
													ctrl.size.height='17.3';
													tcell.padding.extra.left='12';
												}
												SS_NAME='Element List Column'
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
							par.style='s4';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='May be included in elements by substitutions'
									</LABEL>
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
		</BODY>
		<HEADER>
			<AREA_SEC>
				COND='thisContext.checkVar ("has-simple-content-detail")\n||\n(thisContext.checkVar ("has-profile") ||\n thisContext.checkVar ("has-content-model-diagram"))\n&&\n! thisContext.checkVar ("has-xml-rep-summary")'
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
	<FOLDER>
		DESCR='Usage / Definition Locations'
		COND='getIntParam("usageCount") > 0\n&&\ngetBooleanParam("doc.comp.usage")'
		COLLAPSED
		<BODY>
			<FOLDER>
				DESCR='case of global element'
				COND='getBooleanParam("doc.comp.usage.for.element.global")'
				MATCHING_ET='xs:element'
				FMT={
					sec.outputStyle='list';
					list.item.margin.top='10';
					list.item.margin.bottom='10';
				}
				<HTARGET>
					HKEYS={
						'contextElement.id';
						'"usage-locations"';
					}
				</HTARGET>
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<FOLDER>
						DESCR='within global complexTypes'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (\n    findPredecessorByType ("xs:%element|xs:complexType").instanceOf ("xs:complexType")\n  )\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (\n       el.toElement().findPredecessorByType("xs:complexType"),\n       "XMLName"\n     ))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
								COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														PASSED_ELEMENT_EXPR='findPredecessorByType("xs:complexType")'
														PASSED_ELEMENT_MATCHING_ET='xs:complexType'
													</SS_CALL_CTRL>
													<PANEL>
														COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='69';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		TEXT='['
																	</LABEL>
																	<LABEL>
																		<DOC_HLINK>
																			HKEYS={
																				'contextElement.id';
																				'Array ("def", "xml-source-location")',array;
																			}
																		</DOC_HLINK>
																		TEXT='ref'
																	</LABEL>
																	<LABEL>
																		TEXT=']'
																	</LABEL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<PANEL>
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='156';
															text.style='cs9';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
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
							</ELEMENT_ITER>
							<FOLDER>
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Usage Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1,\n  getElementTypes ("xs:complexType")\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Usage Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true,\n  getElementTypes ("xs:complexType")\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='Within global complexTypes'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
						DESCR='within anonymous complexTypes of elements'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (findPredecessorByType("xs:%element") != null)\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (\n       el.toElement().findPredecessorByType("xs:%element"),\n       "XMLName"\n     ))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and the list will not contain local elements (or local name extensions must be omitted)\n3). there is only one item in the list'
								COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\n(v = thisContext.getVar ("locations").toVector()).size() == 1\n||\nhasParamValue("doc.comp.usage.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByFilter (\n  BooleanQuery ({\n    el = findPredecessorByType("xs:%element");\n\n    el.instanceOf("xs:%localElement") &&\n    (hasParamValue("show.localElementExt", "always") ||\n    {\n      schema = el.findAncestor ("xs:schema");\n\n      qName = QName (\n        ((hasAttr("form") ? el.getAttrValue("form") :\n            schema.getAttrValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : ""),\n        el.getAttrStringValue("name")\n      );\n\n      countElementsByKey ("global-elements", qName) +\n      countElementsByKey ("local-elements", qName) > 1\n    })\n  }) \n) == null)'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														PASSED_ELEMENT_EXPR='findPredecessorByType("xs:%element")'
														PASSED_ELEMENT_MATCHING_ET='xs:%element'
													</SS_CALL_CTRL>
													<PANEL>
														COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='69';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		TEXT='['
																	</LABEL>
																	<LABEL>
																		<DOC_HLINK>
																			HKEYS={
																				'contextElement.id';
																				'Array ("def", "xml-source-location")',array;
																			}
																		</DOC_HLINK>
																		TEXT='ref'
																	</LABEL>
																	<LABEL>
																		TEXT=']'
																	</LABEL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<PANEL>
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='156';
															text.style='cs9';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
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
							</ELEMENT_ITER>
							<FOLDER>
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Usage Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1,\n  getElementTypes ("xs:%element")\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Usage Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true,\n  getElementTypes ("xs:%element")\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='Within anonymous complexTypes of elements'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
						DESCR='within groups'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (\n    findPredecessorByType("xs:%element|xs:group").instanceOf ("xs:group")\n  )\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (\n       el.toElement().findPredecessorByType("xs:group"),\n       "XMLName"\n     ))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
								COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														PASSED_ELEMENT_EXPR='findPredecessorByType("xs:group")'
														PASSED_ELEMENT_MATCHING_ET='xs:group'
													</SS_CALL_CTRL>
													<PANEL>
														COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='69';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		TEXT='['
																	</LABEL>
																	<LABEL>
																		<DOC_HLINK>
																			HKEYS={
																				'contextElement.id';
																				'Array ("def", "xml-source-location")',array;
																			}
																		</DOC_HLINK>
																		TEXT='ref'
																	</LABEL>
																	<LABEL>
																		TEXT=']'
																	</LABEL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<PANEL>
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='156';
															text.style='cs9';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
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
							</ELEMENT_ITER>
							<FOLDER>
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Usage Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1,\n  getElementTypes ("xs:group")\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Usage Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true,\n  getElementTypes ("xs:group")\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='Within model groups'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
						DESCR='as head element of substitution group affiliations'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (\n    instanceOf ("xs:element") && hasAttr ("substitutionGroup")\n  )\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (el.toElement().callStockSection ("XMLName"))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
								COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("detail", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='154.5';
															text.style='cs9';
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
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Element List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Element List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='As head element of substitution group affiliations'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
										TEXT='Known Usage Locations'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</FOLDER>
			<FOLDER>
				DESCR='case of local element'
				COND='hasParamValue("doc.comp.usage.for.element.local", "always")\n||\nhasParamValue("doc.comp.usage.for.element.local", "multiple")\n&&\ngetIntParam("usageCount") > 1'
				MATCHING_ET='xs:%localElement'
				FMT={
					sec.outputStyle='list';
					list.item.margin.top='10';
					list.item.margin.bottom='10';
				}
				<HTARGET>
					HKEYS={
						'contextElement.id';
						'"def-locations"';
					}
				</HTARGET>
				<BODY>
					<FOLDER>
						DESCR='within global complexTypes'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (\n    findPredecessorByType ("xs:%element|xs:complexType").instanceOf("xs:complexType")\n  )\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (\n       el.toElement().findPredecessorByType("xs:complexType"),\n       "XMLName"\n     ))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
								COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														PASSED_ELEMENT_EXPR='findPredecessorByType("xs:complexType")'
														PASSED_ELEMENT_MATCHING_ET='xs:complexType'
													</SS_CALL_CTRL>
													<PANEL>
														COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='69.8';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		TEXT='['
																	</LABEL>
																	<LABEL>
																		<DOC_HLINK>
																			HKEYS={
																				'contextElement.id';
																				'Array ("def", "xml-source-location")',array;
																			}
																		</DOC_HLINK>
																		TEXT='def'
																	</LABEL>
																	<LABEL>
																		TEXT=']'
																	</LABEL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<PANEL>
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='154.5';
															text.style='cs9';
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
																				'Array ("def", "xml-source-location")',array;
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
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Definition Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1,\n  getElementTypes ("xs:complexType")\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Definition Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true,\n  getElementTypes ("xs:complexType")\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='Within global complexTypes'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
						DESCR='within anonymous complexTypes of elements'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (findPredecessorByType("xs:%element") != null)\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (\n       el.toElement().findPredecessorByType("xs:%element"),\n       "XMLName"\n     ))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='print the list as comma-delimited text flow when either\n1). the list layout is specified to be flow\n2). the layout is specified as \'optimal\' and the list will not contain local elements (or local name extensions must be omitted)\n3). there is only one item in the list'
								COND='hasParamValue("doc.comp.usage.layout", "flow")\n||\n(v = thisContext.getVar ("locations").toVector()).size() == 1\n||\nhasParamValue("doc.comp.usage.layout", "optimal")\n&&\n(hasParamValue("show.localElementExt", "never")\n||\nv.findElementByFilter (\n  BooleanQuery ({\n    el = findPredecessorByType("xs:%element");\n\n    el.instanceOf("xs:%localElement") &&\n    (hasParamValue("show.localElementExt", "always") ||\n    {\n      schema = el.findAncestor ("xs:schema");\n\n      qName = QName (\n        ((hasAttr("form") ? el.getAttrValue("form") :\n            schema.getAttrValue ("elementFormDefault")) == "qualified" \n              ? schema.getAttrStringValue("targetNamespace") : ""),\n        el.getAttrStringValue("name")\n      );\n\n      countElementsByKey ("global-elements", qName) +\n      countElementsByKey ("local-elements", qName) > 1\n    })\n  }) \n) == null)'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														PASSED_ELEMENT_EXPR='findPredecessorByType("xs:%element")'
														PASSED_ELEMENT_MATCHING_ET='xs:%element'
													</SS_CALL_CTRL>
													<PANEL>
														COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='69.8';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		TEXT='['
																	</LABEL>
																	<LABEL>
																		<DOC_HLINK>
																			HKEYS={
																				'contextElement.id';
																				'Array ("def", "xml-source-location")',array;
																			}
																		</DOC_HLINK>
																		TEXT='def'
																	</LABEL>
																	<LABEL>
																		TEXT=']'
																	</LABEL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<PANEL>
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='154.5';
															text.style='cs9';
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
																				'Array ("def", "xml-source-location")',array;
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
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Definition Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1,\n  getElementTypes ("xs:%element")\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Definition Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true,\n  getElementTypes ("xs:%element")\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='Within anonymous complexTypes of elements'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
						DESCR='within groups'
						COND='e = findElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  // filter\n  BooleanQuery (\n    findPredecessorByType("xs:%element|xs:group").instanceOf ("xs:group")\n  )\n);\n\ne.hasNext() ?\n{\n  v = e.toVector();\n\n  v.sortVector (\n     @el,\n     FlexQuery (callStockSection (\n       el.toElement().findPredecessorByType("xs:group"),\n       "XMLName"\n     ))\n  );\n\n  thisContext.setVar ("locations", v);\n  true;\n\n} : false'
						COLLAPSED
						<BODY>
							<ELEMENT_ITER>
								DESCR='if two-column layout was not specified, print the list as comma-delimited text flow'
								COND='! hasParamValue("doc.comp.usage.layout", "two_columns")\n||\nthisContext.getVar ("locations").toVector().size() == 1'
								FMT={
									sec.outputStyle='list';
									txtfl.delimiter.type='text';
									txtfl.delimiter.text=', ';
									list.type='delimited';
								}
								TARGET_ET='xs:%element'
								SCOPE='custom'
								ELEMENT_ENUM_EXPR='thisContext.getVar ("locations").toEnum()'
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
														PASSED_ELEMENT_EXPR='findPredecessorByType("xs:group")'
														PASSED_ELEMENT_MATCHING_ET='xs:group'
													</SS_CALL_CTRL>
													<PANEL>
														COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='69.8';
															txtfl.delimiter.type='none';
														}
														<AREA>
															<CTRL_GROUP>
																<CTRLS>
																	<LABEL>
																		TEXT='['
																	</LABEL>
																	<LABEL>
																		<DOC_HLINK>
																			HKEYS={
																				'contextElement.id';
																				'Array ("def", "xml-source-location")',array;
																			}
																		</DOC_HLINK>
																		TEXT='def'
																	</LABEL>
																	<LABEL>
																		TEXT=']'
																	</LABEL>
																</CTRLS>
															</CTRL_GROUP>
														</AREA>
													</PANEL>
													<PANEL>
														COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
														FMT={
															ctrl.size.width='154.5';
															text.style='cs9';
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
																				'Array ("def", "xml-source-location")',array;
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
								DESCR='otherwise, print everything as two-column list, so it will look more readable'
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
															ctrl.size.width='208.5';
															ctrl.size.height='17.3';
														}
														SS_NAME='Definition Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\nN = v.size();\n\nArray (\n  v.subVector (0, (N + 1) / 2),\n  N == 1,\n  getElementTypes ("xs:group")\n)'
													</SS_CALL_CTRL>
													<SS_CALL_CTRL>
														FMT={
															ctrl.size.width='273';
															ctrl.size.height='17.3';
															tcell.padding.extra.left='12';
														}
														SS_NAME='Definition Location List Column'
														PARAMS_EXPR='v = thisContext.getVar ("locations").toVector();\n\nArray (\n  v.subVector ((v.size() + 1) / 2),\n  true,\n  getElementTypes ("xs:group")\n)'
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
									par.style='s5';
								}
								<HTARGET>
									HKEYS={
										'contextElement.id';
										'"usage-locations"';
									}
								</HTARGET>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='Within model groups'
											</LABEL>
											<DATA_CTRL>
												FORMULA='"(" + thisContext.getVar ("locations").toVector().size() + ")"'
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
										TEXT='Definition Locations'
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
		DESCR='Annotation'
		COND='getBooleanParam("doc.comp.annotation") &&\ngetBooleanParam("doc.comp.annotation.for.element")'
		COLLAPSED
		<BODY>
			<FOLDER>
				DESCR='case of global element or local element defined in the only location\n-\nprint the only annotation'
				COND='instanceOf("xs:element") || getIntParam("usageCount") == 1'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<SS_CALL>
						SS_NAME='annotation'
					</SS_CALL>
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
			<ELEMENT_ITER>
				DESCR='case of "quasi-global" local element defined at multiple locations\n--\nprint all annotations by definition locations'
				OUTPUT_CHECKER_EXPR='checkElementsByKey (\n  "element-usage",\n  getParam("usageMapKey"),\n  BooleanQuery (checkStockSectionOutput ("annotation"))\n) ? 1 : -1'
				FINISH_EXPR='removeElementMap ("local-annotations")'
				TARGET_ET='#CUSTOM'
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='prepareElementMap (\n  "local-annotations",\n  findElementsByKey ("element-usage", getParam("usageMapKey")),\n  FlexQuery ({\n    ann = callStockSection ("annotation");\n    (ann != "") ? ann : null\n  })\n);\n\nCustomElements (getElementMapKeys ("local-annotations"))'
				COLLAPSED
				<BODY>
					<ELEMENT_ITER>
						DESCR='iterate by all locations with the same (current) annotation'
						OUTPUT_CHECKER_EXPR='1 // the output always exists'
						FMT={
							sec.outputStyle='list';
							list.type='delimited';
							list.margin.block='true';
						}
						TARGET_ET='xs:%element'
						SCOPE='custom'
						ELEMENT_ENUM_EXPR='findElementsByKey ("local-annotations", contextElement.value)'
						<BODY>
							<AREA_SEC>
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='within'
											</LABEL>
											<PANEL>
												CONTEXT_ELEMENT_EXPR='findPredecessorByType("xs:%element|xs:complexType|xs:group")'
												MATCHING_ETS={'xs:%element';'xs:complexType';'xs:group'}
												FMT={
													ctrl.size.width='269.3';
													ctrl.size.height='38.3';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<SS_CALL_CTRL>
																FMT={
																	text.style='cs2';
																}
																SS_NAME='XMLName'
															</SS_CALL_CTRL>
															<LABEL>
																MATCHING_ET='xs:%element'
																TEXT='element'
															</LABEL>
															<LABEL>
																MATCHING_ET='xs:complexType'
																TEXT='complexType'
															</LABEL>
															<LABEL>
																MATCHING_ET='xs:group'
																TEXT='group'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
											<PANEL>
												COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
												FMT={
													ctrl.size.width='69';
													txtfl.delimiter.type='none';
												}
												<AREA>
													<CTRL_GROUP>
														<CTRLS>
															<LABEL>
																TEXT='['
															</LABEL>
															<LABEL>
																<DOC_HLINK>
																	HKEYS={
																		'contextElement.id';
																		'Array ("def", "xml-source-location")',array;
																	}
																</DOC_HLINK>
																TEXT='def'
															</LABEL>
															<LABEL>
																TEXT=']'
															</LABEL>
														</CTRLS>
													</CTRL_GROUP>
												</AREA>
											</PANEL>
											<PANEL>
												COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
												FMT={
													ctrl.size.width='156.8';
													text.style='cs9';
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
																		'Array ("def", "xml-source-location")',array;
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
						<HEADER>
							<AREA_SEC>
								FMT={
									text.font.style.bold='true';
									par.margin.top='8';
									par.margin.bottom='8';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												COND='iterator.numItems == 1'
												FMT={
													text.font.style.bold='true';
												}
												TEXT='Location:'
											</LABEL>
											<LABEL>
												COND='iterator.numItems > 1'
												FMT={
													text.font.style.bold='true';
												}
												TEXT='Locations:'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</AREA_SEC>
						</HEADER>
					</ELEMENT_ITER>
					<AREA_SEC>
						FMT={
							text.font.style.bold='true';
							par.margin.top='8';
							par.margin.bottom='8';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										FMT={
											text.font.style.bold='true';
										}
										TEXT='Annotation:'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<SS_CALL>
						FMT={
							sec.indent.block='true';
						}
						SS_NAME='annotation'
						PASSED_ELEMENT_EXPR='findElementByKey ("local-annotations", contextElement.value)'
						PASSED_ELEMENT_MATCHING_ET='xs:%element'
					</SS_CALL>
					<AREA_SEC>
						COND='! iterator.isLastItem'
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
										TEXT='Annotations'
									</LABEL>
									<DATA_CTRL>
										FORMULA='"(" + iterator.numItems + ")"'
									</DATA_CTRL>
									<DELIMITER>
										FMT={
											text.style='cs3';
										}
									</DELIMITER>
									<LABEL>
										FMT={
											text.style='cs7';
										}
										TEXT='(by all definition locations)'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</HEADER>
			</ELEMENT_ITER>
		</BODY>
	</FOLDER>
	<FOLDER>
		DESCR='TYPE DETAIL'
		COND='getBooleanParam("doc.comp.type")\n&& (\n hasParamValue("doc.comp.type.for.element.type", "anonymous") &&\n getParam("elementTypeQName") == null\n ||\n hasParamValue("doc.comp.type.for.element.type", "any")\n)'
		CONTEXT_ELEMENT_EXPR='getParam("elementType").toElement()'
		MATCHING_ETS={'xs:%complexType';'xs:%simpleType'}
		<HTARGET>
			COND='instanceOf("xs:%localSimpleType | xs:%localComplexType")'
			HKEYS={
				'contextElement.id';
				'"detail"';
			}
			NAME_EXPR='output.type == "document" ? "type_detail" : ""'
		</HTARGET>
		<HTARGET>
			COND='instanceOf("xs:simpleType | xs:complexType")'
			HKEYS={
				'contextElement.id';
				'"local"';
				'rootElement.id';
			}
			NAME_EXPR='output.type == "document" ? "type_detail" : ""'
		</HTARGET>
		COLLAPSED
		<BODY>
			<AREA_SEC>
				COND='getBooleanParam("doc.comp.type.deriv.tree")\n&&\n(instanceOf ("xs:%simpleType") ||\n getValueByLPath (\n   "(xs:simpleContent | xs:complexContent) / (xs:extension | xs:restriction)/@base"\n ) != null)'
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
								TEMPLATE_FILE='../type/typeDerivationTree.tpl'
								PASSED_PARAMS={
									'detail_link','instanceOf("xs:simpleType | xs:complexType")';
									'xml_source_link','instanceOf("xs:simpleType | xs:complexType") ||\n! getBooleanParam("doc.comp.xml")';
								}
							</TEMPLATE_CALL_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<TEMPLATE_CALL>
				COND='getBooleanParam("doc.comp.type.annotation")'
				TEMPLATE_FILE='../ann/annotation.tpl'
				PASSED_PARAMS={
					'showHeading','true';
				}
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				DESCR='in case this type has a simple content, print details about its definition'
				COND='! hasParamValue("doc.comp.type.deriv.simpleContent", "none")'
				FMT={
					sec.spacing.before='8';
				}
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
				COND='// see "Context Element" tab'
				MATCHING_ETS={'xs:%localComplexType';'xs:%localSimpleType'}
				FMT={
					par.style='s1';
				}
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						FMT={
							trow.bkgr.color='#CCCCFF';
						}
						<CTRLS>
							<LABEL>
								TEXT='Anonymous Type Detail'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
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
							<DATA_CTRL>
								FORMULA='\'"\' + getParam("elementTypeQName") + \'"\''
							</DATA_CTRL>
							<LABEL>
								MATCHING_ET='xs:simpleType'
								TEXT='simpleType'
							</LABEL>
							<LABEL>
								MATCHING_ET='xs:complexType'
								TEXT='complexType'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</HEADER>
	</FOLDER>
	<FOLDER>
		DESCR='XML SOURCE -- only for a top-level element or a local element defined in single location'
		COND='getBooleanParam("doc.comp.xml")\n&&\n(instanceOf("xs:element") || getIntParam("usageCount") == 1)'
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
								FMT={
									text.style='cs2';
								}
							</DELIMITER>
							<TEMPLATE_CALL_CTRL>
								FMT={
									text.style='cs7';
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
		DESCR='ATTRIBUTE DETAIL'
		COND='getBooleanParam("doc.comp.attributes") &&\ngetBooleanParam("doc.comp.attributes.for.element")'
		TEMPLATE_FILE='../attribute/attributes.tpl'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		DESCR='CONTENT ELEMENT DETAIL'
		COND='getBooleanParam("doc.comp.contentElements") &&\ngetBooleanParam("doc.comp.contentElements.for.element")'
		TEMPLATE_FILE='contentElements.tpl'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		DESCR='Bottom Message'
		COND='output.type == "document" &&\n! hasParamValue("show.about", "none")'
		TEMPLATE_FILE='../about.tpl'
	</TEMPLATE_CALL>
</ROOT>
<STOCK_SECTIONS>
	<FOLDER>
		SS_NAME='annotation'
		<BODY>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='../ann/annotation.tpl'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
	<ELEMENT_ITER>
		DESCR='params[0]: vector of defining element components; \nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item);\nparams[2]: the Element Types (array) matching the component containing the location'
		FMT={
			sec.outputStyle='pars';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='xs:%element'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
		SS_NAME='Definition Location List Column'
		<BODY>
			<AREA_SEC>
				FMT={
					txtfl.delimiter.type='none';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='nbsp';
						}
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME='XMLName'
								PASSED_ELEMENT_EXPR='findPredecessorByType (getElementTypes (stockSection.params[2]))'
								PASSED_ELEMENT_MATCHING_ET='<ANY>'
							</SS_CALL_CTRL>
							<PANEL>
								COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
								FMT={
									ctrl.size.width='69.8';
									txtfl.delimiter.type='none';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='['
											</LABEL>
											<LABEL>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'Array ("def", "xml-source-location")',array;
													}
												</DOC_HLINK>
												TEXT='def'
											</LABEL>
											<LABEL>
												TEXT=']'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
								FMT={
									ctrl.size.width='154.5';
									text.style='cs9';
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
														'Array ("def", "xml-source-location")',array;
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
									txtfl.delimiter.type='none';
								}
							</DELIMITER>
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
	<ELEMENT_ITER>
		DESCR='params[0]: vector of column elements; \nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item)'
		FMT={
			sec.outputStyle='pars';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='xs:%element'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
		SS_NAME='Element List Column'
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
													text.style='cs9';
												}
												TEXT='['
											</LABEL>
											<DATA_CTRL>
												FMT={
													ctrl.option.noHLinkFmt='true';
													text.style='cs9';
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
													text.style='cs9';
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
	<FOLDER>
		MATCHING_ET='xs:%localElement'
		SS_NAME='localElementExt'
		<BODY>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='localElementExt.tpl'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
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
							text.style='cs6';
						}
						FORMULA='redef_no = getServiceAttr ("redefinition").toInt();\n\n" (redef" + (redef_no > 0 ? redef_no : "") + ")"'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<ELEMENT_ITER>
		DESCR='params[0]: vector of element reference components; \nparams[1]: true if this is the last part of the whole list (to avoid printing comma after last item);\nparams[2]: the Element Types (array) matching the component containing the location'
		FMT={
			sec.outputStyle='pars';
			par.option.nowrap='true';
			list.style.type='none';
		}
		TARGET_ET='xs:%element'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='toEnum (stockSection.param)'
		SS_NAME='Usage Location List Column'
		<BODY>
			<AREA_SEC>
				FMT={
					txtfl.delimiter.type='none';
				}
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='nbsp';
						}
						<CTRLS>
							<SS_CALL_CTRL>
								SS_NAME='XMLName'
								PASSED_ELEMENT_EXPR='findPredecessorByType (getElementTypes (stockSection.params[2]))'
								PASSED_ELEMENT_MATCHING_ET='<ANY>'
							</SS_CALL_CTRL>
							<PANEL>
								COND='! output.format.supportsPagination\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
								FMT={
									ctrl.size.width='69';
									txtfl.delimiter.type='none';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
											<LABEL>
												TEXT='['
											</LABEL>
											<LABEL>
												<DOC_HLINK>
													HKEYS={
														'contextElement.id';
														'Array ("def", "xml-source-location")',array;
													}
												</DOC_HLINK>
												TEXT='ref'
											</LABEL>
											<LABEL>
												TEXT=']'
											</LABEL>
										</CTRLS>
									</CTRL_GROUP>
								</AREA>
							</PANEL>
							<PANEL>
								COND='output.format.supportsPageRefs\n&&\ngetBooleanParam("fmt.page.refs")\n&&\nhyperTargetExists (ArgumentList (\n  contextElement.id,\n  Array ("def", "xml-source-location")\n))'
								FMT={
									ctrl.size.width='156';
									text.style='cs9';
									txtfl.delimiter.type='none';
								}
								<AREA>
									<CTRL_GROUP>
										<CTRLS>
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
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='none';
								}
							</DELIMITER>
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
									HKEYS={
										'contextElement.id';
										'Array ("detail", "xml-source-location")',array;
									}
								</DOC_HLINK>
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name"),\n  rootElement\n)'
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
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name"),\n  rootElement\n)'
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
							<SS_CALL_CTRL>
								COND='instanceOf("xs:%localElement") &&\n(\n  hasParamValue("show.localElementExt", "always")\n  ||\n  hasParamValue("show.localElementExt", "repeating") &&\n  {\n    schema = findAncestor ("xs:schema");\n\n    qName = QName (\n      ((hasAttr("form") ? getAttrValue("form") :\n          schema.getAttrValue ("elementFormDefault")) == "qualified" \n            ? schema.getAttrStringValue("targetNamespace") : ""),\n      getAttrStringValue("name")\n    );\n\n    countElementsByKey ("global-elements", qName) +\n    countElementsByKey ("local-elements", qName) > 1\n  }\n)'
								SS_NAME='localElementExt'
							</SS_CALL_CTRL>
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
								FORMULA='toXMLName (\n  findAncestor ("xs:schema").getAttrStringValue("targetNamespace"),\n  getAttrStringValue("name"),\n  rootElement\n)'
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
CHECKSUM='OL7pLfEpnR7joQ6nHAeTyu49MNnKVw0?gCViN6j3RA8'
</DOCFLEX_TEMPLATE>