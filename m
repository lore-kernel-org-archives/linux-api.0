From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 03/14] kdbus: add driver skeleton, ioctl entry points and utility functions
Date: Mon,  9 Mar 2015 14:09:09 +0100
Message-ID: <1425906560-13798-4-git-send-email-gregkh@linuxfoundation.org>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425906560-13798-1-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>

Add the basic driver structure.

handle.c is the main ioctl command dispatcher that calls into other par=
ts
of the driver.

main.c contains the code that creates the initial domain at startup, an=
d
util.c has utility functions such as item iterators that are shared wit=
h
other files.

limits.h describes limits on things like maximum data structure sizes,
number of messages per users and suchlike. Some of the numbers currentl=
y
picked are rough ideas of what what might be sufficient and are probabl=
y
rather conservative.

Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 Documentation/ioctl/ioctl-number.txt |   1 +
 ipc/kdbus/handle.c                   | 617 +++++++++++++++++++++++++++=
++++++++
 ipc/kdbus/handle.h                   |  85 +++++
 ipc/kdbus/limits.h                   |  64 ++++
 ipc/kdbus/main.c                     | 125 +++++++
 ipc/kdbus/util.c                     | 201 ++++++++++++
 ipc/kdbus/util.h                     |  74 +++++
 7 files changed, 1167 insertions(+)
 create mode 100644 ipc/kdbus/handle.c
 create mode 100644 ipc/kdbus/handle.h
 create mode 100644 ipc/kdbus/limits.h
 create mode 100644 ipc/kdbus/main.c
 create mode 100644 ipc/kdbus/util.c
 create mode 100644 ipc/kdbus/util.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl=
/ioctl-number.txt
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
 					<mailto:buk-KMFVLCTwZAcb1SvskN2V4Q@public.gmane.org>
diff --git a/ipc/kdbus/handle.c b/ipc/kdbus/handle.c
new file mode 100644
index 000000000000..f72dbe513b4a
--- /dev/null
+++ b/ipc/kdbus/handle.c
@@ -0,0 +1,617 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Greg Kroah-Hartman <gregkh@linuxfoundation.=
org>
+ * Copyright (C) 2013-2015 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2015 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2015 Linux Foundation
+ * Copyright (C) 2014-2015 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/kdev_t.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+
+#include "bus.h"
+#include "connection.h"
+#include "endpoint.h"
+#include "fs.h"
+#include "handle.h"
+#include "item.h"
+#include "match.h"
+#include "message.h"
+#include "names.h"
+#include "domain.h"
+#include "policy.h"
+
+static int kdbus_args_verify(struct kdbus_args *args)
+{
+	struct kdbus_item *item;
+	size_t i;
+	int ret;
+
+	KDBUS_ITEMS_FOREACH(item, args->items, args->items_size) {
+		struct kdbus_arg *arg =3D NULL;
+
+		if (!KDBUS_ITEM_VALID(item, args->items, args->items_size))
+			return -EINVAL;
+
+		for (i =3D 0; i < args->argc; ++i)
+			if (args->argv[i].type =3D=3D item->type)
+				break;
+		if (i >=3D args->argc)
+			return -EINVAL;
+
+		arg =3D &args->argv[i];
+
+		ret =3D kdbus_item_validate(item);
+		if (ret < 0)
+			return ret;
+
+		if (arg->item && !arg->multiple)
+			return -EINVAL;
+
+		arg->item =3D item;
+	}
+
+	if (!KDBUS_ITEMS_END(item, args->items, args->items_size))
+		return -EINVAL;
+
+	for (i =3D 0; i < args->argc; ++i)
+		if (args->argv[i].mandatory && !args->argv[i].item)
+			return -EINVAL;
+
+	return 0;
+}
+
+static int kdbus_args_negotiate(struct kdbus_args *args)
+{
+	struct kdbus_item __user *user;
+	struct kdbus_item *negotiation;
+	size_t i, j, num;
+
+	/*
+	 * If KDBUS_FLAG_NEGOTIATE is set, we overwrite the flags field with
+	 * the set of supported flags. Furthermore, if an KDBUS_ITEM_NEGOTIAT=
E
+	 * item is passed, we iterate its payload (array of u64, each set to =
an
+	 * item type) and clear all unsupported item-types to 0.
+	 * The caller might do this recursively, if other flags or objects ar=
e
+	 * embedded in the payload itself.
+	 */
+
+	if (args->cmd->flags & KDBUS_FLAG_NEGOTIATE) {
+		if (put_user(args->allowed_flags & ~KDBUS_FLAG_NEGOTIATE,
+			     &args->user->flags))
+			return -EFAULT;
+	}
+
+	if (args->argc < 1 || args->argv[0].type !=3D KDBUS_ITEM_NEGOTIATE ||
+	    !args->argv[0].item)
+		return 0;
+
+	negotiation =3D args->argv[0].item;
+	user =3D (struct kdbus_item __user *)
+		((u8 __user *)args->user +
+		 ((u8 *)negotiation - (u8 *)args->cmd));
+	num =3D KDBUS_ITEM_PAYLOAD_SIZE(negotiation) / sizeof(u64);
+
+	for (i =3D 0; i < num; ++i) {
+		for (j =3D 0; j < args->argc; ++j)
+			if (negotiation->data64[i] =3D=3D args->argv[j].type)
+				break;
+
+		if (j < args->argc)
+			continue;
+
+		/* this item is not supported, clear it out */
+		negotiation->data64[i] =3D 0;
+		if (put_user(negotiation->data64[i], &user->data64[i]))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ * __kdbus_args_parse() - parse payload of kdbus command
+ * @args:		object to parse data into
+ * @argp:		user-space location of command payload to parse
+ * @type_size:		overall size of command payload to parse
+ * @items_offset:	offset of items array in command payload
+ * @out:		output variable to store pointer to copied payload
+ *
+ * This parses the ioctl payload at user-space location @argp into @ar=
gs. @args
+ * must be pre-initialized by the caller to reflect the supported flag=
s and
+ * items of this command. This parser will then copy the command paylo=
ad into
+ * kernel-space, verify correctness and consistency and cache pointers=
 to parsed
+ * items and other data in @args.
+ *
+ * If this function succeeded, you must call kdbus_args_clear() to rel=
ease
+ * allocated resources before destroying @args.
+ *
+ * Return: On failure a negative error code is returned. Otherwise, 1 =
is
+ * returned if negotiation was requested, 0 if not.
+ */
+int __kdbus_args_parse(struct kdbus_args *args, void __user *argp,
+		       size_t type_size, size_t items_offset, void **out)
+{
+	int ret;
+
+	args->cmd =3D kdbus_memdup_user(argp, type_size, KDBUS_CMD_MAX_SIZE);
+	if (IS_ERR(args->cmd))
+		return PTR_ERR(args->cmd);
+
+	args->cmd->return_flags =3D 0;
+	args->user =3D argp;
+	args->items =3D (void *)((u8 *)args->cmd + items_offset);
+	args->items_size =3D args->cmd->size - items_offset;
+
+	if (args->cmd->flags & ~args->allowed_flags) {
+		ret =3D -EINVAL;
+		goto error;
+	}
+
+	ret =3D kdbus_args_verify(args);
+	if (ret < 0)
+		goto error;
+
+	ret =3D kdbus_args_negotiate(args);
+	if (ret < 0)
+		goto error;
+
+	*out =3D args->cmd;
+	return !!(args->cmd->flags & KDBUS_FLAG_NEGOTIATE);
+
+error:
+	return kdbus_args_clear(args, ret);
+}
+
+/**
+ * kdbus_args_clear() - release allocated command resources
+ * @args:	object to release resources of
+ * @ret:	return value of this command
+ *
+ * This frees all allocated resources on @args and copies the command =
result
+ * flags into user-space. @ret is usually returned unchanged by this f=
unction,
+ * so it can be used in the final 'return' statement of the command ha=
ndler.
+ *
+ * Return: -EFAULT if return values cannot be copied into user-space, =
otherwise
+ *         @ret is returned unchanged.
+ */
+int kdbus_args_clear(struct kdbus_args *args, int ret)
+{
+	if (!args)
+		return ret;
+
+	if (!IS_ERR_OR_NULL(args->cmd)) {
+		if (put_user(args->cmd->return_flags,
+			     &args->user->return_flags))
+			ret =3D -EFAULT;
+		kfree(args->cmd);
+		args->cmd =3D NULL;
+	}
+
+	return ret;
+}
+
+/**
+ * enum kdbus_handle_type - type an handle can be of
+ * @KDBUS_HANDLE_NONE:		no type set, yet
+ * @KDBUS_HANDLE_BUS_OWNER:	bus owner
+ * @KDBUS_HANDLE_EP_OWNER:	endpoint owner
+ * @KDBUS_HANDLE_CONNECTED:	endpoint connection after HELLO
+ */
+enum kdbus_handle_type {
+	KDBUS_HANDLE_NONE,
+	KDBUS_HANDLE_BUS_OWNER,
+	KDBUS_HANDLE_EP_OWNER,
+	KDBUS_HANDLE_CONNECTED,
+};
+
+/**
+ * struct kdbus_handle - handle to the kdbus system
+ * @rwlock:		handle lock
+ * @type:		type of this handle (KDBUS_HANDLE_*)
+ * @bus_owner:		bus this handle owns
+ * @ep_owner:		endpoint this handle owns
+ * @conn:		connection this handle owns
+ * @privileged:		Flag to mark a handle as privileged
+ */
+struct kdbus_handle {
+	struct rw_semaphore rwlock;
+
+	enum kdbus_handle_type type;
+	union {
+		struct kdbus_bus *bus_owner;
+		struct kdbus_ep *ep_owner;
+		struct kdbus_conn *conn;
+	};
+
+	bool privileged:1;
+};
+
+static int kdbus_handle_open(struct inode *inode, struct file *file)
+{
+	struct kdbus_handle *handle;
+	struct kdbus_node *node;
+	int ret;
+
+	node =3D kdbus_node_from_inode(inode);
+	if (!kdbus_node_acquire(node))
+		return -ESHUTDOWN;
+
+	handle =3D kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle) {
+		ret =3D -ENOMEM;
+		goto exit;
+	}
+
+	init_rwsem(&handle->rwlock);
+	handle->type =3D KDBUS_HANDLE_NONE;
+
+	if (node->type =3D=3D KDBUS_NODE_ENDPOINT) {
+		struct kdbus_ep *ep =3D kdbus_ep_from_node(node);
+		struct kdbus_bus *bus =3D ep->bus;
+
+		/*
+		 * A connection is privileged if it is opened on an endpoint
+		 * without custom policy and either:
+		 *   * the user has CAP_IPC_OWNER in the domain user namespace
+		 * or
+		 *   * the callers euid matches the uid of the bus creator
+		 */
+		if (!ep->user &&
+		    (ns_capable(bus->domain->user_namespace, CAP_IPC_OWNER) ||
+		     uid_eq(file->f_cred->euid, bus->node.uid)))
+			handle->privileged =3D true;
+	}
+
+	file->private_data =3D handle;
+	ret =3D 0;
+
+exit:
+	kdbus_node_release(node);
+	return ret;
+}
+
+static int kdbus_handle_release(struct inode *inode, struct file *file=
)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+
+	switch (handle->type) {
+	case KDBUS_HANDLE_BUS_OWNER:
+		if (handle->bus_owner) {
+			kdbus_node_deactivate(&handle->bus_owner->node);
+			kdbus_bus_unref(handle->bus_owner);
+		}
+		break;
+	case KDBUS_HANDLE_EP_OWNER:
+		if (handle->ep_owner) {
+			kdbus_node_deactivate(&handle->ep_owner->node);
+			kdbus_ep_unref(handle->ep_owner);
+		}
+		break;
+	case KDBUS_HANDLE_CONNECTED:
+		kdbus_conn_disconnect(handle->conn, false);
+		kdbus_conn_unref(handle->conn);
+		break;
+	case KDBUS_HANDLE_NONE:
+		/* nothing to clean up */
+		break;
+	}
+
+	kfree(handle);
+
+	return 0;
+}
+
+static long kdbus_handle_ioctl_control(struct file *file, unsigned int=
 cmd,
+				       void __user *argp)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	struct kdbus_node *node =3D file_inode(file)->i_private;
+	struct kdbus_domain *domain;
+	int ret =3D 0;
+
+	if (!kdbus_node_acquire(node))
+		return -ESHUTDOWN;
+
+	/*
+	 * The parent of control-nodes is always a domain, make sure to pin i=
t
+	 * so the parent is actually valid.
+	 */
+	domain =3D kdbus_domain_from_node(node->parent);
+	if (!kdbus_node_acquire(&domain->node)) {
+		kdbus_node_release(node);
+		return -ESHUTDOWN;
+	}
+
+	switch (cmd) {
+	case KDBUS_CMD_BUS_MAKE: {
+		struct kdbus_bus *bus;
+
+		bus =3D kdbus_cmd_bus_make(domain, argp);
+		if (IS_ERR_OR_NULL(bus)) {
+			ret =3D PTR_ERR_OR_ZERO(bus);
+			break;
+		}
+
+		handle->type =3D KDBUS_HANDLE_BUS_OWNER;
+		handle->bus_owner =3D bus;
+		break;
+	}
+
+	default:
+		ret =3D -EBADFD;
+		break;
+	}
+
+	kdbus_node_release(&domain->node);
+	kdbus_node_release(node);
+	return ret;
+}
+
+static long kdbus_handle_ioctl_ep(struct file *file, unsigned int cmd,
+				  void __user *buf)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	struct kdbus_node *node =3D file_inode(file)->i_private;
+	struct kdbus_ep *ep, *file_ep =3D kdbus_ep_from_node(node);
+	struct kdbus_conn *conn;
+	int ret =3D 0;
+
+	if (!kdbus_node_acquire(node))
+		return -ESHUTDOWN;
+
+	switch (cmd) {
+	case KDBUS_CMD_ENDPOINT_MAKE:
+		/* creating custom endpoints is a privileged operation */
+		if (!handle->privileged) {
+			ret =3D -EPERM;
+			break;
+		}
+
+		ep =3D kdbus_cmd_ep_make(file_ep->bus, buf);
+		if (IS_ERR_OR_NULL(ep)) {
+			ret =3D PTR_ERR_OR_ZERO(ep);
+			break;
+		}
+
+		handle->type =3D KDBUS_HANDLE_EP_OWNER;
+		handle->ep_owner =3D ep;
+		break;
+
+	case KDBUS_CMD_HELLO:
+		conn =3D kdbus_cmd_hello(file_ep, handle->privileged, buf);
+		if (IS_ERR_OR_NULL(conn)) {
+			ret =3D PTR_ERR_OR_ZERO(conn);
+			break;
+		}
+
+		handle->type =3D KDBUS_HANDLE_CONNECTED;
+		handle->conn =3D conn;
+		break;
+
+	default:
+		ret =3D -EBADFD;
+		break;
+	}
+
+	kdbus_node_release(node);
+	return ret;
+}
+
+static long kdbus_handle_ioctl_ep_owner(struct file *file, unsigned in=
t command,
+					void __user *buf)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	struct kdbus_ep *ep =3D handle->ep_owner;
+	int ret;
+
+	if (!kdbus_node_acquire(&ep->node))
+		return -ESHUTDOWN;
+
+	switch (command) {
+	case KDBUS_CMD_ENDPOINT_UPDATE:
+		ret =3D kdbus_cmd_ep_update(ep, buf);
+		break;
+	default:
+		ret =3D -EBADFD;
+		break;
+	}
+
+	kdbus_node_release(&ep->node);
+	return ret;
+}
+
+static long kdbus_handle_ioctl_connected(struct file *file,
+					 unsigned int command, void __user *buf)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	struct kdbus_conn *conn =3D handle->conn;
+	struct kdbus_conn *release_conn =3D NULL;
+	int ret;
+
+	release_conn =3D conn;
+	ret =3D kdbus_conn_acquire(release_conn);
+	if (ret < 0)
+		return ret;
+
+	switch (command) {
+	case KDBUS_CMD_BYEBYE:
+		/*
+		 * BYEBYE is special; we must not acquire a connection when
+		 * calling into kdbus_conn_disconnect() or we will deadlock,
+		 * because kdbus_conn_disconnect() will wait for all acquired
+		 * references to be dropped.
+		 */
+		kdbus_conn_release(release_conn);
+		release_conn =3D NULL;
+		ret =3D kdbus_cmd_byebye_unlocked(conn, buf);
+		break;
+	case KDBUS_CMD_NAME_ACQUIRE:
+		ret =3D kdbus_cmd_name_acquire(conn, buf);
+		break;
+	case KDBUS_CMD_NAME_RELEASE:
+		ret =3D kdbus_cmd_name_release(conn, buf);
+		break;
+	case KDBUS_CMD_LIST:
+		ret =3D kdbus_cmd_list(conn, buf);
+		break;
+	case KDBUS_CMD_CONN_INFO:
+		ret =3D kdbus_cmd_conn_info(conn, buf);
+		break;
+	case KDBUS_CMD_BUS_CREATOR_INFO:
+		ret =3D kdbus_cmd_bus_creator_info(conn, buf);
+		break;
+	case KDBUS_CMD_UPDATE:
+		ret =3D kdbus_cmd_update(conn, buf);
+		break;
+	case KDBUS_CMD_MATCH_ADD:
+		ret =3D kdbus_cmd_match_add(conn, buf);
+		break;
+	case KDBUS_CMD_MATCH_REMOVE:
+		ret =3D kdbus_cmd_match_remove(conn, buf);
+		break;
+	case KDBUS_CMD_SEND:
+		ret =3D kdbus_cmd_send(conn, file, buf);
+		break;
+	case KDBUS_CMD_RECV:
+		ret =3D kdbus_cmd_recv(conn, buf);
+		break;
+	case KDBUS_CMD_FREE:
+		ret =3D kdbus_cmd_free(conn, buf);
+		break;
+	default:
+		ret =3D -EBADFD;
+		break;
+	}
+
+	kdbus_conn_release(release_conn);
+	return ret;
+}
+
+static long kdbus_handle_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	struct kdbus_node *node =3D kdbus_node_from_inode(file_inode(file));
+	void __user *argp =3D (void __user *)arg;
+	long ret =3D -EBADFD;
+
+	switch (cmd) {
+	case KDBUS_CMD_BUS_MAKE:
+	case KDBUS_CMD_ENDPOINT_MAKE:
+	case KDBUS_CMD_HELLO:
+		/* bail out early if already typed */
+		if (handle->type !=3D KDBUS_HANDLE_NONE)
+			break;
+
+		down_write(&handle->rwlock);
+		if (handle->type =3D=3D KDBUS_HANDLE_NONE) {
+			if (node->type =3D=3D KDBUS_NODE_CONTROL)
+				ret =3D kdbus_handle_ioctl_control(file, cmd,
+								 argp);
+			else if (node->type =3D=3D KDBUS_NODE_ENDPOINT)
+				ret =3D kdbus_handle_ioctl_ep(file, cmd, argp);
+		}
+		up_write(&handle->rwlock);
+		break;
+
+	case KDBUS_CMD_ENDPOINT_UPDATE:
+	case KDBUS_CMD_BYEBYE:
+	case KDBUS_CMD_NAME_ACQUIRE:
+	case KDBUS_CMD_NAME_RELEASE:
+	case KDBUS_CMD_LIST:
+	case KDBUS_CMD_CONN_INFO:
+	case KDBUS_CMD_BUS_CREATOR_INFO:
+	case KDBUS_CMD_UPDATE:
+	case KDBUS_CMD_MATCH_ADD:
+	case KDBUS_CMD_MATCH_REMOVE:
+	case KDBUS_CMD_SEND:
+	case KDBUS_CMD_RECV:
+	case KDBUS_CMD_FREE:
+		down_read(&handle->rwlock);
+		if (handle->type =3D=3D KDBUS_HANDLE_EP_OWNER)
+			ret =3D kdbus_handle_ioctl_ep_owner(file, cmd, argp);
+		else if (handle->type =3D=3D KDBUS_HANDLE_CONNECTED)
+			ret =3D kdbus_handle_ioctl_connected(file, cmd, argp);
+		up_read(&handle->rwlock);
+		break;
+	default:
+		ret =3D -ENOTTY;
+		break;
+	}
+
+	return ret < 0 ? ret : 0;
+}
+
+static unsigned int kdbus_handle_poll(struct file *file,
+				      struct poll_table_struct *wait)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	unsigned int mask =3D POLLOUT | POLLWRNORM;
+	int ret;
+
+	/* Only a connected endpoint can read/write data */
+	down_read(&handle->rwlock);
+	if (handle->type !=3D KDBUS_HANDLE_CONNECTED) {
+		up_read(&handle->rwlock);
+		return POLLERR | POLLHUP;
+	}
+	up_read(&handle->rwlock);
+
+	ret =3D kdbus_conn_acquire(handle->conn);
+	if (ret < 0)
+		return POLLERR | POLLHUP;
+
+	poll_wait(file, &handle->conn->wait, wait);
+
+	if (!list_empty(&handle->conn->queue.msg_list) ||
+	    atomic_read(&handle->conn->lost_count) > 0)
+		mask |=3D POLLIN | POLLRDNORM;
+
+	kdbus_conn_release(handle->conn);
+
+	return mask;
+}
+
+static int kdbus_handle_mmap(struct file *file, struct vm_area_struct =
*vma)
+{
+	struct kdbus_handle *handle =3D file->private_data;
+	int ret =3D -EBADFD;
+
+	if (down_read_trylock(&handle->rwlock)) {
+		if (handle->type =3D=3D KDBUS_HANDLE_CONNECTED)
+			ret =3D kdbus_pool_mmap(handle->conn->pool, vma);
+		up_read(&handle->rwlock);
+	}
+	return ret;
+}
+
+const struct file_operations kdbus_handle_ops =3D {
+	.owner =3D		THIS_MODULE,
+	.open =3D			kdbus_handle_open,
+	.release =3D		kdbus_handle_release,
+	.poll =3D			kdbus_handle_poll,
+	.llseek =3D		noop_llseek,
+	.unlocked_ioctl =3D	kdbus_handle_ioctl,
+	.mmap =3D			kdbus_handle_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =3D		kdbus_handle_ioctl,
+#endif
+};
diff --git a/ipc/kdbus/handle.h b/ipc/kdbus/handle.h
new file mode 100644
index 000000000000..93a372d554a2
--- /dev/null
+++ b/ipc/kdbus/handle.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Greg Kroah-Hartman <gregkh@linuxfoundation.=
org>
+ * Copyright (C) 2013-2015 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2015 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2015 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_HANDLE_H
+#define __KDBUS_HANDLE_H
+
+#include <linux/fs.h>
+#include <uapi/linux/kdbus.h>
+
+extern const struct file_operations kdbus_handle_ops;
+
+/**
+ * kdbus_arg - information and state of a single ioctl command item
+ * @type:		item type
+ * @item:		set by the parser to the first found item of this type
+ * @multiple:		whether multiple items of this type are allowed
+ * @mandatory:		whether at least one item of this type is required
+ *
+ * This structure describes a single item in an ioctl command payload.=
 The
+ * caller has to pre-fill the type and flags, the parser will then use=
 this
+ * information to verify the ioctl payload. @item is set by the parser=
 to point
+ * to the first occurrence of the item.
+ */
+struct kdbus_arg {
+	u64 type;
+	struct kdbus_item *item;
+	bool multiple : 1;
+	bool mandatory : 1;
+};
+
+/**
+ * kdbus_args - information and state of ioctl command parser
+ * @allowed_flags:	set of flags this command supports
+ * @argc:		number of items in @argv
+ * @argv:		array of items this command supports
+ * @user:		set by parser to user-space location of current command
+ * @cmd:		set by parser to kernel copy of command payload
+ * @items:		points to item array in @cmd
+ * @items_size:		size of @items in bytes
+ *
+ * This structure is used to parse ioctl command payloads on each invo=
cation.
+ * The ioctl handler has to pre-fill the flags and allowed items befor=
e passing
+ * the object to kdbus_args_parse(). The parser will copy the command =
payload
+ * into kernel-space and verify the correctness of the data.
+ */
+struct kdbus_args {
+	u64 allowed_flags;
+	size_t argc;
+	struct kdbus_arg *argv;
+
+	struct kdbus_cmd __user *user;
+	struct kdbus_cmd *cmd;
+
+	struct kdbus_item *items;
+	size_t items_size;
+};
+
+int __kdbus_args_parse(struct kdbus_args *args, void __user *argp,
+		       size_t type_size, size_t items_offset, void **out);
+int kdbus_args_clear(struct kdbus_args *args, int ret);
+
+#define kdbus_args_parse(_args, _argp, _v)                            =
  \
+	({                                                              \
+		BUILD_BUG_ON(offsetof(typeof(**(_v)), size) !=3D          \
+			     offsetof(struct kdbus_cmd, size));         \
+		BUILD_BUG_ON(offsetof(typeof(**(_v)), flags) !=3D         \
+			     offsetof(struct kdbus_cmd, flags));        \
+		BUILD_BUG_ON(offsetof(typeof(**(_v)), return_flags) !=3D  \
+			     offsetof(struct kdbus_cmd, return_flags)); \
+		__kdbus_args_parse((_args), (_argp), sizeof(**(_v)),    \
+				   offsetof(typeof(**(_v)), items),     \
+				   (void **)(_v));                      \
+	})
+
+#endif
diff --git a/ipc/kdbus/limits.h b/ipc/kdbus/limits.h
new file mode 100644
index 000000000000..6450f58cffcf
--- /dev/null
+++ b/ipc/kdbus/limits.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Greg Kroah-Hartman <gregkh@linuxfoundation.=
org>
+ * Copyright (C) 2013-2015 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2015 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2015 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_DEFAULTS_H
+#define __KDBUS_DEFAULTS_H
+
+#include <linux/kernel.h>
+
+/* maximum size of message header and items */
+#define KDBUS_MSG_MAX_SIZE		SZ_8K
+
+/* maximum number of message items */
+#define KDBUS_MSG_MAX_ITEMS		128
+
+/* maximum number of memfd items per message */
+#define KDBUS_MSG_MAX_MEMFD_ITEMS	16
+
+/* max size of ioctl command data */
+#define KDBUS_CMD_MAX_SIZE		SZ_32K
+
+/* maximum number of inflight fds in a target queue per user */
+#define KDBUS_CONN_MAX_FDS_PER_USER	16
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
+/* maximum number of matches per connection */
+#define KDBUS_MATCH_MAX				256
+
+/* maximum number of queued messages from the same individual user */
+#define KDBUS_CONN_MAX_MSGS			256
+
+/* maximum number of well-known names per connection */
+#define KDBUS_CONN_MAX_NAMES			256
+
+/* maximum number of queued requests waiting for a reply */
+#define KDBUS_CONN_MAX_REQUESTS_PENDING		128
+
+/* maximum number of connections per user in one domain */
+#define KDBUS_USER_MAX_CONN			1024
+
+/* maximum number of buses per user in one domain */
+#define KDBUS_USER_MAX_BUSES			16
+
+#endif
diff --git a/ipc/kdbus/main.c b/ipc/kdbus/main.c
new file mode 100644
index 000000000000..785f529d98b7
--- /dev/null
+++ b/ipc/kdbus/main.c
@@ -0,0 +1,125 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Greg Kroah-Hartman <gregkh@linuxfoundation.=
org>
+ * Copyright (C) 2013-2015 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2015 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2015 Linux Foundation
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+
+#include "util.h"
+#include "fs.h"
+#include "handle.h"
+#include "metadata.h"
+#include "node.h"
+
+/*
+ * This is a simplified outline of the internal kdbus object relations=
, for
+ * those interested in the inner life of the driver implementation.
+ *
+ * From a mount point's (domain's) perspective:
+ *
+ * struct kdbus_domain
+ *   |=C2=BB struct kdbus_user *user (many, owned)
+ *   '=C2=BB struct kdbus_node node (embedded)
+ *       |=C2=BB struct kdbus_node children (many, referenced)
+ *       |=C2=BB struct kdbus_node *parent (pinned)
+ *       '=C2=BB struct kdbus_bus (many, pinned)
+ *           |=C2=BB struct kdbus_node node (embedded)
+ *           '=C2=BB struct kdbus_ep (many, pinned)
+ *               |=C2=BB struct kdbus_node node (embedded)
+ *               |=C2=BB struct kdbus_bus *bus (pinned)
+ *               |=C2=BB struct kdbus_conn conn_list (many, pinned)
+ *               |   |=C2=BB struct kdbus_ep *ep (pinned)
+ *               |   |=C2=BB struct kdbus_name_entry *activator_of (ow=
ned)
+ *               |   |=C2=BB struct kdbus_match_db *match_db (owned)
+ *               |   |=C2=BB struct kdbus_meta *meta (owned)
+ *               |   |=C2=BB struct kdbus_match_db *match_db (owned)
+ *               |   |    '=C2=BB struct kdbus_match_entry (many, owne=
d)
+ *               |   |
+ *               |   |=C2=BB struct kdbus_pool *pool (owned)
+ *               |   |    '=C2=BB struct kdbus_pool_slice *slices (man=
y, owned)
+ *               |   |       '=C2=BB struct kdbus_pool *pool (pinned)
+ *               |   |
+ *               |   |=C2=BB struct kdbus_user *user (pinned)
+ *               |   `=C2=BB struct kdbus_queue_entry entries (many, e=
mbedded)
+ *               |        |=C2=BB struct kdbus_pool_slice *slice (pinn=
ed)
+ *               |        |=C2=BB struct kdbus_conn_reply *reply (owne=
d)
+ *               |        '=C2=BB struct kdbus_user *user (pinned)
+ *               |
+ *               '=C2=BB struct kdbus_user *user (pinned)
+ *                   '=C2=BB struct kdbus_policy_db policy_db (embedde=
d)
+ *                        |=C2=BB struct kdbus_policy_db_entry (many, =
owned)
+ *                        |   |=C2=BB struct kdbus_conn (pinned)
+ *                        |   '=C2=BB struct kdbus_ep (pinned)
+ *                        |
+ *                        '=C2=BB struct kdbus_policy_db_cache_entry (=
many, owned)
+ *                            '=C2=BB struct kdbus_conn (pinned)
+ *
+ * For the life-time of a file descriptor derived from calling open() =
on a file
+ * inside the mount point:
+ *
+ * struct kdbus_handle
+ *  |=C2=BB struct kdbus_meta *meta (owned)
+ *  |=C2=BB struct kdbus_ep *ep (pinned)
+ *  |=C2=BB struct kdbus_conn *conn (owned)
+ *  '=C2=BB struct kdbus_ep *ep (owned)
+ */
+
+/* kdbus mount-point /sys/fs/kdbus */
+static struct kobject *kdbus_dir;
+
+/* global module option to apply a mask to exported metadata */
+unsigned long long kdbus_meta_attach_mask =3D KDBUS_ATTACH_TIMESTAMP |
+					    KDBUS_ATTACH_CREDS |
+					    KDBUS_ATTACH_PIDS |
+					    KDBUS_ATTACH_AUXGROUPS |
+					    KDBUS_ATTACH_NAMES |
+					    KDBUS_ATTACH_SECLABEL |
+					    KDBUS_ATTACH_CONN_DESCRIPTION;
+MODULE_PARM_DESC(attach_flags_mask, "Attach-flags mask for exported me=
tadata");
+module_param_named(attach_flags_mask, kdbus_meta_attach_mask, ullong, =
0644);
+
+static int __init kdbus_init(void)
+{
+	int ret;
+
+	kdbus_dir =3D kobject_create_and_add(KBUILD_MODNAME, fs_kobj);
+	if (!kdbus_dir)
+		return -ENOMEM;
+
+	ret =3D kdbus_fs_init();
+	if (ret < 0) {
+		pr_err("cannot register filesystem: %d\n", ret);
+		goto exit_dir;
+	}
+
+	pr_info("initialized\n");
+	return 0;
+
+exit_dir:
+	kobject_put(kdbus_dir);
+	return ret;
+}
+
+static void __exit kdbus_exit(void)
+{
+	kdbus_fs_exit();
+	kobject_put(kdbus_dir);
+}
+
+module_init(kdbus_init);
+module_exit(kdbus_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("D-Bus, powerful, easy to use interprocess communic=
ation");
+MODULE_ALIAS_FS(KBUILD_MODNAME "fs");
diff --git a/ipc/kdbus/util.c b/ipc/kdbus/util.c
new file mode 100644
index 000000000000..eaa806a27997
--- /dev/null
+++ b/ipc/kdbus/util.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Greg Kroah-Hartman <gregkh@linuxfoundation.=
org>
+ * Copyright (C) 2013-2015 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2015 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2015 Linux Foundation
+ * Copyright (C) 2014-2015 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/capability.h>
+#include <linux/cred.h>
+#include <linux/ctype.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+#include <linux/uio.h>
+#include <linux/user_namespace.h>
+
+#include "limits.h"
+#include "util.h"
+
+/**
+ * kdbus_copy_from_user() - copy aligned data from user-space
+ * @dest:	target buffer in kernel memory
+ * @user_ptr:	user-provided source buffer
+ * @size:	memory size to copy from user
+ *
+ * This copies @size bytes from @user_ptr into the kernel, just like
+ * copy_from_user() does. But we enforce an 8-byte alignment and rejec=
t any
+ * unaligned user-space pointers.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kdbus_copy_from_user(void *dest, void __user *user_ptr, size_t siz=
e)
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
+/**
+ * kdbus_memdup_user() - copy dynamically sized object from user-space
+ * @user_ptr:	user-provided source buffer
+ * @sz_min:	minimum object size
+ * @sz_max:	maximum object size
+ *
+ * This copies a dynamically sized object from user-space into kernel-=
space. We
+ * require the object to have a 64bit size field at offset 0. We read =
it out
+ * first, allocate a suitably sized buffer and then copy all data.
+ *
+ * The @sz_min and @sz_max parameters define possible min and max obje=
ct sizes
+ * so user-space cannot trigger un-bound kernel-space allocations.
+ *
+ * The same alignment-restrictions as described in kdbus_copy_from_use=
r() apply.
+ *
+ * Return: pointer to dynamically allocated copy, or ERR_PTR() on fail=
ure.
+ */
+void *kdbus_memdup_user(void __user *user_ptr, size_t sz_min, size_t s=
z_max)
+{
+	void *ptr;
+	u64 size;
+	int ret;
+
+	ret =3D kdbus_copy_from_user(&size, user_ptr, sizeof(size));
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (size < sz_min)
+		return ERR_PTR(-EINVAL);
+
+	if (size > sz_max)
+		return ERR_PTR(-EMSGSIZE);
+
+	ptr =3D memdup_user(user_ptr, size);
+	if (IS_ERR(ptr))
+		return ptr;
+
+	if (*(u64 *)ptr !=3D size) {
+		kfree(ptr);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return ptr;
+}
+
+/**
+ * kdbus_verify_uid_prefix() - verify UID prefix of a user-supplied na=
me
+ * @name:	user-supplied name to verify
+ * @user_ns:	user-namespace to act in
+ * @kuid:	Kernel internal uid of user
+ *
+ * This verifies that the user-supplied name @name has their UID as pr=
efix. This
+ * is the default name-spacing policy we enforce on user-supplied name=
s for
+ * public kdbus entities like buses and endpoints.
+ *
+ * The user must supply names prefixed with "<UID>-", whereas the UID =
is
+ * interpreted in the user-namespace of the domain. If the user fails =
to supply
+ * such a prefixed name, we reject it.
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+int kdbus_verify_uid_prefix(const char *name, struct user_namespace *u=
ser_ns,
+			    kuid_t kuid)
+{
+	uid_t uid;
+	char prefix[16];
+
+	/*
+	 * The kuid must have a mapping into the userns of the domain
+	 * otherwise do not allow creation of buses nor endpoints.
+	 */
+	uid =3D from_kuid(user_ns, kuid);
+	if (uid =3D=3D (uid_t) -1)
+		return -EINVAL;
+
+	snprintf(prefix, sizeof(prefix), "%u-", uid);
+	if (strncmp(name, prefix, strlen(prefix)) !=3D 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * kdbus_sanitize_attach_flags() - Sanitize attach flags from user-spa=
ce
+ * @flags:		Attach flags provided by userspace
+ * @attach_flags:	A pointer where to store the valid attach flags
+ *
+ * Convert attach-flags provided by user-space into a valid mask. If t=
he mask
+ * is invalid, an error is returned. The sanitized attach flags are st=
ored in
+ * the output parameter.
+ *
+ * Return: 0 on success, negative error on failure.
+ */
+int kdbus_sanitize_attach_flags(u64 flags, u64 *attach_flags)
+{
+	/* 'any' degrades to 'all' for compatibility */
+	if (flags =3D=3D _KDBUS_ATTACH_ANY)
+		flags =3D _KDBUS_ATTACH_ALL;
+
+	/* reject unknown attach flags */
+	if (flags & ~_KDBUS_ATTACH_ALL)
+		return -EINVAL;
+
+	*attach_flags =3D flags;
+	return 0;
+}
+
+/**
+ * kdbus_kvec_set - helper utility to assemble kvec arrays
+ * @kvec:	kvec entry to use
+ * @src:	Source address to set in @kvec
+ * @len:	Number of bytes in @src
+ * @total_len:	Pointer to total length variable
+ *
+ * Set @src and @len in @kvec, and increase @total_len by @len.
+ */
+void kdbus_kvec_set(struct kvec *kvec, void *src, size_t len, u64 *tot=
al_len)
+{
+	kvec->iov_base =3D src;
+	kvec->iov_len =3D len;
+	*total_len +=3D len;
+}
+
+static const char * const zeros =3D "\0\0\0\0\0\0\0";
+
+/**
+ * kdbus_kvec_pad - conditionally write a padding kvec
+ * @kvec:	kvec entry to use
+ * @len:	Total length used for kvec array
+ *
+ * Check if the current total byte length of the array in @len is alig=
ned to
+ * 8 bytes. If it isn't, fill @kvec with padding information and incre=
ase @len
+ * by the number of bytes stored in @kvec.
+ *
+ * Return: the number of added padding bytes.
+ */
+size_t kdbus_kvec_pad(struct kvec *kvec, u64 *len)
+{
+	size_t pad =3D KDBUS_ALIGN8(*len) - *len;
+
+	if (!pad)
+		return 0;
+
+	kvec->iov_base =3D (void *)zeros;
+	kvec->iov_len =3D pad;
+
+	*len +=3D pad;
+
+	return pad;
+}
diff --git a/ipc/kdbus/util.h b/ipc/kdbus/util.h
new file mode 100644
index 000000000000..9caadb337912
--- /dev/null
+++ b/ipc/kdbus/util.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Greg Kroah-Hartman <gregkh@linuxfoundation.=
org>
+ * Copyright (C) 2013-2015 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2015 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2015 Linux Foundation
+ * Copyright (C) 2014-2015 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
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
+ * kdbus_member_set_user - write a structure member to user memory
+ * @_s:		Variable to copy from
+ * @_b:		Buffer to write to
+ * @_t:		Structure type
+ * @_m:		Member name in the passed structure
+ *
+ * Return: the result of copy_to_user()
+ */
+#define kdbus_member_set_user(_s, _b, _t, _m)				\
+({									\
+	u64 __user *_sz =3D						\
+		(void __user *)((u8 __user *)(_b) + offsetof(_t, _m));	\
+	copy_to_user(_sz, _s, sizeof(((_t *)0)->_m));			\
+})
+
+/**
+ * kdbus_strhash - calculate a hash
+ * @str:	String
+ *
+ * Return: hash value
+ */
+static inline unsigned int kdbus_strhash(const char *str)
+{
+	unsigned long hash =3D init_name_hash();
+
+	while (*str)
+		hash =3D partial_name_hash(*str++, hash);
+
+	return end_name_hash(hash);
+}
+
+int kdbus_verify_uid_prefix(const char *name, struct user_namespace *u=
ser_ns,
+			    kuid_t kuid);
+int kdbus_sanitize_attach_flags(u64 flags, u64 *attach_flags);
+
+int kdbus_copy_from_user(void *dest, void __user *user_ptr, size_t siz=
e);
+void *kdbus_memdup_user(void __user *user_ptr, size_t sz_min, size_t s=
z_max);
+
+struct kvec;
+
+void kdbus_kvec_set(struct kvec *kvec, void *src, size_t len, u64 *tot=
al_len);
+size_t kdbus_kvec_pad(struct kvec *kvec, u64 *len);
+
+#endif
--=20
2.3.1
