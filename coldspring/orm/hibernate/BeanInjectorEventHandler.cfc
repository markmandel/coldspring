/*
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
*/

/**
 * Event handler for ORM that will inject dependencies
 * into an Entity as it is loaded.<br/>
 * To use, set it up in your Application.cfc as:<br/>
 * <pre>
 * this.ormsettings.eventhandling = true;
 * this.ormsettings.eventhandler = "coldspring.orm.hibernate.BeanInjectorEventHandler";
 * </pre>
 *
 * When implemented via Application.cfc, this Event Handler assumes 2 things:<br/>
 * <ol>
 * 	<li>That ColdSpring is in the application scope, under the key 'coldspring'.</li>
 *  <li>That ColdSpring has a class that extends AbstractBeanInjector under the id 'hibernate-beanInjector', such as AutowireByNameBeanInjector</li>
 * </ol>
 *
 * To overwrite any of these default settings, extend this class and overwrite 'getBeanFactory()' and/or 'getBeanInjector()'.
 *
 * <p>TODO: Allow this class to be used within ColdSpring, implemented through a Event Marshalling System</p>
 *
 */
component implements="cfide.orm.IEventHandler"
{
	/**
     * The bean injector that will wire up the entity when it loads
     */
	property name="beanInjector" type="any";

	/**
     * Constructor
     */
    public BeanInjectorEventHandler function init()
    {
    	return this;
    }

	/**
	 * Does nothing
	 */
	public void function preLoad(any entity)
	{
	}

	/**
	 * Wires the entity with its dependencies
	 */
	public void function postLoad(any entity)
	{
		getBeanInjector().wire(arguments.entity);
	}

	/**
	 * Does nothing
	 */
	public void function preInsert(any entity)
	{
	}

	/**
	 * Does nothing
	 */
	public void function postInsert(any entity)
	{
	}

	/**
	 * Does nothing
	 */
	public void function preUpdate(any entity, struct oldData )
	{
	}

	/**
	 * Does nothing
	 */
	public void function postUpdate(any entity)
	{
	}

	/**
	 * Does nothing
	 */
	public void function preDelete(any entity)
	{
	}

	/**
	 * Does nothing
	 */
	public void function postDelete(any entity)
	{
	}

	/**
	 * Returns the a bean injector.<br/>
	 * This is getBeanFactory().getBean("hibernate-beanInjector").
	 */
	private any function getBeanInjector()
    {
		if(structKeyExists(variables, "beanInjector"))
		{
	    	return variables.beanInjector;
		}

		return getBeanFactory().getBean("hibernate-beanInjector");
    }

	/**
     * returns the bean factory from application.coldspring
     */
    public coldspring.beans.BeanFactory function getBeanFactory()
    {
		return application.coldspring;
    }

}