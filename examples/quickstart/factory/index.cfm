<cfimport taglib="../layout" prefix="layout" />

<cfoutput>
<layout:layout section="factory">
<h1>Using ColdSpring Factory Beans</h1>

<p>
	ColdSpring provides support for Factory Beans, which are <strong>special kinds of objects that create and return other
	objects</strong>. This example is a bit contrived for the sake of simplicity in demonstrating how factory beans work, however
	it should be enough to get you started.
</p>

<cfset productService = beanFactory.getBean('productService') />
<cfset product = productService.getProduct(14) />

<p>Should return 14 since that is the Product ID we used to create the Product: #product.getProductID()#</p>

</layout:layout>
</cfoutput>