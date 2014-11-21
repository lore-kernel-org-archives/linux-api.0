From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add connection, queue handling and message validation code
Date: Thu, 20 Nov 2014 21:02:21 -0800
Message-ID: <1416546149-24799-6-git-send-email-gregkh@linuxfoundation.org>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

This patch adds code to create and destroy connections, to validate
incoming messages and to maintain the queue of messages that are
associated with a connection.

Note that connection and queue have a 1:1 relation, the code is only
split in two parts for cleaner separation and better readability.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/kdbus/connection.c | 1838 ++++++++++++++++++++++++++++++++++++++++++++++++
 ipc/kdbus/connection.h |  188 +++++
 ipc/kdbus/item.c       |  258 +++++++
 ipc/kdbus/item.h       |   41 ++
 ipc/kdbus/message.c    |  444 ++++++++++++
 ipc/kdbus/message.h    |   75 ++
 ipc/kdbus/queue.c      |  608 ++++++++++++++++
 ipc/kdbus/queue.h      |   93 +++
 ipc/kdbus/util.h       |    2 +-
 9 files changed, 3546 insertions(+), 1 deletion(-)
 create mode 100644 ipc/kdbus/connection.c
 create mode 100644 ipc/kdbus/connection.h
 create mode 100644 ipc/kdbus/item.c
 create mode 100644 ipc/kdbus/item.h
 create mode 100644 ipc/kdbus/message.c
 create mode 100644 ipc/kdbus/message.h
 create mode 100644 ipc/kdbus/queue.c
 create mode 100644 ipc/kdbus/queue.h

diff --git a/ipc/kdbus/connection.c b/ipc/kdbus/connection.c
new file mode 100644
index 000000000000..73d149eecc25
--- /dev/null
+++ b/ipc/kdbus/connection.c
@@ -0,0 +1,1838 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/audit.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/hashtable.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/math64.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/shmem_fs.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+#include "bus.h"
+#include "connection.h"
+#include "endpoint.h"
+#include "match.h"
+#include "message.h"
+#include "metadata.h"
+#include "names.h"
+#include "domain.h"
+#include "item.h"
+#include "notify.h"
+#include "policy.h"
+#include "util.h"
+#include "queue.h"
+
+#define KDBUS_CONN_ACTIVE_BIAS (INT_MIN + 1)
+
+/**
+ * struct kdbus_conn_reply - an entry of kdbus_conn's list of replies
+ * @kref:		Ref-count of this object
+ * @entry:		The entry of the connection's reply_list
+ * @reply_dst:		The connection the reply will be sent to (method origin)
+ * @queue_entry:	The queue enty item that is prepared by the replying
+ *			connection
+ * @deadline_ns:	The deadline of the reply, in nanoseconds
+ * @cookie:		The cookie of the requesting message
+ * @name_id:		ID of the well-known name the original msg was sent to
+ * @sync:		The reply block is waiting for synchronous I/O
+ * @waiting:		The condition to synchronously wait for
+ * @interrupted:	The sync reply was left in an interrupted state
+ * @err:		The error code for the synchronous reply
+ */
+struct kdbus_conn_reply {
+	struct kref kref;
+	struct list_head entry;
+	struct kdbus_conn *reply_dst;
+	struct kdbus_queue_entry *queue_entry;
+	u64 deadline_ns;
+	u64 cookie;
+	u64 name_id;
+	bool sync:1;
+	bool waiting:1;
+	bool interrupted:1;
+	int err;
+};
+
+static struct kdbus_conn_reply *
+kdbus_conn_reply_new(struct kdbus_conn *reply_dst,
+		     const struct kdbus_msg *msg,
+		     struct kdbus_name_entry *name_entry)
+{
+	bool sync = msg->flags & KDBUS_MSG_FLAGS_SYNC_REPLY;
+	struct kdbus_conn_reply *r;
+	int ret = 0;
+
+	if (atomic_inc_return(&reply_dst->reply_count) >
+	    KDBUS_CONN_MAX_REQUESTS_PENDING) {
+		ret = -EMLINK;
+		goto exit_dec_reply_count;
+	}
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r) {
+		ret = -ENOMEM;
+		goto exit_dec_reply_count;
+	}
+
+	kref_init(&r->kref);
+	r->reply_dst = kdbus_conn_ref(reply_dst);
+	r->cookie = msg->cookie;
+	r->name_id = name_entry ? name_entry->name_id : 0;
+	r->deadline_ns = msg->timeout_ns;
+
+	if (sync) {
+		r->sync = true;
+		r->waiting = true;
+	}
+
+exit_dec_reply_count:
+	if (ret < 0) {
+		atomic_dec(&reply_dst->reply_count);
+		return ERR_PTR(ret);
+	}
+
+	return r;
+}
+
+static void __kdbus_conn_reply_free(struct kref *kref)
+{
+	struct kdbus_conn_reply *reply =
+		container_of(kref, struct kdbus_conn_reply, kref);
+
+	atomic_dec(&reply->reply_dst->reply_count);
+	kdbus_conn_unref(reply->reply_dst);
+	kfree(reply);
+}
+
+static struct kdbus_conn_reply*
+kdbus_conn_reply_ref(struct kdbus_conn_reply *r)
+{
+	if (r)
+		kref_get(&r->kref);
+	return r;
+}
+
+static struct kdbus_conn_reply*
+kdbus_conn_reply_unref(struct kdbus_conn_reply *r)
+{
+	if (r)
+		kref_put(&r->kref, __kdbus_conn_reply_free);
+	return NULL;
+}
+
+static void kdbus_conn_reply_sync(struct kdbus_conn_reply *reply, int err)
+{
+	BUG_ON(!reply->sync);
+
+	list_del_init(&reply->entry);
+	reply->waiting = false;
+	reply->err = err;
+	wake_up_interruptible(&reply->reply_dst->wait);
+}
+
+/*
+ * Check for maximum number of messages per individual user. This
+ * should prevent a single user from being able to fill the receiver's
+ * queue.
+ */
+static int kdbus_conn_queue_user_quota(const struct kdbus_conn *conn_src,
+				       struct kdbus_conn *conn_dst,
+				       struct kdbus_queue_entry *entry)
+{
+	struct kdbus_domain_user *user;
+
+	if (!conn_src)
+		return 0;
+
+	/*
+	 * Per-user accounting can be expensive if we have many different
+	 * users on the bus. Allow one set of messages to pass through
+	 * un-accounted. Only once we hit that limit, we start accounting.
+	 */
+	if (conn_dst->queue.msg_count < KDBUS_CONN_MAX_MSGS_PER_USER)
+		return 0;
+
+	user = conn_src->user;
+
+	/* extend array to store the user message counters */
+	if (user->idr >= conn_dst->msg_users_max) {
+		unsigned int *users;
+		unsigned int i;
+
+		i = 8 + KDBUS_ALIGN8(user->idr);
+		users = krealloc(conn_dst->msg_users, i * sizeof(unsigned int),
+				 GFP_KERNEL | __GFP_ZERO);
+		if (!users)
+			return -ENOMEM;
+
+		conn_dst->msg_users = users;
+		conn_dst->msg_users_max = i;
+	}
+
+	if (conn_dst->msg_users[user->idr] >= KDBUS_CONN_MAX_MSGS_PER_USER)
+		return -ENOBUFS;
+
+	conn_dst->msg_users[user->idr]++;
+	entry->user = kdbus_domain_user_ref(user);
+	return 0;
+}
+
+static void kdbus_conn_work(struct work_struct *work)
+{
+	struct kdbus_conn *conn;
+	struct kdbus_conn_reply *reply, *reply_tmp;
+	u64 deadline = ~0ULL;
+	struct timespec64 ts;
+	u64 now;
+
+	conn = container_of(work, struct kdbus_conn, work.work);
+	ktime_get_ts64(&ts);
+	now = timespec64_to_ns(&ts);
+
+	mutex_lock(&conn->lock);
+	if (!kdbus_conn_active(conn)) {
+		mutex_unlock(&conn->lock);
+		return;
+	}
+
+	list_for_each_entry_safe(reply, reply_tmp, &conn->reply_list, entry) {
+		/*
+		 * If the reply block is waiting for synchronous I/O,
+		 * the timeout is handled by wait_event_*_timeout(),
+		 * so we don't have to care for it here.
+		 */
+		if (reply->sync && !reply->interrupted)
+			continue;
+
+		if (reply->deadline_ns > now) {
+			/* remember next timeout */
+			if (deadline > reply->deadline_ns)
+				deadline = reply->deadline_ns;
+
+			continue;
+		}
+
+		/*
+		 * A zero deadline means the connection died, was
+		 * cleaned up already and the notification was sent.
+		 * Don't send notifications for reply trackers that were
+		 * left in an interrupted syscall state.
+		 */
+		if (reply->deadline_ns != 0 && !reply->interrupted)
+			kdbus_notify_reply_timeout(conn->ep->bus,
+						   reply->reply_dst->id,
+						   reply->cookie);
+
+		list_del_init(&reply->entry);
+		kdbus_conn_reply_unref(reply);
+	}
+
+	/* rearm delayed work with next timeout */
+	if (deadline != ~0ULL)
+		schedule_delayed_work(&conn->work,
+				      nsecs_to_jiffies(deadline - now));
+
+	mutex_unlock(&conn->lock);
+
+	kdbus_notify_flush(conn->ep->bus);
+}
+
+/**
+ * kdbus_cmd_msg_recv() - receive a message from the queue
+ * @conn:		Connection to work on
+ * @recv:		The command as passed in by the ioctl
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int kdbus_cmd_msg_recv(struct kdbus_conn *conn,
+		       struct kdbus_cmd_recv *recv)
+{
+	struct kdbus_queue_entry *entry = NULL;
+	unsigned int lost_count;
+	int ret = 0;
+
+	if (recv->offset > 0)
+		return -EINVAL;
+
+	mutex_lock(&conn->lock);
+	entry = kdbus_queue_entry_peek(&conn->queue, recv->priority,
+				       recv->flags & KDBUS_RECV_USE_PRIORITY);
+	if (IS_ERR(entry)) {
+		ret = PTR_ERR(entry);
+		goto exit_unlock;
+	}
+
+	/*
+	 * Make sure to never install fds into a connection that has
+	 * refused to receive any.
+	 */
+	if (WARN_ON(!(conn->flags & KDBUS_HELLO_ACCEPT_FD) &&
+		    entry->fds_count > 0)) {
+		ret = -EINVAL;
+		goto exit_unlock;
+	}
+
+	/* just drop the message */
+	if (recv->flags & KDBUS_RECV_DROP) {
+		bool reply_found = false;
+
+		if (entry->reply) {
+			struct kdbus_conn_reply *r;
+
+			/*
+			 * Walk the list of pending replies and see if the
+			 * one attached to this entry item is stil there.
+			 * It might have been removed by an incoming reply,
+			 * and we currently don't track reply entries in that
+			 * direction in order to prevent potentially dangling
+			 * pointers.
+			 */
+			list_for_each_entry(r, &conn->reply_list, entry) {
+				if (r == entry->reply) {
+					reply_found = true;
+					break;
+				}
+			}
+		}
+
+		if (reply_found) {
+			if (entry->reply->sync) {
+				kdbus_conn_reply_sync(entry->reply, -EPIPE);
+			} else {
+				list_del_init(&entry->reply->entry);
+				kdbus_conn_reply_unref(entry->reply);
+				kdbus_notify_reply_dead(conn->ep->bus,
+							entry->src_id,
+							entry->cookie);
+			}
+		}
+
+		kdbus_queue_entry_remove(conn, entry);
+		kdbus_pool_slice_free(entry->slice);
+
+		/* Free the resources of this entry */
+		kdbus_queue_entry_free(entry);
+
+		goto exit_unlock;
+	}
+
+	/*
+	 * If there have been lost broadcast messages, report the number
+	 * in the overloaded recv->dropped_msgs field and return -EOVERFLOW.
+	 */
+	lost_count = atomic_read(&conn->lost_count);
+	if (lost_count) {
+		recv->dropped_msgs = lost_count;
+		atomic_sub(lost_count, &conn->lost_count);
+		ret = -EOVERFLOW;
+		goto exit_unlock;
+	}
+
+	/* Give the offset back to the caller. */
+	recv->offset = kdbus_pool_slice_offset(entry->slice);
+
+	/*
+	 * Just return the location of the next message. Do not install
+	 * file descriptors or anything else. This is usually used to
+	 * determine the sender of the next queued message.
+	 *
+	 * File descriptor numbers referenced in the message items
+	 * are undefined, they are only valid with the full receive
+	 * not with peek.
+	 */
+	if (recv->flags & KDBUS_RECV_PEEK) {
+		kdbus_pool_slice_flush(entry->slice);
+		goto exit_unlock;
+	}
+
+	ret = kdbus_queue_entry_install(entry);
+	kdbus_pool_slice_make_public(entry->slice);
+	kdbus_queue_entry_remove(conn, entry);
+	kdbus_queue_entry_free(entry);
+
+exit_unlock:
+	mutex_unlock(&conn->lock);
+	kdbus_notify_flush(conn->ep->bus);
+	return ret;
+}
+
+/**
+ * kdbus_conn_reply_find() - Find the corresponding reply object
+ * @conn_replying:	The replying connection
+ * @conn_reply_dst:	The connection the reply will be sent to
+ *			(method origin)
+ * @cookie:		The cookie of the requesting message
+ *
+ * Lookup a reply object that should be sent as a reply by
+ * @conn_replying to @conn_reply_dst with the given cookie.
+ *
+ * For optimizations, callers should first check 'reply_count' of
+ * @conn_reply_dst to see if the connection has issued any requests
+ * that are waiting for replies, before calling this function.
+ *
+ * Return: the corresponding reply object or NULL if not found
+ */
+static struct kdbus_conn_reply *
+kdbus_conn_reply_find(struct kdbus_conn *conn_replying,
+		      struct kdbus_conn *conn_reply_dst,
+		      uint64_t cookie)
+{
+	struct kdbus_conn_reply *r;
+	struct kdbus_conn_reply *reply = NULL;
+
+	list_for_each_entry(r, &conn_replying->reply_list, entry) {
+		if (r->reply_dst == conn_reply_dst &&
+		    r->cookie == cookie) {
+			reply = r;
+			break;
+		}
+	}
+
+	return reply;
+}
+
+/**
+ * kdbus_cmd_msg_cancel() - cancel all pending sync requests
+ *			    with the given cookie
+ * @conn:		The connection
+ * @cookie:		The cookie
+ *
+ * Return: 0 on success, or -ENOENT if no pending request with that
+ * cookie was found.
+ */
+int kdbus_cmd_msg_cancel(struct kdbus_conn *conn,
+			 u64 cookie)
+{
+	struct kdbus_conn_reply *reply;
+	struct kdbus_conn *c;
+	int ret = -ENOENT;
+	int i;
+
+	if (atomic_read(&conn->reply_count) == 0)
+		return -ENOENT;
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	down_read(&conn->ep->bus->conn_rwlock);
+	hash_for_each(conn->ep->bus->conn_hash, i, c, hentry) {
+		if (c == conn)
+			continue;
+
+		mutex_lock(&c->lock);
+		reply = kdbus_conn_reply_find(c, conn, cookie);
+		if (reply && reply->sync) {
+			kdbus_conn_reply_sync(reply, -ECANCELED);
+			ret = 0;
+		}
+		mutex_unlock(&c->lock);
+	}
+	up_read(&conn->ep->bus->conn_rwlock);
+
+	return ret;
+}
+
+static int kdbus_conn_check_access(struct kdbus_ep *ep,
+				   const struct kdbus_msg *msg,
+				   struct kdbus_conn *conn_src,
+				   struct kdbus_conn *conn_dst,
+				   struct kdbus_conn_reply **reply_wake)
+{
+	bool allowed = false;
+
+	/*
+	 * Walk the conn_src's list of expected replies. If there's any
+	 * matching entry, allow the message to be sent, and remove it.
+	 *
+	 * If conn_dst did not issue any previous request or if the
+	 * request was canceled then nothing to do, and fallback to
+	 * to a normal permission check
+	 */
+	if (reply_wake && msg->cookie_reply > 0 &&
+	    atomic_read(&conn_dst->reply_count) > 0) {
+		struct kdbus_conn_reply *r;
+
+		mutex_lock(&conn_src->lock);
+		r = kdbus_conn_reply_find(conn_src, conn_dst,
+					  msg->cookie_reply);
+		if (r) {
+			list_del_init(&r->entry);
+			if (r->sync)
+				*reply_wake = kdbus_conn_reply_ref(r);
+			else
+				kdbus_conn_reply_unref(r);
+
+			allowed = true;
+		}
+		mutex_unlock(&conn_src->lock);
+	}
+
+	if (allowed)
+		return 0;
+
+	/* ... otherwise, ask the policy DBs for permission */
+	return kdbus_ep_policy_check_talk_access(ep, conn_src, conn_dst);
+}
+
+/* Callers should take the conn_dst lock */
+static struct kdbus_queue_entry *
+kdbus_conn_entry_make(struct kdbus_conn *conn_src,
+		      struct kdbus_conn *conn_dst,
+		      const struct kdbus_kmsg *kmsg)
+{
+	struct kdbus_queue_entry *entry;
+
+	/* The remote connection was disconnected */
+	if (!kdbus_conn_active(conn_dst))
+		return ERR_PTR(-ECONNRESET);
+
+	/* The connection does not accept file descriptors */
+	if (!(conn_dst->flags & KDBUS_HELLO_ACCEPT_FD) && kmsg->fds_count > 0)
+		return ERR_PTR(-ECOMM);
+
+	entry = kdbus_queue_entry_alloc(conn_src, conn_dst, kmsg);
+	if (IS_ERR(entry))
+		return entry;
+
+	return entry;
+}
+
+/*
+ * Synchronously responding to a message, allocate a queue entry
+ * and attach it to the reply tracking object.
+ * The connection's queue will never get to see it.
+ */
+static int kdbus_conn_entry_sync_attach(struct kdbus_conn *conn_src,
+					struct kdbus_conn *conn_dst,
+					const struct kdbus_kmsg *kmsg,
+					struct kdbus_conn_reply *reply_wake)
+{
+	struct kdbus_queue_entry *entry;
+	int remote_ret;
+	int ret = 0;
+
+	mutex_lock(&conn_dst->lock);
+
+	/*
+	 * If we are still waiting then proceed, allocate a queue
+	 * entry and attach it to the reply object
+	 */
+	if (reply_wake->waiting) {
+		entry = kdbus_conn_entry_make(conn_src, conn_dst, kmsg);
+		if (IS_ERR(entry))
+			ret = PTR_ERR(entry);
+		else
+			/* Attach the entry to the reply object */
+			reply_wake->queue_entry = entry;
+	} else {
+		ret = -ECONNRESET;
+	}
+
+	/*
+	 * Update the reply object and wake up remote peer only
+	 * on appropriate return codes
+	 *
+	 * * -ECOMM: if the replying connection failed with -ECOMM
+	 *           then wakeup remote peer with -EREMOTEIO
+	 *
+	 *           We do this to differenciate between -ECOMM errors
+	 *           from the original sender perspective:
+	 *           -ECOMM error during the sync send and
+	 *           -ECOMM error during the sync reply, this last
+	 *           one is rewritten to -EREMOTEIO
+	 *
+	 * * Wake up on all other return codes.
+	 */
+	remote_ret = ret;
+
+	if (ret == -ECOMM)
+		remote_ret = -EREMOTEIO;
+
+	kdbus_conn_reply_sync(reply_wake, remote_ret);
+	kdbus_conn_reply_unref(reply_wake);
+
+	mutex_unlock(&conn_dst->lock);
+
+	return ret;
+}
+
+/**
+ * kdbus_conn_entry_insert - enqueue a message into the receiver's pool
+ * @conn_src:		The sending connection
+ * @conn_dst:		The connection to queue into
+ * @kmsg:		The kmag to queue
+ * @reply:		The reply tracker to attach to the queue entry
+ *
+ * Return: 0 on success. negative error otherwise.
+ */
+int kdbus_conn_entry_insert(struct kdbus_conn *conn_src,
+			    struct kdbus_conn *conn_dst,
+			    const struct kdbus_kmsg *kmsg,
+			    struct kdbus_conn_reply *reply)
+{
+	struct kdbus_queue_entry *entry;
+	int ret;
+
+	mutex_lock(&conn_dst->lock);
+
+	/* limit the maximum number of queued messages */
+	if (conn_dst->queue.msg_count > KDBUS_CONN_MAX_MSGS) {
+		ret = -ENOBUFS;
+		goto exit_unlock;
+	}
+
+	/* Get a queue entry for src and dst pairs */
+	entry = kdbus_conn_entry_make(conn_src, conn_dst, kmsg);
+	if (IS_ERR(entry)) {
+		ret = PTR_ERR(entry);
+		goto exit_unlock;
+	}
+
+	/* limit the number of queued messages from the same individual user */
+	ret = kdbus_conn_queue_user_quota(conn_src, conn_dst, entry);
+	if (ret < 0)
+		goto exit_queue_free;
+
+	/*
+	 * Remember the the reply associated with this queue entry, so we can
+	 * move the reply entry's connection when a connection moves from an
+	 * activator to an implementor.
+	 */
+	entry->reply = reply;
+
+	if (reply) {
+		list_add(&reply->entry, &conn_dst->reply_list);
+		if (!reply->sync)
+			schedule_delayed_work(&conn_dst->work, 0);
+	}
+
+	/* link the message into the receiver's entry */
+	kdbus_queue_entry_add(&conn_dst->queue, entry);
+	mutex_unlock(&conn_dst->lock);
+
+	/* wake up poll() */
+	wake_up_interruptible(&conn_dst->wait);
+	return 0;
+
+exit_queue_free:
+	kdbus_queue_entry_free(entry);
+exit_unlock:
+	mutex_unlock(&conn_dst->lock);
+	return ret;
+}
+
+static void kdbus_conn_eavesdrop(struct kdbus_bus *bus,
+				 struct kdbus_conn *conn,
+				 struct kdbus_kmsg *kmsg)
+{
+	struct kdbus_conn *c;
+	int ret;
+
+	/*
+	 * Monitor connections get all messages; ignore possible errors
+	 * when sending messages to monitor connections.
+	 */
+
+	down_read(&bus->conn_rwlock);
+	list_for_each_entry(c, &bus->monitors_list, monitor_entry) {
+		/*
+		 * The first monitor which requests additional
+		 * metadata causes the message to carry it; all
+		 * monitors after that will see all of the added
+		 * data, even when they did not ask for it.
+		 */
+		if (conn) {
+			ret = kdbus_kmsg_attach_metadata(kmsg, conn, c);
+			if (ret < 0)
+				break;
+		}
+
+		kdbus_conn_entry_insert(NULL, c, kmsg, NULL);
+	}
+	up_read(&bus->conn_rwlock);
+}
+
+static int kdbus_conn_wait_reply(struct kdbus_conn *conn_src,
+				 struct kdbus_conn *conn_dst,
+				 struct kdbus_msg *msg,
+				 struct kdbus_conn_reply *reply_wait,
+				 u64 timeout_ns)
+{
+	struct kdbus_queue_entry *entry;
+	int r, ret;
+
+	/*
+	 * Block until the reply arrives. reply_wait is left untouched
+	 * by the timeout scans that might be conducted for other,
+	 * asynchronous replies of conn_src.
+	 */
+	r = wait_event_interruptible_timeout(reply_wait->reply_dst->wait,
+		!reply_wait->waiting || !kdbus_conn_active(conn_src),
+		nsecs_to_jiffies(timeout_ns));
+	if (r < 0) {
+		/*
+		 * Interrupted system call. Unref the reply object, and
+		 * pass the return value down the chain. Mark the reply as
+		 * interrupted, so the cleanup work can remove it, but do
+		 * not unlink it from the list. Once the syscall restarts,
+		 * we'll pick it up and wait on it again.
+		 */
+		mutex_lock(&conn_dst->lock);
+		reply_wait->interrupted = true;
+		schedule_delayed_work(&conn_dst->work, 0);
+		mutex_unlock(&conn_dst->lock);
+
+		return r;
+	}
+
+	if (r == 0)
+		ret = -ETIMEDOUT;
+	else if (!kdbus_conn_active(conn_src))
+		ret = -ECONNRESET;
+	else
+		ret = reply_wait->err;
+
+	mutex_lock(&conn_dst->lock);
+	list_del_init(&reply_wait->entry);
+	mutex_unlock(&conn_dst->lock);
+
+	mutex_lock(&conn_src->lock);
+	reply_wait->waiting = false;
+	entry = reply_wait->queue_entry;
+	if (entry) {
+		if (ret == 0)
+			ret = kdbus_queue_entry_install(entry);
+
+		msg->offset_reply = kdbus_pool_slice_offset(entry->slice);
+		kdbus_pool_slice_make_public(entry->slice);
+		kdbus_queue_entry_free(entry);
+	}
+	mutex_unlock(&conn_src->lock);
+
+	kdbus_conn_reply_unref(reply_wait);
+
+	return ret;
+}
+
+/**
+ * kdbus_conn_kmsg_send() - send a message
+ * @ep:			Endpoint to send from
+ * @conn_src:		Connection, kernel-generated messages do not have one
+ * @kmsg:		Message to send
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int kdbus_conn_kmsg_send(struct kdbus_ep *ep,
+			 struct kdbus_conn *conn_src,
+			 struct kdbus_kmsg *kmsg)
+{
+	struct kdbus_conn_reply *reply_wait = NULL;
+	struct kdbus_conn_reply *reply_wake = NULL;
+	struct kdbus_name_entry *name_entry = NULL;
+	struct kdbus_msg *msg = &kmsg->msg;
+	struct kdbus_conn *conn_dst = NULL;
+	struct kdbus_bus *bus = ep->bus;
+	bool sync = msg->flags & KDBUS_MSG_FLAGS_SYNC_REPLY;
+	int ret = 0;
+
+	/* assign domain-global message sequence number */
+	BUG_ON(kmsg->seq > 0);
+	kmsg->seq = atomic64_inc_return(&bus->domain->msg_seq_last);
+
+	/* non-kernel senders append credentials/metadata */
+	if (conn_src) {
+		/*
+		 * If a connection has installed faked credentials when it was
+		 * created, make sure only those are sent out as attachments
+		 * of messages, and nothing that is gathered at retrieved from
+		 * 'current' at the time of sending.
+		 *
+		 * Hence, in such cases, duplicate the connection's owner_meta,
+		 * and take care not to augment it by attaching any new items.
+		 */
+		if (conn_src->owner_meta)
+			kmsg->meta = kdbus_meta_dup(conn_src->owner_meta);
+		else
+			kmsg->meta = kdbus_meta_new();
+
+		if (IS_ERR(kmsg->meta)) {
+			ret = PTR_ERR(kmsg->meta);
+			kmsg->meta = NULL;
+			return ret;
+		}
+	}
+
+	if (msg->dst_id == KDBUS_DST_ID_BROADCAST) {
+		kdbus_bus_broadcast(bus, conn_src, kmsg);
+		return 0;
+	}
+
+	if (kmsg->dst_name) {
+		name_entry = kdbus_name_lock(bus->name_registry,
+					     kmsg->dst_name);
+		if (!name_entry)
+			return -ESRCH;
+
+		/*
+		 * If both a name and a connection ID are given as destination
+		 * of a message, check that the currently owning connection of
+		 * the name matches the specified ID.
+		 * This way, we allow userspace to send the message to a
+		 * specific connection by ID only if the connection currently
+		 * owns the given name.
+		 */
+		if (msg->dst_id != KDBUS_DST_ID_NAME &&
+		    msg->dst_id != name_entry->conn->id) {
+			ret = -EREMCHG;
+			goto exit_name_unlock;
+		}
+
+		if (!name_entry->conn && name_entry->activator)
+			conn_dst = kdbus_conn_ref(name_entry->activator);
+		else
+			conn_dst = kdbus_conn_ref(name_entry->conn);
+
+		if ((msg->flags & KDBUS_MSG_FLAGS_NO_AUTO_START) &&
+		     kdbus_conn_is_activator(conn_dst)) {
+			ret = -EADDRNOTAVAIL;
+			goto exit_unref;
+		}
+	} else {
+		/* unicast message to unique name */
+		conn_dst = kdbus_bus_find_conn_by_id(bus, msg->dst_id);
+		if (!conn_dst)
+			return -ENXIO;
+
+		/*
+		 * Special-purpose connections are not allowed to be addressed
+		 * via their unique IDs.
+		 */
+		if (!kdbus_conn_is_ordinary(conn_dst)) {
+			ret = -ENXIO;
+			goto exit_unref;
+		}
+	}
+
+	/*
+	 * Record the sequence number of the registered name;
+	 * it will be passed on to the queue, in case messages
+	 * addressed to a name need to be moved from or to
+	 * activator connections of the same name.
+	 */
+	if (name_entry)
+		kmsg->dst_name_id = name_entry->name_id;
+
+	if (conn_src) {
+		/*
+		 * If we got here due to an interrupted system call, our reply
+		 * wait object is still queued on conn_dst, with the former
+		 * cookie. Look it up, and in case it exists, go dormant right
+		 * away again, and don't queue the message again.
+		 *
+		 * We also need to make sure that conn_src did really
+		 * issue a request or if the request did not get
+		 * canceled on the way before looking up any reply
+		 * object.
+		 */
+		if (sync && atomic_read(&conn_src->reply_count) > 0) {
+			mutex_lock(&conn_dst->lock);
+			reply_wait = kdbus_conn_reply_find(conn_dst,
+							   conn_src,
+							   kmsg->msg.cookie);
+			if (reply_wait) {
+				/* It was interrupted */
+				if (reply_wait->interrupted)
+					reply_wait->interrupted = false;
+				else
+					reply_wait = NULL;
+			}
+			mutex_unlock(&conn_dst->lock);
+
+			if (reply_wait)
+				goto wait_sync;
+		}
+
+		ret = kdbus_kmsg_attach_metadata(kmsg, conn_src, conn_dst);
+		if (ret < 0)
+			goto exit_unref;
+
+		if (msg->flags & KDBUS_MSG_FLAGS_EXPECT_REPLY) {
+			ret = kdbus_conn_check_access(ep, msg, conn_src,
+						      conn_dst, NULL);
+			if (ret < 0)
+				goto exit_unref;
+
+			reply_wait = kdbus_conn_reply_new(conn_src, msg,
+							  name_entry);
+			if (IS_ERR(reply_wait)) {
+				ret = PTR_ERR(reply_wait);
+				goto exit_unref;
+			}
+		} else {
+			ret = kdbus_conn_check_access(ep, msg, conn_src,
+						      conn_dst, &reply_wake);
+			if (ret < 0)
+				goto exit_unref;
+		}
+	}
+
+	if (reply_wake) {
+		/*
+		 * If we're synchronously responding to a message, allocate a
+		 * queue item and attach it to the reply tracking object.
+		 * The connection's queue will never get to see it.
+		 */
+		ret = kdbus_conn_entry_sync_attach(conn_src, conn_dst,
+						   kmsg, reply_wake);
+		if (ret < 0)
+			goto exit_unref;
+	} else {
+		/*
+		 * Otherwise, put it in the queue and wait for the connection
+		 * to dequeue and receive the message.
+		 */
+		ret = kdbus_conn_entry_insert(conn_src, conn_dst,
+					      kmsg, reply_wait);
+		if (ret < 0) {
+			if (reply_wait)
+				kdbus_conn_reply_unref(reply_wait);
+			goto exit_unref;
+		}
+	}
+
+	/* forward to monitors */
+	kdbus_conn_eavesdrop(bus, conn_src, kmsg);
+
+wait_sync:
+	/* no reason to keep names locked for replies */
+	name_entry = kdbus_name_unlock(bus->name_registry, name_entry);
+
+	if (sync) {
+		struct timespec64 ts;
+		u64 now, timeout;
+
+		BUG_ON(!reply_wait);
+
+		ktime_get_ts64(&ts);
+		now = timespec64_to_ns(&ts);
+
+		if (unlikely(msg->timeout_ns <= now))
+			timeout = 0;
+		else
+			timeout = msg->timeout_ns - now;
+
+		ret = kdbus_conn_wait_reply(conn_src, conn_dst, msg,
+					    reply_wait, timeout);
+	}
+
+exit_unref:
+	kdbus_conn_unref(conn_dst);
+exit_name_unlock:
+	kdbus_name_unlock(bus->name_registry, name_entry);
+
+	return ret;
+}
+
+/**
+ * kdbus_conn_disconnect() - disconnect a connection
+ * @conn:		The connection to disconnect
+ * @ensure_queue_empty:	Flag to indicate if the call should fail in
+ *			case the connection's message list is not
+ *			empty
+ *
+ * If @ensure_msg_list_empty is true, and the connection has pending messages,
+ * -EBUSY is returned.
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int kdbus_conn_disconnect(struct kdbus_conn *conn, bool ensure_queue_empty)
+{
+	struct kdbus_conn_reply *reply, *reply_tmp;
+	struct kdbus_queue_entry *entry, *tmp;
+	LIST_HEAD(reply_list);
+
+	mutex_lock(&conn->lock);
+	if (!kdbus_conn_active(conn)) {
+		mutex_unlock(&conn->lock);
+		return -EALREADY;
+	}
+
+	if (ensure_queue_empty && !list_empty(&conn->queue.msg_list)) {
+		mutex_unlock(&conn->lock);
+		return -EBUSY;
+	}
+
+	atomic_add(KDBUS_CONN_ACTIVE_BIAS, &conn->active);
+	mutex_unlock(&conn->lock);
+
+	wake_up_interruptible(&conn->wait);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	rwsem_acquire(&conn->dep_map, 0, 0, _RET_IP_);
+	if (atomic_read(&conn->active) != KDBUS_CONN_ACTIVE_BIAS)
+		lock_contended(&conn->dep_map, _RET_IP_);
+#endif
+
+	wait_event(conn->wait,
+		   atomic_read(&conn->active) == KDBUS_CONN_ACTIVE_BIAS);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lock_acquired(&conn->dep_map, _RET_IP_);
+	rwsem_release(&conn->dep_map, 1, _RET_IP_);
+#endif
+
+	cancel_delayed_work_sync(&conn->work);
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	mutex_lock(&conn->ep->lock);
+	down_write(&conn->ep->bus->conn_rwlock);
+
+	/* remove from bus and endpoint */
+	hash_del(&conn->hentry);
+	list_del(&conn->monitor_entry);
+	list_del(&conn->ep_entry);
+
+	up_write(&conn->ep->bus->conn_rwlock);
+	mutex_unlock(&conn->ep->lock);
+
+	/*
+	 * Remove all names associated with this connection; this possibly
+	 * moves queued messages back to the activator connection.
+	 */
+	kdbus_name_remove_by_conn(conn->ep->bus->name_registry, conn);
+
+	/* if we die while other connections wait for our reply, notify them */
+	mutex_lock(&conn->lock);
+	list_for_each_entry_safe(entry, tmp, &conn->queue.msg_list, entry) {
+		if (entry->reply)
+			kdbus_notify_reply_dead(conn->ep->bus, entry->src_id,
+						entry->cookie);
+
+		kdbus_queue_entry_remove(conn, entry);
+		kdbus_pool_slice_free(entry->slice);
+		kdbus_queue_entry_free(entry);
+	}
+	list_splice_init(&conn->reply_list, &reply_list);
+	mutex_unlock(&conn->lock);
+
+	list_for_each_entry_safe(reply, reply_tmp, &reply_list, entry) {
+		if (reply->sync) {
+			kdbus_conn_reply_sync(reply, -EPIPE);
+			continue;
+		}
+
+		/* send a 'connection dead' notification */
+		kdbus_notify_reply_dead(conn->ep->bus, reply->reply_dst->id,
+					reply->cookie);
+
+		list_del(&reply->entry);
+		kdbus_conn_reply_unref(reply);
+	}
+
+	kdbus_notify_id_change(conn->ep->bus, KDBUS_ITEM_ID_REMOVE,
+			       conn->id, conn->flags);
+
+	kdbus_notify_flush(conn->ep->bus);
+
+	return 0;
+}
+
+/**
+ * kdbus_conn_active() - connection is not disconnected
+ * @conn:		Connection to check
+ *
+ * Return true if the connection was not disconnected, yet. Note that a
+ * connection might be disconnected asynchronously, unless you hold the
+ * connection lock. If that's not suitable for you, see kdbus_conn_acquire() to
+ * suppress connection shutdown for a short period.
+ *
+ * Return: true if the connection is still active
+ */
+bool kdbus_conn_active(const struct kdbus_conn *conn)
+{
+	return atomic_read(&conn->active) >= 0;
+}
+
+/**
+ * kdbus_conn_flush_policy() - flush all cached policy entries that
+ *			       refer to a connecion
+ * @conn:	Connection to check
+ */
+void kdbus_conn_purge_policy_cache(struct kdbus_conn *conn)
+{
+	kdbus_policy_purge_cache(&conn->ep->policy_db, conn);
+	kdbus_policy_purge_cache(&conn->ep->bus->policy_db, conn);
+}
+
+static void __kdbus_conn_free(struct kref *kref)
+{
+	struct kdbus_conn *conn = container_of(kref, struct kdbus_conn, kref);
+
+	BUG_ON(kdbus_conn_active(conn));
+	BUG_ON(delayed_work_pending(&conn->work));
+	BUG_ON(!list_empty(&conn->queue.msg_list));
+	BUG_ON(!list_empty(&conn->names_list));
+	BUG_ON(!list_empty(&conn->names_queue_list));
+	BUG_ON(!list_empty(&conn->reply_list));
+
+	atomic_dec(&conn->user->connections);
+	kdbus_domain_user_unref(conn->user);
+
+	kdbus_conn_purge_policy_cache(conn);
+	kdbus_policy_remove_owner(&conn->ep->bus->policy_db, conn);
+
+	kdbus_meta_free(conn->owner_meta);
+	kdbus_match_db_free(conn->match_db);
+	kdbus_pool_free(conn->pool);
+	kdbus_ep_unref(conn->ep);
+	put_cred(conn->cred);
+	kfree(conn->name);
+	kfree(conn);
+}
+
+/**
+ * kdbus_conn_ref() - take a connection reference
+ * @conn:		Connection
+ *
+ * Return: the connection itself
+ */
+struct kdbus_conn *kdbus_conn_ref(struct kdbus_conn *conn)
+{
+	kref_get(&conn->kref);
+	return conn;
+}
+
+/**
+ * kdbus_conn_unref() - drop a connection reference
+ * @conn:		Connection (may be NULL)
+ *
+ * When the last reference is dropped, the connection's internal structure
+ * is freed.
+ *
+ * Return: NULL
+ */
+struct kdbus_conn *kdbus_conn_unref(struct kdbus_conn *conn)
+{
+	if (conn)
+		kref_put(&conn->kref, __kdbus_conn_free);
+	return NULL;
+}
+
+/**
+ * kdbus_conn_acquire() - acquire an active connection reference
+ * @conn:		Connection
+ *
+ * Users can close a connection via KDBUS_BYEBYE (or by destroying the
+ * endpoint/bus/...) at any time. Whenever this happens, we should deny any
+ * user-visible action on this connection and signal ECONNRESET instead.
+ * To avoid testing for connection availability everytime you take the
+ * connection-lock, you can acquire a connection for short periods.
+ *
+ * By calling kdbus_conn_acquire(), you gain an "active reference" to the
+ * connection. You must also hold a regular reference at any time! As long as
+ * you hold the active-ref, the connection will not be shut down. However, if
+ * the connection was shut down, you can never acquire an active-ref again.
+ *
+ * kdbus_conn_disconnect() disables the connection and then waits for all active
+ * references to be dropped. It will also wake up any pending operation.
+ * However, you must not sleep for an indefinite period while holding an
+ * active-reference. Otherwise, kdbus_conn_disconnect() might stall. If you need
+ * to sleep for an indefinite period, either release the reference and try to
+ * acquire it again after waking up, or make kdbus_conn_disconnect() wake up
+ * your wait-queue.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kdbus_conn_acquire(struct kdbus_conn *conn)
+{
+	if (!atomic_inc_unless_negative(&conn->active))
+		return -ECONNRESET;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	rwsem_acquire_read(&conn->dep_map, 0, 1, _RET_IP_);
+#endif
+
+	return 0;
+}
+
+/**
+ * kdbus_conn_release() - release an active connection reference
+ * @conn:		Connection
+ *
+ * This releases an active reference that has been acquired via
+ * kdbus_conn_acquire(). If the connection was already disabled and this is the
+ * last active-ref that is dropped, the disconnect-waiter will be woken up and
+ * properly close the connection.
+ */
+void kdbus_conn_release(struct kdbus_conn *conn)
+{
+	int v;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	rwsem_release(&conn->dep_map, 1, _RET_IP_);
+#endif
+
+	v = atomic_dec_return(&conn->active);
+	if (v != KDBUS_CONN_ACTIVE_BIAS)
+		return;
+
+	wake_up_all(&conn->wait);
+}
+
+/**
+ * kdbus_conn_move_messages() - move messages from one connection to another
+ * @conn_dst:		Connection to copy to
+ * @conn_src:		Connection to copy from
+ * @name_id:		Filter for the sequence number of the registered
+ *			name, 0 means no filtering.
+ *
+ * Move all messages from one connection to another. This is used when
+ * an implementor connection is taking over/giving back a well-known name
+ * from/to an activator connection.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_conn_move_messages(struct kdbus_conn *conn_dst,
+			     struct kdbus_conn *conn_src,
+			     u64 name_id)
+{
+	struct kdbus_queue_entry *q, *q_tmp;
+	struct kdbus_conn_reply *r, *r_tmp;
+	LIST_HEAD(reply_list);
+	LIST_HEAD(msg_list);
+	int ret = 0;
+
+	BUG_ON(!mutex_is_locked(&conn_dst->ep->bus->lock));
+	BUG_ON(conn_src == conn_dst);
+
+	/* remove all messages from the source */
+	mutex_lock(&conn_src->lock);
+	list_for_each_entry_safe(r, r_tmp, &conn_src->reply_list, entry) {
+		/* filter messages for a specific name */
+		if (name_id > 0 && r->name_id != name_id)
+			continue;
+
+		list_move_tail(&r->entry, &reply_list);
+	}
+	list_for_each_entry_safe(q, q_tmp, &conn_src->queue.msg_list, entry) {
+		/* filter messages for a specific name */
+		if (name_id > 0 && q->dst_name_id != name_id)
+			continue;
+
+		kdbus_queue_entry_remove(conn_src, q);
+
+		if (!(conn_dst->flags & KDBUS_HELLO_ACCEPT_FD) &&
+		    q->fds_count > 0) {
+			atomic_inc(&conn_dst->lost_count);
+			continue;
+		}
+
+		list_add_tail(&q->entry, &msg_list);
+	}
+	mutex_unlock(&conn_src->lock);
+
+	/* insert messages into destination */
+	mutex_lock(&conn_dst->lock);
+	if (!kdbus_conn_active(conn_dst)) {
+		struct kdbus_conn_reply *r, *r_tmp;
+
+		/* our destination connection died, just drop all messages */
+		mutex_unlock(&conn_dst->lock);
+		list_for_each_entry_safe(q, q_tmp, &msg_list, entry)
+			kdbus_queue_entry_free(q);
+		list_for_each_entry_safe(r, r_tmp, &reply_list, entry)
+			kdbus_conn_reply_unref(r);
+		return -ECONNRESET;
+	}
+
+	list_for_each_entry_safe(q, q_tmp, &msg_list, entry) {
+		ret = kdbus_pool_slice_move(conn_src->pool, conn_dst->pool,
+					    &q->slice);
+		if (ret < 0)
+			kdbus_queue_entry_free(q);
+		else
+			kdbus_queue_entry_add(&conn_dst->queue, q);
+	}
+	list_splice(&reply_list, &conn_dst->reply_list);
+	mutex_unlock(&conn_dst->lock);
+
+	/* wake up poll() */
+	wake_up_interruptible(&conn_dst->wait);
+
+	return ret;
+}
+
+/**
+ * kdbus_cmd_info() - retrieve info about a connection
+ * @conn:		Connection
+ * @cmd_info:		The command as passed in by the ioctl
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_cmd_info(struct kdbus_conn *conn,
+		   struct kdbus_cmd_info *cmd_info)
+{
+	struct kdbus_name_entry *entry = NULL;
+	struct kdbus_conn *owner_conn = NULL;
+	struct kdbus_info info = {};
+	struct kdbus_meta *meta = NULL;
+	struct kdbus_pool_slice *slice;
+	u64 extra_flags, attach_flags;
+	size_t pos, meta_size;
+	int ret = 0;
+
+	if (cmd_info->id == 0) {
+		const char *name;
+
+		name = kdbus_items_get_str(cmd_info->items,
+					   KDBUS_ITEMS_SIZE(cmd_info, items),
+					   KDBUS_ITEM_NAME);
+		if (IS_ERR(name))
+			return -EINVAL;
+
+		if (!kdbus_name_is_valid(name, false))
+			return -EINVAL;
+
+		/* check if 'conn' is allowed to see 'name' */
+		ret = kdbus_ep_policy_check_see_access(conn->ep, conn, name);
+		if (ret < 0)
+			return ret;
+
+		entry = kdbus_name_lock(conn->ep->bus->name_registry, name);
+		if (!entry)
+			return -ESRCH;
+		else if (entry->conn)
+			owner_conn = kdbus_conn_ref(entry->conn);
+	} else {
+		owner_conn = kdbus_bus_find_conn_by_id(conn->ep->bus,
+						       cmd_info->id);
+		if (!owner_conn) {
+			ret = -ENXIO;
+			goto exit;
+		}
+
+		/* check if 'conn' is allowed to see any of owner_conn's names*/
+		ret = kdbus_ep_policy_check_src_names(conn->ep, owner_conn,
+						      conn);
+		if (ret < 0)
+			goto exit;
+	}
+
+	info.size = sizeof(info);
+	info.id = owner_conn->id;
+	info.flags = owner_conn->flags;
+
+	/* mask out what information the connection wants to pass us */
+	attach_flags = cmd_info->flags &
+		       atomic64_read(&owner_conn->attach_flags_send);
+
+	meta_size = kdbus_meta_size(owner_conn->meta, conn, &attach_flags);
+	info.size += meta_size;
+
+	/*
+	 * Unlike the rest of the values which are cached at connection
+	 * creation time, some values need to be appended here because
+	 * at creation time a connection does not have names and other
+	 * properties.
+	 */
+	extra_flags = attach_flags & (KDBUS_ATTACH_NAMES |
+				      KDBUS_ATTACH_CONN_DESCRIPTION);
+	if (extra_flags) {
+		meta = kdbus_meta_new();
+		if (IS_ERR(meta)) {
+			ret = PTR_ERR(meta);
+			meta = NULL;
+			goto exit;
+		}
+
+		ret = kdbus_meta_append(meta, conn->ep->bus->domain,
+					owner_conn, 0, extra_flags);
+		if (ret < 0)
+			goto exit;
+
+		info.size += kdbus_meta_size(meta, conn, &extra_flags);
+	}
+
+	slice = kdbus_pool_slice_alloc(conn->pool, info.size);
+	if (IS_ERR(slice)) {
+		ret = PTR_ERR(slice);
+		slice = NULL;
+		goto exit;
+	}
+
+	ret = kdbus_pool_slice_copy(slice, 0, &info, sizeof(info));
+	if (ret < 0)
+		goto exit_free;
+
+	pos = sizeof(info);
+
+	if (meta_size) {
+		ret = kdbus_meta_write(owner_conn->meta, conn,
+				       attach_flags, slice, pos);
+		if (ret < 0)
+			goto exit_free;
+
+		pos += meta_size;
+	}
+
+	if (extra_flags) {
+		ret = kdbus_meta_write(meta, conn, extra_flags, slice, pos);
+		if (ret < 0)
+			goto exit_free;
+	}
+
+	/* write back the offset */
+	cmd_info->offset = kdbus_pool_slice_offset(slice);
+	kdbus_pool_slice_flush(slice);
+	kdbus_pool_slice_make_public(slice);
+
+exit_free:
+	if (ret < 0)
+		kdbus_pool_slice_free(slice);
+
+exit:
+	kdbus_meta_free(meta);
+	kdbus_conn_unref(owner_conn);
+	kdbus_name_unlock(conn->ep->bus->name_registry, entry);
+
+	return ret;
+}
+
+/**
+ * kdbus_cmd_conn_update() - update the attach-flags of a connection or
+ *			     the policy entries of a policy holding one
+ * @conn:		Connection
+ * @cmd:		The command as passed in by the ioctl
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_cmd_conn_update(struct kdbus_conn *conn,
+			  const struct kdbus_cmd_update *cmd)
+{
+	const struct kdbus_item *item;
+	bool policy_provided = false;
+	bool send_flags_provided = false;
+	bool recv_flags_provided = false;
+	u64 attach_flags_send;
+	u64 attach_flags_recv;
+	int ret;
+
+	KDBUS_ITEMS_FOREACH(item, cmd->items, KDBUS_ITEMS_SIZE(cmd, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_ATTACH_FLAGS_SEND:
+		case KDBUS_ITEM_ATTACH_FLAGS_RECV:
+			/*
+			 * Only ordinary or monitor connections
+			 * may update their attach-flags.
+			 */
+			if (!kdbus_conn_is_ordinary(conn) &&
+			    !kdbus_conn_is_monitor(conn))
+				return -EOPNOTSUPP;
+
+			if (item->type == KDBUS_ITEM_ATTACH_FLAGS_SEND) {
+				send_flags_provided = true;
+				attach_flags_send = item->data64[0];
+			} else {
+				recv_flags_provided = true;
+				attach_flags_recv = item->data64[0];
+			}
+			break;
+
+		case KDBUS_ITEM_NAME:
+		case KDBUS_ITEM_POLICY_ACCESS:
+			/*
+			 * Only policy holders may update their policy entries.
+			 */
+			if (!kdbus_conn_is_policy_holder(conn))
+				return -EOPNOTSUPP;
+
+			policy_provided = true;
+			break;
+		}
+	}
+
+	if (policy_provided) {
+		ret = kdbus_policy_set(&conn->ep->bus->policy_db, cmd->items,
+				       KDBUS_ITEMS_SIZE(cmd, items),
+				       1, true, conn);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (send_flags_provided)
+		atomic64_set(&conn->attach_flags_send, attach_flags_send);
+
+	if (recv_flags_provided)
+		atomic64_set(&conn->attach_flags_recv, attach_flags_recv);
+
+	return 0;
+}
+
+/**
+ * kdbus_conn_new() - create a new connection
+ * @ep:			The endpoint the connection is connected to
+ * @hello:		The kdbus_cmd_hello as passed in by the user
+ * @meta:		The metadata gathered at open() time of the handle
+ * @privileged:		Whether to create a privileged connection
+ *
+ * Return: a new kdbus_conn on success, ERR_PTR on failure
+ */
+struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep,
+				  struct kdbus_cmd_hello *hello,
+				  struct kdbus_meta *meta,
+				  bool privileged)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	static struct lock_class_key __key;
+#endif
+	const struct kdbus_creds *creds = NULL;
+	struct kdbus_bus *bus = ep->bus;
+	const struct kdbus_item *item;
+	const char *conn_name = NULL;
+	const char *seclabel = NULL;
+	const char *name = NULL;
+	struct kdbus_conn *conn;
+	size_t seclabel_len = 0;
+	u64 attach_flags_send;
+	u64 attach_flags_recv;
+	bool is_policy_holder;
+	bool is_activator;
+	bool is_monitor;
+	int ret;
+
+	is_monitor = hello->flags & KDBUS_HELLO_MONITOR;
+	is_activator = hello->flags & KDBUS_HELLO_ACTIVATOR;
+	is_policy_holder = hello->flags & KDBUS_HELLO_POLICY_HOLDER;
+
+	/* can't be activator or policy holder and monitor at the same time */
+	if (is_monitor && (is_activator || is_policy_holder))
+		return ERR_PTR(-EINVAL);
+
+	/* can't be policy holder and activator at the same time */
+	if (is_activator && is_policy_holder)
+		return ERR_PTR(-EINVAL);
+
+	/* only privileged connections can activate and monitor */
+	if (!privileged && (is_activator || is_policy_holder || is_monitor))
+		return ERR_PTR(-EPERM);
+
+	KDBUS_ITEMS_FOREACH(item, hello->items,
+			    KDBUS_ITEMS_SIZE(hello, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_NAME:
+			if (!is_activator && !is_policy_holder)
+				return ERR_PTR(-EINVAL);
+
+			if (name)
+				return ERR_PTR(-EINVAL);
+
+			if (!kdbus_name_is_valid(item->str, true))
+				return ERR_PTR(-EINVAL);
+
+			name = item->str;
+			break;
+
+		case KDBUS_ITEM_CREDS:
+			/* privileged processes can impersonate somebody else */
+			if (!privileged)
+				return ERR_PTR(-EPERM);
+
+			if (item->size != KDBUS_ITEM_SIZE(sizeof(*creds)))
+				return ERR_PTR(-EINVAL);
+
+			creds = &item->creds;
+			break;
+
+		case KDBUS_ITEM_SECLABEL:
+			/* privileged processes can impersonate somebody else */
+			if (!privileged)
+				return ERR_PTR(-EPERM);
+
+			seclabel = item->str;
+			seclabel_len = item->size - KDBUS_ITEM_HEADER_SIZE;
+			break;
+
+		case KDBUS_ITEM_CONN_DESCRIPTION:
+			/* human-readable connection name (debugging) */
+			if (conn_name)
+				return ERR_PTR(-EINVAL);
+
+			conn_name = item->str;
+			break;
+		}
+	}
+
+	if ((is_activator || is_policy_holder) && !name)
+		return ERR_PTR(-EINVAL);
+
+	attach_flags_send = hello->attach_flags_send;
+	attach_flags_recv = hello->attach_flags_recv;
+
+	/* 'any' degrades to 'all' for compatibility */
+	if (attach_flags_send == _KDBUS_ATTACH_ANY)
+		attach_flags_send = _KDBUS_ATTACH_ALL;
+
+	if (attach_flags_recv == _KDBUS_ATTACH_ANY)
+		attach_flags_recv = _KDBUS_ATTACH_ALL;
+
+	/* reject unknown attach flags */
+	if (attach_flags_send & ~_KDBUS_ATTACH_ALL)
+		return ERR_PTR(-EINVAL);
+
+	if (attach_flags_recv & ~_KDBUS_ATTACH_ALL)
+		return ERR_PTR(-EINVAL);
+
+	/* Let userspace know which flags are enforced by the bus */
+	hello->attach_flags_send = bus->attach_flags_req | KDBUS_FLAG_KERNEL;
+
+	if (bus->attach_flags_req & ~attach_flags_send)
+		return ERR_PTR(-ECONNREFUSED);
+
+	conn = kzalloc(sizeof(*conn), GFP_KERNEL);
+	if (!conn)
+		return ERR_PTR(-ENOMEM);
+
+	if (is_activator || is_policy_holder) {
+		/*
+		 * Policy holders may install one name, and are
+		 * allowed to use wildcards.
+		 */
+		ret = kdbus_policy_set(&bus->policy_db, hello->items,
+				       KDBUS_ITEMS_SIZE(hello, items),
+				       1, is_policy_holder, conn);
+		if (ret < 0)
+			goto exit_free_conn;
+	}
+
+	if (conn_name) {
+		conn->name = kstrdup(conn_name, GFP_KERNEL);
+		if (!conn->name) {
+			ret = -ENOMEM;
+			goto exit_free_conn;
+		}
+	}
+
+	kref_init(&conn->kref);
+	atomic_set(&conn->active, 0);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_init_map(&conn->dep_map, "s_active", &__key, 0);
+#endif
+	mutex_init(&conn->lock);
+	INIT_LIST_HEAD(&conn->names_list);
+	INIT_LIST_HEAD(&conn->names_queue_list);
+	INIT_LIST_HEAD(&conn->reply_list);
+	atomic_set(&conn->name_count, 0);
+	atomic_set(&conn->reply_count, 0);
+	atomic_set(&conn->lost_count, 0);
+	INIT_DELAYED_WORK(&conn->work, kdbus_conn_work);
+	conn->cred = get_current_cred();
+	init_waitqueue_head(&conn->wait);
+	kdbus_queue_init(&conn->queue);
+	conn->privileged = privileged;
+
+	/* init entry, so we can unconditionally remove it */
+	INIT_LIST_HEAD(&conn->monitor_entry);
+
+	conn->pool = kdbus_pool_new(conn->name, hello->pool_size);
+	if (IS_ERR(conn->pool)) {
+		ret = PTR_ERR(conn->pool);
+		conn->pool = NULL;
+		goto exit_unref_cred;
+	}
+
+	conn->match_db = kdbus_match_db_new();
+	if (IS_ERR(conn->match_db)) {
+		ret = PTR_ERR(conn->match_db);
+		conn->match_db = NULL;
+		goto exit_free_pool;
+	}
+
+	conn->ep = kdbus_ep_ref(ep);
+
+	/* get new id for this connection */
+	conn->id = atomic64_inc_return(&bus->conn_seq_last);
+
+	/* return properties of this connection to the caller */
+	hello->bus_flags = bus->bus_flags;
+	hello->bloom = bus->bloom;
+	hello->id = conn->id;
+
+	BUILD_BUG_ON(sizeof(bus->id128) != sizeof(hello->id128));
+	memcpy(hello->id128, bus->id128, sizeof(hello->id128));
+
+	conn->flags = hello->flags;
+	atomic64_set(&conn->attach_flags_send, attach_flags_send);
+	atomic64_set(&conn->attach_flags_recv, attach_flags_recv);
+
+	if (is_activator) {
+		u64 flags = KDBUS_NAME_ACTIVATOR;
+
+		ret = kdbus_name_acquire(bus->name_registry, conn,
+					 name, &flags);
+		if (ret < 0)
+			goto exit_unref_ep;
+	}
+
+	if (is_monitor) {
+		down_write(&bus->conn_rwlock);
+		list_add_tail(&conn->monitor_entry, &bus->monitors_list);
+		up_write(&bus->conn_rwlock);
+	}
+
+	/* privileged processes can impersonate somebody else */
+	if (creds || seclabel) {
+		conn->owner_meta = kdbus_meta_new();
+		if (IS_ERR(conn->owner_meta)) {
+			ret = PTR_ERR(conn->owner_meta);
+			conn->owner_meta = NULL;
+			goto exit_release_names;
+		}
+
+		if (creds) {
+			ret = kdbus_meta_append_data(conn->owner_meta,
+						     KDBUS_ITEM_CREDS,
+						     creds, sizeof(*creds));
+			if (ret < 0)
+				goto exit_free_meta;
+		}
+
+		if (seclabel) {
+			ret = kdbus_meta_append_data(conn->owner_meta,
+						     KDBUS_ITEM_SECLABEL,
+						     seclabel, seclabel_len);
+			if (ret < 0)
+				goto exit_free_meta;
+		}
+
+		/* use the information provided with the HELLO call */
+		conn->meta = conn->owner_meta;
+	} else {
+		/* use the connection's metadata gathered at open() */
+		conn->meta = meta;
+	}
+
+	/*
+	 * Account the connection against the current user (UID), or for
+	 * custom endpoints use the anonymous user assigned to the endpoint.
+	 */
+	if (ep->user) {
+		conn->user = kdbus_domain_user_ref(ep->user);
+	} else {
+		conn->user = kdbus_domain_get_user(ep->bus->domain,
+						   current_fsuid());
+		if (IS_ERR(conn->user)) {
+			ret = PTR_ERR(conn->user);
+			conn->user = NULL;
+			goto exit_free_meta;
+		}
+	}
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	mutex_lock(&bus->lock);
+	mutex_lock(&ep->lock);
+	down_write(&bus->conn_rwlock);
+
+	if (atomic_inc_return(&conn->user->connections) > KDBUS_USER_MAX_CONN) {
+		atomic_dec(&conn->user->connections);
+		ret = -EMFILE;
+		goto exit_unref_user_unlock;
+	}
+
+	/* make sure the ep-node is active while we add our connection */
+	if (!kdbus_node_acquire(&ep->node)) {
+		atomic_dec(&conn->user->connections);
+		ret = -ESHUTDOWN;
+		goto exit_unref_user_unlock;
+	}
+
+	/* link into bus and endpoint */
+	list_add_tail(&conn->ep_entry, &ep->conn_list);
+	hash_add(bus->conn_hash, &conn->hentry, conn->id);
+
+	kdbus_node_release(&ep->node);
+	up_write(&bus->conn_rwlock);
+	mutex_unlock(&ep->lock);
+	mutex_unlock(&bus->lock);
+
+	/* notify subscribers about the new active connection */
+	ret = kdbus_notify_id_change(conn->ep->bus, KDBUS_ITEM_ID_ADD,
+				     conn->id, conn->flags);
+	if (ret < 0) {
+		atomic_dec(&conn->user->connections);
+		goto exit_domain_user_unref;
+	}
+
+	kdbus_notify_flush(conn->ep->bus);
+
+	return conn;
+
+exit_unref_user_unlock:
+	up_write(&bus->conn_rwlock);
+	mutex_unlock(&ep->lock);
+	mutex_unlock(&bus->lock);
+exit_domain_user_unref:
+	kdbus_domain_user_unref(conn->user);
+exit_free_meta:
+	kdbus_meta_free(conn->owner_meta);
+exit_release_names:
+	kdbus_name_remove_by_conn(bus->name_registry, conn);
+exit_unref_ep:
+	kdbus_ep_unref(conn->ep);
+	kdbus_match_db_free(conn->match_db);
+exit_free_pool:
+	kdbus_pool_free(conn->pool);
+exit_unref_cred:
+	put_cred(conn->cred);
+exit_free_conn:
+	kfree(conn->name);
+	kfree(conn);
+
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_conn_has_name() - check if a connection owns a name
+ * @conn:		Connection
+ * @name:		Well-know name to check for
+ *
+ * Return: true if the name is currently owned by the connection
+ */
+bool kdbus_conn_has_name(struct kdbus_conn *conn, const char *name)
+{
+	struct kdbus_name_entry *e;
+	bool match = false;
+
+	/* No need to go further if we do not own names */
+	if (atomic_read(&conn->name_count) == 0)
+		return false;
+
+	mutex_lock(&conn->lock);
+	list_for_each_entry(e, &conn->names_list, conn_entry) {
+		if (strcmp(e->name, name) == 0) {
+			match = true;
+			break;
+		}
+	}
+	mutex_unlock(&conn->lock);
+
+	return match;
+}
diff --git a/ipc/kdbus/connection.h b/ipc/kdbus/connection.h
new file mode 100644
index 000000000000..cd4cb241cae3
--- /dev/null
+++ b/ipc/kdbus/connection.h
@@ -0,0 +1,188 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel@zonque.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann@gmail.com>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_CONNECTION_H
+#define __KDBUS_CONNECTION_H
+
+#include <linux/atomic.h>
+#include <linux/kref.h>
+#include <linux/lockdep.h>
+#include "limits.h"
+#include "metadata.h"
+#include "pool.h"
+#include "queue.h"
+#include "util.h"
+
+#define KDBUS_HELLO_SPECIAL_CONN	(KDBUS_HELLO_ACTIVATOR | \
+					 KDBUS_HELLO_POLICY_HOLDER | \
+					 KDBUS_HELLO_MONITOR)
+
+/**
+ * struct kdbus_conn - connection to a bus
+ * @kref:		Reference count
+ * @active:		Active references to the connection
+ * @id:			Connection ID
+ * @flags:		KDBUS_HELLO_* flags
+ * @attach_flags_send:	KDBUS_ATTACH_* flags for sending
+ * @attach_flags_recv:	KDBUS_ATTACH_* flags for receiving
+ * @name:		Human-readable connection name, used for debugging
+ * @ep:			The endpoint this connection belongs to
+ * @lock:		Connection data lock
+ * @msg_users:		Array to account the number of queued messages per
+ *			individual user
+ * @msg_users_max:	Size of the users array
+ * @hentry:		Entry in ID <-> connection map
+ * @ep_entry:		Entry in endpoint
+ * @monitor_entry:	Entry in monitor, if the connection is a monitor
+ * @names_list:		List of well-known names
+ * @names_queue_list:	Well-known names this connection waits for
+ * @reply_list:		List of connections this connection should
+ *			reply to
+ * @work:		Delayed work to handle timeouts
+ * @activator_of:	Well-known name entry this connection acts as an
+ *			activator for
+ * @match_db:		Subscription filter to broadcast messages
+ * @meta:		Active connection creator's metadata/credentials,
+ *			either from the handle or from HELLO
+ * @owner_meta:		The connection's metadata/credentials supplied by
+ *			HELLO
+ * @pool:		The user's buffer to receive messages
+ * @user:		Owner of the connection
+ * @cred:		The credentials of the connection at creation time
+ * @name_count:		Number of owned well-known names
+ * @reply_count:	Number of requests this connection has issued, and
+ *			waits for replies from other peers
+ * @lost_count:		Number of lost broadcast messages
+ * @wait:		Wake up this endpoint
+ * @queue:		The message queue associated with this connection
+ * @privileged:		Whether this connection is privileged on the bus
+ */
+struct kdbus_conn {
+	struct kref kref;
+	atomic_t active;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+	u64 id;
+	u64 flags;
+	atomic64_t attach_flags_send;
+	atomic64_t attach_flags_recv;
+	const char *name;
+	struct kdbus_ep *ep;
+	struct mutex lock;
+	unsigned int *msg_users;
+	unsigned int msg_users_max;
+	struct hlist_node hentry;
+	struct list_head ep_entry;
+	struct list_head monitor_entry;
+	struct list_head names_list;
+	struct list_head names_queue_list;
+	struct list_head reply_list;
+	struct delayed_work work;
+	struct kdbus_name_entry *activator_of;
+	struct kdbus_match_db *match_db;
+	struct kdbus_meta *meta;
+	struct kdbus_meta *owner_meta;
+	struct kdbus_pool *pool;
+	struct kdbus_domain_user *user;
+	const struct cred *cred;
+	atomic_t name_count;
+	atomic_t reply_count;
+	atomic_t lost_count;
+	wait_queue_head_t wait;
+	struct kdbus_queue queue;
+	bool privileged : 1;
+};
+
+struct kdbus_kmsg;
+struct kdbus_name_registry;
+
+struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep,
+				  struct kdbus_cmd_hello *hello,
+				  struct kdbus_meta *meta,
+				  bool privileged);
+struct kdbus_conn *kdbus_conn_ref(struct kdbus_conn *conn);
+struct kdbus_conn *kdbus_conn_unref(struct kdbus_conn *conn);
+int kdbus_conn_acquire(struct kdbus_conn *conn);
+void kdbus_conn_release(struct kdbus_conn *conn);
+int kdbus_conn_disconnect(struct kdbus_conn *conn, bool ensure_queue_empty);
+bool kdbus_conn_active(const struct kdbus_conn *conn);
+int kdbus_conn_entry_insert(struct kdbus_conn *conn_src,
+			    struct kdbus_conn *conn_dst,
+			    const struct kdbus_kmsg *kmsg,
+			    struct kdbus_conn_reply *reply);
+void kdbus_conn_purge_policy_cache(struct kdbus_conn *conn);
+int kdbus_conn_move_messages(struct kdbus_conn *conn_dst,
+			     struct kdbus_conn *conn_src,
+			     u64 name_id);
+bool kdbus_conn_has_name(struct kdbus_conn *conn, const char *name);
+
+/* command dispatcher */
+int kdbus_cmd_msg_recv(struct kdbus_conn *conn,
+		       struct kdbus_cmd_recv *recv);
+int kdbus_cmd_msg_cancel(struct kdbus_conn *conn,
+			 u64 cookie);
+int kdbus_cmd_info(struct kdbus_conn *conn,
+			struct kdbus_cmd_info *cmd_info);
+int kdbus_cmd_conn_update(struct kdbus_conn *conn,
+			  const struct kdbus_cmd_update *cmd_update);
+int kdbus_conn_kmsg_send(struct kdbus_ep *ep,
+			 struct kdbus_conn *conn_src,
+			 struct kdbus_kmsg *kmsg);
+
+/**
+ * kdbus_conn_is_ordinary() - Check if connection is ordinary
+ * @conn:		The connection to check
+ *
+ * Return: Non-zero if the connection is an ordinary connection
+ */
+static inline int kdbus_conn_is_ordinary(const struct kdbus_conn *conn)
+{
+	return !(conn->flags & KDBUS_HELLO_SPECIAL_CONN);
+}
+
+/**
+ * kdbus_conn_is_activator() - Check if connection is an activator
+ * @conn:		The connection to check
+ *
+ * Return: Non-zero if the connection is an activator
+ */
+static inline int kdbus_conn_is_activator(const struct kdbus_conn *conn)
+{
+	return conn->flags & KDBUS_HELLO_ACTIVATOR;
+}
+
+/**
+ * kdbus_conn_is_policy_holder() - Check if connection is a policy holder
+ * @conn:		The connection to check
+ *
+ * Return: Non-zero if the connection is a policy holder
+ */
+static inline int kdbus_conn_is_policy_holder(const struct kdbus_conn *conn)
+{
+	return conn->flags & KDBUS_HELLO_POLICY_HOLDER;
+}
+
+/**
+ * kdbus_conn_is_monitor() - Check if connection is a monitor
+ * @conn:		The connection to check
+ *
+ * Return: Non-zero if the connection is a monitor
+ */
+static inline int kdbus_conn_is_monitor(const struct kdbus_conn *conn)
+{
+	return conn->flags & KDBUS_HELLO_MONITOR;
+}
+
+#endif
diff --git a/ipc/kdbus/item.c b/ipc/kdbus/item.c
new file mode 100644
index 000000000000..06369fefeb69
--- /dev/null
+++ b/ipc/kdbus/item.c
@@ -0,0 +1,258 @@
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
+#include <linux/fs.h>
+#include <linux/string.h>
+
+#include "item.h"
+#include "limits.h"
+#include "util.h"
+
+#define KDBUS_ITEM_VALID(_i, _is, _s)					\
+	((_i)->size > KDBUS_ITEM_HEADER_SIZE &&				\
+	 (u8 *)(_i) + (_i)->size <= (u8 *)(_is) + (_s) &&		\
+	 (u8 *)(_i) >= (u8 *)(_is))
+
+#define KDBUS_ITEMS_END(_i, _is, _s)					\
+	((u8 *)_i == ((u8 *)(_is) + KDBUS_ALIGN8(_s)))
+
+/**
+ * kdbus_item_validate_name() - validate an item containing a name
+ * @item:		Item to validate
+ *
+ * Return: zero on success or an negative error code on failure
+ */
+int kdbus_item_validate_name(const struct kdbus_item *item)
+{
+	if (item->size < KDBUS_ITEM_HEADER_SIZE + 2)
+		return -EINVAL;
+
+	if (item->size > KDBUS_ITEM_HEADER_SIZE +
+			 KDBUS_SYSNAME_MAX_LEN + 1)
+		return -ENAMETOOLONG;
+
+	if (!kdbus_str_valid(item->str, KDBUS_ITEM_PAYLOAD_SIZE(item)))
+		return -EINVAL;
+
+	return kdbus_sysname_is_valid(item->str);
+}
+
+static int kdbus_item_validate(const struct kdbus_item *item)
+{
+	size_t payload_size = KDBUS_ITEM_PAYLOAD_SIZE(item);
+	size_t l;
+	int ret;
+
+	if (item->size < KDBUS_ITEM_HEADER_SIZE)
+		return -EINVAL;
+
+	switch (item->type) {
+	case KDBUS_ITEM_PAYLOAD_VEC:
+		if (payload_size != sizeof(struct kdbus_vec))
+			return -EINVAL;
+		if (item->vec.size == 0 || item->vec.size > SIZE_MAX)
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_PAYLOAD_OFF:
+		if (payload_size != sizeof(struct kdbus_vec))
+			return -EINVAL;
+		if (item->vec.size == 0 || item->vec.size > SIZE_MAX)
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_PAYLOAD_MEMFD:
+		if (payload_size != sizeof(struct kdbus_memfd))
+			return -EINVAL;
+		if (item->memfd.size == 0 || item->memfd.size > SIZE_MAX)
+			return -EINVAL;
+		if (item->memfd.fd < 0)
+			return -EBADF;
+		break;
+
+	case KDBUS_ITEM_FDS:
+		if (payload_size % sizeof(int) != 0)
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_BLOOM_PARAMETER:
+		if (payload_size != sizeof(struct kdbus_bloom_parameter))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_BLOOM_FILTER:
+		/* followed by the bloom-mask, depends on the bloom-size */
+		if (payload_size < sizeof(struct kdbus_bloom_filter))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_BLOOM_MASK:
+		/* size depends on bloom-size of bus */
+		break;
+
+	case KDBUS_ITEM_CONN_DESCRIPTION:
+	case KDBUS_ITEM_MAKE_NAME:
+		ret = kdbus_item_validate_name(item);
+		if (ret < 0)
+			return ret;
+		break;
+
+	case KDBUS_ITEM_ATTACH_FLAGS_SEND:
+	case KDBUS_ITEM_ATTACH_FLAGS_RECV:
+	case KDBUS_ITEM_ID:
+		if (payload_size != sizeof(u64))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_TIMESTAMP:
+		if (payload_size != sizeof(struct kdbus_timestamp))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_CREDS:
+		if (payload_size != sizeof(struct kdbus_creds))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_AUXGROUPS:
+		if (payload_size % sizeof(u64) != 0)
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_NAME:
+	case KDBUS_ITEM_DST_NAME:
+	case KDBUS_ITEM_PID_COMM:
+	case KDBUS_ITEM_TID_COMM:
+	case KDBUS_ITEM_EXE:
+	case KDBUS_ITEM_CMDLINE:
+	case KDBUS_ITEM_CGROUP:
+	case KDBUS_ITEM_SECLABEL:
+		if (!kdbus_str_valid(item->str, payload_size))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_CAPS:
+		/* TODO */
+		break;
+
+	case KDBUS_ITEM_AUDIT:
+		if (payload_size != sizeof(struct kdbus_audit))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_POLICY_ACCESS:
+		if (payload_size != sizeof(struct kdbus_policy_access))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_NAME_ADD:
+	case KDBUS_ITEM_NAME_REMOVE:
+	case KDBUS_ITEM_NAME_CHANGE:
+		if (payload_size < sizeof(struct kdbus_notify_name_change))
+			return -EINVAL;
+		l = payload_size - offsetof(struct kdbus_notify_name_change,
+					    name);
+		if (l > 0 && !kdbus_str_valid(item->name_change.name, l))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_ID_ADD:
+	case KDBUS_ITEM_ID_REMOVE:
+		if (payload_size != sizeof(struct kdbus_notify_id_change))
+			return -EINVAL;
+		break;
+
+	case KDBUS_ITEM_REPLY_TIMEOUT:
+	case KDBUS_ITEM_REPLY_DEAD:
+		if (payload_size != 0)
+			return -EINVAL;
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * kdbus_items_validate() - validate items passed by user-space
+ * @items:		items to validate
+ * @items_size:		number of items
+ *
+ * This verifies that the passed items pointer is consistent and valid.
+ * Furthermore, each item is checked for:
+ *  - valid "size" value
+ *  - payload is of expected type
+ *  - payload is fully included in the item
+ *  - string payloads are zero-terminated
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kdbus_items_validate(const struct kdbus_item *items, size_t items_size)
+{
+	const struct kdbus_item *item;
+	int ret;
+
+	KDBUS_ITEMS_FOREACH(item, items, items_size) {
+		if (!KDBUS_ITEM_VALID(item, items, items_size))
+			return -EINVAL;
+
+		ret = kdbus_item_validate(item);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (!KDBUS_ITEMS_END(item, items, items_size))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * kdbus_items_get_str() - get string from a list of items
+ * @items:		The items to walk
+ * @items_size:		The size of all items
+ * @item_type:		The item type to look for
+ *
+ * This function walks a list of items and searches for items of type
+ * @item_type. If it finds exactly one such item, @str_ret will be set to
+ * the .str member of the item.
+ *
+ * Return: the string, if the item was found exactly once, ERR_PTR(-EEXIST)
+ * if the item was found more than once, and ERR_PTR(-EBADMSG) if there was
+ * no item of the given type.
+ */
+const char *kdbus_items_get_str(const struct kdbus_item *items,
+				size_t items_size,
+				unsigned int item_type)
+{
+	const struct kdbus_item *item;
+	const char *n = NULL;
+
+	KDBUS_ITEMS_FOREACH(item, items, items_size) {
+		if (item->type == item_type) {
+			if (n)
+				return ERR_PTR(-EEXIST);
+
+			n = item->str;
+			continue;
+		}
+	}
+
+	if (!n)
+		return ERR_PTR(-EBADMSG);
+
+	return n;
+}
diff --git a/ipc/kdbus/item.h b/ipc/kdbus/item.h
new file mode 100644
index 000000000000..30d399ab0b65
--- /dev/null
+++ b/ipc/kdbus/item.h
@@ -0,0 +1,41 @@
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
+#ifndef __KDBUS_ITEM_H
+#define __KDBUS_ITEM_H
+
+#include <linux/kernel.h>
+#include <uapi/linux/kdbus.h>
+
+#include "util.h"
+
+/* generic access and iterators over a stream of items */
+#define KDBUS_ITEM_HEADER_SIZE offsetof(struct kdbus_item, data)
+#define KDBUS_ITEM_PAYLOAD_SIZE(_i) ((_i)->size - KDBUS_ITEM_HEADER_SIZE)
+#define KDBUS_ITEM_SIZE(_s) KDBUS_ALIGN8(KDBUS_ITEM_HEADER_SIZE + (_s))
+#define KDBUS_ITEM_NEXT(_i) (typeof(_i))(((u8 *)_i) + KDBUS_ALIGN8((_i)->size))
+#define KDBUS_ITEMS_SIZE(_h, _is) ((_h)->size - offsetof(typeof(*_h), _is))
+
+#define KDBUS_ITEMS_FOREACH(_i, _is, _s)				\
+	for (_i = _is;							\
+	     ((u8 *)(_i) < (u8 *)(_is) + (_s)) &&			\
+	       ((u8 *)(_i) >= (u8 *)(_is));				\
+	     _i = KDBUS_ITEM_NEXT(_i))
+
+int kdbus_item_validate_name(const struct kdbus_item *item);
+int kdbus_items_validate(const struct kdbus_item *items, size_t items_size);
+const char *kdbus_items_get_str(const struct kdbus_item *items,
+				size_t items_size,
+				unsigned int item_type);
+
+#endif
diff --git a/ipc/kdbus/message.c b/ipc/kdbus/message.c
new file mode 100644
index 000000000000..5b9c3fe3cab1
--- /dev/null
+++ b/ipc/kdbus/message.c
@@ -0,0 +1,444 @@
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
+#include <linux/capability.h>
+#include <linux/cgroup.h>
+#include <linux/cred.h>
+#include <linux/file.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/shmem_fs.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <net/sock.h>
+
+#include "bus.h"
+#include "connection.h"
+#include "domain.h"
+#include "endpoint.h"
+#include "handle.h"
+#include "item.h"
+#include "match.h"
+#include "message.h"
+#include "names.h"
+#include "policy.h"
+
+#define KDBUS_KMSG_HEADER_SIZE offsetof(struct kdbus_kmsg, msg)
+
+/**
+ * kdbus_kmsg_free() - free allocated message
+ * @kmsg:		Message
+ */
+void kdbus_kmsg_free(struct kdbus_kmsg *kmsg)
+{
+	kdbus_fput_files(kmsg->memfds, kmsg->memfds_count);
+	kdbus_fput_files(kmsg->fds, kmsg->fds_count);
+	kdbus_meta_free(kmsg->meta);
+	kfree(kmsg->memfds);
+	kfree(kmsg->fds);
+	kfree(kmsg);
+}
+
+/**
+ * kdbus_kmsg_new() - allocate message
+ * @extra_size:		additional size to reserve for data
+ *
+ * Return: new kdbus_kmsg on success, ERR_PTR on failure.
+ */
+struct kdbus_kmsg *kdbus_kmsg_new(size_t extra_size)
+{
+	struct kdbus_kmsg *m;
+	size_t size;
+
+	size = sizeof(struct kdbus_kmsg) + KDBUS_ITEM_SIZE(extra_size);
+	m = kzalloc(size, GFP_KERNEL);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+
+	m->msg.size = size - KDBUS_KMSG_HEADER_SIZE;
+	m->msg.items[0].size = KDBUS_ITEM_SIZE(extra_size);
+
+	return m;
+}
+
+static int kdbus_handle_check_file(struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct socket *sock;
+
+	/*
+	 * Don't allow file descriptors in the transport that themselves allow
+	 * file descriptor queueing. This will eventually be allowed once both
+	 * unix domain sockets and kdbus share a generic garbage collector.
+	 */
+
+	if (file->f_op == &kdbus_handle_ep_ops)
+		return -EOPNOTSUPP;
+
+	if (!S_ISSOCK(inode->i_mode))
+		return 0;
+
+	/* Almost nothing can be done with O_PATHed files */
+	if (file->f_mode & FMODE_PATH)
+		return 0;
+
+	sock = SOCKET_I(inode);
+	if (sock->sk && sock->ops && sock->ops->family == PF_UNIX)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/*
+ * kdbus_msg_scan_items() - validate incoming data and prepare parsing
+ * @conn:		Connection
+ * @kmsg:		Message
+ *
+ * Return: 0 on success, negative errno on failure.
+ *
+ * On errors, the caller should drop any taken reference with
+ * kdbus_kmsg_free()
+ */
+static int kdbus_msg_scan_items(struct kdbus_conn *conn,
+				struct kdbus_kmsg *kmsg)
+{
+	const struct kdbus_msg *msg = &kmsg->msg;
+	const struct kdbus_item *item;
+	unsigned int items_count = 0;
+	size_t vecs_size = 0;
+	bool has_bloom = false;
+	bool has_name = false;
+	bool has_fds = false;
+	struct file *f;
+
+	KDBUS_ITEMS_FOREACH(item, msg->items, KDBUS_ITEMS_SIZE(msg, items))
+		if (item->type == KDBUS_ITEM_PAYLOAD_MEMFD)
+			kmsg->memfds_count++;
+
+	if (kmsg->memfds_count > 0) {
+		kmsg->memfds = kcalloc(kmsg->memfds_count,
+				       sizeof(struct file *), GFP_KERNEL);
+		if (!kmsg->memfds)
+			return -ENOMEM;
+
+		/* reset counter so we can reuse it */
+		kmsg->memfds_count = 0;
+	}
+
+	KDBUS_ITEMS_FOREACH(item, msg->items, KDBUS_ITEMS_SIZE(msg, items)) {
+		size_t payload_size;
+
+		if (++items_count > KDBUS_MSG_MAX_ITEMS)
+			return -E2BIG;
+
+		payload_size = KDBUS_ITEM_PAYLOAD_SIZE(item);
+
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_VEC:
+			if (vecs_size + item->vec.size <= vecs_size)
+				return -EMSGSIZE;
+
+			vecs_size += item->vec.size;
+			if (vecs_size > KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE)
+				return -EMSGSIZE;
+
+			/* \0-bytes records store only the alignment bytes */
+			if (KDBUS_PTR(item->vec.address))
+				kmsg->vecs_size += item->vec.size;
+			else
+				kmsg->vecs_size += item->vec.size % 8;
+			kmsg->vecs_count++;
+			break;
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			int seals, mask;
+			int fd = item->memfd.fd;
+
+			/* Verify the fd and increment the usage count */
+			if (fd < 0)
+				return -EBADF;
+
+			f = fget(fd);
+			if (!f)
+				return -EBADF;
+
+			kmsg->memfds[kmsg->memfds_count] = f;
+			kmsg->memfds_count++;
+
+			/*
+			 * We only accept a sealed memfd file whose content
+			 * cannot be altered by the sender or anybody else
+			 * while it is shared or in-flight. Other files need
+			 * to be passed with KDBUS_MSG_FDS.
+			 */
+			seals = shmem_get_seals(f);
+			if (seals < 0)
+				return -EMEDIUMTYPE;
+
+			mask = F_SEAL_SHRINK |
+			       F_SEAL_GROW |
+			       F_SEAL_WRITE |
+			       F_SEAL_SEAL;
+			if ((seals & mask) != mask)
+				return -ETXTBSY;
+
+			/*
+			 * The specified size in the item cannot be larger
+			 * than the backing file.
+			 */
+			if (item->memfd.size > i_size_read(file_inode(f)))
+				return -EBADF;
+
+			break;
+		}
+
+		case KDBUS_ITEM_FDS: {
+			unsigned int n, i;
+
+			/* do not allow multiple fd arrays */
+			if (has_fds)
+				return -EEXIST;
+			has_fds = true;
+
+			/* do not allow to broadcast file descriptors */
+			if (msg->dst_id == KDBUS_DST_ID_BROADCAST)
+				return -ENOTUNIQ;
+
+			n = KDBUS_ITEM_PAYLOAD_SIZE(item) / sizeof(int);
+			if (n > KDBUS_MSG_MAX_FDS)
+				return -EMFILE;
+
+			kmsg->fds = kcalloc(n, sizeof(*kmsg->fds), GFP_KERNEL);
+			if (!kmsg->fds)
+				return -ENOMEM;
+
+			for (i = 0; i < n; i++) {
+				int ret;
+				int fd = item->fds[i];
+
+				/*
+				 * Verify the fd and increment the usage count.
+				 * Use fget_raw() to allow passing O_PATH fds.
+				 */
+				if (fd < 0)
+					return -EBADF;
+
+				f = fget_raw(fd);
+				if (!f)
+					return -EBADF;
+
+				kmsg->fds[i] = f;
+				kmsg->fds_count++;
+
+				ret = kdbus_handle_check_file(f);
+				if (ret < 0)
+					return ret;
+			}
+
+			break;
+		}
+
+		case KDBUS_ITEM_BLOOM_FILTER: {
+			u64 bloom_size;
+
+			/* do not allow multiple bloom filters */
+			if (has_bloom)
+				return -EEXIST;
+			has_bloom = true;
+
+			/* bloom filters are only for broadcast messages */
+			if (msg->dst_id != KDBUS_DST_ID_BROADCAST)
+				return -EBADMSG;
+
+			bloom_size = payload_size -
+				     offsetof(struct kdbus_bloom_filter, data);
+
+			/*
+			* Allow only bloom filter sizes of a multiple of 64bit.
+			*/
+			if (!KDBUS_IS_ALIGNED8(bloom_size))
+				return -EFAULT;
+
+			/* do not allow mismatching bloom filter sizes */
+			if (bloom_size != conn->ep->bus->bloom.size)
+				return -EDOM;
+
+			kmsg->bloom_filter = &item->bloom_filter;
+			break;
+		}
+
+		case KDBUS_ITEM_DST_NAME:
+			/* do not allow multiple names */
+			if (has_name)
+				return -EEXIST;
+			has_name = true;
+
+			if (!kdbus_name_is_valid(item->str, false))
+				return -EINVAL;
+
+			kmsg->dst_name = item->str;
+			break;
+		}
+	}
+
+	/* name is needed if no ID is given */
+	if (msg->dst_id == KDBUS_DST_ID_NAME && !has_name)
+		return -EDESTADDRREQ;
+
+	if (msg->dst_id == KDBUS_DST_ID_BROADCAST) {
+		/* broadcasts can't take names */
+		if (has_name)
+			return -EBADMSG;
+
+		/* broadcast messages require a bloom filter */
+		if (!has_bloom)
+			return -EBADMSG;
+
+		/* timeouts are not allowed for broadcasts */
+		if (msg->timeout_ns > 0)
+			return -ENOTUNIQ;
+	}
+
+	/* bloom filters are for undirected messages only */
+	if (has_name && has_bloom)
+		return -EBADMSG;
+
+	return 0;
+}
+
+/**
+ * kdbus_kmsg_new_from_user() - copy message from user memory
+ * @conn:		Connection
+ * @msg:		User-provided message
+ *
+ * Return: a new kdbus_kmsg on success, ERR_PTR on failure.
+ */
+struct kdbus_kmsg *kdbus_kmsg_new_from_user(struct kdbus_conn *conn,
+					    struct kdbus_msg __user *msg)
+{
+	struct kdbus_kmsg *m;
+	u64 size, alloc_size;
+	int ret;
+
+	if (!KDBUS_IS_ALIGNED8((unsigned long)msg))
+		return ERR_PTR(-EFAULT);
+
+	if (kdbus_size_get_user(&size, msg, struct kdbus_msg))
+		return ERR_PTR(-EFAULT);
+
+	if (size < sizeof(struct kdbus_msg) || size > KDBUS_MSG_MAX_SIZE)
+		return ERR_PTR(-EMSGSIZE);
+
+	alloc_size = size + KDBUS_KMSG_HEADER_SIZE;
+
+	m = kmalloc(alloc_size, GFP_KERNEL);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+	memset(m, 0, KDBUS_KMSG_HEADER_SIZE);
+
+	if (copy_from_user(&m->msg, msg, size)) {
+		ret = -EFAULT;
+		goto exit_free;
+	}
+
+	ret = kdbus_items_validate(m->msg.items,
+				   KDBUS_ITEMS_SIZE(&m->msg, items));
+	if (ret < 0)
+		goto exit_free;
+
+	/* do not accept kernel-generated messages */
+	if (m->msg.payload_type == KDBUS_PAYLOAD_KERNEL) {
+		ret = -EINVAL;
+		goto exit_free;
+	}
+
+	ret = kdbus_negotiate_flags(&m->msg, msg, struct kdbus_msg,
+				    KDBUS_MSG_FLAGS_EXPECT_REPLY |
+				    KDBUS_MSG_FLAGS_SYNC_REPLY |
+				    KDBUS_MSG_FLAGS_NO_AUTO_START);
+	if (ret < 0)
+		goto exit_free;
+
+	if (m->msg.flags & KDBUS_MSG_FLAGS_EXPECT_REPLY) {
+		/* requests for replies need a timeout */
+		if (m->msg.timeout_ns == 0) {
+			ret = -EINVAL;
+			goto exit_free;
+		}
+
+		/* replies may not be expected for broadcasts */
+		if (m->msg.dst_id == KDBUS_DST_ID_BROADCAST) {
+			ret = -ENOTUNIQ;
+			goto exit_free;
+		}
+	} else {
+		/*
+		 * KDBUS_MSG_FLAGS_SYNC_REPLY is only valid together with
+		 * KDBUS_MSG_FLAGS_EXPECT_REPLY
+		 */
+		if (m->msg.flags & KDBUS_MSG_FLAGS_SYNC_REPLY) {
+			ret = -EINVAL;
+			goto exit_free;
+		}
+	}
+
+	ret = kdbus_msg_scan_items(conn, m);
+	if (ret < 0)
+		goto exit_free;
+
+	/* patch-in the source of this message */
+	if (m->msg.src_id > 0 && m->msg.src_id != conn->id) {
+		ret = -EINVAL;
+		goto exit_free;
+	}
+	m->msg.src_id = conn->id;
+
+	return m;
+
+exit_free:
+	kdbus_kmsg_free(m);
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_kmsg_attach_metadata() - Attach metadata to a kmsg object
+ * @kmsg:	The message to attach the metadata to
+ * @conn_src:	The source connection that sends the message
+ * @conn_dst:	The destination connection that is about to receive the message
+ *
+ * Append metadata items according to the destination connection's
+ * attach flags. If the source connection has faked credentials, the
+ * metadata object associated with the kmsg has been pre-filled with
+ * conn_src->owner_meta, and we only attach the connection's name and
+ * currently owned names on top of that.
+ *
+ * Return: 0 on success, negative error otherwise.
+ */
+int kdbus_kmsg_attach_metadata(struct kdbus_kmsg *kmsg,
+			       struct kdbus_conn *conn_src,
+			       struct kdbus_conn *conn_dst)
+{
+	u64 attach_flags;
+
+	attach_flags = atomic64_read(&conn_dst->attach_flags_recv);
+
+	if (conn_src->owner_meta)
+		attach_flags &= KDBUS_ATTACH_NAMES |
+				KDBUS_ATTACH_CONN_DESCRIPTION;
+
+	return kdbus_meta_append(kmsg->meta, conn_dst->ep->bus->domain,
+				 conn_src, kmsg->seq, attach_flags);
+}
diff --git a/ipc/kdbus/message.h b/ipc/kdbus/message.h
new file mode 100644
index 000000000000..b610e2c4f67b
--- /dev/null
+++ b/ipc/kdbus/message.h
@@ -0,0 +1,75 @@
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
+#ifndef __KDBUS_MESSAGE_H
+#define __KDBUS_MESSAGE_H
+
+#include "util.h"
+#include "metadata.h"
+
+/**
+ * struct kdbus_kmsg - internal message handling data
+ * @seq:		Domain-global message sequence number
+ * @notify_type:	Short-cut for faster lookup
+ * @notify_old_id:	Short-cut for faster lookup
+ * @notify_new_id:	Short-cut for faster lookup
+ * @notify_name:	Short-cut for faster lookup
+ * @dst_name:		Short-cut to msg for faster lookup
+ * @dst_name_id:	Short-cut to msg for faster lookup
+ * @bloom_filter:	Bloom filter to match message properties
+ * @bloom_generation:	Generation of bloom element set
+ * @fds:		Array of file descriptors to pass
+ * @fds_count:		Number of file descriptors to pass
+ * @meta:		Appended SCM-like metadata of the sending process
+ * @vecs_size:		Size of PAYLOAD data
+ * @vecs_count:		Number of PAYLOAD vectors
+ * @memfds_count:	Number of memfds to pass
+ * @notify_entry:	List of kernel-generated notifications
+ * @msg:		Message from or to userspace
+ */
+struct kdbus_kmsg {
+	u64 seq;
+	u64 notify_type;
+	u64 notify_old_id;
+	u64 notify_new_id;
+	const char *notify_name;
+
+	const char *dst_name;
+	u64 dst_name_id;
+	const struct kdbus_bloom_filter *bloom_filter;
+	u64 bloom_generation;
+	struct file **fds;
+	unsigned int fds_count;
+	struct kdbus_meta *meta;
+	size_t vecs_size;
+	unsigned int vecs_count;
+	struct file **memfds;
+	unsigned int memfds_count;
+	struct list_head notify_entry;
+
+	/* variable size, must be the last member */
+	struct kdbus_msg msg;
+};
+
+struct kdbus_ep;
+struct kdbus_conn;
+
+struct kdbus_kmsg *kdbus_kmsg_new(size_t extra_size);
+struct kdbus_kmsg *kdbus_kmsg_new_from_user(struct kdbus_conn *conn,
+					    struct kdbus_msg __user *msg);
+void kdbus_kmsg_free(struct kdbus_kmsg *kmsg);
+
+int kdbus_kmsg_attach_metadata(struct kdbus_kmsg *kmsg,
+			       struct kdbus_conn *conn_src,
+			       struct kdbus_conn *conn_dst);
+#endif
diff --git a/ipc/kdbus/queue.c b/ipc/kdbus/queue.c
new file mode 100644
index 000000000000..668831d66d0f
--- /dev/null
+++ b/ipc/kdbus/queue.c
@@ -0,0 +1,608 @@
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
+#include <linux/audit.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/hashtable.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/math64.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+#include "domain.h"
+#include "connection.h"
+#include "item.h"
+#include "message.h"
+#include "metadata.h"
+#include "util.h"
+#include "queue.h"
+
+static int kdbus_queue_entry_fds_install(struct kdbus_queue_entry *entry)
+{
+	unsigned int i;
+	int ret, *fds;
+	size_t count;
+
+	/* get array of file descriptors */
+	count = entry->fds_count + entry->memfds_count;
+	if (!count)
+		return 0;
+
+	fds = kcalloc(count, sizeof(int), GFP_KERNEL);
+	if (!fds)
+		return -ENOMEM;
+
+	/* allocate new file descriptors in the receiver's process */
+	for (i = 0; i < count; i++) {
+		fds[i] = get_unused_fd_flags(O_CLOEXEC);
+		if (fds[i] < 0) {
+			ret = fds[i];
+			goto exit_remove_unused;
+		}
+	}
+
+	if (entry->fds_count) {
+		/* copy the array into the message item */
+		ret = kdbus_pool_slice_copy(entry->slice, entry->fds, fds,
+					    entry->fds_count * sizeof(int));
+		if (ret < 0)
+			goto exit_remove_unused;
+
+		/* install files in the receiver's process */
+		for (i = 0; i < entry->fds_count; i++)
+			fd_install(fds[i], get_file(entry->fds_fp[i]));
+	}
+
+	if (entry->memfds_count) {
+		off_t o = entry->fds_count;
+
+		/*
+		 * Update the file descriptor number in the items.
+		 * We remembered the locations of the values in the buffer.
+		 */
+		for (i = 0; i < entry->memfds_count; i++) {
+			ret = kdbus_pool_slice_copy(entry->slice,
+						    entry->memfds[i],
+						    &fds[o + i], sizeof(int));
+			if (ret < 0)
+				goto exit_rewind_fds;
+		}
+
+		/* install files in the receiver's process */
+		for (i = 0; i < entry->memfds_count; i++)
+			fd_install(fds[o + i], get_file(entry->memfds_fp[i]));
+	}
+
+	kfree(fds);
+	return 0;
+
+exit_rewind_fds:
+	for (i = 0; i < entry->fds_count; i++)
+		sys_close(fds[i]);
+
+exit_remove_unused:
+	for (i = 0; i < count; i++) {
+		if (fds[i] < 0)
+			break;
+
+		put_unused_fd(fds[i]);
+	}
+
+	kfree(fds);
+	return ret;
+}
+
+/**
+ * kdbus_queue_entry_install() - install message components into the
+ *				 receiver's process
+ * @entry:	The queue entry to install
+ *
+ * This function will install file descriptors transported in a queue enrty
+ * into 'current'.
+ *
+ * Return: 0 on success.
+ */
+int kdbus_queue_entry_install(struct kdbus_queue_entry *entry)
+{
+	int ret;
+
+	ret = kdbus_queue_entry_fds_install(entry);
+	if (ret < 0)
+		return ret;
+
+	kdbus_pool_slice_flush(entry->slice);
+	return 0;
+}
+
+static int kdbus_queue_entry_payload_add(struct kdbus_queue_entry *entry,
+					 const struct kdbus_kmsg *kmsg,
+					 size_t items, size_t vec_data)
+{
+	const struct kdbus_item *item;
+	int ret;
+
+	if (kmsg->memfds_count > 0) {
+		entry->memfds = kcalloc(kmsg->memfds_count,
+					sizeof(off_t), GFP_KERNEL);
+		if (!entry->memfds)
+			return -ENOMEM;
+
+		entry->memfds_fp = kcalloc(kmsg->memfds_count,
+					   sizeof(struct file *), GFP_KERNEL);
+		if (!entry->memfds_fp)
+			return -ENOMEM;
+	}
+
+	KDBUS_ITEMS_FOREACH(item, kmsg->msg.items,
+			    KDBUS_ITEMS_SIZE(&kmsg->msg, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_VEC: {
+			char tmp[KDBUS_ITEM_HEADER_SIZE +
+				 sizeof(struct kdbus_vec)];
+			struct kdbus_item *it = (struct kdbus_item *)tmp;
+
+			/* add item */
+			it->type = KDBUS_ITEM_PAYLOAD_OFF;
+			it->size = sizeof(tmp);
+
+			/* a NULL address specifies a \0-bytes record */
+			if (KDBUS_PTR(item->vec.address))
+				it->vec.offset = vec_data;
+			else
+				it->vec.offset = ~0ULL;
+			it->vec.size = item->vec.size;
+			ret = kdbus_pool_slice_copy(entry->slice, items,
+						    it, it->size);
+			if (ret < 0)
+				return ret;
+			items += KDBUS_ALIGN8(it->size);
+
+			/* \0-bytes record */
+			if (!KDBUS_PTR(item->vec.address)) {
+				size_t l = item->vec.size % 8;
+				const char *n = "\0\0\0\0\0\0\0";
+
+				if (l == 0)
+					break;
+
+				/*
+				 * Preserve the alignment for the next payload
+				 * record in the output buffer; write as many
+				 * null-bytes to the buffer which the \0-bytes
+				 * record would have shifted the alignment.
+				 */
+				ret = kdbus_pool_slice_copy(entry->slice,
+							    vec_data, n, l);
+				if (ret < 0)
+					return ret;
+
+				vec_data += l;
+				break;
+			}
+
+			/* copy kdbus_vec data from sender to receiver */
+			ret = kdbus_pool_slice_copy_user(entry->slice, vec_data,
+				KDBUS_PTR(item->vec.address), item->vec.size);
+			if (ret < 0)
+				return ret;
+
+			vec_data += item->vec.size;
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			char tmp[KDBUS_ITEM_HEADER_SIZE +
+				 sizeof(struct kdbus_memfd)];
+			struct kdbus_item *it = (struct kdbus_item *)tmp;
+
+			/* add item */
+			it->type = KDBUS_ITEM_PAYLOAD_MEMFD;
+			it->size = sizeof(tmp);
+			it->memfd.size = item->memfd.size;
+			it->memfd.fd = -1;
+			ret = kdbus_pool_slice_copy(entry->slice, items,
+						    it, it->size);
+			if (ret < 0)
+				return ret;
+
+			/*
+			 * Remember the file and the location of the fd number
+			 * which will be updated at RECV time.
+			 */
+			entry->memfds[entry->memfds_count] =
+				items + offsetof(struct kdbus_item, memfd.fd);
+			entry->memfds_fp[entry->memfds_count] =
+				get_file(kmsg->memfds[entry->memfds_count]);
+			entry->memfds_count++;
+
+			items += KDBUS_ALIGN8(it->size);
+			break;
+		}
+
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * kdbus_queue_entry_add() - Add an queue entry to a queue
+ * @queue:	The queue to attach the item to
+ * @entry:	The entry to attach
+ *
+ * Adds a previously allocated queue item to a queue, and maintains the
+ * priority r/b tree.
+ */
+/* add queue entry to connection, maintain priority queue */
+void kdbus_queue_entry_add(struct kdbus_queue *queue,
+			   struct kdbus_queue_entry *entry)
+{
+	struct rb_node **n, *pn = NULL;
+	bool highest = true;
+
+	/* sort into priority entry tree */
+	n = &queue->msg_prio_queue.rb_node;
+	while (*n) {
+		struct kdbus_queue_entry *e;
+
+		pn = *n;
+		e = rb_entry(pn, struct kdbus_queue_entry, prio_node);
+
+		/* existing node for this priority, add to its list */
+		if (likely(entry->priority == e->priority)) {
+			list_add_tail(&entry->prio_entry, &e->prio_entry);
+			goto prio_done;
+		}
+
+		if (entry->priority < e->priority) {
+			n = &pn->rb_left;
+		} else {
+			n = &pn->rb_right;
+			highest = false;
+		}
+	}
+
+	/* cache highest-priority entry */
+	if (highest)
+		queue->msg_prio_highest = &entry->prio_node;
+
+	/* new node for this priority */
+	rb_link_node(&entry->prio_node, pn, n);
+	rb_insert_color(&entry->prio_node, &queue->msg_prio_queue);
+	INIT_LIST_HEAD(&entry->prio_entry);
+
+prio_done:
+	/* add to unsorted fifo list */
+	list_add_tail(&entry->entry, &queue->msg_list);
+	queue->msg_count++;
+}
+
+/**
+ * kdbus_queue_entry_peek() - Retrieves an entry from a queue
+ *
+ * @queue:		The queue
+ * @priority:		The minimum priority of the entry to peek
+ * @use_priority:	Boolean flag whether or not to peek by priority
+ *
+ * Look for a entry in a queue, either by priority, or the oldest one (FIFO).
+ * The entry is not freed, put off the queue's lists or anything else.
+ *
+ * Return: the peeked queue entry on success, ERR_PTR(-ENOMSG) if there is no
+ * entry with the requested priority, or ERR_PTR(-EAGAIN) if there are no
+ * entries at all.
+ */
+struct kdbus_queue_entry *kdbus_queue_entry_peek(struct kdbus_queue *queue,
+						 s64 priority,
+						 bool use_priority)
+{
+	struct kdbus_queue_entry *e;
+
+	if (queue->msg_count == 0)
+		return ERR_PTR(-EAGAIN);
+
+	if (use_priority) {
+		/* get next entry with highest priority */
+		e = rb_entry(queue->msg_prio_highest,
+			     struct kdbus_queue_entry, prio_node);
+
+		/* no entry with the requested priority */
+		if (e->priority > priority)
+			return ERR_PTR(-ENOMSG);
+	} else {
+		/* ignore the priority, return the next entry in the entry */
+		e = list_first_entry(&queue->msg_list,
+				     struct kdbus_queue_entry, entry);
+	}
+
+	return e;
+}
+
+/**
+ * kdbus_queue_entry_remove() - Remove an entry from a queue
+ * @conn:	The connection containing the queue
+ * @entry:	The entry to remove
+ *
+ * Remove an entry from both the queue's list and the priority r/b tree.
+ */
+void kdbus_queue_entry_remove(struct kdbus_conn *conn,
+			      struct kdbus_queue_entry *entry)
+{
+	struct kdbus_queue *queue = &conn->queue;
+
+	list_del(&entry->entry);
+	queue->msg_count--;
+
+	/* user quota */
+	if (entry->user) {
+		BUG_ON(conn->msg_users[entry->user->idr] == 0);
+		conn->msg_users[entry->user->idr]--;
+		entry->user = kdbus_domain_user_unref(entry->user);
+	}
+
+	/* the queue is empty, remove the user quota accounting */
+	if (queue->msg_count == 0 && conn->msg_users_max > 0) {
+		kfree(conn->msg_users);
+		conn->msg_users = NULL;
+		conn->msg_users_max = 0;
+	}
+
+	if (list_empty(&entry->prio_entry)) {
+		/*
+		 * Single entry for this priority, update cached
+		 * highest-priority entry, remove the tree node.
+		 */
+		if (queue->msg_prio_highest == &entry->prio_node)
+			queue->msg_prio_highest = rb_next(&entry->prio_node);
+
+		rb_erase(&entry->prio_node, &queue->msg_prio_queue);
+	} else {
+		struct kdbus_queue_entry *q;
+
+		/*
+		 * Multiple entries for this priority entry, get next one in
+		 * the list. Update cached highest-priority entry, store the
+		 * new one as the tree node.
+		 */
+		q = list_first_entry(&entry->prio_entry,
+				     struct kdbus_queue_entry, prio_entry);
+		list_del(&entry->prio_entry);
+
+		if (queue->msg_prio_highest == &entry->prio_node)
+			queue->msg_prio_highest = &q->prio_node;
+
+		rb_replace_node(&entry->prio_node, &q->prio_node,
+				&queue->msg_prio_queue);
+	}
+}
+
+/**
+ * kdbus_queue_entry_alloc() - allocate a queue entry
+ * @conn_src:	The connection used to create the message
+ * @conn_dst:	The connection that holds the queue
+ * @kmsg:	The kmsg object the queue entry should track
+ *
+ * Allocates a queue entry based on a given kmsg and allocate space for
+ * the message payload and the requested metadata in the connection's pool.
+ * The entry is not actually added to the queue's lists at this point.
+ *
+ * Return: the allocated entry on success, or an ERR_PTR on failures.
+ */
+struct kdbus_queue_entry *kdbus_queue_entry_alloc(struct kdbus_conn *conn_src,
+						  struct kdbus_conn *conn_dst,
+						  const struct kdbus_kmsg *kmsg)
+{
+	struct kdbus_queue_entry *entry;
+	struct kdbus_item *it;
+	u64 attach_flags = 0;
+	size_t msg_size;
+	size_t size;
+	size_t dst_name_len = 0;
+	size_t payloads = 0;
+	size_t fds = 0;
+	size_t meta_off = 0;
+	size_t vec_data;
+	size_t want, have;
+	int ret = 0;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	/* copy message properties we need for the entry management */
+	entry->src_id = kmsg->msg.src_id;
+	entry->cookie = kmsg->msg.cookie;
+
+	/* space for the header */
+	if (kmsg->msg.src_id == KDBUS_SRC_ID_KERNEL)
+		size = kmsg->msg.size;
+	else
+		size = offsetof(struct kdbus_msg, items);
+	msg_size = size;
+
+	/* let the receiver know where the message was addressed to */
+	if (kmsg->dst_name) {
+		dst_name_len = strlen(kmsg->dst_name) + 1;
+		msg_size += KDBUS_ITEM_SIZE(dst_name_len);
+		entry->dst_name_id = kmsg->dst_name_id;
+	}
+
+	/* space for PAYLOAD items */
+	if ((kmsg->vecs_count + kmsg->memfds_count) > 0) {
+		payloads = msg_size;
+		msg_size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec)) *
+			    kmsg->vecs_count;
+		msg_size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd)) *
+			    kmsg->memfds_count;
+	}
+
+	/* space for FDS item */
+	if (kmsg->fds_count > 0) {
+		entry->fds_fp = kcalloc(kmsg->fds_count, sizeof(struct file *),
+					GFP_KERNEL);
+		if (!entry->fds_fp) {
+			ret = -ENOMEM;
+			goto exit_free_entry;
+		}
+
+		fds = msg_size;
+		msg_size += KDBUS_ITEM_SIZE(kmsg->fds_count * sizeof(int));
+	}
+
+	if (conn_src)
+		attach_flags = atomic64_read(&conn_src->attach_flags_send) &
+			       atomic64_read(&conn_dst->attach_flags_recv);
+
+	/* space for metadata/credential items */
+	if (kmsg->meta && attach_flags) {
+		size_t meta_size;
+
+		meta_size = kdbus_meta_size(kmsg->meta, conn_dst,
+					    &attach_flags);
+		if (meta_size > 0) {
+			meta_off = msg_size;
+			msg_size += meta_size;
+		}
+	}
+
+	/* data starts after the message */
+	vec_data = KDBUS_ALIGN8(msg_size);
+
+	/* do not give out more than half of the remaining space */
+	want = vec_data + kmsg->vecs_size;
+	have = kdbus_pool_remain(conn_dst->pool);
+	if (want < have && want > have / 2) {
+		ret = -EXFULL;
+		goto exit_free_entry;
+	}
+
+	/* allocate the needed space in the pool of the receiver */
+	entry->slice = kdbus_pool_slice_alloc(conn_dst->pool, want);
+	if (IS_ERR(entry->slice)) {
+		ret = PTR_ERR(entry->slice);
+		entry->slice = NULL;
+		goto exit_free_entry;
+	}
+
+	/* copy the message header */
+	ret = kdbus_pool_slice_copy(entry->slice, 0, &kmsg->msg, size);
+	if (ret < 0)
+		goto exit_free_slice;
+
+	/* update the size */
+	ret = kdbus_pool_slice_copy(entry->slice, 0, &msg_size,
+				    sizeof(kmsg->msg.size));
+	if (ret < 0)
+		goto exit_free_slice;
+
+	if (dst_name_len  > 0) {
+		char tmp[KDBUS_ITEM_HEADER_SIZE + dst_name_len];
+
+		it = (struct kdbus_item *)tmp;
+		it->size = KDBUS_ITEM_HEADER_SIZE + dst_name_len;
+		it->type = KDBUS_ITEM_DST_NAME;
+		memcpy(it->str, kmsg->dst_name, dst_name_len);
+
+		ret = kdbus_pool_slice_copy(entry->slice, size, it, it->size);
+		if (ret < 0)
+			goto exit_free_slice;
+	}
+
+	/* add PAYLOAD items */
+	if (payloads > 0) {
+		ret = kdbus_queue_entry_payload_add(entry, kmsg,
+						    payloads, vec_data);
+		if (ret < 0)
+			goto exit_free_slice;
+	}
+
+	/* add a FDS item; the array content will be updated at RECV time */
+	if (kmsg->fds_count > 0) {
+		char tmp[KDBUS_ITEM_HEADER_SIZE];
+		unsigned int i;
+
+		it = (struct kdbus_item *)tmp;
+		it->type = KDBUS_ITEM_FDS;
+		it->size = KDBUS_ITEM_HEADER_SIZE +
+			   (kmsg->fds_count * sizeof(int));
+		ret = kdbus_pool_slice_copy(entry->slice, fds,
+					    it, KDBUS_ITEM_HEADER_SIZE);
+		if (ret < 0)
+			goto exit_free_slice;
+
+		for (i = 0; i < kmsg->fds_count; i++) {
+			entry->fds_fp[i] = get_file(kmsg->fds[i]);
+			if (!entry->fds_fp[i]) {
+				ret = -EBADF;
+				goto exit_free_slice;
+			}
+		}
+
+		/* remember the array to update at RECV */
+		entry->fds = fds + offsetof(struct kdbus_item, fds);
+		entry->fds_count = kmsg->fds_count;
+	}
+
+	/* append message metadata/credential items */
+	if (meta_off > 0) {
+		ret = kdbus_meta_write(kmsg->meta, conn_dst, attach_flags,
+				       entry->slice, meta_off);
+		if (ret < 0)
+			goto exit_free_slice;
+	}
+
+	entry->priority = kmsg->msg.priority;
+	return entry;
+
+exit_free_slice:
+	kdbus_pool_slice_free(entry->slice);
+exit_free_entry:
+	kdbus_queue_entry_free(entry);
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_queue_entry_free() - free resources of an entry
+ * @entry:	The entry to free
+ *
+ * Removes resources allocated by a queue entry, along with the entry itself.
+ * Note that the entry's slice is not freed at this point.
+ */
+void kdbus_queue_entry_free(struct kdbus_queue_entry *entry)
+{
+	kdbus_fput_files(entry->memfds_fp, entry->memfds_count);
+	kdbus_fput_files(entry->fds_fp, entry->fds_count);
+	kfree(entry->memfds_fp);
+	kfree(entry->fds_fp);
+	kfree(entry->memfds);
+	kfree(entry);
+}
+
+/**
+ * kdbus_queue_init() - initialize data structure related to a queue
+ * @queue:	The queue to initialize
+ */
+void kdbus_queue_init(struct kdbus_queue *queue)
+{
+	INIT_LIST_HEAD(&queue->msg_list);
+	queue->msg_prio_queue = RB_ROOT;
+}
diff --git a/ipc/kdbus/queue.h b/ipc/kdbus/queue.h
new file mode 100644
index 000000000000..2ddde8b81cfe
--- /dev/null
+++ b/ipc/kdbus/queue.h
@@ -0,0 +1,93 @@
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
+#ifndef __KDBUS_QUEUE_H
+#define __KDBUS_QUEUE_H
+
+struct kdbus_domain_user;
+
+/**
+ * struct kdbus_queue - a connection's message queue
+ * @msg_count		Number of messages in the queue
+ * @msg_list:		List head for kdbus_queue_entry objects
+ * @msg_prio_queue:	RB tree root for messages, sorted by priority
+ * @msg_prio_highest:	Link to the RB node referencing the message with the
+ *			highest priority in the tree.
+ */
+struct kdbus_queue {
+	size_t msg_count;
+	struct list_head msg_list;
+	struct rb_root msg_prio_queue;
+	struct rb_node *msg_prio_highest;
+};
+
+/**
+ * struct kdbus_queue_entry - messages waiting to be read
+ * @entry:		Entry in the connection's list
+ * @prio_node:		Entry in the priority queue tree
+ * @prio_entry:		Queue tree node entry in the list of one priority
+ * @priority:		Queueing priority of the message
+ * @slice:		Allocated slice in the receiver's pool
+ * @memfds:		Arrays of offsets where to update the installed
+ *			fd number
+ * @memfds_fp:		Array memfd files queued up for this message
+ * @memfds_count:	Number of memfds
+ * @fds:		Offset to array where to update the installed fd number
+ * @fds_fp:		Array of passed files queued up for this message
+ * @fds_count:		Number of files
+ * @src_id:		The ID of the sender
+ * @cookie:		Message cookie, used for replies
+ * @dst_name_id:	The sequence number of the name this message is
+ *			addressed to, 0 for messages sent to an ID
+ * @reply:		The reply block if a reply to this message is expected.
+ * @user:		Index in per-user message counter, -1 for unused
+ */
+struct kdbus_queue_entry {
+	struct list_head entry;
+	struct rb_node prio_node;
+	struct list_head prio_entry;
+	s64 priority;
+	struct kdbus_pool_slice *slice;
+	size_t *memfds;
+	struct file **memfds_fp;
+	unsigned int memfds_count;
+	size_t fds;
+	struct file **fds_fp;
+	unsigned int fds_count;
+	u64 src_id;
+	u64 cookie;
+	u64 dst_name_id;
+	struct kdbus_conn_reply *reply;
+	struct kdbus_domain_user *user;
+};
+
+struct kdbus_kmsg;
+
+void kdbus_queue_init(struct kdbus_queue *queue);
+
+struct kdbus_queue_entry *
+kdbus_queue_entry_alloc(struct kdbus_conn *conn_src,
+			struct kdbus_conn *conn_dst,
+			const struct kdbus_kmsg *kmsg);
+void kdbus_queue_entry_free(struct kdbus_queue_entry *entry);
+
+void kdbus_queue_entry_add(struct kdbus_queue *queue,
+			   struct kdbus_queue_entry *entry);
+void kdbus_queue_entry_remove(struct kdbus_conn *conn,
+			      struct kdbus_queue_entry *entry);
+struct kdbus_queue_entry *kdbus_queue_entry_peek(struct kdbus_queue *queue,
+						 s64 priority,
+						 bool use_priority);
+int kdbus_queue_entry_install(struct kdbus_queue_entry *entry);
+
+#endif /* __KDBUS_QUEUE_H */
diff --git a/ipc/kdbus/util.h b/ipc/kdbus/util.h
index e727a2134d0c..39347a394bc8 100644
--- a/ipc/kdbus/util.h
+++ b/ipc/kdbus/util.h
@@ -17,7 +17,7 @@
 #include <linux/dcache.h>
 #include <linux/ioctl.h>
 
-#include "kdbus.h"
+#include <uapi/linux/kdbus.h>
 
 /* all exported addresses are 64 bit */
 #define KDBUS_PTR(addr) ((void __user *)(uintptr_t)(addr))
-- 
2.1.3
