<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-03-04 07:50:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='FramesetTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ET='#DOCUMENTS'
DESCR='This template generates multi-file framed hypertext documentation for any number of XML Schemas.\n<p>\n<b>Note:</b> The destination output format may be only HTML.'
INIT_EXPR='callStockSection("Init");\n\nsetXMLNameForm (\n  getBooleanParam("show.nsPrefix") ? "qualified" : "unqualified"\n);'
FINISH_EXPR='callStockSection("Finish")'
TITLE_EXPR='getStringParam("docTitle")'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='docTitle';
		param.title='Documentation Title';
		param.description='Specifies the title to be placed at the top of the documentation overview.';
		param.type='string';
		param.trimSpaces='true';
		param.noEmptyString='true';
		param.default.value='XML Schema Documentation';
	}
	PARAM={
		param.name='gen.doc';
		param.title='Generate Details';
		param.title.style.bold='true';
		param.description='This group of parameters controls the overall content of the generated XML schema documentation.\n<p>\nThe XML schema documentation generated with <i>"XSDDoc"</i> template set is built of big independent <b><i>documentation blocks</i></b> (or documents).\n<p>\nIn framed HTML documentation, each of those blocks becomes a separate HTML file (or page), which is displayed in the <i>"details"</i> frame.\n<p>\nIn single-file (HTML or RTF) documentation, the blocks become separate sections that follow one after another. In RTF each of those sections also has its own page header/footer.\n<p>\nThere are following types of documentation blocks:\n<ul>\n<li><b><i>Overview Summary</i></b>: This block is generated only once for the whole documentation.</li>\n<li><b><i>All Component Summary</i></b>: This block (also generated only once) contains summaries of all schema components of the specified types throughout all schemas being documented.</li>\n<li><b><i>Namespace Overview</i></b>: This block is generated for every namespace being documented.</li>\n<li><b><i>Schema Overview</i></b>: This is generated for every XML schema.</li>\n<li><b><i>Component Documentation</i></b>: This is the most sophisticated type of blocks that can be generated for all types of global components as well as all local elements.</i>\n<li><b><i>XML Namespace Bindings</i></b>: A special report, which can be generated only once.</li>\n</ul>\n\nUsing parameters in this group, you can specify which of those blocks must be generated and for which XML schema components (e.g. <i>Component Documentation</i> blocks).\n<p>\nWhat exactly is included in particular those blocks should be specified in the <b><i>"Details"</i></b> parameter group.';
		param.grouping='true';
	}
	PARAM={
		param.name='gen.doc.for.schemas';
		param.title='For Schemas';
		param.title.style.italic='true';
		param.description='This group of parameters controls which XML schemas (and their components) should be documented.\n<p>\nThe XML schema files you initially specify on the command line (or in the generator dialog) are the primary XML files to be processed by the XSDDoc template set.\n<p>\nHowever, those initial XML schemas may call from themselves some other XML schema files (via the <code>&lt;xs:import&gt;</code>, <code>&lt;xs:include&gt;</code> and <code>&lt;xs:redefine&gt;</code> elements) and they, in turn, yet more extra schemas. All those extra XML schema files plus the schemas specified initially will constitute the whole your XML schema project. Generally, all of them must be loaded and processed in order to make sense of your initial XML schemas (that is to interpret and document them).\nSome of such imported extra XML schemas may be the standard ones used in other your projects (in addition, they may be rather big).\n<p>\nSo, the question arises: Which of the XML schemas involved in your project do you actually need to document?\nThese parameters allow you to specify it.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='gen.doc.for.schemas.initial';
		param.title='Initial';
		param.title.style.italic='true';
		param.description='Specify whether to document the XML schema files initially specified on the generator command line (or in the generator dialog).\n<p>\nYou may unselect this parameter, when you want to document only the imported or redefined XML schemas, but not the primary ones. (This may be odd, however we provide such functionality for completeness.)';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.for.schemas.imported';
		param.title='Imported';
		param.title.style.italic='true';
		param.description='Specify whether to document all additional XML schema files loaded by <b><code>&lt;xs:import&gt;</code></b> elements.\n<p>\n<b>Note:</b> When an XML schema is both specified initially on the command line and referred from an <code>&lt;xs:import&gt;</code> element, it is loaded only once as the <i>initial</i> XML schema, however, it will be marked as the <i>imported</i> schema too.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.for.schemas.included';
		param.title='Included';
		param.title.style.italic='true';
		param.description='Specify whether to document all additional XML schema files loaded by <b><code>&lt;xs:include&gt;</code></b> elements.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.for.schemas.redefined';
		param.title='Redefined';
		param.title.style.italic='true';
		param.description='Specify whether to document all additional XML schema files loaded by <b><code>&lt;xs:redefine&gt;</code></b> elements.\n<p>\nEach XML schema specified in such an element is loaded into memory and then altered so that every component being redefined within the <code>&lt;xs:redefine&gt;</code> element is renamed within the loaded schema by adding the suffix <b><code>\'$ORIGINAL\'</code></b> to the component\'s name. All references to the original components within the <code>&lt;xs:redefine&gt;</code> element are also renamed. Further, the schema is processed the same way as in the case of <code>&lt;xs:include&gt;</code> element.\nThis makes possible not only to interpret and document all the new semantics of the redefined components but also to preserve and document the original components.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.overview';
		param.title='Overview Summary';
		param.description='Specifies whether to generate the <b><i>Overview Summary</i></b> documentation block.\n<p>\nThe <i>Overview Summary</i> may be generated only once for the entire XML schema documentation. It appears the first in the <i>details</i> frame of framed HTML documentation (when it is started) or on the first page of single-file documentation (RTF).\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Overview Summary"</i> parameter group, which controls the exact content of the <i>Overview Summary</i> block.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.allcomps';
		param.title='All Component Summary';
		param.description='Specifies whether to generate the <b><i>All Component Summary</i></b> page/block.\n<p>\nThis block may be generated only once for the entire XML schema documentation. It contains summaries of all schema components of the specified types throughout all schemas being documented.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | All Component Summary"</i> parameter group that controls the exact content of <i>All Component Summary</i> block.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.namespace';
		param.title='Namespace Overviews';
		param.description='Specifies whether to generate the <b><i>Namespace Overview</i></b> pages/blocks.\n<p>\nWhen specified, the <i>Namespace Overview</i> will be generated for each namespace being documented (i.e. targeted by at least one of the documented XML schemas).\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Namespace Overview"</i> parameter group, which controls the exact content of each <i>Namespace Overview</i> document/block.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.schema';
		param.title='Schema Overviews';
		param.description='Specifies whether to generate the <b><i>Schema Overview</i></b> pages/blocks.\n<p>\nWhen specified, the <i>Schema Overview</i> will be generated for each XML schema being documented.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Schema Overview"</i> parameter group that controls the exact content of each <i>Schema Overview</i> document/block.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.element';
		param.title='Elements';
		param.description='Specifies whether to generate the detailed <b><i>Element Documentation</i></b> for each <i>global</i> element component and some of the <i>local</i> element components (that are defined in all XML schemas being documented).\n\n<p>\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecify which of the <i>local</i> element components must be documented.\n</dd></dl>\n\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, where you can specify precisely what is included in the <i>Element Documentation</i>.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.element.local';
		param.title='Local Elements';
		param.description='Specifies whether to generate the detailed <b><i>Element Documentation</i></b> for <i>local elements</i> (i.e. locally defined element components; see also below).\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"all"</i>\n<dl><dd>\nDocument all local elements the same way as global ones (see <i>"How Local Elements are documented | Global Documenting"</i> below).\n</dd></dl>\n\n<i>"with complex type only"</i>\n<dl><dd>\nGenerate the detailed <i>Element Documentation</i> only for local elements with complex types.\n<p></p>\n<b>Note:</b> Certain XML schema design patterns avoid using global element components almost entirely. Instead, they define a single global element component that describes the root element of a possible XML document. Any other elements, which may be contained in that XML document, are defined using only global types and local element components. What is more, frequently, those XML schemas also avoid defining element attributes. Instead, to store in an XML document the elementary data normally supposed for attributes, they define lots of local elements with primitive simple types. As a result, such an XML schema contains great a lot of insignificant local element components. When all of them are documented separately (and appear in main element component lists) they may overwhelm anything else. This parameter value allows you to avoid exactly such a mess and properly document your XML schemas written according to that pattern!\n</dd></dl>\n\n<i>"none"</i>\n<dl><dd>\nDo not generate the <i>Element Documentation</i> for local elements.\n</dd></dl>\n\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, which controls the exact content of the <i>Element Documentation</i>.\n</blockquote>\n\n<h2>About Local Elements</h2>\n\n<b><i>Local Elements</i></b> are those element components that are defined locally within:\n<ul>\n<li>complex types (either global ones or defined anonymously within other elements)</li>\n<li>element groups (which are separate schema components that define whole bunches of elements arranged in specific complex models).</li>\n</ul>\nLocal elements represent a challenge for documenting. This is because since their introduction in W3C XML Schema language, there is no strict relationship any longer between an element name and its type for the entire scope of the XML document. Now, within the same XML document, you may find several different XML elements that share the same name, however, actually represent more or less different things and, therefore, may have different attributes and content. Such equally named however essentially different local elements must be documented differently.\n<p>\nOn the other hand, this should not be extended to all local elements, because in lots of cases local elements are declared very simply:\n<dl><dd>\n<code>&lt;xs:element name="elementName" type="typeName"/&gt;</code>\n</dd></dl>\nIn such a declaration, an element is totally defined by its type, which is a global one. An XML schema may contain many such declarations, where {elementName, typeName} pairs are repeating. Therefore, every such a pair may be considered as a special "global" element that could be documented as a single entity.\n\n<h2>How Local Elements are documented</h2>\n\nThis XML Schema documentation generator provides unique capabilities to document all local elements defined in your XML schemas.\n<p>\nLocal elements can be documented simultaneously in two ways: <b>locally</b> and <b>globally</b>.\n\n<h2>Local Documenting</h2>\n\nAn element component can be documented locally together with its parent component where it is defined. \n<p>\nIn that case, the element will be treated essentially the same as an attribute. (Actually, locally defined elements with simple types are frequently used instead of attributes.)\n<p>\nThe details about such an element will appear in the <i>"Content Element Detail"</i> section of the <i>Component Documentation</i> generated for its parent component. What exactly is included in this section about the element is controlled by the parameter group: <i>"Details | Component Documentation | Content Element Detail"</i>\n\n<h2>Global Documenting</h2>\n\nGlobal documenting of a local element means generating for it the full <i>Element Documentation</i> block/page.\n<p>\nIn the case of framed HTML documentation, such an element will also appear in the component lists shown in the documentation <i>List Frame</i> (on the left).\n<p>\nMoreover, unlike a section describing that element in the <i>"Content Element Detail"</i> of its parent component, the detailed <i>Element Documentation</i> may contain substantially more information (such as <i>"List of Containing Elements"</i>, <i>"Usage/Definition Locations"</i> report and etc.)\n\n<h3>Global Interpretation of Local Elements</h3>\n\nTo be able to document local elements along with the global ones, their meaning must be somehow generalized/extended so as to make it unique for the entire XML schema (and even the entire namespace it belongs to). \n<p>\nFor instance, those elements that duplicate the same definition across the whole XML schema (e.g. the name and type) may be considered to represent the same kind of things from the outside world. Therefore, all such elements may be represented by the same <i>global element entity</i> and documentation as a single unit.\n<p>\nWe solve this problem in the following way:\n<ul>\n<li>\nWhen several local elements share the same name and their type is determined by the <code>\'type\'</code> attribute referring to the same global simple or complex type, all such local elements are considered as a single <b><i>quasi-global</i></b> element.\n<p></p>\nUnlike ordinary global elements whose names are unique for the whole namespace, each quasi-global element is unique only by its name/type combination. Most of things that can be said about every local element with the equal name/type combination are the same and, therefore, may be referred to and documented as a single unit. \n<p></p>\nActually, such an approach may be even more interesting, because the same name/type combination for a schema element is normally associated with the same thing from the real world. When you try to understand a particular XML schema, tracking something associated with different local elements scattered across the whole schema may be difficult. Having a single documentation for this may quickly reveal a lot more details. \n<p></p>\nEach quasi-global element is documented separately and is referred to from every location of the corresponding local elements it represents. Conversely, the unified documentation for a quasi-global element will account and mention all locations where all actual local elements represented by it are declared.\n<p></p>\n</li>\n<li>\nLocal elements with embedded anonymous types may be considered as truly local ones. The presence of the embedded type means that such an element is associated with something relevant to only that particular local context where it is defined.\nBecause of this, each local element with anonymous type is documented with a separate <i>Element Documentation</i> block/page.\n<p></p>\n<table border="1">\n<tr><td><font face="Dialog" size="-1">\nThere are some XML schemas which contain a number of local element components with the same names and absolutely equally defined anonymous types embedded in them. All such local elements again represent the same unique global entity and it will not be accounted in the documentation. Fortunately, that kind of design is used very rarely.\n</font>\n</td></tr>\n</table>\n</li>\n</ul>\n\n<h3>Global Naming of Local Elements</h3>\n\nSince the name of a local element is required to be unique only within the scope of its parent, several local element components may exist that share the same name however have different types (and, therefore, must be documented differently).\nTo be able to refer to such elements on the global level, their names must be extended to make them unique for the whole namespace.\n<p>\nThe <b><i>extension of local element name</i></b> is generated according to the following rules:\n<ol>\n<li>\nWhen the element is included in the content model of only one other globally documented element (that is taking into account <i>quasi-global</i> elements; see above), the element name is extended with the full name of it possible parent element like the following:\n<blockquote>\n<code><i>name</i> (in <i>full_parent_name</i>)</code>\n</blockquote>\n<p>\n</li>\n\n<li>\nOtherwise, when this is a <i>quasi-global</i> element (see above), the element name is extended with the type name like the following:\n<blockquote>\n<code><i>name</i> (type <i>type_name</i>)</code>\n</blockquote>\nor\n<blockquote>\n<code><i>name</i> : <i>type_name</i></code>\n</blockquote>\nwhen the name appears within the extension of other local element\'s name.\n<p>\n</li>\n\n<li>\nThe rest is the case when the element has anonymous type and is declared locally within a global complex type or element group. In that case, the element name is extended with a short info how its anonymous type was derived from other global types:\n<blockquote>\n<code><i>name</i> (type extension of <i>global_type_name</i>)</code><br>\n<code><i>name</i> (type restriction of <i>global_type_name</i>)</code><br>\n<code><i>name</i> (type list of <i>global_type_name</i>)</code><br>\n<code><i>name</i> (type anonymous)</code>\n</blockquote>\n(The last is the case when the anonymous type was not derived directly from a global type by extension, restriction or list.)\n<p></p>\nTheoretically, such name extensions may still be repeating for different local elements. However, in practice that will happen very rarely.\n</li>\n</ol>\n\n<u>Examples</u>:\n<p>\n<code>xs:choice <b>(in xs:group)</b></code>\n<blockquote>\nHere, the local element <code>\'xs:choice\'</code> (whose name is extended) may be included in only one other element <code>\'xs:group\'</code> which is the global one.\n</blockquote>\n\n<code>configuration <b>(in plugin in plugins in reporting)</b></code>\n<blockquote>\nThe local element <code>\'configuration\'</code> (whose name is extended) may be included in only one other element <code>\'plugin\'</code>, which is by itself a local element included only in element <code>plugins</code> and so on.\n</blockquote>\n\n<code>configuration <b>(in plugin : Plugin)</b></code>\n<blockquote>\nThe local element <code>\'configuration\'</code> may be included in only one other element <code>\'plugin\'</code>, which is also a local element. However, what\'s know more about that element is that its type is <code>\'Plugin\'</code> and it appears in content model of several other elements.\n</blockquote>\n<p>\n<u>Omitting Local Element Name Extensions</u>\n<p>\nWhen the name of a local element is unique for the entire namespace, no name extension is actually needed. In that case, you can disable the generation of name extensions using <i>"Show | Local Element Extension"</i> parameter either for all local elements or for only those whose original names are unique.';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='all;complexType;none';
		param.enum.displayValues='all;with complex type only;none';
	}
	PARAM={
		param.name='gen.doc.complexType';
		param.title='Complex Types';
		param.description='Specifies whether to generate the detailed <b><i>Complex Type Documentation</i></b> for each global complex type component.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, where you can specify what will be included in the <i>Complex Type Documentation</i>.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.simpleType';
		param.title='Simple Types';
		param.description='Specifies whether to generate the detailed <b><i>Simple Type Documentation</i></b> for each global simple type component.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, which controls the exact content of the <i>Simple Type Documentation</i>.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.group';
		param.title='Element Groups';
		param.description='Specifies whether to generate the detailed <b><i>Element Group Documentation</i></b> for each global element group component.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, where you can specify what is included in the <i>Element Group Documentation</i>.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.attribute';
		param.title='Global Attributes';
		param.description='Specifies whether to generate the detailed <b><i>Global Attribute Documentation</i></b> for each global attribute component.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, where you can specify what is included in the <i>Global Attribute Documentation</i>.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.attributeGroup';
		param.title='Attribute Groups';
		param.description='Specifies whether to generate the detailed <b><i>Attribute Group Documentation</i></b> for each global attribute group component.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation"</i> parameter group, where you can specify what is included in the <i>Attribute Group Documentation</i>.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='gen.doc.xmlnsBindings';
		param.title='XML Namespace Bindings';
		param.description='Specifies whether to generate the <b><i>Namespace Bindings</i></b> report.\n<p>\nThis report will allow you to quickly find by any namespace prefix used in the source XSD files the namespace URI associated with it and the exact location where that namespace binding is specified.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc';
		param.title='Details';
		param.title.style.bold='true';
		param.description='This group of parameters controls the exact content of specific <i>documentation blocks</i> (which the whole documentation is made of).\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Generate Details"</i> parameter group, where you can select which of the blocks must be generated and for which XML schema components (e.g. <i>Component Documentation</i> blocks).\n</blockquote>';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.overview';
		param.title='Overview Summary';
		param.title.style.bold='true';
		param.description='This group of parameters controls the content of the  <b><i>Overview Summary</i></b> documentation block.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Generate Details | Overview Summary"</i> parameter, where you can specify whether to generate the <i>Overview Summary</i> block.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.overview.namespaces';
		param.title='Namespace Summary';
		param.description='Specify whether to generate the <b><i>Namespace Summary</i></b> section.\n<p>\nThis section enumerates all documented namespaces (i.e. those targeted by at least one of the documented XML schemas) along with brief information about each namespace.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas';
		param.title='Schema Summary';
		param.description='Specify whether to generate the <b><i>Schema Summary</i></b> table that enumerates all documented XML schemas along with a few details about each of them.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nSpecify which details are to be shown about each XML schema.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the XML schema annotation and which part of it.\n<p>\nThe full annotation text is obtained from all &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code>xs:schema/xs:annotation/xs:documentation</code>\n</dd></dl>\nMultiple &lt;xs:documentation&gt; elements produce multiple sections of the annotation text.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"first sentence"</i>\n<blockquote>\nInclude only the first sentence of the annotation text.\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nInclude the full annotation.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include annotation.\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
		param.enum.displayValues='first sentence;full;none';
	}
	PARAM={
		param.name='doc.overview.schemas.profile';
		param.title='Schema Profile';
		param.description='Specifies whether to generate the <b><i>Schema Profile</i></b> section,\nwhich includes some general information about the XML schema.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Schema Profile</i> section.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.targetNamespace';
		param.title='Target Namespace';
		param.description='Specify whether to show the <b>namespace URI</b> targeted by the schema.\n<p>\nThis is the value of <code>\'targetNamespace\'</code> attribute of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.version';
		param.title='Version';
		param.description='Specify whether to show the schema <b>version</b>.\n<p>\nThis is the value of <code>\'version\'</code> attribute of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.components';
		param.title='Components';
		param.description='Specify whether to show the <b>number of components</b> by their types defined in the schema.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.formDefault';
		param.title='Default NS-Qualified Form';
		param.description='Specify whether to show the <b>default namespace-qualified form</b> for local elements and local attributes defined in the schema.\n<p>\nThese are the values of  <code>\'elementFormDefault\'</code> and <code>\'attributeFormDefault\'</code> attributes of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.blockDefault';
		param.title='Default Block Attribute';
		param.description='Specify whether to document <b><code>\'blockDefault\'</code></b> attribute of the schema (<code>&lt;xs:schema&gt;</code> element).\n<p>\nThis attribute specifies the default value of <code>\'block\'</code> attribute of  <code>&lt;xs:element&gt;</code> and <code>&lt;xs:complexType&gt;</code> elements defined in the schema.\n<p>\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'blockDefault\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.blockDefault.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'blockDefault\'</code> attribute.\n<p>\n<b>Note:</b> Empty or blank value will be ignored (treated as no-value)</b>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.blockDefault.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the <code>\'blockDefault\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.finalDefault';
		param.title='Default Final Attribute';
		param.description='Specify whether to document <b><code>\'finalDefault\'</code></b> attribute of the schema (<code>&lt;xs:schema&gt;</code> element).\n<p>\nThis attribute specifies the default value of <code>\'final\'</code> attribute of  <code>&lt;xs:element&gt;</code> and <code>&lt;xs:complexType&gt;</code> elements defined in the schema.\n<p>\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'finalDefault\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.finalDefault.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'finalDefault\'</code> attribute.\n<p>\n<b>Note:</b> Empty or blank value will be ignored (treated as no-value)</b>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.finalDefault.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the <code>\'finalDefault\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.location';
		param.title='Schema Location';
		param.description='Specify whether to show the location of the <b>schema source file</b> (or URL).';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.location.relative';
		param.title='Relative Path';
		param.description='Specify whether to display schema location as a relative pathname.\n<p>\nWhen this parameter is selected (<b><code>true</code></b>) and the schema file resides on the local system, the file pathname will be converted to a relative one against the documentation destination directory.';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.location.hyperlink';
		param.title='Hyperlink';
		param.description='Specify whether to generate a hyperlink to the schema file.\n<p>\nWhen this parameter is selected (<b><code>true</code></b>), the schema location text will be hyperlinked to the actual schema file.\n<p>\nWhen the displayed schema location is a relative pathname, the hyperlink is generated relatively to the location of the given document file. Otherwise, the hyperlink is generated to an absolute URL either on the local system or remote one.';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.overview.schemas.profile.relatedSchemas';
		param.title='Related Schemas';
		param.description='Specify whether to show the lists of other XML schemas that this schema <b>imports</b>, <b>includes</b> and <b>redefines</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps';
		param.title='All Component Summary';
		param.title.style.bold='true';
		param.description='This group of parameters controls the content of the <b><i>All Component Summary</i></b> documentation page/block.\n<p>\nThis block contains the summaries of all schema components of the specified types (see nested parameters) throughout all schemas being documented.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Generate Details | All Component Summary"</i> parameter, where you can specify whether to generate the <i>All Component Summary</i> block.\n</blockquote>';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.allcomps.item';
		param.title='Summary Item';
		param.title.style.italic='true';
		param.description='This parameter group controls which information about a component will appear in a summary table item.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.allcomps.item.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the component annotation and which part of it.\n<p>\nThe annotation text is obtained from the &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code><b><i>xs:component</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nwhere <code><i>\'xs:component\'</i></code> is the particular XSD element which defines the component (e.g. <code>xs:complexType</code>).\nMultiple &lt;xs:documentation&gt; elements produce different sections of the annotation text.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"first sentence"</i>\n<blockquote>\nInclude only the first sentence of the annotation text.\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nInclude the full annotation.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include annotation.\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
		param.enum.displayValues='first sentence;full;none';
	}
	PARAM={
		param.name='doc.allcomps.item.profile';
		param.title='Component Profile';
		param.description='Specifies whether to generate the <b><i>Component Profile</i></b> section,\nwhich provides general summary information about the component.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Component Profile</i> section.\n<p></p>\nFor more details about each parameter in this group, please see similar parameters in <i>"Details | Component Documentation | Component Profile"</i> group.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.namespace';
		param.title='Namespace';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.type';
		param.title='Type';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.content';
		param.title='Content';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.abstract';
		param.title='Abstract';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.block';
		param.title='Block';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.block.value';
		param.title='Value';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.block.meaning';
		param.title='Meaning';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.final';
		param.title='Final';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.final.value';
		param.title='Value';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.final.meaning';
		param.title='Meaning';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.subst';
		param.title='Subst.Gr';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.subst.heads';
		param.title='List of group heads';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.subst.members';
		param.title='List of group members';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.nillable';
		param.title='Nillable';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.defined';
		param.title='Defined';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.includes';
		param.title='Includes';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.redefines';
		param.title='Redefines';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.redefined';
		param.title='Redefined';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.item.profile.used';
		param.title='Used';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.allcomps.elements';
		param.title='Elements';
		param.description='Specify whether to generate the <b><i>Element Summary</i></b> of all <i>global</i> element components and some of the <i>local</i> element components defined across all XML schemas being documented.\n\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Elements"</i> parameter.\n</dd>\n</dl>\n\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecify which of the <i>local</i> element components must be included.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.element")';
	}
	PARAM={
		param.name='doc.allcomps.elements.local';
		param.title='Local Elements';
		param.description='Specifies whether to include <i>local elements</i> in the <b><i>Element Summary</i></b> table.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"all"</i>\n<blockquote>\nInclude all local elements.\n</blockquote>\n\n<i>"with complex type only"</i>\n<blockquote>\nInclude only local elements with complex types.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include local elements.\n</blockquote>\n\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Elements | Local Elements"</i> parameter.\n</dd></dl>\n\n<b>See Also:</b>\n<blockquote>\nFor more details about how local elements are documented, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='all;complexType;none';
		param.enum.displayValues='all;with complex type;none';
		param.default.expr='getStringParam("gen.doc.element.local")';
	}
	PARAM={
		param.name='doc.allcomps.complexTypes';
		param.title='Complex Types';
		param.description='Specify whether to generate the <b><i>Complex Type Summary</i></b> of all global complexType components defined across all XML schemas being documented.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Complex Types"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.complexType")';
	}
	PARAM={
		param.name='doc.allcomps.simpleTypes';
		param.title='Simple Types';
		param.description='Specify whether to generate the <b><i>Simple Type Summary</i></b> of all global simpleType components defined across all XML schemas being documented.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Simple Types"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.simpleType")';
	}
	PARAM={
		param.name='doc.allcomps.groups';
		param.title='Element Groups';
		param.description='Specify whether to generate the <b><i>Element Group Summary</i></b> of all global element group components defined across all XML schemas being documented.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Element Groups"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.group")';
	}
	PARAM={
		param.name='doc.allcomps.attributes';
		param.title='Global Attributes';
		param.description='Specify whether to generate the <b><i>Global Attribute Summary</i></b> of all global attribute components defined across all XML schemas being documented.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Global Attributes"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.attribute")';
	}
	PARAM={
		param.name='doc.allcomps.attributeGroups';
		param.title='Attribute Groups';
		param.description='Specify whether to generate the <b><i>Attribute Group Summary</i></b> of all global attribute group components defined across all XML schemas being documented.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Attribute Groups"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.attributeGroup")';
	}
	PARAM={
		param.name='doc.namespace';
		param.title='Namespace Overview';
		param.title.style.bold='true';
		param.description='This group of parameters controls the content of the  <b><i>Namespace Overview</i></b> documentation blocks that can be generated for each namespace.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Generate Details | Namespace Overviews"</i> parameter, where you can specify whether to generate the <i>Namespace Overview</i> blocks.\n</blockquote>';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.namespace.profile';
		param.title='Namespace Profile';
		param.description='Specifies whether to generate the <b><i>Namespace Profile</i></b> section with brief information about the namespace.\n<p>\nIn particular, this includes the list of the XML schemas targeting this namespace, number of components by types, etc.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas';
		param.title='Schema Summary';
		param.description='Specify whether to generate the <b><i>Schema Summary</i></b> table that enumerates all documented XML schemas targeting this namespace.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nSpecify which details are to be shown about each XML schema.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the XML schema annotation and which part of it.\n<p>\nThe full annotation text is obtained from all &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code>xs:schema/xs:annotation/xs:documentation</code>\n</dd></dl>\nMultiple &lt;xs:documentation&gt; elements produce multiple sections of the annotation text.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"first sentence"</i>\n<blockquote>\nInclude only the first sentence of the annotation text.\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nInclude the full annotation.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include annotation.\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
		param.enum.displayValues='first sentence;full;none';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile';
		param.title='Schema Profile';
		param.description='Specifies whether to generate the <b><i>Schema Profile</i></b> section,\nwhich includes some general information about the XML schema.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Schema Profile</i> section.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.targetNamespace';
		param.title='Target Namespace';
		param.description='Specify whether to show the <b>namespace URI</b> targeted by the schema.\n<p>\nThis is the value of <code>\'targetNamespace\'</code> attribute of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.version';
		param.title='Version';
		param.description='Specify whether to show the schema <b>version</b>.\n<p>\nThis is the value of <code>\'version\'</code> attribute of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.components';
		param.title='Components';
		param.description='Specify whether to show the <b>number of components</b> by their types defined in the schema.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.formDefault';
		param.title='Default NS-Qualified Form';
		param.description='Specify whether to show the <b>default namespace-qualified form</b> for local elements and local attributes defined in the schema.\n<p>\nThese are the values of  <code>\'elementFormDefault\'</code> and <code>\'attributeFormDefault\'</code> attributes of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.blockDefault';
		param.title='Default Block Attribute';
		param.description='Specify whether to document <b><code>\'blockDefault\'</code></b> attribute of the schema (<code>&lt;xs:schema&gt;</code> element).\n<p>\nThis attribute specifies the default value of <code>\'block\'</code> attribute of  <code>&lt;xs:element&gt;</code> and <code>&lt;xs:complexType&gt;</code> elements defined in the schema.\n<p>\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'blockDefault\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.blockDefault.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'blockDefault\'</code> attribute.\n<p>\n<b>Note:</b> Empty or blank value will be ignored (treated as no-value)</b>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.blockDefault.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the <code>\'blockDefault\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.finalDefault';
		param.title='Default Final Attribute';
		param.description='Specify whether to document <b><code>\'finalDefault\'</code></b> attribute of the schema (<code>&lt;xs:schema&gt;</code> element).\n<p>\nThis attribute specifies the default value of <code>\'final\'</code> attribute of  <code>&lt;xs:element&gt;</code> and <code>&lt;xs:complexType&gt;</code> elements defined in the schema.\n<p>\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'finalDefault\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.finalDefault.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'finalDefault\'</code> attribute.\n<p>\n<b>Note:</b> Empty or blank value will be ignored (treated as no-value)</b>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.finalDefault.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the <code>\'finalDefault\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.location';
		param.title='Schema Location';
		param.description='Specify whether to show the location of the <b>schema source file</b> (or URL).';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.location.relative';
		param.title='Relative Path';
		param.description='Specify whether to display schema location as a relative pathname.\n<p>\nWhen this parameter is selected (<b><code>true</code></b>) and the schema file resides on the local system, the file pathname will be converted to a relative one against the documentation destination directory.';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.location.hyperlink';
		param.title='Hyperlink';
		param.description='Specify whether to generate a hyperlink to the schema file.\n<p>\nWhen this parameter is selected (<b><code>true</code></b>), the schema location text will be hyperlinked to the actual schema file.\n<p>\nWhen the displayed schema location is a relative pathname, the hyperlink is generated relatively to the location of the given document file. Otherwise, the hyperlink is generated to an absolute URL either on the local system or remote one.';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.namespace.schemas.profile.relatedSchemas';
		param.title='Related Schemas';
		param.description='Specify whether to show the lists of other XML schemas that this schema <b>imports</b>, <b>includes</b> and <b>redefines</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps';
		param.title='Component Summaries';
		param.title.style.bold='true';
		param.description='Specify whether to generate summary tables of global components and local elements that belong to the given namespace (that is defined in all XML schemas that target this namespace).\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nSpecify the types of the components to be shown in the summary tables and which information must be displayed about each component.\n<p></p>\nThe default values of the parameters selecting the components are calculated dynamically from the corresponding parameters of the <i>"Generate Details"</i> group. That is, by default, only those components will appear in the summary tables which you have already specified to be documented in full. The parameters just allow you to override this.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item';
		param.title='Summary Item';
		param.title.style.italic='true';
		param.description='This parameter group controls which information about a component will appear in a summary table item.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.namespace.comps.item.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the component annotation and which part of it.\n<p>\nThe annotation text is obtained from the &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code><b><i>xs:component</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\n(where <code><i>\'xs:component\'</i></code> is the particular XSD element which defines the component, e.g. <code>xs:complexType</code>)\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"first sentence"</i>\n<blockquote>\nInclude only the first sentence of the annotation text.\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nInclude the full annotation.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include annotation.\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
		param.enum.displayValues='first sentence;full;none';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile';
		param.title='Component Profile';
		param.description='Specifies whether to generate the <b><i>Component Profile</i></b> section,\nwhich provides general summary information about the component.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Component Profile</i> section.\n<p></p>\nFor more details about each parameter in this group, please see similar parameters in <i>"Details | Component Documentation | Component Profile"</i> group.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.namespace';
		param.title='Namespace';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.type';
		param.title='Type';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.content';
		param.title='Content';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.abstract';
		param.title='Abstract';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.block';
		param.title='Block';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.block.value';
		param.title='Value';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.block.meaning';
		param.title='Meaning';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.final';
		param.title='Final';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.final.value';
		param.title='Value';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.final.meaning';
		param.title='Meaning';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.subst';
		param.title='Subst.Gr';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.subst.heads';
		param.title='List of group heads';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.subst.members';
		param.title='List of group members';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.nillable';
		param.title='Nillable';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.defined';
		param.title='Defined';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.includes';
		param.title='Includes';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.redefines';
		param.title='Redefines';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.redefined';
		param.title='Redefined';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.item.profile.used';
		param.title='Used';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.namespace.comps.elements';
		param.title='Elements';
		param.description='Specify whether to generate the <b><i>Element Summary</i></b> of all <i>global</i> element components and some of the <i>local</i> element components defined in the given namespace.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Elements"</i> parameter.\n</dd></dl>\n\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecify which of the <i>local</i> element components must be included.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.element")';
	}
	PARAM={
		param.name='doc.namespace.comps.elements.local';
		param.title='Local Elements';
		param.description='Specifies whether to include <i>local elements</i> in the <b><i>Element Summary</i></b> table.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"all"</i>\n<blockquote>\nInclude all local elements.\n</blockquote>\n\n<i>"with complex type only"</i>\n<blockquote>\nInclude only local elements with complex types.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include local elements.\n</blockquote>\n\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Elements | Local Elements"</i> parameter.\n</dd></dl>\n\n<b>See Also:</b>\n<blockquote>\nFor more details about how local elements are documented, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='all;complexType;none';
		param.enum.displayValues='all;with complex type;none';
	}
	PARAM={
		param.name='doc.namespace.comps.complexTypes';
		param.title='Complex Types';
		param.description='Specify whether to generate the <b><i>Complex Type Summary</i></b> of all global <i>complex type</i> components defined in the given namespace.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Complex Types"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.complexType")';
	}
	PARAM={
		param.name='doc.namespace.comps.simpleTypes';
		param.title='Simple Types';
		param.description='Specify whether to generate the <b><i>Simple Type Summary</i></b> of all global <i>simple type</i> components defined in the given namespace.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Simple Types"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.simpleType")';
	}
	PARAM={
		param.name='doc.namespace.comps.groups';
		param.title='Element Groups';
		param.description='Specify whether to generate the <b><i>Element Group Summary</i></b> of all global <i>element group</i> components defined in the given namespace.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Element Groups"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.group")';
	}
	PARAM={
		param.name='doc.namespace.comps.attributes';
		param.title='Global Attributes';
		param.description='Specify whether to generate the <b><i>Global Attribute Summary</i></b> of all global <i>attribute</i> components defined in the given namespace.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Global Attributes"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.attribute")';
	}
	PARAM={
		param.name='doc.namespace.comps.attributeGroups';
		param.title='Attribute Groups';
		param.description='Specify whether to generate the <b><i>Attribute Group Summary</i></b> of all global <i>attribute group</i> components defined in the given namespace.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Attribute Groups"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.attributeGroup")';
	}
	PARAM={
		param.name='doc.schema';
		param.title='Schema Overview';
		param.title.style.bold='true';
		param.description='This group of parameters controls the content of the  <b><i>Schema Overview</i></b> documentation blocks that can be generated for each XML schema being documented.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Generate Details | Schema Overviews"</i> parameter, where you can specify whether to generate the <i>Schema Overview</i> blocks.\n</blockquote>';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.schema.profile';
		param.title='Schema Profile';
		param.description='Specifies whether to generate the <b><i>Schema Profile</i></b> section,\nwhich includes some general information about the XML schema.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Schema Profile</i> section.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.targetNamespace';
		param.title='Target Namespace';
		param.description='Specify whether to show the <b>namespace URI</b> targeted by the schema.\n<p>\nThis is the value of <code>\'targetNamespace\'</code> attribute of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.version';
		param.title='Version';
		param.description='Specify whether to show the schema <b>version</b>.\n<p>\nThis is the value of <code>\'version\'</code> attribute of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.components';
		param.title='Components';
		param.description='Specify whether to show the <b>number of components</b> by their types defined in the schema.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.formDefault';
		param.title='Default NS-Qualified Form';
		param.description='Specify whether to show the <b>default namespace-qualified form</b> for local elements and local attributes defined in the schema.\n<p>\nThese are the values of  <code>\'elementFormDefault\'</code> and <code>\'attributeFormDefault\'</code> attributes of the <code>&lt;xs:schema&gt;</code> element.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.blockDefault';
		param.title='Default Block Attribute';
		param.description='Specify whether to document <b><code>\'blockDefault\'</code></b> attribute of the schema (<code>&lt;xs:schema&gt;</code> element).\n<p>\nThis attribute specifies the default value of <code>\'block\'</code> attribute of  <code>&lt;xs:element&gt;</code> and <code>&lt;xs:complexType&gt;</code> elements defined in the schema.\n<p>\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'blockDefault\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.blockDefault.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'blockDefault\'</code> attribute.\n<p>\n<b>Note:</b> Empty or blank value will be ignored (treated as no-value)</b>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.blockDefault.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the <code>\'blockDefault\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.finalDefault';
		param.title='Default Final Attribute';
		param.description='Specify whether to document <b><code>\'finalDefault\'</code></b> attribute of the schema (<code>&lt;xs:schema&gt;</code> element).\n<p>\nThis attribute specifies the default value of <code>\'final\'</code> attribute of  <code>&lt;xs:element&gt;</code> and <code>&lt;xs:complexType&gt;</code> elements defined in the schema.\n<p>\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'finalDefault\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.finalDefault.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'finalDefault\'</code> attribute.\n<p>\n<b>Note:</b> Empty or blank value will be ignored (treated as no-value)</b>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.finalDefault.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the <code>\'finalDefault\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.location';
		param.title='Schema Location';
		param.description='Specify whether to show the location of the <b>schema source file</b> (or URL).';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.profile.location.relative';
		param.title='Relative Path';
		param.description='Specify whether to display schema location as a relative pathname.\n<p>\nWhen this parameter is selected (<b><code>true</code></b>) and the schema file resides on the local system, the file pathname will be converted to a relative one against the documentation destination directory.';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.schema.profile.location.hyperlink';
		param.title='Hyperlink';
		param.description='Specify whether to generate a hyperlink to the schema file.\n<p>\nWhen this parameter is selected (<b><code>true</code></b>), the schema location text will be hyperlinked to the actual schema file.\n<p>\nWhen the displayed schema location is a relative pathname, the hyperlink is generated relatively to the location of the given document file. Otherwise, the hyperlink is generated to an absolute URL either on the local system or remote one.';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.schema.profile.relatedSchemas';
		param.title='Related Schemas';
		param.description='Specify whether to show the lists of other XML schemas that this schema <b>imports</b>, <b>includes</b> and <b>redefines</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the XML schema annotation.\n<p>\nThe full annotation text is obtained from all &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code>xs:schema/xs:annotation/xs:documentation</code>\n</dd></dl>\nMultiple &lt;xs:documentation&gt; elements produce separate sections of the annotation text.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps';
		param.title='Component Summaries';
		param.title.style.bold='true';
		param.description='Specify whether to generate summary tables of global components and local elements that are defined in the given XML schema.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nSpecify the types of the components to be shown in the summary tables and which information must be displayed about each component.\n<p></p>\nThe default values of the parameters selecting the components are calculated dynamically from the corresponding parameters of the <i>"Generate Details"</i> group. That is, by default, only those components will appear in the summary tables which you have already specified to be documented in full. The parameters just allow you to override this.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.schema.comps.item';
		param.title='Summary Item';
		param.title.style.italic='true';
		param.description='This parameter group controls which information about a component will appear in a summary table item.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.schema.comps.item.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the component annotation and which part of it.\n<p>\nThe annotation text is obtained from the &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code><b><i>xs:component</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nwhere <code><i>\'xs:component\'</i></code> is the particular XSD element which defines the component (e.g. <code>xs:complexType</code>).\nMultiple &lt;xs:documentation&gt; elements produce different sections of the annotation text.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"first sentence"</i>\n<blockquote>\nInclude only the first sentence of the annotation text.\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nInclude the full annotation.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include annotation.\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='first_sentence;full;none';
		param.enum.displayValues='first sentence;full;none';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile';
		param.title='Component Profile';
		param.description='Specifies whether to generate the <b><i>Component Profile</i></b> section,\nwhich provides general summary information about the component.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Component Profile</i> section.\n<p></p>\nFor more details about each parameter in this group, please see similar parameters in <i>"Details | Component Documentation | Component Profile"</i> group.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.namespace';
		param.title='Namespace';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.type';
		param.title='Type';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.content';
		param.title='Content';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.abstract';
		param.title='Abstract';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.block';
		param.title='Block';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.block.value';
		param.title='Value';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.block.meaning';
		param.title='Meaning';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.final';
		param.title='Final';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.final.value';
		param.title='Value';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.final.meaning';
		param.title='Meaning';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.subst';
		param.title='Subst.Gr';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.subst.heads';
		param.title='List of group heads';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.subst.members';
		param.title='List of group members';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.nillable';
		param.title='Nillable';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.defined';
		param.title='Defined';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.includes';
		param.title='Includes';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.redefines';
		param.title='Redefines';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.redefined';
		param.title='Redefined';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.item.profile.used';
		param.title='Used';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.comps.elements';
		param.title='Elements';
		param.description='Specify whether to generate the <b><i>Element Summary</i></b> of all <i>global</i> element components and some of the <i>local</i> element components defined in the given XML schema.\n\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Elements"</i> parameter.\n</dd>\n</dl>\n\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecify which of the <i>local</i> element components must be included.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.element")';
	}
	PARAM={
		param.name='doc.schema.comps.elements.local';
		param.title='Local Elements';
		param.description='Specifies whether to include <i>local elements</i> in the <b><i>Element Summary</i></b> table.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"all"</i>\n<blockquote>\nInclude all local elements.\n</blockquote>\n\n<i>"with complex type only"</i>\n<blockquote>\nInclude only local elements with complex types.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not include local elements.\n</blockquote>\n\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Elements | Local Elements"</i> parameter.\n</dd></dl>\n\n<b>See Also:</b>\n<blockquote>\nFor more details about how local elements are documented, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='all;complexType;none';
		param.enum.displayValues='all;with complex type;none';
	}
	PARAM={
		param.name='doc.schema.comps.complexTypes';
		param.title='Complex Types';
		param.description='Specify whether to generate the <b><i>Complex Type Summary</i></b> of all global <i>complex type</i> components defined in the given XML schema.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Complex Types"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.complexType")';
	}
	PARAM={
		param.name='doc.schema.comps.simpleTypes';
		param.title='Simple Types';
		param.description='Specify whether to generate the <b><i>Simple Type Summary</i></b> of all global <i>simple type</i> components defined in the given XML schema.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Simple Types"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.simpleType")';
	}
	PARAM={
		param.name='doc.schema.comps.groups';
		param.title='Element Groups';
		param.description='Specify whether to generate the <b><i>Element Group Summary</i></b> of all global <i>element group</i> components defined in the given XML schema.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Element Groups"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.group")';
	}
	PARAM={
		param.name='doc.schema.comps.attributes';
		param.title='Global Attributes';
		param.description='Specify whether to generate the <b><i>Global Attribute Summary</i></b> of all global <i>attribute</i> components defined in the given XML schema.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Global Attributes"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.attribute")';
	}
	PARAM={
		param.name='doc.schema.comps.attributeGroups';
		param.title='Attribute Groups';
		param.description='Specify whether to generate the <b><i>Attribute Group Summary</i></b> of all global <i>attribute group</i> components defined in the given XML schema.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nThe default value of this parameter is copied dynamically from the value of the <i>"Generate Details | Attribute Groups"</i> parameter.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='getBooleanParam("gen.doc.attributeGroup")';
	}
	PARAM={
		param.name='doc.schema.xml';
		param.title='XML Source';
		param.title.style.bold='true';
		param.description='Specifies whether to includes in the <i>Schema Overview</i> documentation the reproduced XML source of the whole XML schema.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls how the reproduced XML source will look and what it should include.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.xml.box';
		param.title='Enclose in Box';
		param.description='Specifies if the reproduced XML should be enclosed in a box.';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.schema.xml.remove.anns';
		param.title='Remove Annotations';
		param.description='Specifies whether to remove all <b><code>&lt;xs:annotation&gt;</code></b> elements from the reproduced XML source of the whole schema.\n<p>\nYou may want to exclude the <code>&lt;xs:annotation&gt;</code> elements from the reproduced XML source because such elements may occupy a lot of space (especially, when you use XHTML to format your annotations), so they could overwhelm anything else making it difficult to read other important things. Moreover, the actual content of the <code>&lt;xs:annotation&gt;</code> elements may be already shown (as a formatted text) in the corresponding <i>Annotation</i> sections of the documentation.\n\n<p>\n<b>See Also Parameters:</b>\n<ul>\n<li><i>"Details | Schema Overview | Annotation"</i></li>\n<li><i>"Processing | Annotations | Tags | XHTML"</i></li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp';
		param.title='Component Documentation';
		param.title.style.bold='true';
		param.description='This group of parameters controls the detailed content of the <b><i>Component Documentation</i></b> blocks that can be generated for all XML schema global components and all local element components. In particular, this applies to the following types of components:\n<ul>\n<li>Elements (both <i>global</i> and <i>local</i> ones)</li>\n<li>Complex Types</li>\n<li>Simple Types</li>\n<li>Element Groups</li>\n<li>Global Attributes</li>\n<li>Attribute Groups</li>\n</ul>\nCertain parameters in this group apply to all component types. Others are specific to only some component types.\n\n<p>\n<b>See Also:</b>\n<blockquote>\nThe corresponding parameters in <i>"Generate Details"</i> parameter group:\n</blockquote>\n<ul>\n<li><i>"Elements"</i></li>\n<li><i>"Local Elements"</i></li>\n<li><i>"Complex Types"</i></li>\n<li><i>"Simple Types"</i></li>\n<li><i>"Element Groups"</i></li>\n<li><i>"Global Attributes"</i></li>\n<li><i>"Attribute Groups"</i></li>\n</ul>\n<blockquote>\nWith these parameters, you can select which of those components should be documented.\n</blockquote>';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.profile';
		param.title='Component Profile';
		param.description='Specifies whether to generate the <b><i>Component Profile</i></b> section, which contains brief information about the component (such as which namespace it belongs to, where it is declared, type and content, etc.)\n<p>\n<b>Applies To:</b>\n<dl><dd>\nAll components\n</dd></dl>\n\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Component Profile</i> section.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.namespace';
		param.title='Namespace';
		param.description='Specify whether to show the <b><i>namespace</i></b> which the given component belongs to.\n<p>\n<b>Applies To:</b>\n<blockquote>\nAll components\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.type';
		param.title='Type';
		param.description='Specify whether to show the <b><i>component type</i></b> information.\n<p>\nThis is typically the name of a simple or complex global type which is specified in the <code>\'type\'</code> attribute of the XSD element that defines the component. For example:\n<dl><dd>\n<code>&lt;xs:element name="minExclusive" type="xs:facet"&gt;</code>\n</dd></dl>\nIn the case of an anonymous type, which is defined within the component itself, the type information will include some details about how that type is derived.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Global Attributes</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.content';
		param.title='Content';
		param.description='Specify whether to show brief information about the <b><i>element content model</i></b> and <b><i>attributes</i></b> associated with the given component. In particular, this includes:\n<ul>\n<li>\nThe element content type, which may be:  <i>simple</i>, <i>complex</i>, <i>mixed</i> or <i>empty</i>. This applies to the components:\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n</ul>\n(In the case of <i>Element Groups</i>, the element content is always complex. <i>Simple Types</i> always define simple content. Other components do not define element content.)\n<p></p>\n</li>\n<li>\nThe number of attributes (including a wildcard attribute) associated with the given component. These are both the attributes defined within the component itself and inherited from its ancestors. This item applies to the components:\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Attribute Groups</li>\n</ul>\n</li>\n<li>\nThe number of content elements (including a wildcard) associated with the given component. These are both the content elements defined within the component itself and inherited from its ancestors. This item applies to the components:\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Element Groups</li>\n</ul>\n</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.abstract';
		param.title='Abstract';
		param.description='Specify whether to document <b><code>\'abstract\'</code></b> attribute of the component.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Global Elements</li>\n<li>Complex Types</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.block';
		param.title='Block';
		param.description='Specify whether to document <b><code>\'block\'</code></b> attribute of the component.\n<p>\n<b>Note:</b> For global elements and complex types, when <code>block</code> attribute is not specified, its default value is defined by the <b><code>\'blockDefault\'</code></b> attribute of the parent <b><code>&lt;xs:schema&gt;</code></b>.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"any"</i>\n<blockquote>\nDocument <code>block</code> attribute in any case both for the original and default value.\n</blockquote>\n\n<i>"non-default only"</i>\n<blockquote>\nDocument <code>block</code> attribute only in the case when it is specified on this component. (No default value will be documented.)\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document <code>block</code> attribute.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Global & Local Elements</li>\n<li>Complex Types</li>\n</ul>\n\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'block\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.comp.profile.block.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'block\'</code> attribute.\n<p>\n<b>Notes:</b>\n<ul>\n<li>\nFor global elements and complex types, when <code>\'block\'</code> attribute is not specified on the component, its value will be taken from the <b><code>\'blockDefault\'</code></b> attribute of the parent <code>&lt;xs:schema&gt;</code>.\n</li>\n<li>\nEmpty or blank value will be ignored (treated as no-value)\n</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.block.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the actual <code>\'block\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.final';
		param.title='Final';
		param.description='Specify whether to document <b><code>\'final\'</code></b> attribute of the component.\n<p>\n<b>Note:</b> For global elements and complex types, when <code>final</code> attribute is not specified, its default value is defined by the <b><code>\'finalDefault\'</code></b> attribute of the parent <b><code>&lt;xs:schema&gt;</code></b>.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"any"</i>\n<blockquote>\nDocument <code>final</code> attribute in any case both for the original and default value.\n</blockquote>\n\n<i>"non-default only"</i>\n<blockquote>\nDocument <code>final</code> attribute only in the case when it is specified on this component. (No default value will be documented.)\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document <code>final</code> attribute.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Global Elements</li>\n<li>Complex Types</li>\n<li>Simple Types</li>\n</ul>\n\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>\'final\'</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
	}
	PARAM={
		param.name='doc.comp.profile.final.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'final\'</code> attribute.\n<p>\n<b>Notes:</b>\n<ul>\n<li>\nFor global elements and complex types, when <code>\'final\'</code> attribute is not specified on the component, its value will be taken from the <b><code>\'finalDefault\'</code></b> attribute of the parent <code>&lt;xs:schema&gt;</code>.\n</li>\n<li>\nEmpty or blank value will be ignored (treated as no-value)\n</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.final.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the actual <code>\'final\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.subst';
		param.title='Subst.Gr';
		param.description='Specify whether to show the information about the substitution groups, in which this element is involved (i.e. affiliated, head or member of). This may include:\n<ul>\n<li>\nThe list (or number) of elements which this element may substitute for.\n</li>\n<li>\nThe list (or number) of elements that may substitute for this element.</li>\n</ul>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>\n\n<b>Nested Parameter Group:</b>\n<blockquote>\nControls what exactly is included in the substitution group info.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.subst.heads';
		param.title='List of group heads';
		param.description='Specify whether to show the list of the substitution group heads, which this element is member of. (In other words, these are the elements that this element may substitute for.)\n<p>\nWhen <b><code>false</code></b> (unselected), only the number of the substitutable elements will be printed along with the link to the <i>"May substitute for elements"</i> section in the Element Documentation (which, when specified, shows the same list).\n<p>\n<b>See Also Parameter:</b>\n<blockquote>\n<i>"Details | Component Documentation | List of Substitutable Elements"</i> \n<blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.subst.members';
		param.title='List of group members';
		param.description='Specify whether to show the list of the members of the substitution group, which this element is head of. (In other words, these are the elements that may substitute for this element.)\n<p>\nWhen <b><code>false</code></b> (unselected), only the number of the substituting elements will be printed along with the link to the <i>"May be substituted with elements"</i> section in the Element Documentation (which, when specified, shows the same list).\n<p>\n<b>See Also Parameter:</b>\n<blockquote>\n<i>"Details | Component Documentation | List of Substituting Elements"</i> \n<blockquote>';
		param.featureType='pro';
		param.type='boolean';
	}
	PARAM={
		param.name='doc.comp.profile.nillable';
		param.title='Nillable';
		param.description='Specify whether to document <b><code>\'nillable\'</code></b> attribute of the element component.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.defined';
		param.title='Defined';
		param.description='Specify whether to show where the component is defined (in which XML schema).\n<p>\nFor local elements, this section also shows the number of location where the particular local element is defined (or "used", in effect). For more details about how documenting of local elements work, please see the description of the parameter: <i>"Generate Details | Elements | Local Elements"</i>.\n<p>\n<b>Applies To:</b>\n<blockquote>\nAll components\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.includes';
		param.title='Includes';
		param.description='Specify whether to show the number of <b><i>attributes</i></b> and <b><i>content elements</i></b> that are defined directly within this component (not inherited from its ancestor components). This includes:\n<ul>\n<li>\nThe number of attributes (including a wildcard attribute) defined within this component. It applies to the components:\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Attribute Groups</li>\n</ul>\n</li>\n<li>\nThe number of content elements (including a wildcard) defined within this component. It applies to the components:\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Element Groups</li>\n</ul>\n</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.redefines';
		param.title='Redefines';
		param.description='Specify whether to show which component has been redefined by this component and where (see also below).\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Complex Types</li>\n<li>Simple Types</li>\n<li>Element Groups</li>\n<li>Attribute Groups</li>\n</ul>\n\n<h3>Documenting of Redefined Components</h3>\n\nA schema component may <i>redefine</i> other component when it is declared within an XSD <code>&lt;xs:redefine&gt;</code> element. When the XML schema, which is being redefined by this element, also contains a component with that name, such a component becomes <i>redefined</i>. It will be completely replaced by the <i>redefining</i> component within the namespace scope targeted by the schema.\n<p>\nThe redefining component is typically based on the original component it redefines (it just extends or restricts it). Because of this, DocFlex/XML | XSDDoc will document both components. But since they have the same name, the original component will appear in the documentation under an altered name produced from the original one by adding the suffix: "$ORIGINAL"';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.redefined';
		param.title='Redefined';
		param.description='Specify whether to show which component redefines this component and where (see also below).\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Complex Types</li>\n<li>Simple Types</li>\n<li>Element Groups</li>\n<li>Attribute Groups</li>\n</ul>\n\n<h3>Documenting of Redefined Components</h3>\n\nA schema component may <i>redefine</i> other component when it is declared within an XSD <code>&lt;xs:redefine&gt;</code> element. When the XML schema, which is being redefined by this element, also contains a component with that name, such a component becomes <i>redefined</i>. It will be completely replaced by the <i>redefining</i> component within the namespace scope targeted by the schema.\n<p>\nThe redefining component is typically based on the original component it redefines (it just extends or restricts it). Because of this, DocFlex/XML | XSDDoc will document both components. But since they have the same name, the original component will appear in the documentation under an altered name produced from the original one by adding the suffix: "$ORIGINAL"';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.profile.used';
		param.title='Used';
		param.description='Specify whether to show the number of locations where the component is used.\n<p>\n<b>Applies To:</b>\n<blockquote>\nAll global components\n</blockquote>\n<p>\n<b>See Also:</b>\n<blockquote>\nParameter: <i>"Details | Component Documentation | Usage/Definition Locations"</i>\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.diagram';
		param.title='Content Model Diagram';
		param.description='Specify whether to generate/include the <b>graphic diagram</b> representation of the component content model.\n<p>\nCurrently, the content model diagrams can be generated only by an extension of DocFlex/XML that employs the functionality provided by some other software (for instance, the integration with Altova XMLSpy; see <i>"Integrations | XMLSpy"</i> parameter group).\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Element Groups</li>\n</ul>\n\n<b>Nested Parameters:</b>\n<dl><dd>\nControl how to direct hyperlinks from the diagram image.\n</dd></dl>\n\n<b>See Also:</b>\n<dl><dd>\n<i>"Integrations | XMLSpy"</i> parameter group\n</dd></dl>';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.expr='getBooleanParam("integration.xmlspy")';
	}
	PARAM={
		param.name='doc.comp.diagram.links';
		param.title='Hyperlinks';
		param.description='This parameter group controls how the diagram hyperlinks will be generated.\nThe current implementation limits it to the following possibilities:\n<ol>\n<li>The depiction of a <b>global attribute</b> (specified by reference) can be hyperlinked either to the attribute\'s global documentation or to its local documentation (found in <i>Attrbute Detail</i> section). This is controlled by the <i>"Global Attribute"</i> parameter of this group.\nWhen neither local nor global documentation is found, the hyperlink will go to the location where the global attribute is defined within the XML schema source. See <i>"Details | Schema Overview | XML Source"</i> parameter.<p></li>\n\n<li>The depiction of a <b>local attribute</b> or <b>attribute prohibition</b> can be hyperlinked only to the corresponding local documentation in <i>Attrbute Detail</i> section.\nWhen that documentation is not found, the hyperlink will go to the definition\'s location within the XML schema source.<p></li>\n\n<li>The depiction of a <b>global element</b> (specified by reference) can be hyperlinked only to the element\'s global documentation. If not found, the hyperlink will go to the location where the global element is defined within the XML schema source (see <i>"Details | Schema Overview | XML Source"</i> parameter).<p></li>\n\n<li>The depiction of a <b>local element</b> can be hyperlinked either to the global documentation related to this element component (see <i>"Generate Details | Elements | Local Elements"</i> parameter) or to its local documentation in <i>Content Element Detail</i> section. This is controlled by the <i>"Local Element"</i> parameter in this group.\nWhen neither local nor global documentation is found, the hyperlink will go to the definition\'s location within the XML schema source. See <i>"Details | Schema Overview | XML Source"</i> parameter.</li>\n\n</ol>';
		param.grouping='true';
	}
	PARAM={
		param.name='doc.comp.diagram.links.attribute.global';
		param.title='Global Attributes';
		param.description='Specify where to direct the hyperlink from a <b>global attribute</b> depiction:\n<p>\n<i>"global"</i>\n<dl><dd>\nThe hyperlink will be generated to the attribute\'s global documentation (see <i>"Generate Details | Global Attributes"</i> parameter). If that documentation is not found, the hyperlink goes to the local documentation (i.e. that of of the attribute reference definition) in the <i>Attrbute Detail</i> section. At last, if that is also not found, the hyperlink is directed to the definition of the global attribute within the XML schema source. See <i>"Details | Schema Overview | XML Source"</i> parameter.\n</dd></dl>\n\n<i>"local"</i>\n<dl><dd>\nIn this case, the local documentation (found in <i>Attrbute Detail</i> section) will be the first priority; then the attribute global documentation; at last, the location within the XML schema source.\n</dd></dl>';
		param.type='enum';
		param.enum.values='global;local';
	}
	PARAM={
		param.name='doc.comp.diagram.links.element.local';
		param.title='Local Elements';
		param.description='Specify where to direct the hyperlink from a <b>local element</b> depiction:\n<p>\n<i>"global"</i>\n<dl><dd>\nThe hyperlink will be generated to the global documentation related to this element component (see <i>"Generate Details | Elements | Local Elements"</i> parameter). If that documentation is not found, the hyperlink goes to the local documentation (i.e. that of of the element reference definition) in the <i>Content Element Detail</i> section. At last, if that is also not found, the hyperlink will be directed to the definition of this element within the XML schema source. See <i>"Details | Schema Overview | XML Source"</i> parameter.\n</dd></dl>\n\n<i>"local"</i>\n<dl><dd>\nIn this case, the local documentation (found in <i>Content Element Detail</i> section) will be the first priority; then the element global documentation; at last, the location within the XML schema source.\n</dd></dl>';
		param.type='enum';
		param.enum.values='global;local';
	}
	PARAM={
		param.name='doc.comp.xmlRep';
		param.title='XML Representation Summary';
		param.description='Specifies whether to generate the <b><i>XML Representation Summary</i></b> section.\n<p>\n<b>Applies To:</b>\n<blockquote>\nAll components\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which components the <i>"XML Representation Summary"</i> section must be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"XML Representation Summary"</i> section for <b>element</b> components (both global and local ones).';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.complexType';
		param.title='Complex Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"XML Representation Summary"</i> section for global <b>complex types</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.simpleType';
		param.title='Simple Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"XML Representation Summary"</i> section for global <b>simple types</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.group';
		param.title='Element Groups';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"XML Representation Summary"</i> section for global <b>element groups</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.attribute';
		param.title='Global Attributes';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"XML Representation Summary"</i> section for global <b>attributes</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"XML Representation Summary"</i> section for global <b>attribute groups</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xmlRep.sorting';
		param.title='Sorting';
		param.description='This parameter specifies sorting of attributes shown in the XML Representation Summary.\n<p>\nWhen selected (<b><code>true</code></b>) the attributes will be sorted in alphabetic order of their qualified names.\n<p>\nWhen unselected (<b><code>false</code></b>) the attributes will follow according to some <i>natural order</i> determined by how and where the attributes have been defined.\nIn a simplest case, when all attributes are defined within the same component, that will be exactly the order of their definitions. When the given component (whose attributes are represented) is based on other components, some of such ancestor components may define particular attributes (and even block some of those defined within their own ancestors). In that case, the result attribute ordering will appear from the subsequent interpretation of all involved components.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value.limited='true';
	}
	PARAM={
		param.name='doc.comp.simpleContent';
		param.title='Simple Content Detail';
		param.description='Specify whether to generate the details of the <b><i>simple content</i></b> defined by (or associated with) this component.\n<p>\nUnder the term <i>"simple content"</i>, we mean any data that comply with one of the XSD basic datatypes (e.g. <code>xs:string</code> or <code>xs:boolean</code>). In the case of XML elements, such data may represent the content of some element. In the case of attributes, it is the attribute value.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements with simple content model.</li>\n<li>Complex Types with simple content model.</li>\n<li>All Simple Types. The simple content is exactly what a particular simple type defines.</li>\n<li>All Global Attributes. The attribute value is a particular instance of simple content.</li>\n</ul>\n\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls generation of specific details about simple content.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.simpleContent.restrictions';
		param.title='Restrictions';
		param.description='Specify whether to show all <b>actual facets</b> that restrict a possible value allowed for this simple content.\n<p>\nThe list of actual facets is produced as the following.\n<p>\nFirst, the initial facets are collected by all types starting from the lowest one (which is either this component itself, when it is a type, or the type directly assigned to this component, when it is an element or attribute) throughout the chain of all its ancestor types (both global and anonymous) until the top ancestor passed or a derivation by list or union reached.\n<p>\nFurther, the produced sequence of facets is filtered so as the facets collected earliest (that is defined in lower descendant types) remain and those overridden by them are removed. In particular:\n<ol>\n<li>\nAll <code>xs:pattern</code> facets will remain, because a value allowed for the given simple content must match all of them.\n</li>\n<li>\nThe <code>xs:enumeration</code> facets will remain those that are defined in the same type, which is nearest to the given component.\n</li>\n<li>\nAll other facets will override the same facets defined in the ancestor types.\n</li>\n</ol>\n\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether to show the annotation of each facet.\n</dd></dl>\n\n<b>See Also:</b>\n<dl><dd>\nParameter <i>"Details | Component Documentation | Type Definition Detail | Simple Content Derivation | Facets"</i>\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.simpleContent.restrictions.annotation';
		param.title='Annotations';
		param.description='Specify whether to include the facet annotations.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.simpleContent.default';
		param.title='Default Value';
		param.description='Specify whether to show the <b>default value</b> assigned to the given simple content.\n<p>\nThis applies to global element and global attribute components. The default value is specified using <code>\'default\'</code> attribute of the XSD element defining the component.\n<p>\nIn the case of local elements, this item may be not applicable. When an element is declared locally in several places, its default value may be different at each location, therefore, it is senseless to display here just  one of those values.\n(For more details about documenting of local elements, please see the description of the parameter: <i>"Generate Details | Elements | Local Elements"</i>.)\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Global Attributes</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.simpleContent.fixed';
		param.title='Fixed Value';
		param.description='Specify whether to show the <b>fixed value</b> assigned to the given simple content.\n<p>\nThis applies to global element and global attribute components. The default value is specified using <code>\'fixed\'</code> attribute of the XSD element defining the component.\n<p>\nIn the case of local elements, this item may be not applicable. When an element is declared locally in several places, its fixed value may be different at each location, therefore, it is senseless to display here just  one of those values.\n(For more details about documenting of local elements, please see the description of the parameter: <i>"Generate Details | Elements | Local Elements"</i>.)\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Global Attributes</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists';
		param.title='Lists of Related Components';
		param.title.style.bold='true';
		param.description='The group of parameters to control the generation of various summary lists of other XML schema components that are related to the given component.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.lists.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.description='This parameter controls how the list items are displayed.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"flow"</i>\n<dl><dd>\nThe list items will appear as a comma delimited text flow within a single paragraph.\n<p></p>\nThis layout produces a very compact representation of the list. However,\nit may be difficult to read, particularly when some items contain spaces.\n</dd></dl>\n\n<i>"two columns"</i>\n<dl><dd>\nThe list items will be arranged in a two-column table.\n<p></p>\nThis representation is better to read, however, it will occupy more space. It suits more for the lists, whose items are strings with spaces. It may be worse for the big lists made of short word items.\n</dd></dl>\n\n<i>"optimal"</i>\n<dl><dd>\nThis choice allows the list layout to be selected automatically (this is programmed in templates). If the list is expected to include items with spaces, the two-column layout will be used. Otherwise, the list is displayed as a comma separated text flow.\n</dd></dl>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
		param.enum.displayValues='flow;two columns;optimal';
		param.default.value='optimal';
	}
	PARAM={
		param.name='doc.comp.lists.contentElements';
		param.title='Content Elements';
		param.description='Specifies whether to generate the <b><i>List of Content Elements</i></b>.\n<p>\nThis list shows all elements declared in the <b>Element Content Model</b> of the given component. These are the same elements as shown in the Complex Content Model of the component\'s XML Representation Summary. However, unlike in the model representation, the elements in this list are ordered alphabetically, never repeat and hyper-linked directly to the corresponding Element Documentations.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Global & Local Elements</li>\n<li>Complex Types</li>\n<li>Element Groups</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.containingElements';
		param.title='Containing Elements';
		param.description='Specifies whether to generate the <b><i>List of Containing Elements</i></b>.\n<p>\nThis list is generated only for Element Components, where it appears under the heading <i>"Included in content model of elements"</i>. The list shows all elements whose content models explicitly include the given element. (Here, "explicitly" means that element wildcards are not taken into account.)\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal & Local Elements\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.substitutableElements';
		param.title='Substitutable Elements';
		param.description='Specifies whether to generate the list of elements this element may substitute for (that is, the given element may be used anywhere instead of the elements in the list).\n<p>\nThis list will appear under the heading <i>"May substitute for elements"</i>.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>\n<p>\n<b>See Also Parameter:</b>\n<blockquote>\n<i>"Details | Component Documentation | Component Profile | Subst.Gr | List of group heads"</i> \n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
		param.default.expr='! getBooleanParam("doc.comp.profile.subst.heads")';
	}
	PARAM={
		param.name='doc.comp.lists.substitutingElements';
		param.title='Substituting Elements';
		param.description='Specifies whether to generate the list of elements that may substitute for the given element.\n(These are the members of the substitution group headed by the given element.)\n<p>\nThe list will appear under the heading <i>"May be substituted with elements"</i>.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>\n<p>\n<b>See Also Parameter:</b>\n<blockquote>\n<i>"Details | Component Documentation | Component Profile | Subst.Gr | List of group members"</i> \n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value.limited='false';
		param.default.expr='! getBooleanParam("doc.comp.profile.subst.members")';
	}
	PARAM={
		param.name='doc.comp.lists.childrenBySubst';
		param.title='Children By Substitutions';
		param.description='Specifies whether to generate the list of all known elements that may be included in the given element by substitutions.\n<p>\nIn particular, the list shows all members of the substitution groups whose head elements are declared in the content model of the given element component.\n<p>\nThe list will appear under the heading <i>"May contain elements by substitutions"</i>.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal & Local Elements\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.lists.parentsBySubst';
		param.title='Parents By Substitutions';
		param.description='Specifies whether to generate the list of all known elements that may include the given element by substitutions.\n<p>\nIn particular, the list shows all elements whose content models include the head element of a substitution group which the given element is member of. \n<p>\nThe list will appear under the heading <i>"May be included in elements by substitutions"</i>.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.lists.directSubtypes';
		param.title='Direct Subtypes';
		param.description='Specifies whether to generate the <b><i>List of Direct Subtypes</i></b>.\n<p>\nThis list is generated for each Simple/Complex Type Component. It shows all other type components that are directly derived from the given type component. \n<p>\n(A type is considered to be <i>directly derived</i> from the given type, when its definition contains an explicit reference to the given type).\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Simple Types</li>\n<li>Complex Types</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.indirectSubtypes';
		param.title='Indirect Subtypes';
		param.description='Specifies whether to generate the <b><i>List of Indirect Subtypes</i></b>.\n<p>\nThis list is generated for each Simple/Complex Type Component. It shows all other type components that are indirectly derived from the given type component. \n<p>\n(A type is considered to be <i>indirectly derived</i> from the given type, when its definition contains no explicit references to the given type but a reference to a certain third type that is directly or indirectly derived from the given type).\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Simple Types</li>\n<li>Complex Types</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.basedElements';
		param.title='All Based Elements';
		param.description='Specifies whether to generate the <b><i>List of All Based Elements</i></b>.\n<p>\nThis list is generated for each Simple/Complex Type Component. It shows all elements whose type is either the given type itself or directly/indirectly derived from the given type.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Simple Types</li>\n<li>Complex Types</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.lists.basedAttributes';
		param.title='All Based Attributes';
		param.description='Specifies whether to generate the <b><i>List of All Based Attributes</i></b>.\n<p>\nThis list is generated for each Simple Type Component. It shows all attributes (defined both globally and locally) whose type is either the given type itself or directly/indirectly derived from the given type.\n<p>\n<b>Applies To:</b>\n<blockquote>\nSimple Types\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage';
		param.title='Usage / Definition Locations';
		param.description='Specifies whether to generate the <b><i>Usage Locations</i></b> report.\n<p>\nFor global components, this section shows where and how the given component  is used within this XML schema (where the component is defined) and within other XML schemas included in the documentation.\n<p>\nFor local elements, any usage locations are actually where the element is defined. So, the section is called <b><i>Definition Locations</i></b>.';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which components the <i>"Type Definition Detail"</i> section must be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.usage.for.element.global';
		param.title='Global Elements';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.for.element.local';
		param.title='Local Elements';
		param.title.style.italic='true';
		param.description='Specifies whether to generate the <b><i>Definition Locations</i></b> report for local element components.\n<p>\nThis section shows all definition locations where the given local element is defined.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"always"</i>\n<blockquote>\nGenerate the definition locations report for all local elements.\n</blockquote>\n\n<i>"multiple only"</i>\n<blockquote>\nGenerate this section only for <i>"quasi-global"</i> local elements with multiple definition locations.\n<p>\nFor more details about how local elements are documented, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>\n\n<i>"never"</i>\n<blockquote>\nDo not generate the definition locations report.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<blockquote>\nLocal Elements\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='always;multiple;never';
		param.enum.displayValues='always;multiple only;never';
		param.default.value='multiple';
		param.default.value.limited='always';
	}
	PARAM={
		param.name='doc.comp.usage.for.complexType';
		param.title='Complex Types';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.for.simpleType';
		param.title='Simple Types';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.for.group';
		param.title='Element Groups';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.for.attribute';
		param.title='Global Attributes';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.usage.layout';
		param.title='List Layout';
		param.title.style.italic='true';
		param.description='This parameter controls how the list items are displayed.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"flow"</i>\n<dl><dd>\nThe list items will appear as a comma delimited text flow within a single paragraph.\n<p></p>\nThis layout produces a very compact representation of the list. However,\nit may be difficult to read, particularly when some items contain spaces.\n</dd></dl>\n\n<i>"two columns"</i>\n<dl><dd>\nThe list items will be arranged in a two-column table.\n<p></p>\nThis representation is better to read, however, it will occupy more space. It suits more for the lists, whose items are strings with spaces. It may be worse for the big lists made of short word items.\n</dd></dl>\n\n<i>"optimal"</i>\n<dl><dd>\nThis choice allows the list layout to be selected automatically (this is programmed in templates). If the list is expected to include items with spaces, the two-column layout will be used. Otherwise, the list is displayed as a comma separated text flow.\n</dd></dl>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='flow;two_columns;optimal';
		param.enum.displayValues='flow;two columns;optimal';
		param.default.value='optimal';
	}
	PARAM={
		param.name='doc.comp.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the component annotation (full annotation text).\n<p>\nThe annotation text is obtained from the &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code><b><i>xs:component</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nwhere <code><i>\'xs:component\'</i></code> is the particular XSD element which defines the component (e.g. <code>xs:complexType</code>). Multiple &lt;xs:documentation&gt; elements produce separate sections of the annotation text.\n\n<p>\n<b>Nested Parameters:</b>\n<dl><dd>\nIn the nested parameter group <i>"Generate For"</i>, you can specify precisely for which components the <i>"Annotation"</i> section will be generated.\n</dd></dl>\n\n<b>See Also:</b>\n<dl><dd>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.annotation.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which components the <i>"Annotation"</i> section must be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.annotation.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.description='Specify whether to generate the annotation section for <b>element</b> components (both global and local ones).';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.annotation.for.complexType';
		param.title='Complex Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate the annotation section for global <b>complex types</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.annotation.for.simpleType';
		param.title='Simple Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate the annotation section for global <b>simple types</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.annotation.for.group';
		param.title='Element Groups';
		param.title.style.italic='true';
		param.description='Specify whether to generate the annotation section for global <b>element groups</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.annotation.for.attribute';
		param.title='Global Attributes';
		param.title.style.italic='true';
		param.description='Specify whether to generate the annotation section for global <b>attributes</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.annotation.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
		param.description='Specify whether to generate the annotation section for global <b>attribute groups</b>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.type';
		param.title='Type Definition Detail';
		param.title.style.bold='true';
		param.description='Specify whether to generate the details about the definition of the type associated with (or represented by) the given component.\n<p>\nThis section may include:\n<ol>\n<li>\nThe <i>"Type Derivation Tree"</i> summary, which graphically depicts how this type was derived from the most basic types.\n</li>\n<li>\nThe type annotation (which is generated in the case of an element or attribute component).\n</li>\n<li>\nIn the case of a simple type (or a complex type with simple content), this section may also include all details about how the datatype was derived including all facets and annotations to them.\nWith the nested <i>"Simple Content Derivation"</i> parameter, you can specify whether to document in that way the entire type derivation tree produced by all known XML schema components involved.\n</li>\n</ol>\n\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Global Attributes</li>\n<li>Simple Types</li>\n<li>Complex Types</li>\n</ul>\n\n<b>Nested Parameters:</b>\n<dl><dd>\n<p>\nIn the nested parameter group <i>"Generate For"</i>, you can specify exactly for which components this section should be generated.\n<p></p>\nOther parameters control the section content.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.type.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which components the <i>"Type Definition Detail"</i> section must be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.type.for.element.type';
		param.title='Elements With Types';
		param.title.style.italic='true';
		param.description='Specify when the <i>"Type Definition Detail"</i> section should be generated for element components.\n\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"anonymous"</i>\n<blockquote>\nThe type details will be generated only in the case of an anonymous type.\n(The <i>anonymous type</i> is the one that is defined directly within the definition of the element component.)\n<p>\nThis is the default setting because the (non-anonymous) global types are supposed to be documented separately.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe definition of any element type (both global and anonymous) will be documented along with the element component.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the element type definition.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n</ul>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='anonymous;any;none';
	}
	PARAM={
		param.name='doc.comp.type.for.attribute.type';
		param.title='Attributes With Types';
		param.title.style.italic='true';
		param.description='Specify when the <i>"Type Definition Detail"</i> section should be generated for global attribute components.\n\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"anonymous"</i>\n<blockquote>\nThe type details will be generated only in the case of an anonymous type.\n(The <i>anonymous type</i> is the one that is defined directly within the definition of the attribute component.)\n<p>\nThis is the default setting because the (non-anonymous) global types are supposed to be documented separately.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe definition of any attribute type (both global and anonymous) will be documented along with the attribute component.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the attribute type definition.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Global Attributes</li>\n</ul>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='anonymous;any;none';
	}
	PARAM={
		param.name='doc.comp.type.for.type';
		param.title='Global Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate the <i>"Type Definition Detail"</i> for a global type component.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Simple Types</li>\n<li>Complex Types</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.type.deriv.tree';
		param.title='Type Derivation Tree';
		param.description='Specify whether to generate the <b><i>Type Derivation Tree</i></b> summary, which graphically depicts how this type was derived from the most basic types.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.type.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the type annotation.\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Global Attributes</li>\n</ul>\n<blockquote>\n(In the case of a simple/complex type component, the type annotation is already present in the component\'s <i>Annotation</i> section.)\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.type.deriv.simpleContent';
		param.title='Simple Content Derivation';
		param.description='Specify whether to generate the details about the derivation of the simple content datatype described by this type, including all facets and (possibly) annotations.\n<p>\n<i><b>Note:</b> This applies only to simple types and complex types with simple content.</i>\n\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"local definition only"</i>\n<blockquote>\nDocument the simple content derivation specified only within the definition of the given component itself  (i.e. the one being documented in this <i>Component Documentation</i>).\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nDocument the entire simple content derivation tree produced from all known XML schema components involved.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the derivation of simple content.\n</blockquote>\n\n<p>\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether the derivation details should include all annotations (e.g. facet annotations)\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='local;full;none';
		param.enum.displayValues='local definition only;full;none';
	}
	PARAM={
		param.name='doc.comp.type.deriv.simpleContent.facets';
		param.title='Facets';
		param.description='Specify whether to show <b>facets</b> specified in each derivation step.\n<p>\n<b>Note:</b> You may want to disable documenting every facet specified during the type derivation because all actual facets that restrict the component value/content may be already shown in the <i>Simple Content Detail</i> section (some facets specified later may override those specified earlier). See parameter: <i>"Details | Component Documentation | Simple Content Detail | Restrictions"</i>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.type.deriv.simpleContent.annotations';
		param.title='Annotations';
		param.description='Specifies whether the datatype derivation details should include all annotations (e.g. facet annotations)';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.xml';
		param.title='XML Source';
		param.title.style.bold='true';
		param.description='Specifies whether to reproduce within the component documentation the fragment of the XML schema source that defined the given component.\n<p>\n<b>Applies To:</b>\n<blockquote>\nAll components\n</blockquote>\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls how the reproduced XML source will look and what it should include.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xml.box';
		param.title='Enclose in Box';
		param.description='Specifies if the reproduced XML should be enclosed in a box.';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.xml.remove.anns';
		param.title='Remove Annotations';
		param.description='Specifies whether to remove all <b><code>&lt;xs:annotation&gt;</code></b> elements from the reproduced XML source fragment.\n<p>\nYou may want to exclude the <code>&lt;xs:annotation&gt;</code> elements from the reproduced XML source because such elements may occupy a lot of space (especially, when you use XHTML to format your annotations), so they could overwhelm anything else making it difficult to read other important things. Moreover, the actual content of the <code>&lt;xs:annotation&gt;</code> elements may be already shown (as a formatted text) in the corresponding <i>Annotation</i> sections of the documentation.\n\n<p>\n<b>See Also Parameters:</b>\n<ul>\n<li><i>"Details | Component Documentation | Annotation"</i></li>\n<li><i>"Processing | Annotations | Tags | XHTML"</i></li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.attributes';
		param.title='Attribute Detail';
		param.title.style.bold='true';
		param.description='Specifies whether to generate the <b><i>Attribute Detail</i></b> section, which documents the attribute declarations specified for the given component.\n<p>\nIn <i>"Generate For"</i> nested parameter group, you can select precisely for which components this section may be generated.\n<p>\nIn <i>"Include"</i> nested parameter group, you can specify which kinds of attribute definitions need to be documented:\n<ul>\n<li>specified in this component only</li>\n<li>inherited from ancestor components</li>\n<li>local attributes</li>\n<li>global attributes (specified by reference)</li>\n<li>wildcards</li>\n<li>prohibitions</li>\n</ul>\n\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Attribute Groups</li>\n</ul>\n\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls which kinds of attributes should be documented, for which components and how to document a particular attribute.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which components the <i>"Attribute Detail"</i> section must be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.attributes.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.description='Specify whether to generate <i>Attribute Detail</i> for elements.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.for.complexType';
		param.title='Complex Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate <i>Attribute Detail</i> for complex types.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.for.attributeGroup';
		param.title='Attribute Groups';
		param.title.style.italic='true';
		param.description='Specify whether to generate <i>Attribute Detail</i> for attribute groups.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.include';
		param.title='Include';
		param.title.style.italic='true';
		param.description='This parameter group controls which kinds of attribute definitions will be documented.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.attributes.include.local';
		param.title='Local';
		param.title.style.italic='true';
		param.description='Specify whether to document definitions of <b>local</b> attributes';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.include.references';
		param.title='References';
		param.title.style.italic='true';
		param.description='Specify whether to document <b>global</b> attributes specified by reference';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.include.wildcard';
		param.title='Wildcard';
		param.title.style.italic='true';
		param.description='Specify whether to document the attribute <b>wildcard</b> definitions.\n<p>\n<b>Note:</b> Only one wildcard defintion per a component may actual (and, therefore, documented).';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.include.prohibitions';
		param.title='Prohibitions';
		param.title.style.italic='true';
		param.description='Specify whether to document attribute <b>prohibitions</b>.\n<p>\nOnly prohibitions declared directly in this component may be documented.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.include.inherited';
		param.title='Inherited';
		param.title.style.italic='true';
		param.description='Specify whether to document in this section the definitions of attributes <b>inherited</b> from other (ancestor) components. \n<p>\nWhen this parameter is selected (<b><code>true</code></b>), both the attributes defined directly within this component itself and those inherited from other (ancestor) components will be documented together. This will result in repeating of the details of the same attributes defined in a certain component across the <i>component documentation</i> generated for each of its descendant components.\n<p>\nIf this parameter is unselected (<b><code>false</code></b>), only attributes specified directly within the definition of this component may be documented. Any other attributes that are inherited from other components will be documented only once together with their parent components (where they are defined). Only hyperlinks to the corresponding attribute details will lead from this component documentation (e.g. from the <i>XML Representation Summary</i>). This setting will produce a more compact documentation!';
		param.featureType='pro';
		param.type='boolean';
		param.default.value.limited='true';
	}
	PARAM={
		param.name='doc.comp.attributes.profile';
		param.title='Profile';
		param.description='Specifies whether to generate the <b><i>Attribute Profile</i></b> section, which contains summary information about the attribute (such as its type, possible usage, default or fixed value, definition location).\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Attribute Profile</i> section.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.profile.form';
		param.title='Form';
		param.description='Specify whether to document if the attribute name should be namespace-qualified or not.\n<p>\nAll attribute components defined globally have namespace-qualified names.\n<p>\nFor locally defined attribute components, their namespace qualification is specified by the <b><code>\'form\'</code></b> attribute of the component.\nWhen that attribute is absent, its default value is defined by the <b><code>\'attributeFormDefault\'</code></b> attribute of the parent <b><code>&lt;xs:schema&gt;</code></b>.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"any"</i>\n<blockquote>\nDocument the namespace-qualified form for all attribute components (both global and local ones).\n</blockquote>\n\n<i>"non-default only"</i>\n<blockquote>\nDocument the namespace-qualified form only for locally defined attribute components with the explicitly specified <code>\'form\'</code> attribute. (No default value of that attribute will be documented.)\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the namespace-qualified form of the attribute.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
		param.default.value='non_default';
	}
	PARAM={
		param.name='doc.comp.attributes.profile.type';
		param.title='Type';
		param.description='Specify whether to show the attribute type information.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.profile.use';
		param.title='Usage';
		param.description='Specify whether to show the possible usage of the attribute.\n<p>\nMore exactly, it is the value of the <code>\'use\'</code> attribute found in the XSD element defining the attribute (component). For example:\n<dl><dd>\n<code>\n&lt;xs:attribute name="refer" type="xs:QName" <b>use="required"</b>/&gt;\n</code>\n</dd></dl>\n\nWhen the <code>use</code> attribute is not specified, the default usage is <i>"optional"</i>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.profile.default';
		param.title='Default Value';
		param.description='Specify whether to show the attribute default value.\n<p>\nBy default, this parameter is switched off when <i>"Attribute Value | Default Value"</i> parameter is selected.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='! getBooleanParam("doc.comp.attributes.value") ||\n! getBooleanParam("doc.comp.attributes.value.default")';
	}
	PARAM={
		param.name='doc.comp.attributes.profile.fixed';
		param.title='Fixed Value';
		param.description='Specify whether to show the attribute fixed value.\n<p>\nBy default, this parameter is switched off when <i>"Attribute Value | Fixed Value"</i> parameter is selected.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='! getBooleanParam("doc.comp.attributes.value") ||\n! getBooleanParam("doc.comp.attributes.value.fixed")';
	}
	PARAM={
		param.name='doc.comp.attributes.profile.defined';
		param.title='Definition Location';
		param.description='Specify whether to show in which component this attribute is defined.\n<p>\nThe definition location may be different from this component (being documented by this <i>Component Documentation</i>) when the <i>"Attribute Detail"</i> parameter is set to <i>"all"</i> and the attribute is inherited from some of the ancestors of this component.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nBy default, this parameter is unselected when the <i>"Attribute Detail"</i> parameter is set to <i>"own only"</i>.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.expr='getBooleanParam("doc.comp.attributes.include.inherited")';
	}
	PARAM={
		param.name='doc.comp.attributes.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the attribute annotation (full annotation text).\n<p>\nThe annotation text is obtained from the &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code><b><i>xs:attribute</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nMultiple &lt;xs:documentation&gt; elements will produce separate sections of the annotation text.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.value';
		param.title='Attribute Value';
		param.description='Specify whether to generate the information about a possible attribute value.\nThis may include:\n<ol>\n<li>The <i>datatype model</i>. It shows how the attribute datatype is related to the XSD basic simple types.</li>\n<li>The value restrictions (that is all <i>actual facets</i>).</li>\n<li>The default value of the attribute.</li>\n<li>The fixed value of the attribute.</li>\n</ol>\n\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls generation of specific items\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.attributes.value.model';
		param.title='Datatype Model';
		param.description='Specify whether to generate the <i>datatype model</i>, which shows how the attribute datatype is related to the XSD basic simple types.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.value.restrictions';
		param.title='Restrictions';
		param.description='Specify whether to show all <b>actual facets</b> that restrict a possible value allowed for this attribute.\n<p>\nThe list of actual facets is produced as the following.\n<p>\nFirst, the initial facets are collected by all types starting from the type assigned to the attribute throughout the chain of all its ancestor types (both global and anonymous) until the top ancestor passed or a derivation by list or union reached.\n<p>\nFurther, the produced sequence of facets is filtered so as the facets collected earliest (that is defined in lower descendant types) remain and those overridden by them are removed. In particular:\n<ol>\n<li>\nAll <code>xs:pattern</code> facets will remain, because the attribute value must match all of them.\n</li>\n<li>\nThe <code>xs:enumeration</code> facets will remain those that are defined in the same type, which is either the attribute type itself or the one nearest to it.\n</li>\n<li>\nAll other facets will override the same facets defined in the ancestor types.\n</li>\n</ol>\n\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether to show the annotation of each facet.\n</dd></dl>\n\n<b>See Also:</b>\n<dl><dd>\nParameter <i>"Details | Component Documentation | Attribute Detail | Type Detail | Simple Content Derivation | Facets"</i>\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.value.restrictions.annotation';
		param.title='Annotations';
		param.description='Specify whether to include the facet annotations.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.value.default';
		param.title='Default Value';
		param.description='Specify whether to show the attribute default value.\n<p>\nThe default value is specified using <code>\'default\'</code> attribute of the XSD element defining the attribute component. For example:\n<dl><dd>\n<code>&lt;xs:attribute name="abstract" type="xs:boolean" <b>default="false"</b>/&gt;</code>\n</dd></dl>\n\nWhen the attribute is defined by reference, its default value may be specified both in the reference attribute component (which is being documented here) and in the global (referenced) attribute component. In that case, the actual default value will be looked for, first, in the reference component and, then, in the global one.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.value.fixed';
		param.title='Fixed Value';
		param.description='Specify whether to show the attribute fixed value.\n<p>\nThe fixed value is specified using <code>\'fixed\'</code> attribute of the XSD element defining the attribute component. For example:\n<dl><dd>\n<code>&lt;xs:attribute name="version" type="xs:string" <b>fixed="2.0"</b>/&gt;</code>\n</dd></dl>\n\nWhen the attribute is defined by reference, its fixed value can be specified either in the reference attribute component (which is being documented here) or in the global (referenced) attribute component. In that case, the <code>fixed</code> attribute is searched for in the both components.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.type';
		param.title='Type Detail';
		param.description='Specify whether to generate the details about the definition of the attribute type.\n<p>\nThis section may include:\n<ol>\n<li>\nThe <i>"Type Derivation Tree"</i> summary, which graphically depicts how the type was derived from the most basic types.\n</li>\n<li>\nThe type annotation.\n</li>\n<li>\nThe type derivation details, which include all facets and annotations to them.\nWith the nested <i>"Simple Content Derivation"</i> parameter, you can specify whether to document the entire datatype derivation tree produced from all known XML schema components involved.\n</li>\n</ol>\n\n<b>Nested Parameters:</b>\n<dl><dd>\n<p>\nIn the nested parameter group <i>"Generate For"</i>, you can specify exactly for which attributes this section should be generated.\n<p></p>\nOther parameters control the section content.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.type.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which attributes the <i>"Type Detail"</i> section must be generated.\n<p>\nEach parameter imposes a specific condition on the attribute and its type. The <i>"Type Detail"</i> section is generated when the conditions by all parameters in this group are satisfied.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.attributes.type.for.attr';
		param.title='Attributes';
		param.title.style.italic='true';
		param.description='Specify the possible scope of attributes for which the <i>"Type Detail"</i> section may be generated.\n\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"local only"</i>\n<blockquote>\nThe type details may be generated only for locally defined attributes.\n<p>\nThis is the default setting because the global attributes (with their types) are supposed to be documented separately.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe type details may be generated regardless of the attribute scope.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='local;any';
		param.enum.displayValues='local only;any';
	}
	PARAM={
		param.name='doc.comp.attributes.type.for.typeDecl';
		param.title='Type Declarations';
		param.title.style.italic='true';
		param.description='Specify the possible scope of the attribute type declaration for which the <i>"Type Detail"</i> section may be generated.\n\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"anonymous"</i>\n<blockquote>\nThe type details may be generated only in the case of an anonymous type.\n(The <i>anonymous type</i> is the one that is defined directly within the definition of the attribute component.)\n<p>\nThis is the default setting because the (non-anonymous) global types are supposed to be documented separately.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe type details should be generated for any attribute type (regardless of its declaration scope).\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='anonymous;any';
	}
	PARAM={
		param.name='doc.comp.attributes.type.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the attribute type annotation.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.attributes.type.deriv.tree';
		param.title='Type Derivation Tree';
		param.description='Specify whether to generate the <b><i>Type Derivation Tree</i></b> summary, which graphically depicts how the attribute type was derived from the most basic types.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.attributes.type.deriv.simpleContent';
		param.title='Simple Content Derivation';
		param.description='Specify whether to generate the details about the derivation of the attribute datatype, including all facets and (possibly) annotations.\n\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"local definition only"</i>\n<blockquote>\nDocument the datatype derivation specified only within the definition of this attribute\n(i.e. within the XSD <code>&lt;xs:attribute&gt;</code> element defining this attribute).\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nDocument the entire datatype derivation tree produced from all known XML schema components involved.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the datatype derivation.\n</blockquote>\n\n<p>\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether the derivation details should include all annotations (e.g. facet annotations)\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='local;full;none';
		param.enum.displayValues='local definition only;full;none';
	}
	PARAM={
		param.name='doc.comp.attributes.type.deriv.simpleContent.facets';
		param.title='Facets';
		param.description='Specify whether to show <b>facets</b> specified in each derivation step.\n<p>\n<b>Note:</b> You may want to disable documenting every facet specified during the type derivation because all actual facets that restrict the attribute value may be already shown in the <i>Attribute Value</i> section (some facets specified later may override those specified earlier). See parameter: <i>"Details | Component Documentation | Attribute Detail | Attribute Value | Restrictions"</i>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.attributes.type.deriv.simpleContent.annotations';
		param.title='Annotations';
		param.description='Specifies whether the datatype derivation details should include all annotations (e.g. facet annotations)';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.attributes.xml';
		param.title='XML Source';
		param.description='Specifies whether to reproduce the fragment of the XML schema source that defined this attribute.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls how the reproduced XML source will look and what it should include.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.xml.box';
		param.title='Enclose in Box';
		param.description='Specifies if the reproduced XML should be enclosed in a box.';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.attributes.xml.remove.anns';
		param.title='Remove Annotations';
		param.description='Specifies whether to remove all <b><code>&lt;xs:annotation&gt;</code></b> elements from the reproduced XML source fragment.\n<p>\nYou may want to exclude the <code>&lt;xs:annotation&gt;</code> elements from the reproduced XML source because such elements may occupy a lot of space (especially, when you use XHTML to format your annotations), so they could overwhelm anything else making it difficult to read other important things. Moreover, the actual content of the <code>&lt;xs:annotation&gt;</code> elements may be already shown (as a formatted text) in the corresponding <i>Annotation</i> sections of the documentation.\n\n<p>\n<b>See Also Parameters:</b>\n<ul>\n<li><i>"Details | Component Documentation | Annotation"</i></li>\n<li><i>"Processing | Annotations | Tags | XHTML"</i></li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.contentElements';
		param.title='Content Element Detail';
		param.title.style.bold='true';
		param.description='Specifies whether to generate the <b><i>Content Element Detail</i></b> section, which documents the elements declared in the element content model of the given component.\n<p>\nIn <i>"Generate For"</i> nested parameter group, you can select precisely for which components this section may be generated.\n<p>\nIn <i>"Include"</i> nested parameter group, you can specify which kinds of content element definitions need to be documented:\n<ul>\n<li>specified in this component only</li>\n<li>inherited from ancestor components</li>\n<li>local elements</li>\n<li>references to global elements</li>\n<li>wildcards</li>\n</ul>\n\n<p>\n<b>Applies To:</b>\n<ul>\n<li>Elements</li>\n<li>Complex Types</li>\n<li>Element Groups</li>\n</ul>\n\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls which kinds of content elements should be documented, for which components and how to document a particular content element.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which components the <i>"Content Element Detail"</i> section must be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.contentElements.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.description='Specify whether to generate <i>Content Element Detail</i> for element components.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.for.complexType';
		param.title='Complex Types';
		param.title.style.italic='true';
		param.description='Specify whether to generate <i>Content Element Detail</i> for complex types';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.for.group';
		param.title='Element Groups';
		param.title.style.italic='true';
		param.description='Specify whether to generate <i>Content Element Detail</i> for element groups';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.include';
		param.title='Include';
		param.title.style.italic='true';
		param.description='This parameter group controls which kinds of content element definitions will be documented.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.contentElements.include.local';
		param.title='Local';
		param.title.style.italic='true';
		param.description='Specify whether to document definitions of <b>local</b> elements';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.include.references';
		param.title='References';
		param.title.style.italic='true';
		param.description='Specify whether to document references to <b>global</b> elements';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.include.wildcards';
		param.title='Wildcards';
		param.title.style.italic='true';
		param.description='Specify whether to document the element <b>wildcard</b> definitions.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.include.inherited';
		param.title='Inherited';
		param.title.style.italic='true';
		param.description='Specify whether to document in this section the definitions of content elements <b>inherited</b> from other (ancestor) components. \n<p>\nWhen this parameter is selected (<b><code>true</code></b>), both the elements directly defined within this component itself and those inherited from other (ancestor) components will be documented together. This will result in repeating of the details of the same content elements defined in a certain component across the <i>component documentation</i> generated for each of its descendant components.\n<p>\nIf this parameter is unselected (<b><code>false</code></b>), only content elements specified directly within the definition of this component may be documented. Any other content elements that are inherited from other components will be documented only once together with their parent components (where they are defined). Only hyperlinks to the corresponding content element details will lead from this component documentation (e.g. from the <i>XML Representation Summary</i>). This setting will produce a more compact documentation!';
		param.featureType='pro';
		param.type='boolean';
		param.default.value.limited='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile';
		param.title='Profile';
		param.description='Specifies whether to generate the <b><i>Element Profile</i></b> section, which contains summary information about the element (such as its type, default or fixed value, definition location).\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls what exactly is included in the <i>Element Profile</i> section.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.form';
		param.title='Form';
		param.description='Specify whether to document if the element name should be namespace-qualified or not.\n<p>\nAll element components defined globally have namespace-qualified names.\n<p>\nFor locally defined element components, their namespace qualification is specified by the <b><code>\'form\'</code></b> attribute of the component.\nWhen that attribute is absent, its default value is defined by the <b><code>\'elementFormDefault\'</code></b> attribute of the parent <b><code>&lt;xs:schema&gt;</code></b>.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"any"</i>\n<blockquote>\nDocument the namespace-qualified form for all element components (both global and local ones).\n</blockquote>\n\n<i>"non-default only"</i>\n<blockquote>\nDocument the namespace-qualified form only for locally defined element components with the explicitly specified <code>\'form\'</code> attribute. (No default value of that attribute will be documented.)\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the namespace-qualified form of the element.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
		param.default.value='non_default';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.type';
		param.title='Type';
		param.description='Specify whether to show the element type information.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.abstract';
		param.title='Abstract';
		param.description='Specify whether to document <b><code>\'abstract\'</code></b> attribute of the element.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.block';
		param.title='Block';
		param.description='Specify whether to document <b><code>\'block\'</code></b> attribute of the element.\n<p>\n<b>Note:</b> For global elements, when <code>\'block\'</code> attribute is not specified, its default value is defined by the <b><code>\'blockDefault\'</code></b> attribute of the parent <b><code>&lt;xs:schema&gt;</code></b>.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"any"</i>\n<blockquote>\nDocument <code>block</code> attribute in any case both for the original and default value.\n</blockquote>\n\n<i>"non-default only"</i>\n<blockquote>\nDocument <code>block</code> attribute only in the case when it is specified on this element. (No default value will be documented.)\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document <code>block</code> attribute.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal & Local Elements\n</blockquote>\n\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>block</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
		param.default.value='non_default';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.block.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'block\'</code> attribute.\n<p>\n<b>Notes:</b>\n<ul>\n<li>\nFor global elements, when <code>\'block\'</code> attribute is not specified on the component, its value will be taken from the <b><code>\'blockDefault\'</code></b> attribute of the parent <code>&lt;xs:schema&gt;</code>.\n</li>\n<li>\nEmpty or blank value will be ignored (treated as no-value)\n</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.block.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the actual <code>\'block\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.final';
		param.title='Final';
		param.description='Specify whether to document <b><code>\'final\'</code></b> attribute of the element.\n<p>\n<b>Note:</b> When <code>final</code> attribute is not specified, its default value is defined by the <b><code>\'finalDefault\'</code></b> attribute of the parent <b><code>&lt;xs:schema&gt;</code></b>.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"any"</i>\n<blockquote>\nDocument <code>final</code> attribute in any case both for the original and default value.\n</blockquote>\n\n<i>"non-default only"</i>\n<blockquote>\nDocument <code>final</code> attribute only in the case when it is specified on this element. (No default value will be documented.)\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document <code>final</code> attribute.\n</blockquote>\n\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>\n\n<b>Nested Parameter Group:</b>\n<blockquote>\nSpecify how to document the <code>final</code> attribute value.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='any;non_default;none';
		param.enum.displayValues='any;non-default only;none';
		param.default.value='non_default';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.final.value';
		param.title='Value';
		param.description='Specify whether to show the actual value of the <code>\'final\'</code> attribute.\n<p>\n<b>Notes:</b>\n<ul>\n<li>\nWhen <code>\'final\'</code> attribute is not specified on the component, its value will be taken from the <b><code>\'finalDefault\'</code></b> attribute of the parent <code>&lt;xs:schema&gt;</code>.\n</li>\n<li>\nEmpty or blank value will be ignored (treated as no-value)\n</li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.final.meaning';
		param.title='Meaning';
		param.description='Specify whether to include the text explaining the meaning of the actual <code>\'final\'</code> attribute value.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.subst';
		param.title='Subst.Gr';
		param.description='Specify whether to show the information about the substitution groups, in which this element is involved (i.e. affiliated, head or member of). This may include:\n<ul>\n<li>\nThe list (or number) of elements which this element may substitute for.\n</li>\n<li>\nThe list (or number) of elements that may substitute for this element.</li>\n</ul>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>\n\n<b>Nested Parameter Group:</b>\n<blockquote>\nControls what exactly is included in the substitution group info.\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.subst.heads';
		param.title='List of group heads';
		param.description='Specify whether to show the list of the substitution group heads, which this element is member of. (In other words, these are the elements that this element may substitute for.)\n<p>\nWhen <b><code>false</code></b> (unselected), only the number of the substitutable elements will be printed along with the link to the <i>"May substitute for elements"</i> section in the Element Documentation (which, when specified, shows the same list).\n<p>\n<b>See Also Parameter:</b>\n<blockquote>\n<i>"Details | Component Documentation | List of Substitutable Elements"</i> \n<blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.subst.members';
		param.title='List of group members';
		param.description='Specify whether to show the list of the members of the substitution group, which this element is head of. (In other words, these are the elements that may substitute for this element.)\n<p>\nWhen <b><code>false</code></b> (unselected), only the number of the substituting elements will be printed along with the link to the <i>"May be substituted with elements"</i> section in the Element Documentation (which, when specified, shows the same list).\n<p>\n<b>See Also Parameter:</b>\n<blockquote>\n<i>"Details | Component Documentation | List of Substituting Elements"</i> \n<blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.default';
		param.title='Default Value';
		param.description='Specify whether to show the default value of the element simple content.\n<p>\nBy default, this parameter is switched off when <i>"Simple Content | Default Value"</i> parameter is selected.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='! getBooleanParam("doc.comp.contentElements.simpleContent") ||\n! getBooleanParam("doc.comp.contentElements.simpleContent.default")';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.fixed';
		param.title='Fixed Value';
		param.description='Specify whether to show the fixed value of the element simple content.\n<p>\nBy default, this parameter is switched off when <i>"Simple Content | Fixed Value"</i> parameter is selected.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.expr='! getBooleanParam("doc.comp.contentElements.simpleContent") ||\n! getBooleanParam("doc.comp.contentElements.simpleContent.fixed")';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.nillable';
		param.title='Nillable';
		param.description='Specify whether to document <b><code>\'nillable\'</code></b> attribute of the element component.\n<p>\n<b>Applies To:</b>\n<blockquote>\nGlobal Elements\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.profile.defined';
		param.title='Definition Location';
		param.description='Specify whether to show in which component this content element is defined.\n<p>\nThe definition location may be different from this component (being documented by this <i>Component Documentation</i>) when the <i>"Content Element Detail"</i> parameter is set to <i>"all"</i> and the element is inherited from some of the ancestors of this component.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nBy default, this parameter is unselected when the <i>"Content Element Detail"</i> parameter is set to <i>"own only"</i>.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.expr='getBooleanParam("doc.comp.contentElements.include.inherited")';
	}
	PARAM={
		param.name='doc.comp.contentElements.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the element annotation (full annotation text).\n<p>\nThe annotation text is obtained from the &lt;xs:documentation&gt; elements found by the following path:\n<dl><dd>\n<code><b><i>xs:element</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nMultiple &lt;xs:documentation&gt; elements will produce separate sections of the annotation text.\n\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Processing | Annotations"</i> parameter group, where you can specify how annotations are processed and displayed.\n</blockquote>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.xmlRep';
		param.title='XML Representation Summary';
		param.description='Specifies whether to generate the <b><i>XML Representation Summary</i></b> of the given content element.\n<p>\nThis section is the same as the one controlled by the parameter <i>"Details | Component Documentation | XML Representation"</i>. However, it is printed in a smaller font.\n<p>\n<b>Nested Parameters:</b>\n<dl><dd>\n<p>\nIn the nested parameter group <i>"Generate For"</i>, you can specify exactly for which content elements this section is generated.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
		param.default.expr='! getBooleanParam("gen.doc.element") ||\n! hasParamValue("gen.doc.element.local", "all")';
	}
	PARAM={
		param.name='doc.comp.contentElements.xmlRep.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which elements the <i>"XML Representation Summary"</i> section must be generated.\n<p>\nEach parameter imposes a specific condition on the element and its type. The section is generated when the conditions by all parameters in this group are satisfied.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.contentElements.xmlRep.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.description='Specify the possible scope of the elements for which the <i>XML Representation Summary</i> section may be generated.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"local only"</i>\n<blockquote>\nGenerate this section only for locally defined elements (i.e. not those specified by reference to a global element component).\n<p>\nYou may choose this setting when you prefer to document some (or all) of the local elements only locally so as most of the details about each local element are placed within the <i>"Content Element Detail"</i> section of the <i>Component Documentation</i> generated for the parent global component, where the element is defined (or used).\n<p>\nFor more details documenting of local elements, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nGenerate this section regardless of the element scope.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='local;any';
		param.enum.displayValues='local only;any';
		param.default.expr='getBooleanParam("gen.doc.element") ? "local" : "any"';
	}
	PARAM={
		param.name='doc.comp.contentElements.xmlRep.for.type';
		param.title='With Types';
		param.title.style.italic='true';
		param.description='Specify the possible types of elements for which the <i>XML Representation Summary</i> section may be generated.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"complex type"</i>\n<blockquote>\nThe section may be generated only for elements with complex types.\n</blockquote>\n\n<i>"simple type"</i>\n<blockquote>\nThe section may be generated only for elements with simple types.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nGenerate this section regardless of the element type.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='complexType;simpleType;any';
		param.enum.displayValues='complex type;simple type;any type';
		param.default.expr='hasParamValue("gen.doc.element.local", "complexType") ?\n "simpleType" : "any"';
	}
	PARAM={
		param.name='doc.comp.contentElements.xmlRep.heading';
		param.title='Show Heading';
		param.description='Specify whether to show the heading string: <i>"XML Representation Summary"</i>.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.xmlRep.sorting';
		param.title='Sorting';
		param.description='This parameter specifies sorting of attributes shown in the XML Representation Summary.\n<p>\nWhen selected (<b><code>true</code></b>) the attributes will be sorted in alphabetic order of their qualified names.\n<p>\nWhen unselected (<b><code>false</code></b>) the attributes will follow according to some <i>natural order</i> determined by how and where the attributes have been defined.\nIn a simplest case, when all attributes are defined within the same component, that will be exactly the order of their definitions. When the given component (whose attributes are represented) is based on other components, some of such ancestor components may define particular attributes (and even block some of those defined within their own ancestors). In that case, the result attribute ordering will appear from the subsequent interpretation of all involved components.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.simpleContent';
		param.title='Simple Content';
		param.description='<i><b>Note:</b> This parameter and the documentation section controlled by it apply only to elements with simple types or complex types with simple content.</i>\n<p>\nSpecify whether to generate the details of the element <b><i>simple content</i></b>.\nThis may include:\n<ol>\n<li>The <i>simple content model</i>. It shows how the element content datatype is related to the XSD basic simple types.</li>\n<li>The content restrictions (that is all <i>actual</i> facets).</li>\n<li>The default value of the element content.</li>\n<li>The fixed value of the element content.</li>\n</ol>\n\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls generation of specific items\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='doc.comp.contentElements.simpleContent.model';
		param.title='Content Model';
		param.description='Specify whether to generate the <i>simple content model</i>, which shows how the element content datatype is related to the XSD basic simple types.\n<dl>\n<dt><b>Note:</b></dt>\n<dd>\nSince <i>simple content model</i> is actually a part of the element <i>XML Representation Summary</i>, it will not be generated separately (regardless of the setting of this parameter), when the <i>"XML Representation Summary"</i> parameter is selected.\n</dd></dl>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.simpleContent.restrictions';
		param.title='Restrictions';
		param.description='Specify whether to show all <b>actual facets</b> that restrict a possible value allowed for the element simple content.\n<p>\nThe list of actual facets is produced as the following.\n<p>\nFirst, the initial facets are collected by all types starting from the type assigned to the element throughout the chain of all its ancestor types (both global and anonymous) until the top ancestor passed or a derivation by list or union reached.\n<p>\nFurther, the produced sequence of facets is filtered so as the facets collected earliest (that is defined in lower descendant types) remain and those overridden by them are removed. In particular:\n<ol>\n<li>\nAll <code>xs:pattern</code> facets will remain, because a value allowed for the given simple content must match all of them.\n</li>\n<li>\nThe <code>xs:enumeration</code> facets will remain those that are defined in the same type, which is either the element type itself or the one nearest to it.\n</li>\n<li>\nAll other facets will override the same facets defined in the ancestor types.\n</li>\n</ol>\n\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether to show the annotation of each facet.\n</dd></dl>\n\n<b>See Also:</b>\n<dl><dd>\nParameter <i>"Details | Component Documentation | Content Element Detail | Type Detail | Simple Content Derivation | Facets"</i>\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.simpleContent.restrictions.annotation';
		param.title='Annotations';
		param.description='Specify whether to include the facet annotations.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.simpleContent.default';
		param.title='Default Value';
		param.description='Specify whether to show the default value of the element content.\n<p>\nThe default value is specified using <code>\'default\'</code> attribute of the XSD element defining the element component. For example:\n<dl><dd>\n<code>\n&lt;xs:element name="Language" type="LanguageType" <b>default="English"</b>/&gt;</code>\n</dd></dl>\nWhen the element (with simple content) is defined by reference, its default value may be specified both in the reference element component (which is being documented here) and in the global (referenced) element component. In that case, the actual default value will be looked for, first, in the reference component and, then, in the global one.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.simpleContent.fixed';
		param.title='Fixed Value';
		param.description='Specify whether to show the fixed value of the element content.\n<p>\nThe fixed value is specified using <code>\'fixed\'</code> attribute of the XSD element defining the element component.\n<p>\nWhen the element is defined by reference, its fixed value can be specified either in the reference element component (which is being documented here) or in the global (referenced) element component. In that case, the <code>fixed</code> attribute is looked for in the both components.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.type';
		param.title='Type Detail';
		param.description='Specify whether to generate the details about the definition of the element type.\n<p>\nThis section may include:\n<ol>\n<li>\nThe <i>"Type Derivation Tree"</i> summary, which graphically depicts how the type was derived from the most basic types.\n</li>\n<li>\nThe type annotation.\n</li>\n<li>\nThe type derivation details, which include all facets and annotations to them.\nWith the nested <i>"Simple Content Derivation"</i> parameter, you can specify whether to document the entire datatype derivation tree produced from all known XML schema components involved.\n</li>\n</ol>\n\n<b>Nested Parameters:</b>\n<dl><dd>\n<p>\nIn the nested parameter group <i>"Generate For"</i>, you can specify exactly for which elements this section should be generated.\n<p></p>\nOther parameters control the section content.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
		param.default.expr='! getBooleanParam("gen.doc.element") ||\n! hasParamValue("gen.doc.element.local", "all")';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.for';
		param.title='Generate For';
		param.title.style.italic='true';
		param.description='The parameters in this group allows you to specify exactly for which elements the <i>"Type Detail"</i> section must be generated.\n<p>\nEach parameter imposes a specific condition on the element and its type. The <i>"Type Detail"</i> section is generated when the conditions by all parameters in this group are satisfied.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.for.element';
		param.title='Elements';
		param.title.style.italic='true';
		param.description='Specify the possible scope of the elements for which the <i>"Type Detail"</i> section may be generated.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"local only"</i>\n<blockquote>\nThe type details may be generated only for locally defined elements (i.e. not those specified by reference to a global element component).\n<p>\nYou may choose this setting when you prefer to document some (or all) of the local elements only locally so as most of the details about each local element are placed within the <i>"Content Element Detail"</i> section of the <i>Component Documentation</i> generated for the parent global component, where the element is defined (or used).\n<p>\nFor more details about documenting of local elements, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe type details may be generated regardless of the element scope.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='local;any';
		param.enum.displayValues='local only;any';
		param.default.expr='getBooleanParam("gen.doc.element") ? "local" : "any"';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.for.type';
		param.title='Types';
		param.title.style.italic='true';
		param.description='Specify for which element types the <i>"Type Detail"</i> section may be generated.\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"simple type"</i>\n<blockquote>\nThe type details may be generated only for simple types.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe type details may be generated for any types (both simple and complex).\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='simpleType;any';
		param.enum.displayValues='simple type;any';
		param.default.expr='getBooleanParam("gen.doc.element") &&\n  hasParamValue("gen.doc.element.local", "complexType")\n? "simpleType" : "any"';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.for.typeDecl';
		param.title='Type Declarations';
		param.title.style.italic='true';
		param.description='Specify the possible scope of the element type declaration for which the <i>"Type Detail"</i> section may be generated.\n\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"anonymous"</i>\n<blockquote>\nThe type details may be generated only in the case of an anonymous type.\n(The <i>anonymous type</i> is the one that is defined directly within the definition of the element component.)\n<p>\nThis is the default setting because the (non-anonymous) global types are supposed to be documented separately.\n</blockquote>\n\n<i>"any"</i>\n<blockquote>\nThe type details should be generated for any element type (regardless of its declaration scope).\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='anonymous;any';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.annotation';
		param.title='Annotation';
		param.description='Specify whether to include the element type annotation.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.deriv.tree';
		param.title='Type Derivation Tree';
		param.description='Specify whether to generate the <b><i>Type Derivation Tree</i></b> summary, which graphically depicts how the element type was derived from the most basic types.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.deriv.simpleContent';
		param.title='Simple Content Derivation';
		param.description='<i><b>Note:</b> This parameter and the documentation section controlled by it apply only to elements with simple types or complex types with simple content.</i>\n<p>\nSpecify whether to generate the details about the derivation of the element\'s <i>simple content</i> datatype, including all facets and (possibly) annotations.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"local definition only"</i>\n<blockquote>\nDocument the datatype derivation specified only within the definition of this element\n(i.e. within the XSD <code>&lt;xs:element&gt;</code> element defining this element component).\n</blockquote>\n\n<i>"full"</i>\n<blockquote>\nDocument the entire datatype derivation tree produced by all known XML schema components involved.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not document the datatype derivation.\n</blockquote>\n\n<p>\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether the datatype derivation details should include all annotations (e.g. facet annotations)\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='enum';
		param.enum.values='local;full;none';
		param.enum.displayValues='local definition only;full;none';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.deriv.simpleContent.facets';
		param.title='Facets';
		param.description='Specify whether to show <b>facets</b> specified in each derivation step.\n<p>\n<b>Note:</b> You may want to disable documenting every facet specified during the type derivation because all actual facets that restrict the component value/content may be already shown in the <i>Simple Content</i> section (some facets specified later may override those specified earlier). See parameter: <i>"Details | Component Documentation | Content Element Detail | Simple Content | Restrictions"</i>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.type.deriv.simpleContent.annotations';
		param.title='Annotations';
		param.description='Specifies whether the datatype derivation details should include all annotations (e.g. facet annotations)';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.xml';
		param.title='XML Source';
		param.description='Specifies whether to reproduce the fragment of the XML schema source that defined this content element.\n<p>\n<b>Nested Parameter Group:</b>\n<dl><dd>\nControls how the reproduced XML source will look and what it should include.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.xml.box';
		param.title='Enclose in Box';
		param.description='Specifies if the reproduced XML should be enclosed in a box.';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='doc.comp.contentElements.xml.remove.anns';
		param.title='Remove Annotations';
		param.description='Specifies whether to remove all <b><code>&lt;xs:annotation&gt;</code></b> elements from the reproduced XML source fragment.\n<p>\nYou may want to exclude the <code>&lt;xs:annotation&gt;</code> elements from the reproduced XML source because such elements may occupy a lot of space (especially, when you use XHTML to format your annotations), so they could overwhelm anything else making it difficult to read other important things. Moreover, the actual content of the <code>&lt;xs:annotation&gt;</code> elements may be already shown (as a formatted text) in the corresponding <i>Annotation</i> sections of the documentation.\n\n<p>\n<b>See Also Parameters:</b>\n<ul>\n<li><i>"Details | Component Documentation | Annotation"</i></li>\n<li><i>"Processing | Annotations | Tags | XHTML"</i></li>\n</ul>';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='show';
		param.title='Show';
		param.title.style.bold='true';
		param.description='The group of parameters to control generation of various small fragments (like parts of component names, specific sections etc.)';
		param.grouping='true';
	}
	PARAM={
		param.name='show.nsPrefix';
		param.title='Namespace Prefixes';
		param.description='Specify whether to add namespace prefixes to any XML names appearing in the generated documentation.\n<p style="margin:0">\n<table border="1">\n<tr><td><font face="Dialog" size="-1">\nAs you may know, each XML name is not just a string. Rather, it is a vector of two values: { <i>namespace URI</i>, <i>local name</i> }\n</font>\n</td></tr>\n</table>\n<p>\nAny namespace prefixes used in the output documentation originate from the namespace URI/prefix bindings declared in the source XSD files.\nFor a particular XML name, its namespace prefix is generated according to the binding for the given namespace found the nearest to the documentation context where that XML name appears.\n<p>\n<u>Example</u>:\n<p>\n Suppose you generate documentation for two XML schemas: <b><i>schema1</i></b> and <b><i>schema2</i></b>.\n<p>\nThe <i>schema1</i> is targeted to the namespace associated with <code>\'namespace_uri_1\'</code> URI, which is bound to <code>\'myns\'</code> prefix.\nThis schema defines some <b><i>MyType</i></b> type component.\n<p>\nThe <i>schema2</i> is targeted to a different namespace, however, it also uses <i>MyType</i>, which it imports from the <i>schema1</i>. To reference to that type, the <i>schema2</i> binds the <code>\'namespace_uri_1\'</code> to the prefix <code>\'ns1\'</code>, so <i>MyType</i> looks in it as:\n<dl><dd><code>ns1:MyType</code></dd></dl>\nHow will <i>MyType</i> look in the output documentation when this parameter is selected?\n<p>\nIn the parts of the documentation related to <i>schema1</i> you will see:\n<dl><dd><code>myns:MyType</code></dd></dl>\nIn parts related to <i>schema2</i>, you will see:\n<dl><dd><code>ns1:MyType</code></dd></dl>\nHowever, both names will be connected via hyperlinks to the same details of <i>MyType</i> type.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='show.localElementExt';
		param.title='Local Element Extensions';
		param.description='Specify whether to generate extended names of local elements.\n<p>\nThe extended name of a local element is made of its normal name extended with some short info about the possible element location or its type. For example:\n<dl><dd>\n<code>\nconfiguration (in plugin in plugins in reporting)<br>\nxs:complexType (type xs:localComplexType)\n</code>\n</dd></dl>\nhere in the brackets are the local element name extensions.\n<p>\nThe name extension is needed to distinguish that element in the documentation from other local elements, which share the same XML name, however have different content.\n<p>\nThe name extensions may be not necessary for local element with unique names.  For instance, some XML schemas are designed (or generated) so that almost all element components are declared locally, except only the root element. At that, all element names may be unique. So, the name extensions are not really needed and will only overload the documentation.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"always"</i>\n<blockquote>\nGenerate name extensions for all local elements.\n</blockquote>\n\n<i>"for repeating names only"</i>\n<blockquote>\nGenerate name extension only for local elements with non-unique names (i.e. whose XML names are shared by any other element components).\n</blockquote>\n\n<i>"never"</i>\n<blockquote>\nDo not generate the name extensions.\n</blockquote>\n\n<p>\n<b>See Also:</b>\n<blockquote>\nFor more details about how local elements are documented, please see description of the  parameter: <i>"Generate Details | Elements | Local Elements"</i>\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='always;repeating;never';
		param.enum.displayValues='always;for repeating names only;never';
	}
	PARAM={
		param.name='show.about';
		param.title='About (footer)';
		param.description='Specify whether to generate the <i>"About"</i> section added at the bottom of each generated document.\n<p>\nThis section shows certain information about the <b><i>"DocFlex/XML"</i></b> software and the <b><i>"XSDDoc"</i></b> template set, which power this XML Schema Documentation Generator.\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"full"</i>\n<blockquote>\nGenerate the detailed information.\n</blockquote>\n\n<i>"short"</i>\n<blockquote>\nGenerate only a brief notice.\n</blockquote>\n\n<i>"none"</i>\n<blockquote>\nDo not generate the <i>"About"</i> section.\n</blockquote>\n\n<p>\n<b>Note:</b>\n<blockquote>\nActually, all what you can see in the <i>"About"</i> section is generated entirely by the following template:\n<p>\n<code>XSDDoc/lib/about.tpl</code>\n<p>\nOnce you have acquired the full license for DocFlex/XML, you will be able to modify this template as you wish (as well as all other XSDDoc templates) so as to generate in the <i>"About"</i> section something of your own. For instance, to insert you company info, logotype, copyright statement about your software (your XML schema), etc.\n</blockquote>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='full;short;none';
		param.default.value='short';
		param.default.value.limited='full';
	}
	PARAM={
		param.name='proc';
		param.title='Processing';
		param.title.style.bold='true';
		param.description='This group of parameters controls processing of specific data obtained from XML schema (XSD) files.';
		param.grouping='true';
	}
	PARAM={
		param.name='proc.annotation';
		param.title='Annotations';
		param.title.style.bold='true';
		param.description='This group of parameters controls processing and formatting of annotations (the content of <b><code>&lt;xs:annotation&gt;</code></b> elements specified in XML schemas).\n<p>\nThe annotation text, which appears in a particular <i>"Annotation"</i> section of the generate documentation, is produced from all &lt;xs:documentation&gt; elements found by the path:\n<dl><dd>\n<code><b><i>xs:annotated</i></b>/xs:annotation/xs:documentation</code>\n</dd></dl>\nwhere <code><i>\'xs:annotated\'</i></code> is the XSD element which defines either the XML schema itself (<code>\'xs:schema\'</code>) or a schema component (e.g. <code>\'xs:complexType\'</code>) being documented.\n<p>\nMultiple &lt;xs:documentation&gt; elements will produce different sections of the annotation text.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='proc.annotation.appinfo';
		param.title='<appinfo>';
		param.title.style.bold='true';
		param.description='Specify whether to process <b><code>&lt;xs:appinfo&gt;</code></b> elements.\n<p>\nIf <code>true</code> (selected), all <code>&lt;xs:appinfo&gt;</code> elements will be treated the same way as <code>&lt;xs:documentation&gt;</code> elements.\n<p>\n<b>Nested Parameters:</b>\n<dl><dd>\nControl processing of specific attributes of <code>&lt;xs:appinfo&gt;</code> elements.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
	}
	PARAM={
		param.name='proc.annotation.appinfo.source';
		param.title='Source URI';
		param.description='Specify how to process the value of <code>source</code> attribute of <code>&lt;xs:appinfo&gt;</code> elements.\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"document as see-link"</i>\n<dl><dd>\nThe value will be documented in a section below annotation text looking as the following:\n<blockquote>\n<b>See:</b>&nbsp; <i><u>source-url-link</u></i>\n</blockquote>\n</dd></dl>\n\n<i>"document as annotation title"</i>\n<dl><dd>\nThe value will be documented as a title printed before annotation text obtained from this <code>&lt;xs:documentation&gt;</code> element.\n</dd></dl>\n\n<i>"no processing"</i>\n<dl><dd>\nThe value of <code>source</code> attribute will not be documented.\n</dd></dl>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='as_see_link;as_title;no';
		param.enum.displayValues='document as see-link;document as annotation title;no processing';
	}
	PARAM={
		param.name='proc.annotation.documentation';
		param.title='<documentation>';
		param.title.style.bold='true';
		param.description='Specify whether to process <b><code>&lt;xs:documentation&gt;</code></b> elements.\n<p>\nThe <code>&lt;xs:documentation&gt;</code> elements are primary holders of any information about the XML schema (components and etc.) intended for human readers.\n<p>\n<b>Nested Parameters:</b>\n<dl><dd>\nControl processing of specific attributes of <code>&lt;xs:documentation&gt;</code> elements.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='proc.annotation.documentation.lang';
		param.title='Language';
		param.description='When you annotate your XML schema simultaneously in different languages, this parameter will allow you to generate the documentation localized for only one of them (that is, only the annotations written in the selected language will be included in the documentation).\n<p>\n<u>Parameter Value</u>:\n<p>\nThe 2- or 3-letter code identifying the language.\nThis must be the same code which you have specified in the <b><code>\'xml:lang\'</code></b> attribute of the &lt;xs:documentation&gt; elements you want to process.\n<p>\nYou may also specify multiple language codes separated with semicolons (\';\'). For example:\n<dl><dd>\n<code>de;deu</code>\n</dd></dl>\nIn that case, only those &lt;xs:documentation&gt; elements will be processed, which contain the <code>\'xml:lang\'</code> attribute assigned with one of the specified language codes.\n<p>\nWhen this parameter is not specified (empty string), all sibling &lt;xs:documentation&gt; elements are processed, which will produce a single (however, multi-sectional) annotation text.\n<p>\n<u>Example</u>:\n<dl><dd>\n<pre><code>\n&lt;xs:annotation&gt;\n\n   &lt;xs:documentation xml:lang="en"&gt;\n      This description is in English...\n   &lt;/xs:documentation&gt;\n\n   &lt;xs:documentation xml:lang="de"&gt;\n      Die deutsche Beschreibung...\n   &lt;/xs:documentation&gt;\n\n&lt;/xs:annotation&gt;\n</code></pre>\n</dd></dl>\nWhen you specify <code>"de"</code> in this parameter, you will get in the documentation only this text: <i>"Die deutsche Beschreibung..."</i>\n\n<p>\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies an alternative language\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='string';
		param.trimSpaces='true';
		param.noEmptyString='true';
		param.list='true';
		param.list.noEmptyList='true';
	}
	PARAM={
		param.name='proc.annotation.documentation.lang.alt';
		param.title='Alternative Language';
		param.description='When the <i>"Language"</i> parameter is specified, only the &lt;xs:documentation&gt; elements marked with the specified language code(s) will be process. All others will be ignored.\n<p>\nHowever, you may have a situation that not all annotations in your XML schema are translated into a specific language. When you generate the documentation targeted to that language, it is preferable to have all descriptions written in it.  However, when such a localized description is missing, a description written in some basic language (e.g. English) would also suffice.\n<p>\nUsing this parameter you may specify such an alternative language.\n<p>\nThe value of this parameter must be specified the same way as of <i>"Language"</i> parameter.\n<p>\nFor example, let\'s suppose that in the <i>"Language"</i> parameter you have specified <code>"de"</code> and the value of this (<i>"Alternative Language"</i>) parameter is <code>"en"</code>. Then, when German annotations are found only them will get into the generated documentation. However, when a German annotation is missing and the English one exists, it will be used instead.';
		param.featureType='pro';
		param.type='string';
		param.trimSpaces='true';
		param.noEmptyString='true';
		param.list='true';
		param.list.noEmptyList='true';
	}
	PARAM={
		param.name='proc.annotation.documentation.source';
		param.title='Source URI';
		param.description='Specifies how to process the value of <code>source</code> attribute of <code>&lt;xs:documentation&gt;</code> elements.\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"document as see-link"</i>\n<dl><dd>\nThe value will be documented in a section below annotation text looking as the following:\n<blockquote>\n<b>See:</b>&nbsp; <i><u>source-url-link</u></i>\n</blockquote>\n</dd></dl>\n\n<i>"document as annotation title"</i>\n<dl><dd>\nThe value will be documented as a title printed before annotation text obtained from this <code>&lt;xs:documentation&gt;</code> element.\n</dd></dl>\n\n<i>"no processing"</i>\n<dl><dd>\nThe value of <code>source</code> attribute will not be documented.\n</dd></dl>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='as_see_link;as_title;no';
		param.enum.displayValues='document as see-link;document as annotation title;no processing';
	}
	PARAM={
		param.name='proc.annotation.tags';
		param.title='Tags';
		param.title.style.bold='true';
		param.description='The group of parameters to specify processing of non-XSD element tags embedded in the annotation text (i.e. within the content of &lt;xs:documentation&gt; elements).';
		param.grouping='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml';
		param.title='XHTML';
		param.description='Specify whether to process XHTML tags embedded in the annotation text.\n<p>\nXHTML tags are considered any XML elements that belong to XHTML namespace, which is associated with the following URI:\n<dl><dd>\n<code>http://www.w3.org/1999/xhtml</code>\n</dd></dl>\n(Specifically, this particular URI, which is used by the templates to identify the XHTML elements, is specified in <b><code>\'xsddoc.xmltype\'</code></b> configuration file, where you can change it when you need.)\n<p>\nWhen this parameter is <b><code>true</code></b> (checked), any XHTML elements will be converted to normal HTML tags (that is, the namespace prefix will be removed from each tag\'s name and everything else rewritten as it was). That will make the annotation text look as a fragment of normal HTML, which will be further inserted directly into the documentation output (in case of HTML) or rendered (in case of RTF). \n<p>\nWhen this parameter is <code><b>false</b></code> (unchecked), the XHTML elements will not be specifically processed in any way. The element tags will be simply removed or printed as normal text, which is controlled by <i>"Processing | Annotations | Tags | Show other tags"</i> parameter.\n\n<p>\n<b>Important:</b>\n<blockquote>\nTo have XHTML embedded in your annotations work, when generating documentation (both HTML and RTF), check also that <b><i>"Render embedded HTML"</i></b> option of the destination output format  is selected! (This is specified in the generator dialog.)\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.type='boolean';
		param.default.value='true';
		param.default.value.limited='false';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas';
		param.title='For schemas';
		param.title.style.italic='true';
		param.description='Specify for which schemas the XHTML markup in annotations should be processed.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas.include';
		param.title='Include';
		param.title.style.italic='true';
		param.description='Specify the list of XML schemas whose annotations may contain XHTML markup.\n<p>\nEach XML schema is specified with its file name (the last name in the pathname\'s name sequence, e.g. "xml.xsd"). Multiple file names should be separated with the allowed item separator (e.g. newline).\n<p>\nWhen this parameter is assigned (with a non-empty string specifying the schema list), the XHTML tags will be processed in annotations of only those schemas whose file names are found in that list.';
		param.featureType='pro';
		param.type='string';
		param.trimSpaces='true';
		param.collapseSpaces='true';
		param.noEmptyString='true';
		param.list='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.schemas.exclude';
		param.title='Exclude';
		param.title.style.italic='true';
		param.description='Specify the list of XML schemas whose annotations contain no XHTML markup (or it should ignored).\n<p>\nEach XML schema is specified with its file name (the last name in the pathname\'s name sequence, e.g. "xml.xsd"). Multiple file names should be separated with an allowed item separator (e.g. newline).\n<p>\nWhen this parameter is assigned (with a non-empty string specifying the schema list), the XHTML tags will be processed in annotations of only those schemas whose file names are <b>not</b> found in that list.';
		param.featureType='pro';
		param.type='string';
		param.trimSpaces='true';
		param.collapseSpaces='true';
		param.noEmptyString='true';
		param.list='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.images';
		param.title='Include Images';
		param.description='Controls whether to include images specified with the XHTML <code>&lt;img&gt;</code> tags.\n<p>\nIf this parameter is <code><b>true</b></code> (checked), all <code>&lt;img&gt;</code> tags will be processed and the images specified in them inserted in the generated documentation.\n<p>\nWhen the parameter is <code><b>false</b></code> (unchecked), the <code>&lt;img&gt;</code> tags will be recognized still, however just passed over without particular processing.\n<p>\n<b>Nested Parameter:</b>\n<dl><dd>\nSpecifies whether the images must be copied to the documentation destination directory.\n</dd></dl>';
		param.featureType='pro';
		param.grouping='true';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='proc.annotation.tags.xhtml.images.copy';
		param.title='Copy Images';
		param.description='Specifies whether the images embedded in the annotation text must be copied to the documentation destination directory.\n<p>\nIf this parameter is <code><b>true</b></code> (checked), all images referred from <code>&lt;img&gt;</code> tags will be automatically copied to the associated files directory (e.g. "doc-files") of the schema documentation. The <code>src</code> attribute of each <code>&lt;img&gt;</code> tag will be altered to point to the new image location.\n<p>\nWhen the parameter is <code><b>false</b></code> (unchecked), no images will be copied and the original image source URL in each <code>&lt;img&gt;</code> tag will be preserved.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='proc.annotation.tags.other';
		param.title='Other Tags';
		param.description='Controls what to do with any other XML tags that have not been specifically processed\nas XHTML markup.\n<p>\n<u>Possible Choices</u>:\n<p>\n<i>"show"</i>\n<dl><dd>\nAll unprocessed XML tags will appear in the generated documentation.\n</dd></dl>\n\n<i>"process as XHTML"</i>\n<dl><dd>\nThe unprocessed tags will be treated as XHTML tags.\n(The <i>"XHTML"</i> parameter should be also selected for this.)\n</dd></dl>\n\n<i>"no processing"</i>\n<dl><dd>\nAny unprocessed tags will be ignored.\n</dd></dl>';
		param.featureType='pro';
		param.type='enum';
		param.enum.values='show;xhtml;no';
		param.enum.displayValues='show;process as XHTML;no processing';
	}
	PARAM={
		param.name='proc.annotation.encode.markup.chars';
		param.title='Encode markup characters';
		param.description='Specifies whether to encode HTML markup characters contained in the annotation text.\n<p>\nThe following table shows all such characters and the entities into which they are encoded:\n<dl><dd>\n<table border="1">\n<tr bgcolor="#CCCCEE">\n  <td><b>Character</b></td>\n  <td><b>Entity</b></td>\n</tr>\n<tr>\n  <td align="center"><code>&lt;</code></td>\n  <td><code>&amp;lt;</code></td>\n</tr>\n<tr>\n  <td align="center"><code>&gt;</code></td>\n  <td><code>&amp;gt;</code></td>\n</tr>\n<tr>\n  <td align="center"><code>&amp;</code></td>\n  <td><code>&amp;amp;&nbsp;</code></td>\n</tr>\n</table>\n</dd></dl>\n</blockquote>\n<p>\n<b>Note:</b> The encoding will be done only when the output format supports rendering of embedded HTML, and it is switched on (see output format options).\n<p>\nThe purpose of this parameter is the following:\n<p>\n1. Suppose you use XHTML elements to format your annotations and some annotation contains a text like this:\n<blockquote><code>A &lt; B</code></blockquote>\nYou need to show the <code>\'&lt;\'</code> character as it is. Since the whole annotation will be converted into HTML, that character needs to be encoded. In that case, this parameter should be <b>selected</b>.\n<p>\n2. However, some XML schema authors do not rely on XHTML to format annotation (probably because few tools process it). Instead, they insert HTML markup directly into the annotation text, like the following:\n\n<dl><dd>\n<pre><code>\n&lt;xs:annotation&gt;\n   &lt;xs:documentation&gt;\n      This is &amp;lt;b&amp;gt;keyword&amp;lt;/b&amp;gt;\n   &lt;/xs:documentation&gt;\n&lt;/xs:annotation&gt;\n</code></pre>\n</dd></dl>\n\nAn XML parser will convert such an annotation text into the string:\n<dl><dd>\n<code>This is &lt;b&gt;keyword&lt;/b&gt;</code>\n</dd></dl>\nwhich could be immediately passed to an HTML viewer or added to HTML output. In that case, the HTML markup characters should not be encoded!\n<p>\nTherefore, if you have an XML schema like this, you should <b>unselect</b> this parameter.';
		param.featureType='pro';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='proc.annotation.show.part.headings';
		param.title='Show part headings';
		param.description='Specify, whether to generate multipart annotation headings.\n<p>\nA human-written description of an XML schema or schema component is generated from the content of an <code>&lt;xs:documentation&gt;</code> element found within the <code>&lt;xs:annotation&gt;</code> element that is direct child of an XSD element defining the schema or component. For example:\n<blockquote>\n<pre><code>\n&lt;xs:element name="SomeElement"&gt;\n  &lt;xs:annotation&gt;\n    &lt;xs:documentation&gt;\n      <font color="#008000"><i>element description</i></font>\n    &lt;xs:documentation&gt;\n  &lt;/xs:annotation&gt;\n  ...\n&lt;/xs:element&gt;\n</code></pre>\n</blockquote>\nHowever, <code>&lt;xs:annotation&gt;</code> elements are allowed to have multiple <code>&lt;xs:documentation&gt;</code> children (and <code>&lt;xs:schema&gt;</code> element may have even multiple <code>&lt;xs:annotation&gt;</code> children). In that case, the result description text will be produced from the content of all <code>&lt;xs:documentation&gt;</code> element found by the path:\n<dl><dd>\n<code><i>component</i>/annotation/documentation</code>\n</dd></dl>\nWhen the component description is generated from the content of multiple <code>&lt;xs:documentation&gt;</code> elements, each of them will produce a separate part of the entire description text. In that case, each part will have a separate heading, so the whole text will look like the following:\n<blockquote>\n<p>\n<b>Annotation 1:</b>\n<p>\n<i>Text 1...</i>\n<p>\n<b>Annotation 2:</b>\n<p>\n<i>Text 2 ...</i><br>\n...\n</blockquote>\nThis parameter allows you to suppress the generation of part headings, so the result text will be:\n<blockquote>\n<p>\n<i>Text 1...</i><br>\n<i>Text 2 ...</i><br>\n...\n</blockquote>';
		param.featureType='pro';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='proc.annotation.show.part.headings.schemas';
		param.title='For schemas';
		param.title.style.italic='true';
		param.description='Specify for which XML schemas the multipart annotation headings should be generated.';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='proc.annotation.show.part.headings.schemas.include';
		param.title='Include';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='string';
		param.trimSpaces='true';
		param.collapseSpaces='true';
		param.noEmptyString='true';
		param.list='true';
	}
	PARAM={
		param.name='proc.annotation.show.part.headings.schemas.exclude';
		param.title='Exclude';
		param.title.style.italic='true';
		param.featureType='pro';
		param.type='string';
		param.trimSpaces='true';
		param.collapseSpaces='true';
		param.noEmptyString='true';
		param.list='true';
	}
	PARAM={
		param.name='integration';
		param.title='Integrations';
		param.title.style.bold='true';
		param.description='The group of parameters to control integrations with other software tools';
		param.grouping='true';
		param.grouping.defaultState='collapsed';
	}
	PARAM={
		param.name='integration.xmlspy';
		param.title='XMLSpy';
		param.description='Enables XMLSpy Integration.\n<p>\nWhen <code>false</code>, XMLSpy won\'t be called.\n<p>\n<b>See Also:</b>\n<blockquote>\n<i>"Details | Component Documentation | Content Model Diagram"</i> parameter group\n</blockquote>';
		param.grouping='true';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='integration.xmlspy.showApp';
		param.title='Show Application';
		param.description='Specify whether to show XMLSpy application (IDE), when it is called to process XML schemas';
		param.type='boolean';
	}
	PARAM={
		param.name='integration.xmlspy.deleteTempDocs';
		param.title='Delete Temporary Docs';
		param.description='Specify whether to delete all files temporarily generated by XMLSpy.\n<p>\nThe integration of DocFlex/XML XSDDoc with XMLSpy works by calling XMLSpy to generate its own (reduced) documentation for each initially specified XML schema file. Further, that intermediate documentation is used by DocFlex/XML (the integration bridge) to obtain the diagram images (and hypertext maps to them) created by XMLSpy so as to insert them in the documentation output generated by XSDDoc. Once, XSDDoc finishes, the original XMLSpy documentation is not needed any longer and can be deleted. This parameter controls whether to delete or leave it.\n<p>\nAll temporary files produced by XMLSpy are stored in the directory\n<dl><dd>\n<code>{documentation_files}/xmlspy</code>\n</dd></dl>\nwhere <code>\'{documentation_files}\'</code> is either the main output directory (specified to the DocFlex generator) or the directory associated with the main output file.\n<p>\nThe documentation originally generated by XMLSpy for each initial XML schema is stored in a separate subdirectory within <code>xmlspy</code> under the name derived from the XML schema file\'s name, for example:\n<dl><dd>\n<code>{documentation_files}/xmlspy/schema-for-xslt20_xsd</code>\n</dd></dl>\n\nWhen this parameter is selected (<b><code>true</code></b>), the entire <code>\'xmlspy\'</code> subdirectory will be deleted on the finishing of XSDDoc. Otherwise, all XMLSpy generated docs will be left.';
		param.type='boolean';
		param.default.value='true';
	}
	PARAM={
		param.name='integration.xmlspy.diagramFormat';
		param.title='Diagram Format';
		param.description='Select the graphics format of the diagrams generated by XMLSpy.\n<p>\n<u>Possible Values</u>:\n<p>\n<i>"PNG"</i>\n<dl><dd>\nAll diagrams will be in PNG formats.\n<p>\nThis is the default format. It is best for HTML documentation. (However, in RTF/PDF documentation it will work as well.)\n</dd></dl>\n\n<i>"EMF"</i>\n<dl><dd>\nThe diagrams will be generated in <b>EMF</b> format. \n<p>\nThis format is more suitable for printable RTF/PDF documentation. (In case of HTML, the diagrams will be generated in EMF as well, however, whether you can see them will depend on your HTML browser.)\n<p><p>\n<b>Important:</b>\nThe generation of diagrams in EMF format is possible only since XMLSpy <b>2009</b> or later. (Although, XMLSpy itself supported EMF much earlier, they provided the Java API for it only since 2009.) Therefore, if you have an earlier version of XMLSpy and select "EMF" in this parameter, only PNG graphics will be generated instead.\n</dd></dl>';
		param.type='enum';
		param.enum.values='PNG;EMF';
	}
	PARAM={
		param.name='integration.xmlspy.fixCoords';
		param.title='Fix Imagemap Coordinates';
		param.description='Specify whether to correct <b>imagemap coordinates</b> generated by XMLSpy.\n<p>\nAs of the versions XMLSpy 2004-2009, all rectangle areas contained in the hypertext imagemaps associated with the content model diagrams generated by XMLSpy are shifted slightly to the top and left, which makes every clickable area to appear somewhat displaced from where it should be.\n<p>\nWe have found no rational purpose behind this and assumed that it was simply a bug. Therefore, we programmed a correction by adding <code>(+10,+5)</code> to every <code>(x,y)</code> coordinate found in the imagemaps.\n<p>\nNow, this works fine. But since it is likely the bug of XMLSpy, they may fix it some time later. In that case, our correction would actually produce a distortion by itself.\n<p>\nWith this parameter, you can disable any corrections. Unselect it (or specify <b><code>false</code></b>) to have only the original imagemap coordinates (generated by XMLSpy) used in the result documentation.';
		param.type='boolean';
		param.default.value='true';
	}
</TEMPLATE_PARAMS>
<FRAMESET>
	LAYOUT='columns'
	<FRAMESET>
		PERCENT_SIZE=20
		LAYOUT='rows'
		<FRAME>
			COND='documentByTemplate("overview-frame") != null'
			PERCENT_SIZE=30
			NAME='overviewFrame'
			SOURCE_EXPR='documentByTemplate("overview-frame")'
		</FRAME>
		<FRAME>
			COND='documentByTemplate (\n  "all-components-frame;\n   namespace-frame;\n   schema-frame"\n) != null'
			PERCENT_SIZE=70
			NAME='listFrame'
			SOURCE_EXPR='documentByTemplate (\n  "all-components-frame;\n   namespace-frame;\n   schema-frame"\n)'
		</FRAME>
	</FRAMESET>
	<FRAME>
		PERCENT_SIZE=80
		NAME='detailFrame'
		SOURCE_EXPR='documentByTemplate (\n "overview-summary; all-components-summary;\n  namespace-summary; schema-summary;\n  element; complexType; simpleType;\n  group; attribute; attributeGroup;\n  xmlns-bindings"\n)'
	</FRAME>
</FRAMESET>
<STYLES>
	CHAR_STYLE={
		style.name='Annotation';
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
		style.name='Code Smallest';
		style.id='cs4';
		text.font.name='Courier New';
		text.font.size='7.5';
	}
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs5';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Derivation Method';
		style.id='cs6';
		text.font.name='Verdana';
		text.font.size='8';
		text.color.foreground='#FF9900';
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
		par.padding.left='2.5';
		par.padding.right='2.5';
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
	}
	PAR_STYLE={
		style.name='Detail Heading 4';
		style.id='s4';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
		text.font.style.italic='true';
		text.color.background='#CCCCFF';
		text.color.opaque='true';
		par.margin.top='10';
		par.margin.bottom='6';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Detail Heading 5';
		style.id='s5';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='true';
		text.font.style.italic='true';
		text.color.background='#CCCCFF';
		text.color.opaque='true';
		par.margin.top='8';
		par.margin.bottom='8';
		par.page.keepWithNext='true';
	}
	PAR_STYLE={
		style.name='Frame Heading';
		style.id='s6';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.top='7';
		par.margin.bottom='3';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Heading Note';
		style.id='s7';
		text.font.name='Tahoma';
		text.font.size='6';
		text.font.style.bold='true';
		par.margin.top='0';
		par.margin.bottom='4';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Item';
		style.id='s8';
		text.font.size='9';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Title 1';
		style.id='s9';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.bottom='4';
		par.option.nowrap='true';
	}
	PAR_STYLE={
		style.name='Frame Title 2';
		style.id='s10';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.bottom='4';
		par.option.nowrap='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs7';
	}
	PAR_STYLE={
		style.name='List Heading 1';
		style.id='s11';
		text.font.name='Arial';
		text.font.size='10';
		text.font.style.bold='true';
		par.margin.top='12';
		par.margin.bottom='8';
	}
	PAR_STYLE={
		style.name='List Heading 2';
		style.id='s12';
		text.font.name='Arial';
		text.font.size='9';
		text.font.style.bold='true';
		par.margin.bottom='8';
	}
	PAR_STYLE={
		style.name='Main Heading';
		style.id='s13';
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
	}
	CHAR_STYLE={
		style.name='Name Modifier';
		style.id='cs8';
		text.font.name='Verdana';
		text.font.size='7';
		text.color.foreground='#B2B2B2';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s14';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Normal Smaller';
		style.id='cs9';
		text.font.name='Arial';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Normal Smallest';
		style.id='cs10';
		text.font.name='Arial';
		text.font.size='8';
	}
	CHAR_STYLE={
		style.name='Note Font';
		style.id='cs11';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='false';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Property Text';
		style.id='cs12';
		text.font.name='Verdana';
		text.font.size='8';
		par.lineHeight='11';
	}
	PAR_STYLE={
		style.name='Property Title';
		style.id='s15';
		text.font.name='Arial';
		text.font.size='8';
		text.font.style.bold='true';
		par.lineHeight='11';
		par.margin.right='7';
	}
	CHAR_STYLE={
		style.name='Property Title Font';
		style.id='cs13';
		text.font.size='8';
		text.font.style.bold='true';
		par.lineHeight='11';
		par.margin.right='7';
	}
	PAR_STYLE={
		style.name='Property Value';
		style.id='s16';
		text.font.name='Verdana';
		text.font.size='8';
		par.lineHeight='11';
	}
	CHAR_STYLE={
		style.name='Property Value Font';
		style.id='cs14';
		text.font.name='Verdana';
		text.font.size='8';
		par.lineHeight='11';
	}
	CHAR_STYLE={
		style.name='Summary Heading Font';
		style.id='cs15';
		text.font.size='12';
		text.font.style.bold='true';
	}
	CHAR_STYLE={
		style.name='XML Source';
		style.id='cs16';
		text.font.name='Verdana';
		text.font.size='8';
	}
</STYLES>
<ROOT>
	<TEMPLATE_CALL>
		COND='getBooleanParam("gen.doc.overview")'
		TEMPLATE_FILE='lib/overview-summary.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		COND='getBooleanParam("gen.doc.allcomps")'
		TEMPLATE_FILE='lib/all-components-summary.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
		SUPPRESS_EMPTY_FILE
	</TEMPLATE_CALL>
	<ELEMENT_ITER>
		DESCR='ITERATE BY ALL NAMESPACES (see "Processing | Iteration Scope" tab);\nnamespace URI is saved in \'nsURI\' variable (see "Processing | Init/Step/Finish | Step Expression" tab)'
		TARGET_ET='#CUSTOM'
		SCOPE='custom'
		ELEMENT_ENUM_EXPR='CustomElements (getElementMapKeys("namespaces"))'
		SORTING='by-value'
		SORTING_KEY={lpath='.',ascending}
		STEP_EXPR='uri = contextElement.value.toString();\nsetVar("nsURI", uri);\n\nnsFolder = makeFileName (uri);\nnsFolder = (nsFolder != "") ? nsFolder :  "global_namespace";\nsetVar("nsFolder", output.filesDir + "namespaces/" + nsFolder);'
		<BODY>
			<TEMPLATE_CALL>
				DESCR='namespace overview summary'
				COND='getBooleanParam("gen.doc.namespace")'
				TEMPLATE_FILE='lib/namespace/namespace-summary.tpl'
				PASSED_PARAMS={
					'nsURI','getVar("nsURI")';
				}
				OUTPUT_TYPE='document'
				OUTPUT_DIR_EXPR='getVar("nsFolder").toString()'
				PASSED_ROOT_ELEMENT_EXPR='rootElement'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				COND='getBooleanParam("gen.doc.namespace")'
				TEMPLATE_FILE='lib/namespace/namespace-frame.tpl'
				PASSED_PARAMS={
					'nsURI','getVar("nsURI")';
				}
				OUTPUT_TYPE='document'
				OUTPUT_DIR_EXPR='getVar("nsFolder").toString()'
				SUPPRESS_EMPTY_FILE
				PASSED_ROOT_ELEMENT_EXPR='rootElement'
			</TEMPLATE_CALL>
			<ELEMENT_ITER>
				DESCR='schema summaries'
				COND='getBooleanParam("gen.doc.schema")'
				TARGET_ET='xs:schema'
				SCOPE='custom'
				ELEMENT_ENUM_EXPR='findElementsByKey ("namespaces", getStringVar("nsURI"))'
				SORTING='by-expr'
				SORTING_KEY={expr='getXMLDocument().getAttrStringValue("xmlName")',ascending}
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						DESCR='schema overview summary'
						TEMPLATE_FILE='lib/schema/schema-summary.tpl'
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getStringVar("schemaFolder")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/schema/schema-frame.tpl'
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getStringVar("schemaFolder")'
						SUPPRESS_EMPTY_FILE
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='elements'
				COND='getBooleanParam("gen.doc.element")'
				FMT={
					table.sizing='Relative';
					table.cellpadding.both='3';
				}
				TARGET_ET='xs:%element'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema/descendant::xs:%element[instanceOf("xs:element") || ! hasAttr("ref") &&\n{\n  form = hasAttr("form") ? getAttrValue("form") :\n           findPredecessorByType("xs:schema").getAttrStringValue ("elementFormDefault");\n\n  (form == "qualified" || getVar("nsURI") == "")\n}]';
					'*[getStringVar("nsURI") == ""] -> {findElementsByKey ("namespaces", "")}::xs:%localElement';
				}
				FILTER_BY_KEY='/* Local elements with the same {name:type} signature\nmay appear in the initially generated scope many times,\nas many as the number of such element components. However,\nsince all local elements with the same name and global type\nare documented as a single quasi-global element, \nmultiple {name:type} entries must be reduced to only one. \nAll global elements and local elements with anonymous type\nmust be preserved in the list. So, for them the key must be \nunique for each component (e.g. GOMElement.id). \nThe following expression generates a necessary key. */\n\ninstanceOf ("xs:%localElement") &&\n  (typeQName = getAttrQNameValue("type")) != null ?\n{\n  HashKey (\n    getAttrStringValue("name"),\n    typeQName\n  )\n} : contextElement.id'
				FILTER='instanceOf("xs:element") ||\n{\n  // case of local element\n\n  local = getStringParam("gen.doc.element.local");\n  \n  local == "complexType" ?\n    ((typeQName = getAttrQNameValue("type")) != null) ?\n      findElementByKey ("types", typeQName).instanceOf("xs:complexType")\n    : hasChild("xs:complexType")\n  :\n  local == "all"\n}'
				SORTING='by-expr'
				SORTING_KEY={expr='callStockSection("Element Name")',ascending}
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/element/element.tpl'
						PASSED_PARAMS={
							'nsURI','getVar("nsURI")';
						}
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getStringVar("schemaFolder") + "elements"'
						FILE_NAME_EXPR='getAttrStringValue("name")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='complexTypes'
				COND='getBooleanParam("gen.doc.complexType")'
				FMT={
					table.sizing='Relative';
					table.cellpadding.both='3';
				}
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
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/type/complexType.tpl'
						PASSED_PARAMS={
							'nsURI','getVar("nsURI")';
						}
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getVar("schemaFolder") + "complexTypes"'
						FILE_NAME_EXPR='getAttrStringValue("name")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='simpleTypes'
				COND='getBooleanParam("gen.doc.simpleType")'
				FMT={
					table.sizing='Relative';
					table.cellpadding.both='3';
				}
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
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/type/simpleType.tpl'
						PASSED_PARAMS={
							'nsURI','getVar("nsURI")';
						}
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getVar("schemaFolder") + "simpleTypes"'
						FILE_NAME_EXPR='getAttrStringValue("name")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='element groups'
				COND='getBooleanParam("gen.doc.group")'
				FMT={
					table.sizing='Relative';
					table.cellpadding.both='3';
				}
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
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/groups/group.tpl'
						PASSED_PARAMS={
							'nsURI','getVar("nsURI")';
						}
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getVar("schemaFolder") + "groups"'
						FILE_NAME_EXPR='getAttrStringValue("name")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='global attributes'
				COND='getBooleanParam("gen.doc.attribute")'
				FMT={
					table.sizing='Relative';
					table.cellpadding.both='3';
				}
				TARGET_ET='xs:attribute'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> {findElementsByKey ("namespaces", getVar("nsURI"))}::xs:schema/xs:attribute';
				}
				SORTING='by-attr'
				SORTING_KEY={lpath='@name',ascending}
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/attribute/attribute.tpl'
						PASSED_PARAMS={
							'nsURI','getVar("nsURI")';
						}
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getVar("schemaFolder") + "attributes"'
						FILE_NAME_EXPR='getAttrStringValue("name")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
			<ELEMENT_ITER>
				DESCR='attribute groups'
				COND='getBooleanParam("gen.doc.attributeGroup")'
				FMT={
					table.sizing='Relative';
					table.cellpadding.both='3';
				}
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
				STEP_EXPR='setVar ("schemaFolder",\n  output.filesDir + "schemas/" +\n  getXMLDocument().getAttrStringValue("xmlName").replace (".", "_") + "/"\n)'
				<BODY>
					<TEMPLATE_CALL>
						TEMPLATE_FILE='lib/groups/attributeGroup.tpl'
						PASSED_PARAMS={
							'nsURI','getVar("nsURI")';
						}
						OUTPUT_TYPE='document'
						OUTPUT_DIR_EXPR='getVar("schemaFolder") + "attributeGroups"'
						FILE_NAME_EXPR='getAttrStringValue("name")'
						ASSOCIATED_FILES_DIR_EXPR='getVar("schemaFolder") + "doc-files"'
					</TEMPLATE_CALL>
				</BODY>
			</ELEMENT_ITER>
		</BODY>
	</ELEMENT_ITER>
	<TEMPLATE_CALL>
		COND='getBooleanParam("gen.doc.allcomps")\n||\n! getBooleanParam("gen.doc.namespace")\n&&\n! getBooleanParam("gen.doc.schema")'
		TEMPLATE_FILE='lib/all-components-frame.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
		SUPPRESS_EMPTY_FILE
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		TEMPLATE_FILE='lib/overview-frame.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
		SUPPRESS_EMPTY_FILE
	</TEMPLATE_CALL>
	<TEMPLATE_CALL>
		COND='getBooleanParam("gen.doc.xmlnsBindings")'
		TEMPLATE_FILE='lib/xml/xmlns-bindings.tpl'
		OUTPUT_TYPE='document'
		OUTPUT_DIR_EXPR='output.filesDir'
		SUPPRESS_EMPTY_FILE
	</TEMPLATE_CALL>
</ROOT>
<STOCK_SECTIONS>
	<AREA_SEC>
		MATCHING_ET='xs:%element'
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='Element Name'
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
						ATTR='name'
					</DATA_CTRL>
					<TEMPLATE_CALL_CTRL>
						MATCHING_ET='xs:%localElement'
						FMT={
							text.font.style.bold='false';
						}
						TEMPLATE_FILE='lib/element/localElementExt.tpl'
					</TEMPLATE_CALL_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<FOLDER>
		MATCHING_ET='#DOCUMENTS'
		SS_NAME='Finish'
		<BODY>
			<FOLDER>
				DESCR='Delete temporary docs generated by XMLSpy'
				COND='getBooleanParam("integration.xmlspy") &&\ndsm.imageProvider.class == "com.docflex.xml.xmlspy.SpyKit" &&\ngetBooleanParam("integration.xmlspy.deleteTempDocs")'
				INIT_EXPR='deleteDir (output.filesDir + "xmlspy")'
				<BODY>
				</BODY>
			</FOLDER>
		</BODY>
	</FOLDER>
	<FOLDER>
		MATCHING_ET='#DOCUMENTS'
		SS_NAME='Init'
		<BODY>
			<TEMPLATE_CALL>
				TEMPLATE_FILE='lib/init.tpl'
				OUTPUT_TYPE='document'
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				COND='getBooleanParam("integration.xmlspy") &&\ndsm.imageProvider.class == "com.docflex.xml.xmlspy.SpyKit"'
				TEMPLATE_FILE='lib/integrations/xmlspy.tpl'
				OUTPUT_TYPE='document'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='mq+Dg7omDXEY+bnWfFU8+SArj9mW4BbatL6P76aHkvo'
</DOCFLEX_TEMPLATE>