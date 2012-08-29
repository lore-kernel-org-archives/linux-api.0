From: xiaoyan.zhang@intel.com
Subject: [PATCH] driver/char/tpm: declare internal symbols as static
Date: Wed, 29 Aug 2012 04:40:41 +0000 (UTC)
Message-ID: <1377779951-1687-1-git-send-email-xiaoyan.zhang__42974.8101080351$1346215243$gmane$org@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Date: Thu, 29 Aug 2013 20:39:11 +0800
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: xiaoyan.zhang@intel.com, joseph.cihula@intel.com, gang.wei@intel.com, tpmdd-devel@lists.sourceforge.net, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com, shpedoikal@gmail.com, linux-security-module@vger.kernel.org, james.l.morris@oracle.com, hpa@zytor.com, linux-api@vger.kernel.org, yoder1@us.ibm.com, key@linux.vnet.ibm.com, fengguang.wu@intel.com
List-Id: linux-api@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>

This patch declares the internal struct and functions as static to provide
more security.

Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/char/tpm/tpm.c     |    4 ++--
 drivers/char/tpm/tpm_ppi.c |   37 +++++++++++++++++++------------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 39526c0..6724615 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -915,7 +915,7 @@ EXPORT_SYMBOL_GPL(tpm_show_pcrs);
 
 #define  READ_PUBEK_RESULT_SIZE 314
 #define TPM_ORD_READPUBEK cpu_to_be32(124)
-struct tpm_input_header tpm_readpubek_header = {
+static struct tpm_input_header tpm_readpubek_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(30),
 	.ordinal = TPM_ORD_READPUBEK
@@ -1395,7 +1395,7 @@ EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
  * Once all references to platform device are down to 0,
  * release all allocated structures.
  */
-void tpm_dev_release(struct device *dev)
+static void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 440fa1c..f27b58c 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -53,8 +53,8 @@ static inline void ppi_assign_params(union acpi_object params[4],
 	params[3].package.elements = NULL;
 }
 
-ssize_t tpm_show_ppi_version(struct device *dev, struct device_attribute *attr,
-			     char *buf)
+static ssize_t tpm_show_ppi_version(struct device *dev,
+				    struct device_attribute *attr, char *buf)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -82,9 +82,8 @@ ssize_t tpm_show_ppi_version(struct device *dev, struct device_attribute *attr,
 	return status;
 }
 
-ssize_t tpm_show_ppi_request(struct device *dev,
-			     struct device_attribute *attr,
-			     char *buf)
+static ssize_t tpm_show_ppi_request(struct device *dev,
+				    struct device_attribute *attr, char *buf)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -132,9 +131,9 @@ cleanup:
 	return status;
 }
 
-ssize_t tpm_store_ppi_request(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
+static ssize_t tpm_store_ppi_request(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
 {
 	char version[PPI_VERSION_LEN + 1];
 	acpi_handle handle;
@@ -207,9 +206,9 @@ ssize_t tpm_store_ppi_request(struct device *dev,
 	return status;
 }
 
-ssize_t tpm_show_ppi_transition_action(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+static ssize_t tpm_show_ppi_transition_action(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
 {
 	char version[PPI_VERSION_LEN + 1];
 	acpi_handle handle;
@@ -269,9 +268,9 @@ ssize_t tpm_show_ppi_transition_action(struct device *dev,
 	return status;
 }
 
-ssize_t tpm_show_ppi_response(struct device *dev,
-			      struct device_attribute *attr,
-			      char *buf)
+static ssize_t tpm_show_ppi_response(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -413,14 +412,16 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 	return str - buf;
 }
 
-ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
 {
 	return show_ppi_operations(buf, 0, PPI_TPM_REQ_MAX);
 }
 
-ssize_t tpm_show_ppi_vs_operations(struct device *dev,
-				  struct device_attribute *attr, char *buf)
+static ssize_t tpm_show_ppi_vs_operations(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
 {
 	return show_ppi_operations(buf, PPI_VS_REQ_START, PPI_VS_REQ_END);
 }
-- 
1.7.7.6

