From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 05/11] mei: bus: report also uuid in module alias
Date: Thu,  7 May 2015 15:54:02 +0300
Message-ID: <1431003248-3164-5-git-send-email-tomas.winkler@intel.com>
References: <1431003248-3164-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431003248-3164-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, linux-api@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
List-Id: linux-api@vger.kernel.org

In order to automate modules matching add device uuid
which is reported in client enumeration, keep also
the name that is needed in for nfc distinguishing radio vendor

Report mei:name:uuid

Cc: linux-api@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-mei |  2 +-
 drivers/misc/mei/bus.c                  | 42 ++++++++++++++++++++++++++-------
 drivers/misc/mei/mei_dev.h              |  2 ++
 drivers/nfc/mei_phy.h                   |  3 +++
 drivers/nfc/microread/mei.c             |  2 +-
 drivers/nfc/pn544/mei.c                 |  2 +-
 include/linux/mod_devicetable.h         | 13 ++++++++++
 scripts/mod/devicetable-offsets.c       |  1 +
 scripts/mod/file2alias.c                | 18 ++++++++++++--
 9 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-mei b/Documentation/ABI/testing/sysfs-bus-mei
index 2066f0bbd453..91967a70313a 100644
--- a/Documentation/ABI/testing/sysfs-bus-mei
+++ b/Documentation/ABI/testing/sysfs-bus-mei
@@ -4,4 +4,4 @@ KernelVersion:	3.10
 Contact:	Samuel Ortiz <sameo@linux.intel.com>
 		linux-mei@linux.intel.com
 Description:	Stores the same MODALIAS value emitted by uevent
-		Format: mei:<mei device name>
+		Format: mei:<mei device name>:<device uuid>:
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 1101d6efaf27..17b00baa53b1 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -30,23 +30,40 @@
 #define to_mei_cl_driver(d) container_of(d, struct mei_cl_driver, driver)
 #define to_mei_cl_device(d) container_of(d, struct mei_cl_device, dev)
 
+static inline uuid_le uuid_le_cast(const __u8 uuid[16])
+{
+	return *(uuid_le *)uuid;
+}
+
 static int mei_cl_device_match(struct device *dev, struct device_driver *drv)
 {
 	struct mei_cl_device *device = to_mei_cl_device(dev);
 	struct mei_cl_driver *driver = to_mei_cl_driver(drv);
 	const struct mei_cl_device_id *id;
+	const uuid_le *uuid;
+	const char *name;
 
 	if (!device)
 		return 0;
 
+	uuid = mei_me_cl_uuid(device->me_cl);
+	name = device->name;
+
 	if (!driver || !driver->id_table)
 		return 0;
 
 	id = driver->id_table;
 
-	while (id->name[0]) {
-		if (!strncmp(dev_name(dev), id->name, sizeof(id->name)))
-			return 1;
+	while (uuid_le_cmp(NULL_UUID_LE, uuid_le_cast(id->uuid))) {
+
+		if (!uuid_le_cmp(*uuid, uuid_le_cast(id->uuid))) {
+			if (id->name[0]) {
+				if (!strncmp(name, id->name, sizeof(id->name)))
+					return 1;
+			} else {
+				return 1;
+			}
+		}
 
 		id++;
 	}
@@ -69,7 +86,7 @@ static int mei_cl_device_probe(struct device *dev)
 
 	dev_dbg(dev, "Device probe\n");
 
-	strlcpy(id.name, dev_name(dev), sizeof(id.name));
+	strlcpy(id.name, device->name, sizeof(id.name));
 
 	return driver->probe(device, &id);
 }
@@ -100,9 +117,12 @@ static int mei_cl_device_remove(struct device *dev)
 static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 			     char *buf)
 {
-	int len;
+	struct mei_cl_device *device = to_mei_cl_device(dev);
+	const uuid_le *uuid = mei_me_cl_uuid(device->me_cl);
+	size_t len;
 
-	len = snprintf(buf, PAGE_SIZE, "mei:%s\n", dev_name(dev));
+	len = snprintf(buf, PAGE_SIZE, "mei:%s:" MEI_CL_UUID_FMT ":",
+		device->name, MEI_CL_UUID_ARGS(uuid->b));
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
@@ -116,7 +136,11 @@ ATTRIBUTE_GROUPS(mei_cl_dev);
 
 static int mei_cl_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	if (add_uevent_var(env, "MODALIAS=mei:%s", dev_name(dev)))
+	struct mei_cl_device *device = to_mei_cl_device(dev);
+	const uuid_le *uuid = mei_me_cl_uuid(device->me_cl);
+
+	if (add_uevent_var(env, "MODALIAS=mei:%s:" MEI_CL_UUID_FMT ":",
+		device->name, MEI_CL_UUID_ARGS(uuid->b)))
 		return -ENOMEM;
 
 	return 0;
@@ -185,7 +209,9 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 	device->dev.bus = &mei_cl_bus_type;
 	device->dev.type = &mei_cl_device_type;
 
-	dev_set_name(&device->dev, "%s", name);
+	strlcpy(device->name, name, sizeof(device->name));
+
+	dev_set_name(&device->dev, "mei:%s:%pUl", name, mei_me_cl_uuid(me_cl));
 
 	status = device_register(&device->dev);
 	if (status) {
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 79ab78184523..ab719e674edf 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -376,6 +376,7 @@ struct mei_cl *mei_cl_bus_find_cl_by_uuid(struct mei_device *dev, uuid_le uuid);
  * @dev: linux driver model device pointer
  * @me_cl: me client
  * @cl: mei client
+ * @name: device name
  * @ops: ME transport ops
  * @event_work: async work to execute event callback
  * @event_cb: Drivers register this callback to get asynchronous ME
@@ -389,6 +390,7 @@ struct mei_cl_device {
 
 	struct mei_me_client *me_cl;
 	struct mei_cl *cl;
+	char name[MEI_CL_NAME_SIZE];
 
 	const struct mei_cl_ops *ops;
 
diff --git a/drivers/nfc/mei_phy.h b/drivers/nfc/mei_phy.h
index d669900f8278..06608c28ff14 100644
--- a/drivers/nfc/mei_phy.h
+++ b/drivers/nfc/mei_phy.h
@@ -3,7 +3,10 @@
 
 #include <linux/mei_cl_bus.h>
 #include <net/nfc/hci.h>
+#include <linux/uuid.h>
 
+#define MEI_NFC_UUID __UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
+		0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
 #define MEI_NFC_HEADER_SIZE 10
 #define MEI_NFC_MAX_HCI_PAYLOAD 300
 
diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 2d1395be64ae..f9f5fc97cdd7 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -67,7 +67,7 @@ static int microread_mei_remove(struct mei_cl_device *device)
 }
 
 static struct mei_cl_device_id microread_mei_tbl[] = {
-	{ MICROREAD_DRIVER_NAME },
+	{ MICROREAD_DRIVER_NAME, MEI_NFC_UUID},
 
 	/* required last entry */
 	{ }
diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index 330cd4031009..101a37e12efa 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -67,7 +67,7 @@ static int pn544_mei_remove(struct mei_cl_device *device)
 }
 
 static struct mei_cl_device_id pn544_mei_tbl[] = {
-	{ PN544_DRIVER_NAME },
+	{ PN544_DRIVER_NAME, MEI_NFC_UUID},
 
 	/* required last entry */
 	{ }
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 3bfd56778c29..2d2b2b571d61 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -599,9 +599,22 @@ struct ipack_device_id {
 
 #define MEI_CL_MODULE_PREFIX "mei:"
 #define MEI_CL_NAME_SIZE 32
+#define MEI_CL_UUID_FMT "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
+#define MEI_CL_UUID_ARGS(_u) \
+	_u[0], _u[1], _u[2], _u[3], _u[4], _u[5], _u[6], _u[7], \
+	_u[8], _u[9], _u[10], _u[11], _u[12], _u[13], _u[14], _u[15]
 
+/**
+ * struct mei_cl_device_id - MEI client device identifier
+ * @name: helper name
+ * @uuid: client uuid
+ * @driver_info: information used by the driver.
+ *
+ * identifies mei client device by uuid and name
+ */
 struct mei_cl_device_id {
 	char name[MEI_CL_NAME_SIZE];
+	__u8 uuid[16];
 	kernel_ulong_t driver_info;
 };
 
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index fce36d0f6898..091f6290a651 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -182,6 +182,7 @@ int main(void)
 
 	DEVID(mei_cl_device_id);
 	DEVID_FIELD(mei_cl_device_id, name);
+	DEVID_FIELD(mei_cl_device_id, uuid);
 
 	DEVID(rio_device_id);
 	DEVID_FIELD(rio_device_id, did);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 78691d51a479..62c517f4b592 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -131,6 +131,15 @@ static inline void add_wildcard(char *str)
 		strcat(str + len, "*");
 }
 
+static inline void add_uuid(char *str, __u8 uuid[16])
+{
+	int len = strlen(str);
+	int i;
+
+	for (i = 0; i < 16; i++)
+		sprintf(str + len + (i << 1), "%02x", uuid[i]);
+}
+
 /**
  * Check that sizeof(device_id type) are consistent with size of section
  * in .o file. If in-consistent then userspace and kernel does not agree
@@ -1160,13 +1169,18 @@ static int do_cpu_entry(const char *filename, void *symval, char *alias)
 }
 ADD_TO_DEVTABLE("cpu", cpu_feature, do_cpu_entry);
 
-/* Looks like: mei:S */
+/* Looks like: mei:S:uuid */
 static int do_mei_entry(const char *filename, void *symval,
 			char *alias)
 {
 	DEF_FIELD_ADDR(symval, mei_cl_device_id, name);
+	DEF_FIELD_ADDR(symval, mei_cl_device_id, uuid);
+
+	sprintf(alias, MEI_CL_MODULE_PREFIX);
+	sprintf(alias + strlen(alias), "%s:",  (*name)[0]  ? *name : "*");
+	add_uuid(alias, *uuid);
 
-	sprintf(alias, MEI_CL_MODULE_PREFIX "%s", *name);
+	strcat(alias, ":*");
 
 	return 1;
 }
-- 
2.1.0
