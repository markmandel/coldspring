/**
 * test for wiring
 */
component extends="unittests.AbstractTestCase"
{
	/**
     * setup function
     */
    public void function setup()
    {
		super.setup();
		ormReload();
    }

	/**
     * test autowire
     */
    public void function testAutoWireByName()
    {
		var list = EntityLoad("Foo");

		local.len = ArrayLen(list);
        for(local.counter=1; local.counter <= local.len; local.counter++)
        {
        	local.foo = list[local.counter];

			assertEquals("Gandalf", local.foo.getInject());
        }

    }


}