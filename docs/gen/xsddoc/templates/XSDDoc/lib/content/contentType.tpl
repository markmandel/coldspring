<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-04-26 03:31:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ETS={'xs:%complexType';'xs:%element';'xs:%simpleType'}
DESCR='NOTE: when the passed root element is an element component, it must be the element declaration (not a reference to it).'
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
		text.font.style.bold='false';
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
		CONTEXT_ELEMENT_EXPR='instanceOf ("xs:%element") \n ? findElementByKey ("element-types", contextElement.id)\n : contextElement;'
		MATCHING_ETS={'#CUSTOM';'xs:%complexType';'xs:%simpleType'}
		<BODY>
			<FOLDER>
				MATCHING_ET='xs:%complexType'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						COND='/* According to W3C spec, the mixed content is determined by boolean value:\n1. If the mixed attribute is present on <complexContent>, then its actual value;\n2. If the mixed attribute is present on <complexType>, then its actual value;\n3. otherwise false.\n*/\n\n((el = findChild("xs:complexContent")) != null && el.hasAttr ("mixed")) ?\n  el.getAttrBooleanValue("mixed") : getAttrBooleanValue("mixed")'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='mixed'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						COND='// check if there are any content elements\n\ncheckElementsByKey ("content-model-elements", contextElement.id)'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='complex'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						COND='hasChild("xs:simpleContent") && ! rootElement.hasAttrValue("fixed", "")'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='simple'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='empty'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<FOLDER>
				MATCHING_ET='xs:%simpleType'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						COND='! rootElement.hasAttrValue("fixed", "")'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='simple'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='empty'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<AREA_SEC>
				MATCHING_ET='#CUSTOM'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<DATA_CTRL>
								FORMULA='typeQName = contextElement.value.toQName();\n\nisXSPredefinedType (typeQName)\n ? typeQName.localName == "anyType" ? "any" : \n     rootElement.hasAttrValue("fixed", "") ? "empty" : "simple"\n : "unknown"'
							</DATA_CTRL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
</ROOT>
CHECKSUM='F4OAO7ySmhClgzOe3nJ8G4EEr1N7AQQp71hOYEyEZdg'
</DOCFLEX_TEMPLATE>