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

<cfcomponent extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/car-beans.xml"));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="testReverseVisitor1" hint="reverse all the strings on the bean" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.beanDefinition = instance.factory.getBeanDefinition("car1");
		local.beanDefinitionCopy = local.beanDefinition.clone();

		local.resolver = createObject("component", "unittests.beans.com.ReverseResolver").init();
		local.visitor = createObject("component", "coldspring.beans.factory.config.BeanDefinitionVisitor").init(local.resolver);

		local.visitor.visitBeanDefinition(local.beanDefinitionCopy);

		AssertEquals(reverse(local.beanDefinition.getClassName()), local.beanDefinitionCopy.getClassName());
		AssertEquals(local.beanDefinition.getScope(), local.beanDefinitionCopy.getScope());

		AssertEquals(reverse(local.beanDefinition.getInitMethod()), local.beanDefinitionCopy.getInitMethod());

		local.args = local.beanDefinition.getConstructorArgs();
		local.copyArgs = local.beanDefinitionCopy.getConstructorArgs();

		for(local.key in local.args)
		{
			local.revKey = reverse(local.key);
			AssertTrue(StructKeyExists(local.copyArgs, local.revKey), "Key should be #local.revKey#");

			local.arg = local.args[local.key];
			local.copyArg = local.copyArgs[local.revKey];

			assertEquals(reverse(local.arg.getName()), local.copyArg.getName());
		}

		//ref value constructor arg
		local.key = "engine";
		local.ref = local.args[local.key].getValue();
		local.refCopy = local.copyArgs[reverse(local.key)].getValue();

		assertEquals(reverse(local.ref.getBeanName()), local.refCopy.getBeanName());

		//properties
		local.props = local.beanDefinition.getProperties();
		local.copyProps = local.beanDefinitionCopy.getProperties();

		for(local.key in local.props)
		{
			local.revKey = reverse(local.key);
			AssertTrue(StructKeyExists(local.copyProps, local.revKey), "Key should be #local.revKey#");

			local.prop = local.props[local.key];
			local.copyProp = local.copyProps[local.revKey];

			assertEquals(reverse(local.prop.getName()), local.copyProp.getName());
		}

		//ref property
		local.key = "color";
		local.ref = local.props[local.key].getValue();
		local.refCopy = local.copyProps[reverse(local.key)].getValue();

		assertEquals(reverse(local.ref.getBeanName()), local.refCopy.getBeanName());

		//simple value
		local.key = "make";
		local.simple = local.props[local.key].getValue();
		local.copySimple = local.copyProps[reverse(local.key)].getValue();

		assertEquals(reverse(local.simple.getValue()), local.copySimple.getValue());

		//map value in reverse
		local.key = "wheels";
		local.mapValue = local.props[local.key].getValue().getValueMap();
		local.copyMapValue = local.copyProps[reverse(local.key)].getValue().getValueMap();

		local.iterator = local.mapValue.keySet().iterator();

		while(local.iterator.hasNext())
		{
			local.key = local.iterator.next();

			local.copyKey = findReverseKey(local.key, local.copyMapValue);

			assertTrue(StructKeyExists(local, "copyKey"), "Couldn't find a reverse for #local.key.getValue()#");

			local.ref = local.mapValue.get(local.key);

			assertTrue(StructKeyExists(local, "ref"), "Couldn't find a value for #local.key.getValue()#");

			local.copyRef = local.copyMapValue.get(local.copyKey);

			assertTrue(StructKeyExists(local, "copyRef"), "Couldn't find a value for #local.copyKey.getValue()#");

			assertEquals(reverse(local.ref.getBeanName()), local.copyRef.getBeanName());
		}
    </cfscript>
</cffunction>

<cffunction name="testReverseVisitor2" hint="reverse all the strings on the bean" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.beanDefinition = instance.factory.getBeanDefinition("car2");
		local.beanDefinitionCopy = local.beanDefinition.clone();

		local.resolver = createObject("component", "unittests.beans.com.ReverseResolver").init();
		local.visitor = createObject("component", "coldspring.beans.factory.config.BeanDefinitionVisitor").init(local.resolver);

		local.visitor.visitBeanDefinition(local.beanDefinitionCopy);

		assertEquals(reverse(local.beanDefinition.getParentName()), local.beanDefinitionCopy.getParentName());

		local.args = local.beanDefinition.getConstructorArgs();
		local.copyArgs = local.beanDefinitionCopy.getConstructorArgs();

		//ref value constructor arg
		local.key = "engine";

		local.meta = local.args[local.key].getMeta();
		local.copyMeta = local.copyArgs[reverse(local.key)].getMeta();

		//test meta
		for(local.key in local.meta)
		{
			local.revKey = reverse(local.key);
			assertTrue(structKeyExists(local.copyMeta, local.revKey), "Should be reverse key for #local.key#");

			assertEquals(reverse(local.meta[local.key]), local.copyMeta[local.revKey]);
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->


<cffunction name="findReverseKey" hint="find the reverse key for a simpleValue key" access="private" returntype="any" output="false">
	<cfargument name="key" hint="the simple value key" type="any" required="Yes">
	<cfargument name="map" hint="the map with the reversed key in it" type="struct" required="Yes">
	<cfscript>
		var local = {};
		local.search = reverse(arguments.key.getValue());
		local.iterator = arguments.map.keySet().iterator();

		while(local.iterator.hasNext())
		{
			local.item = local.iterator.next();

			if(local.item.getValue() eq local.search)
			{
				return local.item;
			}
		}
    </cfscript>
</cffunction>

</cfcomponent>