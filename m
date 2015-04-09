From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 13/21] Drivers: hv: util: introduce hv_utils_transport
 abstraction
Date: Thu,  9 Apr 2015 10:38:42 +0200
Message-ID: <1428568730-6030-14-git-send-email-vkuznets@redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The intention is to make KVP/VSS drivers work through misc char devices.
Introduce an abstraction for kernel/userspace communication to make the
migration smoother. Transport operational mode (netlink or char device)
is determined by the first received message. To support driver upgrades
the switch from netlink to chardev operational mode is supported.

Every hv_util daemon is supposed to register 2 callbacks:
1) on_msg() to get notified when the userspace daemon sent a message;
2) on_reset() to get notified when the userspace daemon drops the connection.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/Makefile             |   2 +-
 drivers/hv/hv_utils_transport.c | 276 ++++++++++++++++++++++++++++++++++++++++
 drivers/hv/hv_utils_transport.h |  51 ++++++++
 3 files changed, 328 insertions(+), 1 deletion(-)
 create mode 100644 drivers/hv/hv_utils_transport.c
 create mode 100644 drivers/hv/hv_utils_transport.h

diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
index 5e4dfa4..39c9b2c 100644
--- a/drivers/hv/Makefile
+++ b/drivers/hv/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_HYPERV_BALLOON)	+= hv_balloon.o
 hv_vmbus-y := vmbus_drv.o \
 		 hv.o connection.o channel.o \
 		 channel_mgmt.o ring_buffer.o
-hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o hv_fcopy.o
+hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o hv_fcopy.o hv_utils_transport.o
diff --git a/drivers/hv/hv_utils_transport.c b/drivers/hv/hv_utils_transport.c
new file mode 100644
index 0000000..ea7ba5e
--- /dev/null
+++ b/drivers/hv/hv_utils_transport.c
@@ -0,0 +1,276 @@
+/*
+ * Kernel/userspace transport abstraction for Hyper-V util driver.
+ *
+ * Copyright (C) 2015, Vitaly Kuznetsov <vkuznets@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+
+#include "hyperv_vmbus.h"
+#include "hv_utils_transport.h"
+
+static DEFINE_SPINLOCK(hvt_list_lock);
+static struct list_head hvt_list = LIST_HEAD_INIT(hvt_list);
+
+static void hvt_reset(struct hvutil_transport *hvt)
+{
+	mutex_lock(&hvt->outmsg_lock);
+	kfree(hvt->outmsg);
+	hvt->outmsg = NULL;
+	hvt->outmsg_len = 0;
+	mutex_unlock(&hvt->outmsg_lock);
+	if (hvt->on_reset)
+		hvt->on_reset();
+}
+
+static ssize_t hvt_op_read(struct file *file, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	struct hvutil_transport *hvt;
+	int ret;
+
+	hvt = container_of(file->f_op, struct hvutil_transport, fops);
+
+	if (wait_event_interruptible(hvt->outmsg_q, hvt->outmsg_len > 0))
+		return -EINTR;
+
+	mutex_lock(&hvt->outmsg_lock);
+	if (!hvt->outmsg) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	if (count < hvt->outmsg_len) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!copy_to_user(buf, hvt->outmsg, hvt->outmsg_len))
+		ret = hvt->outmsg_len;
+	else
+		ret = -EFAULT;
+
+	kfree(hvt->outmsg);
+	hvt->outmsg = NULL;
+	hvt->outmsg_len = 0;
+
+out_unlock:
+	mutex_unlock(&hvt->outmsg_lock);
+	return ret;
+}
+
+static ssize_t hvt_op_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct hvutil_transport *hvt;
+	u8 *inmsg;
+
+	hvt = container_of(file->f_op, struct hvutil_transport, fops);
+
+	inmsg = kzalloc(count, GFP_KERNEL);
+	if (copy_from_user(inmsg, buf, count)) {
+		kfree(inmsg);
+		return -EFAULT;
+	}
+	if (hvt->on_msg(inmsg, count))
+		return -EFAULT;
+	kfree(inmsg);
+
+	return count;
+}
+
+static unsigned int hvt_op_poll(struct file *file, poll_table *wait)
+{
+	struct hvutil_transport *hvt;
+
+	hvt = container_of(file->f_op, struct hvutil_transport, fops);
+
+	poll_wait(file, &hvt->outmsg_q, wait);
+	if (hvt->outmsg_len > 0)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static int hvt_op_open(struct inode *inode, struct file *file)
+{
+	struct hvutil_transport *hvt;
+
+	hvt = container_of(file->f_op, struct hvutil_transport, fops);
+
+	/*
+	 * Switching to CHARDEV mode. We switch bach to INIT when device
+	 * gets released.
+	 */
+	if (hvt->mode == HVUTIL_TRANSPORT_INIT)
+		hvt->mode = HVUTIL_TRANSPORT_CHARDEV;
+	else if (hvt->mode == HVUTIL_TRANSPORT_NETLINK) {
+		/*
+		 * We're switching from netlink communication to using char
+		 * device. Issue the reset first.
+		 */
+		hvt_reset(hvt);
+		hvt->mode = HVUTIL_TRANSPORT_CHARDEV;
+	} else
+		return -EBUSY;
+
+	return 0;
+}
+
+static int hvt_op_release(struct inode *inode, struct file *file)
+{
+	struct hvutil_transport *hvt;
+
+	hvt = container_of(file->f_op, struct hvutil_transport, fops);
+
+	hvt->mode = HVUTIL_TRANSPORT_INIT;
+	/*
+	 * Cleanup message buffers to avoid spurious messages when the daemon
+	 * connects back.
+	 */
+	hvt_reset(hvt);
+
+	return 0;
+}
+
+static void hvt_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
+{
+	struct hvutil_transport *hvt, *hvt_found = NULL;
+
+	spin_lock(&hvt_list_lock);
+	list_for_each_entry(hvt, &hvt_list, list) {
+		if (hvt->cn_id.idx == msg->id.idx &&
+		    hvt->cn_id.val == msg->id.val) {
+			hvt_found = hvt;
+			break;
+		}
+	}
+	spin_unlock(&hvt_list_lock);
+	if (!hvt_found) {
+		pr_warn("hvt_cn_callback: spurious message received!\n");
+		return;
+	}
+
+	/*
+	 * Switching to NETLINK mode. Switching to CHARDEV happens when someone
+	 * opens the device.
+	 */
+	if (hvt->mode == HVUTIL_TRANSPORT_INIT)
+		hvt->mode = HVUTIL_TRANSPORT_NETLINK;
+
+	if (hvt->mode == HVUTIL_TRANSPORT_NETLINK)
+		hvt_found->on_msg(msg->data, msg->len);
+	else
+		pr_warn("hvt_cn_callback: unexpected netlink message!\n");
+}
+
+int hvutil_transport_send(struct hvutil_transport *hvt, void *msg, int len)
+{
+	struct cn_msg *cn_msg;
+	int ret = 0;
+
+	if (hvt->mode == HVUTIL_TRANSPORT_INIT) {
+		return -EINVAL;
+	} else if (hvt->mode == HVUTIL_TRANSPORT_NETLINK) {
+		cn_msg = kzalloc(sizeof(*cn_msg) + len, GFP_ATOMIC);
+		if (!msg)
+			return -ENOMEM;
+		cn_msg->id.idx = hvt->cn_id.idx;
+		cn_msg->id.val = hvt->cn_id.val;
+		cn_msg->len = len;
+		memcpy(cn_msg->data, msg, len);
+		ret = cn_netlink_send(cn_msg, 0, 0, GFP_ATOMIC);
+		kfree(cn_msg);
+		return ret;
+	}
+	/* HVUTIL_TRANSPORT_CHARDEV */
+	mutex_lock(&hvt->outmsg_lock);
+	if (hvt->outmsg) {
+		/* Previous message wasn't received */
+		ret = -EFAULT;
+		goto out_unlock;
+	}
+	hvt->outmsg = kzalloc(len, GFP_KERNEL);
+	memcpy(hvt->outmsg, msg, len);
+	hvt->outmsg_len = len;
+	wake_up_interruptible(&hvt->outmsg_q);
+out_unlock:
+	mutex_unlock(&hvt->outmsg_lock);
+	return ret;
+}
+
+struct hvutil_transport *hvutil_transport_init(const char *name,
+					       u32 cn_idx, u32 cn_val,
+					       int (*on_msg)(void *, int),
+					       void (*on_reset)(void))
+{
+	struct hvutil_transport *hvt;
+
+	hvt = kzalloc(sizeof(*hvt), GFP_KERNEL);
+	if (!hvt)
+		return NULL;
+
+	hvt->cn_id.idx = cn_idx;
+	hvt->cn_id.val = cn_val;
+
+	hvt->mdev.minor = MISC_DYNAMIC_MINOR;
+	hvt->mdev.name = name;
+
+	hvt->fops.owner = THIS_MODULE;
+	hvt->fops.read = hvt_op_read;
+	hvt->fops.write = hvt_op_write;
+	hvt->fops.poll = hvt_op_poll;
+	hvt->fops.open = hvt_op_open;
+	hvt->fops.release = hvt_op_release;
+
+	hvt->mdev.fops = &hvt->fops;
+
+	init_waitqueue_head(&hvt->outmsg_q);
+	mutex_init(&hvt->outmsg_lock);
+
+	spin_lock(&hvt_list_lock);
+	list_add(&hvt->list, &hvt_list);
+	spin_unlock(&hvt_list_lock);
+
+	hvt->on_msg = on_msg;
+	hvt->on_reset = on_reset;
+
+	if (misc_register(&hvt->mdev))
+		goto err_free_hvt;
+
+	/* Use cn_id.idx/cn_id.val to determine if we need to setup netlink */
+	if (hvt->cn_id.idx > 0 && hvt->cn_id.val > 0 &&
+	    cn_add_callback(&hvt->cn_id, name, hvt_cn_callback))
+		goto err_free_hvt;
+
+	return hvt;
+
+err_free_hvt:
+	kfree(hvt);
+	return NULL;
+}
+
+void hvutil_transport_destroy(struct hvutil_transport *hvt)
+{
+	spin_lock(&hvt_list_lock);
+	list_del(&hvt->list);
+	spin_unlock(&hvt_list_lock);
+	if (hvt->cn_id.idx > 0 && hvt->cn_id.val > 0)
+		cn_del_callback(&hvt->cn_id);
+	misc_deregister(&hvt->mdev);
+	kfree(hvt->outmsg);
+	kfree(hvt);
+}
diff --git a/drivers/hv/hv_utils_transport.h b/drivers/hv/hv_utils_transport.h
new file mode 100644
index 0000000..314c76c
--- /dev/null
+++ b/drivers/hv/hv_utils_transport.h
@@ -0,0 +1,51 @@
+/*
+ * Kernel/userspace transport abstraction for Hyper-V util driver.
+ *
+ * Copyright (C) 2015, Vitaly Kuznetsov <vkuznets@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ */
+
+#ifndef _HV_UTILS_TRANSPORT_H
+#define _HV_UTILS_TRANSPORT_H
+
+#include <linux/connector.h>
+#include <linux/miscdevice.h>
+
+enum hvutil_transport_mode {
+	HVUTIL_TRANSPORT_INIT = 0,
+	HVUTIL_TRANSPORT_NETLINK,
+	HVUTIL_TRANSPORT_CHARDEV,
+};
+
+struct hvutil_transport {
+	int mode;                           /* hvutil_transport_mode */
+	struct file_operations fops;        /* file operations */
+	struct miscdevice mdev;             /* misc device */
+	struct cb_id cn_id;                 /* CN_*_IDX/CN_*_VAL */
+	struct list_head list;              /* hvt_list */
+	int (*on_msg)(void *, int);         /* callback on new user message */
+	void (*on_reset)(void);             /* callback when userspace drops */
+	u8 *outmsg;                         /* message to the userspace */
+	int outmsg_len;                     /* its length */
+	wait_queue_head_t outmsg_q;         /* poll/read wait queue */
+	struct mutex outmsg_lock;           /* protects outmsg */
+};
+
+struct hvutil_transport *hvutil_transport_init(const char *name,
+					       u32 cn_idx, u32 cn_val,
+					       int (*on_msg)(void *, int),
+					       void (*on_reset)(void));
+int hvutil_transport_send(struct hvutil_transport *hvt, void *msg, int len);
+void hvutil_transport_destroy(struct hvutil_transport *hvt);
+
+#endif /* _HV_UTILS_TRANSPORT_H */
-- 
1.9.3
