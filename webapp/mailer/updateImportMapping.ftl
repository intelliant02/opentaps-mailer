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
<@import location="component://mailer/webapp/mailer/commonFormMacros.ftl"/>
<div class="allSubSectionBlocks">
	<div class="form">
		<form id="updateImportMappingForm" name="updateImportMappingForm" action="<@ofbizUrl>updateImportMapping</@ofbizUrl>" method="post" enctype="multipart/form-data" class="basic-form">
			<@inputHidden name="importMapperId" value="${importMapping.importMapperId}"/>
			<table width="100%">
				<tr>
					<td>
						<div class="rowContainer">
							<div class="label">
								<@display class="tableheadtext requiredField" text=uiLabelMap.CommonName />
							</div>
							<div class="fieldContainer">
								<@inputText name="importMapperName" size=35 class="inputBox required" default="${importMapping.importMapperName}" />
							</div>
							<div class="label">
								<@display class="tableheadtext" text=uiLabelMap.LabelSampleImport />
							</div>
							<div class="fieldContainer">
								<@display class="tabletext" text='${importMapping.getRelatedOne("Content").get("contentName")} (${importMapping.contentId})' />
							</div>
						</div>
						<div class="rowContainer">
							<div class="label">
								<@display class="tableheadtext" text=uiLabelMap.LabelCreatedByUser />
							</div>
							<div class="fieldContainer">
								<@display class="tabletext" text="${importMapping.createdByUserLogin?if_exists}" />
							</div>
							<div class="label">
								<@display class="tableheadtext" text=uiLabelMap.LabelLastUpdatedByUser />
							</div>
							<div class="fieldContainer">
								<@display class="tabletext" text="${importMapping.lastModifiedByUserLogin?if_exists}" />
							</div>
						</div>
						<div class="rowContainer">
							<div class="label">
								<@display class="tableheadtext" text=uiLabelMap.CommonDescription />
							</div>
							<div class="fieldContainer">
								<@inputTextarea name="description" rows=4 cols=35 default="${importMapping.description?if_exists}"/>
							</div>
							<div class="label">
								<@display class="tableheadtext" text=uiLabelMap.IsFirstRowHeader />
							</div>
							<div class="fieldContainer">		
								<#assign yes = Static["org.ofbiz.base.util.UtilMisc"].toMap("value", "Y", "name", "Yes")>							
								<#assign no = Static["org.ofbiz.base.util.UtilMisc"].toMap("value", "N", "name", "No")>
								<#assign isFirstRowHeader = [yes, no]>								
								<@inputSelect name="isFirstRowHeader" default=importMapping.isFirstRowHeader list=isFirstRowHeader displayField="name" key="value" />            
								
							</div>
						</div>
						<#if lhsColumns?has_content>
							<#list lhsColumns as lhsColumn>
								<div class="rowContainer">
									<div class="label">
										<#if lhsColumn.get("isNotNull") == true ><span class="tableheadtext requiredField" ></#if>${lhsColumn.get("entityColDesc")}<#if lhsColumn.get("isNotNull") == true ></span></#if>
									</div>
									<div class="fieldContainer">
										<input type="hidden" name="entityColName_${lhsColumn_index}" value='${lhsColumn.get("entityColName")}'>
										<select class="dropDown <#if lhsColumn.get("isNotNull") == true >required</#if>" name="importFileColIdx_${lhsColumn_index}" id="importFileColIdx_${lhsColumn_index}">
											<option value=''>--select--</option>
											<#list rhsColumns as rhsColumn>
												<option value='${rhsColumn_index}' <#if (selectedIndex.get(lhsColumn_index)?string==rhsColumn_index?string) >selected='selected'</#if> >${rhsColumn}</option>
											</#list>
										</select>
									</div>
								</div>
							</#list>
						</#if>
						<#if (security.hasEntityPermission("MAILER_MAP", "_UPDATE", session))>
							<div class="rowContainer">
								<div class="label">&nbsp;</div>
								<div class="fieldContainer">
									<@inputSubmit title=uiLabelMap.ButtonUpdateMapping onClick="" class=smallSubmit />
								</div>
							</div>
						</#if>					
					</td>
				</tr>
			</table>			
		</form>
	</div>
</div>