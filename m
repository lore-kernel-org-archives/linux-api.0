From: Kazimierz Krosman <k.krosman@samsung.com>
Subject: [PATCH v6 5/8] kmsg: add function for adding and deleting additional
 buffers
Date: Wed, 24 Feb 2016 12:53:18 +0100
Message-ID: <1456314801-32738-6-git-send-email-k.krosman@samsung.com>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, peter@hurleysoftware.com, tj@kernel.org, vvs@virtuozzo.com, corbet@lwn.net, arnd@arndb.de, pmladek@suse.cz, gregkh@linuxfoundation.org, daniel@zonque.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: k.lewandowsk@samsung.com, k.krosman@samsung.com, m.niesluchow@samsung.com, richard.weinberger@gmail.com, b.zolnierkie@samsung.com, luto@amacapital.net, knhoon.baik@samsung.com
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow@samsung.com>

Additional kmsg buffers should be created and deleted dynamically.

Adding two functions
* kmsg_sys_buffer_add() creates additional kmsg buffer returning minor
* kmsg_sys_buffer_del() deletes one based on provided minor

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
[Rebased kmsg patch v5 on Linux 4.5-rc5]
Signed-off-by: Kazimierz Krosman <k.krosman@samsung.com>
---
 include/linux/printk.h |   9 +++++
 kernel/printk/kmsg.c   | 107 +++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/printk/printk.c |  12 ++++++
 kernel/printk/printk.h |   4 ++
 4 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 342e9d0..c146ee4 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -431,6 +431,8 @@ extern const struct file_operations kmsg_fops;
 extern struct device *init_kmsg(int minor, umode_t mode);
 extern int kmsg_memory_open(struct inode *inode, struct file *filp);
 extern int kmsg_mode(int minor, umode_t *mode);
+extern int kmsg_sys_buffer_add(size_t size, umode_t mode);
+extern void kmsg_sys_buffer_del(int minor);
 
 #else
 
@@ -449,6 +451,13 @@ static inline int kmsg_mode(int minor, umode_t *mode)
 	return -ENXIO;
 }
 
+static inline int kmsg_sys_buffer_add(size_t size, umode_t mode)
+{
+	return -ENXIO;
+}
+
+static inline void kmsg_sys_buffer_del(int minor) {}
+
 #endif
 
 enum {
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
index b5e07ff..82bc282 100644
--- a/kernel/printk/kmsg.c
+++ b/kernel/printk/kmsg.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/major.h>
 #include <linux/kdev_t.h>
+#include <linux/kref.h>
 
 #include <asm/uaccess.h>
 
@@ -141,8 +142,20 @@ static ssize_t kmsg_read(struct log_buffer *log_b, struct file *file,
 		}
 
 		raw_spin_unlock_irq(&log_b->lock);
-		ret = wait_event_interruptible(log_b->wait,
-					       user->seq != log_b->next_seq);
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
 		raw_spin_lock_irq(&log_b->lock);
@@ -311,8 +324,14 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
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
@@ -428,6 +447,88 @@ int kmsg_mode(int minor, umode_t *mode)
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
 static DEFINE_SPINLOCK(dump_list_lock);
 static LIST_HEAD(dump_list);
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index d8626ee..fd5991d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -42,6 +42,8 @@
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
 #include <linux/ctype.h>
+#include <linux/kref.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm-generic/sections.h>
@@ -171,6 +173,7 @@ struct log_buffer log_buf = {
 	.len		= __LOG_BUF_K_LEN,
 	.lock		= __RAW_SPIN_LOCK_UNLOCKED(log_buf.lock),
 	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(log_buf.wait),
+	.refcount	= { .refcount = { .counter = 0 } },
 	.first_seq	= 0,
 	.first_idx	= 0,
 	.next_seq	= 0,
@@ -216,6 +219,15 @@ u32 log_buf_len_get(void)
 	return log_buf.len;
 }
 
+void log_buf_release(struct kref *ref)
+{
+	struct log_buffer *log_b = container_of(ref, struct log_buffer,
+						refcount);
+
+	kfree(log_b->buf);
+	kfree(log_b);
+}
+
 /*
  * Check whether there is enough free space for the given message.
  *
diff --git a/kernel/printk/printk.h b/kernel/printk/printk.h
index e5c8a46..a873c27 100644
--- a/kernel/printk/printk.h
+++ b/kernel/printk/printk.h
@@ -5,6 +5,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/kref.h>
 
 #ifdef CONFIG_PRINTK
 
@@ -111,6 +112,7 @@ struct log_buffer {
 	char *buf;		/* cyclic log buffer */
 	u32 len;		/* buffer length */
 	wait_queue_head_t wait;	/* wait queue for kmsg buffer */
+	struct kref refcount;	/* refcount for kmsg_sys buffers */
 #endif
 /*
  * The lock protects kmsg buffer, indices, counters. This can be taken within
@@ -139,6 +141,8 @@ struct log_buffer {
 
 extern struct log_buffer log_buf;
 
+void log_buf_release(struct kref *ref);
+
 ssize_t msg_print_ext_header(char *buf, size_t size,
 				    struct printk_log *msg, u64 seq,
 				    enum log_flags prev_flags);
-- 
1.9.1
