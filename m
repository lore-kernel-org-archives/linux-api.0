From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH 3/3] firmware: fw_cfg: create directory
	hierarchy for fw_cfg file names
Date: Mon, 10 Aug 2015 12:31:20 -0400
Message-ID: <1cadfcda3c31d7470f677656f9c914e9c4b7c0cd.1439220623.git.somlo@cmu.edu>
References: <cover.1439220623.git.somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <cover.1439220623.git.somlo@cmu.edu>
In-Reply-To: <cover.1439220623.git.somlo@cmu.edu>
References: <cover.1439220623.git.somlo@cmu.edu>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, ralf@linux-mips.org, zajec5@gmail.com, paul@pwsan.com, galak@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, rjones@redhat.com, jordan.l.justen@intel.com, x86@kernel.org, qemu-devel@nongnu.org, gleb@cloudius-systems.com, matt.fleming@intel.com, kernelnewbies@kernelnewbies.org, kraxel@redhat.com, pbonzini@redhat.com, lersek@redhat.com
List-Id: linux-api@vger.kernel.org

From: "Gabriel Somlo" <somlo@cmu.edu>

Each fw_cfg entry of type "file" has an associated 56-char,
nul-terminated ASCII string which represents its name. While
the fw_cfg device doesn't itself impose any specific naming
convention, QEMU developers have traditionally used path name
semantics (i.e. "etc/acpi/rsdp") to descriptively name the
various fw_cfg "blobs" passed into the guest.

This patch attempts, on a best effort basis, to create a
directory hierarchy representing the content of fw_cfg file
names, under /sys/firmware/fw_cfg/by_name.

Upon successful creation of all directories representing the
"dirname" portion of a fw_cfg file, a symlink will be created
to represent the "basename", pointing at the appropriate
/sys/firmware/fw_cfg/by_select entry. If a file name is not
suitable for this procedure (e.g., if its basename or dirname
components collide with an already existing dirname component
or basename, respectively) the corresponding fw_cfg blob is
skipped and will remain available in sysfs only by its selector
key value.

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
---
 Documentation/ABI/testing/sysfs-firmware-fw_cfg |  42 ++++++++++
 drivers/firmware/fw_cfg.c                       | 104 ++++++++++++++++++++++++
 2 files changed, 146 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-firmware-fw_cfg b/Documentation/ABI/testing/sysfs-firmware-fw_cfg
index 3a7e7f2..1024776 100644
--- a/Documentation/ABI/testing/sysfs-firmware-fw_cfg
+++ b/Documentation/ABI/testing/sysfs-firmware-fw_cfg
@@ -167,3 +167,45 @@ Description:
 			  entry via the control register, and reading a number
 			  of bytes equal to the blob size from the data
 			  register.
+
+		--- Listing fw_cfg blobs by file name ---
+
+		While the fw_cfg device does not impose any specific naming
+		convention on the blobs registered in the file directory,
+		QEMU developers have traditionally used path name semantics
+		to give each blob a descriptive name. For example:
+
+			"bootorder"
+			"genroms/kvmvapic.bin"
+			"etc/e820"
+			"etc/boot-fail-wait"
+			"etc/system-states"
+			"etc/table-loader"
+			"etc/acpi/rsdp"
+			"etc/acpi/tables"
+			"etc/smbios/smbios-tables"
+			"etc/smbios/smbios-anchor"
+			...
+
+		In addition to the listing by unique selector key described
+		above, the fw_cfg sysfs driver also attempts to build a tree
+		of directories matching the path name components of fw_cfg
+		blob names, ending in symlinks to the by_select entry for each
+		"basename", as illustrated below (assume current directory is
+		/sys/firmware):
+
+			fw_cfg/by_name/bootorder -> ../by_select/38
+			fw_cfg/by_name/etc/e820 -> ../../by_select/35
+			fw_cfg/by_name/etc/acpi/rsdp -> ../../../by_select/41
+			...
+
+		Construction of the directory tree and symlinks is done on a
+		"best-effort" basis, as there is no guarantee that components
+		of fw_cfg blob names are always "well behaved". I.e., there is
+		the possibility that a symlink (basename) will conflict with
+		a dirname component of another fw_cfg blob, in which case the
+		creation of the offending /sys/firmware/fw_cfg/by_name entry
+		will be skipped.
+
+		The authoritative list of entries will continue to be found
+		under the /sys/firmware/fw_cfg/by_select directory.
diff --git a/drivers/firmware/fw_cfg.c b/drivers/firmware/fw_cfg.c
index be17411..94233a5 100644
--- a/drivers/firmware/fw_cfg.c
+++ b/drivers/firmware/fw_cfg.c
@@ -327,9 +327,104 @@ static struct bin_attribute fw_cfg_sysfs_attr_raw = {
 	.read = fw_cfg_sysfs_read_raw,
 };
 
+/*
+ * Create a kset subdirectory matching each '/' delimited dirname token
+ * in 'name', starting with sysfs kset/folder 'dir'; At the end, create
+ * a symlink directed at the given 'target'.
+ * NOTE: We do this on a best-effort basis, since 'name' is not guaranteed
+ * to be a well-behaved path name. Whenever a symlink vs. kset directory
+ * name collision occurs, the kernel will issue big scary warnings while
+ * refusing to add the offending link or directory. We follow up with our
+ * own, slightly less scary error messages explaining the situation :)
+ */
+static int __init fw_cfg_build_symlink(struct kset *dir,
+				       struct kobject *target,
+				       const char *name)
+{
+	int ret;
+	struct kset *subdir;
+	struct kobject *ko;
+	char *name_copy, *p, *tok;
+
+	if (!dir || !target || !name || !*name)
+		return -EINVAL;
+
+	/* clone a copy of name for parsing */
+	name_copy = p = kstrdup(name, GFP_KERNEL);
+	if (!name_copy)
+		return -ENOMEM;
+
+	/* create folders for each dirname token, then symlink for basename */
+	while ((tok = strsep(&p, "/")) && *tok) {
+
+		/* last (basename) token? If so, add symlink here */
+		if (!p || !*p) {
+			ret = sysfs_create_link(&dir->kobj, target, tok);
+			break;
+		}
+
+		/* does the current dir contain an item named after tok ? */
+		ko = kset_find_obj(dir, tok);
+		if (ko) {
+			/* drop reference added by kset_find_obj */
+			kobject_put(ko);
+
+			/* ko MUST be a kset - we're about to use it as one ! */
+			if (ko->ktype != dir->kobj.ktype) {
+				ret = -EINVAL;
+				break;
+			}
+
+			/* descend into already existing subdirectory */
+			dir = to_kset(ko);
+		} else {
+			/* create new subdirectory kset */
+			subdir = kzalloc(sizeof(struct kset), GFP_KERNEL);
+			if (!subdir) {
+				ret = -ENOMEM;
+				break;
+			}
+			subdir->kobj.kset = dir;
+			subdir->kobj.ktype = dir->kobj.ktype;
+			ret = kobject_set_name(&subdir->kobj, "%s", tok);
+			if (ret) {
+				kfree(subdir);
+				break;
+			}
+			ret = kset_register(subdir);
+			if (ret) {
+				kfree(subdir);
+				break;
+			}
+
+			/* descend into newly created subdirectory */
+			dir = subdir;
+		}
+	}
+
+	/* we're done with cloned copy of name */
+	kfree(name_copy);
+	return ret;
+}
+
+/* recursively unregister fw_cfg/by_name/ kset directory tree */
+static void fw_cfg_kset_unregister_recursive(struct kset *kset)
+{
+	struct kobject *k, *next;
+
+	list_for_each_entry_safe(k, next, &kset->list, entry)
+		/* all set members are ksets too, but check just in case... */
+		if (k->ktype == kset->kobj.ktype)
+			fw_cfg_kset_unregister_recursive(to_kset(k));
+
+	/* symlinks are cleanly and automatically removed with the directory */
+	kset_unregister(kset);
+}
+
 /* kobjects & kset representing top-level, by_select, and by_name folders */
 static struct kobject *fw_cfg_top_ko;
 static struct kobject *fw_cfg_sel_ko;
+static struct kset *fw_cfg_fname_kset;
 
 /* callback function to register an individual fw_cfg file */
 static int __init fw_cfg_register_file(const struct fw_cfg_file *f)
@@ -358,6 +453,9 @@ static int __init fw_cfg_register_file(const struct fw_cfg_file *f)
 	if (err)
 		goto err_add_raw;
 
+	/* try adding "/sys/firmware/fw_cfg/by_name/" symlink (best-effort) */
+	fw_cfg_build_symlink(fw_cfg_fname_kset, &entry->kobj, entry->f.name);
+
 	/* success, add entry to global cache */
 	fw_cfg_sysfs_cache_enlist(entry);
 	return 0;
@@ -393,6 +491,9 @@ static int __init fw_cfg_sysfs_init(void)
 	fw_cfg_sel_ko = kobject_create_and_add("by_select", fw_cfg_top_ko);
 	if (!fw_cfg_sel_ko)
 		goto err_sel;
+	fw_cfg_fname_kset = kset_create_and_add("by_name", NULL, fw_cfg_top_ko);
+	if (!fw_cfg_fname_kset)
+		goto err_name;
 
 	/* get revision number, add matching top-level attribute */
 	fw_cfg_read_blob(FW_CFG_ID, &fw_cfg_rev, 0, sizeof(fw_cfg_rev));
@@ -414,6 +515,8 @@ err_scan:
 	fw_cfg_sysfs_cache_cleanup();
 	sysfs_remove_file(fw_cfg_top_ko, &fw_cfg_rev_attr.attr);
 err_rev:
+	fw_cfg_kset_unregister_recursive(fw_cfg_fname_kset);
+err_name:
 	fw_cfg_kobj_cleanup(fw_cfg_sel_ko);
 err_sel:
 	fw_cfg_kobj_cleanup(fw_cfg_top_ko);
@@ -426,6 +529,7 @@ static void __exit fw_cfg_sysfs_exit(void)
 {
 	pr_debug("fw_cfg: unloading.\n");
 	fw_cfg_sysfs_cache_cleanup();
+	fw_cfg_kset_unregister_recursive(fw_cfg_fname_kset);
 	fw_cfg_kobj_cleanup(fw_cfg_sel_ko);
 	fw_cfg_kobj_cleanup(fw_cfg_top_ko);
 	fw_cfg_io_cleanup();
-- 
2.4.3
