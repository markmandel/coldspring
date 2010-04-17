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
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", instance.registry);

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
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", instance.registry);
		beanDef.setClassName("unittests.testBeans.Car");

		assertEquals(0, instance.registry.getBeanDefinitionCount());

		instance.registry.registerBeanDefinition(beanDef);

		assertEquals(1, instance.registry.getBeanDefinitionCount());

		beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo2", instance.registry);
		beanDef.setClassName("unittests.testBeans.Car");

		instance.registry.registerBeanDefinition(beanDef);

		assertEquals(2, instance.registry.getBeanDefinitionCount());

		instance.registry.removeBeanDefinition("foo");

		assertEquals(1, instance.registry.getBeanDefinitionCount());
    </cfscript>
</cffunction>

<cffunction name="testGetNames" hint="test getting the bean def names" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", instance.registry);
		var names = [];

		beanDef.setClassName("unittests.testBeans.Car");
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo2", instance.registry);
		beanDef.setClassName("unittests.testBeans.Car");

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo2", "foo"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());

		instance.registry.removeBeanDefinition("foo");

		names = ["foo2"];
		assertEquals(names, instance.registry.getBeanDefinitionNames());
    </cfscript>
</cffunction>

<cffunction name="testGetNamesByType" hint="testing getting names of beans by their type" access="public" returntype="void" output="false">
	<cfscript>
		var beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo", instance.registry);
		var names = [];

		beanDef.setClassName("unittests.testBeans.Car");

		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo"];
		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));

		beanDef = createObject("coldspring.beans.support.CFCBeanDefinition").init("foo2", instance.registry);
		beanDef.setClassName("unittests.testBeans.Car");

		instance.registry.registerBeanDefinition(beanDef);

		names = ["foo", "foo2"];
		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));

		instance.registry.removeBeanDefinition("foo");

		names = ["foo2"];
		assertEquals(names, instance.registry.getBeanNamesForType("unittests.testBeans.Car"));
    </cfscript>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>