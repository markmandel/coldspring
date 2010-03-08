<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-10-17 11:23:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='xmldoc'
ROOT_ET='<ANY>'
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
	<AREA_SEC>
		FMT={
			text.font.name='Verdana';
			text.font.size='7';
			text.color.foreground='#808080';
		}
		<AREA>
			<CTRL_GROUP>
				FMT={
					par.border.top.style='solid';
					par.border.top.color='#808080';
					par.margin.top='24';
					par.margin.bottom='6';
					par.padding.top='2';
				}
				<CTRLS>
					<LABEL>
						TEXT='XML File documentation generated with'
					</LABEL>
					<DATA_CTRL>
						<URL_HLINK>
							COND='output.generator.name == "DocFlex/XML RE"'
							TARGET_FRAME_EXPR='"_blank"'
							TARGET_FRAME_ALWAYS
							URL_EXPR='"http://www.filigris.com/products/docflex_xml/#docflex-xml-re"'
						</URL_HLINK>
						<URL_HLINK>
							COND='output.generator.name == "DocFlex/XML SDK"'
							TARGET_FRAME_EXPR='"_blank"'
							TARGET_FRAME_ALWAYS
							URL_EXPR='"http://www.filigris.com/products/docflex_xml/#docflex-xml-sdk"'
						</URL_HLINK>
						<URL_HLINK>
							TARGET_FRAME_EXPR='"_blank"'
							TARGET_FRAME_ALWAYS
							URL_EXPR='"http://www.filigris.com/products/docflex_xml/"'
						</URL_HLINK>
						FORMULA='output.generator.name'
					</DATA_CTRL>
					<LABEL>
						TEXT='v'
					</LABEL>
					<DELIMITER>
						FMT={
							txtfl.delimiter.type='none';
						}
					</DELIMITER>
					<DATA_CTRL>
						FORMULA='output.generator.version'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
			<CTRL_GROUP>
				<CTRLS>
					<LABEL>
						COND='output.generator.name == "DocFlex/XML SDK"'
						<URL_HLINK>
							TARGET_FRAME_EXPR='"_blank"'
							TARGET_FRAME_ALWAYS
							URL_EXPR='"http://www.filigris.com/products/docflex_xml/"'
						</URL_HLINK>
						TEXT='DocFlex/XML'
					</LABEL>
					<PANEL>
						COND='output.generator.name == "DocFlex/XML RE"'
						FMT={
							ctrl.size.width='243';
							ctrl.size.height='38.3';
						}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<DATA_CTRL>
										<URL_HLINK>
											COND='output.generator.name == "DocFlex/XML RE"'
											TARGET_FRAME_EXPR='"_blank"'
											TARGET_FRAME_ALWAYS
											URL_EXPR='"http://www.filigris.com/products/docflex_xml/#docflex-xml-re"'
										</URL_HLINK>
										<URL_HLINK>
											TARGET_FRAME_EXPR='"_blank"'
											TARGET_FRAME_ALWAYS
											URL_EXPR='"http://www.filigris.com/products/docflex_xml/"'
										</URL_HLINK>
										FORMULA='output.generator.name'
									</DATA_CTRL>
									<LABEL>
										TEXT='is a reduced editon of'
									</LABEL>
									<LABEL>
										<URL_HLINK>
											TARGET_FRAME_EXPR='"_blank"'
											TARGET_FRAME_ALWAYS
											URL_EXPR='"http://www.filigris.com/products/docflex_xml/"'
										</URL_HLINK>
										TEXT='DocFlex/XML'
									</LABEL>
									<DELIMITER>
										FMT={
											txtfl.delimiter.type='text';
											txtfl.delimiter.text=', ';
										}
									</DELIMITER>
									<LABEL>
										TEXT='which'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</PANEL>
					<LABEL>
						TEXT='is a powerful template-driven documentation and report generator from any data stored in XML files.'
					</LABEL>
					<LABEL>
						TEXT='Based on an innovative technology developed by'
					</LABEL>
					<LABEL>
						<URL_HLINK>
							TARGET_FRAME_EXPR='"_blank"'
							TARGET_FRAME_ALWAYS
							URL_EXPR='"http://www.filigris.com"'
						</URL_HLINK>
						TEXT='FILIGRIS WORKS'
					</LABEL>
					<DELIMITER>
						FMT={
							txtfl.delimiter.type='text';
							txtfl.delimiter.text=', ';
						}
					</DELIMITER>
					<LABEL>
						TEXT='this new tool offers capabilities not found in anything else!'
					</LABEL>
					<LABEL>
						TEXT='Find out more at'
					</LABEL>
					<LABEL>
						<URL_HLINK>
							TARGET_FRAME_EXPR='"_blank"'
							TARGET_FRAME_ALWAYS
							URL_EXPR='"http://www.filigris.com"'
						</URL_HLINK>
						TEXT='www.filigris.com'
					</LABEL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</ROOT>
CHECKSUM='9XJbDVbRoSRLez8OQSowTnTZWM9rdN7sGUq5uoh?b8w'
</DOCFLEX_TEMPLATE>