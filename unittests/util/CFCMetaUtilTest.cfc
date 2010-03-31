<cfcomponent extends="unittests.AbstractTestCase">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="" access="public" returntype="void" output="false">
	<cfscript>
		instance.cfcmetaUtil = createObject("component", "coldspring.util.CFCMetaUtil").init();
    </cfscript>
</cffunction>

<cffunction name="testAssignableFromSuperClass" hint="tests if it can see assignable from a super class" access="public" returntype="void" output="false">
	<cfscript>
		assertTrue(instance.cfcmetaUtil.isAssignableFrom("coldspring.beans.xml.XmlBeanFactory", "coldspring.beans.AbstractBeanFactory"));

		assertTrue(instance.cfcmetaUtil.isAssignableFrom("coldspring.beans.support.Property", "coldspring.beans.support.AbstractProperty"));
    </cfscript>
</cffunction>

<cffunction name="testAssignableFromInterface" hint="tests if it can see assignable from an interface" access="public" returntype="void" output="false">
	<cfscript>
		assertTrue(instance.cfcmetaUtil.isAssignableFrom("coldspring.beans.factory.config.ListFactoryBean", "coldspring.beans.factory.FactoryBean"));
    </cfscript>
</cffunction>

<cffunction name="testNotAssignable" hint="tests if it can see assignable from an interface" access="public" returntype="void" output="false">
	<cfscript>
		assertFalse(instance.cfcmetaUtil.isAssignableFrom("coldspring.beans.support.Property", "coldspring.beans.factory.FactoryBean"));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>