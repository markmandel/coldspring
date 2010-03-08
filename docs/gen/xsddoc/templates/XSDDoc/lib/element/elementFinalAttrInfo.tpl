<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2008-11-17 02:44:26'
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
DESCR='Documents \'final\' attribute of a global element component'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='finalAttrValues';
		param.title='The actual values of \'final\' attribute';
		param.type='string';
		param.list='true';
		param.default.expr='hasAttr ("final") ? getAttrValues ("final") :\n  findAncestor("xs:schema").getAttrValues ("finalDefault")';
	}
	PARAM={
		param.name='profile.final.value';
		param.title='Value';
		param.type='boolean';
	}
	PARAM={
		param.name='profile.final.meaning';
		param.title='Meaning';
		param.type='boolean';
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
	CHAR_STYLE={
		style.name='Property Note';
		style.id='cs4';
		text.font.name='Tahoma';
		text.font.size='8';
		text.font.style.italic='true';
	}
</STYLES>
<ROOT>
	<AREA_SEC>
		COND='getBooleanParam("profile.final.value")'
		FMT={
			text.style='cs1';
			txtfl.delimiter.type='none';
		}
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						TEXT='"'
					</LABEL>
					<DATA_CTRL>
						FMT={
							txtfl.delimiter.text=' ';
						}
						FORMULA='getArrayParam("finalAttrValues")'
					</DATA_CTRL>
					<LABEL>
						TEXT='"'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<FOLDER>
		DESCR='meaning'
		COND='getBooleanParam("profile.final.meaning")'
		FMT={
			text.style='cs4';
		}
		<BODY>
			<AREA_SEC>
				DESCR='#all'
				COND='getArrayParam("finalAttrValues").contains ("#all")'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='(cannot be used as the head of a substitution group)'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
			<AREA_SEC>
				DESCR='extension, restriction'
				COND='values = getArrayParam("finalAttrValues");\n\nderivations = Vector();\n\nvalues.contains ("extension") ?\n  derivations.addElement ("extension");\n\nvalues.contains ("restriction") ?\n  derivations.addElement ("restriction");\n\nderivations.size() > 0 ? \n{\n  setVar ("blocked_derivations", derivations);\n  true\n} : false'
				<AREA>
					<CTRL_GROUP>
						<CTRLS>
							<LABEL>
								TEXT='(cannot be used as the head of a substitution group for elements whose types are derived by'
							</LABEL>
							<DATA_CTRL>
								FORMULA='mergeStrings (\n  getVar ("blocked_derivations").toVector(),\n  ", ", " or "\n)'
							</DATA_CTRL>
							<LABEL>
								TEXT='from the type of this element)'
							</LABEL>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</FOLDER>
</ROOT>
CHECKSUM='am41QVWBUM3nfHLoHECL1fubPN6LiZOUAjHev?yu0hM'
</DOCFLEX_TEMPLATE>