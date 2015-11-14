From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v4 3/4] firmware: create directory hierarchy
	for sysfs fw_cfg entries
Date: Fri, 13 Nov 2015 22:03:54 -0500
Message-ID: <1447470235-13643-4-git-send-email-somlo@cmu.edu>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.maydell@linaro.org, matt.fleming@intel.com, mst@redhat.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, ard.biesheuvel@linaro.org, kraxel@redhat.com, stefanha@gmail.com, pbonzini@redhat.com
List-Id: linux-api@vger.kernel.org

From: Gabriel Somlo <somlo@cmu.edu>

Each fw_cfg entry of type "file" has an associated 56-char,
nul-terminated ASCII string which represents its name. While
the fw_cfg device doesn't itself impose any specific naming
convention, QEMU developers have traditionally used path name
semantics (i.e. "etc/acpi/rsdp") to descriptively name the
various fw_cfg "blobs" passed into the guest.

This patch attempts, on a best effort basis, to create a
directory hierarchy representing the content of fw_cfg file
names, under /sys/firmware/qemu_fw_cfg/by_name.

Upon successful creation of all directories representing the
"dirname" portion of a fw_cfg file, a symlink will be created
to represent the "basename", pointing at the appropriate
/sys/firmware/qemu_fw_cfg/by_key entry. If a file name is not
suitable for this procedure (e.g., if its basename or dirname
components collide with an already existing dirname component
or basename, respectively) the corresponding fw_cfg blob is
skipped and will remain available in sysfs only by its selector
key value.

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 .../ABI/testing/sysfs-firmware-qemu_fw_cfg         |  42 ++++++++
 drivers/firmware/qemu_fw_cfg.c                     | 109 ++++++++++++++++++++-
 2 files changed, 148 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg b/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
index b908b6d..a346ee0 100644
--- a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
+++ b/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
@@ -196,3 +196,45 @@ Description:
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
+		blob names, ending in symlinks to the by_key entry for each
+		"basename", as illustrated below (assume current directory is
+		/sys/firmware):
+
+		    qemu_fw_cfg/by_name/bootorder -> ../by_key/38
+		    qemu_fw_cfg/by_name/etc/e820 -> ../../by_key/35
+		    qemu_fw_cfg/by_name/etc/acpi/rsdp -> ../../../by_key/41
+		    ...
+
+		Construction of the directory tree and symlinks is done on a
+		"best-effort" basis, as there is no guarantee that components
+		of fw_cfg blob names are always "well behaved". I.e., there is
+		the possibility that a symlink (basename) will conflict with
+		a dirname component of another fw_cfg blob, in which case the
+		creation of the offending /sys/firmware/qemu_fw_cfg/by_name
+		entry will be skipped.
+
+		The authoritative list of entries will continue to be found
+		under the /sys/firmware/qemu_fw_cfg/by_key directory.
diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index 618304a..9ac1ca7 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -318,9 +318,103 @@ static struct bin_attribute fw_cfg_sysfs_attr_raw = {
 	.read = fw_cfg_sysfs_read_raw,
 };
 
-/* kobjects representing top-level and by_key folders */
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
+static int fw_cfg_build_symlink(struct kset *dir,
+				struct kobject *target, const char *name)
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
+/* kobjects & kset representing top-level, by_key, and by_name folders */
 static struct kobject *fw_cfg_top_ko;
 static struct kobject *fw_cfg_sel_ko;
+static struct kset *fw_cfg_fname_kset;
 
 /* register an individual fw_cfg file */
 static int fw_cfg_register_file(const struct fw_cfg_file *f)
@@ -347,6 +441,9 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	if (err)
 		goto err_add_raw;
 
+	/* try adding "/sys/firmware/qemu_fw_cfg/by_name/" symlink */
+	fw_cfg_build_symlink(fw_cfg_fname_kset, &entry->kobj, entry->f.name);
+
 	/* success, add entry to global cache */
 	fw_cfg_sysfs_cache_enlist(entry);
 	return 0;
@@ -401,18 +498,21 @@ static int fw_cfg_sysfs_probe(struct platform_device *pdev)
 
 	/* NOTE: If we supported multiple fw_cfg devices, we'd first create
 	 * a subdirectory named after e.g. pdev->id, then hang per-device
-	 * by_key subdirectories underneath it. However, only
+	 * by_key (and by_name) subdirectories underneath it. However, only
 	 * one fw_cfg device exist system-wide, so if one was already found
 	 * earlier, we might as well stop here.
 	 */
 	if (fw_cfg_sel_ko)
 		return -EBUSY;
 
-	/* create by_key subdirectory of /sys/firmware/qemu_fw_cfg/ */
+	/* create by_key and by_name subdirs of /sys/firmware/qemu_fw_cfg/ */
 	err = -ENOMEM;
 	fw_cfg_sel_ko = kobject_create_and_add("by_key", fw_cfg_top_ko);
 	if (!fw_cfg_sel_ko)
 		goto err_sel;
+	fw_cfg_fname_kset = kset_create_and_add("by_name", NULL, fw_cfg_top_ko);
+	if (!fw_cfg_fname_kset)
+		goto err_name;
 
 	/* initialize fw_cfg device i/o from platform data */
 	err = fw_cfg_do_platform_probe(pdev);
@@ -441,6 +541,8 @@ err_dir:
 err_rev:
 	fw_cfg_io_cleanup();
 err_probe:
+	fw_cfg_kset_unregister_recursive(fw_cfg_fname_kset);
+err_name:
 	fw_cfg_kobj_cleanup(fw_cfg_sel_ko);
 err_sel:
 	return err;
@@ -450,6 +552,7 @@ static int fw_cfg_sysfs_remove(struct platform_device *pdev)
 {
 	pr_debug("fw_cfg: unloading.\n");
 	fw_cfg_sysfs_cache_cleanup();
+	fw_cfg_kset_unregister_recursive(fw_cfg_fname_kset);
 	fw_cfg_kobj_cleanup(fw_cfg_sel_ko);
 	fw_cfg_io_cleanup();
 	return 0;
-- 
2.4.3
