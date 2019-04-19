module Test.Data where

atomFeedXml :: String
atomFeedXml = """<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
    <entry />
    <entry />
    <entry />
</feed>
"""

cdCatalogXml :: String
cdCatalogXml = """<?xml version="1.0" encoding="UTF-8"?>
<CATALOG>
  <CD>
    <TITLE>Empire Burlesque</TITLE>
    <ARTIST>Bob Dylan</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>Columbia</COMPANY>
    <PRICE>10.90</PRICE>
    <YEAR>1985</YEAR>
  </CD>
  <CD>
    <TITLE>Hide your heart</TITLE>
    <ARTIST>Bonnie Tyler</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>CBS Records</COMPANY>
    <PRICE>9.90</PRICE>
    <YEAR>1988</YEAR>
  </CD>
  <CD>
    <TITLE>Greatest Hits</TITLE>
    <ARTIST>Dolly Parton</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>RCA</COMPANY>
    <PRICE>9.90</PRICE>
    <YEAR>1982</YEAR>
  </CD>
  <CD>
    <TITLE>Still got the blues</TITLE>
    <ARTIST>Gary Moore</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Virgin records</COMPANY>
    <PRICE>10.20</PRICE>
    <YEAR>1990</YEAR>
  </CD>
  <CD>
    <TITLE>Eros</TITLE>
    <ARTIST>Eros Ramazzotti</ARTIST>
    <COUNTRY>EU</COUNTRY>
    <COMPANY>BMG</COMPANY>
    <PRICE>9.90</PRICE>
    <YEAR>1997</YEAR>
  </CD>
  <CD>
    <TITLE>One night only</TITLE>
    <ARTIST>Bee Gees</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Polydor</COMPANY>
    <PRICE>10.90</PRICE>
    <YEAR>1998</YEAR>
  </CD>
  <CD>
    <TITLE>Sylvias Mother</TITLE>
    <ARTIST>Dr.Hook</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>CBS</COMPANY>
    <PRICE>8.10</PRICE>
    <YEAR>1973</YEAR>
  </CD>
  <CD>
    <TITLE>Maggie May</TITLE>
    <ARTIST>Rod Stewart</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Pickwick</COMPANY>
    <PRICE>8.50</PRICE>
    <YEAR>1990</YEAR>
  </CD>
  <CD>
    <TITLE>Romanza</TITLE>
    <ARTIST>Andrea Bocelli</ARTIST>
    <COUNTRY>EU</COUNTRY>
    <COMPANY>Polydor</COMPANY>
    <PRICE>10.80</PRICE>
    <YEAR>1996</YEAR>
  </CD>
  <CD>
    <TITLE>When a man loves a woman</TITLE>
    <ARTIST>Percy Sledge</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>Atlantic</COMPANY>
    <PRICE>8.70</PRICE>
    <YEAR>1987</YEAR>
  </CD>
  <CD>
    <TITLE>Black angel</TITLE>
    <ARTIST>Savage Rose</ARTIST>
    <COUNTRY>EU</COUNTRY>
    <COMPANY>Mega</COMPANY>
    <PRICE>10.90</PRICE>
    <YEAR>1995</YEAR>
  </CD>
  <CD>
    <TITLE>1999 Grammy Nominees</TITLE>
    <ARTIST>Many</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>Grammy</COMPANY>
    <PRICE>10.20</PRICE>
    <YEAR>1999</YEAR>
  </CD>
  <CD>
    <TITLE>For the good times</TITLE>
    <ARTIST>Kenny Rogers</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Mucik Master</COMPANY>
    <PRICE>8.70</PRICE>
    <YEAR>1995</YEAR>
  </CD>
  <CD>
    <TITLE>Big Willie style</TITLE>
    <ARTIST>Will Smith</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>Columbia</COMPANY>
    <PRICE>9.90</PRICE>
    <YEAR>1997</YEAR>
  </CD>
  <CD>
    <TITLE>Tupelo Honey</TITLE>
    <ARTIST>Van Morrison</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Polydor</COMPANY>
    <PRICE>8.20</PRICE>
    <YEAR>1971</YEAR>
  </CD>
  <CD>
    <TITLE>Soulsville</TITLE>
    <ARTIST>Jorn Hoel</ARTIST>
    <COUNTRY>Norway</COUNTRY>
    <COMPANY>WEA</COMPANY>
    <PRICE>7.90</PRICE>
    <YEAR>1996</YEAR>
  </CD>
  <CD>
    <TITLE>The very best of</TITLE>
    <ARTIST>Cat Stevens</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Island</COMPANY>
    <PRICE>8.90</PRICE>
    <YEAR>1990</YEAR>
  </CD>
  <CD>
    <TITLE>Stop</TITLE>
    <ARTIST>Sam Brown</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>A and M</COMPANY>
    <PRICE>8.90</PRICE>
    <YEAR>1988</YEAR>
  </CD>
  <CD>
    <TITLE>Bridge of Spies</TITLE>
    <ARTIST>T'Pau</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Siren</COMPANY>
    <PRICE>7.90</PRICE>
    <YEAR>1987</YEAR>
  </CD>
  <CD>
    <TITLE>Private Dancer</TITLE>
    <ARTIST>Tina Turner</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>Capitol</COMPANY>
    <PRICE>8.90</PRICE>
    <YEAR>1983</YEAR>
  </CD>
  <CD>
    <TITLE>Midt om natten</TITLE>
    <ARTIST>Kim Larsen</ARTIST>
    <COUNTRY>EU</COUNTRY>
    <COMPANY>Medley</COMPANY>
    <PRICE>7.80</PRICE>
    <YEAR>1983</YEAR>
  </CD>
  <CD>
    <TITLE>Pavarotti Gala Concert</TITLE>
    <ARTIST>Luciano Pavarotti</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>DECCA</COMPANY>
    <PRICE>9.90</PRICE>
    <YEAR>1991</YEAR>
  </CD>
  <CD>
    <TITLE>The dock of the bay</TITLE>
    <ARTIST>Otis Redding</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>Stax Records</COMPANY>
    <PRICE>7.90</PRICE>
    <YEAR>1968</YEAR>
  </CD>
  <CD>
    <TITLE>Picture book</TITLE>
    <ARTIST>Simply Red</ARTIST>
    <COUNTRY>EU</COUNTRY>
    <COMPANY>Elektra</COMPANY>
    <PRICE>7.20</PRICE>
    <YEAR>1985</YEAR>
  </CD>
  <CD>
    <TITLE>Red</TITLE>
    <ARTIST>The Communards</ARTIST>
    <COUNTRY>UK</COUNTRY>
    <COMPANY>London</COMPANY>
    <PRICE>7.80</PRICE>
    <YEAR>1987</YEAR>
  </CD>
  <CD>
    <TITLE>Unchain my heart</TITLE>
    <ARTIST>Joe Cocker</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>EMI</COMPANY>
    <PRICE>8.20</PRICE>
    <YEAR>1987</YEAR>
  </CD>
</CATALOG>
"""

noteXml :: String
noteXml = """<?xml version="1.0" encoding="UTF-8"?>
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
"""

metajeloXml :: String
metajeloXml = """<?xml version="1.0" encoding="UTF-8"?>
<record xmlns:re3="http://www.re3data.org/schema/2-2"
 xmlns:datacite="http://datacite.org/schema/kernel-4"
 xmlns="http://ourdomain.cornell.edu/reuse/v.01"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://ourdomain.cornell.edu/reuse/v.01 file:/Users/clagoze/Downloads/metajelo-master/schema/xsd/reproMetadata0.7.xsd">
    <identifier identifierType="EISSN">OjlTjf</identifier>
    <date>2020-04-04</date>
    <lastModified>2019-05-04Z</lastModified>
    <relatedIdentifier relatedIdentifierType="LSID" relationType="IsDerivedFrom">v7Ra9f_</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="PMID" relationType="IsNewVersionOf">sm3AM1NbOSx</relatedIdentifier>
    <supplementaryProducts>
        <supplementaryProduct>
            <basicMetadata>
                <Title>niBi6PpDgbhM3</Title>
                <Creator>cbK1</Creator>
                <PublicationYear>2019-08-11Z</PublicationYear>
            </basicMetadata>
            <resourceID relatedIdentifierType="IGSN">bW8w2m5bzZ0WoKj7SBI_</resourceID>
            <resourceType resourceTypeGeneral="Event">cNMAxYjF0j0k</resourceType>
            <Format>
                <format>aPd4QER93hRARj3HudkWUwratMGEd</format>
                <format>Vf5ti6</format>
            </Format>
            <resourceMetadataSource relationType="HasMetadata">http://HgMuxvbx/</resourceMetadataSource>
            <location>
                <institutionID>LISSN</institutionID>
                <institutionName>pKhb</institutionName>
                <institutionType>commercial</institutionType>
                <superOrganizationName>DHv5J4LquWfN42iu1a</superOrganizationName>
                <institutionContact institutionContactType="dataCustodian">foo@baz.edu</institutionContact>
                <institutionSustainability>
                    <missionStatementURL>http://akbNcujU/</missionStatementURL>
                    <fundingStatementURL>http://tdjmeVUQ/</fundingStatementURL>
                </institutionSustainability>
                <institutionPolicies>
                    <institutionPolicy policyType="Quality" appliesToProduct="0">
                        <refPolicy>http://skGHargw/</refPolicy>
                    </institutionPolicy>
                    <institutionPolicy policyType="Preservation" appliesToProduct="1">
                        <freeTextPolicy>fqxRlcso3</freeTextPolicy>
                    </institutionPolicy>
                </institutionPolicies>
                <versioning>yes</versioning>
            </location>
        </supplementaryProduct>
        <supplementaryProduct>
            <basicMetadata>
                <Title>M._y</Title>
                <Creator>T4nUil6</Creator>
                <PublicationYear>2020-09-16Z</PublicationYear>
            </basicMetadata>
            <resourceID relatedIdentifierType="IGSN">lCi7-M50qjeFNhiAt</resourceID>
            <resourceType resourceTypeGeneral="Sound">ewNM9_1KtEgas9spr8PEY</resourceType>
            <Format>
                <format>S2Zq5</format>
                <format>JmjVZzqUrJ653r4_9Y8ex6RpZ</format>
            </Format>
            <resourceMetadataSource relationType="HasMetadata">http://iEhiBPjr/</resourceMetadataSource>
            <location>
                <institutionID>URL</institutionID>
                <institutionName>m0-XHPS</institutionName>
                <institutionType>commercial</institutionType>
                <superOrganizationName>Ld0KhpgrA_LdvGgp-WDVZgeIgtJkM</superOrganizationName>
                <institutionContact institutionContactType="dataCustodian">foo@bar.edu</institutionContact>
                <institutionSustainability>
                    <missionStatementURL>http://RadUMcWC/</missionStatementURL>
                    <fundingStatementURL>http://YWYwhJyz/</fundingStatementURL>
                </institutionSustainability>
                <institutionPolicies>
                    <institutionPolicy policyType="Data" appliesToProduct="0">
                        <freeTextPolicy>lo8H7YsHaOEYf4BvtW_RXXHFZ</freeTextPolicy>
                    </institutionPolicy>
                    <institutionPolicy policyType="Data" appliesToProduct="true">
                        <freeTextPolicy>eRNBB2</freeTextPolicy>
                    </institutionPolicy>
                </institutionPolicies>
                <versioning>yes</versioning>
            </location>
        </supplementaryProduct>
    </supplementaryProducts>
</record>
"""
