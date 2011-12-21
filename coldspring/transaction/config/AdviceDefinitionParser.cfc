<!---
	Copyright 2011 Mark Mandel

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--->

<cfcomponent hint="Parser for tx:advice elements, sets up transaction interceptors" implements="coldspring.beans.xml.BeanDefinitionParser" output="false">

<cfscript>
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};

		const.TRANSACTION_INTERCEPTOR_CLASS = "coldspring.transaction.interceptor.TransactionInterceptor";

		const.ADVICE_ELEMENT = "advice";
		const.ID_ATTRIBUTE = "id";
		const.ORDER_ATTRIBUTE = "order";
		const.ISOLATION_ATTRIBUTE = "isolation";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AdviceDefinitionParser" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="Set up configuration of the <tx:advice> items" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var id = arguments.element.getAttribute(meta.const.ID_ATTRIBUTE);
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);
		var prop = 0;
		var value = 0;

		beanDef.setClassName(meta.const.TRANSACTION_INTERCEPTOR_CLASS);

		if(arguments.element.hasAttribute(meta.const.ORDER_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.ORDER_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("order", value);
			beanDef.addProperty(prop);
		}

		if(arguments.element.hasAttribute(meta.const.ISOLATION_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.ISOLATION_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("isolation", value);
			beanDef.addProperty(prop);
		}

		return beanDef;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>