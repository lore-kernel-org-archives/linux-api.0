From: Robin Dong <hao.bigrat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3,23/23] netoops: Add OOM event to dump.
Date: Fri, 22 Apr 2011 19:22:01 +0800
Message-ID: <1303471321-11863-1-git-send-email-hao.bigrat@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Robin Dong <sanbai-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Robin Dong <sanbai-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Our team is evaluating the netoops patchs since it is very useful in 
complicated data center environment.
But we also need to catch the OOM message from remote machine.
So I add this patch.


Signed-off-by: Robin Dong <sanbai-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/netoops.c     |   23 ++++++++++++++++++++++-
 include/linux/kmsg_dump.h |    1 +
 mm/oom_kill.c             |    3 +++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 036e4d8..921775d 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -113,6 +113,7 @@ static struct netoops_msg msg;
 static size_t netoops_user_blob_length;
 static char netoops_user_blob[NETOOPS_BLOB_BYTES];
 static u32 netoops_boot_id;
+static u32 netoops_record_oom;
 
 static void setup_packet_header(int packet_count, struct pt_regs *regs,
 				int soft_dump)
@@ -201,10 +202,15 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 	int soft_dump = 0;
 	int i;
 
+	/* Record oom event only when netoops_record_oom is 1 */
+	if (reason == KMSG_DUMP_OOM && netoops_record_oom == 0)
+		return;
+
 	/* Only handle fatal problems */
 	if (reason != KMSG_DUMP_OOPS
 	 && reason != KMSG_DUMP_PANIC
-	 && reason != KMSG_DUMP_SOFT)
+	 && reason != KMSG_DUMP_SOFT
+	 && reason != KMSG_DUMP_OOM)
 		return;
 
 	if (reason == KMSG_DUMP_SOFT)
@@ -241,6 +247,10 @@ static ssize_t netoops_show(struct kobject *kobj,
 		snprintf(buf, PAGE_SIZE, "%d\n", netoops_boot_id);
 		return strnlen(buf, PAGE_SIZE);
 	}
+	if (!strcmp(attr->attr.name, "netoops_record_oom")) {
+		snprintf(buf, PAGE_SIZE, "%d\n", netoops_record_oom);
+		return strnlen(buf, PAGE_SIZE);
+	}
 	return -EINVAL;
 }
 
@@ -261,6 +271,14 @@ static ssize_t netoops_store(struct kobject *kobj,
 		if (tmp > UINT_MAX)
 			printk("Warning: truncating boot_id to 32bits.");
 		netoops_boot_id = tmp;
+	} else if (!strcmp(attr->attr.name, "netoops_record_oom")) {
+		unsigned long tmp;
+		if (strict_strtoul(buf, 0, &tmp))
+			return -EINVAL;
+		if (tmp)
+			netoops_record_oom = 1;
+		else
+			netoops_record_oom = 0;
 	} else
 		return -EINVAL;
 
@@ -271,10 +289,13 @@ static struct kobj_attribute netoops_user_blob_attribute =
 	__ATTR(netoops_user_blob, 0644, netoops_show, netoops_store);
 static struct kobj_attribute netoops_boot_number_attribute =
 	__ATTR(netoops_boot_id, 0666, netoops_show, netoops_store);
+static struct kobj_attribute netoops_record_oom_attribute =
+	__ATTR(netoops_record_oom, 0666, netoops_show, netoops_store);
 
 static struct attribute *attrs[] = {
 	&netoops_user_blob_attribute.attr,
 	&netoops_boot_number_attribute.attr,
+	&netoops_record_oom_attribute.attr,
 	NULL,
 };
 
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index 0abc2d7..cefbf5f 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -21,6 +21,7 @@ enum kmsg_dump_reason {
 	KMSG_DUMP_PANIC,
 	KMSG_DUMP_KEXEC,
 	KMSG_DUMP_SOFT,
+	KMSG_DUMP_OOM,
 };
 
 /**
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7dcca55..40f3862 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -31,6 +31,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
+#include <linux/kmsg_dump.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -742,6 +743,8 @@ out:
 	 */
 	if (killed && !test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
+
+	kmsg_dump(KMSG_DUMP_OOM, NULL);
 }
 
 /*
-- 
1.7.1
