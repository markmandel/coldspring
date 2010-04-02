<!---
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
 --->

<cfinterface hint="
	Interface to be implemented by objects used within a BeanFactory  which are themselves factories. If a bean implements this interface, it is used as a factory for an object to expose, not directly as a bean instance that will be exposed itself.<br/>
	NB: A bean that implements this interface cannot be used as a normal bean. A FactoryBean is defined in a bean style, but the object exposed for bean references (getObject() is always the object that it creates.<br/>
	FactoryBeans can support singletons and prototypes, and can either create objects lazily on demand or eagerly on startup.<br/>
	This interface is heavily used within the framework itself. It can be used for application components as well; however, this is not common outside of infrastructure code.<br/>
	NOTE: FactoryBean objects participate in the containing BeanFactory's synchronization of bean creation. There is usually no need for internal synchronization other than for purposes of lazy initialization within the FactoryBean itself (or the like).<br/>">

<cffunction name="getObject" hint="Return an instance (possibly shared or independent) of the object managed by this factory." access="public" returntype="any" output="false">
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="
	Return the type of object that this FactoryBean creates, or an empty string if not known in advance.  This must be a valid CFC type.<br/>
	This allows one to check for specific types of beans without instantiating objects, for example on autowiring.<br/>
	In the case of implementations that are creating a singleton object, this method should try to avoid singleton creation as far as possible; it should rather estimate the type in advance. For prototypes, returning a meaningful type here is advisable too.<br/>
	This method can be called before this FactoryBean has been fully initialized. It must not rely on state created during initialization; of course, it can still use such state if available.<br/>
	<strong>NOTE:</strong> Autowiring by type will simply ignore FactoryBeans that return an empty string here. Therefore it is highly recommended to implement this method properly, using the current state of the FactoryBean.
	">
</cffunction>

<cffunction name="isSingleton" access="public" returntype="boolean" output="false" hint="
	Is the object managed by this factory a singleton? That is, will getObject() always return the same object (a reference that can be cached)?<br/>
	NOTE: If a FactoryBean indicates to hold a singleton object, the object returned from getObject() might get cached by the owning BeanFactory. Hence, do not return true unless the FactoryBean always exposes the same reference.<br/>
	The singleton status of the FactoryBean itself will generally be provided by the owning BeanFactory; usually, it has to be defined as singleton there.<br/>
	">
</cffunction>

</cfinterface>