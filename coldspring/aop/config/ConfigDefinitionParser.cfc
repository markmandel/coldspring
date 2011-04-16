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
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};
		const.AOP_NAMESPACE_URI = "http://www.coldspringframework.org/schema/aop";

		const.ADVISOR_ELEMENT = "advisor";
		const.ASPECT_ELEMENT = "aspect";
		const.BEFORE_ELEMENT = "before";
		const.AROUND_ELEMENT = "around";
		const.POINTCUT_ELEMENT = "pointcut";

		const.ADVICE_REF_ATTRIBUTE = "advice-ref";
		const.ID_ATTRIBUTE = "id";
		const.REF_ATTRIBUTE = "ref";
		const.METHOD_ATTRIBUTE = "method";
		const.POINTCUT_ATTRIBUTE = "pointcut";
		const.POINTCUT_REF_ATTRIBUTE = "pointcut-ref";
		const.EXPRESSION_ATTRIBUTE = "expression";

		const.EXPRESSION_POINTCUT_CLASS = "coldspring.aop.expression.ExpressionPointcut";
		const.ADVISOR_CLASS = "coldspring.aop.PointcutAdvisor";
		const.METHOD_INVOCATION_ADVICE_CLASS = "coldspring.aop.framework.adapter.MethodInvocationAdviceInterceptor";

		const.ELEMENT_ADVISE_MAP =
			{
				around = "around"
				,before = "before"
			};
		const.ELEMENT_ADVISE_MAP["after-returning"] = "afterReturning";
		const.ELEMENT_ADVISE_MAP["after-throwing"] = "throws";

		meta.const = const;
	}
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

		parseAspects(arguments.element, arguments.parserContext);
		parseAdvisors(arguments.element, arguments.parserContext);
		parsePointcuts(arguments.element, arguments.parserContext);
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
		var childNodes = arguments.element.getElementsByTagNameNS(meta.const.AOP_NAMESPACE_URI, meta.const.ADVISOR_ELEMENT);
		var counter = 0;
		var child = 0;

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);
			parseAdvisor(child, arguments.parserContext);
		}
    </cfscript>
</cffunction>

<cffunction name="parseAdvisor" hint="parse a single advisor element, and add it to the registry" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:advisor> XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var id = 0;
		var advisorBeanDef = 0;
		var pointcutBeanDef = 0;
		var constructorArg = 0;
		var property = 0;
		var value = 0;

		advisorBeanDef = parseAdvisorProperties(arguments.element);

		parsePointcutAttributes(arguments.element, arguments.parserContext, advisorBeanDef);

		//advice constructor arg
		value = createObject("component", "coldspring.beans.support.RefValue").init(arguments.element.getAttribute(meta.const.ADVICE_REF_ATTRIBUTE), arguments.parserContext.getBeanFactory());
		constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("advice", value);

		advisorBeanDef.addConstructorArg(constructorArg);

		arguments.parserContext.getBeanDefinitionRegistry().registerBeanDefinition(advisorBeanDef);
    </cfscript>
</cffunction>

<cffunction name="parseAspects" hint="parse all aspects in the config block" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:config> XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var childNodes = arguments.element.getElementsByTagNameNS(meta.const.AOP_NAMESPACE_URI, meta.const.ASPECT_ELEMENT);
		var counter = 0;
		var child = 0;

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);
			parseAspect(child, arguments.parserContext);
		}
    </cfscript>
</cffunction>

<cffunction name="parseAspect" hint="parse a single aspect element, and add it to the registry" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:aspect> XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var counter = 0;
		var childNodes = arguments.element.getChildNodes();
		var child = 0;
		var templateBeanDef = parseAdvisorProperties(arguments.element);
		var cloneAdvisorBeanDef = 0;
		var cloneMethodInvokeBeanDef = 0;
		var node = arguments.parserContext.getDelegate().getNode();

		var templateMethodInvokeBeanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("MethodInvoke-" & createUUID());
		var value = createObject("component", "coldspring.beans.support.RefValue").init(arguments.element.getAttribute(meta.const.REF_ATTRIBUTE), arguments.parserContext.getBeanFactory());
		var constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("target", value);

		templateMethodInvokeBeanDef.setClassName(meta.const.METHOD_INVOCATION_ADVICE_CLASS);
		templateMethodInvokeBeanDef.addConstructorArg(constructorArg);

		templateMethodInvokeBeanDef.setAutowire("no");
		templateMethodInvokeBeanDef.setAutowireCandidate(false);

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);

			if(child.getNodeType() eq node.ELEMENT_NODE)
			{
				//this is for all advice (i.e. non pointcut def)
				if(child.getLocalName() != meta.const.POINTCUT_ELEMENT)
				{
					cloneAdvisorBeanDef = templateBeanDef.clone();
					cloneAdvisorBeanDef.setID(templateBeanDef.getID() & "-" & counter);

					cloneMethodInvokeBeanDef = templateMethodInvokeBeanDef.clone();
					cloneMethodInvokeBeanDef.setID("MethodInvoke-" & createUUID());

					value = createObject("component", "coldspring.beans.support.RefValue").init(cloneMethodInvokeBeanDef.getID(), arguments.parserContext.getBeanFactory());
					constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("advice", value);

					cloneAdvisorBeanDef.addConstructorArg(constructorArg);

					//method
					value = createObject("component", "coldspring.beans.support.SimpleValue").init(child.getAttribute(meta.const.METHOD_ATTRIBUTE));
					constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("method", value);

					cloneMethodInvokeBeanDef.addConstructorArg(constructorArg);

					//maps which advice type the method invoking iterceptor actually fires.
					value = createObject("component", "coldspring.beans.support.SimpleValue").init(meta.const.ELEMENT_ADVISE_MAP[child.getLocalName()]);

					constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("adviceType", value);
					cloneMethodInvokeBeanDef.addConstructorArg(constructorArg);
					parsePointcutAttributes(child, arguments.parserContext, cloneAdvisorBeanDef);

					arguments.parserContext.getBeanDefinitionRegistry().registerBeanDefinition(cloneAdvisorBeanDef);
					arguments.parserContext.getBeanDefinitionRegistry().registerBeanDefinition(cloneMethodInvokeBeanDef);
				}
				else
				{
					parsePointcut(child, arguments.parserContext.getBeanDefinitionRegistry());
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="parsePointcuts" hint="parse all pointcuts in the config block" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:config> XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var childNodes = arguments.element.getElementsByTagNameNS(meta.const.AOP_NAMESPACE_URI, meta.const.POINTCUT_ELEMENT);
		var counter = 0;
		var child = 0;

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);
			parsePointcut(child, arguments.parserContext.getBeanDefinitionRegistry());
		}
    </cfscript>
</cffunction>

<cffunction name="parsePointcut" hint="parses a pointcut element into an ExpressionPointut, which is then added to he BeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:pointcut> XML Element" type="any" required="Yes">
	<cfargument name="beanDefRegistry" hint="the bean definition registry" type="coldspring.beans.BeanDefinitionRegistry" required="Yes">
	<cfscript>
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(arguments.element.getAttribute(meta.const.ID_ATTRIBUTE));
		var value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.EXPRESSION_ATTRIBUTE));
		var property = createObject("component", "coldspring.beans.support.Property").init("expression", value);

		beanDef.addProperty(property);
		beanDef.setClassName(meta.const.EXPRESSION_POINTCUT_CLASS);

		/*
			<aop:pointcut expression="!target(unittests.aop.com.sub.Hello) AND @target(dostuff)" id="notSubHello"/>
		 */

		arguments.beanDefRegistry.registerBeanDefinition(beanDef);
    </cfscript>
</cffunction>

<cffunction name="parseAdvisorProperties" hint="Build a default advisor class" access="private" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the <aop:advisor> XML Element" type="any" required="Yes">
	<cfscript>
		var id = 0;
		var advisorBeanDef = 0;

		if(arguments.element.hasAttribute(meta.const.ID_ATTRIBUTE))
		{
			id = arguments.element.getAttribute(meta.const.ID_ATTRIBUTE);
		}
		else
		{
			id = createUUID();
		}

		advisorBeanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);
		advisorBeanDef.setAutowire("no");
		advisorBeanDef.setClassName(meta.const.ADVISOR_CLASS);

		return advisorBeanDef;
    </cfscript>
</cffunction>

<cffunction name="parsePointcutAttributes" hint="parse pointcut attributes, and apply them to the advisor bean definition" access="private" returntype="void" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represents the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfargument name="advisorBeanDef" hint="The bean definition for the advisor" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var pointcutBeanDef = 0;
		var value = 0;
		var property = 0;
		var constructorArg = 0;

		//pointcut constructor arg
		if(arguments.element.hasAttribute(meta.const.POINTCUT_ATTRIBUTE))
		{
			pointcutBeanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(createUUID());
			pointcutBeanDef.setAutowire("no");
			pointcutBeanDef.setClassName(meta.const.EXPRESSION_POINTCUT_CLASS);

			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.POINTCUT_ATTRIBUTE));

			property = createObject("component", "coldspring.beans.support.Property").init("expression", value);

			pointcutBeanDef.addProperty(property);

			arguments.parserContext.getBeanDefinitionRegistry().registerBeanDefinition(pointcutBeanDef);

			value = createObject("component", "coldspring.beans.support.RefValue").init(pointcutBeanDef.getID(), arguments.parserContext.getBeanFactory());
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("pointcut", value);

			arguments.advisorBeanDef.addConstructorArg(constructorArg);
		}
		else if(arguments.element.hasAttribute(meta.const.POINTCUT_REF_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.RefValue").init(arguments.element.getAttribute(meta.const.POINTCUT_REF_ATTRIBUTE), arguments.parserContext.getBeanFactory());
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("pointcut", value);

			arguments.advisorBeanDef.addConstructorArg(constructorArg);
		}
    </cfscript>
</cffunction>

</cfcomponent>