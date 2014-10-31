From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 3/5] kdbus: check if lsm permits installing received fds
Date: Fri, 31 Oct 2014 17:36:35 +0100
Message-ID: <1414773397-26490-4-git-send-email-k.lewandowsk@samsung.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: pmoore@redhat.com, jkosina@suse.cz, linux-api@vger.kernel.org, inux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk, daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com, marcel@holtmann.org, tixxdz@opendz.org, javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk, linux-security-module@vger.kernel.org, lmctlx@gmail.com, r.krypa@samsung.com
List-Id: linux-api@vger.kernel.org

From: Karol Lewandowski <lmctlx@gmail.com>

Signed-off-by: Karol Lewandowski <lmctlx@gmail.com>
---
 drivers/misc/kdbus/queue.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/misc/kdbus/queue.c b/drivers/misc/kdbus/queue.c
index 6693852..dae18bd 100644
--- a/drivers/misc/kdbus/queue.c
+++ b/drivers/misc/kdbus/queue.c
@@ -25,6 +25,7 @@
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/sizes.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
@@ -41,6 +42,18 @@ static int kdbus_queue_entry_fds_install(struct kdbus_queue_entry *entry)
 	int ret, *fds;
 	size_t count;
 
+        for (i = 0; i < entry->fds_count; i++) {
+                ret = security_file_receive(entry->fds_fp[i]);
+                if (ret)
+                        return ret;
+        }
+
+        for (i = 0; i < entry->memfds_count; i++) {
+                ret = security_file_receive(entry->memfds_fp[i]);
+                if (ret)
+                        return ret;
+        }
+
 	/* get array of file descriptors */
 	count = entry->fds_count + entry->memfds_count;
 	if (!count)
-- 
2.1.1

