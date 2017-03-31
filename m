From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memory hotplug and force_remove
Date: Fri, 31 Mar 2017 12:55:05 +0200
Message-ID: <20170331105505.GM27098@dhcp22.suse.cz>
References: <20170320192938.GA11363@dhcp22.suse.cz>
 <2735706.OR0SQDpVy6@aspire.rjw.lan>
 <20170328075808.GB18241@dhcp22.suse.cz>
 <2203902.lsAnRkUs2Y@aspire.rjw.lan>
 <20170331083017.GK27098@dhcp22.suse.cz>
 <20170331104905.GA28365@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170331104905.GA28365-g7OFGfmEpDh8S/rGE13EwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Kani Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 31-03-17 18:49:05, Joey Lee wrote:
> Hi Michal,
> 
> On Fri, Mar 31, 2017 at 10:30:17AM +0200, Michal Hocko wrote:
[...]
> > @@ -241,11 +232,10 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
> >  		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> >  				    NULL, acpi_bus_offline, (void *)true,
> >  				    (void **)&errdev);
> > -		if (!errdev || acpi_force_hot_remove)
> > +		if (!errdev)
> >  			acpi_bus_offline(handle, 0, (void *)true,
> >  					 (void **)&errdev);
> > -
> > -		if (errdev && !acpi_force_hot_remove) {
> > +		else {
>               ^^^^^^^^^^^^^
> Here should still checks the parent's errdev state then rollback
> parent/children to online state:
> 
> -		if (errdev && !acpi_force_hot_remove) {
> +		if (errdev) {

You are right, I have missed that acpi_bus_offline modifies errdev.
Thanks for spotting that! Updated patch is below.
---
>From 8df0abd29988ffb52b6df52407b96d6015861bb7 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Date: Fri, 31 Mar 2017 10:08:41 +0200
Subject: [PATCH] acpi: drop support for force_remove

/sys/firmware/acpi/hotplug/force_remove was presumably added to support
auto offlining in the past. This is, however, inherently dangerous for
some hotplugable resources like memory. The memory offlining fails when
the memory is still in use and cannot be dropped or migrated. If we
ignore the failure we are basically allowing for subtle memory
corruption or a crash.

We have actually noticed the later while hitting BUG() during the memory
hotremove (remove_memory):
	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
			check_memblock_offlined_cb);
	if (ret)
		BUG();

it took us quite non-trivial time realize that the customer had
force_remove enabled. Even if the BUG was removed here and we could
propagate the error up the call chain it wouldn't help at all because
then we would hit a crash or a memory corruption later and harder to
debug. So force_remove is unfixable for the memory hotremove. We haven't
checked other hotplugable resources to be prone to a similar problems.

Remove the force_remove functionality because it is not fixable currently.
Keep the sysfs file and report an error if somebody tries to enable it.
Encourage users to report about the missing functionality and work with
them with an alternative solution.

Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 Documentation/ABI/obsolete/sysfs-firmware-acpi |  8 ++++++++
 Documentation/ABI/testing/sysfs-firmware-acpi  | 10 ----------
 drivers/acpi/internal.h                        |  2 --
 drivers/acpi/scan.c                            | 16 +++-------------
 drivers/acpi/sysfs.c                           |  9 +++++----
 5 files changed, 16 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-firmware-acpi

diff --git a/Documentation/ABI/obsolete/sysfs-firmware-acpi b/Documentation/ABI/obsolete/sysfs-firmware-acpi
new file mode 100644
index 000000000000..6715a71bec3d
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-firmware-acpi
@@ -0,0 +1,8 @@
+What:		/sys/firmware/acpi/hotplug/force_remove
+Date:		Mar 2017
+Contact:	Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+Description:
+		Since the force_remove is inherently broken and dangerous to
+		use for some hotplugable resources like memory (because ignoring
+		the offline failure might lead to memory corruption and crashes)
+		enabling this knob is not safe and thus unsupported.
diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentation/ABI/testing/sysfs-firmware-acpi
index c7fc72d4495c..613f42a9d5cd 100644
--- a/Documentation/ABI/testing/sysfs-firmware-acpi
+++ b/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -44,16 +44,6 @@ Contact:	Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 		or 0 (unset).  Attempts to write any other values to it will
 		cause -EINVAL to be returned.
 
-What:		/sys/firmware/acpi/hotplug/force_remove
-Date:		May 2013
-Contact:	Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
-Description:
-		The number in this file (0 or 1) determines whether (1) or not
-		(0) the ACPI subsystem will allow devices to be hot-removed even
-		if they cannot be put offline gracefully (from the kernel's
-		viewpoint).  That number can be changed by writing a boolean
-		value to this file.
-
 What:		/sys/firmware/acpi/interrupts/
 Date:		February 2008
 Contact:	Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index f15900132912..66229ffa909b 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -65,8 +65,6 @@ static inline void acpi_cmos_rtc_init(void) {}
 #endif
 int acpi_rev_override_setup(char *str);
 
-extern bool acpi_force_hot_remove;
-
 void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
 				    const char *name);
 int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 192691880d55..e2080b6e54aa 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -30,12 +30,6 @@ extern struct acpi_device *acpi_root;
 
 #define INVALID_ACPI_HANDLE	((acpi_handle)empty_zero_page)
 
-/*
- * If set, devices will be hot-removed even if they cannot be put offline
- * gracefully (from the kernel's standpoint).
- */
-bool acpi_force_hot_remove;
-
 static const char *dummy_hid = "device";
 
 static LIST_HEAD(acpi_dep_list);
@@ -170,9 +164,6 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 			pn->put_online = false;
 		}
 		ret = device_offline(pn->dev);
-		if (acpi_force_hot_remove)
-			continue;
-
 		if (ret >= 0) {
 			pn->put_online = !ret;
 		} else {
@@ -241,11 +232,11 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    NULL, acpi_bus_offline, (void *)true,
 				    (void **)&errdev);
-		if (!errdev || acpi_force_hot_remove)
+		if (!errdev)
 			acpi_bus_offline(handle, 0, (void *)true,
 					 (void **)&errdev);
 
-		if (errdev && !acpi_force_hot_remove) {
+		if (errdev) {
 			dev_warn(errdev, "Offline failed.\n");
 			acpi_bus_online(handle, 0, NULL, NULL);
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
@@ -263,8 +254,7 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
 	unsigned long long sta;
 	acpi_status status;
 
-	if (device->handler && device->handler->hotplug.demand_offline
-	    && !acpi_force_hot_remove) {
+	if (device->handler && device->handler->hotplug.demand_offline) {
 		if (!acpi_scan_is_offline(device, true))
 			return -EBUSY;
 	} else {
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index cf05ae973381..1b5ee1e0e5a3 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -921,7 +921,7 @@ void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
 static ssize_t force_remove_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", !!acpi_force_hot_remove);
+	return sprintf(buf, "%d\n", 0);
 }
 
 static ssize_t force_remove_store(struct kobject *kobj,
@@ -935,9 +935,10 @@ static ssize_t force_remove_store(struct kobject *kobj,
 	if (ret < 0)
 		return ret;
 
-	lock_device_hotplug();
-	acpi_force_hot_remove = val;
-	unlock_device_hotplug();
+	if (val) {
+		pr_err("Enabling force_remove is not supported anymore. Please report to linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org if you depend on this functionality\n");
+		return -EINVAL;
+	}
 	return size;
 }
 
-- 
2.11.0

-- 
Michal Hocko
SUSE Labs
