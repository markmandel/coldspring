/*
	Copyright 2012 Mark Mandel

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
 * A blog post
 */
component persistent="true"
{
	property name="id" type="numeric" fieldtype="id" generator="native";
	property name="title" type="string";
	property name="body" type="string" ormType="text";
	property name="postDate" type="date" ormType="timestamp";

	property name="comments" fieldtype="one-to-many" cfc="Comment" singularname="Comment" fkcolumn="postid" type="array" orderby="postDate" cascade="all-delete-orphan";

	/**
	 * I don't normally do this, but wanted to show off how you can inject services into beans.
	 * But some people do like having a .save() method on their beans, so here is an example.
	 */
	property name="blogService" persistent="false";

	/**
	 * Constructor
	 */
	public Post function init()
	{
		setPostDate(Now());
		return this;
	}

	/**
	 * Save this bean
	 */
	public void function save()
	{
		getBlogService().save(this);
	}
}