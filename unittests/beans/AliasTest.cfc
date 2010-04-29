<cfcomponent hint="testig of aliases, names etc" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="testBadAlias" hint="tests an alias that doesn't point to a valid bean" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.exception.BeanDefinitionNotFoundException">
	<cfscript>
		var local = {};
		local.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/errorXML/bad-alias.xml"));

		local.factory.getBean("myAlias");
    </cfscript>
</cffunction>

<cffunction name="testAlias" hint="make sure an alias can be used to get at a bean" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};
		local.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/car-beans.xml"));

		local.realCar = local.factory.getBean("car1");
		local.aliasCar = local.factory.getBean("alsoCar1");

		assertSame(local.realCar, local.aliasCar);
    </cfscript>
</cffunction>

<cffunction name="testName" hint="test the use of name to see if it also works as an alias" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/car-beans.xml"));

		local.realCar = local.factory.getBean("car1");
		local.name1Car = local.factory.getBean("anotherNameForCar1");

		assertSame(local.realCar, local.name1Car);

		local.name2Car = local.factory.getBean("myCarBoogaLoo");

		assertSame(local.realCar, local.name2Car);

		local.aliasCar = local.factory.getBean("anotherAliasForCar1");

		assertSame(local.realCar, local.aliasCar);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>