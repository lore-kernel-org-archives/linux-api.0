From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add code for buses, domains and endpoints
Date: Thu, 20 Nov 2014 21:02:25 -0800
Message-ID: <1416546149-24799-10-git-send-email-gregkh@linuxfoundation.org>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

Add the logic to handle the following entities:

Domain:
  A domain is an unamed object containing a number of buses. A
  domain is automatically created when an instance of kdbusfs
  is mounted, and destroyed when it is unmounted.
  Every domain offers its own "control" device node to create
  buses.  Domains have no connection to each other and cannot
  see nor talk to each other.

Bus:
  A bus is a named object inside a domain. Clients exchange messages
  over a bus. Multiple buses themselves have no connection to each
  other; messages can only be exchanged on the same bus. The default
  entry point to a bus, where clients establish the connection to, is
  the "bus" device node /dev/kdbus/<bus name>/bus.  Common operating
  system setups create one "system bus" per system, and one "user
  bus" for every logged-in user. Applications or services may create
  their own private named buses.

Endpoint:
  An endpoint provides the device node to talk to a bus. Opening an
  endpoint creates a new connection to the bus to which the endpoint
  belongs. Every bus has a default endpoint called "bus". A bus can
  optionally offer additional endpoints with custom names to provide
  a restricted access to the same bus. Custom endpoints carry
  additional policy which can be used to give sandboxed processes
  only a locked-down, limited, filtered access to the same bus.

See Documentation/kdbus.txt for more details.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/kdbus/bus.c      | 459 +++++++++++++++++++++++++++++++++++++++++++++++
 ipc/kdbus/bus.h      |  98 ++++++++++
 ipc/kdbus/domain.c   | 349 ++++++++++++++++++++++++++++++++++++
 ipc/kdbus/domain.h   |  84 +++++++++
 ipc/kdbus/endpoint.c | 497 +++++++++++++++++++++++++++++++++++++++++++++++++++
 ipc/kdbus/endpoint.h |  91 ++++++++++
 6 files changed, 1578 insertions(+)
 create mode 100644 ipc/kdbus/bus.c
 create mode 100644 ipc/kdbus/bus.h
 create mode 100644 ipc/kdbus/domain.c
 create mode 100644 ipc/kdbus/domain.h
 create mode 100644 ipc/kdbus/endpoint.c
 create mode 100644 ipc/kdbus/endpoint.h

diff --git a/ipc/kdbus/bus.c b/ipc/kdbus/bus.c
new file mode 100644
index 000000000000..2808a2e87707
--- /dev/null
+++ b/ipc/kdbus/bus.c
@@ -0,0 +1,459 @@
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
+#include <linux/fs.h>
+#include <linux/hashtable.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "bus.h"
+#include "notify.h"
+#include "connection.h"
+#include "domain.h"
+#include "endpoint.h"
+#include "item.h"
+#include "match.h"
+#include "message.h"
+#include "metadata.h"
+#include "names.h"
+#include "policy.h"
+
+static void kdbus_bus_free(struct kdbus_node *node)
+{
+	struct kdbus_bus *bus = container_of(node, struct kdbus_bus, node);
+
+	BUG_ON(!list_empty(&bus->monitors_list));
+	BUG_ON(!hash_empty(bus->conn_hash));
+
+	kdbus_notify_free(bus);
+
+	kdbus_domain_user_unref(bus->user);
+	kdbus_name_registry_free(bus->name_registry);
+	kdbus_domain_unref(bus->domain);
+	kdbus_policy_db_clear(&bus->policy_db);
+	kdbus_meta_free(bus->meta);
+	kfree(bus);
+}
+
+static void kdbus_bus_release(struct kdbus_node *node, bool was_active)
+{
+	struct kdbus_bus *bus = container_of(node, struct kdbus_bus, node);
+
+	if (was_active)
+		atomic_dec(&bus->user->buses);
+}
+
+/**
+ * kdbus_bus_new() - create a kdbus_cmd_make from user-supplied data
+ * @domain:		The domain to work on
+ * @make:		Information as passed in by userspace
+ * @uid:		The uid of the device node
+ * @gid:		The gid of the device node
+ *
+ * This function is part of the connection ioctl() interface and will parse
+ * the user-supplied data in order to create a new kdbus_bus.
+ *
+ * Return: the new bus on success, ERR_PTR on failure.
+ */
+struct kdbus_bus *kdbus_bus_new(struct kdbus_domain *domain,
+				const struct kdbus_cmd_make *make,
+				kuid_t uid, kgid_t gid)
+{
+	const struct kdbus_bloom_parameter *bloom = NULL;
+	const struct kdbus_item *item;
+	struct kdbus_bus *b;
+	const char *name = NULL;
+	char prefix[16];
+	int ret;
+
+	u64 attach_flags = 0;
+
+	KDBUS_ITEMS_FOREACH(item, make->items, KDBUS_ITEMS_SIZE(make, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_MAKE_NAME:
+			if (name)
+				return ERR_PTR(-EEXIST);
+
+			name = item->str;
+			break;
+
+		case KDBUS_ITEM_BLOOM_PARAMETER:
+			if (bloom)
+				return ERR_PTR(-EEXIST);
+
+			bloom = &item->bloom_parameter;
+			break;
+
+		case KDBUS_ITEM_ATTACH_FLAGS_RECV:
+			if (attach_flags)
+				return ERR_PTR(-EEXIST);
+
+			attach_flags = item->data64[0];
+			break;
+		}
+	}
+
+	if (!name || !bloom)
+		return ERR_PTR(-EBADMSG);
+
+	/* 'any' degrades to 'all' for compatibility */
+	if (attach_flags == _KDBUS_ATTACH_ANY)
+		attach_flags = _KDBUS_ATTACH_ALL;
+
+	/* reject unknown attach flags */
+	if (attach_flags & ~_KDBUS_ATTACH_ALL)
+		return ERR_PTR(-EINVAL);
+	if (bloom->size < 8 || bloom->size > KDBUS_BUS_BLOOM_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
+	if (!KDBUS_IS_ALIGNED8(bloom->size))
+		return ERR_PTR(-EINVAL);
+	if (bloom->n_hash < 1)
+		return ERR_PTR(-EINVAL);
+
+	/* enforce "$UID-" prefix */
+	snprintf(prefix, sizeof(prefix), "%u-",
+		 from_kuid(domain->user_namespace, uid));
+	if (strncmp(name, prefix, strlen(prefix) != 0))
+		return ERR_PTR(-EINVAL);
+
+	b = kzalloc(sizeof(*b), GFP_KERNEL);
+	if (!b)
+		return ERR_PTR(-ENOMEM);
+
+	kdbus_node_init(&b->node, KDBUS_NODE_BUS);
+
+	b->node.free_cb = kdbus_bus_free;
+	b->node.release_cb = kdbus_bus_release;
+	b->node.uid = uid;
+	b->node.gid = gid;
+	b->node.mode = S_IRUSR | S_IXUSR;
+
+	b->access = make->flags & (KDBUS_MAKE_ACCESS_WORLD |
+				   KDBUS_MAKE_ACCESS_GROUP);
+	if (b->access & (KDBUS_MAKE_ACCESS_GROUP | KDBUS_MAKE_ACCESS_WORLD))
+		b->node.mode |= S_IRGRP | S_IXGRP;
+	if (b->access & KDBUS_MAKE_ACCESS_WORLD)
+		b->node.mode |= S_IROTH | S_IXOTH;
+
+	b->bus_flags = make->flags;
+	b->bloom = *bloom;
+	b->attach_flags_req = attach_flags;
+	mutex_init(&b->lock);
+	init_rwsem(&b->conn_rwlock);
+	hash_init(b->conn_hash);
+	INIT_LIST_HEAD(&b->monitors_list);
+	INIT_LIST_HEAD(&b->notify_list);
+	spin_lock_init(&b->notify_lock);
+	mutex_init(&b->notify_flush_lock);
+	atomic64_set(&b->conn_seq_last, 0);
+	b->domain = kdbus_domain_ref(domain);
+	kdbus_policy_db_init(&b->policy_db);
+	b->id = atomic64_inc_return(&domain->bus_seq_last);
+
+	/* generate unique bus id */
+	generate_random_uuid(b->id128);
+
+	ret = kdbus_node_link(&b->node, &domain->node, name);
+	if (ret < 0)
+		goto exit_unref;
+
+	/* cache the metadata/credentials of the creator */
+	b->meta = kdbus_meta_new();
+	if (IS_ERR(b->meta)) {
+		ret = PTR_ERR(b->meta);
+		b->meta = NULL;
+		goto exit_unref;
+	}
+
+	ret = kdbus_meta_append(b->meta, domain, NULL, 0,
+				KDBUS_ATTACH_CREDS	|
+				KDBUS_ATTACH_TID_COMM	|
+				KDBUS_ATTACH_PID_COMM	|
+				KDBUS_ATTACH_EXE	|
+				KDBUS_ATTACH_CMDLINE	|
+				KDBUS_ATTACH_CGROUP	|
+				KDBUS_ATTACH_CAPS	|
+				KDBUS_ATTACH_SECLABEL	|
+				KDBUS_ATTACH_AUDIT);
+	if (ret < 0)
+		goto exit_unref;
+
+	b->name_registry = kdbus_name_registry_new();
+	if (IS_ERR(b->name_registry)) {
+		ret = PTR_ERR(b->name_registry);
+		b->name_registry = NULL;
+		goto exit_unref;
+	}
+
+	b->user = kdbus_domain_get_user(domain, uid);
+	if (IS_ERR(b->user)) {
+		ret = PTR_ERR(b->user);
+		b->user = NULL;
+		goto exit_unref;
+	}
+
+	return b;
+
+exit_unref:
+	kdbus_node_deactivate(&b->node);
+	kdbus_node_unref(&b->node);
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_bus_ref() - increase the reference counter of a kdbus_bus
+ * @bus:		The bus to reference
+ *
+ * Every user of a bus, except for its creator, must add a reference to the
+ * kdbus_bus using this function.
+ *
+ * Return: the bus itself
+ */
+struct kdbus_bus *kdbus_bus_ref(struct kdbus_bus *bus)
+{
+	if (bus)
+		kdbus_node_ref(&bus->node);
+	return bus;
+}
+
+/**
+ * kdbus_bus_unref() - decrease the reference counter of a kdbus_bus
+ * @bus:		The bus to unref
+ *
+ * Release a reference. If the reference count drops to 0, the bus will be
+ * freed.
+ *
+ * Return: NULL
+ */
+struct kdbus_bus *kdbus_bus_unref(struct kdbus_bus *bus)
+{
+	if (bus)
+		kdbus_node_unref(&bus->node);
+	return NULL;
+}
+
+/**
+ * kdbus_bus_activate() - activate a bus
+ * @bus:		Bus
+ *
+ * Activate a bus and make it available to user-space.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int kdbus_bus_activate(struct kdbus_bus *bus)
+{
+	struct kdbus_ep *ep;
+	int ret;
+
+	if (atomic_inc_return(&bus->user->buses) > KDBUS_USER_MAX_BUSES) {
+		atomic_dec(&bus->user->buses);
+		return -EMFILE;
+	}
+
+	/*
+	 * kdbus_bus_activate() must not be called multiple times, so if
+	 * kdbus_node_activate() didn't activate the node, it must already be
+	 * dead.
+	 */
+	if (!kdbus_node_activate(&bus->node)) {
+		atomic_dec(&bus->user->buses);
+		return -ESHUTDOWN;
+	}
+
+	/*
+	 * Create a new default endpoint for this bus. If activation succeeds,
+	 * we drop our own reference, effectively causing the endpoint to be
+	 * deactivated and released when the parent domain is.
+	 */
+	ep = kdbus_ep_new(bus, "bus", bus->access,
+			  bus->node.uid, bus->node.gid, false);
+	if (IS_ERR(ep))
+		return PTR_ERR(ep);
+
+	ret = kdbus_ep_activate(ep);
+	if (ret < 0)
+		kdbus_ep_deactivate(ep);
+	kdbus_ep_unref(ep);
+
+	return 0;
+}
+
+/**
+ * kdbus_bus_deactivate() - deactivate a bus
+ * @bus:               The kdbus reference
+ *
+ * The passed bus will be disconnected and the associated endpoint will be
+ * unref'ed.
+ */
+void kdbus_bus_deactivate(struct kdbus_bus *bus)
+{
+	kdbus_node_deactivate(&bus->node);
+}
+
+/**
+ * kdbus_bus_find_conn_by_id() - find a connection with a given id
+ * @bus:		The bus to look for the connection
+ * @id:			The 64-bit connection id
+ *
+ * Looks up a connection with a given id. The returned connection
+ * is ref'ed, and needs to be unref'ed by the user. Returns NULL if
+ * the connection can't be found.
+ */
+struct kdbus_conn *kdbus_bus_find_conn_by_id(struct kdbus_bus *bus, u64 id)
+{
+	struct kdbus_conn *conn, *found = NULL;
+
+	down_read(&bus->conn_rwlock);
+	hash_for_each_possible(bus->conn_hash, conn, hentry, id)
+		if (conn->id == id) {
+			found = kdbus_conn_ref(conn);
+			break;
+		}
+	up_read(&bus->conn_rwlock);
+
+	return found;
+}
+
+/**
+ * kdbus_bus_broadcast() - send a message to all subscribed connections
+ * @bus:	The bus the connections are connected to
+ * @conn_src:	The source connection, may be %NULL for kernel notifications
+ * @kmsg:	The message to send.
+ *
+ * Send @kmsg to all connections that are currently active on the bus.
+ * Connections must still have matches installed in order to subscribe to
+ * let the message pass.
+ */
+void kdbus_bus_broadcast(struct kdbus_bus *bus,
+			 struct kdbus_conn *conn_src,
+			 struct kdbus_kmsg *kmsg)
+{
+	const struct kdbus_msg *msg = &kmsg->msg;
+	struct kdbus_conn *conn_dst;
+	unsigned int i;
+	int ret = 0;
+
+	down_read(&bus->conn_rwlock);
+
+	hash_for_each(bus->conn_hash, i, conn_dst, hentry) {
+		if (conn_dst->id == msg->src_id)
+			continue;
+
+		/*
+		 * Activator or policy holder connections will
+		 * not receive any broadcast messages, only
+		 * ordinary and monitor ones.
+		 */
+		if (!kdbus_conn_is_ordinary(conn_dst) &&
+		    !kdbus_conn_is_monitor(conn_dst))
+			continue;
+
+		if (!kdbus_match_db_match_kmsg(conn_dst->match_db, conn_src,
+					       kmsg))
+			continue;
+
+		ret = kdbus_ep_policy_check_notification(conn_dst->ep,
+							 conn_dst, kmsg);
+		if (ret < 0)
+			continue;
+
+		/*
+		 * The first receiver which requests additional metadata
+		 * causes the message to carry it; data that is in fact added
+		 * to the message is still subject to what the receiver
+		 * requested, and will be filtered by kdbus_meta_write().
+		 */
+		if (conn_src) {
+			/* Check if conn_src is allowed to signal */
+			ret = kdbus_ep_policy_check_broadcast(conn_dst->ep,
+							      conn_src,
+							      conn_dst);
+			if (ret < 0)
+				continue;
+
+			ret = kdbus_ep_policy_check_src_names(conn_dst->ep,
+							      conn_src,
+							      conn_dst);
+			if (ret < 0)
+				continue;
+
+			ret = kdbus_kmsg_attach_metadata(kmsg, conn_src,
+							 conn_dst);
+			if (ret < 0)
+				goto exit_unlock;
+		}
+
+		ret = kdbus_conn_entry_insert(conn_src, conn_dst, kmsg, NULL);
+		if (ret < 0)
+			atomic_inc(&conn_dst->lost_count);
+	}
+
+exit_unlock:
+	up_read(&bus->conn_rwlock);
+}
+
+
+/**
+ * kdbus_cmd_bus_creator_info() - get information on a bus creator
+ * @conn:	The querying connection
+ * @cmd_info:	The command buffer, as passed in from the ioctl
+ *
+ * Gather information on the creator of the bus @conn is connected to.
+ *
+ * Return: 0 on success, error otherwise.
+ */
+int kdbus_cmd_bus_creator_info(struct kdbus_conn *conn,
+			       struct kdbus_cmd_info *cmd_info)
+{
+	struct kdbus_bus *bus = conn->ep->bus;
+	struct kdbus_pool_slice *slice;
+	struct kdbus_info info = {};
+	u64 flags = cmd_info->flags;
+	int ret;
+
+	info.id = bus->id;
+	info.flags = bus->bus_flags;
+	info.size = sizeof(info) +
+		    kdbus_meta_size(bus->meta, conn, &flags);
+
+	if (info.size == 0)
+		return -EPERM;
+
+	slice = kdbus_pool_slice_alloc(conn->pool, info.size);
+	if (IS_ERR(slice))
+		return PTR_ERR(slice);
+
+	ret = kdbus_pool_slice_copy(slice, 0, &info, sizeof(info));
+	if (ret < 0)
+		goto exit_free_slice;
+
+	ret = kdbus_meta_write(bus->meta, conn, flags, slice, sizeof(info));
+	if (ret < 0)
+		goto exit_free_slice;
+
+	/* write back the offset */
+	cmd_info->offset = kdbus_pool_slice_offset(slice);
+	kdbus_pool_slice_flush(slice);
+	kdbus_pool_slice_make_public(slice);
+
+	return 0;
+
+exit_free_slice:
+	kdbus_pool_slice_free(slice);
+	return ret;
+}
diff --git a/ipc/kdbus/bus.h b/ipc/kdbus/bus.h
new file mode 100644
index 000000000000..cd45b128acad
--- /dev/null
+++ b/ipc/kdbus/bus.h
@@ -0,0 +1,98 @@
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
+#ifndef __KDBUS_BUS_H
+#define __KDBUS_BUS_H
+
+#include <linux/hashtable.h>
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+
+#include "node.h"
+#include "policy.h"
+#include "util.h"
+
+/**
+ * struct kdbus_bus - bus in a domain
+ * @node:		kdbus_node
+ * @disconnected:	Invalidated data
+ * @domain:		Domain of this bus
+ * @id:			ID of this bus in the domain
+ * @lock:		Bus data lock
+ * @access:		The access flags for the bus directory
+ * @ep_seq_last:	Last used endpoint id sequence number
+ * @conn_seq_last:	Last used connection id sequence number
+ * @bus_flags:		Simple pass-through flags from userspace to userspace
+ * @attach_flags_req:	Attach flags required by connecting peers
+ * @name_registry:	Name registry of this bus
+ * @bloom:		Bloom parameters
+ * @id128:		Unique random 128 bit ID of this bus
+ * @user:		Owner of the bus
+ * @policy_db:		Policy database for this bus
+ * @notify_list:	List of pending kernel-generated messages
+ * @notify_lock:	Notification list lock
+ * @notify_flush_lock:	Notification flushing lock
+ * @conn_rwlock:	Read/Write lock for all lists of child connections
+ * @conn_hash:		Map of connection IDs
+ * @monitors_list:	Connections that monitor this bus
+ * @meta:		Meta information about the bus creator
+ *
+ * A bus provides a "bus" endpoint / device node.
+ *
+ * A bus is created by opening the control node and issuing the
+ * KDBUS_CMD_BUS_MAKE iotcl. Closing this file immediately destroys
+ * the bus.
+ */
+struct kdbus_bus {
+	struct kdbus_node node;
+	struct kdbus_domain *domain;
+	u64 id;
+	struct mutex lock;
+	unsigned int access;
+	atomic64_t ep_seq_last;
+	atomic64_t conn_seq_last;
+	u64 bus_flags;
+	u64 attach_flags_req;
+	struct kdbus_name_registry *name_registry;
+	struct kdbus_bloom_parameter bloom;
+	u8 id128[16];
+	struct kdbus_domain_user *user;
+	struct kdbus_policy_db policy_db;
+	struct list_head notify_list;
+	spinlock_t notify_lock;
+	struct mutex notify_flush_lock;
+
+	struct rw_semaphore conn_rwlock;
+	DECLARE_HASHTABLE(conn_hash, 8);
+	struct list_head monitors_list;
+
+	struct kdbus_meta *meta;
+};
+
+struct kdbus_kmsg;
+
+struct kdbus_bus *kdbus_bus_new(struct kdbus_domain *domain,
+				const struct kdbus_cmd_make *make,
+				kuid_t uid, kgid_t gid);
+struct kdbus_bus *kdbus_bus_ref(struct kdbus_bus *bus);
+struct kdbus_bus *kdbus_bus_unref(struct kdbus_bus *bus);
+int kdbus_bus_activate(struct kdbus_bus *bus);
+void kdbus_bus_deactivate(struct kdbus_bus *bus);
+
+int kdbus_cmd_bus_creator_info(struct kdbus_conn *conn,
+			       struct kdbus_cmd_info *cmd_info);
+struct kdbus_conn *kdbus_bus_find_conn_by_id(struct kdbus_bus *bus, u64 id);
+void kdbus_bus_broadcast(struct kdbus_bus *bus, struct kdbus_conn *conn_src,
+			 struct kdbus_kmsg *kmsg);
+
+#endif
diff --git a/ipc/kdbus/domain.c b/ipc/kdbus/domain.c
new file mode 100644
index 000000000000..0396439e4286
--- /dev/null
+++ b/ipc/kdbus/domain.c
@@ -0,0 +1,349 @@
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
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "bus.h"
+#include "domain.h"
+#include "handle.h"
+#include "item.h"
+#include "limits.h"
+#include "util.h"
+
+static void kdbus_domain_control_free(struct kdbus_node *node)
+{
+	kfree(node);
+}
+
+static struct kdbus_node *kdbus_domain_control_new(struct kdbus_domain *domain,
+						   unsigned int access)
+{
+	struct kdbus_node *node;
+	int ret;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	kdbus_node_init(node, KDBUS_NODE_CONTROL);
+
+	node->free_cb = kdbus_domain_control_free;
+	node->mode = domain->node.mode;
+	node->mode = S_IRUSR | S_IWUSR;
+	if (access & (KDBUS_MAKE_ACCESS_GROUP | KDBUS_MAKE_ACCESS_WORLD))
+		node->mode |= S_IRGRP | S_IWGRP;
+	if (access & KDBUS_MAKE_ACCESS_WORLD)
+		node->mode |= S_IROTH | S_IWOTH;
+
+	ret = kdbus_node_link(node, &domain->node, "control");
+	if (ret < 0)
+		goto exit_free;
+
+	return node;
+
+exit_free:
+	kdbus_node_deactivate(node);
+	kdbus_node_unref(node);
+	return ERR_PTR(ret);
+}
+
+static void kdbus_domain_free(struct kdbus_node *node)
+{
+	struct kdbus_domain *domain = container_of(node, struct kdbus_domain,
+						   node);
+
+	BUG_ON(!hash_empty(domain->user_hash));
+
+	put_pid_ns(domain->pid_namespace);
+	put_user_ns(domain->user_namespace);
+	idr_destroy(&domain->user_idr);
+	kfree(domain);
+}
+
+/**
+ * kdbus_domain_new() - create a new domain
+ * @access:		The access mode for this node (KDBUS_MAKE_ACCESS_*)
+ *
+ * Return: a new kdbus_domain on success, ERR_PTR on failure
+ */
+struct kdbus_domain *kdbus_domain_new(unsigned int access)
+{
+	struct kdbus_domain *d;
+	int ret;
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return ERR_PTR(-ENOMEM);
+
+	kdbus_node_init(&d->node, KDBUS_NODE_DOMAIN);
+
+	d->node.free_cb = kdbus_domain_free;
+	d->node.mode = S_IRUSR | S_IXUSR;
+	if (access & (KDBUS_MAKE_ACCESS_GROUP | KDBUS_MAKE_ACCESS_WORLD))
+		d->node.mode |= S_IRGRP | S_IXGRP;
+	if (access & KDBUS_MAKE_ACCESS_WORLD)
+		d->node.mode |= S_IROTH | S_IXOTH;
+
+	d->access = access;
+	mutex_init(&d->lock);
+	atomic64_set(&d->msg_seq_last, 0);
+	idr_init(&d->user_idr);
+	d->pid_namespace = get_pid_ns(task_active_pid_ns(current));
+	d->user_namespace = get_user_ns(current_user_ns());
+
+	ret = kdbus_node_link(&d->node, NULL, NULL);
+	if (ret < 0)
+		goto exit_unref;
+
+	return d;
+
+exit_unref:
+	kdbus_node_deactivate(&d->node);
+	kdbus_node_unref(&d->node);
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_domain_ref() - take a domain reference
+ * @domain:		Domain
+ *
+ * Return: the domain itself
+ */
+struct kdbus_domain *kdbus_domain_ref(struct kdbus_domain *domain)
+{
+	if (domain)
+		kdbus_node_ref(&domain->node);
+	return domain;
+}
+
+/**
+ * kdbus_domain_unref() - drop a domain reference
+ * @domain:		Domain
+ *
+ * When the last reference is dropped, the domain internal structure
+ * is freed.
+ *
+ * Return: NULL
+ */
+struct kdbus_domain *kdbus_domain_unref(struct kdbus_domain *domain)
+{
+	if (domain)
+		kdbus_node_unref(&domain->node);
+	return NULL;
+}
+
+/**
+ * kdbus_domain_activate() - activate a domain
+ * @domain:		Domain
+ *
+ * Activate a domain so it will be visible to user-space and can be accessed
+ * by external entities.
+ *
+ * Returns: 0 on success, negative error-code on failure
+ */
+int kdbus_domain_activate(struct kdbus_domain *domain)
+{
+	struct kdbus_node *control;
+
+	/*
+	 * kdbus_domain_activate() must not be called multiple times, so if
+	 * kdbus_node_activate() didn't activate the node, it must already be
+	 * dead.
+	 */
+	if (!kdbus_node_activate(&domain->node))
+		return -ESHUTDOWN;
+
+	/*
+	 * Create a control-node for this domain. We drop our own reference
+	 * immediately, effectively causing the node to be deactivated and
+	 * released when the parent domain is.
+	 */
+	control = kdbus_domain_control_new(domain, domain->access);
+	if (IS_ERR(control))
+		return PTR_ERR(control);
+
+	kdbus_node_activate(control);
+	kdbus_node_unref(control);
+
+	return 0;
+}
+
+/**
+ * kdbus_domain_deactivate() - invalidate a domain
+ * @domain:		Domain
+ */
+void kdbus_domain_deactivate(struct kdbus_domain *domain)
+{
+	kdbus_node_deactivate(&domain->node);
+}
+
+/**
+ * kdbus_domain_user_assign_id() - allocate ID and assign it to the
+ *				   domain user
+ * @domain:		The domain of the user
+ * @user:		The kdbus_domain_user object of the user
+ *
+ * Returns 0 if ID in [0, INT_MAX] is successfully assigned to the
+ * domain user. Negative errno on failure.
+ *
+ * The user index is used in arrays for accounting user quota in
+ * receiver queues.
+ *
+ * Caller must have the domain lock held and must ensure that the
+ * domain was not disconnected.
+ */
+static int kdbus_domain_user_assign_id(struct kdbus_domain *domain,
+				       struct kdbus_domain_user *user)
+{
+	int ret;
+
+	/*
+	 * Allocate the smallest possible index for this user; used
+	 * in arrays for accounting user quota in receiver queues.
+	 */
+	ret = idr_alloc(&domain->user_idr, user, 0, 0, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	user->idr = ret;
+
+	return 0;
+}
+
+/**
+ * kdbus_domain_get_user() - get a kdbus_domain_user object
+ * @domain:		The domain of the user
+ * @uid:		The uid of the user; INVALID_UID for an
+ *			anonymous user like a custom endpoint
+ *
+ * If there is a uid matching, then use the already accounted
+ * kdbus_domain_user, increment its reference counter and return it.
+ * Otherwise allocate a new one, link it into the domain and return it.
+ *
+ * Return: the accounted domain user on success, ERR_PTR on failure.
+ */
+struct kdbus_domain_user *kdbus_domain_get_user(struct kdbus_domain *domain,
+						kuid_t uid)
+{
+	int ret;
+	struct kdbus_domain_user *tmp_user;
+	struct kdbus_domain_user *u = NULL;
+
+	mutex_lock(&domain->lock);
+
+	/* find uid and reference it */
+	if (uid_valid(uid)) {
+		hash_for_each_possible(domain->user_hash, tmp_user,
+				       hentry, __kuid_val(uid)) {
+			if (!uid_eq(tmp_user->uid, uid))
+				continue;
+
+			/*
+			 * If the ref-count is already 0, the destructor is
+			 * about to unlink and destroy the object. Continue
+			 * looking for a next one or create one, if none found.
+			 */
+			if (kref_get_unless_zero(&tmp_user->kref)) {
+				mutex_unlock(&domain->lock);
+				return tmp_user;
+			}
+		}
+	}
+
+	u = kzalloc(sizeof(*u), GFP_KERNEL);
+	if (!u) {
+		ret = -ENOMEM;
+		goto exit_unlock;
+	}
+
+	kref_init(&u->kref);
+	u->domain = kdbus_domain_ref(domain);
+	u->uid = uid;
+	atomic_set(&u->buses, 0);
+	atomic_set(&u->connections, 0);
+
+	/* Assign user ID and link into domain */
+	ret = kdbus_domain_user_assign_id(domain, u);
+	if (ret < 0)
+		goto exit_free;
+
+	/* UID hash map */
+	hash_add(domain->user_hash, &u->hentry, __kuid_val(u->uid));
+
+	mutex_unlock(&domain->lock);
+	return u;
+
+exit_free:
+	kdbus_domain_unref(u->domain);
+	kfree(u);
+exit_unlock:
+	mutex_unlock(&domain->lock);
+	return ERR_PTR(ret);
+}
+
+static void __kdbus_domain_user_free(struct kref *kref)
+{
+	struct kdbus_domain_user *user =
+		container_of(kref, struct kdbus_domain_user, kref);
+
+	BUG_ON(atomic_read(&user->buses) > 0);
+	BUG_ON(atomic_read(&user->connections) > 0);
+
+	/*
+	 * Lookups ignore objects with a ref-count of 0. Therefore, we can
+	 * safely remove it from the table after dropping the last reference.
+	 * No-one will acquire a ref in parallel.
+	 */
+	mutex_lock(&user->domain->lock);
+	idr_remove(&user->domain->user_idr, user->idr);
+	hash_del(&user->hentry);
+	mutex_unlock(&user->domain->lock);
+
+	kdbus_domain_unref(user->domain);
+	kfree(user);
+}
+
+/**
+ * kdbus_domain_user_ref() - take a domain user reference
+ * @u:		User
+ *
+ * Return: the domain user itself
+ */
+struct kdbus_domain_user *kdbus_domain_user_ref(struct kdbus_domain_user *u)
+{
+	kref_get(&u->kref);
+	return u;
+}
+
+/**
+ * kdbus_domain_user_unref() - drop a domain user reference
+ * @u:		User
+ *
+ * When the last reference is dropped, the domain internal structure
+ * is freed.
+ *
+ * Return: NULL
+ */
+struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u)
+{
+	if (u)
+		kref_put(&u->kref, __kdbus_domain_user_free);
+	return NULL;
+}
diff --git a/ipc/kdbus/domain.h b/ipc/kdbus/domain.h
new file mode 100644
index 000000000000..ad5447626ed1
--- /dev/null
+++ b/ipc/kdbus/domain.h
@@ -0,0 +1,84 @@
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
+#ifndef __KDBUS_DOMAIN_H
+#define __KDBUS_DOMAIN_H
+
+#include <linux/hashtable.h>
+#include <linux/idr.h>
+#include <linux/kref.h>
+#include <linux/user_namespace.h>
+#include <linux/pid_namespace.h>
+
+#include "node.h"
+
+/**
+ * struct kdbus_domain - domain for buses
+ * @node:		Underlying API node
+ * @access:		Access mode for this domain
+ * @lock:		Domain data lock
+ * @bus_seq_last:	Last used bus id sequence number
+ * @msg_seq_last:	Last used message id sequence number
+ * @user_hash:		Accounting of user resources
+ * @user_idr:		Map of all users; smallest possible index
+ * @pid_namespace:	PID namespace, pinned at creation time
+ * @user_namespace:	User namespace, pinned at creation time
+ */
+struct kdbus_domain {
+	struct kdbus_node node;
+	unsigned int access;
+	struct mutex lock;
+	atomic64_t bus_seq_last;
+	atomic64_t msg_seq_last;
+	DECLARE_HASHTABLE(user_hash, 6);
+	struct idr user_idr;
+	struct pid_namespace *pid_namespace;
+	struct user_namespace *user_namespace;
+};
+
+/**
+ * struct kdbus_domain_user - resource accounting for users
+ * @kref:		Reference counter
+ * @domain:		Domain of the user
+ * @hentry:		Entry in domain user map
+ * @idr:		Smallest possible index number of all users
+ * @uid:		UID of the user
+ * @buses:		Number of buses the user has created
+ * @connections:	Number of connections the user has created
+ */
+struct kdbus_domain_user {
+	struct kref kref;
+	struct kdbus_domain *domain;
+	struct hlist_node hentry;
+	unsigned int idr;
+	kuid_t uid;
+	atomic_t buses;
+	atomic_t connections;
+};
+
+#define kdbus_domain_from_node(_node) container_of((_node), \
+						   struct kdbus_domain, \
+						   node)
+
+struct kdbus_domain *kdbus_domain_new(unsigned int access);
+struct kdbus_domain *kdbus_domain_ref(struct kdbus_domain *domain);
+struct kdbus_domain *kdbus_domain_unref(struct kdbus_domain *domain);
+int kdbus_domain_activate(struct kdbus_domain *domain);
+void kdbus_domain_deactivate(struct kdbus_domain *domain);
+
+struct kdbus_domain_user *kdbus_domain_get_user(struct kdbus_domain *domain,
+						kuid_t uid);
+struct kdbus_domain_user *kdbus_domain_user_ref(struct kdbus_domain_user *u);
+struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u);
+
+#endif
diff --git a/ipc/kdbus/endpoint.c b/ipc/kdbus/endpoint.c
new file mode 100644
index 000000000000..dd8189009975
--- /dev/null
+++ b/ipc/kdbus/endpoint.c
@@ -0,0 +1,497 @@
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
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "bus.h"
+#include "connection.h"
+#include "domain.h"
+#include "endpoint.h"
+#include "handle.h"
+#include "item.h"
+#include "message.h"
+#include "policy.h"
+
+static void kdbus_ep_free(struct kdbus_node *node)
+{
+	struct kdbus_ep *ep = container_of(node, struct kdbus_ep, node);
+
+	BUG_ON(!list_empty(&ep->conn_list));
+
+	kdbus_policy_db_clear(&ep->policy_db);
+	kdbus_bus_unref(ep->bus);
+	kdbus_domain_user_unref(ep->user);
+	kfree(ep);
+}
+
+static void kdbus_ep_release(struct kdbus_node *node, bool was_active)
+{
+	struct kdbus_ep *ep = container_of(node, struct kdbus_ep, node);
+
+	/* disconnect all connections to this endpoint */
+	for (;;) {
+		struct kdbus_conn *conn;
+
+		mutex_lock(&ep->lock);
+		conn = list_first_entry_or_null(&ep->conn_list,
+						struct kdbus_conn,
+						ep_entry);
+		if (!conn) {
+			mutex_unlock(&ep->lock);
+			break;
+		}
+
+		/* take reference, release lock, disconnect without lock */
+		kdbus_conn_ref(conn);
+		mutex_unlock(&ep->lock);
+
+		kdbus_conn_disconnect(conn, false);
+		kdbus_conn_unref(conn);
+	}
+}
+
+/**
+ * kdbus_ep_new() - create a new endpoint
+ * @bus:		The bus this endpoint will be created for
+ * @name:		The name of the endpoint
+ * @access:		The access flags for this node (KDBUS_MAKE_ACCESS_*)
+ * @uid:		The uid of the device node
+ * @gid:		The gid of the device node
+ * @policy:		Whether or not the endpoint should have a policy db
+ *
+ * This function will create a new enpoint with the given
+ * name and properties for a given bus.
+ *
+ * Return: a new kdbus_ep on success, ERR_PTR on failure.
+ */
+struct kdbus_ep *kdbus_ep_new(struct kdbus_bus *bus, const char *name,
+			      unsigned int access, kuid_t uid, kgid_t gid,
+			      bool policy)
+{
+	struct kdbus_ep *e;
+	int ret;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+
+	kdbus_node_init(&e->node, KDBUS_NODE_ENDPOINT);
+
+	e->node.free_cb = kdbus_ep_free;
+	e->node.release_cb = kdbus_ep_release;
+	e->node.uid = uid;
+	e->node.gid = gid;
+	e->node.mode = S_IRUSR | S_IWUSR;
+	if (access & (KDBUS_MAKE_ACCESS_GROUP | KDBUS_MAKE_ACCESS_WORLD))
+		e->node.mode |= S_IRGRP | S_IWGRP;
+	if (access & KDBUS_MAKE_ACCESS_WORLD)
+		e->node.mode |= S_IROTH | S_IWOTH;
+
+	mutex_init(&e->lock);
+	INIT_LIST_HEAD(&e->conn_list);
+	kdbus_policy_db_init(&e->policy_db);
+	e->has_policy = policy;
+	e->bus = kdbus_bus_ref(bus);
+	e->id = atomic64_inc_return(&bus->ep_seq_last);
+
+	ret = kdbus_node_link(&e->node, &bus->node, name);
+	if (ret < 0)
+		goto exit_unref;
+
+	return e;
+
+exit_unref:
+	kdbus_node_deactivate(&e->node);
+	kdbus_node_unref(&e->node);
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_ep_ref() - increase the reference counter of a kdbus_ep
+ * @ep:			The endpoint to reference
+ *
+ * Every user of an endpoint, except for its creator, must add a reference to
+ * the kdbus_ep instance using this function.
+ *
+ * Return: the ep itself
+ */
+struct kdbus_ep *kdbus_ep_ref(struct kdbus_ep *ep)
+{
+	if (ep)
+		kdbus_node_ref(&ep->node);
+	return ep;
+}
+
+/**
+ * kdbus_ep_unref() - decrease the reference counter of a kdbus_ep
+ * @ep:		The ep to unref
+ *
+ * Release a reference. If the reference count drops to 0, the ep will be
+ * freed.
+ *
+ * Return: NULL
+ */
+struct kdbus_ep *kdbus_ep_unref(struct kdbus_ep *ep)
+{
+	if (ep)
+		kdbus_node_unref(&ep->node);
+	return NULL;
+}
+
+/**
+ * kdbus_ep_activate() - Activatean endpoint
+ * @ep:			Endpoint
+ *
+ * Return: 0 on success, negative error otherwise.
+ */
+int kdbus_ep_activate(struct kdbus_ep *ep)
+{
+	/*
+	 * kdbus_ep_activate() must not be called multiple times, so if
+	 * kdbus_node_activate() didn't activate the node, it must already be
+	 * dead.
+	 */
+	if (!kdbus_node_activate(&ep->node))
+		return -ESHUTDOWN;
+
+	return 0;
+}
+
+/**
+ * kdbus_ep_deactivate() - invalidate an endpoint
+ * @ep:			Endpoint
+ */
+void kdbus_ep_deactivate(struct kdbus_ep *ep)
+{
+	kdbus_node_deactivate(&ep->node);
+}
+
+/**
+ * kdbus_ep_policy_set() - set policy for an endpoint
+ * @ep:			The endpoint
+ * @items:		The kdbus items containing policy information
+ * @items_size:		The total length of the items
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_ep_policy_set(struct kdbus_ep *ep,
+			const struct kdbus_item *items,
+			size_t items_size)
+{
+	return kdbus_policy_set(&ep->policy_db, items, items_size, 0, true, ep);
+}
+
+/**
+ * kdbus_ep_policy_check_see_access_unlocked() - verify a connection can see
+ *						 the passed name
+ * @ep:			Endpoint to operate on
+ * @conn:		Connection that lists names
+ * @name:		Name that is tried to be listed
+ *
+ * This verifies that @conn is allowed to see the well-known name @name via the
+ * endpoint @ep.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_see_access_unlocked(struct kdbus_ep *ep,
+					      struct kdbus_conn *conn,
+					      const char *name)
+{
+	int ret;
+
+	/*
+	 * Check policy, if the endpoint of the connection has a db.
+	 * Note that policy DBs instanciated along with connections
+	 * don't have SEE rules, so it's sufficient to check the
+	 * endpoint's database.
+	 *
+	 * The lock for the policy db is held across all calls of
+	 * kdbus_name_list_all(), so the entries in both writing
+	 * and non-writing runs of kdbus_name_list_write() are the
+	 * same.
+	 */
+
+	if (!ep->has_policy)
+		return 0;
+
+	ret = kdbus_policy_check_see_access_unlocked(&ep->policy_db,
+						     conn->cred, name);
+
+	/* don't leak hints whether a name exists on a custom endpoint. */
+	if (ret == -EPERM)
+		return -ENOENT;
+
+	return ret;
+}
+
+/**
+ * kdbus_ep_policy_check_see_access() - verify a connection can see
+ *					the passed name
+ * @ep:			Endpoint to operate on
+ * @conn:		Connection that lists names
+ * @name:		Name that is tried to be listed
+ *
+ * This verifies that @conn is allowed to see the well-known name @name via the
+ * endpoint @ep.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_see_access(struct kdbus_ep *ep,
+				     struct kdbus_conn *conn,
+				     const char *name)
+{
+	int ret;
+
+	down_read(&ep->policy_db.entries_rwlock);
+	mutex_lock(&conn->lock);
+
+	ret = kdbus_ep_policy_check_see_access_unlocked(ep, conn, name);
+
+	mutex_unlock(&conn->lock);
+	up_read(&ep->policy_db.entries_rwlock);
+
+	return ret;
+}
+
+/**
+ * kdbus_ep_policy_check_notification() - verify a connection is allowed to see
+ *					  the name in a notification
+ * @ep:			Endpoint to operate on
+ * @conn:		Connection connected to the endpoint
+ * @kmsg:		The message carrying the notification
+ *
+ * This function verifies that @conn is allowed to see the well-known name
+ * inside a name-change notification contained in @msg via the endpoint @ep.
+ * If @msg is not a notification for name changes, this function does nothing
+ * but return 0.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_notification(struct kdbus_ep *ep,
+				       struct kdbus_conn *conn,
+				       const struct kdbus_kmsg *kmsg)
+{
+	int ret = 0;
+
+	if (kmsg->msg.src_id != KDBUS_SRC_ID_KERNEL || !ep->has_policy)
+		return 0;
+
+	switch (kmsg->notify_type) {
+	case KDBUS_ITEM_NAME_ADD:
+	case KDBUS_ITEM_NAME_REMOVE:
+	case KDBUS_ITEM_NAME_CHANGE:
+		ret = kdbus_ep_policy_check_see_access(ep, conn,
+						       kmsg->notify_name);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * kdbus_ep_policy_check_src_names() - check whether a connection's endpoint
+ *				       is allowed to see any of another
+ *				       connection's currently owned names
+ * @ep:			Endpoint to operate on
+ * @conn_src:		Connection that owns the names
+ * @conn_dst:		Destination connection to check credentials against
+ *
+ * This function checks whether @ep is allowed to see any of the names
+ * currently owned by @conn_src.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_src_names(struct kdbus_ep *ep,
+				    struct kdbus_conn *conn_src,
+				    struct kdbus_conn *conn_dst)
+{
+	struct kdbus_name_entry *e;
+	int ret = -ENOENT;
+
+	if (!ep->has_policy)
+		return 0;
+
+	down_read(&ep->policy_db.entries_rwlock);
+	mutex_lock(&conn_src->lock);
+
+	list_for_each_entry(e, &conn_src->names_list, conn_entry) {
+		ret = kdbus_ep_policy_check_see_access_unlocked(ep, conn_dst,
+								e->name);
+		if (ret == 0)
+			break;
+	}
+
+	mutex_unlock(&conn_src->lock);
+	up_read(&ep->policy_db.entries_rwlock);
+
+	return ret;
+}
+
+static int
+kdbus_custom_ep_check_talk_access(struct kdbus_ep *ep,
+				  struct kdbus_conn *conn_src,
+				  struct kdbus_conn *conn_dst)
+{
+	int ret;
+
+	if (!ep->has_policy)
+		return 0;
+
+	/* Custom endpoints have stricter policies */
+	ret = kdbus_policy_check_talk_access(&ep->policy_db,
+					     conn_src, conn_dst);
+
+	/*
+	 * Don't leak hints whether a name exists on a custom
+	 * endpoint.
+	 */
+	if (ret == -EPERM)
+		ret = -ENOENT;
+
+	return ret;
+}
+
+static bool
+kdbus_ep_has_default_talk_access(struct kdbus_conn *conn_src,
+				 struct kdbus_conn *conn_dst)
+{
+	if (conn_src->privileged)
+		return true;
+
+	if (uid_eq(conn_src->cred->fsuid, conn_dst->cred->uid))
+		return true;
+
+	return false;
+}
+
+/**
+ * kdbus_ep_policy_check_talk_access() - verify a connection can talk to the
+ *					 the passed connection
+ * @ep:			Endpoint to operate on
+ * @conn_src:		Connection that tries to talk
+ * @conn_dst:		Connection that is talked to
+ *
+ * This verifies that @conn_src is allowed to talk to @conn_dst via the
+ * endpoint @ep.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_talk_access(struct kdbus_ep *ep,
+				      struct kdbus_conn *conn_src,
+				      struct kdbus_conn *conn_dst)
+{
+	int ret;
+
+	/* First check the custom endpoint with its policies */
+	ret = kdbus_custom_ep_check_talk_access(ep, conn_src, conn_dst);
+	if (ret < 0)
+		return ret;
+
+	/* Then check if it satisfies the implicit policies */
+	if (kdbus_ep_has_default_talk_access(conn_src, conn_dst))
+		return 0;
+
+	/* Fallback to the default endpoint policy */
+	return kdbus_policy_check_talk_access(&ep->bus->policy_db,
+					      conn_src, conn_dst);
+}
+
+/**
+ * kdbus_ep_policy_check_broadcast() - verify a connection can send
+ *				       broadcast messages to the
+ *				       passed connection
+ * @ep:			Endpoint to operate on
+ * @conn_src:		Connection that tries to talk
+ * @conn_dst:		Connection that is talked to
+ *
+ * This verifies that @conn_src is allowed to send broadcast messages
+ * to @conn_dst via the endpoint @ep.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_broadcast(struct kdbus_ep *ep,
+				    struct kdbus_conn *conn_src,
+				    struct kdbus_conn *conn_dst)
+{
+	int ret;
+
+	/* First check the custom endpoint with its policies */
+	ret = kdbus_custom_ep_check_talk_access(ep, conn_src, conn_dst);
+	if (ret < 0)
+		return ret;
+
+	/* Then check if it satisfies the implicit policies */
+	if (kdbus_ep_has_default_talk_access(conn_src, conn_dst))
+		return 0;
+
+	/*
+	 * If conn_src owns names on the bus, and the conn_dst does
+	 * not own any name, then allow conn_src to signal to
+	 * conn_dst. Otherwise fallback and perform the bus policy
+	 * check on conn_dst.
+	 *
+	 * This way we allow services to signal on the bus, and we
+	 * block broadcasts directed to services that own names and
+	 * do not want to receive these messages unless there is a
+	 * policy entry to permit it. By this we try to follow the
+	 * same logic used for unicat messages.
+	 */
+	if (atomic_read(&conn_src->name_count) > 0 &&
+	    atomic_read(&conn_dst->name_count) == 0)
+		return 0;
+
+	/* Fallback to the default endpoint policy */
+	return kdbus_policy_check_talk_access(&ep->bus->policy_db,
+					      conn_src, conn_dst);
+}
+
+/**
+ * kdbus_ep_policy_check_own_access() - verify a connection can own the passed
+ *					name
+ * @ep:			Endpoint to operate on
+ * @conn:		Connection that acquires a name
+ * @name:		Name that is about to be acquired
+ *
+ * This verifies that @conn is allowed to acquire the well-known name @name via
+ * the endpoint @ep.
+ *
+ * Return: 0 if allowed, negative error code if not.
+ */
+int kdbus_ep_policy_check_own_access(struct kdbus_ep *ep,
+				     const struct kdbus_conn *conn,
+				     const char *name)
+{
+	int ret;
+
+	if (ep->has_policy) {
+		ret = kdbus_policy_check_own_access(&ep->policy_db,
+						    conn->cred, name);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (conn->privileged)
+		return 0;
+
+	return kdbus_policy_check_own_access(&ep->bus->policy_db,
+					     conn->cred, name);
+}
diff --git a/ipc/kdbus/endpoint.h b/ipc/kdbus/endpoint.h
new file mode 100644
index 000000000000..e7c69f705399
--- /dev/null
+++ b/ipc/kdbus/endpoint.h
@@ -0,0 +1,91 @@
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
+#ifndef __KDBUS_ENDPOINT_H
+#define __KDBUS_ENDPOINT_H
+
+#include "limits.h"
+#include "names.h"
+#include "node.h"
+#include "policy.h"
+#include "util.h"
+
+struct kdbus_kmsg;
+
+/*
+ * struct kdbus_endpoint - enpoint to access a bus
+ * @node:		The kdbus node
+ * @bus:		Bus behind this endpoint
+ * @id:			ID of this endpoint on the bus
+ * @conn_list:		Connections of this endpoint
+ * @lock:		Endpoint data lock
+ * @user:		Custom enpoints account against an anonymous user
+ * @policy_db:		Uploaded policy
+ * @disconnected:	Invalidated data
+ * @has_policy:		The policy-db is valid and should be used
+ *
+ * An enpoint offers access to a bus; the default device node name is "bus".
+ * Additional custom endpoints to the same bus can be created and they can
+ * carry their own policies/filters.
+ */
+struct kdbus_ep {
+	struct kdbus_node node;
+	struct kdbus_bus *bus;
+	u64 id;
+	struct list_head conn_list;
+	struct mutex lock;
+	struct kdbus_domain_user *user;
+	struct kdbus_policy_db policy_db;
+
+	bool has_policy : 1;
+};
+
+#define kdbus_ep_from_node(_node) container_of((_node), \
+					       struct kdbus_ep, \
+					       node)
+
+struct kdbus_ep *kdbus_ep_new(struct kdbus_bus *bus, const char *name,
+			      unsigned int access, kuid_t uid, kgid_t gid,
+			      bool policy);
+struct kdbus_ep *kdbus_ep_ref(struct kdbus_ep *ep);
+struct kdbus_ep *kdbus_ep_unref(struct kdbus_ep *ep);
+int kdbus_ep_activate(struct kdbus_ep *ep);
+void kdbus_ep_deactivate(struct kdbus_ep *ep);
+
+int kdbus_ep_policy_set(struct kdbus_ep *ep,
+			const struct kdbus_item *items,
+			size_t items_size);
+
+int kdbus_ep_policy_check_see_access_unlocked(struct kdbus_ep *ep,
+					      struct kdbus_conn *conn,
+					      const char *name);
+int kdbus_ep_policy_check_see_access(struct kdbus_ep *ep,
+				     struct kdbus_conn *conn,
+				     const char *name);
+int kdbus_ep_policy_check_notification(struct kdbus_ep *ep,
+				       struct kdbus_conn *conn,
+				       const struct kdbus_kmsg *kmsg);
+int kdbus_ep_policy_check_src_names(struct kdbus_ep *ep,
+				    struct kdbus_conn *conn_src,
+				    struct kdbus_conn *conn_dst);
+int kdbus_ep_policy_check_talk_access(struct kdbus_ep *ep,
+				      struct kdbus_conn *conn_src,
+				      struct kdbus_conn *conn_dst);
+int kdbus_ep_policy_check_broadcast(struct kdbus_ep *ep,
+				    struct kdbus_conn *conn_src,
+				    struct kdbus_conn *conn_dst);
+int kdbus_ep_policy_check_own_access(struct kdbus_ep *ep,
+				     const struct kdbus_conn *conn,
+				     const char *name);
+
+#endif
-- 
2.1.3
