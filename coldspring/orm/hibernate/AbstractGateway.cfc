/*
   Copyright 2010 Mark Mandel, Bob Silverberg
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
 * Abstract gateway for the gateway/data layer for your application using CF9 ORM.<br/>
 * This can be used standalone, or extended to provide additional functionality.<br/>
 *
 * (More functionality on this coming soon, very first pass)
 */
component
{
	/**
     * Constructor
     */
    public AbstractGateway function init()
    {
    	return this;
    }

	/**
	 * onMissingMethod that provides a variety of ORM utility methods by convention.<br/>
	 * <ul>
	 *  <li> getXXX(id): retrieves the entity XXX by id. If no object is found, a new object is returned.</li>
	 *  <li> getXXXByYYY(value): retrieves the entity XXX by YYY property with the value passed in. If no object is found, a new object is returned.</li>
	 *	<li> newXXX(): returns a new instance of Entity XXX</li>
	 *	<li> saveXXX(object): calls EntitySave() on the object argument</li>
	 *	<li> deleteXXX(object): calls EntityDelete() on the object argument</li>
	 *  <li> listXXX[FilterByYYY][OrderByZZZ](): returns a list of the XXX entity.
	 *		<br/>Optionally filters by YYY, for which you need to pass in a value. Optionally orders by property ZZZ
	 *  </li>
	 *  <li> enableFilterXXX(params): enables the filter XXX. The param struct argument passed in keys-values are set as parameters on the filter.</li>
	 * </ul>
	 */
	public any function onMissingMethod(required String missingMethodName, required struct missingMethodArguments)
	{
		arguments.missingMethodName = lCase(arguments.missingMethodName);

		if(arguments.missingMethodName.startsWith("get"))
		{
			local.class = replace(arguments.missingMethodName, "get", "");

			if(Find("by", local.class))
			{
				local.split = local.class.split("by");

				local.class = local.split[1];

				local.filter = {};
				local.filter[local.split[2]] = arguments.missingMethodArguments[1];

				local.return = entityLoad(local.class, local.filter, true);
			}
			else
			{
				local.id = arguments.missingMethodArguments[1];

				if(not len(local.id) OR local.id lte 0)
				{
					return entityNew(local.class);
				}

				local.return = entityLoad(local.class, local.id, true);

			}

			if(isNull(local.return))
			{
				return entityNew(local.class);
			}

			return local.return;
		}
		else if(arguments.missingMethodName.startsWith("new"))
		{
			local.class = replace(arguments.missingMethodName, "new", "");

			return entityNew(local.class);
		}
		else if(arguments.missingMethodName.startsWith("save"))
		{
			entitySave(arguments.missingMethodArguments[1]);
			return;
		}
		else if(arguments.missingMethodName.startsWith("delete"))
		{
			entityDelete(arguments.missingMethodArguments[1]);

			return;
		}
		else if(arguments.missingMethodName.startsWith("list"))
		{
		    local.class = replace(arguments.missingMethodName, "list", "");

		    local.filter = {};
		    local.sortorder = "";

		    //filterby comes first
		    if(Find("filterby", local.class))
		    {
		        local.split = local.class.split("filterby");
		        local.class = local.split[1];
		        local.filterBy = local.split[2];

		        if(Find("orderby", local.filterBy))
		        {
		            local.split = local.filterBy.split("orderby");
					local.filterBy = local.split[1];
		            local.orderBy = local.split[2];
		        }
		    }
		    else if(Find("orderby", local.class))
		    {
		        local.split = local.class.split("orderby");
		        local.class = local.split[1];
		        local.orderBy = local.split[2];
		    }

		    if(StructKeyExists(local, "filterBy"))
		    {
		        local.filter[local.filterBy] = arguments.missingMethodArguments[1];
		    }

		    if(StructKeyExists(local, "orderBy"))
		    {
		        local.sortorder = replace(local.orderBy, "_", " ", "all");
		    }

		    return EntityLoad(local.class, local.filter, local.sortorder);
		}
		else if(arguments.missingMethodName.startsWith("enableFilter"))
		{
			local.filterName = ReplaceNoCase(arguments.missingMethodName, "enableFilter", "");

			local.filter = ormGetSession().enableFilter(local.filterName);

			for(local.key in arguments.missingMethodArguments)
			{
				local.filter.setParameter(local.key, arguments.missingMethodArguments[local.key]);
			}

			return;
		}

		throw(type="MethodDoesNotExistException",
			message="The method you are trying to invoke does not exist on this component",
			detail="On component #getMetaData(this).name#, the function '#arguments.missingMethodName#' does not exist");
	}

}