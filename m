From: "Zhang, Xiaoyan" <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] driver: add PPI support in tpm driver
Date: Wed, 23 May 2012 03:34:12 +0000
Message-ID: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org" <m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org>, "shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cihula, Joseph" <joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The Physical Presence Interface enables the OS and the BIOS to cooperate
and provides a simple and straightforward platform user experience for
administering the TPM without sacrificing security.

Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm.c |  462 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h |   18 ++
 2 files changed, 480 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..afa7ec4 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -28,6 +28,8 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_drivers.h>
 
 #include "tpm.h"
 
@@ -331,6 +333,50 @@ static const u8 tpm_ordinal_duration[TPM_MAX_ORDINAL] = {
 	TPM_MEDIUM,
 };
 
+static const u8 tpm_ppi_uuid[] = {
+	0xA6, 0xFA, 0xDD, 0x3D,
+	0x1B, 0x36,
+	0xB4, 0x4E,
+	0xA4, 0x24,
+	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
+};
+static char *tpm_device_name = "TPM";
+
+#define TPM_PPI_REVISION_ID	1
+#define TPM_PPI_FN_VERSION	1
+#define TPM_PPI_FN_SUBREQ	2
+#define TPM_PPI_FN_GETREQ	3
+#define TPM_PPI_FN_GETACT	4
+#define TPM_PPI_FN_GETRSP	5
+#define TPM_PPI_FN_SUBREQ2	7
+#define TPM_PPI_FN_GETOPR	8
+#define PPI_TPM_REQ_MAX		22
+#define PPI_VS_REQ_START	128
+#define PPI_VS_REQ_END		255
+#define PPI_VERSION_LEN		3
+
+static DEVICE_ATTR(version, S_IRUGO, tpm_show_ppi_version, NULL);
+static DEVICE_ATTR(request, S_IRUGO | S_IWUSR | S_IWGRP,
+		   tpm_show_ppi_request, tpm_store_ppi_request);
+static DEVICE_ATTR(transition_action, S_IRUGO,
+		   tpm_show_ppi_transition_action, NULL);
+static DEVICE_ATTR(response, S_IRUGO, tpm_show_ppi_response, NULL);
+static DEVICE_ATTR(tcg_operations, S_IRUGO, tpm_show_ppi_tcg_operations, NULL);
+static DEVICE_ATTR(vs_operations, S_IRUGO, tpm_show_ppi_vs_operations, NULL);
+
+static struct attribute *ppi_attrs[] = {
+	&dev_attr_version.attr,
+	&dev_attr_request.attr,
+	&dev_attr_transition_action.attr,
+	&dev_attr_response.attr,
+	&dev_attr_tcg_operations.attr,
+	&dev_attr_vs_operations.attr, NULL,
+};
+
+static struct attribute_group ppi_attr_grp = {
+	.attrs = ppi_attrs
+};
+
 static void user_reader_timeout(unsigned long ptr)
 {
 	struct tpm_chip *chip = (struct tpm_chip *) ptr;
@@ -1059,6 +1105,414 @@ ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
 }
 EXPORT_SYMBOL_GPL(tpm_show_timeouts);
 
+static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
+				void **return_value)
+{
+	acpi_status status;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	if (strstr(buffer.pointer, context) != NULL) {
+		*return_value = handle;
+		kfree(buffer.pointer);
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static inline void ppi_assign_params(union acpi_object params[4],
+				     u64 function_num)
+{
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = sizeof(tpm_ppi_uuid);
+	params[0].buffer.pointer = (char *)tpm_ppi_uuid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = TPM_PPI_REVISION_ID;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = function_num;
+	params[3].type = ACPI_TYPE_PACKAGE;
+	params[3].package.count = 0;
+	params[3].package.elements = NULL;
+}
+
+ssize_t tpm_show_ppi_version(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *obj;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					 ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return status;
+	obj = (union acpi_object *)output.pointer;
+	status = scnprintf(buf, PAGE_SIZE, "%s\n", obj->string.pointer);
+	kfree(output.pointer);
+	return status;
+}
+EXPORT_SYMBOL_GPL(tpm_show_ppi_version);
+
+ssize_t tpm_show_ppi_request(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *ret_obj;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_GETREQ);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return status;
+	/*
+	 * output.pointer should be of package type, including two integers.
+	 * The first is function return code, 0 means success and 1 means
+	 * error. The second is pending TPM operation requested by the OS, 0
+	 * means none and >0 means operation value.
+	 */
+	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
+	if (ret_obj->type == ACPI_TYPE_INTEGER) {
+		if (ret_obj->integer.value) {
+			status = AE_ERROR;
+			goto cleanup;
+		}
+		ret_obj++;
+		if (ret_obj->type == ACPI_TYPE_INTEGER)
+			status = scnprintf(buf, PAGE_SIZE, "%llu\n",
+					   ret_obj->integer.value);
+		else
+			status = AE_TYPE;
+	} else {
+		status = AE_TYPE;
+	}
+cleanup:
+	kfree(output.pointer);
+	return status;
+}
+EXPORT_SYMBOL_GPL(tpm_show_ppi_request);
+
+ssize_t tpm_store_ppi_request(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	char version[PPI_VERSION_LEN + 1];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object obj;
+	u32 req;
+	u64 ret;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return status;
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	/*
+	 * the function to submit TPM operation request to pre-os environment
+	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
+	 * version 1.1
+	 */
+	if (strcmp(version, "1.1") == -1)
+		params[2].integer.value = TPM_PPI_FN_SUBREQ;
+	else
+		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
+	/*
+	 * PPI spec defines params[3].type as ACPI_TYPE_PACKAGE. Some BIOS
+	 * accept buffer/string/integer type, but some BIOS accept buffer/
+	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
+	 * for compatibility, and use package type since 1.2 according to spec.
+	 */
+	if (strcmp(version, "1.2") == -1) {
+		params[3].type = ACPI_TYPE_BUFFER;
+		params[3].buffer.length = sizeof(req);
+		sscanf(buf, "%d", &req);
+		params[3].buffer.pointer = (char *)&req;
+	} else {
+		params[3].package.count = 1;
+		obj.type = ACPI_TYPE_INTEGER;
+		sscanf(buf, "%llu", &obj.integer.value);
+		params[3].package.elements = &obj;
+	}
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_INTEGER);
+	if (ACPI_FAILURE(status))
+		return status;
+	ret = ((union acpi_object *)output.pointer)->integer.value;
+	if (ret == 0)
+		status = (acpi_status)count;
+	else if (ret == 1)
+		status = AE_NOT_IMPLEMENTED;
+	else
+		status = AE_ERROR;
+	kfree(output.pointer);
+	return status;
+}
+EXPORT_SYMBOL_GPL(tpm_store_ppi_request);
+
+ssize_t tpm_show_ppi_transition_action(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	char version[PPI_VERSION_LEN + 1];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	u32 ret;
+	char *info[] = {
+		"None",
+		"Shutdown",
+		"Reboot",
+		"OS Vendor-specific",
+		"Error",
+	};
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return status;
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	/*
+	 * PPI spec defines params[3].type as empty package, but some platforms
+	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
+	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
+	 */
+	if (strcmp(version, "1.2") == -1) {
+		params[3].type = ACPI_TYPE_BUFFER;
+		params[3].buffer.length =  0;
+		params[3].buffer.pointer = NULL;
+	}
+	params[2].integer.value = TPM_PPI_FN_GETACT;
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_INTEGER);
+	if (ACPI_FAILURE(status))
+		return status;
+	ret = ((union acpi_object *)output.pointer)->integer.value;
+	if (ret < ARRAY_SIZE(info) - 1)
+		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret, info[ret]);
+	else
+		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret,
+				   info[ARRAY_SIZE(info)-1]);
+	kfree(output.pointer);
+	return status;
+}
+EXPORT_SYMBOL_GPL(tpm_show_ppi_transition_action);
+
+ssize_t tpm_show_ppi_response(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *ret_obj;
+	u64 req;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_GETRSP);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return status;
+	/*
+	 * parameter output.pointer should be of package type, including
+	 * 3 integers. The first means function return code, the second means
+	 * most recent TPM operation request, and the last means response to
+	 * the most recent TPM operation request. Only if the first is 0, and
+	 * the second integer is not 0, the response makes sense.
+	 */
+	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
+	if (ret_obj->type != ACPI_TYPE_INTEGER) {
+		status = AE_TYPE;
+		goto cleanup;
+	}
+	if (ret_obj->integer.value) {
+		status = AE_ERROR;
+		goto cleanup;
+	}
+	ret_obj++;
+	if (ret_obj->type != ACPI_TYPE_INTEGER) {
+		status = AE_TYPE;
+		goto cleanup;
+	}
+	if (ret_obj->integer.value) {
+		req = ret_obj->integer.value;
+		ret_obj++;
+		if (ret_obj->type != ACPI_TYPE_INTEGER) {
+			status = AE_TYPE;
+			goto cleanup;
+		}
+		if (ret_obj->integer.value == 0)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0: Success");
+		else if (ret_obj->integer.value == 0xFFFFFFF0)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0xFFFFFFF0: User Abort");
+		else if (ret_obj->integer.value == 0xFFFFFFF1)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0xFFFFFFF1: BIOS Failure");
+		else if (ret_obj->integer.value >= 1 &&
+			 ret_obj->integer.value <= 0x00000FFF)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
+					   req, ret_obj->integer.value,
+					   "Corresponding TPM error");
+		else
+			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
+					   req, ret_obj->integer.value,
+					   "Error");
+	} else {
+		status = scnprintf(buf, PAGE_SIZE, "%llu: %s\n",
+				   ret_obj->integer.value, "No Recent Request");
+	}
+cleanup:
+	kfree(output.pointer);
+	return status;
+}
+EXPORT_SYMBOL_GPL(tpm_show_ppi_response);
+
+static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
+{
+	char *str = buf;
+	char version[PPI_VERSION_LEN];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object obj;
+	int i;
+	u32 ret;
+	char *info[] = {
+		"Not implemented",
+		"BIOS only",
+		"Blocked for OS by BIOS",
+		"User required",
+		"User not required",
+	};
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					 ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	if (strcmp(version, "1.2") == -1)
+		return AE_NOT_IMPLEMENTED;
+
+	params[2].integer.value = TPM_PPI_FN_GETOPR;
+	params[3].package.count = 1;
+	obj.type = ACPI_TYPE_INTEGER;
+	params[3].package.elements = &obj;
+	for (i = start; i <= end; i++) {
+		obj.integer.value = i;
+		status = acpi_evaluate_object_typed(handle, "_DSM",
+			 &input, &output, ACPI_TYPE_INTEGER);
+		if (ACPI_FAILURE(status))
+			return status;
+
+		ret = ((union acpi_object *)output.pointer)->integer.value;
+		if (ret > 0 && ret < ARRAY_SIZE(info))
+			str += scnprintf(str, PAGE_SIZE, "%d %d: %s\n",
+					 i, ret, info[ret]);
+		kfree(output.pointer);
+		output.length = ACPI_ALLOCATE_BUFFER;
+		output.pointer = NULL;
+	}
+	return str - buf;
+}
+
+ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return show_ppi_operations(buf, 0, PPI_TPM_REQ_MAX);
+}
+EXPORT_SYMBOL_GPL(tpm_show_ppi_tcg_operations);
+
+ssize_t tpm_show_ppi_vs_operations(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return show_ppi_operations(buf, PPI_VS_REQ_START, PPI_VS_REQ_END);
+}
+EXPORT_SYMBOL_GPL(tpm_show_ppi_vs_operations);
+
 ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
@@ -1360,6 +1814,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 
 	char *devname;
 	struct tpm_chip *chip;
+	struct kobject *ppi;
 
 	/* Driver specific per-device data */
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
@@ -1416,6 +1871,13 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 		return NULL;
 	}
 
+	ppi = kobject_create_and_add("ppi", &dev->kobj);
+	if (sysfs_create_group(ppi, &ppi_attr_grp)) {
+		misc_deregister(&chip->vendor.miscdev);
+		put_device(chip->dev);
+		return NULL;
+	}
+
 	chip->bios_dir = tpm_bios_log_setup(devname);
 
 	/* Make chip available */
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b1c5280..3346833 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -65,6 +65,24 @@ extern ssize_t tpm_show_durations(struct device *,
 				  struct device_attribute *attr, char *);
 extern ssize_t tpm_show_timeouts(struct device *,
 				 struct device_attribute *attr, char *);
+extern ssize_t tpm_show_ppi_version(struct device *,
+				    struct device_attribute *attr, char *);
+extern ssize_t tpm_show_ppi_request(struct device *,
+				    struct device_attribute *attr, char *);
+extern ssize_t tpm_store_ppi_request(struct device *,
+				     struct device_attribute *attr,
+				     const char *, size_t);
+extern ssize_t tpm_show_ppi_transition_action(struct device *,
+					      struct device_attribute *attr,
+					      char *);
+extern ssize_t tpm_show_ppi_response(struct device *,
+				     struct device_attribute *attr, char *);
+extern ssize_t tpm_show_ppi_tcg_operations(struct device *,
+					   struct device_attribute *attr,
+					   char *);
+extern ssize_t tpm_show_ppi_vs_operations(struct device *,
+					  struct device_attribute *attr,
+					  char *);
 
 struct tpm_chip;
 
-- 
1.7.6.5
