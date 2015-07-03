From: Marcin Niesluchowski <m.niesluchow@samsung.com>
Subject: [RFC 4/8] kmsg: add function for adding and deleting additional buffers
Date: Fri, 03 Jul 2015 12:49:51 +0200
Message-ID: <1435920595-30879-5-git-send-email-m.niesluchow@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>
List-Id: linux-api@vger.kernel.org

Additional kmsg buffers should be created and deleted dynamically.

Adding two functions
* kmsg_sys_buffer_add() creates additional kmsg buffer returning minor
* kmsg_sys_buffer_del() deletes one based on provided minor

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
---
 include/linux/printk.h |   3 ++
 kernel/printk/printk.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index d3b5f23..5806982 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -422,6 +422,9 @@ extern void init_kmsg_minor(int minor);
 
 extern int kmsg_sys_mode(int minor, umode_t *mode);
 
+extern int kmsg_sys_buffer_add(size_t size, umode_t mode);
+extern void kmsg_sys_buffer_del(int minor);
+
 enum {
 	DUMP_PREFIX_NONE,
 	DUMP_PREFIX_ADDRESS,
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7f30c8b..abe78c1 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -46,6 +46,9 @@
 #include <linux/utsname.h>
 #include <linux/ctype.h>
 #include <linux/uio.h>
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <linux/kdev_t.h>
 
 #include <asm/uaccess.h>
 
@@ -240,6 +243,7 @@ struct log_buffer {
 	char *buf;		/* cyclic log buffer */
 	u32 len;		/* buffer length */
 	wait_queue_head_t wait;	/* wait queue for kmsg buffer */
+	struct kref refcount;	/* refcount for kmsg_sys buffers */
 #endif
 /*
  * The lock protects kmsg buffer, indices, counters. This can be taken within
@@ -292,6 +296,7 @@ static struct log_buffer log_buf = {
 	.len		= __LOG_BUF_K_LEN,
 	.lock		= __RAW_SPIN_LOCK_UNLOCKED(log_buf.lock),
 	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(log_buf.wait),
+	.refcount	= { .refcount = { .counter = 0 } },
 	.first_seq	= 0,
 	.first_idx	= 0,
 	.next_seq	= 0,
@@ -862,6 +867,15 @@ struct devkmsg_user {
 	char buf[CONSOLE_EXT_LOG_MAX];
 };
 
+void log_buf_release(struct kref *ref)
+{
+	struct log_buffer *log_b = container_of(ref, struct log_buffer,
+						refcount);
+
+	kfree(log_b->buf);
+	kfree(log_b);
+}
+
 static int kmsg_sys_write(int minor, int level, const char *fmt, ...)
 {
 	va_list args;
@@ -969,10 +983,24 @@ static ssize_t kmsg_read(struct log_buffer *log_b, struct file *file,
 		}
 
 		raw_spin_unlock_irq(&log_b->lock);
-		ret = wait_event_interruptible(log_b->wait,
-					       user->seq != log_b->next_seq);
+
+		if (log_b == &log_buf) {
+			ret = wait_event_interruptible(log_b->wait,
+						user->seq != log_b->next_seq);
+		} else {
+			rcu_read_unlock();
+			kref_get(&log_b->refcount);
+			ret = wait_event_interruptible(log_b->wait,
+						user->seq != log_b->next_seq);
+			if (log_b->minor == -1)
+				ret = -ENXIO;
+			if (kref_put(&log_b->refcount, log_buf_release))
+				ret = -ENXIO;
+			rcu_read_lock();
+		}
 		if (ret)
 			goto out;
+
 		raw_spin_lock_irq(&log_b->lock);
 	}
 
@@ -1140,8 +1168,14 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 	rcu_read_lock();
 	list_for_each_entry_rcu(log_b, &log_buf.list, list) {
 		if (log_b->minor == minor) {
+			kref_get(&log_b->refcount);
+			rcu_read_unlock();
+
 			ret = kmsg_poll(log_b, file, wait);
-			break;
+
+			if (kref_put(&log_b->refcount, log_buf_release))
+				return POLLERR|POLLNVAL;
+			return ret;
 		}
 	}
 	rcu_read_unlock();
@@ -1242,6 +1276,88 @@ int kmsg_sys_mode(int minor, umode_t *mode)
 	return ret;
 }
 
+static DEFINE_SPINLOCK(kmsg_sys_list_lock);
+
+int kmsg_sys_buffer_add(size_t size, umode_t mode)
+{
+	unsigned long flags;
+	int minor = log_buf.minor;
+	struct log_buffer *log_b;
+	struct log_buffer *log_b_new;
+
+	if (size < LOG_LINE_MAX + PREFIX_MAX)
+		return -EINVAL;
+
+	log_b_new = kzalloc(sizeof(struct log_buffer), GFP_KERNEL);
+	if (!log_b_new)
+		return -ENOMEM;
+
+	log_b_new->buf = kmalloc(size, GFP_KERNEL);
+	if (!log_b_new->buf) {
+		kfree(log_b_new);
+		return -ENOMEM;
+	}
+
+	log_b_new->len = size;
+	log_b_new->lock = __RAW_SPIN_LOCK_UNLOCKED(log_b_new->lock);
+	init_waitqueue_head(&log_b_new->wait);
+	kref_init(&log_b_new->refcount);
+	log_b_new->mode = mode;
+
+	kref_get(&log_b_new->refcount);
+
+	spin_lock_irqsave(&kmsg_sys_list_lock, flags);
+
+	list_for_each_entry(log_b, &log_buf.list, list) {
+		if (log_b->minor - minor > 1)
+			break;
+
+		minor = log_b->minor;
+	}
+
+	if (!(minor & MINORMASK)) {
+		kref_put(&log_b->refcount, log_buf_release);
+		spin_unlock_irqrestore(&kmsg_sys_list_lock, flags);
+		return -ERANGE;
+	}
+
+	minor += 1;
+	log_b_new->minor = minor;
+
+	list_add_tail_rcu(&log_b_new->list, &log_b->list);
+
+	spin_unlock_irqrestore(&kmsg_sys_list_lock, flags);
+
+	return minor;
+}
+
+void kmsg_sys_buffer_del(int minor)
+{
+	unsigned long flags;
+	struct log_buffer *log_b;
+
+	spin_lock_irqsave(&kmsg_sys_list_lock, flags);
+
+	list_for_each_entry(log_b, &log_buf.list, list) {
+		if (log_b->minor == minor)
+			break;
+	}
+
+	if (log_b == &log_buf) {
+		spin_unlock_irqrestore(&kmsg_sys_list_lock, flags);
+		return;
+	}
+
+	list_del_rcu(&log_b->list);
+
+	spin_unlock_irqrestore(&kmsg_sys_list_lock, flags);
+
+	log_b->minor = -1;
+	wake_up_interruptible(&log_b->wait);
+
+	kref_put(&log_b->refcount, log_buf_release);
+}
+
 #ifdef CONFIG_KEXEC
 /*
  * This appends the listed symbols to /proc/vmcore
-- 
1.9.1

