<cfcomponent extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="void" output="false">
	<cfscript>
		var jl = createObject("component", "coldspring.util.java.JavaLoader").init("unittests");
		var beanCache = createObject("component", "coldspring.beans.factory.BeanCache").init(jl);

		//this is lazy, but I'll just create an abstract bean factory. (This should be mocked later, but I'm on a deadline)
		var factory = createObject("component", "coldspring.beans.AbstractBeanFactory");

		instance.registry = createObject("component", "coldspring.beans.BeanDefinitionRegistry").init(factory, beanCache);
    </cfscript>
</cffunction>

<cffunction name="testContains" hint="testing the contains" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo");

		beanDef.setClassName("unittests.testBeans.Car");

		assertFalse(instance.registry.containsBeanDefinition("foo"));

		instance.registry.registerBeanDefinition(beanDef);

		assertTrue(instance.registry.containsBeanDefinition("foo"));

		assertFalse(instance.registry.containsBeanDefinition("foo2"));

		instance.registry.removeBeanDefinition("foo");

		assertFalse(instance.registry.containsBeanDefinition("foo"));
    </cfscript>
</cffunction>

<cffunction name="testCount" hint="testing the contains" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo");
		beanDef.setClassName("unittests.testBeans.Car");

		assertEquals(0, instance.registry.getBeanDefinitionCount());

		instance.registry.registerBeanDefinition(beanDef);

		assertEquals(1, instance.registry.getBeanDefinitionCount());

		beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo2");
		beanDef.setClassName("unittests.testBeans.Car");

		instance.registry.registerBeanDefinition(beanDef);

		assertEquals(2, instance.registry.getBeanDefinitionCount());

		instance.registry.removeBeanDefinition("foo");

		assertEquals(1, instance.registry.getBeanDefinitionCount());
    </cfscript>
</cffunction>

<cffunction name="testGetNames" hint="test getting the bean def names" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo");
		var names = [];

		beanDef.setClassName("unittests.testBeans.Car");
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo2");
		beanDef.setClassName("unittests.testBeans.Car");

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo2", "foo"];
		assertArrayEqualsNonOrdered(names, instance.registry.getBeanDefinitionNames());

		instance.registry.removeBeanDefinition("foo");

		names = ["foo2"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());
    </cfscript>
</cffunction>

<cffunction name="testGetNamesByType" hint="testing getting names of beans by their type" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo");
		var names = [];

		beanDef.setClassName("unittests.testBeans.Car");

		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo"];
		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));

		beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo2");
		beanDef.setClassName("unittests.testBeans.Car");

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo", "foo2"];
		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));

		instance.registry.removeBeanDefinition("foo");

		names = ["foo2"];
		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));
    </cfscript>
</cffunction>

<cffunction name="testAlias" hint="test to see if aliasing works" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("foo");
		var local = {};

		beanDef.setClassName("unittests.testBeans.Car");

		assertFalse(instance.registry.containsBeanDefinition("foo"));

		instance.registry.registerBeanDefinition(beanDef);

		instance.registry.notifyComplete();
		instance.registry.validate();

		local.def = instance.registry.getBeanDefinition("foo");

		assertSame(local.def, beanDef);

		assertFalse(instance.registry.isAlias("foo"));

		local.aliases = [];
		assertEquals(local.aliases, instance.registry.getAliases("foo"));

		assertFalse(instance.registry.containsBeanDefinition("fooAlias"));

		//register alias
		instance.registry.registerAlias("foo", "fooAlias");

		assertTrue(instance.registry.isAlias("fooAlias"));

		local.aliases = ["fooAlias"];
		assertEquals(local.aliases, instance.registry.getAliases("foo"));

		assertTrue(instance.registry.containsBeanDefinition("fooAlias"));

		local.def = instance.registry.getBeanDefinition("fooAlias");

		assertSame(local.def, beanDef);

		//remove alias
		instance.registry.removeAlias("fooAlias");

		assertFalse(instance.registry.isAlias("foo"));

		local.aliases = [];

		assertEquals(local.aliases, instance.registry.getAliases("foo"));

		assertFalse(instance.registry.containsBeanDefinition("fooAlias"));

		//put is back in to test the remove bean process
		instance.registry.registerAlias("foo", "fooAlias");

		instance.registry.removeBeanDefinition("foo");

		assertTrue(instance.registry.isAlias("fooAlias"), "Alias should NOT be removed");

		instance.registry.removeAlias("fooAlias");

		assertFalse(instance.registry.isAlias("fooAlias"), "Alias should be removed");
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>