From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 21/23] netoops: Add user programmable fields to the netoops
	packet.
Date: Mon, 08 Nov 2010 12:33:41 -0800
Message-ID: <20101108203340.22479.22958.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108203120.22479.19708.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In our environment, it is important for us to capture motherboard name,
firmware version and boot number for consideration when analyzing netoops
dumps.

We collect this information in userland at system startup (in platform
specific ways) and plug this information into the netoops driver via
files available in sysfs.

Files introduced:
  /sys/kernel/netdump/netdump_board_name
  /sys/kernel/netdump/netdump_fw_version
  /sys/kernel/netdump/netdump_boot_id

If this were to be rewritten, we would probably like to have a more
general way for userland to add to netdump packets.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
TODO: This would probably be better handled by having the kernel accept
some blob of data.  It doesn't need to know what the data itself is, as
long as it is delivered in each packet.
---
 drivers/net/netoops.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index f63e12a..5cbb732 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -68,7 +68,7 @@ struct netoops_msg {
 		u16 type;
 		u32 packet_count;
 		u32 packet_no;
-		u32 __reserved1;
+		u32 blog_boot_id;
 		u8 x86_family;
 		u8 x86_model;
 		u8 x86_stepping;
@@ -77,8 +77,13 @@ struct netoops_msg {
 		 * termination not required.
 		 */
 		char kernel_version[64];
-		char __reserved2[64];
-		char __reserved3[64];
+		/*
+		 * bios and board info come from smbios which
+		 * has a maximum string length of 64 according
+		 * to page 26 of the smbios 2.3 spec.
+		 */
+		char bios_version[64];
+		char motherboard_type[64];
 		/* NOTE: regs is 60 or 168 bytes */
 		struct pt_regs regs; /* arch specific. */
 		/*
@@ -93,7 +98,12 @@ struct netoops_msg {
 
 static struct netoops_msg msg;
 
-static void setup_packet_header(int packet_count, int soft_dump)
+static char netoops_fw_version[80];
+static char netoops_board_name[80];
+static int netoops_boot_number;
+
+static void setup_packet_header(int packet_count, struct pt_regs *regs,
+				int soft_dump)
 {
 	msg.header.version = NETOOPS_VERSION;
 	msg.header.arch = NETOOPS_ARCH;
@@ -102,11 +112,16 @@ static void setup_packet_header(int packet_count, int soft_dump)
 	msg.header.dump_id = (jiffies/HZ) & 0xffff;
 	msg.header.packet_count = packet_count;
 	msg.header.header_size = sizeof(msg.header);
+	msg.header.blog_boot_id = (u32)netoops_boot_number;
 #ifndef CONFIG_UML
 	msg.header.x86_family = current_cpu_data.x86;
 	msg.header.x86_model = current_cpu_data.x86_model;
 	msg.header.x86_stepping = current_cpu_data.x86_mask;
 #endif
+	strncpy(msg.header.bios_version, netoops_fw_version,
+		sizeof(msg.header.bios_version));
+	strncpy(msg.header.motherboard_type, netoops_board_name,
+		sizeof(msg.header.motherboard_type));
 	strncpy(msg.header.kernel_version,
 		utsname()->release,
 		min(sizeof(msg.header.kernel_version),
@@ -209,6 +224,60 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 	spin_unlock_irqrestore(&targets.lock, flags);
 }
 
+static ssize_t netoops_show(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    char *buf) {
+
+	if (!strcmp(attr->attr.name, "netdump_fw_version"))
+		strncpy(buf, netoops_fw_version, PAGE_SIZE);
+	else if (!strcmp(attr->attr.name, "netdump_board_name"))
+		strncpy(buf, netoops_board_name, PAGE_SIZE);
+	else if (!strcmp(attr->attr.name, "netdump_boot_number"))
+		snprintf(buf, PAGE_SIZE, "%d\n", netoops_boot_number);
+	buf[PAGE_SIZE - 1] = '\0';
+	return strnlen(buf, PAGE_SIZE);
+}
+
+static ssize_t netoops_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf,
+			     size_t count) {
+	if (!count)
+		return count;
+
+	if (!strcmp(attr->attr.name, "netdump_fw_version")) {
+		strncpy(netoops_fw_version, buf, sizeof(netoops_fw_version));
+		netoops_fw_version[sizeof(netoops_fw_version) - 1] = '\0';
+	} else if (!strcmp(attr->attr.name, "netdump_board_name")) {
+		strncpy(netoops_board_name, buf, sizeof(netoops_board_name));
+		netoops_board_name[sizeof(netoops_board_name) - 1] = '\0';
+	} else if (!strcmp(attr->attr.name, "netdump_boot_number")) {
+		((char *)buf)[count - 1] = '\0';
+		sscanf(buf, "%du", &netoops_boot_number);
+	}
+	return count;
+}
+
+static struct kobj_attribute netoops_fw_version_attribute =
+	__ATTR(netoops_fw_version, 0666, netoops_show, netoops_store);
+static struct kobj_attribute netoops_board_name_attribute =
+	__ATTR(netoops_board_name, 0666, netoops_show, netoops_store);
+static struct kobj_attribute netoops_boot_number_attribute =
+	__ATTR(netoops_boot_number, 0666, netoops_show, netoops_store);
+
+static struct attribute *attrs[] = {
+	&netoops_fw_version_attribute.attr,
+	&netoops_board_name_attribute.attr,
+	&netoops_boot_number_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attrs,
+};
+
+static struct kobject *netoops_kobj;
+
 static struct kmsg_dumper netoops_dumper = {
 	.dump = netoops,
 };
@@ -228,11 +297,23 @@ static int __init netoops_init(void)
 	if (retval)
 		goto out;
 
+	netoops_kobj = kobject_create_and_add("netoops", kernel_kobj);
+	if (!netoops_kobj)
+		goto out_targets;
+
+	retval = sysfs_create_group(netoops_kobj, &attr_group);
+	if (retval)
+		goto out_kobj;
+
 	retval = kmsg_dump_register(&netoops_dumper);
 	if (retval)
-		goto out_targets;
+		goto out_sysfs_group;
 
 	return 0;
+out_sysfs_group:
+	sysfs_remove_group(netoops_kobj, &attr_group);
+out_kobj:
+	kobject_put(netoops_kobj);
 out_targets:
 	unregister_netpoll_targets(&targets);
 out:
@@ -242,6 +323,8 @@ out:
 static void __exit netoops_exit(void)
 {
 	kmsg_dump_unregister(&netoops_dumper);
+	sysfs_remove_group(netoops_kobj, &attr_group);
+	kobject_put(netoops_kobj);
 	unregister_netpoll_targets(&targets);
 }
 
