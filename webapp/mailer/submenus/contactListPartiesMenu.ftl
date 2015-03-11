<#--
 * Copyright (c) Intelliant
 *
 * Opentaps is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Opentaps is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Opentaps.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  @author Intelliant (iaerp@intelliant.net)
 *
-->
<#if hasUpdatePermission?exists>
	<#assign removeLink>
		<a class='subMenuButton' href='#?contactListId=${contactList.contactListId}'>${uiLabelMap.ButtonRemoveSelected}</a>
	</#assign>
</#if>

<a name="ListContactListParties"></a>
<div class="subSectionHeader">
	<div class="subSectionTitle">${uiLabelMap.CrmContactListParties}</div>
	<div class="subMenuBar"><a class="subMenuButton" href="importContactListForm?contactListId=${contactList.contactListId}">${uiLabelMap.ButtonImportContacts}</a>${removeLink?if_exists}</div>
</div>
