<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:template match="/">
	<html>
		<head>
			<meta charset="utf-8" />
			<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<meta name="viewport" content="width=device-width, initial-scale=1" />

			<title>AIDA DOI repository</title>

	    	<script type="text/javascript" src="https://code.jquery.com/jquery.min.js"></script>
	    	<script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
			<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css" />
			<style type="text/css">
				table {
				   font-size: 105% !important;
				}
			</style>
		</head>
		<body>
			<div class="container">
				<div class="jumbotron" style="margin-top: 10px">
				<!-- <div class="well" style="margin-top: 10px"> -->
	        		<a href="https://medtech4health.se/aida"><img src="https://medtech4health.se/wp-content/uploads/2018/01/AIDA-banner-smal.jpg" style="max-width: 100%" title="AIDA banner" /></a>
	        		<!-- <a href="https://bils.se"><img src="bilslogo-small.jpg" /></a> -->
	        		<h3>AIDA DOI repository</h3>
	        		<p class="text-info">
	        			<small>Permanent identifiers to datasets on the AIDA data hub.</small>
					</p>
					<p  class="text-muted">
						<small><a href="https://medtech4health.se/aida" title="AIDA">Analytic Imaging Diagnostics Arena</a>
						   is a Swedish arena for
						   research and innovation on artificial intelligence, AI, for
						   medical image analysis. Here, academia, healthcare and industry
						   will meet to translate technical advances in AI technology into
						   patient benefit in the form of clinically useful tools.
						</small>
					</p>
					<p  class="text-muted">
						<small><em>
							AIDA is an initiative within the Strategic
							innovation program <a href="https://medtech4health.se">Medtech4Health</a>,
							jointly supported by VINNOVA,	Formas and the Swedish Energy Agency.
						</em></small>
					</p>
				</div>

				<div class="panel panel-success">
	        		<div class="panel-heading">
	          			<h3 class="panel-title">Issued DOIs</h3>
	        		</div>
		        	<div class="panel-body">
		          		<table class="table table-striped">
		          			<thead>
			          			<tr>
			          				<th>DOI</th>
			          				<th>Authors</th>
			          				<th>Title</th>
			          				<th>Year</th>
			          			</tr>
			          		</thead>
			          		<tbody>
			          			<xsl:for-each select="response/result/doc">
			          				<xsl:sort select="str[@name='publicationYear']" />
			          				<xsl:sort select="str[@name='doi']" />
				          			<tr>
				          				<td>
				          					<xsl:element name="a">
	                      						<xsl:attribute name="href">
				          							<xsl:value-of select="str[@name='doi']"/>
				          						</xsl:attribute>
				          						<xsl:value-of select="str[@name='doi']"/>
				          					</xsl:element>
				          				</td>
				          				<td>
											<xsl:for-each select="arr[@name='creator']/str">
												<xsl:value-of select="."/>
												<xsl:if test="not(position()=last())">, </xsl:if>
												<xsl:if test="position()=last()-1">and </xsl:if>
											</xsl:for-each>

				          				</td>
				          				<td>
			          						<xsl:for-each select="arr[@name='title']/str">
			          							<xsl:value-of select="." /><br/>
			          						</xsl:for-each>
				          				</td>
				          				<td>
				          					<xsl:value-of select="str[@name='publicationYear']"/>
				          				</td>
				          			</tr>
			          			</xsl:for-each>
			          		</tbody>

		          		</table>
		          	</div>
				</div>
			</div>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>
