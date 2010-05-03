<cfcomponent output="false" extends="unittests.AbstractTestCase">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="testDuplicateClone" hint="tests to see if cloning happens through duplication" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.wheel = createObject("component", "unittests.testBeans.Wheel").init();

		local.clone = local.wheel.clone();

		assertNotSame(local.wheel, local.clone);

		assertEquals(getMetadata(local.wheel).name, getMetadata(local.clone).name);
    </cfscript>
</cffunction>

<cffunction name="testSetInstanceClone" hint="testing of a clone that takes a set instance" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.engine = createObject("component", "unittests.testBeans.Engine").init();
		local.car = createObject("component", "unittests.testBeans.Car").init(local.engine);

		local.car.setMake("Ford");

		local.wheels = {};
		StructInsert(local.wheels, "1", createObject("component", "unittests.testBeans.Wheel").init());
		StructInsert(local.wheels, "2", createObject("component", "unittests.testBeans.Wheel").init());
		StructInsert(local.wheels, "3", createObject("component", "unittests.testBeans.Wheel").init());
		StructInsert(local.wheels, "4", createObject("component", "unittests.testBeans.Wheel").init());

		local.car.setWheels(local.wheels);

		local.clone = local.car.clone();

		AssertNotSame(local.car, local.clone);
		assertEquals(getMetadata(local.car).name, getMetadata(local.clone).name);

		assertEquals(local.car.getMake(), local.clone.getMake());

		assertNotSame(local.car.getEngine(), local.clone.getEngine());

		AssertEquals(4, structCount(local.car.getWheels()));

		local.wheels = local.car.getWheels();
		local.cloneWheels = local.clone.getWheels();

		for(local.key in local.wheels)
		{
			local.cloneWheel = local.cloneWheels[local.key];
			local.wheel = local.wheels[local.key];

			assertNotSame(local.wheel, local.cloneWheel);

			assertEquals(getMetadata(local.wheel).name, getMetadata(local.cloneWheel).name);
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>