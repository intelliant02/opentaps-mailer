<#if hasUpdatePermission?exists>
	<#assign removeLink>
		<a class='subMenuButton' href='#?contactListId=${contactList.contactListId}'>${uiLabelMap.ButtonRemoveSelected}</a>
	</#assign>
</#if>

<a name="ListContactListParties"></a>
<div class="subSectionHeader">
	<div class="subSectionTitle">${uiLabelMap.CrmContactListParties}</div>
	<div class="subMenuBar">
		${removeLink?if_exists}
		<a class="subMenuButton" href="importContactListForm?contactListId=${contactList.contactListId}">${uiLabelMap.ButtonImportContacts}</a>
  	</div>
</div>
