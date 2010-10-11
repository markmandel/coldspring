<!---
   Copyright 2010 Mark Mandel
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

<cfcomponent hint="The definition parser for the <aop:config> element" extends="coldspring.beans.xml.AbstractBeanDefinitionParser" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	instance.static = {};

	instance.static.AOP_NAMESPACE_URI = "http://www.coldspringframework.org/schema/aop";

	instance.static.ADVISOR_ELEMENT = "advisor";

	instance.static.ADVICE_REF_ATTRIBUTE = "advice-ref";
	instance.static.ID_ATTRIBUTE = "id";
	instance.static.POINTCUT_ATTRIBUTE = "pointcut";
	instance.static.POINTCUT_REF_ATTRIBUTE = "pointcut-ref";

	instance.static.EXPRESSION_POINTCUT_CLASS = "coldspring.aop.expression.ExpressionPointcut";
	instance.static.ADVISOR_CLASS = "coldspring.aop.PointcutAdvisor";
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="ConfigDefinitionParser" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="Set up configuration of the <aop:config> items" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		initAutoProxyCreator(arguments.parserContext.getBeanDefinitionRegistry());

		parseAdvisors(arguments.element, arguments.parserContext);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initAutoProxyCreator" hint="sets up an autoproxy creator, if one hasn't already been set up" access="private" returntype="void" output="false">
	<cfargument name="beanRegistry" hint="the bean registry" type="coldspring.beans.BeanDefinitionRegistry"  required="Yes">
	<cfscript>
		var beanNames = arguments.beanRegistry.getBeanNamesForType("coldspring.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator");
		var beanDef = 0;

		if(arrayIsEmpty(beanNames))
		{
			beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("aop-config-autoproxycreator");
			beanDef.setClassName("coldspring.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator");
			beanDef.setAutowire("no");
			beanDef.setAutowireCandidate(false);

			arguments.beanRegistry.registerBeanDefinition(beanDef);
		}
    </cfscript>
</cffunction>

<cffunction name="parseAdvisors" hint="parse all advisors in the config block" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:config> XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var childNodes = arguments.element.getElementsByTagNameNS(instance.static.AOP_NAMESPACE_URI, instance.static.ADVISOR_ELEMENT);
		var counter = 0;

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);
			parseAdvisor(child, arguments.parserContext);
		}
    </cfscript>
</cffunction>

<cffunction name="parseAdvisor" hint="parse a single advisor element, and add it to the registry" access="public" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:advisor> XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var id = 0;
		var advisorBeanDef = 0;
		var pointcutBeanDef = 0;
		var constructorArg = 0;
		var property = 0;
		var value = 0;

		if(arguments.element.hasAttribute(instance.static.ID_ATTRIBUTE))
		{
			id = arguments.element.getAttribute(instance.static.ID_ATTRIBUTE);
		}
		else
		{
			id = createUUID();
		}

		advisorBeanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);
		advisorBeanDef.setAutowire("no");
		advisorBeanDef.setClassName(instance.static.ADVISOR_CLASS);

		//pointcut constructor arg
		if(arguments.element.hasAttribute(instance.static.POINTCUT_ATTRIBUTE))
		{
			pointcutBeanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(createUUID());
			pointcutBeanDef.setAutowire("no");
			pointcutBeanDef.setClassName(instance.static.EXPRESSION_POINTCUT_CLASS);

			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(instance.static.POINTCUT_ATTRIBUTE));

			property = createObject("component", "coldspring.beans.support.Property").init("expression", value);

			pointcutBeanDef.addProperty(property);

			arguments.parserContext.getBeanDefinitionRegistry().registerBeanDefinition(pointcutBeanDef);

			value = createObject("component", "coldspring.beans.support.RefValue").init(pointcutBeanDef.getID(), arguments.parserContext.getBeanFactory());
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("pointcut", value);

			advisorBeanDef.addConstructorArg(constructorArg);
		}
		else if(arguments.element.hasAttribute(instance.static.POINTCUT_REF_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.RefValue").init(arguments.element.getAttribute(instance.static.POINTCUT_REF_ATTRIBUTE), arguments.parserContext.getBeanFactory());
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("pointcut", value);

			advisorBeanDef.addConstructorArg(constructorArg);
		}

		//advice constructor arg
		value = createObject("component", "coldspring.beans.support.RefValue").init(arguments.element.getAttribute(instance.static.ADVICE_REF_ATTRIBUTE), arguments.parserContext.getBeanFactory());
		constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("advice", value);

		advisorBeanDef.addConstructorArg(constructorArg);

		arguments.parserContext.getBeanDefinitionRegistry().registerBeanDefinition(advisorBeanDef);
    </cfscript>
</cffunction>

</cfcomponent>