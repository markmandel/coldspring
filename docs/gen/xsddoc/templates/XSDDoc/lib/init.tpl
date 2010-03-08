<DOCFLEX_TEMPLATE VER='1.13'>
CREATED='2005-06-12 08:57:00'
LAST_UPDATE='2009-10-30 06:36:29'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-xml-xsddoc2'
APP_NAME='DocFlex/XML XSDDoc'
APP_VER='2.2.0'
APP_AUTHOR='Copyright \u00a9 2005-2009 Filigris Works,\nLeonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='ProcedureTemplate'
DSM_TYPE_ID='xsddoc'
ROOT_ET='#DOCUMENTS'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='gen.doc.for.schemas.initial';
		param.title='Initial';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.for.schemas.imported';
		param.title='Imported';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.for.schemas.included';
		param.title='Included';
		param.title.style.italic='true';
		param.type='boolean';
	}
	PARAM={
		param.name='gen.doc.for.schemas.redefined';
		param.title='Redefined';
		param.title.style.italic='true';
		param.type='boolean';
	}
</TEMPLATE_PARAMS>
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
	<ELEMENT_ITER>
		DESCR='associate the schema documents initially loaded from command line with their target namespaces as keys (to avoid repeating loading of them when they are imported/included in other schemas)'
		TARGET_ET='xs:schema'
		SCOPE='advanced-location-rules'
		RULES={
			'* -> #DOCUMENT/xs:schema';
		}
		STEP_EXPR='getXMLDocument().setAttr ("initial", true);\nmarkXMLDocument (getXMLAttribute("targetNamespace"))\n'
		<BODY>
		</BODY>
	</ELEMENT_ITER>
	<ELEMENT_ITER>
		DESCR='load all subschemas;\n\nadditionally, the following hash-maps are created (see tab: Processing | Init/Step/Finish | Init Expression):\n\n(1) "loaded-schema" \n\nMaps each <xs:import>/<xs:include>/<xs:redefine> element to the schema it loads. The hash-key is the ID of the referencing element. The result element is <xs:schema>.\n\n(2) "schema-loading-elements"\n\nMaps each schema to all <xs:import>/<xs:include>/<xs:redefine> elements referencing to it. The hash-key is the <xs:schema> element\'s id; the result is the enumeration of all elements referencing to that schema.\n\n(3) "redefined-component"\n\nMaps each redefining component (the one specified within <xs:redefine> element) to the original component it redefines. The hash-key is the redefining component\'s element id; the result is the element of the redefined component.\n\n(4) "redefining-components"\n\nMaps each original redefined component to all the components redefining it (those specified within <xs:redefine> elements). The hash-key is the original component\'s element id; the result is the enumeration of redefining component elements.\n\nNote: Actually, the presence of multiple components redefining the same original component would points to an erroneous situation. That would mean that the same subschema has been redefined in several locations with the same target namespace. This may happen when two different main schemas are being documented in a single documentation and both of them redefine the same subschema however in different ways. The current XSDDoc implementation treats all initial schemas as if they are imported from a single root XML schema. Therefore, such multiple redefinitions may cause wrong processing and produce incorrect documentation.'
		INIT_EXPR='createElementMap("loaded-schema");\ncreateElementMap("schema-loading-elements");\ncreateElementMap("redefined-component");\ncreateElementMap("redefining-components");\n'
		TARGET_ET='xs:schema'
		SCOPE='advanced-location-rules'
		RULES={
			'* -> #DOCUMENT/xs:schema';
		}
		<BODY>
			<SS_CALL>
				SS_NAME='Load Subschemas'
			</SS_CALL>
		</BODY>
	</ELEMENT_ITER>
	<FOLDER>
		DESCR='prepare hash-maps (element-maps)'
		<BODY>
			<ELEMENT_ITER>
				DESCR='\'namespaces\', \'global-elements\', \'types\', \'groups\', \'attributeGroups\', \'global-attributes\'\n--\nThe \'namespaces\' hash-map uses namespace URI as a key. It allows you to find all schemas to be documented (i.e. <xs:schema> elements) targeting a given namespace. For the global namespace (or "no-namespace" with the empty URI string), the hash-map also returns all local element components which have namespace-unqualified form and are defined in any other schemas (to be documented and whose target namespace is specified). Overall, the keys of \'namespaces\' hash-map represent all namespaces involved (i.e. targeted by XML schemas and components to be documented).\n--\nThe hash-maps \'global-elements\' and \'global-attributes\' are used to quickly find a corresponding global schema component by its full XML name: { namespaceURI, name }. The hash key is QName (namespaceURI, name)\n--\nThe hash-maps \'types\', \'groups\', \'attributeGroups\' are used to find a corresponding schema component by its full XML name: { namespaceURI, name } plus the value of "redefined" service attribute (see "Load Subschemas" stock-section | "process <xs:redefine>" folder section). \nThe hash key is \'HashKey (QName (namespaceURI, name), getServiceAttr ("redefined"))\', when the component has a "redefined" service attribute and \'QName (namespaceURI, name)\' otherwise.\n--\nThe hash-maps are initially created in "Processing | Init/Step/Finish | Init Expression" tab and populated in "Processing | Init/Step/Finish | Step Expression" tab (for each schema).'
				INIT_EXPR='createElementMaps (Array (\n  "namespaces",\n  "global-elements",\n  "types",\n  "groups",\n  "attributeGroups",\n  "global-attributes"\n))'
				TARGET_ET='xs:schema'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> #DOCUMENT/xs:schema';
				}
				STEP_EXPR='// \'contextElement\' points to the current schema !!\n\ntargetNamespace = getAttrStringValue ("targetNamespace");\nelementFormDefault = getAttrValue ("elementFormDefault");\n\n//-- update \'namespaces\' element-map\n\ndocument = getXMLDocument();\n\ndocument.hasAttr ("initial") &&\ngetBooleanParam("gen.doc.for.schemas.initial")\n||\ndocument.hasAttr ("imported") &&\ngetBooleanParam("gen.doc.for.schemas.imported")\n||\ndocument.hasAttr ("included") &&\ngetBooleanParam("gen.doc.for.schemas.included")\n||\ndocument.hasAttr ("redefined") &&\ngetBooleanParam("gen.doc.for.schemas.redefined") ? \n{\n  putElementByKey ("namespaces", targetNamespace, contextElement);\n\n  (targetNamespace != "") ? \n  {\n    putElementsByKey (\n      "namespaces",\n      "",\n      findElementsByLPath (\n        "descendant::xs:%localElement",\n        BooleanQuery (\n          ! hasAttr ("ref")\n          &&\n          (hasAttr("form") ? getAttrValue("form") : elementFormDefault) != "qualified"\n        )\n      )\n    )\n  }\n};\n\n// the key query used for global elements and attributes\nkeyQuery1 = FlexQuery (QName (targetNamespace, getAttrStringValue("name")));\n\n// the key query used for simple/complex types and element/attribute groups\nkeyQuery2 = FlexQuery ({\n  qName = QName (targetNamespace, getAttrStringValue("name"));\n  hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n});\n\n//-- update \'global-elements\' element-map\nputElementsByKeys ("global-elements", findChildren ("xs:element"), keyQuery1);\n\n//-- update \'types\' element-map\nputElementsByKeys ("types", findElementsByLPath ("descendant::(xs:simpleType | xs:complexType)"), keyQuery2);\n\n//-- update \'groups\' element-map\nputElementsByKeys ("groups", findElementsByLPath ("descendant::xs:group"), keyQuery2);\n\n//-- update \'attributeGroups\' element-map\nputElementsByKeys ("attributeGroups", findElementsByLPath ("descendant::xs:attributeGroup"), keyQuery2);\n\n//-- update \'global-attributes\' element-map\nputElementsByKeys ("global-attributes", findChildren ("xs:attribute"), keyQuery1);'
				<BODY>
				</BODY>
			</ELEMENT_ITER>
			<FOLDER>
				DESCR='\'local-elements\'\n--\nthe hash-map to find local element components by the specified full XML name:\n{ namespaceURI, name }.\n\nThe hash key is QName (namespaceURI, name)\n\nIt is possible that multiple element components in the schema may share the same name. In that case, several such components may be stored in the hash-map by the same { namespaceURI, name } key according to the following rules:\n\n(1) In the case of local elements with global types, for all element components with the same { namespaceURI : name : typeQName }, only one of them is stored in the map;\n\n(2) For local elements with anonymous types, all of them are stored in the map.'
				INIT_EXPR='prepareElementMap (\n  "local-elements",\n\n  // obtain elements to put in the map\n  findElementsByLPath (\n\n    // the location path for all local element components\n    "#DOCUMENT / xs:schema / descendant::xs:%localElement",\n\n    // remove references to global elements\n    BooleanQuery (getAttrValue("ref") == null),\n\n    // eliminate multiple local element components with the same\n    // { namespaceURI : name : typeQName }\n\n    FlexQuery (\n      (typeQName = getAttrQNameValue("type")) != null ?\n      {\n        schema = findPredecessorByType ("xs:schema");\n\n        HashKey (\n          ((hasAttr("form") ? getAttrValue("form") :\n             schema.getAttrValue ("elementFormDefault")) == "qualified" \n               ? schema.getAttrStringValue("targetNamespace") : ""),\n          getAttrStringValue("name"),\n          typeQName\n        )\n      } : contextElement.id\n    )\n  ),\n\n  // generating the hash key\n  FlexQuery ({\n    schema = findPredecessorByType ("xs:schema");\n\n    QName (\n      ((hasAttr("form") ? getAttrValue("form") :\n          schema.getAttrValue ("elementFormDefault")) == "qualified" \n            ? schema.getAttrStringValue("targetNamespace") : ""),\n      getAttrStringValue("name")\n    )\n  })\n)'
				<BODY>
				</BODY>
			</FOLDER>
			<FOLDER>
				DESCR='\'element-types\'\n--\nthe hash-map to find the type of a given element;\nthis also takes into account the type which the element may inherit from the substitution group head to which this element is affiliated.\n\nThe hash-key is the element component unique id (see \'GOMElement.id\' property). The mapped element is the type component (either global or local anonymous one).\n\nWhen the element\'s type cannot be resolved to any type component in the loaded XSD files, such a type is presented in the map by a custom element whose value is the QName object created by the type\'s qualified name: \nCustomElement (QName (typeQualifiedName))'
				INIT_EXPR='createElementMap("element-types");\n\n// iterate by all element components (except references)\niterate (\n  findElementsByLPath (\n    "#DOCUMENT / xs:schema / descendant::xs:%element",\n    BooleanQuery (getAttrValue("ref") == null)\n  ),\n  @elementVar,\n  FlexQuery ({\n\n    // for each element component resolve the element type\n\n    element = elementVar.toElement();\n\n    // when the \'type\' attribute is specified\n\n    ((typeQName = element.getAttrQNameValue ("type")) != null) ?\n    {\n      ((elementType = findElementByKey ("types", typeQName)) == null) ?\n        elementType = CustomElement (typeQName);\n\n    } : {\n      // otherwise, look for the locally defined anonymous type\n\n      ((elementType = element.findChild ("xs:complexType | xs:simpleType")) == null) ? \n      { \n        // If no type is explicitly specified, check if there is a substitution group affiliation\n        // (or the same for the found group\'s head element and so on) where the element type is specified.\n        // If a head with the type is found, use this type for the given element.\n\n        (element.getAttrValue("substitutionGroup") != null) ?\n        {\n          (headElement = element.findElementByLRules (\n            Array (\n              LocationRule (\n                \'* -> {findElementsByKey ("global-elements", getAttrQNameValue("substitutionGroup"))}::*\',\n                true\n              )\n            ),\n            "xs:element",\n            BooleanQuery (\n              getAttrValue("type") != null || hasChild ("xs:complexType | xs:simpleType")\n            )\n          )) != null ?\n          {\n            ((headTypeQName = headElement.getAttrQNameValue ("type")) != null) ?\n            {\n              ((elementType = findElementByKey ("types", headTypeQName)) == null) ?\n              {\n                // the head element does have type, however, it cannot be resolved to any type component\n                elementType = CustomElement (typeQName);\n              }\n            } : {\n              // if the head element has no \'type\' attribute, use its anonymous type\n              elementType = headElement.findChild ("xs:complexType | xs:simpleType");\n            }\n          }\n        };\n\n        // if no type is specified at all, assume \'xs:anyType\'\n\n        (elementType == null) ?\n          elementType = CustomElement (QName (getNamespaceURI ("xs"), "anyType"))\n      }\n    };\n\n    // store the type in the hashmap by the element\'s ID\n    putElementByKey ("element-types", element.id, elementType);\n  })\n)'
				<BODY>
				</BODY>
			</FOLDER>
			<FOLDER>
				DESCR='\'element-usage\'\n--\nthe hash-map to find all usage locations of a given element, which are:\n\n(*) For a global element: \n- all local components with the reference to that element;\n- all global elements with \'substitutionGroup\' attribute pointing to that element (this is resolved in the next section)\n\n(*) For a pseudo-global element representing a group of local element components with the same {namespace:name:type} -- all those local element components\n\n(*) For a local element with anonymous type -- that very local element component.\n\nThe hash-key is the the following:\n\n(1) For a pseudo-global element identified by {namespace, name, type}, the hash-key is the object:\nHashKey (namespaceURI, elementName, elementTypeQName);\n\n(2) For a global element or local element with anonymous type, the hash-key is the unique ID (see \'GOMElement.id\' property).'
				INIT_EXPR='prepareElementMap (\n  "element-usage",\n\n  findElementsByLPath ("#DOCUMENT / xs:schema / descendant::xs:%localElement"),\n\n  // generation of the element\'s key for "element-usage" map\n  FlexQuery ({\n\n    // the element for which the key should be generated is currently \n    // the generator\'s context element\n\n    // in case there\'s a reference to a global element\n\n    (elementQName = getAttrQNameValue("ref")) != null ? {\n\n      findElementByKey ("global-elements", elementQName).id \n\n    } : {\n\n      // when the type is specified     \n      (typeQName = getAttrQNameValue("type")) != null ? {\n\n        schema = findPredecessorByType ("xs:schema");\n\n        HashKey (\n          ((hasAttr("form") ? getAttrValue("form") :\n              schema.getAttrValue ("elementFormDefault")) == "qualified" \n                ? schema.getAttrStringValue("targetNamespace") : ""),\n          getAttrStringValue ("name"),\n          typeQName\n        ) \n\n      } : {\n        // the type is anonymous or no type\n        contextElement.id\n      }\n    }\n  })\n)'
				<BODY>
				</BODY>
			</FOLDER>
			<ELEMENT_ITER>
				DESCR='\'substitution-group-affiliates\', \'substitution-group-members\', \'substitution-group-heads\'\n--\n\'substitution-group-affiliates\' element-map allows finding all elements affiliated to a given substitution group head element. The hash-key is the element GOMElement.id. The affiliated elements are those whose \'substitutionGroup\' attribute is specified either with the given element or with another element affiliated to it. The affiliated element is not necessary a member of the same substitution group (headed by the given element). The actual membership may be blocked by \'block\' attributes. (However, the affiliated element may inherit its type from the head element.)\n--\n\'substitution-group-members\' element-map allows finding all members of the substitution group headed by a given element. The hash-key is GOMElement.id of the given element. The substitution group members are all or a subset of its affiliated elements.\n--\n\'substitution-group-heads\' element-map allows finding all substitution groups (i.e. their head elements) which a given element is member of. The hash-key is GOMElement.id of the given element.\n--\nThis Element Iterator initially iterates by all global element components which have a specified \'substitutionGroup\' attribute. The element maps are initially created in "Processing | Init/Step/Finish | Init Expression" tab.'
				INIT_EXPR='createElementMaps (Array (\n  "substitution-group-affiliates",\n  "substitution-group-members",\n  "substitution-group-heads"\n));'
				TARGET_ET='xs:element'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> #DOCUMENT/xs:schema/xs:element[hasAttr("substitutionGroup")]';
				}
				<BODY>
					<ELEMENT_ITER>
						DESCR='update all element maps for an element affiliated to a substitution group\n--\nThe Element Iterator is specified to iterate by all head elements which the given element (received in the context) is affiliated to. The element maps are updated in "Processing | Init/Step/Finish" tabs.'
						INIT_EXPR='// when there is at least one head element\n// (that is the initial value of \'substitutionGroup\' attribute\n// can be resolved to an element component)\n\niterator.numItems > 0 ?\n{\n  // currently, the affiliate is in the context element \n  // (the one received from the parent section)\n\n  // obtain the element type of the affiliate\n  affiliateType = findElementByKey ("element-types", contextElement.id);\n\n  // generate the type derivation path and save it in a variable for further usage\n  setVar (\n    "affiliateTypeDerivPath", \n    affiliateType.callStockSection("Type Derivation Path")\n  );\n\n  // the head element directly specified in the \'substitutionGroup\' attribute\n  // of the affiliate\n  directHead = iterator.itemAt(0).toElement();\n\n  // keep that the affiliate is one its usage locations\n  putElementByKey ("element-usage", directHead.id, contextElement);\n}'
						TARGET_ET='xs:element'
						SCOPE='advanced-location-rules'
						RULES={
							'* -> {findElementsByKey ("global-elements", getAttrQNameValue("substitutionGroup"))}::xs:element',recursive;
						}
						STEP_EXPR='affiliate = iterator.contextElement; // the affiliate element\nhead = contextElement; // the head of a substitution group it is affiliate to\n\n// keep that relation in the corresponding map\nputElementByKey ("substitution-group-affiliates", head.id, affiliate);\n\n// now determine if the affiliate can be a member of the head\'s substitution group;\n// if it\'s abstract it definitely cannot\n\n! affiliate.getAttrBooleanValue ("abstract") ?\n{\n  // the actual \'block\' value of the head\n  block = head.hasAttr ("block") ? head.getAttrValues ("block") :\n            head.findAncestor("xs:schema").getAttrValues ("blockDefault");\n\n  // if substituations of the head element are not entirely blocked\n\n  ! block.contains ("#all") && ! block.contains ("substitution") ?\n  {\n    // the type of the head element\n    headType = findElementByKey ("element-types", head.id);\n\n    // the derivation path of the head\'s type\n    headTypeDerivPath = headType.callStockSection("Type Derivation Path");\n\n    // the derivation path of the affiliate\'s type\n    affiliateTypeDerivPath = getStringVar ("affiliateTypeDerivPath");\n\n    // the affiliate\'s type must be either the same or derived from the head\'s type\n    affiliateTypeDerivPath.startsWith (headTypeDerivPath) ?\n    {\n      headTypeDerivPath.length() == 0  // the head\'s type is xs:anyType\n      ||\n      // the affiliate\'s type is the same as the head\'s type\n      (r = affiliateTypeDerivPath.substring (headTypeDerivPath.length())).length() == 0\n      ||\n      // otherwise, the affiliate\'s type is derived from the head\'s type;\n      // check that the derivation does not use the disallowed methods\n      r.startsWith ("/") && ! r.contains (\n      {\n        // collect disallowed derivation methods\n\n        disallowedDerivMethods = Vector();\n\n        // derivation by list is always disallowed\n        disallowedDerivMethods.addElement ("[list]");\n\n        // add blocked derivation methods\n        iterate (\n          block,\n          @derivMethod,\n          FlexQuery (\n            disallowedDerivMethods.addElement ("[" + derivMethod + "]")\n          )\n        );\n\n        // return vector of collected disallowed derivation methods\n        // as the parameter for the function call\n\n        disallowedDerivMethods\n      }) ? \n      {\n        // the affiliate is allowed to be member of the head\'s group;\n        // update corresponding hash-maps\n\n        putElementByKey ("substitution-group-heads", affiliate.id, head);\n        putElementByKey ("substitution-group-members", head.id, affiliate);\n      }\n    }\n  }\n}'
						<BODY>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</ELEMENT_ITER>
			<FOLDER>
				DESCR='\'content-model-elements\' -- the hash-map to find all content model elements (including wildcards) for a given schema component: \n\n- complexType (global or anonymous) \n- element group (global)\n\nThe hash-key is the component\'s GOMElement.id'
				INIT_EXPR='// Prepare Location Rules to obtain the content model elements\n// for a given: complexType or group\n\nrules = Array (\n  LocationRule (\n    \'xs:%complexType -> xs:complexContent / xs:extension / {\n        qName = getAttrQNameValue("base");\n        findElementsByKey (\n          "types",\n          hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n        )\n    }::xs:complexType\',\n    true\n  ),\n  LocationRule(\n    \'xs:%complexType -> xs:complexContent / (xs:extension | xs:restriction) / xs:%group\',\n    true\n  ),\n  LocationRule(\n    \'xs:%complexType -> xs:%group\',\n    true\n  ),\n  LocationRule(\n    \'xs:%group -> (xs:%element | xs:any | xs:%group)\',\n    true\n  ),\n  LocationRule(\n    \'xs:%groupRef -> {\n        qName = getAttrQNameValue("ref");\n        findElementsByKey (\n          "groups", \n          hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n        )\n    }::xs:group\',\n    true\n  )\n);\n\n// The subquery which produces an enumeration of the content model\n// elements for a given: complexType or group\n\nelemQuery = FlexQuery (findElementsByLRules (rules, "xs:%element | xs:any"));\n\n// Collect all schema components for which we want to hash the content model \n// elements in the hash-map\n\ncomponents = findElementsByLPath (\n  \'#DOCUMENT / xs:schema / descendant::xs:%complexType |\n   #DOCUMENT / xs:schema / xs:group | \n   #DOCUMENT / xs:schema / xs:redefine / xs:group\'\n);\n\n// Create the element-map. The hash key is the component\'s unique ID\n\nprepareElementMap (\n  "content-model-elements",\n  components,\n  FlexQuery (contextElement.id),\n  elemQuery\n)'
				<BODY>
				</BODY>
			</FOLDER>
			<FOLDER>
				DESCR='\'content-model-attributes\' -- the hash-map to find all attribute (including wildcards) components associated with a given schema complexType (global or anonymous) or attributeGroup (global).\n\nThe hash-key is the GOMElement.id of the schema component for which we want to find the attributes.'
				INIT_EXPR='// Prepare Location Rules to obtain possible attributes \n// for a given: complexType or attributeGroup\n\nrules = Array (\n\n  // the following two rules must be the first, because the attributes defined \n  // in ancestor complexTypes may be overridden in descendant ones\n\n  LocationRule (\n    \'xs:%complexType -> xs:complexContent / (xs:extension | xs:restriction) / {\n        qName = getAttrQNameValue("base");\n        findElementsByKey (\n          "types", \n          hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n        )\n    }::xs:complexType\',\n    true\n  ),\n  LocationRule (\n    \'xs:%complexType -> xs:simpleContent / (xs:extension | xs:restriction) / {\n        qName = getAttrQNameValue("base");\n        findElementsByKey (\n          "types", \n          hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n        )\n    }::xs:complexType\',\n    true\n  ),\n\n  LocationRule (\n    \'xs:%complexType -> xs:complexContent / (xs:extension | xs:restriction) /\n       (xs:attribute%xs:attribute | xs:anyAttribute | xs:%attributeGroupRef)\',\n    true\n  ),\n  LocationRule (\n    \'xs:%complexType -> xs:simpleContent / (xs:extension | xs:restriction) /\n       (xs:attribute%xs:attribute | xs:anyAttribute | xs:%attributeGroupRef)\',\n    true\n  ),\n  LocationRule (\n    \'xs:%complexType -> (xs:attribute%xs:attribute | xs:anyAttribute | xs:%attributeGroupRef)\',\n    true\n  ),\n  LocationRule (\n    \'xs:attributeGroup -> (xs:attribute%xs:attribute | xs:anyAttribute | xs:%attributeGroupRef)\',\n    true\n  ),\n  LocationRule (\n    \'xs:%attributeGroupRef -> {\n        qName = getAttrQNameValue("ref");\n        findElementsByKey (\n          "attributeGroups", \n          hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n        )\n    }::xs:attributeGroup\',\n    true\n  )\n);\n\n// The subquery which produces an enumeration of the possible attributes\n// for a given: complexType or attributeGroup\n\nattrQuery = FlexQuery ({\n\n  // First, produce the enumeration of all atribute declarations. \n  // The location rules are designed and intepreted so that the further an attribute \n  // is declared in the ancestor types chain the earlier it appears in the enumeration\n\n  e = findElementsByLRules (rules, "xs:%attribute | xs:anyAttribute");\n\n  // Now, remove from the produced enumeration those declarations that refer\n  // to the same attribute. The remaining ones will be those which appear the last.\n  // This is what we need, because an attribute declaration taken from the last \n  // descendant type may override settings specified for the same attribute in \n  // the ancestor types\n\n  filterElementsByKey (e, FlexQuery ({\n\n    // in case of anyAttribute the null key ensures that only last declaration will remain\n\n    instanceOf ("xs:anyAttribute") ? null : \n      ((attrQName = getAttrQNameValue("ref")) != null) ? attrQName : \n        QName ({\n          schema = findAncestor ("xs:schema");\n          (hasAttr("form") ? getAttrValue("form")\n                           : schema.getAttrValue ("attributeFormDefault")) == "qualified"\n            ? schema.getAttrStringValue("targetNamespace") : ""\n          },\n          getAttrStringValue("name")\n        )\n\n  }), BooleanQuery (true));\n});\n\n// Collect all schema components for which we want to hash the possible \n// contained attributes\n\ncomponents = findElementsByLPath (\n  \'#DOCUMENT / xs:schema / descendant::xs:%complexType |\n   #DOCUMENT / xs:schema / xs:attributeGroup | \n   #DOCUMENT / xs:schema / xs:redefine / xs:attributeGroup\'\n);\n\n// Create the hash-map. The hash key is the component\'s unique ID\n\nprepareElementMap (\n  "content-model-attributes",  \n  components, \n  FlexQuery (contextElement.id),\n  attrQuery\n)'
				<BODY>
				</BODY>
			</FOLDER>
			<ELEMENT_ITER>
				DESCR='\'containing-elements\', \'children-by-substitutions\', \'parents-by-substitutions\'\n--\n\'containing-elements\' is used to find all elements whose content model includes a given element.\n\nThe hash-key is the the following:\n\n(1) For a pseudo-global element identified by {namespace, name, type}, the hash-key is the object:\nHashKey (namespaceURI, elementName, elementTypeQName);\n\n(2) For a global element or local element with anonymous type, the hash-key is the unique ID (see \'GOMElement.id\' property).\n\n--\n\'children-by-substitutions\' is used to find all known elements that may be included in the given element by substitutions (that is all members of the substitution groups whose head elements are declared in the content model of the given element component). The hash-key is GOMElement.id of the given element.\n\n--\n\'parents-by-substitutions\' is used to find all known elements that may include the given element by substitutions. (In particular, these are all elements whose content models include the head element of a substitution group which the given element is member of.) The hash-key is GOMElement.id of the given element.'
				INIT_EXPR='createElementMaps (Array (\n  "containing-elements",\n  "children-by-substitutions",\n  "parents-by-substitutions"\n));'
				TARGET_ET='xs:%element'
				SCOPE='advanced-location-rules'
				RULES={
					'* -> #DOCUMENT/xs:schema/descendant::xs:%element[getAttrValue("ref") == null]';
				}
				FILTER_BY_KEY='instanceOf ("xs:%localElement") &&\n  (typeQName = getAttrQNameValue ("type")) != null ?\n{\n  schema = findAncestor ("xs:schema");\n\n  HashKey (\n    ((hasAttr("form") ? getAttrValue("form") :\n       schema.getAttrValue ("elementFormDefault")) == "qualified" \n         ? schema.getAttrStringValue("targetNamespace") : ""),\n    getAttrStringValue("name"),\n    typeQName\n  )\n} : contextElement.id'
				STEP_EXPR='setVar (\n  "containingElementKey",\n\n  instanceOf ("xs:%localElement") && \n    (typeQName = getAttrQNameValue ("type")) != null ?\n  {\n    schema = findAncestor ("xs:schema");\n\n    HashKey (\n      ((hasAttr("form") ? getAttrValue("form") :\n         schema.getAttrValue ("elementFormDefault")) == "qualified" \n           ? schema.getAttrStringValue("targetNamespace") : ""),\n      getAttrStringValue("name"),\n      typeQName\n    )\n  } : contextElement.id\n)'
				<BODY>
					<ELEMENT_ITER>
						DESCR='update element maps'
						TARGET_ET='xs:%element'
						SCOPE='advanced-location-rules'
						RULES={
							'* -> {findElementsByKey (\n  "content-model-elements", \n  findElementByKey ("element-types", contextElement.id).id\n)}::*';
							'xs:%localElement[getAttrValue("ref") != null] -> {findElementsByKey ("global-elements", getAttrQNameValue("ref"))}::xs:element',recursive;
						}
						FILTER_BY_KEY='instanceOf ("xs:%localElement") &&\n  (typeQName = getAttrQNameValue ("type")) != null ?\n{\n  schema = findAncestor ("xs:schema");\n\n  HashKey (\n    ((hasAttr("form") ? getAttrValue("form") :\n       schema.getAttrValue ("elementFormDefault")) == "qualified" \n         ? schema.getAttrStringValue("targetNamespace") : ""),\n    getAttrStringValue("name"),\n    typeQName\n  )\n} : contextElement.id'
						FILTER='getAttrValue("ref") == null'
						STEP_EXPR='containingElement = iterator.contextElement;\n\ninstanceOf ("xs:element") ? {\n\n  putElementByKey ("containing-elements", contextElement.id, containingElement);\n\n  (! containingElement.getAttrBooleanValue ("abstract")) ?\n  {\n    putElementsByKey (\n      "children-by-substitutions",\n      getVar ("containingElementKey"),\n      findElementsByKey ("substitution-group-members", contextElement.id)\n    );\n\n    putElementByKeys (\n      "parents-by-substitutions",\n      getElementIds (\n        findElementsByKey ("substitution-group-members", contextElement.id)\n      ),\n      containingElement\n    )\n  }\n\n} : {\n\n  putElementByKey (\n    "containing-elements", \n    ((typeQName = getAttrQNameValue ("type")) != null ?\n    {\n      schema = findAncestor ("xs:schema");\n\n      HashKey (\n        ((hasAttr("form") ? getAttrValue("form") :\n           schema.getAttrValue ("elementFormDefault")) == "qualified" \n             ? schema.getAttrStringValue("targetNamespace") : ""),\n        getAttrStringValue("name"),\n        typeQName\n      )\n    } : contextElement.id),\n    containingElement\n  )\n}'
						<BODY>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</ELEMENT_ITER>
			<FOLDER>
				DESCR='\'type-usage\'\n--\nallows finding for a given global type (complex or simple) all XSD locations where it is used. This includes:\n\n- all element and attribute components where it is specified in \'type\' attribute\n- all extension and restriction elements where the type is specified in \'base\' attribute\n- all <xs:list> elements where the type is specified in \'itemType\' attribute\n- all <xs:union> elements where the type is specified in \'memberTypes\' attribute\n\nThe hash-key is the type\'s GOMElement.id (a unique ID of the DSM element representing the global type).'
				INIT_EXPR='// prepare generation of the type keys for a particular location\nkeysQuery = FlexQuery ({\n\n  // direct type of an element or attribute\n  instanceOf ("xs:%element | xs:%attribute") ?\n    findElementByKey ("types", getAttrQNameValue("type")).id\n:\n  // extension or restriction base\n  instanceOf ("xs:%extensionType | xs:%restrictionType | xs:restriction") ? \n  {\n    qName = getAttrQNameValue("base");\n    findElementByKey (\n      "types", \n      hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n    ).id\n  }\n:\n  // list item\n  instanceOf ("xs:list") ? findElementByKey ("types", getAttrQNameValue("itemType")).id\n:\n  // union members\n  instanceOf ("xs:union") ?\n    getElementIds (findElementsByKeys ("types", getAttrQNameValues("memberTypes")))\n:\n  // neither of the above\n  null\n\n});\n\ne = findElementsByLPath (\n\n  // collect XSD components where types may be involved\n  "#DOCUMENT / xs:schema / descendant::(xs:%element | xs:%attribute | \n     xs:%extensionType | xs:%restrictionType | xs:restriction | xs:list | xs:union)",\n\n  // filter off attribute components with the prohibited use\n  BooleanQuery (\n    ! (instanceOf ("xs:%attribute") && getAttrValue ("use") == "prohibited")\n  ),\n\n  // eliminate repeating definition of local elements with \n  // the same name and the same type\n  FlexQuery (\n    instanceOf ("xs:%localElement") && \n      (typeQName = getAttrQNameValue ("type")) != null ?\n    {\n      schema = findAncestor ("xs:schema");\n\n      HashKey (\n        ((hasAttr("form") ? getAttrValue("form") :\n           schema.getAttrValue ("elementFormDefault")) == "qualified" \n             ? schema.getAttrStringValue("targetNamespace") : ""),\n        getAttrStringValue("name"),\n        typeQName\n      )\n    } : contextElement.id\n  )\n);\n\nprepareElementMap ("type-usage", e, keysQuery)'
				<BODY>
				</BODY>
			</FOLDER>
			<FOLDER>
				DESCR='\'group-usage\', \'attributeGroup-usage\', \'attribute-usage\'\n--\n\'group-usage\' allows finding all local <xs:group> elements where a given global element group is specified by reference. The hash-key is the group\'s GOMElement.id (a unique ID of the DSM element representing the group)\n--\n\'attributeGroup-usage\' allows finding all local <xs:attributeGroup> elements where a given global attribute group is specified by reference. The hash-key is the attribute group\'s GOMElement.id\n--\n\'attribute-usage\' allows finding all local <xs:attribute> elements where a given global attribute is specified by reference. The hash-key is the attribute\'s GOMElement.id'
				INIT_EXPR='prepareElementMap ("group-usage",\n  findElementsByLPath ("#DOCUMENT / xs:schema / descendant::xs:%groupRef"),\n  FlexQuery ({\n    qName = getAttrQNameValue("ref");\n    findElementByKey (\n      "groups", \n      hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n    ).id\n  }),\n  FlexQuery (findPredecessorByType ("xs:%element|xs:complexType|xs:group"))\n);\n\nprepareElementMap ("attributeGroup-usage",\n  findElementsByLPath ("#DOCUMENT / xs:schema / descendant::xs:%attributeGroupRef"),\n  FlexQuery ({\n    qName = getAttrQNameValue("ref");\n    findElementByKey (\n      "attributeGroups", \n      hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n    ).id\n  }),\n  FlexQuery (findPredecessorByType ("xs:%element|xs:complexType|xs:attributeGroup"))\n);\n\nprepareElementMap ("attribute-usage",\n  findElementsByLPath ("#DOCUMENT / xs:schema / descendant::xs:%attribute"),\n  FlexQuery (\n    findElementByKey ("global-attributes", getAttrQNameValue("ref")).id\n  )\n)'
				<BODY>
				</BODY>
			</FOLDER>
			<FOLDER>
				DESCR='\'direct-subtypes\', \'indirect-subtypes\'\n--\n\'direct-subtypes\' allows finding for a given global type all other global types whose definitions directly use it\n\n- as an extension / restiction base\n- as the itemType in a derivation by list\n- as the memberType in a derivation by union\n\nThe hash-key is the type\'s GOMElement.id\n\n--\n\'indirect-subtypes\' allows finding for a given global type all other global types whose definitions use any types derived from it. The hash-key is the type\'s GOMElement.id'
				INIT_EXPR='rule1 = \'xs:complexType -> (xs:simpleContent | xs:complexContent) / (xs:extension | xs:restriction) / {\n  qName = getAttrQNameValue("base");\n  findElementsByKey (\n    "types", \n    hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n  )\n}::(xs:complexType | xs:simpleType)\';\n\nrule2 = \'xs:simpleType -> descendant::xs:restriction / {\n  qName = getAttrQNameValue("base");\n  findElementsByKey (\n    "types", \n    hasServiceAttr ("redefined") ? HashKey (qName, getServiceAttr ("redefined")) : qName\n  )\n}::xs:simpleType\';\n\nrule3 = \'xs:simpleType -> descendant::xs:list / {\n  findElementsByKey ("types", getAttrQNameValue("itemType"))\n}::xs:simpleType\';\n\nrule4 = \'xs:simpleType -> descendant::xs:union / {\n  findElementsByKeys ("types", getAttrQNameValues("memberTypes"))\n}::xs:simpleType\';\n\nprepareElementMap ("direct-subtypes",\n  findElementsByLPath (\n    "#DOCUMENT / xs:schema / descendant::(xs:simpleType | xs:complexType)"\n  ),\n  FlexQuery (getElementIds (findElementsByLRules (\n    Array (\n      LocationRule (rule1, false), \n      LocationRule (rule2, false),\n      LocationRule (rule3, false),\n      LocationRule (rule4, false)\n    )\n  )))\n);\n\nprepareElementMap ("indirect-subtypes",\n  findElementsByLPath (\n    "#DOCUMENT / xs:schema / descendant::(xs:simpleType | xs:complexType)"\n  ),\n  FlexQuery ({\n    id = contextElement.id;\n    getElementIds (findElementsByLRules (\n      Array (\n        LocationRule (rule1, true), \n        LocationRule (rule2, true),\n        LocationRule (rule3, true),\n        LocationRule (rule4, true)\n      ),\n      "",\n      BooleanQuery (findPredecessorByType("xs:complexType|xs:simpleType").id != id)             \n    ))\n  })\n);'
				<BODY>
				</BODY>
			</FOLDER>
			<FOLDER>
				DESCR='\'derived-elements\', \'derived-attributes\'\n--\n\'derived-elements\' allows finding for a given global type all element components (both global and local ones) whose types are directly or indirectly derived from it. The hash-key is the type\'s GOMElement.id\n--\n\'derived-attributes\' allows finding for a given global type all attribute components (both global and local ones) whose types are directly or indirectly derived from it. The hash-key is the type\'s GOMElement.id'
				INIT_EXPR='createElementMap("derived-elements");\ncreateElementMap("derived-attributes");\n\niterate (\n  findElementsByLPath (\n    "#DOCUMENT / xs:schema / descendant::(xs:simpleType | xs:complexType)"\n  ),\n  @typeVar,\n  FlexQuery ({\n    type = typeVar.toElement();\n    typeId = type.id;\n\n    iterate (\n      Enum (\n        type,\n        findElementsByKey ("direct-subtypes", typeId),\n        findElementsByKey ("indirect-subtypes", typeId)\n      ),\n      @subtypeVar,\n      FlexQuery ({\n        subtype = subtypeVar.toElement();\n\n        locations = findElementsByKey (\n          "type-usage", \n          subtype.id,\n          BooleanQuery (instanceOf (\n            "xs:%element | xs:%attribute |\n             xs:%extensionType | xs:%restrictionType |\n             xs:list | xs:restriction | xs:union"\n          ))\n        );\n\n        iterate (\n          locations, \n          @loc,\n          FlexQuery ({\n            el = loc.toElement();\n\n            (! el.instanceOf ("xs:%element | xs:%attribute")) ?\n              el = el.findPredecessorByType("xs:%element|xs:%attribute");\n\n            el.instanceOf ("xs:%element") ?\n            {\n              putElementByKey ("derived-elements", typeId, el);\n\n              el.instanceOf ("xs:element") &&\n                checkElementsByKey ("substitution-group-affiliates", el.id) ?\n              {\n                iterate (\n                  findElementsByKey ("substitution-group-affiliates", el.id), \n                  @affiliateVar,\n                  FlexQuery ({\n                    affiliate = affiliateVar.toElement();\n                    affiliateType = findElementByKey ("element-types", affiliate.id);\n\n                    affiliateType.id == typeId ?\n                      putElementByKey ("derived-elements", typeId, affiliate);\n                  })\n                );\n              }\n\n            } : {\n              el.instanceOf ("xs:%attribute") ?\n                putElementByKey ("derived-attributes", typeId, el);\n            }\n          })\n        )\n      })\n    )\n  })\n)'
				<BODY>
				</BODY>
			</FOLDER>
		</BODY>
	</FOLDER>
</ROOT>
<STOCK_SECTIONS>
	<ELEMENT_ITER>
		MATCHING_ET='xs:schema'
		TARGET_ETS={'xs:import';'xs:include';'xs:redefine'}
		SCOPE='simple-location-rules'
		RULES={
			'* -> (xs:import|xs:include|xs:redefine)';
		}
		SS_NAME='Load Subschemas'
		<BODY>
			<SS_CALL>
				COND='getAttrStringValue("schemaLocation") != "" || getAttrStringValue("namespace") != ""'
				MATCHING_ET='xs:import'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='Load Subschemas'
				PASSED_ELEMENT_EXPR='schemaLocation = getAttrStringValue("schemaLocation");\n(schemaLocation == "") ? \n  schemaLocation = getAttrStringValue("namespace");\n\nuri = resolveURI (\n  schemaLocation,\n  getXMLDocument().getAttrStringValue("xmlURI")\n);\n\n((xsdDocument = findXMLDocument (uri)) == null) ?\n{\n  xsdDocument = loadXMLDocument (uri);\n  ((schema = xsdDocument->findChild ("xs:schema")) != null) ?\n  {\n    xsdDocument.setAttr ("imported", true);\n\n    putElementByKey ("loaded-schema", contextElement.id, schema);\n    putElementByKey ("schema-loading-elements", schema.id, contextElement);\n\n    (hasXMLAttribute("namespace")) ? \n      schema.setXMLAttribute ("targetNamespace", getXMLAttribute("namespace"));\n\n    schema\n  }\n} : {\n  ((schema = xsdDocument.findChild ("xs:schema")) != null) ? \n  {\n    xsdDocument.setAttr ("imported", true);\n\n    putElementByKey ("loaded-schema", contextElement.id, schema);\n    putElementByKey ("schema-loading-elements", schema.id, contextElement);\n  };\n\n  null // indicates that no futher processing of this schema is needed\n}'
				PASSED_ELEMENT_MATCHING_ET='xs:schema'
			</SS_CALL>
			<SS_CALL>
				COND='getAttrStringValue("schemaLocation") != ""'
				MATCHING_ET='xs:include'
				BREAK_PARENT_BLOCK='when-executed'
				SS_NAME='Load Subschemas'
				PASSED_ELEMENT_EXPR='uri = resolveURI (\n  getAttrStringValue("schemaLocation"),\n  getXMLDocument().getAttrStringValue("xmlURI")\n);\n\nloadingSchema = stockSection.contextElement;\ntargetNS = loadingSchema.getXMLAttribute("targetNamespace");\n\n((xsdDocument = findXMLDocument (uri, targetNS)) == null) ?\n{\n  xsdDocument = loadXMLDocument (uri, targetNS);\n  ((schema = xsdDocument->findChild ("xs:schema")) != null) ?\n  {\n    xsdDocument.setAttr ("included", true);\n\n    putElementByKey ("loaded-schema", contextElement.id, schema);\n    putElementByKey ("schema-loading-elements", schema.id, contextElement);\n\n    (targetNS != "") ? schema.setXMLAttribute ("targetNamespace", targetNS)\n                     : schema.removeXMLAttribute ("targetNamespace");\n    \n    (! schema.hasXMLAttribute("xmlns") && loadingSchema.hasXMLAttribute("xmlns")) ?\n      schema.setXMLAttribute("xmlns", loadingSchema.getXMLAttribute("xmlns"));\n\n    schema\n  }\n} : {\n  ((schema = xsdDocument.findChild ("xs:schema")) != null) ?\n  {\n    xsdDocument.setAttr ("included", true);\n\n    putElementByKey ("loaded-schema", contextElement.id, schema);\n    putElementByKey ("schema-loading-elements", schema.id, contextElement);\n  };\n\n  null // indicates that no futher processing of this schema is needed\n}'
				PASSED_ELEMENT_MATCHING_ET='xs:schema'
			</SS_CALL>
			<FOLDER>
				DESCR='process <xs:redefine>\n--\n1. First load the redefined schema (see "Processing | init Expression" tab).\n2. Then, load all subschemas referenced from it.\n\n3. Further, iterate by all component redefinitions (global types and element/attribute groups) found within <xs:redefine> element. For each redefinition do the following:\n\n3.1. Find the corresponding (original) component in the redefined schema and assign to it a "redefined" service attribute with the value equal to \'redefine_count\', which is the total number of <xs:redefine> elements already processed.\n\n3.2. When the component redefinition contains a reference to itself (that is to the original component), assign to that reference a "redefined" service attribute with the same \'redefine_count\' value.\n\nThese two steps ensure that the redefined component is referenced from the redifinition not just by the component qualified name (which is not unique now), but rather with { the qualified name; the value of "redefined" service attribute } pair, which will be unique and can be used as a key to find the corresponding DSM element representing the redefined (original) component. (See creation of \'types\', \'groups\', \'attributeGroups\' element maps in the main block.)\n\n3.3. Assign to the component redefinition a "redefinition" service attribute as the following:\n\n1). If the redefined component (the one found in the redefined schema) also has a "redefinition" service attribute that means it is a redefinition itself. In that case, take its "redefinition" attribute value (it must be already set). If it is 0, change it to 1, otherwise leave as is. Increase the result value by 1. That will be the "redefinition" attribute value of the new component redefinition.\n\n2). If the redefined component is trully original one, assign 0 to the "redefinition" attribute of component redefinition.\n\nThis ensures the following. If some component is a redefinition, it always has a "redefinition" attribute. When its value is 0, this is the only redefinition of the original component. If the attribute value is > 0, it will indicate the redefinition number. The last redefinition will have the greatest value of the "redefinition" attribute.'
				COND='getAttrStringValue("schemaLocation") != ""'
				MATCHING_ET='xs:redefine'
				INIT_EXPR='uri = resolveURI (\n  getAttrStringValue("schemaLocation"),\n  getXMLDocument().getAttrStringValue("xmlURI")\n);\n\nloadingSchema = stockSection.contextElement;\ntargetNS = loadingSchema.getXMLAttribute("targetNamespace");\n\n((xsdDocument = findXMLDocument (uri, targetNS)) == null) ? \n{\n  xsdDocument = loadXMLDocument (uri, targetNS);\n  ((schema = xsdDocument->findChild ("xs:schema")) != null) ? \n  {\n    xsdDocument.setAttr ("redefined", true);\n\n    putElementByKey ("loaded-schema", contextElement.id, schema);\n    putElementByKey ("schema-loading-elements", schema.id, contextElement);\n\n    (targetNS != "") ? schema.setXMLAttribute ("targetNamespace", targetNS)\n                     : schema.removeXMLAttribute ("targetNamespace");\n\n    (! schema.hasXMLAttribute("xmlns") && loadingSchema.hasXMLAttribute("xmlns")) ?\n      schema.setXMLAttribute("xmlns", loadingSchema.getXMLAttribute("xmlns"));\n  }\n} : {\n  ((schema = xsdDocument->findChild ("xs:schema")) != null) ?\n  {\n    xsdDocument.setAttr ("redefined", true);\n\n    putElementByKey ("loaded-schema", contextElement.id, schema);\n    putElementByKey ("schema-loading-elements", schema.id, contextElement);\n  }\n};\n\nstockSection.setVar ("redefined_schema", schema);\n\n! checkVar ("redefine_count") ? setVar ("redefine_count", 0);'
				FINISH_EXPR='incVar ("redefine_count", 1)'
				<BODY>
					<SS_CALL>
						DESCR='load all subschemas referenced from the redefined schema'
						SS_NAME='Load Subschemas'
						PASSED_ELEMENT_EXPR='stockSection.getElementVar ("redefined_schema")'
						PASSED_ELEMENT_MATCHING_ET='xs:schema'
					</SS_CALL>
					<ELEMENT_ITER>
						DESCR='iterates by simpleTypes specified within <redefine> element'
						TARGET_ET='xs:simpleType'
						SCOPE='simple-location-rules'
						RULES={
							'* -> xs:simpleType';
						}
						<BODY>
							<ELEMENT_ITER>
								DESCR='those types within the redefined schema are renamed by adding \'$ORIGINAL\' suffix\n(see tab: Processing | Init/Step/Finish | Step Expression)'
								CONTEXT_ELEMENT_EXPR='stockSection.getElementVar ("redefined_schema")'
								MATCHING_ET='xs:schema'
								TARGET_ET='xs:simpleType'
								SCOPE='advanced-location-rules'
								RULES={
									'* -> xs:simpleType';
									'* -> xs:redefine/xs:simpleType';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\n\nhasAttrValue("name", redefiningComp.getAttrStringValue("name")) ?\n{\n  setServiceAttr ("redefined", getVar ("redefine_count"));\n\n  putElementByKey ("redefining-components", contextElement.id, redefiningComp);\n  putElementByKey ("redefined-component", redefiningComp.id, contextElement);\n\n  hasServiceAttr ("redefinition") ?\n  {\n    (redef_no = getServiceAttr ("redefinition").toInt()) == 0 ?\n      setServiceAttr ("redefinition", (redef_no = 1));\n\n    redefiningComp.setServiceAttr ("redefinition", redef_no + 1)\n  } : {\n    redefiningComp.setServiceAttr ("redefinition", 0)\n  }\n}'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
							<ELEMENT_ITER>
								DESCR='self-references in <restriction> bases within a redefining type are also renamed'
								TARGET_ET='xs:restriction'
								SCOPE='simple-location-rules'
								RULES={
									'* -> descendant::xs:restriction';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\nschema = redefiningComp.findAncestor ("xs:schema");\n\nqName = getAttrQNameValue("base");\n\n(qName.localName == redefiningComp.getAttrStringValue("name") &&\n qName.namespaceURI == schema.getAttrStringValue("targetNamespace")) \n? \n setServiceAttr ("redefined", getVar ("redefine_count"));'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
						</BODY>
					</ELEMENT_ITER>
					<ELEMENT_ITER>
						DESCR='iterates by complexTypes specified within <redefine> element'
						TARGET_ET='xs:complexType'
						SCOPE='simple-location-rules'
						RULES={
							'* -> xs:complexType';
						}
						<BODY>
							<ELEMENT_ITER>
								DESCR='those types within the redefined schema are renamed by adding \'$ORIGINAL\' suffix\n(see tab: Processing | Init/Step/Finish | Step Expression)'
								CONTEXT_ELEMENT_EXPR='stockSection.getElementVar ("redefined_schema")'
								MATCHING_ET='xs:schema'
								TARGET_ET='xs:complexType'
								SCOPE='advanced-location-rules'
								RULES={
									'* -> xs:complexType';
									'* -> xs:redefine/xs:complexType';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\n\nhasAttrValue("name", redefiningComp.getAttrStringValue("name")) ?\n{\n  setServiceAttr ("redefined", getVar ("redefine_count"));\n\n  putElementByKey ("redefining-components", contextElement.id, redefiningComp);\n  putElementByKey ("redefined-component", redefiningComp.id, contextElement);\n\n  hasServiceAttr ("redefinition") ?\n  {\n    (redef_no = getServiceAttr ("redefinition").toInt()) == 0 ?\n      setServiceAttr ("redefinition", (redef_no = 1));\n\n    redefiningComp.setServiceAttr ("redefinition", redef_no + 1)\n  } : {\n    redefiningComp.setServiceAttr ("redefinition", 0)\n  }\n}'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
							<ELEMENT_ITER>
								DESCR='self-references in <restriction>/<extension> bases within a redefining type are also renamed'
								TARGET_ETS={'xs:extension%xs:extensionType';'xs:restriction%xs:complexRestrictionType'}
								SCOPE='simple-location-rules'
								RULES={
									'* -> descendant::(xs:extension%xs:extensionType|xs:restriction%xs:complexRestrictionType)';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\nschema = redefiningComp.findAncestor ("xs:schema");\n\nqName = getAttrQNameValue("base");\n\n(qName.localName == redefiningComp.getAttrStringValue("name") &&\n qName.namespaceURI == schema.getAttrStringValue("targetNamespace"))\n? \n setServiceAttr ("redefined", getVar ("redefine_count"));'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
						</BODY>
					</ELEMENT_ITER>
					<ELEMENT_ITER>
						DESCR='iterates by groups specified within <redefine> element'
						TARGET_ET='xs:group'
						SCOPE='simple-location-rules'
						RULES={
							'* -> xs:group';
						}
						<BODY>
							<ELEMENT_ITER>
								DESCR='those groups within the redefined schema are renamed by adding \'$ORIGINAL\' suffix\n(see tab: Processing | Init/Step/Finish | Step Expression)'
								CONTEXT_ELEMENT_EXPR='stockSection.getElementVar ("redefined_schema")'
								MATCHING_ET='xs:schema'
								TARGET_ET='xs:group'
								SCOPE='advanced-location-rules'
								RULES={
									'* -> xs:group';
									'* -> xs:redefine/xs:group';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\n\nhasAttrValue("name", redefiningComp.getAttrStringValue("name")) ?\n{\n  setServiceAttr ("redefined", getVar ("redefine_count"));\n\n  putElementByKey ("redefining-components", contextElement.id, redefiningComp);\n  putElementByKey ("redefined-component", redefiningComp.id, contextElement);\n\n  hasServiceAttr ("redefinition") ?\n  {\n    (redef_no = getServiceAttr ("redefinition").toInt()) == 0 ?\n      setServiceAttr ("redefinition", (redef_no = 1));\n\n    redefiningComp.setServiceAttr ("redefinition", redef_no + 1)\n  } : {\n    redefiningComp.setServiceAttr ("redefinition", 0)\n  }\n}'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
							<ELEMENT_ITER>
								DESCR='self-references within a redefining group are also renamed'
								TARGET_ET='xs:%groupRef'
								SCOPE='simple-location-rules'
								RULES={
									'* -> descendant::xs:%groupRef';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\nschema = redefiningComp.findAncestor ("xs:schema");\n\nqName = getAttrQNameValue("ref");\n\n(qName.localName == redefiningComp.getAttrStringValue("name") &&\n qName.namespaceURI == schema.getAttrStringValue("targetNamespace"))\n? \n setServiceAttr ("redefined", getVar ("redefine_count"));\n'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
						</BODY>
					</ELEMENT_ITER>
					<ELEMENT_ITER>
						DESCR='iterates by attributeGroups specified within <redefine> element'
						TARGET_ET='xs:attributeGroup'
						SCOPE='simple-location-rules'
						RULES={
							'* -> xs:attributeGroup';
						}
						<BODY>
							<ELEMENT_ITER>
								DESCR='those attributeGroups within the redefined schema are renamed by adding \'$ORIGINAL\' suffix (see tab: Processing | Init/Step/Finish | Step Expression)'
								CONTEXT_ELEMENT_EXPR='stockSection.getElementVar ("redefined_schema")'
								MATCHING_ET='xs:schema'
								TARGET_ET='xs:attributeGroup'
								SCOPE='advanced-location-rules'
								RULES={
									'* -> xs:attributeGroup';
									'* -> xs:redefine/xs:attributeGroup';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\n\nhasAttrValue("name", redefiningComp.getAttrStringValue("name")) ?\n{\n  setServiceAttr ("redefined", getVar ("redefine_count"));\n\n  putElementByKey ("redefining-components", contextElement.id, redefiningComp);\n  putElementByKey ("redefined-component", redefiningComp.id, contextElement);\n\n  hasServiceAttr ("redefinition") ?\n  {\n    (redef_no = getServiceAttr ("redefinition").toInt()) == 0 ?\n      setServiceAttr ("redefinition", (redef_no = 1));\n\n    redefiningComp.setServiceAttr ("redefinition", redef_no + 1)\n  } : {\n    redefiningComp.setServiceAttr ("redefinition", 0)\n  }\n}'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
							<ELEMENT_ITER>
								DESCR='self-references within the redefining attributeGroup are also renamed'
								TARGET_ET='xs:%attributeGroupRef'
								SCOPE='simple-location-rules'
								RULES={
									'* -> descendant::xs:%attributeGroupRef';
								}
								STEP_EXPR='redefiningComp = sectionBlock.contextElement;\nschema = redefiningComp.findAncestor ("xs:schema");\n\nqName = getAttrQNameValue("ref");\n\n(qName.localName == redefiningComp.getAttrStringValue("name") &&\n qName.namespaceURI == schema.getAttrStringValue("targetNamespace"))\n? \n setServiceAttr ("redefined", getVar ("redefine_count"));'
								<BODY>
								</BODY>
							</ELEMENT_ITER>
						</BODY>
					</ELEMENT_ITER>
				</BODY>
			</FOLDER>
		</BODY>
	</ELEMENT_ITER>
	<ELEMENT_ITER>
		FMT={
			sec.outputStyle='text-par';
			txtfl.delimiter.type='none';
		}
		TARGET_ETS={'#CUSTOM';'xs:%complexType';'xs:%simpleType'}
		SCOPE='advanced-location-rules'
		RULES={
			'(#CUSTOM|xs:%complexType|xs:%simpleType) -> .';
			'xs:%complexType -> {(base = getValueByLPath ("(xs:simpleContent|xs:complexContent) / (xs:restriction|xs:extension)/@base")) != null ?\n{ \n  typeQName = toQName (base);\n\n  ((el = findElementByKey ("types", typeQName)) == null) ?\n    el = CustomElement (typeQName);\n\n  Enum (el)\n}}::(#CUSTOM|xs:complexType|xs:simpleType)',recursive;
			'xs:%simpleType -> (xs:list|xs:restriction|xs:union)',recursive;
			'xs:restriction -> xs:simpleType',recursive;
			'xs:restriction -> {(typeQName = getAttrQNameValue("base")) != null ? \n{ \n  ((el = findElementByKey ("types", typeQName)) == null) ?\n    el = CustomElement (typeQName);\n\n  Enum (el)\n}}::(#CUSTOM|xs:simpleType)',recursive;
			'xs:list -> {(typeQName = getAttrQNameValue("itemType")) != null ? \n{ \n  ((el = findElementByKey ("types", typeQName)) == null) ?\n    el = CustomElement (typeQName);\n\n  Enum (el)\n}}::(#CUSTOM|xs:simpleType)',recursive;
			'xs:list -> xs:simpleType',recursive;
		}
		FILTER='instanceOf("xs:%localSimpleType") ?\n  contextElement == iterator.contextElement \n: \n! (instanceOf("#CUSTOM") &&\n  contextElement.value.toQName().isXSPredefinedType("anyType"))'
		SORTING='reversed'
		SS_NAME='Type Derivation Path'
		<BODY>
			<AREA_SEC>
				MATCHING_ET='#CUSTOM'
				BREAK_PARENT_BLOCK='when-executed'
				<AREA>
					<CTRL_GROUP>
						FMT={
							txtfl.delimiter.type='none';
						}
						<CTRLS>
							<DATA_CTRL>
								FORMULA='contextElement.value.toQName().fullName'
							</DATA_CTRL>
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='text';
									txtfl.delimiter.text='/';
								}
							</DELIMITER>
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
							<SS_CALL_CTRL>
								SS_NAME='Type Derivation Step'
							</SS_CALL_CTRL>
							<DATA_CTRL>
								FMT={
									ctrl.size.width='328.5';
									ctrl.size.height='17.3';
								}
								FORMULA='instanceOf("xs:simpleType | xs:complexType") ?\n{\n  nsURI = findAncestor ("xs:schema").getAttrStringValue("targetNamespace");\n  localName = getAttrStringValue("name");\n\n  (nsURI != "") ? "{" + nsURI + "}:" + localName : localName\n\n} : "<anonymousType>";'
							</DATA_CTRL>
							<DELIMITER>
								FMT={
									txtfl.delimiter.type='text';
									txtfl.delimiter.text='/';
								}
							</DELIMITER>
						</CTRLS>
					</CTRL_GROUP>
				</AREA>
			</AREA_SEC>
		</BODY>
	</ELEMENT_ITER>
	<FOLDER>
		MATCHING_ETS={'xs:%complexType';'xs:%simpleType'}
		FMT={
			sec.outputStyle='text-par';
		}
		SS_NAME='Type Derivation Step'
		<BODY>
			<FOLDER>
				MATCHING_ET='xs:%complexType'
				BREAK_PARENT_BLOCK='when-executed'
				<BODY>
					<AREA_SEC>
						CONTEXT_ELEMENT_EXPR='findChild ("xs:simpleContent | xs:complexContent")'
						MATCHING_ETS={'xs:complexContent';'xs:simpleContent'}
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										COND='hasChild ("xs:restriction")'
										TEXT='[restriction]'
									</LABEL>
									<LABEL>
										COND='hasChild ("xs:extension")'
										TEXT='[extension]'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
			<FOLDER>
				MATCHING_ET='xs:%simpleType'
				<BODY>
					<AREA_SEC>
						CONTEXT_ELEMENT_EXPR='findChild ("xs:restriction")'
						MATCHING_ET='xs:restriction'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								<CTRLS>
									<LABEL>
										TEXT='[restriction]'
									</LABEL>
									<SS_CALL_CTRL>
										COND='getAttrValue("base") == null'
										SS_NAME='Type Derivation Step'
										PASSED_ELEMENT_EXPR='findChild("xs:simpleType")'
										PASSED_ELEMENT_MATCHING_ET='xs:%localSimpleType'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						CONTEXT_ELEMENT_EXPR='findChild ("xs:list")'
						MATCHING_ET='xs:list'
						BREAK_PARENT_BLOCK='when-executed'
						<AREA>
							<CTRL_GROUP>
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										TEXT='[list]'
									</LABEL>
									<SS_CALL_CTRL>
										COND='getAttrValue("itemType") == null'
										SS_NAME='Type Derivation Step'
										PASSED_ELEMENT_EXPR='findChild("xs:simpleType")'
										PASSED_ELEMENT_MATCHING_ET='xs:%localSimpleType'
									</SS_CALL_CTRL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
					<AREA_SEC>
						COND='hasChild ("xs:union")'
						MATCHING_ET='xs:union'
						<AREA>
							<CTRL_GROUP>
								FMT={
									txtfl.delimiter.type='none';
								}
								<CTRLS>
									<LABEL>
										TEXT='[union]'
									</LABEL>
								</CTRLS>
							</CTRL_GROUP>
						</AREA>
					</AREA_SEC>
				</BODY>
			</FOLDER>
		</BODY>
	</FOLDER>
</STOCK_SECTIONS>
CHECKSUM='COxk3bsIBiqxRe8lNcfePFzkkPsr4RS7SUqK4q42ED0'
</DOCFLEX_TEMPLATE>