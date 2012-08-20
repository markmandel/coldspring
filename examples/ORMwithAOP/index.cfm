<!---
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
--->
<cfsilent>
	<cfimport prefix="tags" taglib="./tags">

	<cfscript>
		blogService = application.coldspring.getBean("blogService");

		//listPost() comes from the AbstractGateway's onMissingMethod.
		posts = blogService.listPostOrderByPostDate();
	</cfscript>
</cfsilent>
<tags:layout>
<cfinclude template="./include/header.cfm" />

	<h1>ColdSpring ORM and AOP Blog Posts</h1>

	<cfoutput>
	<cfloop array="#posts#" index="post">
	<article class="row-fluid">
		<cfset len = ArrayLen(post.getComments()) />
		<em>#dateFormat(post.getPostDate(), "dd mmm yyyy")# #timeFormat(post.getPostDate(), "hh:mm tt")# - #len# Comment<cfif len neq 1>s</cfif></em>
		<h2><a href="post.cfm?id=#post.getID()#">#post.getTitle()#</a></h2>
		<p>
			#post.getBody()#
		</p>

	</article>
	</cfloop>

	</cfoutput>

<cfinclude template="./include/footer.cfm" />
</tags:layout>