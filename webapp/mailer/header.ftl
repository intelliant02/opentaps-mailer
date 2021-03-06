<#--
 * Copyright (c) Intelliant
 *
 * This is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Opentaps.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  @author Intelliant (open.ant@intelliant.net)
 *
-->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<@import location="component://mailer/webapp/mailer/commonFormMacros.ftl"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="Content-Script-Type" content="text/javascript"/>
    <meta http-equiv="Content-Style-Type" content="text/css"/>
    <title><#if pageTitleLabel?exists>${uiLabelMap.get(pageTitleLabel)} |</#if> ${configProperties.get(opentapsApplicationName+".title")}</title>

    <#assign appName = Static["org.ofbiz.base.util.UtilHttp"].getApplicationName(request)/>
  	<#assign nowAsString = Static["org.ofbiz.base.util.UtilDateTime"].nowAsString() />
  	<#assign versionSuffix = versionSuffix!"" />
  	<#assign favico = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("mailer.properties", "mailer.favico")>
    <#if favico?exists && favico?has_content>
    	<link rel="shortcut icon" href="<@ofbizContentUrl>${favico + versionSuffix}</@ofbizContentUrl>" />
    </#if>  	
    <#list Static["org.opentaps.common.util.UtilConfig"].getStylesheetFiles(opentapsApplicationName) as stylesheet>
      <link rel="stylesheet" href="<@ofbizContentUrl>${stylesheet + versionSuffix}</@ofbizContentUrl>" type="text/css"/>
    </#list>

    <#-- here is where the dynamic CSS goes, for changing theme color, etc. To activate this, define sectionName = 'section' -->
    <#if sectionName?exists>
      <#assign bgcolor = Static["org.opentaps.common.util.UtilConfig"].getSectionBgColor(opentapsApplicationName, sectionName)/>
      <#assign fgcolor = Static["org.opentaps.common.util.UtilConfig"].getSectionFgColor(opentapsApplicationName, sectionName)/>
      <style type="text/css">
h1, h2, .gwt-screenlet-header, .sectionHeader, .subSectionHeader, .subSectionTitle, .formSectionHeader, .formSectionHeaderTitle, .screenlet-header, .boxhead, .boxtop, div.boxtop {color: ${fgcolor}; background-color: ${bgcolor};}
div.sectionTabBorder, ul.sectionTabBar li.sectionTabButtonSelected a {color: ${fgcolor}; background-color: ${bgcolor};}
      </style>

      <script type="text/javascript">
        var bgColor = '${bgcolor?default("")?replace("#", "")}';
      </script>
      <script src="/${appName}/control/javascriptUiLabels.js${versionSuffix}" type="text/javascript"></script>

      <#assign javascripts = Static["org.opentaps.common.util.UtilConfig"].getJavascriptFiles(opentapsApplicationName, locale)/>

      <#if layoutSettings?exists && layoutSettings.javaScripts?has_content>
        <#assign javascripts = javascripts + layoutSettings.javaScripts/>
      </#if>
      <#list javascripts as javascript>
        <#if javascript?matches(".*dojo.*")>
          <#-- Unfortunately, due to Dojo's module-loading behaviour, it must be served locally --> 
          <script src="${javascript}" type="text/javascript" djConfig="isDebug: false, parseOnLoad: true <#if Static["org.ofbiz.base.util.UtilHttp"].getLocale(request)?exists>, locale: '${Static["org.ofbiz.base.util.UtilHttp"].getLocale(request).getLanguage()}'</#if>"></script>
        <#else>
          <script src="<@ofbizContentUrl>${javascript + versionSuffix}</@ofbizContentUrl>" type="text/javascript"></script>
        </#if>
      </#list>
    </#if>
    <#if gwtScripts?exists>
      <meta name="gwt:property" content="locale=${locale}"/>
    </#if>
</head>
<body>
  <#assign callInEventIcon = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("asterisk.properties", "asterisk.icon.callInEvent")>
  <#if gwtScripts?exists>
    <#list gwtScripts as gwtScript>
      <@gwtModule widget=gwtScript />
    </#list>
    <#-- Bridge between server data and GWT widgets -->
    <script type="text/javascript" language="javascript">
      <#-- expose base permissions to GWT -->
      <#if user?has_content>
        var securityUser = new Object();
        <#list user.permissions as permission>
          securityUser["${permission}"] = true;
        </#list>
      </#if>
      <#-- set up the OpentapsConfig dictionary (see OpentapsConfig.java) -->
      var OpentapsConfig = {
      <#if configProperties.defaultCountryCode?has_content>
        defaultCountryCode: "${configProperties.defaultCountryCode}",
      </#if>
      <#if configProperties.defaultCountryGeoId?has_content>
        defaultCountryGeoId: "${configProperties.defaultCountryGeoId}",
      </#if>
      <#if configProperties.defaultCurrencyUomId?has_content>
        defaultCurrencyUomId: "${configProperties.defaultCurrencyUomId}",
      </#if>
      <#if callInEventIcon?has_content>
        callInEventIcon: "${callInEventIcon}",
      </#if>      
        applicationName: "${opentapsApplicationName}"
      };
    </script>
  </#if>

  <div style="float: left; margin-left:20px">
    <img alt="${configProperties.get(opentapsApplicationName+".title")}" src="<@ofbizContentUrl>${configProperties.get("mailer.logo") + versionSuffix}</@ofbizContentUrl>"/>
  </div>
  <div align="right" style="margin-left: 300px; margin-right: 10px; margin-top: 10px;">
    <div class="insideHeaderText">
      <#if person?has_content>
        ${uiLabelMap.CommonWelcome}&nbsp;${person.firstName?if_exists}&nbsp;${person.lastName?if_exists}
      <#elseif partyGroup?has_content>
        ${uiLabelMap.CommonWelcome}&nbsp;${partyGroup.groupName?if_exists}
      <#else>
      </#if>
      <#if requestAttributes.userLogin?has_content>
      	<div class="insideHeaderSubtext">
			<a class="buttontext" href="<@ofbizUrl>myMessages</@ofbizUrl>">Inbox</a><span id="numMessages"></span>
        	<a href="<@ofbizUrl>logout</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonLogout}</a>
        </div>
      </#if>
    </div>
    <div class="gwtAsteriskNotification" id="gwtAsteriskNotification"></div>
  </div>
  <div class="spacer"></div>