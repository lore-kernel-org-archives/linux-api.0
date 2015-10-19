From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC v3 8/9] kmsg: add predefined _PID, _TID,
 _COMM keywords to kmsg* log dict
Date: Mon, 19 Oct 2015 14:58:22 +0200
Message-ID: <1445259503-18158-9-git-send-email-p.osmialowsk@samsung.com>
References: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <1445259503-18158-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow@samsung.com>

kmsg* devices write operation wrote no dict along with message
Due to usage of kmsg devices in userspace dict has been added
identifying pid, tid and comm of writing process.

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 kernel/printk/kmsg.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
index 0f56fc9..8c904fe 100644
--- a/kernel/printk/kmsg.c
+++ b/kernel/printk/kmsg.c
@@ -28,6 +28,17 @@
 
 #define KMSG_MAX_MINOR_LEN	20
 
+#define MAX_PID_LEN		20
+#define MAX_TID_LEN		20
+/*
+ * Fromat below describes dict appended to message written from userspace:
+ * "_PID=<pid>\0_TID=<tid>\0_COMM=<comm>"
+ * KMSG_DICT_MAX_LEN definition represents maximal length of this dict.
+ */
+#define KMSG_DICT_MAX_LEN	(5 + MAX_PID_LEN + 1 + \
+				 5 + MAX_TID_LEN + 1 + \
+				 6 + TASK_COMM_LEN)
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -37,7 +48,23 @@ struct devkmsg_user {
 	char buf[CONSOLE_EXT_LOG_MAX];
 };
 
-static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
+static size_t set_kmsg_dict(char *buf)
+{
+	size_t len;
+
+	len = sprintf(buf, "_PID=%d", task_tgid_nr(current)) + 1;
+	len += sprintf(buf + len, "_TID=%d", task_pid_nr(current)) + 1;
+	memcpy(buf + len, "_COMM=", 6);
+	len += 6;
+	get_task_comm(buf + len, current);
+	while (buf[len] != '\0')
+		len++;
+	return len;
+}
+
+static int kmsg_sys_write(int minor, int level,
+			  const char *dict, size_t dictlen,
+			  const char *fmt, ...)
 {
 	va_list args;
 	int ret = -ENXIO;
@@ -52,7 +79,7 @@ static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
 
 		va_start(args, fmt);
 		log_format_and_store(log_b, 1 /* LOG_USER */, level,
-				     NULL, 0, fmt, args);
+				     dict, dictlen, fmt, args);
 		va_end(args);
 		wake_up_interruptible(&log_b->wait);
 
@@ -72,6 +99,8 @@ static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 	int level = default_message_loglevel;
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_iter_count(from);
+	char dict[KMSG_DICT_MAX_LEN];
+	size_t dictlen;
 	ssize_t ret = len;
 	int minor = iminor(iocb->ki_filp->f_inode);
 
@@ -111,10 +140,13 @@ static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 		}
 	}
 
+	dictlen = set_kmsg_dict(dict);
+
 	if (minor == log_buf.minor) {
-		printk_emit(facility, level, NULL, 0, "%s", line);
+		printk_emit(facility, level, dict, dictlen, "%s", line);
 	} else {
-		int error = kmsg_sys_write(minor, level, "%s", line);
+		int error = kmsg_sys_write(minor, level, dict, dictlen,
+					   "%s", line);
 
 		if (error)
 			ret = error;
-- 
1.9.1

