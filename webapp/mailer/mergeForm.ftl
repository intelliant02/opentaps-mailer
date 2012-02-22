<@import location="component://opentaps-common/webapp/common/includes/lib/opentapsFormMacros.ftl"/>
<@import location="component://mailer/webapp/mailer/commonFormMacros.ftl"/>

<div class="subSectionHeader">
    <div class="subSectionTitle">
      ${uiLabelMap.CrmFormLetterTemplate} <#if mergeFormId?has_content >[${mergeFormId}]</#if >
    </div>
</div>

<#if mergeFormId?has_content>
 <#assign formName="updateMergeForm" />
 <#assign formSubmit=uiLabelMap.CommonSave />
 <form method="post" action="deleteMergeForm" name="deleteMergeForm">
  <@inputHidden name="mergeFormId" value=mergeFormId />
 </form>
 <#else >
 <#assign formName="createMergeForm" />
 <#assign formSubmit=uiLabelMap.CommonCreate />
</#if >

<div class="form">
  <form id="mergedForm" method="post" action="<@ofbizUrl>${formName}</@ofbizUrl>" name="${formName}" style="margin: 0;" enctype="multipart/form-data">
    <#if mergeFormId?exists><@inputHidden name="mergeFormId" value=mergeFormId /></#if >
    <@inputHidden name="partyId" value=userLogin.partyId />
  
    <div class="formRow">
      <span class="formLabelRequired">${uiLabelMap.OpentapsTemplateName}</span>
      <span class="formInputSpan">
        <input type="text" class="inputBox required" name="mergeFormName" value="${(MailerMergeForm.mergeFormName)?if_exists}" size="50" maxlength="100"/>
      </span>
    </div>

	<div class="formRow">
      <span class="formLabelRequired">${uiLabelMap.LabelTemplateType}</span>
      <span class="formInputSpan">
		<@inputSelect name="mergeFormTypeId" default=MailerMergeForm.mergeFormTypeId?if_exists list=mergeFormTypesCombobox displayField="description" key="mergeFormTypeId" onChange="campaignTypeOnChange(this.value)" />  
      </span>
    </div>
    
    <div class="formRow" id="emailAddressContainer" <#if MailerMergeForm.mergeFormTypeId?exists && (MailerMergeForm.mergeFormTypeId?if_exists != "EMAIL") >style="display:none"</#if> >
      <span class="formLabelRequired">${uiLabelMap.LabelFromEmailAddress}</span>
      <span class="formInputSpan">
        <input type="text" class="inputBox required email" name="fromEmailAddress" value="${(MailerMergeForm.fromEmailAddress)?if_exists}" size="50" maxlength="100"/>
      </span>
    </div>
    <div id="headerFooterImageContainer" <#if !MailerMergeForm.mergeFormTypeId?exists || MailerMergeForm.mergeFormTypeId?if_exists != "PRINT" > style="display:none"</#if> >
	    <div class="formRow">
	      <span class="formLabel">${uiLabelMap.LabelTemplateHeaderImageLocation}</span>
	      <span class="formInputSpan">
	      	<input type="hidden" id="headerImageLocationRemove" name="headerImageLocationRemove" value="N" />
	      	<#if MailerMergeForm.headerImageLocation?exists && MailerMergeForm.headerImageLocation != "" >
	      		<#assign headerLink = MailerMergeForm.headerImageLocation >
	      		<div id="headerImageControl"><a href="#" onclick="preview('${headerLink}')" >Preview</a> <a href="javascript:void()" onclick="hideShowUploadImage('headerImageControl', 'headerImageLocationCont', 'headerImageLocationRemove')" >Remove</a></div>
		      	<div id="headerImageLocationCont" style="display:none"><@inputFile name="headerImageLocation" class="inputBox" /></div>
	      	<#else>
	      		<@inputFile name="headerImageLocation" class="inputBox" />
	      	</#if>
	      </span>
	    </div>
	    <div class="formRow">
	      <span class="formLabel">${uiLabelMap.LabelTemplateFooterImageLocation}</span>
	      <span class="formInputSpan">
	      	<input type="hidden" id="footerImageLocationRemove" name="footerImageLocationRemove" value="N" />
	      	<#if MailerMergeForm.footerImageLocation?exists  && MailerMergeForm.footerImageLocation != "" >
	      		<#assign footerLink = MailerMergeForm.footerImageLocation >	      		
	      		<div id="footerImageControl"><a href="#" onclick="preview('${footerLink}')" >Preview</a> <a href="javascript:void()" onclick="hideShowUploadImage('footerImageControl', 'footerImageLocationCont', 'footerImageLocationRemove')" >Remove</a></div>
	      		<div id="footerImageLocationCont" style="display:none"><@inputFile name="footerImageLocation" class="inputBox" /></div>
	      	<#else>
	      		<@inputFile name="footerImageLocation" class="inputBox" />
	      	</#if>	      	
	      </span>
	    </div>
    </div>
    
    <div class="formRow">
      <span class="formLabel">${uiLabelMap.CommonDescription}</span>
      <span class="formInputSpan">
        <input type="text" class="inputBox" name="description" size="50" value="${(MailerMergeForm.description)?if_exists}" maxlength="255"/>
      </span>
    </div>

    <div class="formRow">
      <#if (MailerMergeForm.mergeFormTypeId?if_exists) == "EMAIL" >
      	<#assign labelClass="formLabelRequired">
      	<#assign fieldClass="inputBox required">
      <#else>
      	<#assign labelClass="formLabel">
      	<#assign fieldClass="inputBox">
      </#if>
      <span class="${labelClass}" id="subjectLabel">${uiLabelMap.PartySubject}</span>
      <span class="formInputSpan">
        <input type="text" class="${fieldClass}" id="subject" name="subject" size="50" value="${(MailerMergeForm.subject)?if_exists}" maxlength="255"/>
      </span>
    </div>

    <div class="formRow">
      <span class="formLabelRequired">${uiLabelMap.LabelScheduledAt}</span>
      <span class="formInputSpan">
        <input type="text" class="inputBox smallTextfield required digits" name="scheduleAt" size="50" value="${(MailerMergeForm.scheduleAt)?if_exists}" maxlength="255"/>
        <span>[No of days]</span>
      </span>
    </div>

    <div class="formRow">
      <span class="formLabelRequired">${uiLabelMap.OpentapsTemplate}</span>
      <span class="formInputSpan">
        <@htmlTextArea class="required" textAreaId="mergeFormText" value=(MailerMergeForm.mergeFormText)?if_exists tagFileLocation="component://mailer/webapp/mailer/crmsfaFormEditorTags.ftl" style="width: 100%; height: 100%"/>
      </span>
    </div>

    <div class="formRow">
      <span class="formInputSpan">
        <input type="submit" class="smallSubmit" name="submitButton" value="${formSubmit}" onClick="" />
      </span>
    </div>

    <div class="spacer">&nbsp;</div>
  </form>
</div>
