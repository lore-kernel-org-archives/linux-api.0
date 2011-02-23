From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
Date: Tue, 22 Feb 2011 17:53:21 -0800
Message-ID: <20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Lippert <rlippert@google.com>
Cc: Jon Mayer <jonmayer@google.com>, Tony Luck <tony.luck@intel.com>, Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Introduce a new module "dmi-sysfs" that exports the broken out entries
of the DMI table through sysfs.

Entries are enumerated via dmi_walk() on module load, and are populated
as kobjects rooted at /sys/firmware/dmi/entries.

Entries are named "<type>-<instance>", where:
   <type>	: is the type of the entry, and
   <instance>	: is the ordinal count within the DMI table of that
		  entry type.  This instance is used in lieu the DMI
		  entry's handle as no assurances are made by the kernel
		  that handles are unique.

All entries export the following attributes:
   length	: The length of the formatted portion of the entry
   handle	: The handle given to this entry by the firmware
   raw		: The raw bytes of the entire entry, including the
		  formatted portion, the unformatted (strings) portion,
		  and the two terminating nul characters.
   type		: The DMI entry type
   instance	: The ordinal instance of this entry given its type.
   position	: The position ordinal of the entry within the table in
		  its entirety.

Entries in dmi-sysfs are kobject backed members called "struct
dmi_sysfs_entry" and belong to dmi_kset.  They are threaded through
entry_list (protected by entry_list_lock) so that we can find them at
cleanup time.

Signed-off-by: Mike Waychison <mikew@google.com>
---
Changelog:
- v2
   - Added 'type', 'instance' and 'position' attributes to each DMI entry.
   - Fixed module to default to 'n'.
   - Fixed copyright year and module author.
   - Replace module load/unload messages with pr_debug().
   - Fixed a bug in handling multiple instance of the same type where
     reading the raw file for earlier instances would result in 0 bytes
     read due to the instance_count getting stuck at '0'.
---
 drivers/firmware/Kconfig     |   11 +
 drivers/firmware/Makefile    |    1 
 drivers/firmware/dmi-sysfs.c |  396 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 408 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/dmi-sysfs.c

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e710424..3c56afc 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -113,6 +113,17 @@ config DMIID
 	  information from userspace through /sys/class/dmi/id/ or if you want
 	  DMI-based module auto-loading.
 
+config DMI_SYSFS
+	tristate "DMI table support in sysfs"
+	depends on SYSFS && DMI
+	default n
+	help
+	  Say Y or M here to enable the exporting of the raw DMI table
+	  data via sysfs.  This is useful for consuming the data without
+	  requiring any access to /dev/mem at all.  Tables are found
+	  under /sys/firmware/dmi when this option is enabled and
+	  loaded.
+
 config ISCSI_IBFT_FIND
 	bool "iSCSI Boot Firmware Table Attributes"
 	depends on X86
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 1c3c173..20c17fc 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the linux kernel.
 #
 obj-$(CONFIG_DMI)		+= dmi_scan.o
+obj-$(CONFIG_DMI_SYSFS)		+= dmi-sysfs.o
 obj-$(CONFIG_EDD)		+= edd.o
 obj-$(CONFIG_EFI_VARS)		+= efivars.o
 obj-$(CONFIG_EFI_PCDP)		+= pcdp.o
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
new file mode 100644
index 0000000..2d8a04a
--- /dev/null
+++ b/drivers/firmware/dmi-sysfs.c
@@ -0,0 +1,396 @@
+/*
+ * dmi-sysfs.c
+ *
+ * This module exports the DMI tables read-only to userspace through the
+ * sysfs file system.
+ *
+ * Data is currently found below
+ *    /sys/firmware/dmi/...
+ *
+ * DMI attributes are presented in attribute files with names
+ * formatted using %d-%d, so that the first integer indicates the
+ * structure type (0-255), and the second field is the instance of that
+ * entry.
+ *
+ * Copyright 2011 Google, Inc.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kobject.h>
+#include <linux/dmi.h>
+#include <linux/capability.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/io.h>
+
+#define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
+			      the top entry type is only 8 bits */
+
+struct dmi_sysfs_entry {
+	struct dmi_header dh;
+	struct kobject kobj;
+	int instance;
+	int position;
+	struct list_head list;
+};
+
+/*
+ * Global list of dmi_sysfs_entry.  Even though this should only be
+ * manipulated at setup and teardown, the lazy nature of the kobject
+ * system means we get lazy removes.
+ */
+static LIST_HEAD(entry_list);
+static DEFINE_SPINLOCK(entry_list_lock);
+
+/* dmi_sysfs_attribute - Top level attribute. used by all entries. */
+struct dmi_sysfs_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct dmi_sysfs_entry *entry, char *buf);
+};
+
+#define DMI_SYSFS_ATTR(_entry, _name) \
+struct dmi_sysfs_attribute dmi_sysfs_attr_##_entry##_##_name = { \
+	.attr = {.name = __stringify(_name), .mode = 0400}, \
+	.show = dmi_sysfs_##_entry##_##_name, \
+}
+
+/*
+ * dmi_sysfs_mapped_attribute - Attribute where we require the entry be
+ * mapped in.  Use in conjunction with dmi_sysfs_specialize_attr_ops.
+ */
+struct dmi_sysfs_mapped_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct dmi_sysfs_entry *entry,
+			const struct dmi_header *dh,
+			char *buf);
+};
+
+#define DMI_SYSFS_MAPPED_ATTR(_entry, _name) \
+struct dmi_sysfs_mapped_attribute dmi_sysfs_attr_##_entry##_##_name = { \
+	.attr = {.name = __stringify(_name), .mode = 0400}, \
+	.show = dmi_sysfs_##_entry##_##_name, \
+}
+
+/*************************************************
+ * Generic DMI entry support.
+ *************************************************/
+
+static struct dmi_sysfs_entry *to_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct dmi_sysfs_entry, kobj);
+}
+
+static struct dmi_sysfs_attribute *to_attr(struct attribute *attr)
+{
+	return container_of(attr, struct dmi_sysfs_attribute, attr);
+}
+
+static ssize_t dmi_sysfs_attr_show(struct kobject *kobj,
+				   struct attribute *_attr, char *buf)
+{
+	struct dmi_sysfs_entry *entry = to_entry(kobj);
+	struct dmi_sysfs_attribute *attr = to_attr(_attr);
+
+	/* DMI stuff is only ever admin visible */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	return attr->show(entry, buf);
+}
+
+static const struct sysfs_ops dmi_sysfs_attr_ops = {
+	.show = dmi_sysfs_attr_show,
+};
+
+typedef ssize_t (*dmi_callback)(struct dmi_sysfs_entry *,
+				const struct dmi_header *dh, void *);
+
+struct find_dmi_data {
+	struct dmi_sysfs_entry	*entry;
+	dmi_callback		callback;
+	void			*private;
+	int			instance_countdown;
+	ssize_t			ret;
+};
+
+static void find_dmi_entry_helper(const struct dmi_header *dh,
+				  void *_data)
+{
+	struct find_dmi_data *data = _data;
+	struct dmi_sysfs_entry *entry = data->entry;
+
+	/* Is this the entry we want? */
+	if (dh->type != entry->dh.type)
+		return;
+
+	if (data->instance_countdown != 0) {
+		/* try the next instance? */
+		data->instance_countdown--;
+		return;
+	}
+
+	/*
+	 * Don't ever revisit the instance.  Short circuit later
+	 * instances by letting the instance_countdown run negative
+	 */
+	data->instance_countdown--;
+
+	/* Found the entry */
+	data->ret = data->callback(entry, dh, data->private);
+}
+
+/* State for passing the read parameters through dmi_find_entry() */
+struct dmi_read_state {
+	char *buf;
+	loff_t pos;
+	size_t count;
+};
+
+static ssize_t find_dmi_entry(struct dmi_sysfs_entry *entry,
+			      dmi_callback callback, void *private)
+{
+	struct find_dmi_data data = {
+		.entry = entry,
+		.callback = callback,
+		.private = private,
+		.instance_countdown = entry->instance,
+		.ret = -EIO,  /* To signal the entry disappeared */
+	};
+	int ret;
+
+	ret = dmi_walk(find_dmi_entry_helper, &data);
+	/* This shouldn't happen, but just in case. */
+	if (ret)
+		return -EINVAL;
+	return data.ret;
+}
+
+/*
+ * Calculate and return the byte length of the dmi entry identified by
+ * dh.  This includes both the formatted portion as well as the
+ * unformatted string space, including the two trailing nul characters.
+ */
+static size_t dmi_entry_length(const struct dmi_header *dh)
+{
+	const char *p = (const char *)dh;
+
+	p += dh->length;
+
+	while (p[0] || p[1])
+		p++;
+
+	return 2 + p - (const char *)dh;
+}
+
+/*************************************************
+ * Generic DMI entry support.
+ *************************************************/
+
+static ssize_t dmi_sysfs_entry_length(struct dmi_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%d\n", entry->dh.length);
+}
+
+static ssize_t dmi_sysfs_entry_handle(struct dmi_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%d\n", entry->dh.handle);
+}
+
+static ssize_t dmi_sysfs_entry_type(struct dmi_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%d\n", entry->dh.type);
+}
+
+static ssize_t dmi_sysfs_entry_instance(struct dmi_sysfs_entry *entry,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", entry->instance);
+}
+
+static ssize_t dmi_sysfs_entry_position(struct dmi_sysfs_entry *entry,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", entry->position);
+}
+
+static DMI_SYSFS_ATTR(entry, length);
+static DMI_SYSFS_ATTR(entry, handle);
+static DMI_SYSFS_ATTR(entry, type);
+static DMI_SYSFS_ATTR(entry, instance);
+static DMI_SYSFS_ATTR(entry, position);
+
+static struct attribute *dmi_sysfs_entry_attrs[] = {
+	&dmi_sysfs_attr_entry_length.attr,
+	&dmi_sysfs_attr_entry_handle.attr,
+	&dmi_sysfs_attr_entry_type.attr,
+	&dmi_sysfs_attr_entry_instance.attr,
+	&dmi_sysfs_attr_entry_position.attr,
+	NULL,
+};
+
+static ssize_t dmi_entry_raw_read_helper(struct dmi_sysfs_entry *entry,
+					 const struct dmi_header *dh,
+					 void *_state)
+{
+	struct dmi_read_state *state = _state;
+	size_t entry_length;
+
+	entry_length = dmi_entry_length(dh);
+
+	return memory_read_from_buffer(state->buf, state->count,
+				       &state->pos, dh, entry_length);
+}
+
+static ssize_t dmi_entry_raw_read(struct file *filp,
+				  struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t count)
+{
+	struct dmi_sysfs_entry *entry = to_entry(kobj);
+	struct dmi_read_state state = {
+		.buf = buf,
+		.pos = pos,
+		.count = count,
+	};
+
+	return find_dmi_entry(entry, dmi_entry_raw_read_helper, &state);
+}
+
+static const struct bin_attribute dmi_entry_raw_attr = {
+	.attr = {.name = "raw", .mode = 0400},
+	.read = dmi_entry_raw_read,
+};
+
+static void dmi_sysfs_entry_release(struct kobject *kobj)
+{
+	struct dmi_sysfs_entry *entry = to_entry(kobj);
+	sysfs_remove_bin_file(&entry->kobj, &dmi_entry_raw_attr);
+	spin_lock(&entry_list_lock);
+	list_del(&entry->list);
+	spin_unlock(&entry_list_lock);
+	kfree(entry);
+}
+
+static struct kobj_type dmi_sysfs_entry_ktype = {
+	.release = dmi_sysfs_entry_release,
+	.sysfs_ops = &dmi_sysfs_attr_ops,
+	.default_attrs = dmi_sysfs_entry_attrs,
+};
+
+static struct kobject *dmi_kobj;
+static struct kset *dmi_kset;
+
+/* Global count of all instances seen.  Only for setup */
+static int __initdata instance_counts[MAX_ENTRY_TYPE + 1];
+
+/* Global positional count of all entries seen.  Only for setup */
+static int __initdata position_count;
+
+static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
+					     void *_ret)
+{
+	struct dmi_sysfs_entry *entry;
+	int *ret = _ret;
+
+	/* If a previous entry saw an error, short circuit */
+	if (*ret)
+		return;
+
+	/* Allocate and register a new entry into the entries set */
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		*ret = -ENOMEM;
+		return;
+	}
+
+	/* Set the key */
+	entry->dh = *dh;
+	entry->instance = instance_counts[dh->type]++;
+	entry->position = position_count++;
+
+	entry->kobj.kset = dmi_kset;
+	*ret = kobject_init_and_add(&entry->kobj, &dmi_sysfs_entry_ktype, NULL,
+				    "%d-%d", dh->type, entry->instance);
+
+	if (*ret) {
+		kfree(entry);
+		return;
+	}
+
+	/* Thread on the global list for cleanup */
+	spin_lock(&entry_list_lock);
+	list_add_tail(&entry->list, &entry_list);
+	spin_unlock(&entry_list_lock);
+
+	/* Create the raw binary file to access the entry */
+	*ret = sysfs_create_bin_file(&entry->kobj, &dmi_entry_raw_attr);
+	if (*ret)
+		goto out_err;
+
+	return;
+out_err:
+	kobject_put(&entry->kobj);
+	return;
+}
+
+static void cleanup_entry_list(void)
+{
+	struct dmi_sysfs_entry *entry, *next;
+
+	/* No locks, we are on our way out */
+	list_for_each_entry_safe(entry, next, &entry_list, list) {
+		kobject_put(&entry->kobj);
+	}
+}
+
+static int __init dmi_sysfs_init(void)
+{
+	int error = -ENOMEM;
+	int val;
+
+	/* Set up our directory */
+	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
+	if (!dmi_kobj)
+		goto err;
+
+	dmi_kset = kset_create_and_add("entries", NULL, dmi_kobj);
+	if (!dmi_kset)
+		goto err;
+
+	val = 0;
+	error = dmi_walk(dmi_sysfs_register_handle, &val);
+	if (error)
+		goto err;
+	if (val) {
+		error = val;
+		goto err;
+	}
+
+	pr_debug("dmi-sysfs: loaded.\n");
+
+	return 0;
+err:
+	cleanup_entry_list();
+	kset_unregister(dmi_kset);
+	kobject_put(dmi_kobj);
+	return error;
+}
+
+/* clean up everything. */
+static void __exit dmi_sysfs_exit(void)
+{
+	pr_debug("dmi-sysfs: unloading.\n");
+	cleanup_entry_list();
+	kset_unregister(dmi_kset);
+	kobject_put(dmi_kobj);
+}
+
+module_init(dmi_sysfs_init);
+module_exit(dmi_sysfs_exit);
+
+MODULE_AUTHOR("Mike Waychison <mikew@google.com>");
+MODULE_DESCRIPTION("DMI sysfs support");
+MODULE_LICENSE("GPL");
