From: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: [Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs
Date: Mon, 16 Mar 2015 22:57:31 +0200
Message-ID: <1426539451-2119-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jdelvare-l3A5Bk7waGM@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Some utils, like dmidecode and smbios, need to access SMBIOS entry
table area in order to get information like SMBIOS version, size, etc.
Currently it's done via /dev/mem. But for situation when /dev/mem
usage is disabled, the utils have to use dmi sysfs instead, which
doesn't represent SMBIOS entry and adds code/delay redundancy when direct
access for table is needed.

So this patch creates dmi subsystem and adds SMBIOS entry point to allow
utils in question to work correctly without /dev/mem. Also patch adds
raw dmi table to simplify dmi table processing in user space, as were
proposed by Jean Delvare.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
---

This patch is logical continuation of
"[dmidecode] [Patch v4] firmware: dmi-sysfs: add SMBIOS entry point area attribute"
https://lkml.org/lkml/2015/2/4/475

Pay attention that this includes /sys/firmware/dmi for holding tables instead of
/sys/firmware/dmi/table as were proposed.

 Documentation/ABI/testing/sysfs-firmware-dmi       | 122 +++------------------
 .../ABI/testing/sysfs-firmware-dmi-entries         | 110 +++++++++++++++++++
 drivers/firmware/dmi-sysfs.c                       |  12 +-
 drivers/firmware/dmi_scan.c                        | 115 +++++++++++++++++--
 include/linux/dmi.h                                |   2 +
 5 files changed, 238 insertions(+), 123 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-entries

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
index c78f9ab..6413128 100644
--- a/Documentation/ABI/testing/sysfs-firmware-dmi
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi
@@ -1,110 +1,16 @@
 What:		/sys/firmware/dmi/
-Date:		February 2011
-Contact:	Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+Date:		March 2015
+Contact:	Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
 Description:
-		Many machines' firmware (x86 and ia64) export DMI /
-		SMBIOS tables to the operating system.  Getting at this
-		information is often valuable to userland, especially in
-		cases where there are OEM extensions used.
-
-		The kernel itself does not rely on the majority of the
-		information in these tables being correct.  It equally
-		cannot ensure that the data as exported to userland is
-		without error either.
-
-		DMI is structured as a large table of entries, where
-		each entry has a common header indicating the type and
-		length of the entry, as well as a firmware-provided
-		'handle' that is supposed to be unique amongst all
-		entries.
-
-		Some entries are required by the specification, but many
-		others are optional.  In general though, users should
-		never expect to find a specific entry type on their
-		system unless they know for certain what their firmware
-		is doing.  Machine to machine experiences will vary.
-
-		Multiple entries of the same type are allowed.  In order
-		to handle these duplicate entry types, each entry is
-		assigned by the operating system an 'instance', which is
-		derived from an entry type's ordinal position.  That is
-		to say, if there are 'N' multiple entries with the same type
-		'T' in the DMI tables (adjacent or spread apart, it
-		doesn't matter), they will be represented in sysfs as
-		entries "T-0" through "T-(N-1)":
-
-		Example entry directories:
-
-			/sys/firmware/dmi/entries/17-0
-			/sys/firmware/dmi/entries/17-1
-			/sys/firmware/dmi/entries/17-2
-			/sys/firmware/dmi/entries/17-3
-			...
-
-		Instance numbers are used in lieu of the firmware
-		assigned entry handles as the kernel itself makes no
-		guarantees that handles as exported are unique, and
-		there are likely firmware images that get this wrong in
-		the wild.
-
-		Each DMI entry in sysfs has the common header values
-		exported as attributes:
-
-		handle	: The 16bit 'handle' that is assigned to this
-			  entry by the firmware.  This handle may be
-			  referred to by other entries.
-		length	: The length of the entry, as presented in the
-			  entry itself.  Note that this is _not the
-			  total count of bytes associated with the
-			  entry_.  This value represents the length of
-			  the "formatted" portion of the entry.  This
-			  "formatted" region is sometimes followed by
-			  the "unformatted" region composed of nul
-			  terminated strings, with termination signalled
-			  by a two nul characters in series.
-		raw	: The raw bytes of the entry. This includes the
-			  "formatted" portion of the entry, the
-			  "unformatted" strings portion of the entry,
-			  and the two terminating nul characters.
-		type	: The type of the entry.  This value is the same
-			  as found in the directory name.  It indicates
-			  how the rest of the entry should be interpreted.
-		instance: The instance ordinal of the entry for the
-			  given type.  This value is the same as found
-			  in the parent directory name.
-		position: The ordinal position (zero-based) of the entry
-			  within the entirety of the DMI entry table.
-
-		=== Entry Specialization ===
-
-		Some entry types may have other information available in
-		sysfs.  Not all types are specialized.
-
-		--- Type 15 - System Event Log ---
-
-		This entry allows the firmware to export a log of
-		events the system has taken.  This information is
-		typically backed by nvram, but the implementation
-		details are abstracted by this table.  This entry's data
-		is exported in the directory:
-
-		/sys/firmware/dmi/entries/15-0/system_event_log
-
-		and has the following attributes (documented in the
-		SMBIOS / DMI specification under "System Event Log (Type 15)":
-
-		area_length
-		header_start_offset
-		data_start_offset
-		access_method
-		status
-		change_token
-		access_method_address
-		header_format
-		per_log_type_descriptor_length
-		type_descriptors_supported_count
-
-		As well, the kernel exports the binary attribute:
-
-		raw_event_log	: The raw binary bits of the event log
-				  as described by the DMI entry.
+		The firmware provides DMI structures as a packed list of
+		data referenced by a SMBIOS table entry point. The SMBIOS
+		entry point contains general information, like SMBIOS
+		version, DMI table size, etc. The structure, content and
+		size of SMBIOS entry point is dependent on SMBIOS version.
+		That's why SMBIOS entry point is represented in dmi sysfs
+		like a raw attribute and is accessible via
+		/sys/firmware/dmi/smbios_entry_point. The format of SMBIOS
+		entry point header can be read in SMBIOS specification.
+		To simplify access and processing delay in user space,
+		subsystem provides also raw dmi table under
+		/sys/firmware/dmi/dmi_table.
diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi-entries b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
new file mode 100644
index 0000000..c3b4d4c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
@@ -0,0 +1,110 @@
+What:		/sys/firmware/dmi/entries
+Date:		February 2011
+Contact:	Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+Description:
+		Many machines' firmware (x86 and ia64) export DMI /
+		SMBIOS tables to the operating system.  Getting at this
+		information is often valuable to userland, especially in
+		cases where there are OEM extensions used.
+
+		The kernel itself does not rely on the majority of the
+		information in these tables being correct.  It equally
+		cannot ensure that the data as exported to userland is
+		without error either.
+
+		DMI is structured as a large table of entries, where
+		each entry has a common header indicating the type and
+		length of the entry, as well as a firmware-provided
+		'handle' that is supposed to be unique amongst all
+		entries.
+
+		Some entries are required by the specification, but many
+		others are optional.  In general though, users should
+		never expect to find a specific entry type on their
+		system unless they know for certain what their firmware
+		is doing.  Machine to machine experiences will vary.
+
+		Multiple entries of the same type are allowed.  In order
+		to handle these duplicate entry types, each entry is
+		assigned by the operating system an 'instance', which is
+		derived from an entry type's ordinal position.  That is
+		to say, if there are 'N' multiple entries with the same type
+		'T' in the DMI tables (adjacent or spread apart, it
+		doesn't matter), they will be represented in sysfs as
+		entries "T-0" through "T-(N-1)":
+
+		Example entry directories:
+
+			/sys/firmware/dmi/entries/17-0
+			/sys/firmware/dmi/entries/17-1
+			/sys/firmware/dmi/entries/17-2
+			/sys/firmware/dmi/entries/17-3
+			...
+
+		Instance numbers are used in lieu of the firmware
+		assigned entry handles as the kernel itself makes no
+		guarantees that handles as exported are unique, and
+		there are likely firmware images that get this wrong in
+		the wild.
+
+		Each DMI entry in sysfs has the common header values
+		exported as attributes:
+
+		handle	: The 16bit 'handle' that is assigned to this
+			  entry by the firmware.  This handle may be
+			  referred to by other entries.
+		length	: The length of the entry, as presented in the
+			  entry itself.  Note that this is _not the
+			  total count of bytes associated with the
+			  entry_.  This value represents the length of
+			  the "formatted" portion of the entry.  This
+			  "formatted" region is sometimes followed by
+			  the "unformatted" region composed of nul
+			  terminated strings, with termination signalled
+			  by a two nul characters in series.
+		raw	: The raw bytes of the entry. This includes the
+			  "formatted" portion of the entry, the
+			  "unformatted" strings portion of the entry,
+			  and the two terminating nul characters.
+		type	: The type of the entry.  This value is the same
+			  as found in the directory name.  It indicates
+			  how the rest of the entry should be interpreted.
+		instance: The instance ordinal of the entry for the
+			  given type.  This value is the same as found
+			  in the parent directory name.
+		position: The ordinal position (zero-based) of the entry
+			  within the entirety of the DMI entry table.
+
+		=== Entry Specialization ===
+
+		Some entry types may have other information available in
+		sysfs.  Not all types are specialized.
+
+		--- Type 15 - System Event Log ---
+
+		This entry allows the firmware to export a log of
+		events the system has taken.  This information is
+		typically backed by nvram, but the implementation
+		details are abstracted by this table.  This entry's data
+		is exported in the directory:
+
+		/sys/firmware/dmi/entries/15-0/system_event_log
+
+		and has the following attributes (documented in the
+		SMBIOS / DMI specification under "System Event Log (Type 15)":
+
+		area_length
+		header_start_offset
+		data_start_offset
+		access_method
+		status
+		change_token
+		access_method_address
+		header_format
+		per_log_type_descriptor_length
+		type_descriptors_supported_count
+
+		As well, the kernel exports the binary attribute:
+
+		raw_event_log	: The raw binary bits of the event log
+				  as described by the DMI entry.
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index e0f1cb3..390067d 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -566,7 +566,6 @@ static struct kobj_type dmi_sysfs_entry_ktype = {
 	.default_attrs = dmi_sysfs_entry_attrs,
 };
 
-static struct kobject *dmi_kobj;
 static struct kset *dmi_kset;
 
 /* Global count of all instances seen.  Only for setup */
@@ -651,10 +650,10 @@ static int __init dmi_sysfs_init(void)
 	int error = -ENOMEM;
 	int val;
 
-	/* Set up our directory */
-	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
-	if (!dmi_kobj)
-		goto err;
+	if (!dmi_kobj) {
+		pr_err("dmi-sysfs: dmi subsysterm is absent.\n");
+		return -EINVAL;
+	}
 
 	dmi_kset = kset_create_and_add("entries", NULL, dmi_kobj);
 	if (!dmi_kset)
@@ -675,7 +674,6 @@ static int __init dmi_sysfs_init(void)
 err:
 	cleanup_entry_list();
 	kset_unregister(dmi_kset);
-	kobject_put(dmi_kobj);
 	return error;
 }
 
@@ -685,8 +683,6 @@ static void __exit dmi_sysfs_exit(void)
 	pr_debug("dmi-sysfs: unloading.\n");
 	cleanup_entry_list();
 	kset_unregister(dmi_kset);
-	kobject_del(dmi_kobj);
-	kobject_put(dmi_kobj);
 }
 
 module_init(dmi_sysfs_init);
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index c9cb725..3fca52a 100644
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
@@ -118,6 +124,7 @@ static void dmi_table(u8 *buf,
 }
 
 static phys_addr_t dmi_base;
+static u8 *dmi_tb;
 
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
@@ -508,6 +517,8 @@ static int __init dmi_present(const u8 *buf)
 					dmi_ver >> 8, dmi_ver & 0xFF,
 					(dmi_ver < 0x0300) ? "" : ".x");
 			} else {
+				smbios_entry_point_size = 15;
+				memcpy(smbios_entry_point, buf, 15);
 				dmi_ver = (buf[14] & 0xF0) << 4 |
 					   (buf[14] & 0x0F);
 				pr_info("Legacy DMI %d.%d present.\n",
@@ -535,6 +546,8 @@ static int __init dmi_smbios3_present(const u8 *buf)
 		dmi_ver &= 0xFFFFFF;
 		dmi_len = get_unaligned_le32(buf + 12);
 		dmi_base = get_unaligned_le64(buf + 16);
+		smbios_entry_point_size = buf[6];
+		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
 
 		/*
 		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
@@ -638,6 +651,95 @@ void __init dmi_scan_machine(void)
 	dmi_initialized = 1;
 }
 
+static ssize_t smbios_entry_point_read(struct file *filp,
+				       struct kobject *kobj,
+				       struct bin_attribute *bin_attr,
+				       char *buf, loff_t pos, size_t count)
+{
+	ssize_t size;
+
+	size = bin_attr->size;
+
+	if (size > pos)
+		size -= pos;
+	else
+		return 0;
+
+	if (count < size)
+		size = count;
+
+	memcpy(buf, &smbios_entry_point[pos], size);
+
+	return size;
+}
+
+static ssize_t dmi_table_read(struct file *filp,
+			      struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t pos, size_t count)
+{
+	ssize_t size;
+
+	size = bin_attr->size;
+
+	if (size > pos)
+		size -= pos;
+	else
+		return 0;
+
+	if (count < size)
+		size = count;
+
+	memcpy(buf, &dmi_tb[pos], size);
+
+	return size;
+}
+
+BIN_ATTR_RO(dmi_table, 0);
+BIN_ATTR_RO(smbios_entry_point, 0);
+
+/*
+ * Register the dmi subsystem under the firmware subsysterm
+ */
+static int __init dmisubsys_init(void)
+{
+	int ret = -ENOMEM;
+
+	if (!smbios_entry_point_size || !dmi_available) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Set up dmi directory at /sys/firmware/dmi */
+	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
+	if (!dmi_kobj)
+		goto err;
+
+	bin_attr_smbios_entry_point.size = smbios_entry_point_size;
+	ret = sysfs_create_bin_file(dmi_kobj, &bin_attr_smbios_entry_point);
+	if (ret)
+		goto err;
+
+	if (!dmi_tb) {
+		dmi_tb = dmi_remap(dmi_base, dmi_len);
+		if (!dmi_tb)
+			goto err;
+	}
+
+	bin_attr_dmi_table.size = dmi_len;
+	ret = sysfs_create_bin_file(dmi_kobj, &bin_attr_dmi_table);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	pr_err("dmi: Firmware registration failed.\n");
+	kobject_del(dmi_kobj);
+	kobject_put(dmi_kobj);
+	return ret;
+}
+subsys_initcall(dmisubsys_init);
+
 /**
  * dmi_set_dump_stack_arch_desc - set arch description for dump_stack()
  *
@@ -897,18 +999,17 @@ EXPORT_SYMBOL(dmi_get_date);
 int dmi_walk(void (*decode)(const struct dmi_header *, void *),
 	     void *private_data)
 {
-	u8 *buf;
-
 	if (!dmi_available)
 		return -1;
 
-	buf = dmi_remap(dmi_base, dmi_len);
-	if (buf == NULL)
-		return -1;
+	if (!dmi_tb) {
+		dmi_tb = dmi_remap(dmi_base, dmi_len);
+		if (!dmi_tb)
+			return -1;
+	}
 
-	dmi_table(buf, decode, private_data);
+	dmi_table(dmi_tb, decode, private_data);
 
-	dmi_unmap(buf);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dmi_walk);
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index f820f0a..316293e 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -93,6 +93,7 @@ struct dmi_dev_onboard {
 	int devfn;
 };
 
+extern struct kobject *dmi_kobj;
 extern int dmi_check_system(const struct dmi_system_id *list);
 const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
@@ -112,6 +113,7 @@ extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
 
 #else
 
+extern struct kobject *dmi_kobj;
 static inline int dmi_check_system(const struct dmi_system_id *list) { return 0; }
 static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const char *name,
-- 
1.9.1
