<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d='http://datacite.org/schema/kernel-3' >
<!-- 
The magic to get it to work is that the datacite namespace (which is declared for the <resource> element in the xml) 
is assigned to the prefix d (xmlns:d=...) in the declaration above.
The d: prefix is then used in the select attributes of the xsl statements
 -->
<xsl:template match="/">
  <html>
    <head>
      <meta charset="utf-8"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1"/>

      <title><xsl:value-of select="d:resource/d:identifier"/></title>

      <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css" rel="stylesheet" type="text/css" />

      <!-- <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css"/> -->
      <!-- <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css"/> -->

      <script type="text/javascript" src="http://code.jquery.com/jquery.js"></script>
      <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

    </head>
    <body>
      <div class="container">
        <div class="page-header">
          <h3>doi:<xsl:value-of select="d:resource/d:identifier"/></h3>
        </div>
        <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title">Overview</h3>
        </div>
          <div class="panel-body">
            <table class="table table-striped">
              <tr>
                <td>Title</td>
                <td><xsl:value-of select="d:resource/d:titles/d:title"/></td>
              </tr>

              <tr>
                <td>Authors</td>
                <td>
                  <xsl:for-each select="d:resource/d:creators/d:creator">
                    <xsl:value-of select="d:creatorName"/>
                    <xsl:if test="not(position()=last())">, </xsl:if>
                    <xsl:if test="position()=last()-1">and </xsl:if>
                  </xsl:for-each>

                </td>
              </tr>
              <tr>
                <td>Description</td>
                <td>
                  <xsl:for-each select="d:resource/d:descriptions/d:description">
                    <xsl:value-of select="."/>
                    <br/>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <td>Year</td>
                <td><xsl:value-of select="d:resource/d:publicationYear"/></td>
              </tr>
              <tr>
                <td>doi</td>
                <td><xsl:value-of select="d:resource/d:identifier"/></td>
              </tr>
              <tr>
                <td>Access constraints</td>
                <td>
                  <xsl:for-each select="d:resource/d:rightsList/d:rights">
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="./@rightsURI"/>
                      </xsl:attribute>
                      <xsl:value-of select="."/>
                    </xsl:element>
                    <br/>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <td>Cite as</td>
                <td>
                  <xsl:for-each select="d:resource/d:creators/d:creator">
                    <xsl:value-of select="d:creatorName"/>
                    <xsl:if test="not(position()=last())">, </xsl:if>
                    <xsl:if test="position()=last()-1">and </xsl:if>
                  </xsl:for-each>
                  (<xsl:value-of select="d:resource/d:publicationYear"/>)
                  <xsl:value-of select="d:resource/d:titles/d:title"/> 
                  <!-- <br/> -->
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      http://doi.org/<xsl:value-of select="d:resource/d:identifier"/>
                    </xsl:attribute> 
                    <xsl:value-of select="d:resource/d:identifier"/>
                  </xsl:element>
                </td>
              </tr>
              <tr>
                <td>Reference</td>
                <td></td>
              </tr>


            </table>
          </div>
        </div>
      </div>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>