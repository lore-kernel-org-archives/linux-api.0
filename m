From: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: [Patch 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Thu,  2 Apr 2015 15:57:02 +0300
Message-ID: <1427979423-22767-3-git-send-email-ivan.khoronzhuk@globallogic.com>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427979423-22767-1-git-send-email-ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jdelvare-l3A5Bk7waGM@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Some utils, like dmidecode and smbios, need to access SMBIOS entry
table area in order to get information like SMBIOS version, size, etc.
Currently it's done via /dev/mem. But for situation when /dev/mem
usage is disabled, the utils have to use dmi sysfs instead, which
doesn't represent SMBIOS entry and adds code/delay redundancy when direct
access for table is needed.

So this patch creates dmi/tables and adds SMBIOS entry point to allow
utils in question to work correctly without /dev/mem. Also patch adds
raw dmi table to simplify dmi table processing in user space, as
proposed by Jean Delvare.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
---
 .../ABI/testing/sysfs-firmware-dmi-tables          | 22 ++++++
 drivers/firmware/dmi-sysfs.c                       | 11 ++-
 drivers/firmware/dmi_scan.c                        | 80 ++++++++++++++++++++++
 include/linux/dmi.h                                |  1 +
 4 files changed, 107 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-tables

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi-tables b/Documentation/ABI/testing/sysfs-firmware-dmi-tables
new file mode 100644
index 0000000..f46158c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi-tables
@@ -0,0 +1,22 @@
+What:		/sys/firmware/dmi/tables/
+Date:		April 2015
+Contact:	Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
+Description:
+		The firmware provides DMI structures as a packed list of
+		data referenced by a SMBIOS table entry point. The SMBIOS
+		entry point contains general information, like SMBIOS
+		version, DMI table size, etc. The structure, content and
+		size of SMBIOS entry point is dependent on SMBIOS version.
+		The format of SMBIOS entry point, equal as DMI structures
+		can be read in SMBIOS specification.
+
+		The dmi/tables provides raw SMBIOS entry point and DMI tables
+		through sysfs as an alternative to utilities reading them
+		from /dev/mem. The raw SMBIOS entry point and DMI table are
+		presented as raw attributes and are accessible via:
+
+		/sys/firmware/dmi/tables/smbios_entry_point
+		/sys/firmware/dmi/tables/DMI
+
+		The complete DMI information can be taken using these two
+		tables.
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index e0f1cb3..8e1a411 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -566,7 +566,6 @@ static struct kobj_type dmi_sysfs_entry_ktype = {
 	.default_attrs = dmi_sysfs_entry_attrs,
 };
 
-static struct kobject *dmi_kobj;
 static struct kset *dmi_kset;
 
 /* Global count of all instances seen.  Only for setup */
@@ -651,10 +650,11 @@ static int __init dmi_sysfs_init(void)
 	int error = -ENOMEM;
 	int val;
 
-	/* Set up our directory */
-	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
-	if (!dmi_kobj)
+	if (!dmi_kobj) {
+		pr_err("dmi-sysfs: dmi entry is absent.\n");
+		error = -ENOSYS;
 		goto err;
+	}
 
 	dmi_kset = kset_create_and_add("entries", NULL, dmi_kobj);
 	if (!dmi_kset)
@@ -675,7 +675,6 @@ static int __init dmi_sysfs_init(void)
 err:
 	cleanup_entry_list();
 	kset_unregister(dmi_kset);
-	kobject_put(dmi_kobj);
 	return error;
 }
 
@@ -685,8 +684,6 @@ static void __exit dmi_sysfs_exit(void)
 	pr_debug("dmi-sysfs: unloading.\n");
 	cleanup_entry_list();
 	kset_unregister(dmi_kset);
-	kobject_del(dmi_kobj);
-	kobject_put(dmi_kobj);
 }
 
 module_init(dmi_sysfs_init);
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index d3aae09..bb19f8b 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -10,6 +10,9 @@
 #include <asm/dmi.h>
 #include <asm/unaligned.h>
 
+struct kobject *dmi_kobj;
+EXPORT_SYMBOL_GPL(dmi_kobj);
+
 /*
  * DMI stands for "Desktop Management Interface".  It is part
  * of and an antecedent to, SMBIOS, which stands for System
@@ -20,6 +23,9 @@ static const char dmi_empty_string[] = "        ";
 static u32 dmi_ver __initdata;
 static u32 dmi_len;
 static u16 dmi_num;
+static u8 smbios_entry_point[32];
+static int smbios_entry_point_size;
+
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -118,6 +124,7 @@ static void dmi_decode_table(u8 *buf,
 }
 
 static phys_addr_t dmi_base;
+static u8 *dmi_table;
 
 static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 		void *))
@@ -476,6 +483,8 @@ static int __init dmi_present(const u8 *buf)
 	if (memcmp(buf, "_SM_", 4) == 0 &&
 	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
 		smbios_ver = get_unaligned_be16(buf + 6);
+		smbios_entry_point_size = buf[5];
+		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
 
 		/* Some BIOS report weird SMBIOS version, fix that up */
 		switch (smbios_ver) {
@@ -508,6 +517,9 @@ static int __init dmi_present(const u8 *buf)
 					dmi_ver >> 8, dmi_ver & 0xFF,
 					(dmi_ver < 0x0300) ? "" : ".x");
 			} else {
+				smbios_entry_point_size = 15;
+				memcpy(smbios_entry_point, buf,
+				       smbios_entry_point_size);
 				dmi_ver = (buf[14] & 0xF0) << 4 |
 					   (buf[14] & 0x0F);
 				pr_info("Legacy DMI %d.%d present.\n",
@@ -535,6 +547,8 @@ static int __init dmi_smbios3_present(const u8 *buf)
 		dmi_ver &= 0xFFFFFF;
 		dmi_len = get_unaligned_le32(buf + 12);
 		dmi_base = get_unaligned_le64(buf + 16);
+		smbios_entry_point_size = buf[6];
+		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
 
 		/*
 		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
@@ -638,6 +652,72 @@ void __init dmi_scan_machine(void)
 	dmi_initialized = 1;
 }
 
+static ssize_t raw_table_read(struct file *file, struct kobject *kobj,
+			      struct bin_attribute *attr, char *buf,
+			      loff_t pos, size_t count)
+{
+	memcpy(buf, attr->private + pos, count);
+	return count;
+}
+
+static BIN_ATTR(smbios_entry_point, S_IRUSR, raw_table_read, NULL, 0);
+struct bin_attribute bin_attr_dmi_table =
+			__BIN_ATTR(DMI, S_IRUSR, raw_table_read, NULL, 0);
+
+static int __init dmi_init(void)
+{
+	int ret = -ENOMEM;
+	struct kobject *tables_kobj = NULL;
+
+	if (!dmi_available) {
+		ret = -ENOSYS;
+		goto err;
+	}
+
+	/* Set up dmi directory at /sys/firmware/dmi */
+	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
+	if (!dmi_kobj)
+		goto err;
+
+	tables_kobj = kobject_create_and_add("tables", dmi_kobj);
+	if (!tables_kobj)
+		goto err;
+
+	bin_attr_smbios_entry_point.size = smbios_entry_point_size;
+	bin_attr_smbios_entry_point.private = smbios_entry_point;
+	ret = sysfs_create_bin_file(tables_kobj, &bin_attr_smbios_entry_point);
+	if (ret)
+		goto err;
+
+	dmi_table = dmi_remap(dmi_base, dmi_len);
+	if (!dmi_table)
+		goto err;
+
+	bin_attr_dmi_table.size = dmi_len;
+	bin_attr_dmi_table.private = dmi_table;
+	ret = sysfs_create_bin_file(tables_kobj, &bin_attr_dmi_table);
+	if (ret) {
+		dmi_unmap(dmi_table);
+		goto err;
+	}
+
+	return 0;
+err:
+	pr_err("dmi: Firmware registration failed.\n");
+
+	if (tables_kobj)
+		sysfs_remove_bin_file(tables_kobj,
+				      &bin_attr_smbios_entry_point);
+	kobject_del(tables_kobj);
+	kobject_put(tables_kobj);
+	kobject_del(dmi_kobj);
+	kobject_put(dmi_kobj);
+	dmi_kobj = NULL;
+
+	return ret;
+}
+subsys_initcall(dmi_init);
+
 /**
  * dmi_set_dump_stack_arch_desc - set arch description for dump_stack()
  *
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index f820f0a..9f55f46 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -93,6 +93,7 @@ struct dmi_dev_onboard {
 	int devfn;
 };
 
+extern struct kobject *dmi_kobj;
 extern int dmi_check_system(const struct dmi_system_id *list);
 const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
-- 
1.9.1
