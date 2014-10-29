From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add code for buses, domains and endpoints
Date: Wed, 29 Oct 2014 15:00:52 -0700
Message-ID: <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org, gregkh@linuxfoundation.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, teg@jklm.no
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

Add the logic to handle the following entities:

Domain:
  A domain is a named object containing a number of buses. A
  system container that contains its own init system and
  users usually also runs in its own kdbus domain. The
  /dev/kdbus/domain/<container-name>/ directory shows up inside
  the domain as /dev/kdbus/. Every domain offers its own "control"
  device node to create new buses or new sub-domains.  Domains have
  no connection to each other and cannot see nor talk to each
  other. See section 5 for more details.

Bus:
  A bus is a named object inside a domain. Clients exchange messages
  over a bus. Multiple buses themselves have no connection to each
  other; messages can only be exchanged on the same bus. The default
  entry point to a bus, where clients establish the connection to, is
  the "bus" device node /dev/kdbus/<bus name>/bus.  Common operating
  system setups create one "system bus" per system, and one "user
  bus" for every logged-in user. Applications or services may create
  their own private named buses. See section 5 for more details.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/kdbus/bus.c      | 450 +++++++++++++++++++++++++++++++++
 drivers/misc/kdbus/bus.h      | 107 ++++++++
 drivers/misc/kdbus/domain.c   | 477 +++++++++++++++++++++++++++++++++++
 drivers/misc/kdbus/domain.h   | 105 ++++++++
 drivers/misc/kdbus/endpoint.c | 567 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/kdbus/endpoint.h |  94 +++++++
 6 files changed, 1800 insertions(+)
 create mode 100644 drivers/misc/kdbus/bus.c
 create mode 100644 drivers/misc/kdbus/bus.h
 create mode 100644 drivers/misc/kdbus/domain.c
 create mode 100644 drivers/misc/kdbus/domain.h
 create mode 100644 drivers/misc/kdbus/endpoint.c
 create mode 100644 drivers/misc/kdbus/endpoint.h

diff --git a/drivers/misc/kdbus/bus.c b/drivers/misc/kdbus/bus.c
new file mode 100644
index 000000000000..6dcaf22f5d59
--- /dev/null
+++ b/drivers/misc/kdbus/bus.c
@@ -0,0 +1,450 @@
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
+#include "metadata.h"
+#include "names.h"
+#include "policy.h"
+
+/**
+ * kdbus_bus_cred_is_privileged() - check whether the given credentials in
+ *				    combination with the capabilities of the
+ *				    current thead are privileged on the bus
+ * @bus:		The bus to check
+ * @cred:		The credentials to match
+ *
+ * Return: true if the credentials are privileged, otherwise false.
+ */
+bool kdbus_bus_cred_is_privileged(const struct kdbus_bus *bus,
+				  const struct cred *cred)
+{
+	/* Capabilities are *ALWAYS* tested against the current thread, they're
+	 * never remembered from conn-credentials. */
+	if (ns_capable(&init_user_ns, CAP_IPC_OWNER))
+		return true;
+
+	return uid_eq(bus->uid_owner, cred->fsuid);
+}
+
+/**
+ * kdbus_bus_uid_is_privileged() - check whether the current user is a
+ *				   priviledged bus user
+ * @bus:		The bus to check
+ *
+ * Return: true if the current user has CAP_IPC_OWNER capabilities, or
+ * if it has the same UID as the user that created the bus. Otherwise,
+ * false is returned.
+ */
+bool kdbus_bus_uid_is_privileged(const struct kdbus_bus *bus)
+{
+	return kdbus_bus_cred_is_privileged(bus, current_cred());
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
+	kref_get(&bus->kref);
+	return bus;
+}
+
+static void __kdbus_bus_free(struct kref *kref)
+{
+	struct kdbus_bus *bus = container_of(kref, struct kdbus_bus, kref);
+
+	BUG_ON(!bus->disconnected);
+	BUG_ON(!list_empty(&bus->ep_list));
+	BUG_ON(!list_empty(&bus->monitors_list));
+	BUG_ON(!hash_empty(bus->conn_hash));
+
+	kdbus_notify_free(bus);
+	atomic_dec(&bus->user->buses);
+	kdbus_domain_user_unref(bus->user);
+	kdbus_name_registry_free(bus->name_registry);
+	kdbus_domain_unref(bus->domain);
+	kdbus_policy_db_clear(&bus->policy_db);
+	kdbus_meta_free(bus->meta);
+	kfree(bus->name);
+	kfree(bus);
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
+	if (!bus)
+		return NULL;
+
+	kref_put(&bus->kref, __kdbus_bus_free);
+	return NULL;
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
+ * kdbus_bus_disconnect() - disconnect a bus
+ * @bus:		The kdbus reference
+ *
+ * The passed bus will be disconnected and the associated endpoint will be
+ * unref'ed.
+ */
+void kdbus_bus_disconnect(struct kdbus_bus *bus)
+{
+	mutex_lock(&bus->lock);
+	if (bus->disconnected) {
+		mutex_unlock(&bus->lock);
+		return;
+	}
+	bus->disconnected = true;
+	mutex_unlock(&bus->lock);
+
+	/* disconnect from domain */
+	mutex_lock(&bus->domain->lock);
+	list_del(&bus->domain_entry);
+	mutex_unlock(&bus->domain->lock);
+
+	/* disconnect all endpoints attached to this bus */
+	for (;;) {
+		struct kdbus_ep *ep;
+
+		mutex_lock(&bus->lock);
+		ep = list_first_entry_or_null(&bus->ep_list,
+					      struct kdbus_ep,
+					      bus_entry);
+		if (!ep) {
+			mutex_unlock(&bus->lock);
+			break;
+		}
+
+		/* take reference, release lock, disconnect without lock */
+		kdbus_ep_ref(ep);
+		mutex_unlock(&bus->lock);
+
+		kdbus_ep_disconnect(ep);
+		kdbus_ep_unref(ep);
+	}
+
+	/* drop reference for our "bus" endpoint after we disconnected */
+	bus->ep = kdbus_ep_unref(bus->ep);
+}
+
+static struct kdbus_bus *kdbus_bus_find(struct kdbus_domain *domain,
+					const char *name)
+{
+	struct kdbus_bus *bus = NULL;
+	struct kdbus_bus *b;
+
+	mutex_lock(&domain->lock);
+	list_for_each_entry(b, &domain->bus_list, domain_entry) {
+		if (strcmp(b->name, name))
+			continue;
+
+		bus = kdbus_bus_ref(b);
+		break;
+	}
+	mutex_unlock(&domain->lock);
+
+	return bus;
+}
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
+	struct kdbus_bus *bus = conn->bus;
+	struct kdbus_pool_slice *slice;
+	struct kdbus_info info = {};
+	int ret;
+
+	info.size = sizeof(info) + bus->meta->size;
+	info.id = bus->id;
+	info.flags = bus->bus_flags;
+
+	if (!kdbus_meta_ns_eq(conn->meta, bus->meta))
+		return -EPERM;
+
+	ret = kdbus_pool_slice_alloc(conn->pool, &slice, info.size);
+	if (ret < 0)
+		return ret;
+
+	ret = kdbus_pool_slice_copy(slice, 0, &info, sizeof(info));
+	if (ret < 0)
+		goto exit_free_slice;
+
+	ret = kdbus_pool_slice_copy(slice, sizeof(info), bus->meta->data,
+				    bus->meta->size);
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
+
+/**
+ * kdbus_bus_new() - create a new bus
+ * @domain:		The domain to work on
+ * @make:		Pointer to a struct kdbus_cmd_make containing the
+ *			details for the bus creation
+ * @name:		Name of the bus
+ * @bloom:		Bloom parameters for this bus
+ * @mode:		The access mode for the device node
+ * @uid:		The uid of the device node
+ * @gid:		The gid of the device node
+ * @bus:		Pointer to a reference where the new bus is stored
+ *
+ * This function will allocate a new kdbus_bus and link it to the given
+ * domain.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_bus_new(struct kdbus_domain *domain,
+		  const struct kdbus_cmd_make *make,
+		  const char *name,
+		  const struct kdbus_bloom_parameter *bloom,
+		  umode_t mode, kuid_t uid, kgid_t gid,
+		  struct kdbus_bus **bus)
+{
+	struct kdbus_bus *b;
+	char prefix[16];
+	int ret;
+
+	BUG_ON(*bus);
+
+	/* enforce "$UID-" prefix */
+	snprintf(prefix, sizeof(prefix), "%u-",
+		 from_kuid(current_user_ns(), uid));
+	if (strncmp(name, prefix, strlen(prefix) != 0))
+		return -EINVAL;
+
+	b = kdbus_bus_find(domain, name);
+	if (b) {
+		kdbus_bus_unref(b);
+		return -EEXIST;
+	}
+
+	b = kzalloc(sizeof(*b), GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	kref_init(&b->kref);
+	b->uid_owner = uid;
+	b->bus_flags = make->flags;
+	b->bloom = *bloom;
+	mutex_init(&b->lock);
+	init_rwsem(&b->conn_rwlock);
+	hash_init(b->conn_hash);
+	INIT_LIST_HEAD(&b->ep_list);
+	INIT_LIST_HEAD(&b->monitors_list);
+	INIT_LIST_HEAD(&b->notify_list);
+	spin_lock_init(&b->notify_lock);
+	mutex_init(&b->notify_flush_lock);
+	atomic64_set(&b->conn_seq_last, 0);
+	b->domain = kdbus_domain_ref(domain);
+	kdbus_policy_db_init(&b->policy_db);
+
+	/* generate unique bus id */
+	generate_random_uuid(b->id128);
+
+	/* cache the metadata/credentials of the creator */
+	ret = kdbus_meta_new(&b->meta);
+	if (ret < 0)
+		return ret;
+
+	ret = kdbus_meta_append(b->meta, NULL, 0,
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
+		goto exit_free;
+
+	b->name = kstrdup(name, GFP_KERNEL);
+	if (!b->name) {
+		ret = -ENOMEM;
+		goto exit_free;
+	}
+
+	ret = kdbus_name_registry_new(&b->name_registry);
+	if (ret < 0)
+		goto exit_free_name;
+
+	ret = kdbus_ep_new(b, "bus", mode, uid, gid, false, &b->ep);
+	if (ret < 0)
+		goto exit_free_reg;
+
+	/* link into domain */
+	mutex_lock(&domain->lock);
+	if (domain->disconnected) {
+		ret = -ESHUTDOWN;
+		goto exit_unref_user_unlock;
+	}
+
+	/* account the bus against the user */
+	ret = kdbus_domain_get_user_unlocked(domain, uid, &b->user);
+	if (ret < 0)
+		goto exit_unref_user_unlock;
+
+	if (!capable(CAP_IPC_OWNER) &&
+	    atomic_inc_return(&b->user->buses) > KDBUS_USER_MAX_BUSES) {
+		atomic_dec(&b->user->buses);
+		ret = -EMFILE;
+		goto exit_unref_user_unlock;
+	}
+
+	b->id = ++domain->bus_seq_last;
+	list_add_tail(&b->domain_entry, &domain->bus_list);
+	mutex_unlock(&domain->lock);
+
+	*bus = b;
+	return 0;
+
+exit_unref_user_unlock:
+	mutex_unlock(&domain->lock);
+	kdbus_domain_user_unref(b->user);
+	kdbus_ep_disconnect(b->ep);
+	kdbus_ep_unref(b->ep);
+exit_free_reg:
+	kdbus_name_registry_free(b->name_registry);
+exit_free_name:
+	kfree(b->name);
+exit_free:
+	kdbus_meta_free(b->meta);
+	kdbus_policy_db_clear(&b->policy_db);
+	kdbus_domain_unref(b->domain);
+	kfree(b);
+	return ret;
+}
+
+/**
+ * kdbus_bus_make_user() - create a kdbus_cmd_make from user-supplied data
+ * @make:		Reference to the location where to store the result
+ * @name:		Shortcut to the requested name
+ * @bloom:		Bloom parameters for this bus
+ *
+ * This function is part of the connection ioctl() interface and will parse
+ * the user-supplied data.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_bus_make_user(const struct kdbus_cmd_make *make,
+			char **name, struct kdbus_bloom_parameter *bloom)
+{
+	const struct kdbus_item *item;
+	const char *n = NULL;
+	const struct kdbus_bloom_parameter *bl = NULL;
+
+	KDBUS_ITEMS_FOREACH(item, make->items, KDBUS_ITEMS_SIZE(make, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_MAKE_NAME:
+			if (n)
+				return -EEXIST;
+
+			n = item->str;
+			break;
+
+		case KDBUS_ITEM_BLOOM_PARAMETER:
+			if (bl)
+				return -EEXIST;
+
+			bl = &item->bloom_parameter;
+			break;
+		}
+	}
+
+	if (!n || !bl)
+		return -EBADMSG;
+
+	if (bl->size < 8 || bl->size > KDBUS_BUS_BLOOM_MAX_SIZE)
+		return -EINVAL;
+	if (!KDBUS_IS_ALIGNED8(bl->size))
+		return -EINVAL;
+	if (bl->n_hash < 1)
+		return -EINVAL;
+
+	*name = (char *)n;
+	*bloom = *bl;
+	return 0;
+}
diff --git a/drivers/misc/kdbus/bus.h b/drivers/misc/kdbus/bus.h
new file mode 100644
index 000000000000..fd9d8431b886
--- /dev/null
+++ b/drivers/misc/kdbus/bus.h
@@ -0,0 +1,107 @@
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
+#include <linux/kref.h>
+#include <linux/rwsem.h>
+
+#include "policy.h"
+#include "util.h"
+
+/**
+ * struct kdbus_bus - bus in a domain
+ * @kref:		Reference count
+ * @disconnected:	Invalidated data
+ * @uid_owner:		The uid of the owner of the bus
+ * @domain:		Domain of this bus
+ * @name:		The bus name
+ * @id:			ID of this bus in the domain
+ * @lock:		Bus data lock
+ * @ep:			Default "bus" endpoint
+ * @ep_seq_last:	Last used endpoint id sequence number
+ * @conn_seq_last:	Last used connection id sequence number
+ * @ep_list:		Endpoints on this bus
+ * @bus_flags:		Simple pass-through flags from userspace to userspace
+ * @name_registry:	Name registry of this bus
+ * @domain_entry:	Entry in domain
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
+	struct kref kref;
+	bool disconnected;
+	kuid_t uid_owner;
+	struct kdbus_domain *domain;
+	const char *name;
+	u64 id;
+	struct mutex lock;
+	struct kdbus_ep *ep;
+	u64 ep_seq_last;
+	atomic64_t conn_seq_last;
+	struct list_head ep_list;
+	u64 bus_flags;
+	struct kdbus_name_registry *name_registry;
+	struct list_head domain_entry;
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
+int kdbus_bus_make_user(const struct kdbus_cmd_make *make,
+			char **name, struct kdbus_bloom_parameter *bloom);
+int kdbus_bus_new(struct kdbus_domain *domain,
+		  const struct kdbus_cmd_make *make,
+		  const char *name,
+		  const struct kdbus_bloom_parameter *bloom,
+		  umode_t mode, kuid_t uid, kgid_t gid,
+		  struct kdbus_bus **bus);
+int kdbus_cmd_bus_creator_info(struct kdbus_conn *conn,
+			       struct kdbus_cmd_info *cmd_info);
+struct kdbus_bus *kdbus_bus_ref(struct kdbus_bus *bus);
+struct kdbus_bus *kdbus_bus_unref(struct kdbus_bus *bus);
+void kdbus_bus_disconnect(struct kdbus_bus *bus);
+
+bool kdbus_bus_cred_is_privileged(const struct kdbus_bus *bus,
+				  const struct cred *cred);
+bool kdbus_bus_uid_is_privileged(const struct kdbus_bus *bus);
+struct kdbus_conn *kdbus_bus_find_conn_by_id(struct kdbus_bus *bus, u64 id);
+#endif
diff --git a/drivers/misc/kdbus/domain.c b/drivers/misc/kdbus/domain.c
new file mode 100644
index 000000000000..eb2ce720f686
--- /dev/null
+++ b/drivers/misc/kdbus/domain.c
@@ -0,0 +1,477 @@
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
+/* previous domain id sequence number */
+static atomic64_t kdbus_domain_seq_last;
+
+/* kdbus sysfs subsystem */
+struct bus_type kdbus_subsys = {
+	.name = KBUILD_MODNAME,
+};
+
+/* control nodes are world accessible */
+static char *kdbus_devnode_control(struct device *dev, umode_t *mode,
+				   kuid_t *uid, kgid_t *gid)
+{
+	struct kdbus_domain *domain = container_of(dev, struct kdbus_domain,
+						   dev);
+
+	if (mode)
+		*mode = domain->mode;
+
+	return NULL;
+}
+
+static void kdbus_dev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+static struct device_type kdbus_devtype_control = {
+	.name		= "control",
+	.release	= kdbus_dev_release,
+	.devnode	= kdbus_devnode_control,
+};
+
+/**
+ * kdbus_domain_ref() - take a domain reference
+ * @domain:		Domain
+ *
+ * Return: the domain itself
+ */
+struct kdbus_domain *kdbus_domain_ref(struct kdbus_domain *domain)
+{
+	get_device(&domain->dev);
+	return domain;
+}
+
+/**
+ * kdbus_domain_disconnect() - invalidate a domain
+ * @domain:		Domain
+ */
+void kdbus_domain_disconnect(struct kdbus_domain *domain)
+{
+	mutex_lock(&domain->lock);
+	if (domain->disconnected) {
+		mutex_unlock(&domain->lock);
+		return;
+	}
+	domain->disconnected = true;
+	mutex_unlock(&domain->lock);
+
+	/* disconnect from parent domain */
+	if (domain->parent) {
+		mutex_lock(&domain->parent->lock);
+		list_del(&domain->domain_entry);
+		mutex_unlock(&domain->parent->lock);
+	}
+
+	if (device_is_registered(&domain->dev))
+		device_del(&domain->dev);
+
+	kdbus_minor_set(domain->dev.devt, KDBUS_MINOR_CONTROL, NULL);
+
+	/* disconnect all sub-domains */
+	for (;;) {
+		struct kdbus_domain *dom;
+
+		mutex_lock(&domain->lock);
+		dom = list_first_entry_or_null(&domain->domain_list,
+					       struct kdbus_domain,
+					       domain_entry);
+		if (!dom) {
+			mutex_unlock(&domain->lock);
+			break;
+		}
+
+		/* take reference, release lock, disconnect without lock */
+		kdbus_domain_ref(dom);
+		mutex_unlock(&domain->lock);
+
+		kdbus_domain_disconnect(dom);
+		kdbus_domain_unref(dom);
+	}
+
+	/* disconnect all buses in this domain */
+	for (;;) {
+		struct kdbus_bus *bus;
+
+		mutex_lock(&domain->lock);
+		bus = list_first_entry_or_null(&domain->bus_list,
+					       struct kdbus_bus,
+					       domain_entry);
+		if (!bus) {
+			mutex_unlock(&domain->lock);
+			break;
+		}
+
+		/* take reference, release lock, disconnect without lock */
+		kdbus_bus_ref(bus);
+		mutex_unlock(&domain->lock);
+
+		kdbus_bus_disconnect(bus);
+		kdbus_bus_unref(bus);
+	}
+}
+
+static void __kdbus_domain_free(struct device *dev)
+{
+	struct kdbus_domain *domain = container_of(dev, struct kdbus_domain,
+						   dev);
+
+	BUG_ON(!domain->disconnected);
+	BUG_ON(!list_empty(&domain->domain_list));
+	BUG_ON(!list_empty(&domain->bus_list));
+	BUG_ON(!hash_empty(domain->user_hash));
+
+	kdbus_minor_free(domain->dev.devt);
+	kdbus_domain_unref(domain->parent);
+	idr_destroy(&domain->user_idr);
+	kfree(domain->name);
+	kfree(domain->devpath);
+	kfree(domain);
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
+		put_device(&domain->dev);
+	return NULL;
+}
+
+static struct kdbus_domain *kdbus_domain_find(struct kdbus_domain *parent,
+					      const char *name)
+{
+	struct kdbus_domain *n;
+
+	list_for_each_entry(n, &parent->domain_list, domain_entry)
+		if (!strcmp(n->name, name))
+			return n;
+
+	return NULL;
+}
+
+/**
+ * kdbus_domain_new() - create a new domain
+ * @parent:		Parent domain, NULL for initial one
+ * @name:		Name of the domain, NULL for the initial one
+ * @mode:		The access mode for the "control" device node
+ * @domain:		The returned domain
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int kdbus_domain_new(struct kdbus_domain *parent, const char *name,
+		     umode_t mode, struct kdbus_domain **domain)
+{
+	struct kdbus_domain *d;
+	int ret;
+
+	BUG_ON(*domain);
+
+	if ((parent && !name) || (!parent && name))
+		return -EINVAL;
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return -ENOMEM;
+
+	d->disconnected = true;
+	INIT_LIST_HEAD(&d->bus_list);
+	INIT_LIST_HEAD(&d->domain_list);
+	d->mode = mode;
+	mutex_init(&d->lock);
+	atomic64_set(&d->msg_seq_last, 0);
+	idr_init(&d->user_idr);
+
+	device_initialize(&d->dev);
+	d->dev.bus = &kdbus_subsys;
+	d->dev.type = &kdbus_devtype_control;
+	d->dev.release = __kdbus_domain_free;
+
+	/* compose name and path of base directory in /dev */
+	if (parent) {
+		d->devpath = kasprintf(GFP_KERNEL, "%s/domain/%s",
+				       parent->devpath, name);
+		if (!d->devpath) {
+			ret = -ENOMEM;
+			goto exit_put;
+		}
+
+		d->name = kstrdup(name, GFP_KERNEL);
+		if (!d->name) {
+			ret = -ENOMEM;
+			goto exit_put;
+		}
+	} else {
+		/* initial domain */
+		d->devpath = kstrdup(KBUILD_MODNAME, GFP_KERNEL);
+		if (!d->devpath) {
+			ret = -ENOMEM;
+			goto exit_put;
+		}
+	}
+
+	ret = dev_set_name(&d->dev, "%s/control", d->devpath);
+	if (ret < 0)
+		goto exit_put;
+
+	ret = kdbus_minor_alloc(KDBUS_MINOR_CONTROL, NULL, &d->dev.devt);
+	if (ret < 0)
+		goto exit_put;
+
+	if (parent) {
+		/* lock order: parent domain -> domain */
+		mutex_lock(&parent->lock);
+
+		if (parent->disconnected) {
+			mutex_unlock(&parent->lock);
+			ret = -ESHUTDOWN;
+			goto exit_put;
+		}
+
+		if (kdbus_domain_find(parent, name)) {
+			mutex_unlock(&parent->lock);
+			ret = -EEXIST;
+			goto exit_put;
+		}
+
+		d->parent = kdbus_domain_ref(parent);
+		list_add_tail(&d->domain_entry, &parent->domain_list);
+	}
+
+	d->id = atomic64_inc_return(&kdbus_domain_seq_last);
+
+	/*
+	 * We have to mark the domain as enabled _before_ running device_add().
+	 * Otherwise, there's a race between UEVENT_ADD (generated by
+	 * device_add()) and us enabling the minor.
+	 * However, this means user-space can open the minor before we called
+	 * device_add(). This is fine, as we never require the device to be
+	 * registered, anyway.
+	 */
+
+	d->disconnected = false;
+	kdbus_minor_set_control(d->dev.devt, d);
+
+	ret = device_add(&d->dev);
+
+	if (parent)
+		mutex_unlock(&parent->lock);
+
+	if (ret < 0) {
+		kdbus_domain_disconnect(d);
+		kdbus_domain_unref(d);
+		return ret;
+	}
+
+	*domain = d;
+	return 0;
+
+exit_put:
+	put_device(&d->dev);
+	return ret;
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
+ * kdbus_domain_get_user_unlocked() - get a kdbus_domain_user object
+ * @domain:		The domain of the user
+ * @uid:		The uid of the user; INVALID_UID for an
+ *			anonymous user like a custom endpoint
+ * @user:		Pointer to a reference where the accounted
+ *			domain user will be stored.
+ *
+ * Return: 0 on success, negative errno on failure.
+ *
+ * If there is a uid matching, then use the already accounted
+ * kdbus_domain_user, increment its reference counter and
+ * return it in the @user argument. Otherwise allocate a new one,
+ * link it into the domain and return it.
+ */
+int kdbus_domain_get_user_unlocked(struct kdbus_domain *domain,
+				   kuid_t uid,
+				   struct kdbus_domain_user **user)
+{
+	int ret;
+	struct kdbus_domain_user *tmp_user;
+	struct kdbus_domain_user *u = NULL;
+
+	BUG_ON(!mutex_is_locked(&domain->lock));
+
+	/* find uid and reference it */
+	if (uid_valid(uid)) {
+		hash_for_each_possible(domain->user_hash, tmp_user,
+				       hentry, __kuid_val(uid)) {
+			if (!uid_eq(tmp_user->uid, uid))
+				continue;
+
+			u = kdbus_domain_user_ref(tmp_user);
+			goto out;
+		}
+	}
+
+	ret = -ENOMEM;
+	u = kzalloc(sizeof(*u), GFP_KERNEL);
+	if (!u)
+		return ret;
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
+out:
+	*user = u;
+	return 0;
+
+exit_free:
+	kdbus_domain_unref(u->domain);
+	kfree(u);
+	return ret;
+}
+
+/**
+ * kdbus_domain_get_user() - get a kdbus_domain_user object
+ * @domain:		The domain of the user
+ * @uid:		The uid of the user; INVALID_UID for an
+ *			anonymous user like a custom endpoint
+ * @user:		Pointer to a reference where the accounted
+ *			domain user will be stored.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_domain_get_user(struct kdbus_domain *domain,
+			  kuid_t uid,
+			  struct kdbus_domain_user **user)
+{
+	int ret = -ESHUTDOWN;
+
+	mutex_lock(&domain->lock);
+	if (!domain->disconnected)
+		ret = kdbus_domain_get_user_unlocked(domain, uid, user);
+	mutex_unlock(&domain->lock);
+
+	return ret;
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
+ * kdbus_domain_user_unref() - drop a domain user eference
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
diff --git a/drivers/misc/kdbus/domain.h b/drivers/misc/kdbus/domain.h
new file mode 100644
index 000000000000..f51cdb56e83a
--- /dev/null
+++ b/drivers/misc/kdbus/domain.h
@@ -0,0 +1,105 @@
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
+#include <linux/device.h>
+#include <linux/hashtable.h>
+#include <linux/idr.h>
+
+/**
+ * struct kdbus_domain - domain for buses
+ * @dev:		Underlying device
+ * @disconnected:	Invalidated data
+ * @name:		Name of the domain
+ * @devpath:		/dev base directory path
+ * @parent:		Parent domain
+ * @id:			Global id of this domain
+ * @mode:		Device node access mode
+ * @lock:		Domain data lock
+ * @bus_seq_last:	Last used bus id sequence number
+ * @msg_seq_last:	Last used message id sequence number
+ * @domain_list:	List of child domains
+ * @domain_entry:	Entry in parent domain
+ * @bus_list:		Buses in this domain
+ * @user_hash:		Accounting of user resources
+ * @user_idr:		Map of all users; smallest possible index
+ *
+ * A domain provides a "control" device node. Every domain has its
+ * own major number for its endpoint device nodes.
+ *
+ * The initial domain is created at initialization time, is unnamed and
+ * stays around for forver.
+ *
+ * A domain is created by opening the "control" device node of the
+ * parent domain and issuing the KDBUS_CMD_DOMAIN_MAKE iotcl. Closing this
+ * file immediately destroys the entire domain.
+ */
+struct kdbus_domain {
+	struct device dev;
+	bool disconnected;
+	const char *name;
+	const char *devpath;
+	struct kdbus_domain *parent;
+	u64 id;
+	umode_t mode;
+	struct mutex lock;
+	u64 bus_seq_last;
+	atomic64_t msg_seq_last;
+	struct list_head domain_list;
+	struct list_head domain_entry;
+	struct list_head bus_list;
+	DECLARE_HASHTABLE(user_hash, 6);
+	struct idr user_idr;
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
+extern struct bus_type kdbus_subsys;
+
+struct kdbus_domain *kdbus_domain_ref(struct kdbus_domain *domain);
+struct kdbus_domain *kdbus_domain_unref(struct kdbus_domain *domain);
+void kdbus_domain_disconnect(struct kdbus_domain *domain);
+int kdbus_domain_new(struct kdbus_domain *parent, const char *name,
+		     umode_t mode, struct kdbus_domain **domain);
+
+int kdbus_domain_get_user_unlocked(struct kdbus_domain *domain,
+				   kuid_t uid,
+				   struct kdbus_domain_user **user);
+
+int kdbus_domain_get_user(struct kdbus_domain *domain,
+			  kuid_t uid,
+			  struct kdbus_domain_user **user);
+
+struct kdbus_domain_user *kdbus_domain_user_ref(struct kdbus_domain_user *u);
+struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u);
+#endif
diff --git a/drivers/misc/kdbus/endpoint.c b/drivers/misc/kdbus/endpoint.c
new file mode 100644
index 000000000000..830436067c0c
--- /dev/null
+++ b/drivers/misc/kdbus/endpoint.c
@@ -0,0 +1,567 @@
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
+/* endpoints are by default owned by the bus owner */
+static char *kdbus_devnode_ep(struct device *dev, umode_t *mode,
+			      kuid_t *uid, kgid_t *gid)
+{
+	struct kdbus_ep *ep = container_of(dev, struct kdbus_ep, dev);
+
+	if (mode)
+		*mode = ep->mode;
+	if (uid)
+		*uid = ep->uid;
+	if (gid)
+		*gid = ep->gid;
+
+	return NULL;
+}
+
+static void kdbus_dev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+static struct device_type kdbus_devtype_ep = {
+	.name		= "endpoint",
+	.release	= kdbus_dev_release,
+	.devnode	= kdbus_devnode_ep,
+};
+
+struct kdbus_ep *kdbus_ep_ref(struct kdbus_ep *ep)
+{
+	get_device(&ep->dev);
+	return ep;
+}
+
+/**
+ * kdbus_ep_disconnect() - disconnect an endpoint
+ * @ep:			Endpoint
+ */
+void kdbus_ep_disconnect(struct kdbus_ep *ep)
+{
+	mutex_lock(&ep->lock);
+	if (ep->disconnected) {
+		mutex_unlock(&ep->lock);
+		return;
+	}
+	ep->disconnected = true;
+	mutex_unlock(&ep->lock);
+
+	/* disconnect from bus */
+	mutex_lock(&ep->bus->lock);
+	list_del(&ep->bus_entry);
+	mutex_unlock(&ep->bus->lock);
+
+	if (device_is_registered(&ep->dev))
+		device_del(&ep->dev);
+
+	kdbus_minor_set(ep->dev.devt, KDBUS_MINOR_EP, NULL);
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
+static void __kdbus_ep_free(struct device *dev)
+{
+	struct kdbus_ep *ep = container_of(dev, struct kdbus_ep, dev);
+
+	BUG_ON(!ep->disconnected);
+	BUG_ON(!list_empty(&ep->conn_list));
+
+	kdbus_policy_db_clear(&ep->policy_db);
+	kdbus_minor_free(ep->dev.devt);
+	kdbus_bus_unref(ep->bus);
+	kdbus_domain_user_unref(ep->user);
+	kfree(ep->name);
+	kfree(ep);
+}
+
+struct kdbus_ep *kdbus_ep_unref(struct kdbus_ep *ep)
+{
+	if (ep)
+		put_device(&ep->dev);
+	return NULL;
+}
+
+static struct kdbus_ep *kdbus_ep_find(struct kdbus_bus *bus, const char *name)
+{
+	struct kdbus_ep *e;
+
+	list_for_each_entry(e, &bus->ep_list, bus_entry)
+		if (!strcmp(e->name, name))
+			return e;
+
+	return NULL;
+}
+
+/**
+ * kdbus_ep_new() - create a new endpoint
+ * @bus:		The bus this endpoint will be created for
+ * @name:		The name of the endpoint
+ * @mode:		The access mode for the device node
+ * @uid:		The uid of the device node
+ * @gid:		The gid of the device node
+ * @policy:		Whether or not the endpoint should have a policy db
+ * @ep:			Pointer to a reference where the new endpoint is stored
+ *
+ * This function will create a new enpoint with the given
+ * name and properties for a given bus.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_ep_new(struct kdbus_bus *bus, const char *name,
+		 umode_t mode, kuid_t uid, kgid_t gid,
+		 bool policy, struct kdbus_ep **ep)
+{
+	struct kdbus_ep *e;
+	int ret;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+
+	e->disconnected = true;
+	mutex_init(&e->lock);
+	INIT_LIST_HEAD(&e->conn_list);
+	kdbus_policy_db_init(&e->policy_db);
+	e->uid = uid;
+	e->gid = gid;
+	e->mode = mode;
+	e->has_policy = policy;
+
+	device_initialize(&e->dev);
+	e->dev.bus = &kdbus_subsys;
+	e->dev.type = &kdbus_devtype_ep;
+	e->dev.release = __kdbus_ep_free;
+
+	e->name = kstrdup(name, GFP_KERNEL);
+	if (!e->name) {
+		ret = -ENOMEM;
+		goto exit_put;
+	}
+
+	ret = dev_set_name(&e->dev, "%s/%s/%s",
+			   bus->domain->devpath, bus->name, name);
+	if (ret < 0)
+		goto exit_put;
+
+	ret = kdbus_minor_alloc(KDBUS_MINOR_EP, NULL, &e->dev.devt);
+	if (ret < 0)
+		goto exit_put;
+
+	mutex_lock(&bus->lock);
+
+	if (bus->disconnected) {
+		mutex_unlock(&bus->lock);
+		ret = -ESHUTDOWN;
+		goto exit_put;
+	}
+
+	if (kdbus_ep_find(bus, name)) {
+		mutex_unlock(&bus->lock);
+		ret = -EEXIST;
+		goto exit_put;
+	}
+
+	e->bus = kdbus_bus_ref(bus);
+	list_add_tail(&e->bus_entry, &bus->ep_list);
+
+	e->id = ++bus->ep_seq_last;
+
+	/*
+	 * Same as with domains, we have to mark it enabled _before_ running
+	 * device_add() to avoid messing with state after UEVENT_ADD was sent.
+	 */
+
+	e->disconnected = false;
+	kdbus_minor_set_ep(e->dev.devt, e);
+
+	ret = device_add(&e->dev);
+
+	mutex_unlock(&bus->lock);
+
+	if (ret < 0) {
+		kdbus_ep_disconnect(e);
+		kdbus_ep_unref(e);
+		return ret;
+	}
+
+	if (ep)
+		*ep = e;
+	return 0;
+
+exit_put:
+	put_device(&e->dev);
+	return ret;
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
+						     conn, name);
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
+	if (kdbus_bus_cred_is_privileged(conn_src->bus, conn_src->cred))
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
+	ret = kdbus_policy_check_talk_access(&ep->bus->policy_db,
+					     conn_src, conn_dst);
+	if (ret < 0)
+		return ret;
+
+	return 0;
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
+	ret = kdbus_policy_check_talk_access(&ep->bus->policy_db,
+					     conn_src, conn_dst);
+	if (ret < 0)
+		return ret;
+
+	return 0;
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
+		ret = kdbus_policy_check_own_access(&ep->policy_db, conn, name);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (kdbus_bus_cred_is_privileged(conn->bus, conn->cred))
+		return 0;
+
+	ret = kdbus_policy_check_own_access(&ep->bus->policy_db, conn, name);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
diff --git a/drivers/misc/kdbus/endpoint.h b/drivers/misc/kdbus/endpoint.h
new file mode 100644
index 000000000000..19cb2d30d093
--- /dev/null
+++ b/drivers/misc/kdbus/endpoint.h
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
+#ifndef __KDBUS_ENDPOINT_H
+#define __KDBUS_ENDPOINT_H
+
+#include <linux/device.h>
+#include "limits.h"
+#include "names.h"
+#include "policy.h"
+#include "util.h"
+
+/*
+ * struct kdbus_endpoint - enpoint to access a bus
+ * @dev:		Device
+ * @bus:		Bus behind this endpoint
+ * @name:		Name of the endpoint
+ * @id:			ID of this endpoint on the bus
+ * @mode:		File mode of this endpoint device node
+ * @uid:		UID owning this endpoint
+ * @gid:		GID owning this endpoint
+ * @conn_list:		Connections of this endpoint
+ * @bus_entry:		bus' endpoints
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
+	struct device dev;
+	struct kdbus_bus *bus;
+	const char *name;
+	u64 id;
+	umode_t mode;
+	kuid_t uid;
+	kgid_t gid;
+	struct list_head conn_list;
+	struct list_head bus_entry;
+	struct mutex lock;
+	struct kdbus_domain_user *user;
+	struct kdbus_policy_db policy_db;
+
+	bool disconnected : 1;
+	bool has_policy : 1;
+};
+
+int kdbus_ep_new(struct kdbus_bus *bus, const char *name,
+		 umode_t mode, kuid_t uid, kgid_t gid,
+		 bool policy, struct kdbus_ep **ep);
+struct kdbus_ep *kdbus_ep_ref(struct kdbus_ep *ep);
+struct kdbus_ep *kdbus_ep_unref(struct kdbus_ep *ep);
+void kdbus_ep_disconnect(struct kdbus_ep *ep);
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
2.1.2
