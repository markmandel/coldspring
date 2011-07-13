<!---
   Copyright 2011 Mark Mandel
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

<cfcomponent hint="Instances of the class Class represent CFC classes and interfaces in a ColdFusion application." output="false">

<cfscript>
	meta = getMetaData(this);

	if(!structKeyExists (meta, "const"))
	{
		const = {};
    	const.IS_PUBLIC_CLOSURE = createObject("component", "coldspring.util.Closure").init(checkIsPublic);

    	const.ON_MISSING_METHOD = "onMissingMethod";

    	meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<!---
Determines if the specified Object is assignment-compatible with the object represented by this Class.
public boolean isInstance(Object obj)
 --->

<cffunction name="init" hint="Constructor" access="public" returntype="Class" output="false">
	<cfargument name="className" hint="the name of the class/interface this object represents" type="string" required="Yes">
	<cfscript>
		//have to do this stupid juggling because CF8 'can't find 'setLength() on a Builder'
		var builder = 0;
		var reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;

		//builder.setLength(builder.lastIndexOf(".")); << CF8 fails on this because it can't resolve Java Methods. Grrr.
		if(listLen(arguments.className, ".") > 1)
		{
			builder = createObject("java", "java.lang.StringBuilder").init(arguments.className);
			builder.delete(javacast("int", builder.lastIndexOf(".")), len(arguments.className));
			setPackage(builder.toString());
		}
		else
		{
			setPackage("");
		}

    	setReflectionService(reflectionService);
    	setAssignableCache(StructNew());

		setMeta(getComponentMetadata(arguments.className));

		//determine if we are an interface or not
		setInterface(getMeta().type eq "interface");
		setMissingMethods(StructNew());

		//build superclasses
		buildSuperClasses();

		//build implementing interfaces
		buildInterfaces();

		//now go and build all the methods
		buildDeclaredMethods();
		buildMethods();

		//properties - more for cf9+
		buildDeclaredProperties();
		buildProperties();

		return this;
	</cfscript>
</cffunction>

<cffunction name="getName" hint="get the name of this class" access="public" returntype="string" output="false">
	<cfreturn getMeta().name />
</cffunction>

<cffunction name="getPath" hint="get the file path to this classs" access="public" returntype="string" output="false">
	<cfreturn getMeta().path />
</cffunction>

<cffunction name="getMeta" hint="Get the original metadata for this Class" access="public" returntype="struct" output="false">
	<cfreturn instance.meta />
</cffunction>

<cffunction name="getPackage" hint="returns the package this Class belongs to" access="public" returntype="string" output="false">
	<cfreturn instance.package />
</cffunction>

<cffunction name="getDeclaredMethods" hint="Returns a struct of Method objects reflecting all the methods declared by the class or interface represented by this Class object.
			This includes public, package, and private methods, but excludes inherited methods."
			access="public" returntype="struct" output="false" colddoc:generic="string,Method">
	<cfreturn getDeclaredMethodsCollection().getCollection() />
</cffunction>

<cffunction name="getDeclaredMethod" hint="returns a declared method. If the method could not be found, an exception is thrown." access="public" returntype="Method" output="false">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">
	<cfscript>
		if(!hasDeclaredMethod (arguments.methodName))
		{
			createObject("component", "coldspring.core.reflect.exception.MethodNotFoundException").init(getName(), arguments.methodName, true);
		}

		return getDeclaredMethodsCollection().get(arguments.methodName);
    </cfscript>
</cffunction>

<cffunction name="hasDeclaredMethod" hint="Whether or not this class has declared this specific method" access="public" returntype="boolean" output="false">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">
	<cfscript>
    	return structKeyExists(getDeclaredMethods(), arguments.methodName);
    </cfscript>
</cffunction>

<cffunction name="getMethod" hint="returns a public method that exists on this class or a superclass.
			<br/>If the method could not be found and this class has an onMissingMethod, a method will be returned with isConcrete:false, otherwise an exception is thrown."
			access="public" returntype="Method" output="false">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">
	<cfscript>
    	if(!hasMethod(arguments.methodName))
    	{
    		createObject("component", "coldspring.core.reflect.exception.MethodNotFoundException").init(getName(), arguments.methodName, false);
    	}

    	if(hasOnMissingMethod() && !structKeyExists (getMethods(), arguments.methodName))
    	{
    		return getMissingMethod(arguments.methodName);
    	}

		return getMethodsCollection().get(arguments.methodName);
    </cfscript>
</cffunction>

<cffunction name="hasMethod" hint="Whether or not this class has this public method on this class or superclass. If an implementation of onMissingMethod exists on this class, then this method will always return true."
		access="public" returntype="boolean" output="false">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">
	<cfscript>
		if(hasOnMissingMethod())
		{
			return true;
		}

    	return structKeyExists(getMethods(), arguments.methodName);
    </cfscript>
</cffunction>

<cffunction name="getDeclaredMethodsCollection" hint="Collection access to the declared methods, for closure support." access="public" returntype="coldspring.util.Collection" output="false">
	<cfreturn instance.declaredMethodsCollection />
</cffunction>

<cffunction name="getMethods" hint="Returns a struct containing Method objects reflecting all the public member methods of the class or interface represented by
	this Class object, including those declared by the class or interface and those inherited from superclasses and superinterfaces."
	access="public" returntype="struct" output="false" colddoc:generic="string,Method">
	<cfreturn getMethodsCollection().getCollection() />
</cffunction>

<cffunction name="getMethodsCollection" hint="Collection interface to the public Methods on this Class" access="public" returntype="coldspring.util.Collection" output="false">
	<cfreturn instance.methodsCollection />
</cffunction>

<cffunction name="hasAnnotation" hint="does the given annotation exist on this class. If it cannot be found on this class, check the superclass if one exists." access="public" returntype="boolean" output="false">
	<cfargument name="annotation" hint="the name of the annotation" type="string" required="Yes">
	<cfscript>
		var found = structKeyExists(getMeta(), arguments.annotation);

		if(!found && hasSuperClass())
		{
			return getSuperClass().hasAnnotation(arguments.annotation);
		}

		return found;
    </cfscript>
</cffunction>

<cffunction name="getAnnotation" hint="Gets the value of this annotation from the metadata, and returns it. It it can't be found on this class, check the parent." access="public" returntype="boolean" output="false">
	<cfargument name="annotation" hint="the name of the annotation" type="string" required="Yes">
	<cfscript>
		if(!structKeyExists(getMeta(), arguments.annotation) && hasSuperClass())
		{
			return getSuperClass().getAnnotation(arguments.annotation);
		}

    	return structFind(getMeta(), arguments.annotation);
    </cfscript>
</cffunction>

<cffunction name="isInterface" access="public" returntype="boolean" output="false">
	<cfreturn instance.interface />
</cffunction>

<cffunction name="getSuperClass" hint="Returns the Class representing the superclass of the entity represented by this Class.<br/>
	If this Class represents an interface then there is no super class. Look at getInterfaces() instead."
	access="public" returntype="coldspring.core.reflect.Class" output="false">
	<cfreturn instance.superclass />
</cffunction>

<cffunction name="hasSuperClass" hint="whether this object has a superClass" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "superClass") />
</cffunction>

<cffunction name="getInterfaces" hint="Determines the interfaces implemented by the class or interface represented by this object.<br/>
	If this object represents a class, the return value is an array containing objects representing all interfaces implemented by the class.<br/>
	If this object represents an interface, the array contains objects representing all interfaces extended by the interface.<br/>
	If this object represents a class or interface that implements no interfaces, the method returns an array of length 0."
	access="public" returntype="array" output="false" colddoc:generic="Class">
	<cfreturn instance.interfaces />
</cffunction>

<cffunction name="hasOnMissingMethod" hint="convenience method for checking to see if this class has an onMissingMethod implementation"
			access="public" returntype="boolean" output="false">
	<cfscript>
		//don't do this through hasMethod, as otherwise we will get a stack overflow.
    	return structKeyExists(getMethods(), meta.const.ON_MISSING_METHOD);
    </cfscript>
</cffunction>

<cffunction name="isAssignableFrom" hint="Determines if the class or interface represented by this Class object is either the same as,
			or is a superclass or superinterface of, the class or interface represented by the specified Class parameter.
			It returns true if so; otherwise it returns false."
			access="public" returntype="boolean" output="false">
	<cfargument name="className" hint="The name of th class to determine if this class is assignable from" type="string" required="Yes">
	<cfscript>
		var cache = getAssignableCache();

		if(!structKeyExists (cache, arguments.className))
		{
			cache[arguments.className] = buildIsAssignableFrom(arguments.className);
		}

		return cache[arguments.className];
    </cfscript>
</cffunction>

<cffunction name="eachClassInTypeHierarchy" hint="Calls the closure for each class type in inheritence, and also for each interface it implements
				with the coldspring.core.reflect.Class as the single argument passed in.<br/>
				If the closure returns 'false', processing is stopped" access="public" returntype="void" output="false">
	<cfargument name="closure" hint="the closure to fire for each class type found a" type="coldspring.util.Closure" required="Yes">
	<cfscript>
		var local = {};
		var queue = createObject("java", "java.util.ArrayDeque").init();
		var class = 0;
		var len = 0;
		var counter = 0;
		var interfaces = 0;

		queue.add(this);

		while(!queue.isEmpty())
		{
			class = queue.remove();

			local.return = arguments.closure.call(class);

			if(structKeyExists(local, "result") && !local.result)
			{
				return;
			}

			if(class.hasSuperClass())
			{
				queue.add(class.getSuperClass());
			}

			interfaces = class.getInterfaces();
			len = arraylen(interfaces);

			for(counter = 1; counter <= len; counter++)
			{
				queue.add(interfaces[counter]);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="getDeclaredPropertiesCollection" hint="Collection access to the declared proprties, for closure support." access="public" returntype="coldspring.util.Collection" output="false">
	<cfreturn instance.declaredPropertiesCollection />
</cffunction>

<cffunction name="getDeclaredProperties" hint="Get access to all properties declared directly on this class. Does not look up inheritence hierarchies." access="public" returntype="struct" output="false">
	<cfreturn getDeclaredPropertiesCollection().getCollection() />
</cffunction>

<cffunction name="getPropertiesCollection" hint="Collection access to all proprties, including up the inheritence chain, for closure support." access="public" returntype="coldspring.util.Collection" output="false">
	<cfreturn instance.propertiesCollection />
</cffunction>

<cffunction name="hasDeclaredProperty" hint="whether this object has a declared property. Does not Look up the inheritence chain." access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the property to look for" type="string" required="Yes">
	<cfreturn StructKeyExists(getDeclaredProperties(), arguments.name) />
</cffunction>

<cffunction name="getDeclaredProperty" hint="gets a declared property by name. Doesn't look up the inheritence chain." access="public" returntype="Property" output="false">
	<cfargument name="name" hint="the name of the property to look for" type="string" required="Yes">
	<cfscript>
    	if(!hasDeclaredProperty(arguments.name))
    	{
    		createObject("component", "coldspring.core.reflect.exception.PropertyNotFoundException").init(getName(), arguments.name, true);
    	}

		return getDeclaredPropertiesCollection().get(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="getProperties" hint="Get access to all properties on this classincluding up the inheritence chain." access="public" returntype="struct" output="false">
	<cfreturn getPropertiesCollection().getCollection() />
</cffunction>

<cffunction name="getProperty" hint="gets a property by name. Look up the inheritence chain." access="public" returntype="Property" output="false">
	<cfargument name="name" hint="the name of the property to look for" type="string" required="Yes">
	<cfscript>
    	if(!hasProperty(arguments.name))
    	{
    		createObject("component", "coldspring.core.reflect.exception.PropertyNotFoundException").init(getName(), arguments.name, false);
    	}

		return getPropertiesCollection().get(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="hasProperty" hint="whether this object has a Property. Looks up inheritence chain." access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the property to look for" type="string" required="Yes">
	<cfreturn StructKeyExists(getProperties(), arguments.name) />
</cffunction>

<cffunction name="isAccessorsEnabled" hint="Whether or not cfproperty tags will create get/set methods on this object" access="public" returntype="boolean" output="false">
	<cfscript>
		var meta = getMeta();
		if(structKeyExists(meta, "accessors"))
		{
			return meta.accessors;
		}

		if(structKeyExists(meta, "persistent"))
		{
			return meta.persistent;
		}

		return false;
    </cfscript>
</cffunction>

<cffunction name="$equals" hint="equality test with another Class object" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class to test equality with" type="Class" required="Yes">
	<cfreturn getName() eq arguments.class.getName() />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildIsAssignableFrom" hint="does tha calculation to determine if this class is assignable from to the argument class" access="private" returntype="boolean" output="false">
	<cfargument name="className" hint="The name of the class to determine if this class is assignable from" type="string" required="Yes">
	<cfscript>
		var closure = 0;
		var class = 0;

		if(!getReflectionService().classExists(arguments.className))
		{
			return false;
		}

		closure = createObject("component", "coldspring.util.Closure").init(classTypeCheck);
		class = getReflectionService().loadClass(arguments.className);

		closure.bind("result", false);
		closure.bind("class", this);

		class.eachClassInTypeHierarchy(closure);

		return closure.bound("result");
    </cfscript>
</cffunction>

<cffunction name="buildSuperClasses" hint="builds the super class if this is a class, and it has one" access="private" returntype="void" output="false">
	<cfscript>
    	var local = {};

    	if(isInterface())
    	{
    		return;
    	}

    	if(structKeyExists(getMeta(), "extends"))
    	{
    		setSuperclass(getReflectionService().loadClass(getMeta().extends.name));
    	}
    </cfscript>
</cffunction>

<cffunction name="buildInterfaces" hint="build all the interfaces this class/interface has" access="private" returntype="void" output="false">
	<cfscript>
		var interfaces = [];
		var key = 0;
		var meta = getMeta();

		if(isInterface())
		{
			if(structKeyExists(meta, "extends"))
	        {
	        	for(key in meta.extends)
	        	{
	        		arrayAppend(interfaces, getReflectionService().loadClass(meta.extends[key].name));
	        	}
	        }
		}
		else
		{
			if(structKeyExists(meta, "implements"))
	        {
	        	for(key in meta.implements)
	        	{
	        		arrayAppend(interfaces, getReflectionService().loadClass(meta.implements[key].name));
	        	}
	        }
		}

    	setInterfaces(interfaces);
    </cfscript>
</cffunction>

<cffunction name="buildDeclaredMethods" hint="builds all the declared methods for this Class" access="private" returntype="void" output="false">
	<cfscript>
    	var methods = {};
    	var collection = createObject("component", "coldspring.util.Collection").init(methods);
    	var meta = getMeta();
    	var len = 0;
    	var counter = 1;
    	var fun = 0;
    	var method = 0;

		if(StructKeyExists(meta, "functions"))
		{
			len = Arraylen(meta.functions);
			for(; counter <= len; counter++)
			{
				method = createObject("component","coldspring.core.reflect.Method").init(meta.functions[counter], this);
				methods[method.getName()] = method;
			}
		}

		setDeclaredMethodsCollection(collection);
    </cfscript>
</cffunction>

<cffunction name="buildDeclaredProperties" hint="builds all the declared properties for this Class" access="private" returntype="void" output="false">
	<cfscript>
    	var properties = {};
    	var collection = createObject("component", "coldspring.util.Collection").init(properties);
    	var meta = getMeta();
    	var len = 0;
    	var counter = 1;
    	var fun = 0;
    	var property = 0;

		if(StructKeyExists(meta, "properties"))
		{
			len = Arraylen(meta.properties);
			for(; counter <= len; counter++)
			{
				property = createObject("component","coldspring.core.reflect.Property").init(meta.properties[counter]);
				properties[property.getName()] = property;
			}
		}

		setDeclaredPropertiesCollection(collection);
    </cfscript>
</cffunction>

<cffunction name="buildMethods" hint="builds all the public methods, and add in any parent methods" access="private" returntype="void" output="false">
	<cfscript>
    	var methods = {};
    	var publicMethods = createObject("component", "coldspring.util.Collection").init(methods);

    	if(hasSuperClass())
    	{
    		publicMethods.addAll(getSuperClass().getMethods());
    	}

    	publicMethods.addAll(getDeclaredMethodsCollection().findAll(meta.const.IS_PUBLIC_CLOSURE).getCollection());

		/*
		var currentClass = this;

		//setup a queue, so we can go in reverse, down the chain, overwriting methods as we go.
		var queue = createObject("java", "java.util.ArrayDeque").init();

		queue.add(getDeclaredMethodsCollection().findAll(meta.const.IS_PUBLIC_CLOSURE).getCollection());

		while(currentClass.hasSuperClass())
		{
			currentClass = currentClass.getSuperClass();
			queue.add(currentClass.getMethods());
		}

		//now reverse the queue
		while(!queue.isEmpty())
		{
			publicMethods.addAll(queue.pollLast());
		}
		*/

		setMethodsCollection(publicMethods);
    </cfscript>
</cffunction>

<cffunction name="buildProperties" hint="builds all the proprties, and add in any parent properties" access="private" returntype="void" output="false">
	<cfscript>
    	var methods = {};
    	var properties = createObject("component", "coldspring.util.Collection").init(methods);

		if(hasSuperClass())
		{
			properties.addAll(getSuperClass().getProperties());
		}

		properties.addAll(getDeclaredProperties());

		setPropertiesCollection(properties);
    </cfscript>
</cffunction>

<cffunction name="getMissingMethod" hint="returns a method to represent a missing method implementation" access="private" returntype="Method" output="false">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">
	<cfscript>
		var missingMethods = getMissingMethods();
		var methodMeta = 0;

		if(!structKeyExists (missingMethods, arguments.methodName))
		{
			methodMeta = duplicate(getMethod(meta.const.ON_MISSING_METHOD).getMeta());
			methodMeta.name = arguments.methodName;
			methodMeta.parameters = [];

			missingMethods[arguments.methodName] = createObject("component", "Method").init(methodMeta, this, false);
		}

		return missingMethods[arguments.methodName];
    </cfscript>
</cffunction>

<cffunction name="setInterfaces" access="private" returntype="void" output="false">
	<cfargument name="interfaces" type="array" required="true" colddoc:generic="Class">
	<cfset instance.interfaces = arguments.interfaces />
</cffunction>

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="meta" type="struct" required="true">
	<cfset instance.meta = arguments.meta />
</cffunction>

<cffunction name="setPackage" access="private" returntype="void" output="false">
	<cfargument name="package" type="string" required="true">
	<cfset instance.package = arguments.package />
</cffunction>

<cffunction name="setInterface" access="private" returntype="void" output="false">
	<cfargument name="interface" type="boolean" required="true">
	<cfset instance.interface = arguments.interface />
</cffunction>

<cffunction name="setDeclaredMethodsCollection" access="private" returntype="void" output="false">
	<cfargument name="declaredMethodsCollection" type="coldspring.util.Collection" required="true">
	<cfset instance.declaredMethodsCollection = arguments.declaredMethodsCollection />
</cffunction>

<cffunction name="setMethodsCollection" access="private" returntype="void" output="false">
	<cfargument name="methodsCollection" type="coldspring.util.Collection" required="true">
	<cfset instance.methodsCollection = arguments.methodsCollection />
</cffunction>

<cffunction name="setSuperClass" access="private" returntype="void" output="false">
	<cfargument name="superclass" type="coldspring.core.reflect.Class" required="true">
	<cfset instance.superclass = arguments.superclass />
</cffunction>

<cffunction name="getMissingMethods" access="private" returntype="struct" output="false" colddoc:generic="string,Method">
	<cfreturn instance.missingMethods />
</cffunction>

<cffunction name="setMissingMethods" access="private" returntype="void" output="false">
	<cfargument name="missingMethods" type="struct" required="true" colddoc:generic="string,Method">
	<cfset instance.missingMethods = arguments.missingMethods />
</cffunction>

<cffunction name="getReflectionService" access="private" returntype="coldspring.core.reflect.ReflectionService" output="false">
	<cfreturn instance.reflectionService />
</cffunction>

<cffunction name="setReflectionService" access="private" returntype="void" output="false">
	<cfargument name="reflectionService" type="coldspring.core.reflect.ReflectionService" required="true">
	<cfset instance.reflectionService = arguments.reflectionService />
</cffunction>

<cffunction name="getAssignableCache" access="private" returntype="struct" output="false">
	<cfreturn instance.assignableCache />
</cffunction>

<cffunction name="setAssignableCache" access="private" returntype="void" output="false">
	<cfargument name="assignableCache" type="struct" required="true">
	<cfset instance.assignableCache = arguments.assignableCache />
</cffunction>

<cffunction name="setDeclaredPropertiesCollection" access="private" returntype="void" output="false">
	<cfargument name="declaredPropertiesCollection" type="coldspring.util.Collection" required="true">
	<cfset instance.declaredPropertiesCollection = arguments.declaredPropertiesCollection />
</cffunction>

<cffunction name="setPropertiesCollection" access="private" returntype="void" output="false">
	<cfargument name="propertiesCollection" type="coldspring.util.Collection" required="true">
	<cfset instance.propertiesCollection = arguments.propertiesCollection />
</cffunction>

<!--- closure methods --->

<cffunction name="checkIsPublic" hint="is this method public?" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="the method to check" type="coldspring.core.reflect.Method" required="Yes">
	<cfscript>
		return (arguments.method.getAccess() eq "public");
    </cfscript>
</cffunction>

<cffunction name="classTypeCheck" hint="check to see if the given className is the same as the passed in one" access="private" returntype="boolean" output="false">
	<cfargument name="class" hint="the class to check" type="Class" required="Yes">
	<cfscript>
		if(arguments.class.$equals(variables.class))
		{
			//bound variable from closure.
			variables.result = true;
			return false;
		}

		return true;
    </cfscript>
</cffunction>

<!--- /closure methods --->

</cfcomponent>