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
<cfif thistag.executionmode eq "start"><!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>ColdSpring ORM with AOP Example - Blog Post List</title>

	<!-- Le styles -->
	<link href="./css/bootstrap.min.css" rel="stylesheet">
	<link href="./css/main.css" rel="stylesheet">
	<link href="./css/bootstrap-responsive.min.css" rel="stylesheet">

	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
</head>

<body>

<div class="navbar navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container">
			<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</a>
			<div class="nav-collapse">
				<ul class="nav">
					<li class="active"><a href="index.cfm">Home</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="container">
<cfelse>
</div>
<!--- /container --->

</body>
</html>
</cfif>