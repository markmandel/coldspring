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
	meta = getMetadata(this);
	if(!structKeyExists(meta, "const"))
	{
		const = {};
		const.GET_PREFIX = "get";
		const.NEW_PREFIX = "new";
		const.SAVE_PREFIX = "save";
		const.DELETE_PREFIX = "delete";
		const.LIST_PREFIX = "list";
		const.DISABLE_FILTER_PREFIX = "disablefilter";
		const.ENABLE_FILTER_PREFIX = "enablefilter";

		meta.const = const;
	}

	/**
     * Constructor
	 *
	 * @sessionWrapper The Hibernate SessionWrapper to use when interacting with the CF9 ORM. If not provided, the a singleton instance of the default SessionWrapper is used.
	 * @sesionWrapper.coldoc:generic coldspring.orm.hibernate.SessionWrapper
     */
    public AbstractGateway function init(any sessionWrapper)
    {
		if(structKeyExists(arguments, "sessionWrapper"))
		{
			setSessionWrapper(arguments.sessionWrapper);
		}
		else
		{
			var singleton = getComponentMetadata("coldspring.util.Singleton").singleton.instance;
			var defaultSessionWrapper = singleton.createInstance("coldspring.orm.hibernate.SessionWrapper");

			setSessionWrapper(defaultSessionWrapper);
		}

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
	 *  <li> enableFilterXXX(params): enables the filter XXX and returns it. The param struct argument passed in keys-values are set as parameters on the filter.</li>
	 * </ul>
	 */
	public any function onMissingMethod(required String missingMethodName, required struct missingMethodArguments)
	{
		var lName = lcase(arguments.missingMethodName);

		if(lName.startsWith(meta.const.GET_PREFIX))
		{
			return executeGet(arguments.missingMethodName, arguments.missingMethodArguments);
		}
		else if(lName.startsWith(meta.const.NEW_PREFIX))
		{
			return executeNew(arguments.missingMethodName, arguments.missingMethodArguments);
		}
		else if(lName.startsWith(meta.const.SAVE_PREFIX))
		{
			return executeSave(arguments.missingMethodName, arguments.missingMethodArguments);
		}
		else if(lName.startsWith(meta.const.DELETE_PREFIX))
		{
			return executeDelete(arguments.missingMethodName, arguments.missingMethodArguments);
		}
		else if(lName.startsWith(meta.const.LIST_PREFIX))
		{
		   return executeList(arguments.missingMethodName, arguments.missingMethodArguments);
		}
		else if(lName.startsWith(meta.const.ENABLE_FILTER_PREFIX))
		{
			return executeEnableFilter(arguments.missingMethodName, arguments.missingMethodArguments);
		}
		else if(lName.startsWith(meta.const.DISABLE_FILTER_PREFIX))
		{
			return executeDisableFilter(arguments.missingMethodName, arguments.missingMethodArguments);
		}

		//throw an exception if the method is not found
		new coldspring.exception.MethodNotFoundException(this, arguments.missingMethodName);
	}

	/**
     * execute a save operation
     */
    private void function executeSave(required string missingMethodName, required struct missingMethodArguments)
    {
		getSessionWrapper().save(arguments.missingMethodArguments[1]);
    }

	/**
     * executes a new operation
     */
    private any function executeNew(required string missingMethodName, required struct missingMethodArguments)
    {
		local.class = replaceNoCase(arguments.missingMethodName, meta.const.NEW_PREFIX, "");

		return getSessionWrapper().new(local.class);
	}

	/**
     * executes an entity get operation
     */
    private any function executeGet(required string missingMethodName, required struct missingMethodArguments)
    {
		local.class = replaceNoCase(arguments.missingMethodName, meta.const.GET_PREFIX, "");

		if(findNoCase("by", local.class))
		{
			local.split = local.class.split("(?i)by");

			local.class = local.split[1];

			local.filter = {};
			local.filter[local.split[2]] = arguments.missingMethodArguments[1];

			local.return = getSessionWrapper().get(local.class, local.filter);
		}
		else
		{
			local.id = arguments.missingMethodArguments[1];

			if(not len(local.id) OR local.id lte 0)
			{
				return getSessionWrapper().new(local.class);
			}

			local.return = getSessionWrapper().get(local.class, local.id);
		}

		if(isNull(local.return))
		{
			return getSessionWrapper().new(local.class);;
		}

		return local.return;
    }

	/**
     * execute a delete operation
     */
    private void function executeDelete(required string missingMethodName, required struct missingMethodArguments)
    {
		getSessionWrapper().delete(arguments.missingMethodArguments[1]);
    }

	/**
     * executes enabling a filter
     */
    private any function executeEnableFilter(required string missingMethodName, required struct missingMethodArguments)
    {
			local.filterName = ReplaceNoCase(arguments.missingMethodName, meta.const.ENABLE_FILTER_PREFIX, "");

			local.filterName = findFilterName(local.filterName);

			local.filter = getSessionWrapper().enableFilter(local.filterName);

			for(local.key in arguments.missingMethodArguments)
			{
				local.filter.setParameter(local.key, arguments.missingMethodArguments[local.key]);
			}

			return local.filter;
    }

	/**
     * executes a list operation
     */
    private array function executeList(required string missingMethodName, required struct missingMethodArguments)
    {
		local.listParameters = replaceNoCase(arguments.missingMethodName, meta.const.LIST_PREFIX, "");
		local.params = extractListParameters(local.listParameters, missingMethodArguments);
 
	    return getSessionWrapper().list(local.params.class, local.params.filterCriteria, local.params.sortOrder);       
    }

	/**
	 * extract the class, filterCriteria and sortOrder as specified by the listParameters.  Matches based on the pattern
	 *	class(FilterByXXX|Filtered)(OrderByZZZ|Ordered)
	 */
	private struct function extractListParameters(required string listParameters, required struct missingMethodArguments) {
	
		local.listParametersRegEx = "^(.+?)(?:(filterby)(.+?)|(filtered))?(?:(orderby)(.+?)|(ordered))?$";
		
		// Position of interesting subgroups in regular expression
		local.CLASS_GROUP = 2;
		local.FILTERBY_GROUP = 3;
		local.FILTERFIELD_GROUP = 4;
		local.FILTERED_GROUP = 5;
		local.ORDERBY_GROUP = 6;
		local.ORDERFIELD_GROUP = 7;
		local.ORDERED_GROUP = 8;
	
		local.tokens = customREMatchGroupsNoCase(local.listParametersRegEx, arguments.listParameters);
		
		if (arrayLen(local.tokens) < local.CLASS_GROUP) {
			return {};
		}
		
		local.params = {
        	class = local.tokens[local.CLASS_GROUP],
            filterCriteria = {},
            sortOrder = ""
        };
	
	    local.argumentsIndex = 1;
	
		if (local.tokens[local.FILTERBY_GROUP] == "FilterBy") {
			local.filterBy = local.tokens[local.FILTERFIELD_GROUP];
			if (local.filterBy NEQ "") {
				local.params.filterCriteria[local.filterBy] = arguments.missingMethodArguments[local.argumentsIndex++];
			}			
		}
		else if (local.tokens[local.FILTERED_GROUP] == "Filtered") {
			local.params.filterCriteria = arguments.missingMethodArguments[local.argumentsIndex++];
		}
		
		if (local.tokens[local.ORDERBY_GROUP] == "OrderBy") {
			local.orderBy = local.tokens[local.ORDERBY_GROUP];
			if (local.orderBy NEQ "") {
				// support listXXXOrderByField_ASC and listXXXOrderByField_DESC
				local.params.sortOrder = replaceNoCase(local.orderBy, "_", " ", "all");
			}
		}
		else if (local.tokens[local.ORDERED_GROUP] == "Ordered") {
			local.params.sortOrder = arguments.missingMethodArguments[local.argumentsIndex++];
		}
	
		return local.params;
    }

	/**
	 * Extended version of REMatchNoCase that returns subgroups matched within the regExpression
	 *
	 * Parameters
	 *	regExpression - Regular expression to execution
	 *	search - String to search
	 *	position - The position to start searching from (defaults to 1)
	 *	scope - Indicates if the regExpression should be matched multiple times
	 *				"one" - Matches only the first occurence in search (default)
	 *				"all" - Matches all occurences 
	 *	omitEmptyGroups - Where an optional subgroup is not matched, do not include in the returned array, otherwise return it as an empty string (default false).  
	 *					  Note that when true, the position of the returned subgroups in the array is not predictable 
	 *
	 * Returns: Array - contents are dependant on scope setting
	 *	scope == "one" - An array of strings, one string for each pattern matched in the search string
	 *	scope == "all" - An array of arrays as returned for scope == "one"
	 */    
 	private array function customREMatchGroupsNoCase(required string regExpression, required string search, numeric position=1, string scope="one", boolean omitEmptyGroups=false) {
	
		local.position = arguments.position;
		local.matches = [];
		
		local.tokens = reFindNoCase(arguments.regExpression, arguments.search, position, true);
		while (local.tokens.pos[1] != 0 && local.tokens.len[1] != 0) {
			local.theseMatches = [];
			
			for(local.index=1; local.index<=ArrayLen(local.tokens.pos); local.index++) {
				local.thisMatch = "";
				
				if(local.tokens.pos[local.index] != 0 && local.tokens.len[local.index] != 0) {
					local.thisMatch = Mid(arguments.search, local.tokens.pos[local.index], local.tokens.len[local.index]);
				}
				
				if (local.thisMatch != "" || !arguments.omitEmptyGroups) {
					arrayAppend(local.theseMatches, local.thisMatch);
				}
			}
	
			if (arguments.scope == "one") {
				// Where scope == "one" just make an early exit and return only the first match
				return local.theseMatches;
			}
			
			arrayAppend(local.matches, local.theseMatches);
			
			// Continue on to find the next match
			local.position += local.tokens.len[1];
			local.tokens = reFindNoCase(arguments.regExpression, arguments.search, local.position, true);
		}
		
		return local.matches;
	}
    
    
	/**
     * executes disabeling a filter
     */
    private void function executeDisableFilter(required string missingMethodName, required struct missingMethodArguments)
    {
		var filterName = ReplaceNoCase(arguments.missingMethodName, meta.const.DISABLE_FILTER_PREFIX, "");

		local.filterName = findFilterName(local.filterName);

		getSessionWrapper().disableFilter(filterName);
    }


	/**
     * non case sensitive lookup for filters
	 *
	 * @filterName the name of the filter
     */
    private string function findFilterName(required string filtername)
    {
		var filterNames = getSessionWrapper().getSessionFactory().getDefinedFilterNames().iterator();

		while(filterNames.hasNext())
		{
			var filter = filterNames.next();

			if(filter == arguments.filtername)
			{
				return filter;
			}
		}

		return arguments.filterName;
    }

	private any function getSessionWrapper()
    {
    	return variables.sessionWrapper;
    }

    private void function setSessionWrapper(required any sessionWrapper)
    {
    	variables.sessionWrapper = arguments.sessionWrapper;
    }

}
