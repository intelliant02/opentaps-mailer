/*
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
 */
package net.intelliant.imports;

import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.security.Security;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;
import org.opentaps.common.util.UtilMessage;

public class ImportServices {
	private static final String MODULE = ImportServices.class.getName();
	private static final String errorResource = "ErrorLabels";

	@SuppressWarnings("unchecked")
	public static Map<String, Object> configureImportMapping(DispatchContext dctx, Map<String, Object> context) {
		Map<String, Object> serviceResults = ServiceUtil.returnSuccess();
		Locale locale = (Locale) context.get("locale");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String importMapperName = (String) context.get("importMapperName");
		String description = (String) context.get("description");
		String entityName = (String) context.get("ofbizEntityName");
		String contentId = (String) context.get("contentId");

		boolean isFirstRowHeader = (Boolean) context.get("isFirstRowHeader");

		String importMapperId = dctx.getDelegator().getNextSeqId("MailerImportMapper");
		Map<String, Object> inputs = UtilMisc.toMap("importMapperId", importMapperId, "importMapperName", importMapperName, "description", description);
		inputs.put("ofbizEntityName", entityName);
		inputs.put("contentId", contentId);
		inputs.put("createdByUserLogin", userLogin.getString("userLoginId"));
		inputs.put("lastModifiedByUserLogin", userLogin.getString("userLoginId"));
		inputs.put("isFirstRowHeader", isFirstRowHeader ? "Y" : "N");
		inputs.put("fromDate", UtilDateTime.nowTimestamp());
		try {
			dctx.getDelegator().makeValue("MailerImportMapper", inputs).create();
			ModelService service = dctx.getModelService("mailer.configureImportColumnsMapping");
			inputs = service.makeValid(context, "IN");
			inputs.put("importMapperId", importMapperId);
			dctx.getDispatcher().runSync(service.name, inputs);
		} catch (GenericEntityException e) {
			return UtilMessage.createAndLogServiceError(e, UtilProperties.getMessage(errorResource, "errorConfigImportMapper", locale), locale, MODULE);
		} catch (GenericServiceException e) {
			return UtilMessage.createAndLogServiceError(e, UtilProperties.getMessage(errorResource, "errorConfigImportMapper", locale), locale, MODULE);
		}
		serviceResults.put("importMapperId", importMapperId);
		return serviceResults;
	}

	@SuppressWarnings("unchecked")
	public static Map<String, Object> configureImportColumnsMapping(DispatchContext dctx, Map<String, Object> context) {
		Map<String, Object> serviceResults = ServiceUtil.returnSuccess();
		Locale locale = (Locale) context.get("locale");
		String importMapperId = (String) context.get("importMapperId");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		Map<String, Object> entityColNames = (Map) context.get("entityColName");
		Map<String, Object> importFileColIdx = (Map) context.get("importFileColIdx");
		Set<String> keys = entityColNames.keySet();
		for (String key : keys) {
			String importColumnMapperId = dctx.getDelegator().getNextSeqId("MailerImportColumnMapper");
			Map<String, Object> inputs = UtilMisc.toMap("importColumnMapperId", importColumnMapperId);
			String importFileColIdxValue = importFileColIdx.get(key).toString();
			if (UtilValidate.isNotEmpty(importFileColIdxValue)) {
				inputs.put("importMapperId", importMapperId);
				inputs.put("entityColName", entityColNames.get(key));
				inputs.put("importFileColIdx", UtilValidate.isEmpty(importFileColIdxValue) ? "_NA_" : importFileColIdxValue);
				inputs.put("createdByUserLogin", userLogin.getString("userLoginId"));
				try {
					dctx.getDelegator().makeValue("MailerImportColumnMapper", inputs).create();
				} catch (GenericEntityException e) {
					return UtilMessage.createAndLogServiceError(e, UtilProperties.getMessage(errorResource, "errorCreatingCampaign", locale), locale, MODULE);
				}
			}
		}
		return serviceResults;
	}

	@SuppressWarnings("unchecked")
	public static Map<String, Object> updateImportMapping(DispatchContext dctx, Map<String, Object> context) {
		GenericDelegator delegator = dctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String userLoginId = (String) userLogin.get("userLoginId");
		String importMapperId = (String) context.get("importMapperId");

		String importMapperName = (String) context.get("importMapperName");
		String description = (String) context.get("description");
		String isFirstRowHeader = (String) context.get("isFirstRowHeader");

		Map<String, Object> entityColName = (Map) context.get("entityColName");
		Map<String, Object> importFileColIdx = (Map) context.get("importFileColIdx");

		try {
			updateMailerImportMapping(delegator, importMapperId, importMapperName, description, isFirstRowHeader, userLoginId);
			updateMailerImportColumnMapping(delegator, importMapperId, userLogin, entityColName, importFileColIdx);
		} catch (GenericEntityException e) {
			return UtilMessage.createAndLogServiceError(e, UtilProperties.getMessage(errorResource, "Error updating MailerImportMapping", locale), locale, MODULE);
		}
		return ServiceUtil.returnSuccess();
	}

	private static void updateMailerImportMapping(GenericDelegator delegator, String importMapperId, String importMapperName, String description, String isFirstRowHeader, String userLoginId) throws GenericEntityException {
		GenericValue mailerImportMapper = delegator.findByPrimaryKey("MailerImportMapper", UtilMisc.toMap("importMapperId", importMapperId));
		if (!(UtilValidate.areEqual(mailerImportMapper.getString("importMapperName"), importMapperName) && UtilValidate.areEqual(mailerImportMapper.getString("description"), description) && UtilValidate.areEqual(mailerImportMapper.getString("isFirstRowHeader"), isFirstRowHeader))) {
			mailerImportMapper.set("importMapperName", importMapperName);
			mailerImportMapper.set("description", description);
			mailerImportMapper.set("isFirstRowHeader", isFirstRowHeader);
			mailerImportMapper.set("lastModifiedByUserLogin", userLoginId);
			mailerImportMapper.store();
		}
	}

	@SuppressWarnings("unchecked")
	private static void updateMailerImportColumnMapping(GenericDelegator delegator, String importMapperId, GenericValue userLogin, Map<String, Object> entityColName, Map<String, Object> importFileColIdx) throws GenericEntityException {
		GenericValue mailerImportColumnMapper = null;

		// This key set is same for entityColName & importFileColIdx
		Set<String> keys = entityColName.keySet();
		for (String key : keys) {
			mailerImportColumnMapper = EntityUtil.getFirst(delegator.findByAnd("MailerImportColumnMapper", UtilMisc.toMap("importMapperId", importMapperId, "entityColName", entityColName.get(key))));

			String importFileColIndex = (String) importFileColIdx.get(key);
			if (UtilValidate.isNotEmpty(mailerImportColumnMapper)) {
				importFileColIndex = (String) importFileColIdx.get(key);

				mailerImportColumnMapper.set("lastModifiedByUserLogin", userLogin.get("userLoginId"));
				mailerImportColumnMapper.set("importFileColIdx", UtilValidate.isEmpty(importFileColIndex) ? "_NA_" : importFileColIndex);
				mailerImportColumnMapper.store();
			} else {
				String importColumnMapperId = delegator.getNextSeqId("MailerImportColumnMapper");

				Map<String, Object> inputs = UtilMisc.toMap("importColumnMapperId", importColumnMapperId);
				inputs.put("importMapperId", importMapperId);
				inputs.put("entityColName", entityColName.get(key));
				inputs.put("importFileColIdx", UtilValidate.isEmpty(importFileColIndex) ? "_NA_" : importFileColIndex);
				inputs.put("createdByUserLogin", userLogin.get("userLoginId"));

				delegator.makeValue("MailerImportColumnMapper", inputs).create();
			}
		}
	}

	public static Map<String, Object> deleteImportMapping(DispatchContext dctx, Map<String, Object> context) throws GenericEntityException {
		GenericDelegator delegator = dctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		Security security = dctx.getSecurity();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String userLoginId = userLogin.getString("userLoginId");

		String importMapperId = (String) context.get("importMapperId");
		GenericValue importMapperGV = null;

		if (security.hasPermission("MAILER_MAP_DELETE", userLogin)) {
			importMapperId = String.valueOf(importMapperId);
			importMapperGV = delegator.findByPrimaryKey("MailerImportMapper", UtilMisc.toMap("importMapperId", importMapperId));
			importMapperGV.put("thruDate", UtilDateTime.nowTimestamp());
			importMapperGV.put("deletedByUserLogin", userLoginId);
			importMapperGV.store();
		} else {
			return UtilMessage.createAndLogServiceError("Do not have permission to delete imprt mapper", MODULE);
		}
		return ServiceUtil.returnSuccess();
	}
}
