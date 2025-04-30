<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="/questions">
        <html>
            <head>
                <title>Question List</title>
            </head>
            <body>
                <h1>Questions</h1>
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>Answer</th>
                    </tr>
                    <xsl:for-each select="question">
                        <tr>
                            <td><xsl:value-of select="id" /></td>
                            <td><xsl:value-of select="text" /></td>
                            <td><xsl:value-of select="answer" /></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
