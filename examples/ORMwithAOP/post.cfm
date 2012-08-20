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
	<cfparam name="url.id" />

	<cfimport prefix="tags" taglib="./tags">

	<cfscript>
		blogService = application.coldspring.getBean("blogService");

		//getPost() comes from the AbstractGateway's onMissingMethod.
		post = blogService.getPost(url.id);

		if(!structIsEmpty(form))
		{
			//newComment comes from the AbstractGateway's onMissingMethod.
			comment = blogService.newComment();

			comment.setName(form["comment-name"]);
			comment.setComment(form["comment-comment"]);

			post.addComment(comment);

			//Post's save cascades down to all comments. Makes life easy.
			post.save();
		}
	</cfscript>
</cfsilent>
<tags:layout>
<cfinclude template="./include/header.cfm" />

	<cfoutput>
	<h1>#post.getTitle()#</h1>

	<article class="row-fluid">
		<em>#dateFormat(post.getPostDate(), "dd mmm yyyy")# #timeFormat(post.getPostDate(), "hh:mm tt")#</em>
		<p>
			#post.getBody()#
		</p>
		<section class="comments">
			<h2>Comments:</h2>
			<ul>
			<cfloop array="#post.getComments()#" index="comment">
				<li>
					<em>#dateFormat(comment.getPostDate(), "dd mmm yyyy")# #timeFormat(comment.getPostDate(), "hh:mm tt")# - #comment.getName()#</em><br/>
					#comment.getComment()#
				</li>
			</cfloop>
			</ul>

		</section>

		<div class="span6">

		<form class="well form-horizontal" method="post">
			<h3>Add a Comment</h3>

			<div class="control-group">
				<label class="control-label" for="comment-name">Name:</label>
				<div class="controls">
					<input type="text" class="input-xlarge" id="comment-name" name="comment-name">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="comment-name">Comment:</label>
				<div class="controls">
					<textarea class="input-xlarge" name="comment-comment" id="comment-comment" rows="5"></textarea>
				</div>
			</div>
			<div class="form-actions">
				<button type="submit" class="btn btn-primary">Save changes</button>
			</div>
		</form>

		</div>

	</article>

	</cfoutput>

<cfinclude template="./include/footer.cfm" />
</tags:layout>