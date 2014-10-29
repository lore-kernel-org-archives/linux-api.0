From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add driver skeleton, ioctl entry points and utility functions
Date: Wed, 29 Oct 2014 15:00:47 -0700
Message-ID: <1414620056-6675-4-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org, gregkh@linuxfoundation.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, teg@jklm.no
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

Add the basic driver structure.

handle.c is the main ioctl command dispatcher that calls into other parts
of the driver.

main.c contains the code that creates the initial domain at startup, and
util.c has utility functions such as item iterators that are shared with
other files.

limits.h describes limits on things like maximum data structure sizes,
number of messages per users and suchlike. Some of the numbers currently
picked are rough ideas of what what might be sufficient and are probably
rather conservative.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/misc/kdbus/handle.c          | 1221 ++++++++++++++++++++++++++++++++++
 drivers/misc/kdbus/handle.h          |   46 ++
 drivers/misc/kdbus/limits.h          |   77 +++
 drivers/misc/kdbus/main.c            |   70 ++
 drivers/misc/kdbus/util.c            |  108 +++
 drivers/misc/kdbus/util.h            |   94 +++
 7 files changed, 1617 insertions(+)
 create mode 100644 drivers/misc/kdbus/handle.c
 create mode 100644 drivers/misc/kdbus/handle.h
 create mode 100644 drivers/misc/kdbus/limits.h
 create mode 100644 drivers/misc/kdbus/main.c
 create mode 100644 drivers/misc/kdbus/util.c
 create mode 100644 drivers/misc/kdbus/util.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 8136e1fd30fd..54e091ebb862 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -292,6 +292,7 @@ Code  Seq#(hex)	Include File		Comments
 0x92	00-0F	drivers/usb/mon/mon_bin.c
 0x93	60-7F	linux/auto_fs.h
 0x94	all	fs/btrfs/ioctl.h
+0x95	all	uapi/linux/kdbus.h	kdbus IPC driver
 0x97	00-7F	fs/ceph/ioctl.h		Ceph file system
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
diff --git a/drivers/misc/kdbus/handle.c b/drivers/misc/kdbus/handle.c
new file mode 100644
index 000000000000..14810577e269
--- /dev/null
+++ b/drivers/misc/kdbus/handle.c
@@ -0,0 +1,1221 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+
+#include "bus.h"
+#include "connection.h"
+#include "endpoint.h"
+#include "handle.h"
+#include "item.h"
+#include "match.h"
+#include "message.h"
+#include "metadata.h"
+#include "names.h"
+#include "domain.h"
+#include "policy.h"
+
+/**
+ * enum kdbus_handle_type - type a handle can be of
+ * @_KDBUS_HANDLE_NULL:			Uninitialized/invalid
+ * @KDBUS_HANDLE_CONTROL:		New file descriptor of a control node
+ * @KDBUS_HANDLE_CONTROL_DOMAIN_OWNER:	File descriptor to hold a domain
+ * @KDBUS_HANDLE_CONTROL_BUS_OWNER:	File descriptor to hold a bus
+ * @KDBUS_HANDLE_EP:			New file descriptor of a bus node
+ * @KDBUS_HANDLE_ENDPOINT_CONNECTED:	A bus connection after HELLO
+ * @KDBUS_HANDLE_ENDPOINT_OWNER:	File descriptor to hold an endpoint
+ */
+enum kdbus_handle_type {
+	_KDBUS_HANDLE_NULL,
+	KDBUS_HANDLE_CONTROL,
+	KDBUS_HANDLE_CONTROL_DOMAIN_OWNER,
+	KDBUS_HANDLE_CONTROL_BUS_OWNER,
+	KDBUS_HANDLE_EP,
+	KDBUS_HANDLE_ENDPOINT_CONNECTED,
+	KDBUS_HANDLE_ENDPOINT_OWNER,
+};
+
+/**
+ * struct kdbus_handle - a handle to the kdbus system
+ * @type:		Type of this handle (KDBUS_HANDLE_*)
+ * @domain:		Domain for this handle
+ * @meta:		Cached connection creator's metadata/credentials
+ * @ep:			The endpoint for this handle, in case @type is
+ *			KDBUS_HANDLE_EP, KDBUS_HANDLE_ENDPOINT_OWNER or
+ *			KDBUS_HANDLE_ENDPOINT_CONNECTED
+ * @ptr:		Generic pointer used as alias for other members
+ *			in the same union by kdbus_handle_transform()
+ * @domain_owner:	The domain this handle owns, in case @type
+ *			is KDBUS_HANDLE_CONTROL_DOMAIN_OWNER
+ * @bus_owner:		The bus this handle owns, in case @type
+ *			is KDBUS_HANDLE_CONTROL_BUS_OWNER
+ * @ep_owner:		The endpoint this handle owns, in case @type
+ *			is KDBUS_HANDLE_ENDPOINT_OWNER
+ * @conn:		The connection this handle owns, in case @type
+ *			is KDBUS_HANDLE_EP, after HELLO it is
+ *			KDBUS_HANDLE_ENDPOINT_CONNECTED
+ */
+struct kdbus_handle {
+	enum kdbus_handle_type type;
+	struct kdbus_domain *domain;
+	struct kdbus_meta *meta;
+	struct kdbus_ep *ep;
+	union {
+		void *ptr;
+		struct kdbus_domain *domain_owner;
+		struct kdbus_bus *bus_owner;
+		struct kdbus_ep *ep_owner;
+		struct kdbus_conn *conn;
+	};
+};
+
+/* kdbus major */
+static unsigned int kdbus_major;
+
+/* map of minors to objects */
+static DEFINE_IDR(kdbus_minor_idr);
+
+/* kdbus minor lock */
+static DEFINE_SPINLOCK(kdbus_minor_lock);
+
+int kdbus_minor_init(void)
+{
+	int ret;
+
+	ret = __register_chrdev(0, 0, 0xfffff, KBUILD_MODNAME,
+				&kdbus_handle_ops);
+	if (ret < 0)
+		return ret;
+
+	kdbus_major = ret;
+	return 0;
+}
+
+void kdbus_minor_exit(void)
+{
+	__unregister_chrdev(kdbus_major, 0, 0xfffff, KBUILD_MODNAME);
+	idr_destroy(&kdbus_minor_idr);
+}
+
+static void *kdbus_minor_pack(enum kdbus_minor_type type, void *ptr)
+{
+	unsigned long p = (unsigned long)ptr;
+
+	BUILD_BUG_ON(KDBUS_MINOR_CNT > 4);
+
+	if (WARN_ON(p & 0x3UL || type >= KDBUS_MINOR_CNT))
+		return NULL;
+
+	return (void *)(p | (unsigned long)type);
+}
+
+static enum kdbus_minor_type kdbus_minor_unpack(void **ptr)
+{
+	unsigned long p = (unsigned long)*ptr;
+
+	*ptr = (void *)(p & ~0x3UL);
+	return p & 0x3UL;
+}
+
+static void kdbus_minor_ref(enum kdbus_minor_type type, void *ptr)
+{
+	if (ptr) {
+		switch (type) {
+		case KDBUS_MINOR_CONTROL:
+			kdbus_domain_ref(ptr);
+			break;
+		case KDBUS_MINOR_EP:
+			kdbus_ep_ref(ptr);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void kdbus_minor_unref(enum kdbus_minor_type type, void *ptr)
+{
+	if (ptr) {
+		switch (type) {
+		case KDBUS_MINOR_CONTROL:
+			kdbus_domain_unref(ptr);
+			break;
+		case KDBUS_MINOR_EP:
+			kdbus_ep_unref(ptr);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/**
+ * kdbus_minor_alloc() - allocate a minor for a new kdbus device node
+ * @type:	The type of device to allocate
+ * @ptr:	The opaque pointer of the new device to store
+ * @out:	Pointer to a dev_t for storing the result.
+ *
+ * Returns: 0 on success, in which case @out is set to the newly allocated
+ * device node.
+ */
+int kdbus_minor_alloc(enum kdbus_minor_type type, void *ptr, dev_t *out)
+{
+	int ret;
+
+	ptr = kdbus_minor_pack(type, ptr);
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&kdbus_minor_lock);
+	ret = idr_alloc(&kdbus_minor_idr, ptr, 0, 0, GFP_NOWAIT);
+	spin_unlock(&kdbus_minor_lock);
+	idr_preload_end();
+
+	if (ret < 0)
+		return ret;
+
+	*out = MKDEV(kdbus_major, ret);
+	return 0;
+}
+
+/**
+ * kdbus_minor_free() - free a minor of a kdbus device node
+ * @devt:	The device node to remove
+ */
+void kdbus_minor_free(dev_t devt)
+{
+	unsigned int minor = MINOR(devt);
+
+	if (!devt)
+		return;
+
+	spin_lock(&kdbus_minor_lock);
+	idr_remove(&kdbus_minor_idr, minor);
+	spin_unlock(&kdbus_minor_lock);
+}
+
+/**
+ * kdbus_minor_set() - set an existing minor type of a kdbus device node
+ * @devt:	The device node to remove
+ * @type:	New type to set
+ * @ptr:	Associated pointer when node was initially registered
+ */
+void kdbus_minor_set(dev_t devt, enum kdbus_minor_type type, void *ptr)
+{
+	unsigned int minor = MINOR(devt);
+
+	ptr = kdbus_minor_pack(type, ptr);
+
+	spin_lock(&kdbus_minor_lock);
+	ptr = idr_replace(&kdbus_minor_idr, ptr, minor);
+	spin_unlock(&kdbus_minor_lock);
+}
+
+static int kdbus_minor_lookup(dev_t devt, void **out)
+{
+	unsigned int minor = MINOR(devt);
+	enum kdbus_minor_type type;
+	void *ptr;
+
+	spin_lock(&kdbus_minor_lock);
+	ptr = idr_find(&kdbus_minor_idr, minor);
+	type = kdbus_minor_unpack(&ptr);
+	kdbus_minor_ref(type, ptr);
+	spin_unlock(&kdbus_minor_lock);
+
+	if (!ptr)
+		return -ESHUTDOWN;
+
+	*out = ptr;
+	return type;
+}
+
+static int kdbus_handle_open(struct inode *inode, struct file *file)
+{
+	enum kdbus_minor_type minor_type;
+	struct kdbus_handle *handle;
+	void *minor_ptr;
+	int ret;
+
+	ret = kdbus_minor_lookup(inode->i_rdev, &minor_ptr);
+	if (ret < 0)
+		return ret;
+
+	minor_type = ret;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle) {
+		kdbus_minor_unref(minor_type, minor_ptr);
+		return -ENOMEM;
+	}
+
+	file->private_data = handle;
+
+	switch (minor_type) {
+	case KDBUS_MINOR_CONTROL:
+		handle->type = KDBUS_HANDLE_CONTROL;
+		handle->domain = minor_ptr;
+
+		break;
+
+	case KDBUS_MINOR_EP:
+		handle->type = KDBUS_HANDLE_EP;
+		handle->ep = minor_ptr;
+		handle->domain = kdbus_domain_ref(handle->ep->bus->domain);
+
+		/* cache the metadata/credentials of the creator */
+		ret = kdbus_meta_new(&handle->meta);
+		if (ret < 0)
+			goto exit_free;
+
+		ret = kdbus_meta_append(handle->meta, NULL, 0,
+					KDBUS_ATTACH_CREDS	|
+					KDBUS_ATTACH_TID_COMM	|
+					KDBUS_ATTACH_PID_COMM	|
+					KDBUS_ATTACH_EXE	|
+					KDBUS_ATTACH_CMDLINE	|
+					KDBUS_ATTACH_CGROUP	|
+					KDBUS_ATTACH_CAPS	|
+					KDBUS_ATTACH_SECLABEL	|
+					KDBUS_ATTACH_AUDIT);
+		if (ret < 0)
+			goto exit_free;
+
+		break;
+
+	default:
+		kdbus_minor_unref(minor_type, minor_ptr);
+		ret = -EINVAL;
+		goto exit_free;
+	}
+
+	return 0;
+
+exit_free:
+	kdbus_meta_free(handle->meta);
+	kdbus_ep_unref(handle->ep);
+	kdbus_domain_unref(handle->domain);
+	kfree(handle);
+	return ret;
+}
+
+static int kdbus_handle_release(struct inode *inode, struct file *file)
+{
+	struct kdbus_handle *handle = file->private_data;
+
+	switch (handle->type) {
+	case KDBUS_HANDLE_CONTROL_DOMAIN_OWNER:
+		kdbus_domain_disconnect(handle->domain_owner);
+		kdbus_domain_unref(handle->domain_owner);
+		break;
+
+	case KDBUS_HANDLE_CONTROL_BUS_OWNER:
+		kdbus_bus_disconnect(handle->bus_owner);
+		kdbus_bus_unref(handle->bus_owner);
+		break;
+
+	case KDBUS_HANDLE_ENDPOINT_OWNER:
+		kdbus_ep_disconnect(handle->ep_owner);
+		kdbus_ep_unref(handle->ep_owner);
+		break;
+
+	case KDBUS_HANDLE_ENDPOINT_CONNECTED:
+		kdbus_conn_disconnect(handle->conn, false);
+		kdbus_conn_unref(handle->conn);
+		break;
+
+	default:
+		break;
+	}
+
+	kdbus_meta_free(handle->meta);
+	kdbus_domain_unref(handle->domain);
+	kdbus_ep_unref(handle->ep);
+	kfree(handle);
+
+	return 0;
+}
+
+static int kdbus_copy_from_user(void *dest,
+				void __user *user_ptr,
+				size_t size)
+{
+	if (!KDBUS_IS_ALIGNED8((uintptr_t)user_ptr))
+		return -EFAULT;
+
+	if (copy_from_user(dest, user_ptr, size))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kdbus_memdup_user(void __user *user_ptr,
+			     void **out,
+			     size_t size_min,
+			     size_t size_max)
+{
+	void *ptr = NULL;
+	u64 size;
+	int ret;
+
+	ret = kdbus_copy_from_user(&size, user_ptr, sizeof(size));
+	if (ret < 0)
+		return ret;
+
+	if (size < size_min)
+		return -EINVAL;
+
+	if (size > size_max)
+		return -EMSGSIZE;
+
+	ptr = memdup_user(user_ptr, size);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	*out = ptr;
+	return 0;
+}
+
+static int kdbus_handle_transform(struct kdbus_handle *handle,
+				  enum kdbus_handle_type old_type,
+				  enum kdbus_handle_type new_type,
+				  void *ctx_ptr)
+{
+	int ret = -EBADFD;
+
+	/*
+	 * This transforms a handle from one state into another. Only a single
+	 * transformation is allowed per handle, and it must be one of:
+	 *   CONTROL -> CONTROL_DOMAIN_OWNER
+	 *           -> CONTROL_BUS_OWNER
+	 *        EP -> EP_CONNECTED
+	 *           -> EP_OWNER
+	 *
+	 * State transformations are protected by the domain-lock. If another
+	 * transformation runs in parallel, we will fail and the caller has to
+	 * revert any previous steps.
+	 *
+	 * We also update any context before we write the new type. Reads can
+	 * now be sure that iff a specific non-entry type is set, the context
+	 * is accessible, too (given appropriate read-barriers).
+	 */
+
+	mutex_lock(&handle->domain->lock);
+	if (handle->type == old_type) {
+		handle->ptr = ctx_ptr;
+		/* make sure handle->XYZ is accessible before the type is set */
+		smp_wmb();
+		handle->type = new_type;
+		ret = 0;
+	}
+	mutex_unlock(&handle->domain->lock);
+
+	return ret;
+}
+
+/* kdbus control device commands */
+static long kdbus_handle_ioctl_control(struct file *file, unsigned int cmd,
+				       void __user *buf)
+{
+	struct kdbus_handle *handle = file->private_data;
+	struct kdbus_bus *bus = NULL;
+	struct kdbus_cmd_make *make;
+	struct kdbus_domain *domain = NULL;
+	umode_t mode = 0600;
+	void *p = NULL;
+	int ret;
+
+	switch (cmd) {
+	case KDBUS_CMD_BUS_MAKE: {
+		kgid_t gid = KGIDT_INIT(0);
+		struct kdbus_bloom_parameter bloom;
+		char *name;
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*make),
+					KDBUS_MAKE_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		make = p;
+
+		ret = kdbus_negotiate_flags(make, buf, typeof(*make),
+					    KDBUS_MAKE_ACCESS_GROUP |
+					    KDBUS_MAKE_ACCESS_WORLD);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(make->items,
+					   KDBUS_ITEMS_SIZE(make, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_bus_make_user(make, &name, &bloom);
+		if (ret < 0)
+			break;
+
+		if (make->flags & KDBUS_MAKE_ACCESS_WORLD) {
+			mode = 0666;
+		} else if (make->flags & KDBUS_MAKE_ACCESS_GROUP) {
+			mode = 0660;
+			gid = current_fsgid();
+		}
+
+		ret = kdbus_bus_new(handle->domain, make, name, &bloom,
+				    mode, current_fsuid(), gid, &bus);
+		if (ret < 0)
+			break;
+
+		/* turn the control fd into a new bus owner device */
+		ret = kdbus_handle_transform(handle, KDBUS_HANDLE_CONTROL,
+					     KDBUS_HANDLE_CONTROL_BUS_OWNER,
+					     bus);
+		if (ret < 0) {
+			kdbus_bus_disconnect(bus);
+			kdbus_bus_unref(bus);
+			break;
+		}
+
+		break;
+	}
+
+	case KDBUS_CMD_DOMAIN_MAKE: {
+		const char *name;
+
+		if (!capable(CAP_IPC_OWNER)) {
+			ret = -EPERM;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*make),
+					KDBUS_MAKE_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		make = p;
+
+		ret = kdbus_negotiate_flags(make, buf, typeof(*make),
+					    KDBUS_MAKE_ACCESS_GROUP |
+					    KDBUS_MAKE_ACCESS_WORLD);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(make->items,
+					   KDBUS_ITEMS_SIZE(make, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_get_str(make->items,
+					  KDBUS_ITEMS_SIZE(make, items),
+					  KDBUS_ITEM_MAKE_NAME, &name);
+		if (ret < 0)
+			break;
+
+		if (make->flags & KDBUS_MAKE_ACCESS_WORLD)
+			mode = 0666;
+
+		ret = kdbus_domain_new(handle->domain, name, mode, &domain);
+		if (ret < 0)
+			break;
+
+		/* turn the control fd into a new domain owner device */
+		ret = kdbus_handle_transform(handle, KDBUS_HANDLE_CONTROL,
+					     KDBUS_HANDLE_CONTROL_DOMAIN_OWNER,
+					     domain);
+		if (ret < 0) {
+			kdbus_domain_disconnect(domain);
+			kdbus_domain_unref(domain);
+			break;
+		}
+
+		break;
+	}
+
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	kfree(p);
+
+	return ret;
+}
+
+/* kdbus endpoint make commands */
+static long kdbus_handle_ioctl_ep(struct file *file, unsigned int cmd,
+				  void __user *buf)
+{
+	struct kdbus_handle *handle = file->private_data;
+	void *p = NULL;
+	long ret = 0;
+
+	switch (cmd) {
+	case KDBUS_CMD_ENDPOINT_MAKE: {
+		struct kdbus_cmd_make *make;
+		umode_t mode = 0;
+		kgid_t gid = KGIDT_INIT(0);
+		const char *name;
+		struct kdbus_ep *ep;
+
+		/* creating custom endpoints is a privileged operation */
+		if (!kdbus_bus_uid_is_privileged(handle->ep->bus)) {
+			ret = -EPERM;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*make),
+					KDBUS_MAKE_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		make = p;
+
+		ret = kdbus_negotiate_flags(make, buf, typeof(*make),
+					    KDBUS_MAKE_ACCESS_GROUP |
+					    KDBUS_MAKE_ACCESS_WORLD);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(make->items,
+					   KDBUS_ITEMS_SIZE(make, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_get_str(make->items,
+					  KDBUS_ITEMS_SIZE(make, items),
+					  KDBUS_ITEM_MAKE_NAME, &name);
+		if (ret < 0)
+			break;
+
+		if (make->flags & KDBUS_MAKE_ACCESS_WORLD) {
+			mode = 0666;
+		} else if (make->flags & KDBUS_MAKE_ACCESS_GROUP) {
+			mode = 0660;
+			gid = current_fsgid();
+		}
+
+		/* custom endpoints always have a policy db */
+		ret = kdbus_ep_new(handle->ep->bus, name, mode,
+				   current_fsuid(), gid, true, &ep);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_ep_policy_set(ep, make->items,
+					  KDBUS_ITEMS_SIZE(make, items));
+		if (ret < 0) {
+			kdbus_ep_disconnect(ep);
+			kdbus_ep_unref(ep);
+			break;
+		}
+
+		/*
+		 * Get an anonymous user to account messages against; custom
+		 * endpoint users do not share the budget with the ordinary
+		 * users created for a UID.
+		 */
+		ret = kdbus_domain_get_user(handle->ep->bus->domain,
+					    INVALID_UID, &ep->user);
+		if (ret < 0) {
+			kdbus_ep_disconnect(ep);
+			kdbus_ep_unref(ep);
+			break;
+		}
+
+		/* turn the ep fd into a new endpoint owner device */
+		ret = kdbus_handle_transform(handle, KDBUS_HANDLE_EP,
+					     KDBUS_HANDLE_ENDPOINT_OWNER, ep);
+		if (ret < 0) {
+			kdbus_ep_disconnect(ep);
+			kdbus_ep_unref(ep);
+			break;
+		}
+
+		break;
+	}
+
+	case KDBUS_CMD_HELLO: {
+		struct kdbus_cmd_hello *hello;
+		struct kdbus_conn *conn = NULL;
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*hello),
+					KDBUS_HELLO_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		hello = p;
+
+		ret = kdbus_negotiate_flags(hello, buf, typeof(*hello),
+					    KDBUS_HELLO_ACCEPT_FD |
+					    KDBUS_HELLO_ACTIVATOR |
+					    KDBUS_HELLO_POLICY_HOLDER |
+					    KDBUS_HELLO_MONITOR);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(hello->items,
+					   KDBUS_ITEMS_SIZE(hello, items));
+		if (ret < 0)
+			break;
+
+		if (hello->pool_size == 0 ||
+		    !IS_ALIGNED(hello->pool_size, PAGE_SIZE)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = kdbus_conn_new(handle->ep, hello, handle->meta, &conn);
+		if (ret < 0)
+			break;
+
+		/* turn the ep fd into a new connection */
+		ret = kdbus_handle_transform(handle, KDBUS_HANDLE_EP,
+					     KDBUS_HANDLE_ENDPOINT_CONNECTED,
+					     conn);
+		if (ret < 0) {
+			kdbus_conn_disconnect(conn, false);
+			kdbus_conn_unref(conn);
+			break;
+		}
+
+		if (copy_to_user(buf, hello, sizeof(*hello)))
+			ret = -EFAULT;
+
+		break;
+	}
+
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	kfree(p);
+
+	return ret;
+}
+
+/* kdbus endpoint commands for connected peers */
+static long kdbus_handle_ioctl_ep_connected(struct file *file, unsigned int cmd,
+					    void __user *buf)
+{
+	struct kdbus_handle *handle = file->private_data;
+	struct kdbus_conn *conn = handle->conn;
+	void *p = NULL;
+	long ret = 0;
+
+	/*
+	 * BYEBYE is special; we must not acquire a connection when
+	 * calling into kdbus_conn_disconnect() or we will deadlock,
+	 * because kdbus_conn_disconnect() will wait for all acquired
+	 * references to be dropped.
+	 */
+	if (cmd == KDBUS_CMD_BYEBYE) {
+		if (!kdbus_conn_is_connected(conn))
+			return -EOPNOTSUPP;
+
+		return kdbus_conn_disconnect(conn, true);
+	}
+
+	ret = kdbus_conn_acquire(conn);
+	if (ret < 0)
+		return ret;
+
+	switch (cmd) {
+	case KDBUS_CMD_NAME_ACQUIRE: {
+		/* acquire a well-known name */
+		struct kdbus_cmd_name *cmd_name;
+
+		if (!kdbus_conn_is_connected(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*cmd_name),
+					sizeof(*cmd_name) +
+						KDBUS_ITEM_HEADER_SIZE +
+						KDBUS_NAME_MAX_LEN + 1);
+		if (ret < 0)
+			break;
+
+		cmd_name = p;
+
+		ret = kdbus_negotiate_flags(cmd_name, buf, typeof(*cmd_name),
+					    KDBUS_NAME_REPLACE_EXISTING |
+					    KDBUS_NAME_ALLOW_REPLACEMENT |
+					    KDBUS_NAME_QUEUE);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_name->items,
+					   KDBUS_ITEMS_SIZE(cmd_name, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_cmd_name_acquire(conn->bus->name_registry, conn, p);
+		if (ret < 0)
+			break;
+
+		/* return flags to the caller */
+		if (copy_to_user(buf, p, cmd_name->size))
+			ret = -EFAULT;
+
+		break;
+	}
+
+	case KDBUS_CMD_NAME_RELEASE: {
+		/* release a well-known name */
+		struct kdbus_cmd_name *cmd_name;
+
+		if (!kdbus_conn_is_connected(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*cmd_name),
+					sizeof(*cmd_name) +
+						KDBUS_ITEM_HEADER_SIZE +
+						KDBUS_NAME_MAX_LEN + 1);
+		if (ret < 0)
+			break;
+
+		cmd_name = p;
+
+		ret = kdbus_negotiate_flags(cmd_name, buf, typeof(*cmd_name),
+					    0);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_name->items,
+					   KDBUS_ITEMS_SIZE(cmd_name, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_cmd_name_release(conn->bus->name_registry, conn, p);
+		break;
+	}
+
+	case KDBUS_CMD_NAME_LIST: {
+		struct kdbus_cmd_name_list cmd_list;
+
+		/* query current IDs and names */
+		if (kdbus_copy_from_user(&cmd_list, buf, sizeof(cmd_list))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = kdbus_negotiate_flags(&cmd_list, buf, typeof(cmd_list),
+					    KDBUS_NAME_LIST_UNIQUE |
+					    KDBUS_NAME_LIST_NAMES |
+					    KDBUS_NAME_LIST_ACTIVATORS |
+					    KDBUS_NAME_LIST_QUEUED);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_cmd_name_list(conn->bus->name_registry,
+					  conn, &cmd_list);
+		if (ret < 0)
+			break;
+
+		/* return allocated data */
+		if (kdbus_offset_set_user(&cmd_list.offset, buf,
+					  struct kdbus_cmd_name_list))
+			ret = -EFAULT;
+
+		break;
+	}
+
+	case KDBUS_CMD_CONN_INFO:
+	case KDBUS_CMD_BUS_CREATOR_INFO: {
+		struct kdbus_cmd_info *cmd_info;
+
+		/* return the properties of a connection */
+		ret = kdbus_memdup_user(buf, &p, sizeof(*cmd_info),
+					sizeof(*cmd_info) +
+						KDBUS_NAME_MAX_LEN + 1);
+		if (ret < 0)
+			break;
+
+		cmd_info = p;
+
+		ret = kdbus_negotiate_flags(cmd_info, buf, typeof(*cmd_info),
+					    _KDBUS_ATTACH_ALL);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_info->items,
+					   KDBUS_ITEMS_SIZE(cmd_info, items));
+		if (ret < 0)
+			break;
+
+		if (cmd == KDBUS_CMD_CONN_INFO)
+			ret = kdbus_cmd_info(conn, cmd_info);
+		else
+			ret = kdbus_cmd_bus_creator_info(conn, cmd_info);
+
+		if (ret < 0)
+			break;
+
+		if (kdbus_offset_set_user(&cmd_info->offset, buf,
+					  struct kdbus_cmd_info))
+			ret = -EFAULT;
+
+		break;
+	}
+
+	case KDBUS_CMD_CONN_UPDATE: {
+		/* update the properties of a connection */
+		struct kdbus_cmd_update *cmd_update;
+
+		if (!kdbus_conn_is_connected(conn) &&
+		    !kdbus_conn_is_policy_holder(conn) &&
+		    !kdbus_conn_is_monitor(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*cmd_update),
+					KDBUS_UPDATE_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		cmd_update = p;
+
+		ret = kdbus_negotiate_flags(cmd_update, buf,
+					    typeof(*cmd_update), 0);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_update->items,
+					   KDBUS_ITEMS_SIZE(cmd_update, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_cmd_conn_update(conn, p);
+		break;
+	}
+
+	case KDBUS_CMD_MATCH_ADD: {
+		/* subscribe to/filter for broadcast messages */
+		struct kdbus_cmd_match *cmd_match;
+
+		if (!kdbus_conn_is_connected(conn) &&
+		    !kdbus_conn_is_monitor(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p, sizeof(*cmd_match),
+					KDBUS_MATCH_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		cmd_match = p;
+
+		ret = kdbus_negotiate_flags(cmd_match, buf, typeof(*cmd_match),
+					    KDBUS_MATCH_REPLACE);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_match->items,
+					   KDBUS_ITEMS_SIZE(cmd_match, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_match_db_add(conn, cmd_match);
+		break;
+	}
+
+	case KDBUS_CMD_MATCH_REMOVE: {
+		/* unsubscribe from broadcast messages */
+		struct kdbus_cmd_match *cmd_match;
+
+		if (!kdbus_conn_is_connected(conn) &&
+		    !kdbus_conn_is_monitor(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_memdup_user(buf, &p,
+					sizeof(*cmd_match),
+					sizeof(*cmd_match));
+		if (ret < 0)
+			break;
+
+		cmd_match = p;
+
+		ret = kdbus_negotiate_flags(cmd_match, buf, typeof(*cmd_match),
+					    0);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_match->items,
+					   KDBUS_ITEMS_SIZE(cmd_match, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_match_db_remove(conn, p);
+		break;
+	}
+
+	case KDBUS_CMD_MSG_SEND: {
+		/* submit a message which will be queued in the receiver */
+		struct kdbus_kmsg *kmsg = NULL;
+
+		if (!kdbus_conn_is_connected(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_kmsg_new_from_user(conn, buf, &kmsg);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_conn_kmsg_send(conn->ep, conn, kmsg);
+		if (ret < 0) {
+			kdbus_kmsg_free(kmsg);
+			break;
+		}
+
+		/* store the offset of the reply back to userspace */
+		if (kmsg->msg.flags & KDBUS_MSG_FLAGS_SYNC_REPLY) {
+			struct kdbus_msg __user *msg = buf;
+
+			if (copy_to_user(&msg->offset_reply,
+					 &kmsg->msg.offset_reply,
+					 sizeof(msg->offset_reply)))
+				ret = -EFAULT;
+		}
+
+		kdbus_kmsg_free(kmsg);
+		break;
+	}
+
+	case KDBUS_CMD_MSG_RECV: {
+		struct kdbus_cmd_recv cmd_recv;
+
+		if (!kdbus_conn_is_connected(conn) &&
+		    !kdbus_conn_is_monitor(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		ret = kdbus_copy_from_user(&cmd_recv, buf, sizeof(cmd_recv));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_negotiate_flags(&cmd_recv, buf, typeof(cmd_recv),
+					    KDBUS_RECV_PEEK | KDBUS_RECV_DROP |
+					    KDBUS_RECV_USE_PRIORITY);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_cmd_msg_recv(conn, &cmd_recv);
+		if (ret < 0)
+			break;
+
+		/* return the address of the next message in the pool */
+		if (kdbus_offset_set_user(&cmd_recv.offset, buf,
+					  struct kdbus_cmd_recv))
+			ret = -EFAULT;
+
+		break;
+	}
+
+	case KDBUS_CMD_MSG_CANCEL: {
+		struct kdbus_cmd_cancel cmd_cancel;
+
+		if (!kdbus_conn_is_connected(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		/* cancel sync message send requests by cookie */
+		ret = kdbus_copy_from_user(&cmd_cancel, buf,
+					   sizeof(cmd_cancel));
+		if (ret < 0)
+			break;
+
+		if (cmd_cancel.flags != 0)
+			return -EOPNOTSUPP;
+
+		ret = kdbus_cmd_msg_cancel(conn, cmd_cancel.cookie);
+		break;
+	}
+
+	case KDBUS_CMD_FREE: {
+		struct kdbus_cmd_free cmd_free;
+
+		if (!kdbus_conn_is_connected(conn) &&
+		    !kdbus_conn_is_monitor(conn)) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		/* free the memory used in the receiver's pool */
+		ret = copy_from_user(&cmd_free, buf, sizeof(cmd_free));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_negotiate_flags(&cmd_free, buf, typeof(cmd_free),
+					    0);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_pool_release_offset(conn->pool, cmd_free.offset);
+		break;
+	}
+
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	kdbus_conn_release(conn);
+	kfree(p);
+	return ret;
+}
+
+/* kdbus endpoint commands for endpoint owners */
+static long kdbus_handle_ioctl_ep_owner(struct file *file, unsigned int cmd,
+					void __user *buf)
+{
+	struct kdbus_handle *handle = file->private_data;
+	struct kdbus_ep *ep = handle->ep_owner;
+	void *p = NULL;
+	long ret = 0;
+
+	switch (cmd) {
+	case KDBUS_CMD_ENDPOINT_UPDATE: {
+		struct kdbus_cmd_update *cmd_update;
+
+		/* update the properties of a custom endpoint */
+		ret = kdbus_memdup_user(buf, &p, sizeof(*cmd_update),
+					KDBUS_UPDATE_MAX_SIZE);
+		if (ret < 0)
+			break;
+
+		cmd_update = p;
+
+		ret = kdbus_negotiate_flags(cmd_update, buf,
+					    typeof(*cmd_update), 0);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_items_validate(cmd_update->items,
+					   KDBUS_ITEMS_SIZE(cmd_update, items));
+		if (ret < 0)
+			break;
+
+		ret = kdbus_ep_policy_set(ep, cmd_update->items,
+					  KDBUS_ITEMS_SIZE(cmd_update, items));
+		break;
+	}
+
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	kfree(p);
+	return ret;
+}
+
+static long kdbus_handle_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct kdbus_handle *handle = file->private_data;
+	void __user *argp = (void __user *)arg;
+	enum kdbus_handle_type type = handle->type;
+
+	/* make sure all handle fields are set if handle->type is */
+	smp_rmb();
+
+	switch (type) {
+	case KDBUS_HANDLE_CONTROL:
+		return kdbus_handle_ioctl_control(file, cmd, argp);
+
+	case KDBUS_HANDLE_EP:
+		return kdbus_handle_ioctl_ep(file, cmd, argp);
+
+	case KDBUS_HANDLE_ENDPOINT_CONNECTED:
+		return kdbus_handle_ioctl_ep_connected(file, cmd, argp);
+
+	case KDBUS_HANDLE_ENDPOINT_OWNER:
+		return kdbus_handle_ioctl_ep_owner(file, cmd, argp);
+
+	default:
+		return -EBADFD;
+	}
+}
+
+static unsigned int kdbus_handle_poll(struct file *file,
+				      struct poll_table_struct *wait)
+{
+	struct kdbus_handle *handle = file->private_data;
+	struct kdbus_conn *conn;
+	unsigned int mask = POLLOUT | POLLWRNORM;
+
+	/* Only a connected endpoint can read/write data */
+	if (handle->type != KDBUS_HANDLE_ENDPOINT_CONNECTED)
+		return POLLERR | POLLHUP;
+
+	/* make sure handle->conn is set if handle->type is */
+	smp_rmb();
+	conn = handle->conn;
+
+	poll_wait(file, &conn->wait, wait);
+
+	mutex_lock(&conn->lock);
+	if (!kdbus_conn_active(conn))
+		mask = POLLERR | POLLHUP;
+	else if (!list_empty(&conn->queue.msg_list))
+		mask |= POLLIN | POLLRDNORM;
+	mutex_unlock(&conn->lock);
+
+	return mask;
+}
+
+static int kdbus_handle_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct kdbus_handle *handle = file->private_data;
+
+	if (handle->type != KDBUS_HANDLE_ENDPOINT_CONNECTED)
+		return -EPERM;
+
+	/* make sure handle->conn is set if handle->type is */
+	smp_rmb();
+
+	return kdbus_pool_mmap(handle->conn->pool, vma);
+}
+
+const struct file_operations kdbus_handle_ops = {
+	.owner =		THIS_MODULE,
+	.open =			kdbus_handle_open,
+	.release =		kdbus_handle_release,
+	.poll =			kdbus_handle_poll,
+	.llseek =		noop_llseek,
+	.unlocked_ioctl =	kdbus_handle_ioctl,
+	.mmap =			kdbus_handle_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =		kdbus_handle_ioctl,
+#endif
+};
diff --git a/drivers/misc/kdbus/handle.h b/drivers/misc/kdbus/handle.h
new file mode 100644
index 000000000000..0e8e9a50aeb1
--- /dev/null
+++ b/drivers/misc/kdbus/handle.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_HANDLE_H
+#define __KDBUS_HANDLE_H
+
+struct kdbus_domain;
+struct kdbus_ep;
+
+extern const struct file_operations kdbus_handle_ops;
+
+enum kdbus_minor_type {
+	KDBUS_MINOR_CONTROL,
+	KDBUS_MINOR_EP,
+	KDBUS_MINOR_CNT
+};
+
+int kdbus_minor_init(void);
+void kdbus_minor_exit(void);
+int kdbus_minor_alloc(enum kdbus_minor_type type, void *ptr, dev_t *out);
+void kdbus_minor_free(dev_t devt);
+void kdbus_minor_set(dev_t devt, enum kdbus_minor_type type, void *ptr);
+
+/* type-safe kdbus_minor_set() */
+static inline void kdbus_minor_set_control(dev_t devt, struct kdbus_domain *d)
+{
+	kdbus_minor_set(devt, KDBUS_MINOR_CONTROL, d);
+}
+
+/* type-safe kdbus_minor_set() */
+static inline void kdbus_minor_set_ep(dev_t devt, struct kdbus_ep *e)
+{
+	kdbus_minor_set(devt, KDBUS_MINOR_EP, e);
+}
+
+#endif
diff --git a/drivers/misc/kdbus/limits.h b/drivers/misc/kdbus/limits.h
new file mode 100644
index 000000000000..29cf30fcce07
--- /dev/null
+++ b/drivers/misc/kdbus/limits.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_DEFAULTS_H
+#define __KDBUS_DEFAULTS_H
+
+/* maximum size of message header and items */
+#define KDBUS_MSG_MAX_SIZE		SZ_8K
+
+/* maximum number of message items */
+#define KDBUS_MSG_MAX_ITEMS		128
+
+/*
+ * Maximum number of passed file descriptors
+ * Number taken from AF_UNIX upper limits
+ */
+#define KDBUS_MSG_MAX_FDS		253
+
+/* maximum message payload size */
+#define KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE		SZ_2M
+
+/* maximum size of bloom bit field in bytes */
+#define KDBUS_BUS_BLOOM_MAX_SIZE		SZ_4K
+
+/* maximum length of well-known bus name */
+#define KDBUS_NAME_MAX_LEN			255
+
+/* maximum length of bus, domain, ep name */
+#define KDBUS_SYSNAME_MAX_LEN			63
+
+/* maximum size of make data */
+#define KDBUS_MAKE_MAX_SIZE			SZ_32K
+
+/* maximum size of hello data */
+#define KDBUS_HELLO_MAX_SIZE			SZ_32K
+
+/* maximum size for update commands */
+#define KDBUS_UPDATE_MAX_SIZE			SZ_32K
+
+/* maximum number of matches per connection */
+#define KDBUS_MATCH_MAX				256
+
+/* maximum size of match data */
+#define KDBUS_MATCH_MAX_SIZE			SZ_32K
+
+/* maximum size of policy data */
+#define KDBUS_POLICY_MAX_SIZE			SZ_32K
+
+/* maximum number of queued messages in a connection */
+#define KDBUS_CONN_MAX_MSGS			256
+
+/* maximum number of queued messages from the same indvidual user */
+#define KDBUS_CONN_MAX_MSGS_PER_USER		16
+
+/* maximum number of well-known names per connection */
+#define KDBUS_CONN_MAX_NAMES			64
+
+/* maximum number of queued requests waiting for a reply */
+#define KDBUS_CONN_MAX_REQUESTS_PENDING		128
+
+/* maximum number of connections per user in one domain */
+#define KDBUS_USER_MAX_CONN			256
+
+/* maximum number of buses per user in one domain */
+#define KDBUS_USER_MAX_BUSES			16
+
+#endif
diff --git a/drivers/misc/kdbus/main.c b/drivers/misc/kdbus/main.c
new file mode 100644
index 000000000000..caa4aabc1d8d
--- /dev/null
+++ b/drivers/misc/kdbus/main.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include "util.h"
+#include "domain.h"
+#include "handle.h"
+
+/* kdbus initial domain */
+static struct kdbus_domain *kdbus_domain_init;
+
+static int __init kdbus_init(void)
+{
+	int ret;
+
+	ret = subsys_virtual_register(&kdbus_subsys, NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = kdbus_minor_init();
+	if (ret < 0)
+		goto exit_subsys;
+
+	/*
+	 * Create the initial domain; it is world-accessible and
+	 * provides the /dev/kdbus/control device node.
+	 */
+	ret = kdbus_domain_new(NULL, NULL, 0666, &kdbus_domain_init);
+	if (ret < 0) {
+		pr_err("failed to initialize, error=%i\n", ret);
+		goto exit_minor;
+	}
+
+	pr_info("initialized\n");
+	return 0;
+
+exit_minor:
+	kdbus_minor_exit();
+exit_subsys:
+	bus_unregister(&kdbus_subsys);
+	return ret;
+}
+
+static void __exit kdbus_exit(void)
+{
+	kdbus_domain_disconnect(kdbus_domain_init);
+	kdbus_domain_unref(kdbus_domain_init);
+	kdbus_minor_exit();
+	bus_unregister(&kdbus_subsys);
+}
+
+module_init(kdbus_init);
+module_exit(kdbus_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("D-Bus, powerful, easy to use interprocess communication");
diff --git a/drivers/misc/kdbus/util.c b/drivers/misc/kdbus/util.c
new file mode 100644
index 000000000000..8241e15c6ef5
--- /dev/null
+++ b/drivers/misc/kdbus/util.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/ctype.h>
+#include <linux/file.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "limits.h"
+#include "util.h"
+
+/**
+ * kdbus_sysname_valid() - validate names showing up in /proc, /sys and /dev
+ * @name:		Name of domain, bus, endpoint
+ *
+ * Return: 0 if the given name is valid, otherwise negative errno
+ */
+int kdbus_sysname_is_valid(const char *name)
+{
+	unsigned int i;
+	size_t len;
+
+	len = strlen(name);
+	if (len == 0)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		if (isalpha(name[i]))
+			continue;
+		if (isdigit(name[i]))
+			continue;
+		if (name[i] == '_')
+			continue;
+		if (i > 0 && i + 1 < len && strchr("-.", name[i]))
+			continue;
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * kdbus_check_and_write_flags() - check flags provided by user, and write the
+ *				   valid mask back
+ * @flags:	The flags mask provided by userspace
+ * @buf:	The buffer provided by userspace
+ * @offset_out:	Offset of the kernel_flags field inside the user-provided struct
+ * @valid:	Mask of valid bits
+ *
+ * This function will check whether the flags provided by userspace are within
+ * the combination of allowed bits to the kernel, with the KDBUS_FLAGS_KERNEL
+ * bit set in the return buffer.
+ *
+ * Return: 0 on success, -EFAULT if copy_to_user() failed, or -EINVAL if
+ * userspace submitted invalid bits in its mask.
+ */
+int kdbus_check_and_write_flags(u64 flags, void __user *buf,
+			  off_t offset_out, u64 valid)
+{
+	u64 val = valid | KDBUS_FLAG_KERNEL;
+
+	/*
+	 * KDBUS_FLAG_KERNEL is reserved and will never be considered
+	 * valid by any user of this function.
+	 */
+	WARN_ON_ONCE(valid & KDBUS_FLAG_KERNEL);
+
+	if (copy_to_user(((u8 __user *) buf) + offset_out, &val, sizeof(val)))
+		return -EFAULT;
+
+	if (flags & ~valid)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * kdbus_fput_files() - fput() an array of struct files
+ * @files:	The array of files to put, may be NULL
+ * @count:	The number of elements in @files
+ *
+ * Call fput() on all non-NULL elements in @files, and set the entries to
+ * NULL afterwards.
+ */
+void kdbus_fput_files(struct file **files, unsigned int count)
+{
+	int i;
+
+	if (!files)
+		return;
+
+	for (i = count - 1; i >= 0; i--)
+		if (files[i]) {
+			fput(files[i]);
+			files[i] = NULL;
+		}
+}
diff --git a/drivers/misc/kdbus/util.h b/drivers/misc/kdbus/util.h
new file mode 100644
index 000000000000..d84b820d2132
--- /dev/null
+++ b/drivers/misc/kdbus/util.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_UTIL_H
+#define __KDBUS_UTIL_H
+
+#include <linux/dcache.h>
+#include <linux/ioctl.h>
+
+#include "kdbus.h"
+
+/* all exported addresses are 64 bit */
+#define KDBUS_PTR(addr) ((void __user *)(uintptr_t)(addr))
+
+/* all exported sizes are 64 bit and data aligned to 64 bit */
+#define KDBUS_ALIGN8(s) ALIGN((s), 8)
+#define KDBUS_IS_ALIGNED8(s) (IS_ALIGNED(s, 8))
+
+/**
+ * kdbus_size_get_user - read the size variable from user memory
+ * @_s:			Size variable
+ * @_b:			Buffer to read from
+ * @_t:			Structure, "size" is a member of
+ *
+ * Return: the result of copy_from_user()
+ */
+#define kdbus_size_get_user(_s, _b, _t)					\
+({									\
+	u64 __user *_sz =						\
+		(void __user *)((u8 __user *)(_b) + offsetof(_t, size));\
+	copy_from_user(_s, _sz, sizeof(__u64));				\
+})
+
+/**
+ * kdbus_offset_set_user - write the offset variable to user memory
+ * @_s:			Offset variable
+ * @_b:			Buffer to write to
+ * @_t:			Structure, "offset" is a member of
+ *
+ * Return: the result of copy_to_user()
+ */
+#define kdbus_offset_set_user(_s, _b, _t)				\
+({									\
+	u64 __user *_sz =						\
+		(void __user *)((u8 __user *)(_b) + offsetof(_t, offset)); \
+	copy_to_user(_sz, _s, sizeof(__u64));				\
+})
+
+/**
+ * kdbus_str_hash - calculate a hash
+ * @str:		String
+ *
+ * Return: hash value
+ */
+static inline unsigned int kdbus_str_hash(const char *str)
+{
+	return full_name_hash(str, strlen(str));
+}
+
+/**
+ * kdbus_str_valid - verify a string
+ * @str:		String to verify
+ * @size:		Size of buffer of string (including 0-byte)
+ *
+ * This verifies the string at position @str with size @size is properly
+ * zero-terminated and does not contain a 0-byte but at the end.
+ *
+ * Return: true if string is valid, false if not.
+ */
+static inline bool kdbus_str_valid(const char *str, size_t size)
+{
+	return size > 0 && memchr(str, '\0', size) == str + size - 1;
+}
+
+int kdbus_sysname_is_valid(const char *name);
+void kdbus_fput_files(struct file **files, unsigned int count);
+int kdbus_check_and_write_flags(u64 flags, void __user *buf,
+				off_t offset_out, u64 valid);
+
+#define kdbus_negotiate_flags(_s, _b, _t, _v)				\
+	kdbus_check_and_write_flags((_s)->flags, _b,			\
+				    offsetof(_t, kernel_flags), _v)	\
+
+#endif
-- 
2.1.2
