From: Marcin Niesluchowski <m.niesluchow@samsung.com>
Subject: [RFC 6/8] kmsg: add predefined _PID, _TID,
 _COMM keywords to kmsg* log dict
Date: Fri, 03 Jul 2015 12:49:53 +0200
Message-ID: <1435920595-30879-7-git-send-email-m.niesluchow@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>
List-Id: linux-api@vger.kernel.org

kmsg* devices write operation wrote no dict along with message
Due to usage of kmsg devices in userspace dict has been added
identifying pid, tid and comm of writing process.

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
---
 kernel/printk/printk.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index abe78c1..2a7f6a4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -876,7 +876,34 @@ void log_buf_release(struct kref *ref)
 	kfree(log_b);
 }
 
-static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
+#define MAX_PID_LEN	20
+#define MAX_TID_LEN	20
+/*
+ * Fromat below describes dict appended to message written from userspace:
+ * "_PID=<pid>\0_TID=<tid>\0_COMM=<comm>"
+ * KMSG_DICT_MAX_LEN definition represents maximal length of this dict.
+ */
+#define KMSG_DICT_MAX_LEN	(5 + MAX_PID_LEN + 1 + \
+				 5 + MAX_TID_LEN + 1 + \
+				 6 + TASK_COMM_LEN)
+
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
@@ -891,7 +918,7 @@ static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
 
 		va_start(args, fmt);
 		log_format_and_store(log_b, 1 /* LOG_USER */, level,
-				     NULL, 0, fmt, args);
+				     dict, dictlen, fmt, args);
 		va_end(args);
 		wake_up_interruptible(&log_b->wait);
 
@@ -911,6 +938,8 @@ static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 	int level = default_message_loglevel;
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_iter_count(from);
+	char dict[KMSG_DICT_MAX_LEN];
+	size_t dictlen;
 	ssize_t ret = len;
 	int minor = iminor(iocb->ki_filp->f_inode);
 
@@ -950,10 +979,13 @@ static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
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

