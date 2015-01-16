From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 05/13] kdbus: add connection, queue handling and message validation code
Date: Fri, 16 Jan 2015 11:16:09 -0800
Message-ID: <1421435777-25306-6-git-send-email-gregkh@linuxfoundation.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421435777-25306-1-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZooxQFI55V6+gNQ@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>

This patch adds code to create and destroy connections, to validate
incoming messages and to maintain the queue of messages that are
associated with a connection.

Note that connection and queue have a 1:1 relation, the code is only
split in two parts for cleaner separation and better readability.

Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 ipc/kdbus/connection.c | 2004 ++++++++++++++++++++++++++++++++++++++++++++++++
 ipc/kdbus/connection.h |  262 +++++++
 ipc/kdbus/item.c       |  309 ++++++++
 ipc/kdbus/item.h       |   57 ++
 ipc/kdbus/message.c    |  598 +++++++++++++++
 ipc/kdbus/message.h    |  133 ++++
 ipc/kdbus/queue.c      |  505 ++++++++++++
 ipc/kdbus/queue.h      |  108 +++
 ipc/kdbus/reply.c      |  262 +++++++
 ipc/kdbus/reply.h      |   68 ++
 ipc/kdbus/util.h       |    2 +-
 11 files changed, 4307 insertions(+), 1 deletion(-)
 create mode 100644 ipc/kdbus/connection.c
 create mode 100644 ipc/kdbus/connection.h
 create mode 100644 ipc/kdbus/item.c
 create mode 100644 ipc/kdbus/item.h
 create mode 100644 ipc/kdbus/message.c
 create mode 100644 ipc/kdbus/message.h
 create mode 100644 ipc/kdbus/queue.c
 create mode 100644 ipc/kdbus/queue.h
 create mode 100644 ipc/kdbus/reply.c
 create mode 100644 ipc/kdbus/reply.h

diff --git a/ipc/kdbus/connection.c b/ipc/kdbus/connection.c
new file mode 100644
index 000000000000..75e2ea161a0e
--- /dev/null
+++ b/ipc/kdbus/connection.c
@@ -0,0 +1,2004 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
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
+#include <linux/fs_struct.h>
+#include <linux/hashtable.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/math64.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/path.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/shmem_fs.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uio.h>
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
+#include "pool.h"
+#include "reply.h"
+#include "util.h"
+#include "queue.h"
+
+#define KDBUS_CONN_ACTIVE_BIAS	(INT_MIN + 2)
+#define KDBUS_CONN_ACTIVE_NEW	(INT_MIN + 1)
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
+	/*
+	 * When the kernel is the sender we do not do per user
+	 * accouting, instead we just count how many messages have
+	 * been queued and we check the quota limit when inserting
+	 * message into the receiver queue.
+	 */
+	if (!conn_src)
+		return 0;
+
+	/*
+	 * Per-user accounting can be expensive if we have many different
+	 * users on the bus. Allow one set of messages to pass through
+	 * un-accounted. Only once we hit that limit, we start accounting.
+	 */
+	if (conn_dst->queue.msg_count < KDBUS_CONN_MAX_MSGS_UNACCOUNTED)
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
+	bool install = !(recv->flags & KDBUS_RECV_PEEK);
+	struct kdbus_queue_entry *entry = NULL;
+	unsigned int lost_count;
+	int ret = 0;
+
+	if (recv->msg.offset > 0)
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
+	    entry->msg_res && entry->msg_res->fds_count > 0)) {
+		ret = -EINVAL;
+		goto exit_unlock;
+	}
+
+	/* just drop the message */
+	if (recv->flags & KDBUS_RECV_DROP) {
+		struct kdbus_reply *reply = kdbus_reply_ref(entry->reply);
+
+		kdbus_queue_entry_remove(conn, entry);
+		kdbus_pool_slice_release(entry->slice);
+
+		mutex_unlock(&conn->lock);
+
+		if (reply) {
+			/*
+			 * See if the reply object is still linked in
+			 * reply_dst, and kill it. Notify the waiting peer
+			 * that there won't be an answer (-EPIPE).
+			 */
+			mutex_lock(&reply->reply_dst->lock);
+			if (!list_empty(&reply->entry)) {
+				kdbus_reply_unlink(reply);
+				if (reply->sync)
+					kdbus_sync_reply_wakeup(reply, -EPIPE);
+				else
+					kdbus_notify_reply_dead(conn->ep->bus,
+							entry->msg.src_id,
+							entry->msg.cookie);
+			}
+			mutex_unlock(&reply->reply_dst->lock);
+		}
+
+		kdbus_notify_flush(conn->ep->bus);
+		kdbus_queue_entry_free(entry);
+		kdbus_reply_unref(reply);
+
+		return 0;
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
+	/*
+	 * PEEK just returns the location of the next message. Do not install
+	 * file descriptors or anything else. This is usually used to
+	 * determine the sender of the next queued message.
+	 *
+	 * File descriptor numbers referenced in the message items
+	 * are undefined, they are only valid with the full receive
+	 * not with peek.
+	 *
+	 * Only if no PEEK is specified, the FDs are installed and the message
+	 * is dropped from internal queues.
+	 */
+	ret = kdbus_queue_entry_install(entry, conn, &recv->msg.return_flags,
+					install);
+	if (ret < 0)
+		goto exit_unlock;
+
+	/* Give the offset+size back to the caller. */
+	kdbus_pool_slice_publish(entry->slice, &recv->msg.offset,
+				 &recv->msg.msg_size);
+
+	if (install) {
+		kdbus_queue_entry_remove(conn, entry);
+		kdbus_pool_slice_release(entry->slice);
+		kdbus_queue_entry_free(entry);
+	}
+
+exit_unlock:
+	mutex_unlock(&conn->lock);
+	kdbus_notify_flush(conn->ep->bus);
+	return ret;
+}
+
+static int kdbus_conn_check_access(struct kdbus_conn *conn_src,
+				   const struct cred *conn_src_creds,
+				   struct kdbus_conn *conn_dst,
+				   const struct kdbus_msg *msg,
+				   struct kdbus_reply **reply_wake)
+{
+	/*
+	 * If the message is a reply, its cookie_reply field must match any
+	 * of the connection's expected replies. Otherwise, access to send the
+	 * message will be denied.
+	 */
+	if (reply_wake && msg->cookie_reply > 0) {
+		struct kdbus_reply *r;
+
+		/*
+		 * The connection that we are replying to has not
+		 * issued any request or perhaps we have already
+		 * replied, in anycase the supplied cookie_reply is
+		 * no more valid, so fail.
+		 */
+		if (atomic_read(&conn_dst->request_count) == 0)
+			return -EPERM;
+
+		mutex_lock(&conn_dst->lock);
+		r = kdbus_reply_find(conn_src, conn_dst, msg->cookie_reply);
+		if (r) {
+			if (r->sync)
+				*reply_wake = kdbus_reply_ref(r);
+			kdbus_reply_unlink(r);
+		}
+		mutex_unlock(&conn_dst->lock);
+
+		return r ? 0 : -EPERM;
+	}
+
+	/* ... otherwise, ask the policy DBs for permission */
+	if (!kdbus_conn_policy_talk(conn_src, conn_src_creds, conn_dst))
+		return -EPERM;
+
+	return 0;
+}
+
+/* Callers should take the conn_dst lock */
+static struct kdbus_queue_entry *
+kdbus_conn_entry_make(struct kdbus_conn *conn_dst,
+		      const struct kdbus_kmsg *kmsg)
+{
+	/* The remote connection was disconnected */
+	if (!kdbus_conn_active(conn_dst))
+		return ERR_PTR(-ECONNRESET);
+
+	/* The connection does not accept file descriptors */
+	if (!(conn_dst->flags & KDBUS_HELLO_ACCEPT_FD) &&
+	    kmsg->res && kmsg->res->fds_count > 0)
+		return ERR_PTR(-ECOMM);
+
+	return kdbus_queue_entry_alloc(conn_dst->pool, kmsg);
+}
+
+/*
+ * Synchronously responding to a message, allocate a queue entry
+ * and attach it to the reply tracking object.
+ * The connection's queue will never get to see it.
+ */
+static int kdbus_conn_entry_sync_attach(struct kdbus_conn *conn_dst,
+					const struct kdbus_kmsg *kmsg,
+					struct kdbus_reply *reply_wake)
+{
+	struct kdbus_queue_entry *entry;
+	int remote_ret;
+	int ret = 0;
+
+	mutex_lock(&reply_wake->reply_dst->lock);
+
+	/*
+	 * If we are still waiting then proceed, allocate a queue
+	 * entry and attach it to the reply object
+	 */
+	if (reply_wake->waiting) {
+		entry = kdbus_conn_entry_make(conn_dst, kmsg);
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
+	kdbus_sync_reply_wakeup(reply_wake, remote_ret);
+	kdbus_reply_unlink(reply_wake);
+	mutex_unlock(&reply_wake->reply_dst->lock);
+
+	return ret;
+}
+
+/**
+ * kdbus_conn_entry_insert() - enqueue a message into the receiver's pool
+ * @conn_src:		The sending connection
+ * @conn_dst:		The connection to queue into
+ * @kmsg:		The kmsg to queue
+ * @reply:		The reply tracker to attach to the queue entry
+ *
+ * Return: 0 on success. negative error otherwise.
+ */
+int kdbus_conn_entry_insert(struct kdbus_conn *conn_src,
+			    struct kdbus_conn *conn_dst,
+			    const struct kdbus_kmsg *kmsg,
+			    struct kdbus_reply *reply)
+{
+	struct kdbus_queue_entry *entry;
+	int ret;
+
+	kdbus_conn_lock2(conn_src, conn_dst);
+
+	/*
+	 * Limit the maximum number of queued messages. This applies
+	 * to all messages, user messages and kernel notifications
+	 *
+	 * The kernel sends notifications to subscribed connections
+	 * only. If the connection do not clean its queue, no further
+	 * message delivery.
+	 * Kernel is able to queue KDBUS_CONN_MAX_MSGS messages, this
+	 * includes all type of notifications.
+	 */
+	if (conn_dst->queue.msg_count >= KDBUS_CONN_MAX_MSGS) {
+		ret = -ENOBUFS;
+		goto exit_unlock;
+	}
+
+	entry = kdbus_conn_entry_make(conn_dst, kmsg);
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
+	 * Remember the reply associated with this queue entry, so we can
+	 * move the reply entry's connection when a connection moves from an
+	 * activator to an implementer.
+	 */
+	entry->reply = kdbus_reply_ref(reply);
+
+	if (reply) {
+		kdbus_reply_link(reply);
+		if (!reply->sync)
+			schedule_delayed_work(&conn_src->work, 0);
+	}
+
+	/* link the message into the receiver's entry */
+	kdbus_queue_entry_add(&conn_dst->queue, entry);
+
+	/* wake up poll() */
+	wake_up_interruptible(&conn_dst->wait);
+
+	ret = 0;
+	goto exit_unlock;
+
+exit_queue_free:
+	kdbus_queue_entry_free(entry);
+exit_unlock:
+	kdbus_conn_unlock2(conn_src, conn_dst);
+	return ret;
+}
+
+/**
+ * kdbus_conn_wait_reply() - Wait for the reply of a synchronous send
+ *			     operation
+ * @conn_src:		The sending connection (origin)
+ * @conn_dst:		The replying connection
+ * @cmd_send:		Payload of SEND command
+ * @ioctl_file:		struct file used to issue this ioctl
+ * @cancel_fd:		Pinned file that reflects KDBUS_ITEM_CANCEL_FD
+ *			item, used to cancel the blocking send call
+ * @reply_wait:		The tracked reply that we are waiting for.
+ * @expire:		Reply timeout
+ *
+ * Return: 0 on success. negative error otherwise.
+ */
+static int kdbus_conn_wait_reply(struct kdbus_conn *conn_src,
+				 struct kdbus_conn *conn_dst,
+				 struct kdbus_cmd_send *cmd_send,
+				 struct file *ioctl_file,
+				 struct file *cancel_fd,
+				 struct kdbus_reply *reply_wait,
+				 ktime_t expire)
+{
+	struct kdbus_queue_entry *entry;
+	struct poll_wqueues pwq = {};
+	int ret;
+
+	if (WARN_ON(!reply_wait))
+		return -EIO;
+
+	/*
+	 * Block until the reply arrives. reply_wait is left untouched
+	 * by the timeout scans that might be conducted for other,
+	 * asynchronous replies of conn_src.
+	 */
+
+	poll_initwait(&pwq);
+	poll_wait(ioctl_file, &conn_src->wait, &pwq.pt);
+
+	for (;;) {
+		/*
+		 * Any of the following conditions will stop our synchronously
+		 * blocking SEND command:
+		 *
+		 * a) The origin sender closed its connection
+		 * b) The remote peer answered, setting reply_wait->waiting = 0
+		 * c) The cancel FD was written to
+		 * d) A signal was received
+		 * e) The specified timeout was reached, and none of the above
+		 *    conditions kicked in.
+		 */
+
+		/*
+		 * We have already acquired an active reference when
+		 * entering here, but another thread may call
+		 * KDBUS_CMD_BYEBYE which does not acquire an active
+		 * reference, therefore kdbus_conn_disconnect() will
+		 * not wait for us.
+		 */
+		if (!kdbus_conn_active(conn_src)) {
+			ret = -ECONNRESET;
+			break;
+		}
+
+		/*
+		 * After the replying peer unset the waiting variable
+		 * it will wake up us.
+		 */
+		if (!reply_wait->waiting) {
+			ret = reply_wait->err;
+			break;
+		}
+
+		if (cancel_fd) {
+			unsigned int r;
+
+			r = cancel_fd->f_op->poll(cancel_fd, &pwq.pt);
+			if (r & POLLIN) {
+				ret = -ECANCELED;
+				break;
+			}
+		}
+
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		if (!poll_schedule_timeout(&pwq, TASK_INTERRUPTIBLE,
+					   &expire, 0)) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		/*
+		 * Reset the poll worker func, so the waitqueues are not
+		 * added to the poll table again. We just reuse what we've
+		 * collected earlier for further iterations.
+		 */
+		init_poll_funcptr(&pwq.pt, NULL);
+	}
+
+	poll_freewait(&pwq);
+
+	if (ret == -EINTR) {
+		/*
+		 * Interrupted system call. Unref the reply object, and pass
+		 * the return value down the chain. Mark the reply as
+		 * interrupted, so the cleanup work can remove it, but do not
+		 * unlink it from the list. Once the syscall restarts, we'll
+		 * pick it up and wait on it again.
+		 */
+		mutex_lock(&conn_src->lock);
+		reply_wait->interrupted = true;
+		schedule_delayed_work(&conn_src->work, 0);
+		mutex_unlock(&conn_src->lock);
+
+		return -ERESTARTSYS;
+	}
+
+	mutex_lock(&conn_src->lock);
+	reply_wait->waiting = false;
+	entry = reply_wait->queue_entry;
+	if (entry) {
+		ret = kdbus_queue_entry_install(entry, conn_src,
+						&cmd_send->reply.return_flags,
+						true);
+		kdbus_pool_slice_publish(entry->slice, &cmd_send->reply.offset,
+					 &cmd_send->reply.msg_size);
+		kdbus_pool_slice_release(entry->slice);
+		kdbus_queue_entry_free(entry);
+	}
+	kdbus_reply_unlink(reply_wait);
+	mutex_unlock(&conn_src->lock);
+
+	return ret;
+}
+
+/**
+ * kdbus_cmd_msg_send() - send a message
+ * @conn_src:		Connection
+ * @cmd:		Payload of SEND command
+ * @ioctl_file:		struct file used to issue this ioctl
+ * @kmsg:		Message to send
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int kdbus_cmd_msg_send(struct kdbus_conn *conn_src,
+		       struct kdbus_cmd_send *cmd,
+		       struct file *ioctl_file,
+		       struct kdbus_kmsg *kmsg)
+{
+	bool sync = cmd->flags & KDBUS_SEND_SYNC_REPLY;
+	struct kdbus_name_entry *name_entry = NULL;
+	struct kdbus_reply *reply_wait = NULL;
+	struct kdbus_reply *reply_wake = NULL;
+	struct kdbus_msg *msg = &kmsg->msg;
+	struct kdbus_conn *conn_dst = NULL;
+	struct kdbus_bus *bus = conn_src->ep->bus;
+	struct file *cancel_fd = NULL;
+	struct kdbus_item *item;
+	int ret = 0;
+
+	/* assign domain-global message sequence number */
+	if (WARN_ON(kmsg->seq > 0))
+		return -EINVAL;
+
+	KDBUS_ITEMS_FOREACH(item, cmd->items, KDBUS_ITEMS_SIZE(cmd, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_CANCEL_FD:
+			/* install cancel_fd only if synchronous */
+			if (!sync)
+				break;
+
+			if (cancel_fd) {
+				ret = -EEXIST;
+				goto exit_put_cancelfd;
+			}
+
+			cancel_fd = fget(item->fds[0]);
+			if (IS_ERR(cancel_fd))
+				return PTR_ERR(cancel_fd);
+
+			if (!cancel_fd->f_op->poll) {
+				ret = -EINVAL;
+				goto exit_put_cancelfd;
+			}
+			break;
+
+		default:
+			ret = -EINVAL;
+			goto exit_put_cancelfd;
+		}
+	}
+
+	kmsg->seq = atomic64_inc_return(&bus->domain->msg_seq_last);
+
+	if (msg->dst_id == KDBUS_DST_ID_BROADCAST) {
+		kdbus_bus_broadcast(bus, conn_src, kmsg);
+		goto exit_put_cancelfd;
+	}
+
+	if (kmsg->res && kmsg->res->dst_name) {
+		/*
+		 * Lock the destination name so it will not get dropped or
+		 * moved between activator/implementer while we try to queue a
+		 * message. We also rely on this to read-lock the entire
+		 * registry so kdbus_meta_conn_collect() will have a consistent
+		 * view of all acquired names on both connections.
+		 * If kdbus_name_lock() gets changed to a per-name lock, we
+		 * really need to read-lock the whole registry here.
+		 */
+		name_entry = kdbus_name_lock(bus->name_registry,
+					     kmsg->res->dst_name);
+		if (!name_entry) {
+			ret = -ESRCH;
+			goto exit_put_cancelfd;
+		}
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
+		if ((msg->flags & KDBUS_MSG_NO_AUTO_START) &&
+		    kdbus_conn_is_activator(conn_dst)) {
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
+		u64 attach_flags;
+
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
+		if (sync && atomic_read(&conn_src->request_count) > 0) {
+			mutex_lock(&conn_src->lock);
+			reply_wait = kdbus_reply_find(conn_dst, conn_src,
+						      kmsg->msg.cookie);
+			if (reply_wait) {
+				if (reply_wait->interrupted) {
+					kdbus_reply_ref(reply_wait);
+					reply_wait->interrupted = false;
+				} else {
+					reply_wait = NULL;
+				}
+			}
+			mutex_unlock(&conn_src->lock);
+
+			if (reply_wait)
+				goto wait_sync;
+		}
+
+		/* Calculate attach flags of conn_src & conn_dst */
+		attach_flags = kdbus_meta_calc_attach_flags(conn_src, conn_dst);
+
+		/*
+		 * If this connection did not fake its metadata then
+		 * lets augment its metadata by the current valid
+		 * metadata
+		 */
+		if (!conn_src->faked_meta) {
+			ret = kdbus_meta_proc_collect(kmsg->proc_meta,
+						      attach_flags);
+			if (ret < 0)
+				goto exit_unref;
+		}
+
+		/*
+		 * If requested, then we always send the current
+		 * description and owned names of source connection
+		 */
+		ret = kdbus_meta_conn_collect(kmsg->conn_meta, kmsg, conn_src,
+					      attach_flags);
+		if (ret < 0)
+			goto exit_unref;
+
+		if (msg->flags & KDBUS_MSG_EXPECT_REPLY) {
+			ret = kdbus_conn_check_access(conn_src, current_cred(),
+						      conn_dst, msg, NULL);
+			if (ret < 0)
+				goto exit_unref;
+
+			reply_wait = kdbus_reply_new(conn_dst, conn_src, msg,
+						     name_entry, sync);
+			if (IS_ERR(reply_wait)) {
+				ret = PTR_ERR(reply_wait);
+				reply_wait = NULL;
+				goto exit_unref;
+			}
+		} else if (msg->flags & KDBUS_MSG_SIGNAL) {
+			if (!kdbus_match_db_match_kmsg(conn_dst->match_db,
+						       conn_src, kmsg)) {
+				ret = -EPERM;
+				goto exit_unref;
+			}
+
+			/*
+			 * A receiver needs TALK access to the sender
+			 * in order to receive signals.
+			 */
+			ret = kdbus_conn_check_access(conn_dst, NULL, conn_src,
+						      msg, NULL);
+			if (ret < 0)
+				goto exit_unref;
+		} else {
+			ret = kdbus_conn_check_access(conn_src, current_cred(),
+						      conn_dst, msg,
+						      &reply_wake);
+			if (ret < 0)
+				goto exit_unref;
+		}
+	}
+
+	/*
+	 * Forward to monitors before queuing the message. Otherwise, the
+	 * receiver might queue a reply before the original message is queued
+	 * on the monitors.
+	 * We never guarantee consistent ordering across connections, but for
+	 * monitors we should at least make sure they get the message before
+	 * anyone else.
+	 */
+	kdbus_bus_eavesdrop(bus, conn_src, kmsg);
+
+	if (reply_wake) {
+		/*
+		 * If we're synchronously responding to a message, allocate a
+		 * queue item and attach it to the reply tracking object.
+		 * The connection's queue will never get to see it.
+		 */
+		ret = kdbus_conn_entry_sync_attach(conn_dst, kmsg, reply_wake);
+		if (ret < 0)
+			goto exit_unref;
+	} else {
+		/*
+		 * Otherwise, put it in the queue and wait for the connection
+		 * to dequeue and receive the message.
+		 */
+		ret = kdbus_conn_entry_insert(conn_src, conn_dst,
+					      kmsg, reply_wait);
+		if (ret < 0)
+			goto exit_unref;
+	}
+
+wait_sync:
+	/* no reason to keep names locked for replies */
+	name_entry = kdbus_name_unlock(bus->name_registry, name_entry);
+
+	if (sync) {
+		ktime_t now = ktime_get();
+		ktime_t expire = ns_to_ktime(msg->timeout_ns);
+
+		if (likely(ktime_compare(now, expire) < 0))
+			ret = kdbus_conn_wait_reply(conn_src, conn_dst, cmd,
+						    ioctl_file, cancel_fd,
+						    reply_wait, expire);
+		else
+			ret = -ETIMEDOUT;
+	}
+
+exit_unref:
+	kdbus_reply_unref(reply_wait);
+	kdbus_reply_unref(reply_wake);
+	kdbus_conn_unref(conn_dst);
+exit_name_unlock:
+	kdbus_name_unlock(bus->name_registry, name_entry);
+exit_put_cancelfd:
+	if (cancel_fd)
+		fput(cancel_fd);
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
+	struct kdbus_queue_entry *entry, *tmp;
+	struct kdbus_bus *bus = conn->ep->bus;
+	struct kdbus_reply *r, *r_tmp;
+	struct kdbus_conn *c;
+	int i, v;
+
+	mutex_lock(&conn->lock);
+	v = atomic_read(&conn->active);
+	if (v == KDBUS_CONN_ACTIVE_NEW) {
+		/* was never connected */
+		mutex_unlock(&conn->lock);
+		return 0;
+	}
+	if (v < 0) {
+		/* already dead */
+		mutex_unlock(&conn->lock);
+		return -EALREADY;
+	}
+	if (ensure_queue_empty && !list_empty(&conn->queue.msg_list)) {
+		/* still busy */
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
+	kdbus_policy_remove_owner(&conn->ep->bus->policy_db, conn);
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	mutex_lock(&conn->ep->lock);
+	down_write(&bus->conn_rwlock);
+
+	/* remove from bus and endpoint */
+	hash_del(&conn->hentry);
+	list_del(&conn->monitor_entry);
+	list_del(&conn->ep_entry);
+
+	up_write(&bus->conn_rwlock);
+	mutex_unlock(&conn->ep->lock);
+
+	/*
+	 * Remove all names associated with this connection; this possibly
+	 * moves queued messages back to the activator connection.
+	 */
+	kdbus_name_remove_by_conn(bus->name_registry, conn);
+
+	/* if we die while other connections wait for our reply, notify them */
+	mutex_lock(&conn->lock);
+	list_for_each_entry_safe(entry, tmp, &conn->queue.msg_list, entry) {
+		if (entry->reply)
+			kdbus_notify_reply_dead(bus, entry->msg.src_id,
+						entry->msg.cookie);
+
+		kdbus_queue_entry_remove(conn, entry);
+		kdbus_pool_slice_release(entry->slice);
+		kdbus_queue_entry_free(entry);
+	}
+
+	list_for_each_entry_safe(r, r_tmp, &conn->reply_list, entry)
+		kdbus_reply_unlink(r);
+	mutex_unlock(&conn->lock);
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	down_read(&bus->conn_rwlock);
+	hash_for_each(bus->conn_hash, i, c, hentry) {
+		mutex_lock(&c->lock);
+		list_for_each_entry_safe(r, r_tmp, &c->reply_list, entry) {
+			if (r->reply_src == conn) {
+				if (r->sync) {
+					kdbus_sync_reply_wakeup(r, -EPIPE);
+					kdbus_reply_unlink(r);
+					continue;
+				}
+
+				/* send a 'connection dead' notification */
+				kdbus_notify_reply_dead(bus, c->id, r->cookie);
+				kdbus_reply_unlink(r);
+			}
+		}
+		mutex_unlock(&c->lock);
+	}
+	up_read(&bus->conn_rwlock);
+
+	if (!kdbus_conn_is_monitor(conn))
+		kdbus_notify_id_change(bus, KDBUS_ITEM_ID_REMOVE,
+				       conn->id, conn->flags);
+
+	kdbus_notify_flush(bus);
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
+static void __kdbus_conn_free(struct kref *kref)
+{
+	struct kdbus_conn *conn = container_of(kref, struct kdbus_conn, kref);
+
+	WARN_ON(kdbus_conn_active(conn));
+	WARN_ON(delayed_work_pending(&conn->work));
+	WARN_ON(!list_empty(&conn->queue.msg_list));
+	WARN_ON(!list_empty(&conn->names_list));
+	WARN_ON(!list_empty(&conn->names_queue_list));
+	WARN_ON(!list_empty(&conn->reply_list));
+
+	if (conn->user) {
+		atomic_dec(&conn->user->connections);
+		kdbus_domain_user_unref(conn->user);
+	}
+
+	kdbus_meta_proc_unref(conn->meta);
+	kdbus_match_db_free(conn->match_db);
+	kdbus_pool_free(conn->pool);
+	kdbus_ep_unref(conn->ep);
+	put_cred(conn->cred);
+	kfree(conn->description);
+	kfree(conn);
+}
+
+/**
+ * kdbus_conn_ref() - take a connection reference
+ * @conn:		Connection, may be %NULL
+ *
+ * Return: the connection itself
+ */
+struct kdbus_conn *kdbus_conn_ref(struct kdbus_conn *conn)
+{
+	if (conn)
+		kref_get(&conn->kref);
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
+ * an implementer connection is taking over/giving back a well-known name
+ * from/to an activator connection.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_conn_move_messages(struct kdbus_conn *conn_dst,
+			     struct kdbus_conn *conn_src,
+			     u64 name_id)
+{
+	struct kdbus_queue_entry *q, *q_tmp;
+	struct kdbus_reply *r, *r_tmp;
+	struct kdbus_bus *bus;
+	struct kdbus_conn *c;
+	LIST_HEAD(msg_list);
+	int i, ret = 0;
+
+	if (WARN_ON(!mutex_is_locked(&conn_dst->ep->bus->lock)))
+		return -EINVAL;
+
+	if (WARN_ON(conn_src == conn_dst))
+		return -EINVAL;
+
+	bus = conn_src->ep->bus;
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	down_read(&bus->conn_rwlock);
+	hash_for_each(bus->conn_hash, i, c, hentry) {
+		if (c == conn_src || c == conn_dst)
+			continue;
+
+		mutex_lock(&c->lock);
+		list_for_each_entry_safe(r, r_tmp, &c->reply_list, entry) {
+			if (r->reply_src != conn_src)
+				continue;
+
+			/* filter messages for a specific name */
+			if (name_id > 0 && r->name_id != name_id)
+				continue;
+
+			kdbus_conn_unref(r->reply_src);
+			r->reply_src = kdbus_conn_ref(conn_dst);
+		}
+		mutex_unlock(&c->lock);
+	}
+	up_read(&bus->conn_rwlock);
+
+	kdbus_conn_lock2(conn_src, conn_dst);
+	list_for_each_entry_safe(q, q_tmp, &conn_src->queue.msg_list, entry) {
+		/* filter messages for a specific name */
+		if (name_id > 0 && q->dst_name_id != name_id)
+			continue;
+
+		kdbus_queue_entry_remove(conn_src, q);
+
+		if (!(conn_dst->flags & KDBUS_HELLO_ACCEPT_FD) &&
+		    q->msg_res && q->msg_res->fds_count > 0) {
+			atomic_inc(&conn_dst->lost_count);
+			continue;
+		}
+
+		ret = kdbus_queue_entry_move(conn_dst, q);
+		if (ret < 0) {
+			atomic_inc(&conn_dst->lost_count);
+			kdbus_queue_entry_free(q);
+		}
+	}
+	kdbus_conn_unlock2(conn_src, conn_dst);
+
+	/* wake up poll() */
+	wake_up_interruptible(&conn_dst->wait);
+
+	return ret;
+}
+
+/**
+ * kdbus_cmd_conn_info() - retrieve info about a connection
+ * @conn:		Connection
+ * @cmd_info:		The command as passed in by the ioctl
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kdbus_cmd_conn_info(struct kdbus_conn *conn,
+			struct kdbus_cmd_info *cmd_info)
+{
+	struct kdbus_meta_conn *conn_meta = NULL;
+	struct kdbus_pool_slice *slice = NULL;
+	struct kdbus_name_entry *entry = NULL;
+	struct kdbus_conn *owner_conn = NULL;
+	struct kdbus_item *meta_items = NULL;
+	struct kdbus_info info = {};
+	struct kvec kvec[2];
+	size_t meta_size;
+	u64 attach_flags;
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
+		entry = kdbus_name_lock(conn->ep->bus->name_registry, name);
+		if (!entry || !kdbus_conn_policy_see_name(conn, current_cred(),
+							  name)) {
+			/* pretend a name doesn't exist if you cannot see it */
+			ret = -ESRCH;
+			goto exit;
+		}
+
+		if (entry->conn)
+			owner_conn = kdbus_conn_ref(entry->conn);
+	} else {
+		owner_conn = kdbus_bus_find_conn_by_id(conn->ep->bus,
+						       cmd_info->id);
+		if (!owner_conn || !kdbus_conn_policy_see(conn, current_cred(),
+							  owner_conn)) {
+			/* pretend an id doesn't exist if you cannot see it */
+			ret = -ENXIO;
+			goto exit;
+		}
+	}
+
+	info.id = owner_conn->id;
+	info.flags = owner_conn->flags;
+
+	/* mask out what information the connection wants to pass us */
+	attach_flags = cmd_info->flags &
+		       atomic64_read(&owner_conn->attach_flags_send);
+
+	conn_meta = kdbus_meta_conn_new();
+	if (IS_ERR(conn_meta)) {
+		ret = PTR_ERR(conn_meta);
+		conn_meta = NULL;
+		goto exit;
+	}
+
+	ret = kdbus_meta_conn_collect(conn_meta, NULL, owner_conn,
+				      attach_flags);
+	if (ret < 0)
+		goto exit;
+
+	meta_items = kdbus_meta_export(owner_conn->meta, conn_meta,
+				       attach_flags, &meta_size);
+	if (IS_ERR(meta_items)) {
+		ret = PTR_ERR(meta_items);
+		meta_items = NULL;
+		goto exit;
+	}
+
+	kdbus_kvec_set(&kvec[0], &info, sizeof(info), &info.size);
+	kdbus_kvec_set(&kvec[1], meta_items, meta_size, &info.size);
+
+	slice = kdbus_pool_slice_alloc(conn->pool, info.size,
+				       kvec, NULL, ARRAY_SIZE(kvec));
+	if (IS_ERR(slice)) {
+		ret = PTR_ERR(slice);
+		slice = NULL;
+		goto exit;
+	}
+
+	/* write back the offset */
+	kdbus_pool_slice_publish(slice, &cmd_info->offset,
+				 &cmd_info->info_size);
+	ret = 0;
+
+	kdbus_pool_slice_release(slice);
+exit:
+	kfree(meta_items);
+	kdbus_meta_conn_unref(conn_meta);
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
+	struct kdbus_bus *bus = conn->ep->bus;
+	bool send_flags_provided = false;
+	bool recv_flags_provided = false;
+	bool policy_provided = false;
+	const struct kdbus_item *item;
+	u64 attach_send;
+	u64 attach_recv;
+	int ret;
+
+	KDBUS_ITEMS_FOREACH(item, cmd->items, KDBUS_ITEMS_SIZE(cmd, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_ATTACH_FLAGS_SEND:
+			/*
+			 * Only ordinary or monitor connections may update
+			 * their attach-flags-send. attach-flags-recv can
+			 * additionally be updated by activators.
+			 */
+			if (!kdbus_conn_is_ordinary(conn) &&
+			    !kdbus_conn_is_monitor(conn))
+				return -EOPNOTSUPP;
+
+			ret = kdbus_sanitize_attach_flags(item->data64[0],
+							  &attach_send);
+			if (ret < 0)
+				return ret;
+
+			send_flags_provided = true;
+			break;
+
+		case KDBUS_ITEM_ATTACH_FLAGS_RECV:
+			if (!kdbus_conn_is_ordinary(conn) &&
+			    !kdbus_conn_is_monitor(conn) &&
+			    !kdbus_conn_is_activator(conn))
+				return -EOPNOTSUPP;
+
+			ret = kdbus_sanitize_attach_flags(item->data64[0],
+							  &attach_recv);
+			if (ret < 0)
+				return ret;
+
+			recv_flags_provided = true;
+			break;
+
+		case KDBUS_ITEM_NAME:
+		case KDBUS_ITEM_POLICY_ACCESS:
+			/*
+			 * Only policy holders may update their policy
+			 * entries. Policy holders are privileged
+			 * connections.
+			 */
+			if (!kdbus_conn_is_policy_holder(conn))
+				return -EOPNOTSUPP;
+
+			policy_provided = true;
+			break;
+
+		default:
+			return -EINVAL;
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
+	if (send_flags_provided) {
+		/*
+		 * The attach flags send must always satisfy the
+		 * bus requirements.
+		 */
+		if (bus->attach_flags_req & ~attach_send)
+			return -EINVAL;
+
+		atomic64_set(&conn->attach_flags_send, attach_send);
+	}
+
+	if (recv_flags_provided)
+		atomic64_set(&conn->attach_flags_recv, attach_recv);
+
+	return 0;
+}
+
+/**
+ * kdbus_conn_new() - create a new connection
+ * @ep:			The endpoint the connection is connected to
+ * @hello:		The kdbus_cmd_hello as passed in by the user
+ * @privileged:		Whether to create a privileged connection
+ *
+ * Return: a new kdbus_conn on success, ERR_PTR on failure
+ */
+struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep,
+				  struct kdbus_cmd_hello *hello,
+				  bool privileged)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	static struct lock_class_key __key;
+#endif
+	const struct kdbus_creds *creds = NULL;
+	struct kdbus_pool_slice *slice = NULL;
+	const struct kdbus_pids *pids = NULL;
+	struct kdbus_item_list items = {};
+	struct kdbus_bus *bus = ep->bus;
+	const struct kdbus_item *item;
+	const char *conn_description = NULL;
+	const char *seclabel = NULL;
+	const char *name = NULL;
+	struct kdbus_conn *conn;
+	u64 attach_flags_send;
+	u64 attach_flags_recv;
+	bool is_policy_holder;
+	bool is_activator;
+	bool is_monitor;
+	struct kvec kvec[2];
+	int ret;
+
+	struct {
+		/* bloom item */
+		u64 size;
+		u64 type;
+		struct kdbus_bloom_parameter bloom;
+	} bloom_item;
+
+	is_monitor = hello->flags & KDBUS_HELLO_MONITOR;
+	is_activator = hello->flags & KDBUS_HELLO_ACTIVATOR;
+	is_policy_holder = hello->flags & KDBUS_HELLO_POLICY_HOLDER;
+
+	/* can only be one of monitor/activator/policy_holder */
+	if (is_monitor + is_activator + is_policy_holder > 1)
+		return ERR_PTR(-EINVAL);
+
+	/* Monitors are disallowed on custom endpoints */
+	if (is_monitor && ep->has_policy)
+		return ERR_PTR(-EOPNOTSUPP);
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
+		case KDBUS_ITEM_PIDS:
+			/* privileged processes can impersonate somebody else */
+			if (!privileged)
+				return ERR_PTR(-EPERM);
+
+			if (item->size != KDBUS_ITEM_SIZE(sizeof(*pids)))
+				return ERR_PTR(-EINVAL);
+
+			pids = &item->pids;
+			break;
+
+		case KDBUS_ITEM_SECLABEL:
+			/* privileged processes can impersonate somebody else */
+			if (!privileged)
+				return ERR_PTR(-EPERM);
+
+			seclabel = item->str;
+			break;
+
+		case KDBUS_ITEM_CONN_DESCRIPTION:
+			/* human-readable connection name (debugging) */
+			if (conn_description)
+				return ERR_PTR(-EINVAL);
+
+			conn_description = item->str;
+			break;
+
+		case KDBUS_ITEM_POLICY_ACCESS:
+		case KDBUS_ITEM_BLOOM_MASK:
+		case KDBUS_ITEM_ID:
+		case KDBUS_ITEM_NAME_ADD:
+		case KDBUS_ITEM_NAME_REMOVE:
+		case KDBUS_ITEM_NAME_CHANGE:
+		case KDBUS_ITEM_ID_ADD:
+		case KDBUS_ITEM_ID_REMOVE:
+			/* will be handled by policy and match code */
+			break;
+
+		default:
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	if ((is_activator || is_policy_holder) && !name)
+		return ERR_PTR(-EINVAL);
+
+	ret = kdbus_sanitize_attach_flags(hello->attach_flags_send,
+					  &attach_flags_send);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	ret = kdbus_sanitize_attach_flags(hello->attach_flags_recv,
+					  &attach_flags_recv);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Let userspace know which flags are enforced by the bus */
+	hello->attach_flags_send = bus->attach_flags_req | KDBUS_FLAG_KERNEL;
+
+	/*
+	 * The attach flags must always satisfy the bus
+	 * requirements.
+	 */
+	if (bus->attach_flags_req & ~attach_flags_send)
+		return ERR_PTR(-ECONNREFUSED);
+
+	conn = kzalloc(sizeof(*conn), GFP_KERNEL);
+	if (!conn)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&conn->kref);
+	atomic_set(&conn->active, KDBUS_CONN_ACTIVE_NEW);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_init_map(&conn->dep_map, "s_active", &__key, 0);
+#endif
+	mutex_init(&conn->lock);
+	INIT_LIST_HEAD(&conn->names_list);
+	INIT_LIST_HEAD(&conn->names_queue_list);
+	INIT_LIST_HEAD(&conn->reply_list);
+	atomic_set(&conn->name_count, 0);
+	atomic_set(&conn->request_count, 0);
+	atomic_set(&conn->lost_count, 0);
+	INIT_DELAYED_WORK(&conn->work, kdbus_reply_list_scan_work);
+	conn->cred = get_current_cred();
+	init_waitqueue_head(&conn->wait);
+	kdbus_queue_init(&conn->queue);
+	conn->privileged = privileged;
+	conn->ep = kdbus_ep_ref(ep);
+	conn->id = atomic64_inc_return(&bus->conn_seq_last);
+	conn->flags = hello->flags;
+	atomic64_set(&conn->attach_flags_send, attach_flags_send);
+	atomic64_set(&conn->attach_flags_recv, attach_flags_recv);
+	/* init entry, so we can remove it unconditionally */
+	INIT_LIST_HEAD(&conn->monitor_entry);
+
+	if (conn_description) {
+		conn->description = kstrdup(conn_description, GFP_KERNEL);
+		if (!conn->description) {
+			ret = -ENOMEM;
+			goto exit_unref;
+		}
+	}
+
+	conn->pool = kdbus_pool_new(conn->description, hello->pool_size);
+	if (IS_ERR(conn->pool)) {
+		ret = PTR_ERR(conn->pool);
+		conn->pool = NULL;
+		goto exit_unref;
+	}
+
+	conn->match_db = kdbus_match_db_new();
+	if (IS_ERR(conn->match_db)) {
+		ret = PTR_ERR(conn->match_db);
+		conn->match_db = NULL;
+		goto exit_unref;
+	}
+
+	/* return properties of this connection to the caller */
+	hello->bus_flags = bus->bus_flags;
+	hello->id = conn->id;
+
+	BUILD_BUG_ON(sizeof(bus->id128) != sizeof(hello->id128));
+	memcpy(hello->id128, bus->id128, sizeof(hello->id128));
+
+	conn->meta = kdbus_meta_proc_new();
+	if (IS_ERR(conn->meta)) {
+		ret = PTR_ERR(conn->meta);
+		conn->meta = NULL;
+		goto exit_unref;
+	}
+
+	/* privileged processes can impersonate somebody else */
+	if (creds || pids || seclabel) {
+		ret = kdbus_meta_proc_fake(conn->meta, creds, pids, seclabel);
+		if (ret < 0)
+			goto exit_unref;
+
+		conn->faked_meta = true;
+	} else {
+		ret = kdbus_meta_proc_collect(conn->meta,
+					      KDBUS_ATTACH_CREDS |
+					      KDBUS_ATTACH_PIDS |
+					      KDBUS_ATTACH_AUXGROUPS |
+					      KDBUS_ATTACH_TID_COMM |
+					      KDBUS_ATTACH_PID_COMM |
+					      KDBUS_ATTACH_EXE |
+					      KDBUS_ATTACH_CMDLINE |
+					      KDBUS_ATTACH_CGROUP |
+					      KDBUS_ATTACH_CAPS |
+					      KDBUS_ATTACH_SECLABEL |
+					      KDBUS_ATTACH_AUDIT);
+		if (ret < 0)
+			goto exit_unref;
+	}
+
+	/*
+	 * Account the connection against the current user (UID), or for
+	 * custom endpoints use the anonymous user assigned to the endpoint.
+	 * Note that limits are always accounted against the real UID, not
+	 * the effective UID (cred->user always points to the accounting of
+	 * cred->uid, not cred->euid).
+	 */
+	if (ep->user) {
+		conn->user = kdbus_domain_user_ref(ep->user);
+	} else {
+		conn->user = kdbus_domain_get_user(ep->bus->domain,
+						   current_uid());
+		if (IS_ERR(conn->user)) {
+			ret = PTR_ERR(conn->user);
+			conn->user = NULL;
+			goto exit_unref;
+		}
+	}
+
+	if (atomic_inc_return(&conn->user->connections) > KDBUS_USER_MAX_CONN) {
+		/* decremented by destructor as conn->user is valid */
+		ret = -EMFILE;
+		goto exit_unref;
+	}
+
+	bloom_item.size = sizeof(bloom_item);
+	bloom_item.type = KDBUS_ITEM_BLOOM_PARAMETER;
+	bloom_item.bloom = bus->bloom;
+	kdbus_kvec_set(&kvec[0], &items, sizeof(items), &items.size);
+	kdbus_kvec_set(&kvec[1], &bloom_item, bloom_item.size, &items.size);
+
+	slice = kdbus_pool_slice_alloc(conn->pool, items.size, kvec, NULL,
+				       ARRAY_SIZE(kvec));
+	if (IS_ERR(slice)) {
+		ret = PTR_ERR(slice);
+		slice = NULL;
+		goto exit_unref;
+	}
+
+	kdbus_pool_slice_publish(slice, &hello->offset, &hello->items_size);
+	kdbus_pool_slice_release(slice);
+
+	return conn;
+
+exit_unref:
+	kdbus_pool_slice_release(slice);
+	kdbus_conn_unref(conn);
+	return ERR_PTR(ret);
+}
+
+/**
+ * kdbus_conn_connect() - introduce a connection to a bus
+ * @conn:		Connection
+ * @hello:		Hello parameters
+ *
+ * This puts life into a kdbus-conn object. A connection to the bus is
+ * established and the peer will be reachable via the bus (if it is an ordinary
+ * connection).
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kdbus_conn_connect(struct kdbus_conn *conn, struct kdbus_cmd_hello *hello)
+{
+	struct kdbus_ep *ep = conn->ep;
+	struct kdbus_bus *bus = ep->bus;
+	int ret;
+
+	if (WARN_ON(atomic_read(&conn->active) != KDBUS_CONN_ACTIVE_NEW))
+		return -EALREADY;
+
+	/* make sure the ep-node is active while we add our connection */
+	if (!kdbus_node_acquire(&ep->node))
+		return -ESHUTDOWN;
+
+	/* lock order: domain -> bus -> ep -> names -> conn */
+	mutex_lock(&bus->lock);
+	mutex_lock(&ep->lock);
+	down_write(&bus->conn_rwlock);
+
+	/* link into monitor list */
+	if (kdbus_conn_is_monitor(conn))
+		list_add_tail(&conn->monitor_entry, &bus->monitors_list);
+
+	/* link into bus and endpoint */
+	list_add_tail(&conn->ep_entry, &ep->conn_list);
+	hash_add(bus->conn_hash, &conn->hentry, conn->id);
+
+	/* enable lookups and acquire active ref */
+	atomic_set(&conn->active, 1);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	rwsem_acquire_read(&conn->dep_map, 0, 1, _RET_IP_);
+#endif
+
+	up_write(&bus->conn_rwlock);
+	mutex_unlock(&ep->lock);
+	mutex_unlock(&bus->lock);
+
+	kdbus_node_release(&ep->node);
+
+	/*
+	 * Notify subscribers about the new active connection, unless it is
+	 * a monitor. Monitors are invisible on the bus, can't be addressed
+	 * directly, and won't cause any notifications.
+	 */
+	if (!kdbus_conn_is_monitor(conn)) {
+		ret = kdbus_notify_id_change(conn->ep->bus, KDBUS_ITEM_ID_ADD,
+					     conn->id, conn->flags);
+		if (ret < 0)
+			goto exit_disconnect;
+	}
+
+	if (kdbus_conn_is_activator(conn)) {
+		u64 flags = KDBUS_NAME_ACTIVATOR;
+		const char *name;
+
+		name = kdbus_items_get_str(hello->items,
+					   KDBUS_ITEMS_SIZE(hello, items),
+					   KDBUS_ITEM_NAME);
+		if (WARN_ON(!name)) {
+			ret = -EINVAL;
+			goto exit_disconnect;
+		}
+
+		ret = kdbus_name_acquire(bus->name_registry, conn, name,
+					 &flags);
+		if (ret < 0)
+			goto exit_disconnect;
+	}
+
+	kdbus_conn_release(conn);
+	kdbus_notify_flush(bus);
+	return 0;
+
+exit_disconnect:
+	kdbus_conn_release(conn);
+	kdbus_conn_disconnect(conn, false);
+	return ret;
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
+
+/* query the policy-database for all names of @whom */
+static bool kdbus_conn_policy_query_all(struct kdbus_conn *conn,
+					const struct cred *conn_creds,
+					struct kdbus_policy_db *db,
+					struct kdbus_conn *whom,
+					unsigned int access)
+{
+	struct kdbus_name_entry *ne;
+	bool pass = false;
+	int res;
+
+	down_read(&db->entries_rwlock);
+	mutex_lock(&whom->lock);
+
+	list_for_each_entry(ne, &whom->names_list, conn_entry) {
+		res = kdbus_policy_query_unlocked(db, conn_creds ? : conn->cred,
+						  ne->name,
+						  kdbus_strhash(ne->name));
+		if (res >= (int)access) {
+			pass = true;
+			break;
+		}
+	}
+
+	mutex_unlock(&whom->lock);
+	up_read(&db->entries_rwlock);
+
+	return pass;
+}
+
+/**
+ * kdbus_conn_policy_own_name() - verify a connection can own the given name
+ * @conn:		Connection
+ * @conn_creds:		Credentials of @conn to use for policy check
+ * @name:		Name
+ *
+ * This verifies that @conn is allowed to acquire the well-known name @name.
+ *
+ * Return: true if allowed, false if not.
+ */
+bool kdbus_conn_policy_own_name(struct kdbus_conn *conn,
+				const struct cred *conn_creds,
+				const char *name)
+{
+	unsigned int hash = kdbus_strhash(name);
+	int res;
+
+	if (!conn_creds)
+		conn_creds = conn->cred;
+
+	if (conn->ep->has_policy) {
+		res = kdbus_policy_query(&conn->ep->policy_db, conn_creds,
+					 name, hash);
+		if (res < KDBUS_POLICY_OWN)
+			return false;
+	}
+
+	if (conn->privileged)
+		return true;
+
+	res = kdbus_policy_query(&conn->ep->bus->policy_db, conn_creds,
+				 name, hash);
+	return res >= KDBUS_POLICY_OWN;
+}
+
+/**
+ * kdbus_conn_policy_talk() - verify a connection can talk to a given peer
+ * @conn:		Connection that tries to talk
+ * @conn_creds:		Credentials of @conn to use for policy check
+ * @to:			Connection that is talked to
+ *
+ * This verifies that @conn is allowed to talk to @to.
+ *
+ * Return: true if allowed, false if not.
+ */
+bool kdbus_conn_policy_talk(struct kdbus_conn *conn,
+			    const struct cred *conn_creds,
+			    struct kdbus_conn *to)
+{
+	if (!conn_creds)
+		conn_creds = conn->cred;
+
+	if (conn->ep->has_policy &&
+	    !kdbus_conn_policy_query_all(conn, conn_creds, &conn->ep->policy_db,
+					 to, KDBUS_POLICY_TALK))
+		return false;
+
+	if (conn->privileged)
+		return true;
+	if (uid_eq(conn_creds->euid, to->cred->uid))
+		return true;
+
+	return kdbus_conn_policy_query_all(conn, conn_creds,
+					   &conn->ep->bus->policy_db, to,
+					   KDBUS_POLICY_TALK);
+}
+
+/**
+ * kdbus_conn_policy_see_name_unlocked() - verify a connection can see a given
+ *					   name
+ * @conn:		Connection
+ * @conn_creds:		Credentials of @conn to use for policy check
+ * @name:		Name
+ *
+ * This verifies that @conn is allowed to see the well-known name @name. Caller
+ * must hold policy-lock.
+ *
+ * Return: true if allowed, false if not.
+ */
+bool kdbus_conn_policy_see_name_unlocked(struct kdbus_conn *conn,
+					 const struct cred *conn_creds,
+					 const char *name)
+{
+	int res;
+
+	/*
+	 * By default, all names are visible on a bus. SEE policies can only be
+	 * installed on custom endpoints, where by default no name is visible.
+	 */
+	if (!conn->ep->has_policy)
+		return true;
+
+	res = kdbus_policy_query_unlocked(&conn->ep->policy_db,
+					  conn_creds ? : conn->cred,
+					  name, kdbus_strhash(name));
+	return res >= KDBUS_POLICY_SEE;
+}
+
+/**
+ * kdbus_conn_policy_see_name() - verify a connection can see a given name
+ * @conn:		Connection
+ * @conn_creds:		Credentials of @conn to use for policy check
+ * @name:		Name
+ *
+ * This verifies that @conn is allowed to see the well-known name @name.
+ *
+ * Return: true if allowed, false if not.
+ */
+bool kdbus_conn_policy_see_name(struct kdbus_conn *conn,
+				const struct cred *conn_creds,
+				const char *name)
+{
+	bool res;
+
+	down_read(&conn->ep->policy_db.entries_rwlock);
+	res = kdbus_conn_policy_see_name_unlocked(conn, conn_creds, name);
+	up_read(&conn->ep->policy_db.entries_rwlock);
+
+	return res;
+}
+
+/**
+ * kdbus_conn_policy_see() - verify a connection can see a given peer
+ * @conn:		Connection to verify whether it sees a peer
+ * @conn_creds:		Credentials of @conn to use for policy check
+ * @whom:		Peer destination that is to be 'seen'
+ *
+ * This checks whether @conn is able to see @whom.
+ *
+ * Return: true if allowed, false if not.
+ */
+bool kdbus_conn_policy_see(struct kdbus_conn *conn,
+			   const struct cred *conn_creds,
+			   struct kdbus_conn *whom)
+{
+	/*
+	 * By default, all names are visible on a bus, so a connection can
+	 * always see other connections. SEE policies can only be installed on
+	 * custom endpoints, where by default no name is visible and we hide
+	 * peers from each other, unless you see at least _one_ name of the
+	 * peer.
+	 */
+	return !conn->ep->has_policy ||
+	       kdbus_conn_policy_query_all(conn, conn_creds,
+					   &conn->ep->policy_db, whom,
+					   KDBUS_POLICY_SEE);
+}
+
+/**
+ * kdbus_conn_policy_see_notification() - verify a connection is allowed to
+ *					  receive a given kernel notification
+ * @conn:		Connection
+ * @conn_creds:		Credentials of @conn to use for policy check
+ * @kmsg:		The message carrying the notification
+ *
+ * This checks whether @conn is allowed to see the kernel notification @kmsg.
+ *
+ * Return: true if allowed, false if not.
+ */
+bool kdbus_conn_policy_see_notification(struct kdbus_conn *conn,
+					const struct cred *conn_creds,
+					const struct kdbus_kmsg *kmsg)
+{
+	if (WARN_ON(kmsg->msg.src_id != KDBUS_SRC_ID_KERNEL))
+		return false;
+
+	/*
+	 * Depending on the notification type, broadcasted kernel notifications
+	 * have to be filtered:
+	 *
+	 * KDBUS_ITEM_NAME_{ADD,REMOVE,CHANGE}: This notification is forwarded
+	 *     to a peer if, and only if, that peer can see the name this
+	 *     notification is for.
+	 *
+	 * KDBUS_ITEM_ID_{ADD,REMOVE}: As new peers cannot have names, and all
+	 *     names are dropped before a peer is removed, those notifications
+	 *     cannot be seen on custom endpoints. Thus, we only pass them
+	 *     through on default endpoints.
+	 */
+
+	switch (kmsg->notify_type) {
+	case KDBUS_ITEM_NAME_ADD:
+	case KDBUS_ITEM_NAME_REMOVE:
+	case KDBUS_ITEM_NAME_CHANGE:
+		return kdbus_conn_policy_see_name(conn, conn_creds,
+						  kmsg->notify_name);
+
+	case KDBUS_ITEM_ID_ADD:
+	case KDBUS_ITEM_ID_REMOVE:
+		return !conn->ep->has_policy;
+
+	default:
+		WARN(1, "Invalid type for notification broadcast: %llu\n",
+		     (unsigned long long)kmsg->notify_type);
+		return false;
+	}
+}
diff --git a/ipc/kdbus/connection.h b/ipc/kdbus/connection.h
new file mode 100644
index 000000000000..ff25931a4dd0
--- /dev/null
+++ b/ipc/kdbus/connection.h
@@ -0,0 +1,262 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+#include <linux/path.h>
+
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
+ * @description:	Human-readable connection description, used for
+ *			debugging. This field is only set when the
+ *			connection is created.
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
+ * @pool:		The user's buffer to receive messages
+ * @user:		Owner of the connection
+ * @cred:		The credentials of the connection at creation time
+ * @name_count:		Number of owned well-known names
+ * @request_count:	Number of pending requests issued by this
+ *			connection that are waiting for replies from
+ *			other peers
+ * @lost_count:		Number of lost broadcast messages
+ * @wait:		Wake up this endpoint
+ * @queue:		The message queue associated with this connection
+ * @privileged:		Whether this connection is privileged on the bus
+ * @faked_meta:		Whether the metadata was faked on HELLO
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
+	const char *description;
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
+	struct kdbus_meta_proc *meta;
+	struct kdbus_pool *pool;
+	struct kdbus_domain_user *user;
+	const struct cred *cred;
+	atomic_t name_count;
+	atomic_t request_count;
+	atomic_t lost_count;
+	wait_queue_head_t wait;
+	struct kdbus_queue queue;
+
+	bool privileged:1;
+	bool faked_meta:1;
+};
+
+struct kdbus_kmsg;
+struct kdbus_name_registry;
+
+struct kdbus_conn *kdbus_conn_new(struct kdbus_ep *ep,
+				  struct kdbus_cmd_hello *hello,
+				  bool privileged);
+struct kdbus_conn *kdbus_conn_ref(struct kdbus_conn *conn);
+struct kdbus_conn *kdbus_conn_unref(struct kdbus_conn *conn);
+int kdbus_conn_acquire(struct kdbus_conn *conn);
+void kdbus_conn_release(struct kdbus_conn *conn);
+int kdbus_conn_connect(struct kdbus_conn *conn, struct kdbus_cmd_hello *hello);
+int kdbus_conn_disconnect(struct kdbus_conn *conn, bool ensure_queue_empty);
+bool kdbus_conn_active(const struct kdbus_conn *conn);
+int kdbus_conn_entry_insert(struct kdbus_conn *conn_src,
+			    struct kdbus_conn *conn_dst,
+			    const struct kdbus_kmsg *kmsg,
+			    struct kdbus_reply *reply);
+int kdbus_conn_move_messages(struct kdbus_conn *conn_dst,
+			     struct kdbus_conn *conn_src,
+			     u64 name_id);
+bool kdbus_conn_has_name(struct kdbus_conn *conn, const char *name);
+
+/* policy */
+bool kdbus_conn_policy_own_name(struct kdbus_conn *conn,
+				const struct cred *conn_creds,
+				const char *name);
+bool kdbus_conn_policy_talk(struct kdbus_conn *conn,
+			    const struct cred *conn_creds,
+			    struct kdbus_conn *to);
+bool kdbus_conn_policy_see_name_unlocked(struct kdbus_conn *conn,
+					 const struct cred *curr_creds,
+					 const char *name);
+bool kdbus_conn_policy_see_name(struct kdbus_conn *conn,
+				const struct cred *curr_creds,
+				const char *name);
+bool kdbus_conn_policy_see(struct kdbus_conn *conn,
+			   const struct cred *curr_creds,
+			   struct kdbus_conn *whom);
+bool kdbus_conn_policy_see_notification(struct kdbus_conn *conn,
+					const struct cred *curr_creds,
+					const struct kdbus_kmsg *kmsg);
+
+/* command dispatcher */
+int kdbus_cmd_msg_send(struct kdbus_conn *conn_src,
+		       struct kdbus_cmd_send *cmd_send,
+		       struct file *ioctl_file,
+		       struct kdbus_kmsg *kmsg);
+int kdbus_cmd_msg_recv(struct kdbus_conn *conn,
+		       struct kdbus_cmd_recv *recv);
+int kdbus_cmd_conn_info(struct kdbus_conn *conn,
+			struct kdbus_cmd_info *cmd_info);
+int kdbus_cmd_conn_update(struct kdbus_conn *conn,
+			  const struct kdbus_cmd_update *cmd_update);
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
+/**
+ * kdbus_conn_lock2() - Lock two connections
+ * @a:		connection A to lock or NULL
+ * @b:		connection B to lock or NULL
+ *
+ * Lock two connections at once. As we need to have a stable locking order, we
+ * always lock the connection with lower memory address first.
+ */
+static inline void kdbus_conn_lock2(struct kdbus_conn *a, struct kdbus_conn *b)
+{
+	if (a < b) {
+		if (a)
+			mutex_lock(&a->lock);
+		if (b && b != a)
+			mutex_lock_nested(&b->lock, !!a);
+	} else {
+		if (b)
+			mutex_lock(&b->lock);
+		if (a && a != b)
+			mutex_lock_nested(&a->lock, !!b);
+	}
+}
+
+/**
+ * kdbus_conn_unlock2() - Unlock two connections
+ * @a:		connection A to unlock or NULL
+ * @b:		connection B to unlock or NULL
+ *
+ * Unlock two connections at once. See kdbus_conn_lock2().
+ */
+static inline void kdbus_conn_unlock2(struct kdbus_conn *a,
+				      struct kdbus_conn *b)
+{
+	if (a)
+		mutex_unlock(&a->lock);
+	if (b && b != a)
+		mutex_unlock(&b->lock);
+}
+
+/**
+ * kdbus_conn_assert_active() - lockdep assert on active lock
+ * @conn:	connection that shall be active
+ *
+ * This verifies via lockdep that the caller holds an active reference to the
+ * given connection.
+ */
+static inline void kdbus_conn_assert_active(struct kdbus_conn *conn)
+{
+	lockdep_assert_held(conn);
+}
+
+#endif
diff --git a/ipc/kdbus/item.c b/ipc/kdbus/item.c
new file mode 100644
index 000000000000..95bc3822ed45
--- /dev/null
+++ b/ipc/kdbus/item.c
@@ -0,0 +1,309 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
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
+	((_i)->size >= KDBUS_ITEM_HEADER_SIZE &&			\
+	 (u8 *)(_i) + (_i)->size > (u8 *)(_i) &&			\
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
+	case KDBUS_ITEM_CANCEL_FD:
+		if (payload_size != sizeof(int))
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
+		if (payload_size % sizeof(u32) != 0)
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
+ * kdbus_items_get() - Find unique item in item-array
+ * @items:		items to search through
+ * @items_size:		total size of item array
+ * @item_type:		item-type to find
+ *
+ * Return: Pointer to found item, ERR_PTR if not found or available multiple
+ *         times.
+ */
+struct kdbus_item *kdbus_items_get(const struct kdbus_item *items,
+				   size_t items_size,
+				   unsigned int item_type)
+{
+	const struct kdbus_item *iter, *found = NULL;
+
+	KDBUS_ITEMS_FOREACH(iter, items, items_size) {
+		if (iter->type == item_type) {
+			if (found)
+				return ERR_PTR(-EEXIST);
+			found = iter;
+		}
+	}
+
+	return (struct kdbus_item *)found ? : ERR_PTR(-EBADMSG);
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
+
+	item = kdbus_items_get(items, items_size, item_type);
+	return IS_ERR(item) ? ERR_CAST(item) : item->str;
+}
+
+/**
+ * kdbus_item_set() - Set item content
+ * @item:	The item to modify
+ * @type:	The item type to set (KDBUS_ITEM_*)
+ * @data:	Data to copy to item->data, may be %NULL
+ * @len:	Number of bytes in @data
+ *
+ * This sets type, size and data fields of an item. If @data is NULL, the data
+ * memory is cleared.
+ *
+ * Note that you must align your @data memory to 8 bytes. Trailing padding (in
+ * case @len is not 8byte aligned) is cleared by this call.
+ *
+ * Returns: Pointer to the following item.
+ */
+struct kdbus_item *kdbus_item_set(struct kdbus_item *item, u64 type,
+				  const void *data, size_t len)
+{
+	item->type = type;
+	item->size = KDBUS_ITEM_HEADER_SIZE + len;
+
+	if (data) {
+		memcpy(item->data, data, len);
+		memset(item->data + len, 0, KDBUS_ALIGN8(len) - len);
+	} else {
+		memset(item->data, 0, KDBUS_ALIGN8(len));
+	}
+
+	return KDBUS_ITEM_NEXT(item);
+}
diff --git a/ipc/kdbus/item.h b/ipc/kdbus/item.h
new file mode 100644
index 000000000000..6c4f26ba226b
--- /dev/null
+++ b/ipc/kdbus/item.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
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
+#define KDBUS_ITEM_NEXT(_i) (typeof(_i))(((u8 *)_i) + KDBUS_ALIGN8((_i)->size))
+#define KDBUS_ITEMS_SIZE(_h, _is) ((_h)->size - offsetof(typeof(*_h), _is))
+#define KDBUS_ITEM_HEADER_SIZE offsetof(struct kdbus_item, data)
+#define KDBUS_ITEM_SIZE(_s) KDBUS_ALIGN8(KDBUS_ITEM_HEADER_SIZE + (_s))
+#define KDBUS_ITEM_PAYLOAD_SIZE(_i) ((_i)->size - KDBUS_ITEM_HEADER_SIZE)
+
+#define KDBUS_ITEMS_FOREACH(_i, _is, _s)				\
+	for (_i = _is;							\
+	     ((u8 *)(_i) < (u8 *)(_is) + (_s)) &&			\
+	       ((u8 *)(_i) >= (u8 *)(_is));				\
+	     _i = KDBUS_ITEM_NEXT(_i))
+
+/**
+ * struct kdbus_item_header - Describes the fix part of an item
+ * @size:	The total size of the item
+ * @type:	The item type, one of KDBUS_ITEM_*
+ */
+struct kdbus_item_header {
+	u64 size;
+	u64 type;
+};
+
+int kdbus_item_validate_name(const struct kdbus_item *item);
+int kdbus_items_validate(const struct kdbus_item *items, size_t items_size);
+struct kdbus_item *kdbus_items_get(const struct kdbus_item *items,
+				   size_t items_size,
+				   unsigned int item_type);
+const char *kdbus_items_get_str(const struct kdbus_item *items,
+				size_t items_size,
+				unsigned int item_type);
+struct kdbus_item *kdbus_item_set(struct kdbus_item *item, u64 type,
+				  const void *data, size_t len);
+
+#endif
diff --git a/ipc/kdbus/message.c b/ipc/kdbus/message.c
new file mode 100644
index 000000000000..3ec2afc8ff5c
--- /dev/null
+++ b/ipc/kdbus/message.c
@@ -0,0 +1,598 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
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
+static struct kdbus_msg_resources *kdbus_msg_resources_new(void)
+{
+	struct kdbus_msg_resources *r;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&r->kref);
+
+	return r;
+}
+
+static void __kdbus_msg_resources_free(struct kref *kref)
+{
+	struct kdbus_msg_resources *r =
+		container_of(kref, struct kdbus_msg_resources, kref);
+	size_t i;
+
+	for (i = 0; i < r->data_count; ++i) {
+		switch (r->data[i].type) {
+		case KDBUS_MSG_DATA_VEC:
+			/* nothing to do */
+			break;
+		case KDBUS_MSG_DATA_MEMFD:
+			if (r->data[i].memfd.file)
+				fput(r->data[i].memfd.file);
+			break;
+		}
+	}
+
+	kfree(r->data);
+
+	kdbus_fput_files(r->fds, r->fds_count);
+	kfree(r->fds);
+
+	kfree(r->dst_name);
+	kfree(r);
+}
+
+/**
+ * kdbus_msg_resources_ref() - Acquire reference to msg resources
+ * @r:		resources to acquire ref to
+ *
+ * Return: The acquired resource
+ */
+struct kdbus_msg_resources *
+kdbus_msg_resources_ref(struct kdbus_msg_resources *r)
+{
+	if (r)
+		kref_get(&r->kref);
+	return r;
+}
+
+/**
+ * kdbus_msg_resources_unref() - Drop reference to msg resources
+ * @r:		resources to drop reference of
+ *
+ * Return: NULL
+ */
+struct kdbus_msg_resources *
+kdbus_msg_resources_unref(struct kdbus_msg_resources *r)
+{
+	if (r)
+		kref_put(&r->kref, __kdbus_msg_resources_free);
+	return NULL;
+}
+
+/**
+ * kdbus_kmsg_free() - free allocated message
+ * @kmsg:		Message
+ */
+void kdbus_kmsg_free(struct kdbus_kmsg *kmsg)
+{
+	kdbus_msg_resources_unref(kmsg->res);
+	kdbus_meta_conn_unref(kmsg->conn_meta);
+	kdbus_meta_proc_unref(kmsg->proc_meta);
+	kfree(kmsg->iov);
+	kfree(kmsg);
+}
+
+/**
+ * kdbus_kmsg_new() - allocate message
+ * @extra_size:		Additional size to reserve for data
+ *
+ * Return: new kdbus_kmsg on success, ERR_PTR on failure.
+ */
+struct kdbus_kmsg *kdbus_kmsg_new(size_t extra_size)
+{
+	struct kdbus_kmsg *m;
+	size_t size;
+	int ret;
+
+	size = sizeof(struct kdbus_kmsg) + KDBUS_ITEM_SIZE(extra_size);
+	m = kzalloc(size, GFP_KERNEL);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+
+	m->msg.size = size - KDBUS_KMSG_HEADER_SIZE;
+	m->msg.items[0].size = KDBUS_ITEM_SIZE(extra_size);
+
+	m->proc_meta = kdbus_meta_proc_new();
+	if (IS_ERR(m->proc_meta)) {
+		ret = PTR_ERR(m->proc_meta);
+		goto exit;
+	}
+
+	m->conn_meta = kdbus_meta_conn_new();
+	if (IS_ERR(m->conn_meta)) {
+		ret = PTR_ERR(m->conn_meta);
+		goto exit;
+	}
+
+	return m;
+
+exit:
+	kdbus_kmsg_free(m);
+	return ERR_PTR(ret);
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
+static const char * const zeros = "\0\0\0\0\0\0\0";
+
+/*
+ * kdbus_msg_scan_items() - validate incoming data and prepare parsing
+ * @kmsg:		Message
+ * @bus:		Bus the message is sent over
+ *
+ * Return: 0 on success, negative errno on failure.
+ *
+ * Files references in MEMFD or FDS items are pinned.
+ *
+ * On errors, the caller should drop any taken reference with
+ * kdbus_kmsg_free()
+ */
+static int kdbus_msg_scan_items(struct kdbus_kmsg *kmsg,
+				struct kdbus_bus *bus)
+{
+	struct kdbus_msg_resources *res = kmsg->res;
+	const struct kdbus_msg *msg = &kmsg->msg;
+	const struct kdbus_item *item;
+	size_t n, n_vecs, n_memfds;
+	bool has_bloom = false;
+	bool has_name = false;
+	bool has_fds = false;
+	bool is_broadcast;
+	bool is_signal;
+	u64 vec_size;
+
+	is_broadcast = (msg->dst_id == KDBUS_DST_ID_BROADCAST);
+	is_signal = !!(msg->flags & KDBUS_MSG_SIGNAL);
+
+	/* count data payloads */
+	n_vecs = 0;
+	n_memfds = 0;
+	KDBUS_ITEMS_FOREACH(item, msg->items, KDBUS_ITEMS_SIZE(msg, items)) {
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_VEC:
+			++n_vecs;
+			break;
+		case KDBUS_ITEM_PAYLOAD_MEMFD:
+			++n_memfds;
+			if (item->memfd.size % 8)
+				++n_vecs;
+			break;
+		default:
+			break;
+		}
+	}
+
+	n = n_vecs + n_memfds;
+	if (n > 0) {
+		res->data = kcalloc(n, sizeof(*res->data), GFP_KERNEL);
+		if (!res->data)
+			return -ENOMEM;
+	}
+
+	if (n_vecs > 0) {
+		kmsg->iov = kcalloc(n_vecs, sizeof(*kmsg->iov), GFP_KERNEL);
+		if (!kmsg->iov)
+			return -ENOMEM;
+	}
+
+	/* import data payloads */
+	n = 0;
+	vec_size = 0;
+	KDBUS_ITEMS_FOREACH(item, msg->items, KDBUS_ITEMS_SIZE(msg, items)) {
+		size_t payload_size = KDBUS_ITEM_PAYLOAD_SIZE(item);
+		struct iovec *iov = kmsg->iov + kmsg->iov_count;
+
+		if (++n > KDBUS_MSG_MAX_ITEMS)
+			return -E2BIG;
+
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_VEC: {
+			struct kdbus_msg_data *d = res->data + res->data_count;
+			void __force __user *ptr = KDBUS_PTR(item->vec.address);
+			size_t size = item->vec.size;
+
+			if (vec_size + size < vec_size)
+				return -EMSGSIZE;
+			if (vec_size + size > KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE)
+				return -EMSGSIZE;
+
+			d->type = KDBUS_MSG_DATA_VEC;
+			d->size = size;
+
+			if (ptr) {
+				d->vec.off = kmsg->pool_size;
+				iov->iov_base = ptr;
+				iov->iov_len = size;
+			} else {
+				d->vec.off = ~0ULL;
+				iov->iov_base = (char __user *)zeros;
+				iov->iov_len = size % 8;
+			}
+
+			if (kmsg->pool_size + iov->iov_len < kmsg->pool_size)
+				return -EMSGSIZE;
+
+			kmsg->pool_size += iov->iov_len;
+			++kmsg->iov_count;
+			++res->vec_count;
+			++res->data_count;
+			vec_size += size;
+
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			struct kdbus_msg_data *d = res->data + res->data_count;
+			u64 start = item->memfd.start;
+			u64 size = item->memfd.size;
+			size_t pad = size % 8;
+			int seals, mask;
+			struct file *f;
+
+			if (kmsg->pool_size + size % 8 < kmsg->pool_size)
+				return -EMSGSIZE;
+			if (start + size < start)
+				return -EMSGSIZE;
+
+			if (item->memfd.fd < 0)
+				return -EBADF;
+
+			f = fget(item->memfd.fd);
+			if (!f)
+				return -EBADF;
+
+			if (pad) {
+				iov->iov_base = (char __user *)zeros;
+				iov->iov_len = pad;
+
+				kmsg->pool_size += pad;
+				++kmsg->iov_count;
+			}
+
+			++res->data_count;
+			++res->memfd_count;
+
+			d->type = KDBUS_MSG_DATA_MEMFD;
+			d->size = size;
+			d->memfd.start = start;
+			d->memfd.file = f;
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
+			mask = F_SEAL_SHRINK | F_SEAL_GROW |
+				F_SEAL_WRITE | F_SEAL_SEAL;
+			if ((seals & mask) != mask)
+				return -ETXTBSY;
+
+			if (start + size > (u64)i_size_read(file_inode(f)))
+				return -EBADF;
+
+			break;
+		}
+
+		case KDBUS_ITEM_FDS: {
+			unsigned int i;
+			unsigned int fds_count = payload_size / sizeof(int);
+
+			/* do not allow multiple fd arrays */
+			if (has_fds)
+				return -EEXIST;
+			has_fds = true;
+
+			/* Do not allow to broadcast file descriptors */
+			if (is_broadcast)
+				return -ENOTUNIQ;
+
+			if (fds_count > KDBUS_MSG_MAX_FDS)
+				return -EMFILE;
+
+			res->fds = kcalloc(fds_count, sizeof(struct file *),
+					   GFP_KERNEL);
+			if (!res->fds)
+				return -ENOMEM;
+
+			for (i = 0; i < fds_count; i++) {
+				int fd = item->fds[i];
+				int ret;
+
+				/*
+				 * Verify the fd and increment the usage count.
+				 * Use fget_raw() to allow passing O_PATH fds.
+				 */
+				if (fd < 0)
+					return -EBADF;
+
+				res->fds[i] = fget_raw(fd);
+				if (!res->fds[i])
+					return -EBADF;
+
+				res->fds_count++;
+
+				ret = kdbus_handle_check_file(res->fds[i]);
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
+			if (bloom_size != bus->bloom.size)
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
+			res->dst_name = kstrdup(item->str, GFP_KERNEL);
+			if (!res->dst_name)
+				return -ENOMEM;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+	}
+
+	/* name is needed if no ID is given */
+	if (msg->dst_id == KDBUS_DST_ID_NAME && !has_name)
+		return -EDESTADDRREQ;
+
+	if (is_broadcast) {
+		/* Broadcasts can't take names */
+		if (has_name)
+			return -EBADMSG;
+
+		/* All broadcasts have to be signals */
+		if (!is_signal)
+			return -EBADMSG;
+
+		/* Timeouts are not allowed for broadcasts */
+		if (msg->timeout_ns > 0)
+			return -ENOTUNIQ;
+	}
+
+	/*
+	 * Signal messages require a bloom filter, and bloom filters are
+	 * only valid with signals.
+	 */
+	if (is_signal ^ has_bloom)
+		return -EBADMSG;
+
+	return 0;
+}
+
+/**
+ * kdbus_kmsg_new_from_cmd() - create kernel message from send payload
+ * @conn:		Connection
+ * @buf:		The user-buffer location of @cmd
+ * @cmd_send:		Payload of KDBUS_CMD_SEND
+ *
+ * Return: a new kdbus_kmsg on success, ERR_PTR on failure.
+ */
+struct kdbus_kmsg *kdbus_kmsg_new_from_cmd(struct kdbus_conn *conn,
+					   void __user *buf,
+					   struct kdbus_cmd_send *cmd_send)
+{
+	struct kdbus_kmsg *m;
+	u64 size;
+	int ret;
+
+	ret = kdbus_copy_from_user(&size, KDBUS_PTR(cmd_send->msg_address),
+				   sizeof(size));
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (size < sizeof(struct kdbus_msg) || size > KDBUS_MSG_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	m = kmalloc(size + KDBUS_KMSG_HEADER_SIZE, GFP_KERNEL);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+
+	memset(m, 0, KDBUS_KMSG_HEADER_SIZE);
+
+	m->proc_meta = kdbus_meta_proc_new();
+	if (IS_ERR(m->proc_meta)) {
+		ret = PTR_ERR(m->proc_meta);
+		m->proc_meta = NULL;
+		goto exit_free;
+	}
+
+	m->conn_meta = kdbus_meta_conn_new();
+	if (IS_ERR(m->conn_meta)) {
+		ret = PTR_ERR(m->conn_meta);
+		m->conn_meta = NULL;
+		goto exit_free;
+	}
+
+	if (copy_from_user(&m->msg, KDBUS_PTR(cmd_send->msg_address), size)) {
+		ret = -EFAULT;
+		goto exit_free;
+	}
+
+	if (m->msg.size != size) {
+		ret = -EINVAL;
+		goto exit_free;
+	}
+
+	ret = kdbus_check_and_write_flags(m->msg.flags, buf,
+					  offsetof(struct kdbus_cmd_send,
+						   kernel_msg_flags),
+					  KDBUS_MSG_EXPECT_REPLY	|
+					  KDBUS_MSG_NO_AUTO_START	|
+					  KDBUS_MSG_SIGNAL);
+	if (ret < 0)
+		goto exit_free;
+
+	ret = kdbus_items_validate(m->msg.items,
+				   KDBUS_ITEMS_SIZE(&m->msg, items));
+	if (ret < 0)
+		goto exit_free;
+
+	m->res = kdbus_msg_resources_new();
+	if (IS_ERR(m->res)) {
+		ret = PTR_ERR(m->res);
+		m->res = NULL;
+		goto exit_free;
+	}
+
+	/* do not accept kernel-generated messages */
+	if (m->msg.payload_type == KDBUS_PAYLOAD_KERNEL) {
+		ret = -EINVAL;
+		goto exit_free;
+	}
+
+	if (m->msg.flags & KDBUS_MSG_EXPECT_REPLY) {
+		/* requests for replies need timeout and cookie */
+		if (m->msg.timeout_ns == 0 || m->msg.cookie == 0) {
+			ret = -EINVAL;
+			goto exit_free;
+		}
+
+		/* replies may not be expected for broadcasts */
+		if (m->msg.dst_id == KDBUS_DST_ID_BROADCAST) {
+			ret = -ENOTUNIQ;
+			goto exit_free;
+		}
+
+		/* replies may not be expected for signals */
+		if (m->msg.flags & KDBUS_MSG_SIGNAL) {
+			ret = -EINVAL;
+			goto exit_free;
+		}
+	} else {
+		/*
+		 * KDBUS_SEND_SYNC_REPLY is only valid together with
+		 * KDBUS_MSG_EXPECT_REPLY
+		 */
+		if (cmd_send->flags & KDBUS_SEND_SYNC_REPLY) {
+			ret = -EINVAL;
+			goto exit_free;
+		}
+	}
+
+	ret = kdbus_msg_scan_items(m, conn->ep->bus);
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
diff --git a/ipc/kdbus/message.h b/ipc/kdbus/message.h
new file mode 100644
index 000000000000..28f1893b002a
--- /dev/null
+++ b/ipc/kdbus/message.h
@@ -0,0 +1,133 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+ * enum kdbus_msg_data_type - Type of kdbus_msg_data payloads
+ * @KDBUS_MSG_DATA_VEC:		Data vector provided by user-space
+ * @KDBUS_MSG_DATA_MEMFD:	Memfd payload
+ */
+enum kdbus_msg_data_type {
+	KDBUS_MSG_DATA_VEC,
+	KDBUS_MSG_DATA_MEMFD,
+};
+
+/**
+ * struct kdbus_msg_data - Data payload as stored by messages
+ * @type:	Type of payload (KDBUS_MSG_DATA_*)
+ * @size:	Size of the described payload
+ * @off:	The offset, relative to the vec slice
+ * @start:	Offset inside the memfd
+ * @file:	Backing file referenced by the memfd
+ */
+struct kdbus_msg_data {
+	unsigned int type;
+	u64 size;
+
+	union {
+		struct {
+			u64 off;
+		} vec;
+		struct {
+			u64 start;
+			struct file *file;
+		} memfd;
+	};
+};
+
+/**
+ * struct kdbus_kmsg_resources - resources of a message
+ * @kref:		Reference counter
+ * @dst_name:		Short-cut to msg for faster lookup
+ * @fds:		Array of file descriptors to pass
+ * @fds_count:		Number of file descriptors to pass
+ * @data:		Array of data payloads
+ * @vec_count:		Number of VEC entries
+ * @memfd_count:	Number of MEMFD entries in @data
+ * @data_count:		Sum of @vec_count + @memfd_count
+ */
+struct kdbus_msg_resources {
+	struct kref kref;
+	const char *dst_name;
+
+	struct file **fds;
+	unsigned int fds_count;
+
+	struct kdbus_msg_data *data;
+	size_t vec_count;
+	size_t memfd_count;
+	size_t data_count;
+};
+
+struct kdbus_msg_resources *
+kdbus_msg_resources_ref(struct kdbus_msg_resources *r);
+struct kdbus_msg_resources *
+kdbus_msg_resources_unref(struct kdbus_msg_resources *r);
+
+/**
+ * struct kdbus_kmsg - internal message handling data
+ * @seq:		Domain-global message sequence number
+ * @notify_type:	Short-cut for faster lookup
+ * @notify_old_id:	Short-cut for faster lookup
+ * @notify_new_id:	Short-cut for faster lookup
+ * @notify_name:	Short-cut for faster lookup
+ * @dst_name_id:	Short-cut to msg for faster lookup
+ * @bloom_filter:	Bloom filter to match message properties
+ * @bloom_generation:	Generation of bloom element set
+ * @notify_entry:	List of kernel-generated notifications
+ * @iov:		Array of iovec, describing the payload to copy
+ * @iov_count:		Number of array members in @iov
+ * @pool_size:		Overall size of inlined data referenced by @iov
+ * @proc_meta:		Appended SCM-like metadata of the sending process
+ * @conn_meta:		Appended SCM-like metadata of the sending connection
+ * @res:		Message resources
+ * @msg:		Message from or to userspace
+ */
+struct kdbus_kmsg {
+	u64 seq;
+	u64 notify_type;
+	u64 notify_old_id;
+	u64 notify_new_id;
+	const char *notify_name;
+
+	u64 dst_name_id;
+	const struct kdbus_bloom_filter *bloom_filter;
+	u64 bloom_generation;
+	struct list_head notify_entry;
+
+	struct iovec *iov;
+	size_t iov_count;
+	u64 pool_size;
+
+	struct kdbus_meta_proc *proc_meta;
+	struct kdbus_meta_conn *conn_meta;
+	struct kdbus_msg_resources *res;
+
+	/* variable size, must be the last member */
+	struct kdbus_msg msg;
+};
+
+struct kdbus_conn;
+
+struct kdbus_kmsg *kdbus_kmsg_new(size_t extra_size);
+struct kdbus_kmsg *kdbus_kmsg_new_from_cmd(struct kdbus_conn *conn,
+					   void __user *buf,
+					   struct kdbus_cmd_send *cmd_send);
+void kdbus_kmsg_free(struct kdbus_kmsg *kmsg);
+
+#endif
diff --git a/ipc/kdbus/queue.c b/ipc/kdbus/queue.c
new file mode 100644
index 000000000000..53ab51a0f791
--- /dev/null
+++ b/ipc/kdbus/queue.c
@@ -0,0 +1,505 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
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
+#include <linux/uio.h>
+
+#include "util.h"
+#include "domain.h"
+#include "connection.h"
+#include "item.h"
+#include "message.h"
+#include "metadata.h"
+#include "queue.h"
+#include "reply.h"
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
+		if (likely(entry->msg.priority == e->msg.priority)) {
+			list_add_tail(&entry->prio_entry, &e->prio_entry);
+			goto prio_done;
+		}
+
+		if (entry->msg.priority < e->msg.priority) {
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
+		if (e->msg.priority > priority)
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
+ * @pool:	The pool to allocate the slice in
+ * @kmsg:	The kmsg object the queue entry should track
+ *
+ * Allocates a queue entry based on a given kmsg and allocate space for
+ * the message payload and the requested metadata in the connection's pool.
+ * The entry is not actually added to the queue's lists at this point.
+ *
+ * Return: the allocated entry on success, or an ERR_PTR on failures.
+ */
+struct kdbus_queue_entry *kdbus_queue_entry_alloc(struct kdbus_pool *pool,
+						  const struct kdbus_kmsg *kmsg)
+{
+	struct kdbus_msg_resources *res = kmsg->res;
+	const struct kdbus_msg *msg = &kmsg->msg;
+	struct kdbus_queue_entry *entry;
+	int ret = 0;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&entry->entry);
+	entry->msg_res = kdbus_msg_resources_ref(res);
+	entry->proc_meta = kdbus_meta_proc_ref(kmsg->proc_meta);
+	entry->conn_meta = kdbus_meta_conn_ref(kmsg->conn_meta);
+	memcpy(&entry->msg, msg, sizeof(*msg));
+
+	if (kmsg->iov_count) {
+		size_t pool_avail = kdbus_pool_remain(pool);
+
+		/* do not give out more than half of the remaining space */
+		if (kmsg->pool_size < pool_avail &&
+		    kmsg->pool_size > pool_avail / 2) {
+			ret = -EXFULL;
+			goto exit_free_entry;
+		}
+
+		/* allocate the needed space in the pool of the receiver */
+		entry->slice_vecs = kdbus_pool_slice_alloc(pool,
+							   kmsg->pool_size,
+							   NULL, kmsg->iov,
+							   kmsg->iov_count);
+		if (IS_ERR(entry->slice_vecs)) {
+			ret = PTR_ERR(entry->slice_vecs);
+			entry->slice_vecs = NULL;
+			goto exit_free_entry;
+		}
+	}
+
+	if (msg->src_id == KDBUS_SRC_ID_KERNEL) {
+		size_t extra_size = msg->size - sizeof(*msg);
+
+		entry->msg_extra = kmemdup((u8 *)msg + sizeof(*msg),
+					   extra_size, GFP_KERNEL);
+		if (!entry->msg_extra) {
+			ret = -ENOMEM;
+			goto exit_free_slice;
+		}
+
+		entry->msg_extra_size = extra_size;
+	}
+
+	return entry;
+
+exit_free_slice:
+	kdbus_pool_slice_release(entry->slice_vecs);
+exit_free_entry:
+	kdbus_queue_entry_free(entry);
+	return ERR_PTR(ret);
+}
+
+static struct kdbus_item *
+kdbus_msg_make_items(const struct kdbus_msg_resources *res, off_t payload_off,
+		     bool install_fds, u64 *return_flags, size_t *out_size)
+{
+	struct kdbus_item *items, *item;
+	bool incomplete_fds = false;
+	size_t i, size = 0;
+
+	/* sum up how much space we need for the 'control' part */
+	size += res->vec_count * KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size += res->memfd_count * KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+
+	if (res->fds_count)
+		size += KDBUS_ITEM_SIZE(sizeof(int) * res->fds_count);
+
+	if (res->dst_name)
+		size += KDBUS_ITEM_SIZE(strlen(res->dst_name) + 1);
+
+	items = kzalloc(size, GFP_KERNEL);
+	if (!items)
+		return ERR_PTR(-ENOMEM);
+
+	item = items;
+
+	if (res->dst_name) {
+		kdbus_item_set(item, KDBUS_ITEM_DST_NAME,
+			       res->dst_name, strlen(res->dst_name) + 1);
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
+	for (i = 0; i < res->data_count; ++i) {
+		struct kdbus_msg_data *d = res->data + i;
+		struct kdbus_memfd m = {};
+		struct kdbus_vec v = {};
+
+		switch (d->type) {
+		case KDBUS_MSG_DATA_VEC:
+			v.size = d->size;
+			v.offset = d->vec.off;
+			if (v.offset != ~0ULL)
+				v.offset += payload_off;
+
+			kdbus_item_set(item, KDBUS_ITEM_PAYLOAD_OFF,
+				       &v, sizeof(v));
+			item = KDBUS_ITEM_NEXT(item);
+			break;
+
+		case KDBUS_MSG_DATA_MEMFD:
+			m.start = d->memfd.start;
+			m.size = d->size;
+			m.fd = -1;
+			if (install_fds) {
+				m.fd = get_unused_fd_flags(O_CLOEXEC);
+				if (m.fd >= 0)
+					fd_install(m.fd,
+						   get_file(d->memfd.file));
+				else
+					incomplete_fds = true;
+			}
+
+			kdbus_item_set(item, KDBUS_ITEM_PAYLOAD_MEMFD,
+				       &m, sizeof(m));
+			item = KDBUS_ITEM_NEXT(item);
+			break;
+		}
+	}
+
+	if (res->fds_count) {
+		kdbus_item_set(item, KDBUS_ITEM_FDS,
+			       NULL, sizeof(int) * res->fds_count);
+		for (i = 0; i < res->fds_count; i++) {
+			if (install_fds) {
+				item->fds[i] = get_unused_fd_flags(O_CLOEXEC);
+				if (item->fds[i] >= 0)
+					fd_install(item->fds[i],
+						   get_file(res->fds[i]));
+				else
+					incomplete_fds = true;
+			} else {
+				item->fds[i] = -1;
+			}
+		}
+
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
+	/* Make sure the sizes actually match */
+	BUG_ON((u8 *)item != (u8 *)items + size);
+
+	if (incomplete_fds)
+		*return_flags |= KDBUS_RECV_RETURN_INCOMPLETE_FDS;
+
+	*out_size = size;
+	return items;
+}
+
+/**
+ * kdbus_queue_entry_install() - install message components into the
+ *				 receiver's process
+ * @entry:		The queue entry to install
+ * @conn_dst:		The receiver connection
+ * @return_flags:	Pointer to store the return flags for userspace
+ * @install_fds:	Whether or not to install associated file descriptors
+ *
+ * This function will create a slice to transport the message header, the
+ * metadata items and other items for information stored in @entry, and
+ * store it as entry->slice.
+ *
+ * If @install_fds is %true, file descriptors will as well be installed.
+ * This function must always be called from the task context of the receiver.
+ *
+ * Return: 0 on success.
+ */
+int kdbus_queue_entry_install(struct kdbus_queue_entry *entry,
+			      struct kdbus_conn *conn_dst,
+			      u64 *return_flags, bool install_fds)
+{
+	size_t meta_size = 0, payload_items_size = 0;
+	struct kdbus_item *payload_items = NULL;
+	struct kdbus_item *meta_items = NULL;
+	off_t payload_off = 0;
+	struct kvec kvec[4];
+	size_t kvec_count = 0;
+	int ret = 0;
+
+	if (entry->proc_meta || entry->conn_meta) {
+		u64 attach_flags = atomic64_read(&conn_dst->attach_flags_recv);
+
+		meta_items = kdbus_meta_export(entry->proc_meta,
+					       entry->conn_meta,
+					       attach_flags,
+					       &meta_size);
+		if (IS_ERR(meta_items)) {
+			ret = PTR_ERR(meta_items);
+			meta_items = NULL;
+			goto exit_free;
+		}
+	}
+
+	/*
+	 * The offsets stored in the slice are relative to the the start
+	 * of the payload slice. When exporting them, they need to become
+	 * relative to the pool, so get the payload slice's offset first.
+	 */
+	if (entry->slice_vecs)
+		payload_off = kdbus_pool_slice_offset(entry->slice_vecs);
+
+	if (entry->msg_res) {
+		payload_items = kdbus_msg_make_items(entry->msg_res,
+						     payload_off,
+						     install_fds, return_flags,
+						     &payload_items_size);
+		if (IS_ERR(payload_items)) {
+			ret = PTR_ERR(payload_items);
+			payload_items = NULL;
+			goto exit_free;
+		}
+	}
+
+	entry->msg.size = 0;
+
+	kdbus_kvec_set(&kvec[kvec_count++], &entry->msg, sizeof(entry->msg),
+		       &entry->msg.size);
+
+	if (entry->msg_extra_size)
+		kdbus_kvec_set(&kvec[kvec_count++], entry->msg_extra,
+			       entry->msg_extra_size, &entry->msg.size);
+
+	if (payload_items_size)
+		kdbus_kvec_set(&kvec[kvec_count++], payload_items,
+			       payload_items_size, &entry->msg.size);
+
+	if (meta_size)
+		kdbus_kvec_set(&kvec[kvec_count++], meta_items, meta_size,
+			       &entry->msg.size);
+
+	entry->slice = kdbus_pool_slice_alloc(conn_dst->pool, entry->msg.size,
+					      kvec, NULL, kvec_count);
+	if (IS_ERR(entry->slice)) {
+		ret = PTR_ERR(entry->slice);
+		entry->slice = NULL;
+		goto exit_free;
+	}
+
+	kdbus_pool_slice_set_child(entry->slice, entry->slice_vecs);
+
+exit_free:
+	kfree(payload_items);
+	kfree(meta_items);
+
+	return ret;
+}
+
+/**
+ * kdbus_queue_entry_move() - move an entry from one queue to another
+ * @conn_dst:	Connection holding the queue to copy to
+ * @entry:	The queue entry to move
+ *
+ * Return: 0 on success, nagative error otherwise
+ */
+int kdbus_queue_entry_move(struct kdbus_conn *conn_dst,
+			   struct kdbus_queue_entry *entry)
+{
+	int ret = 0;
+
+	if (entry->slice_vecs)
+		ret = kdbus_pool_slice_move(conn_dst->pool, &entry->slice_vecs);
+
+	if (ret < 0)
+		kdbus_queue_entry_free(entry);
+	else
+		kdbus_queue_entry_add(&conn_dst->queue, entry);
+
+	return ret;
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
+	kdbus_msg_resources_unref(entry->msg_res);
+	kdbus_meta_conn_unref(entry->conn_meta);
+	kdbus_meta_proc_unref(entry->proc_meta);
+	kdbus_reply_unref(entry->reply);
+	kfree(entry->msg_extra);
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
index 000000000000..8e9961fd3ecd
--- /dev/null
+++ b/ipc/kdbus/queue.h
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
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
+ * @msg:		Message header, either as received from userspace
+ *			process, or as crafted by the kernel as notification
+ * @msg_extra:		For notifications, contains more fixed parts of a
+ *			message, which will be copied to the final message
+ *			slice verbatim.
+ * @slice:		Slice in the receiver's pool for the message
+ * @slice_vecs:		Slice in the receiver's pool for message payload
+ * @memfds:		Arrays of offsets where to update the installed
+ *			fd number
+ * @dst_name:		Destination well-known-name
+ * @vecs:		Array of struct kdbus_queue_vecs
+ * @vec_count:		Number of elements in @vecs
+ * @memfds_fp:		Array memfd files queued up for this message
+ * @memfd_size:		Array of size_t values, describing the sizes of memfds
+ * @memfds_count:	Number of elements in @memfds_fp
+ * @fds_fp:		Array of passed files queued up for this message
+ * @fds_count:		Number of elements in @fds_fp
+ * @dst_name_id:	The sequence number of the name this message is
+ *			addressed to, 0 for messages sent to an ID
+ * @proc_meta:		Process metadata, captured at message arrival
+ * @conn_meta:		Connection metadata, captured at message arrival
+ * @reply:		The reply block if a reply to this message is expected.
+ * @user:		Index in per-user message counter, -1 for unused
+ */
+struct kdbus_queue_entry {
+	struct list_head entry;
+	struct rb_node prio_node;
+	struct list_head prio_entry;
+
+	struct kdbus_msg msg;
+
+	char *msg_extra;
+	size_t msg_extra_size;
+
+	struct kdbus_pool_slice *slice;
+	struct kdbus_pool_slice *slice_vecs;
+
+	u64 dst_name_id;
+
+	struct kdbus_msg_resources *msg_res;
+	struct kdbus_meta_proc *proc_meta;
+	struct kdbus_meta_conn *conn_meta;
+	struct kdbus_reply *reply;
+	struct kdbus_domain_user *user;
+};
+
+struct kdbus_kmsg;
+
+void kdbus_queue_init(struct kdbus_queue *queue);
+
+struct kdbus_queue_entry *
+kdbus_queue_entry_alloc(struct kdbus_pool *pool,
+			const struct kdbus_kmsg *kmsg);
+int kdbus_queue_entry_move(struct kdbus_conn *conn_dst,
+			   struct kdbus_queue_entry *entry);
+void kdbus_queue_entry_free(struct kdbus_queue_entry *entry);
+
+void kdbus_queue_entry_add(struct kdbus_queue *queue,
+			   struct kdbus_queue_entry *entry);
+void kdbus_queue_entry_remove(struct kdbus_conn *conn,
+			      struct kdbus_queue_entry *entry);
+struct kdbus_queue_entry *kdbus_queue_entry_peek(struct kdbus_queue *queue,
+						 s64 priority,
+						 bool use_priority);
+int kdbus_queue_entry_install(struct kdbus_queue_entry *entry,
+			      struct kdbus_conn *conn_dst,
+			      u64 *return_flags, bool install_fds);
+
+#endif /* __KDBUS_QUEUE_H */
diff --git a/ipc/kdbus/reply.c b/ipc/kdbus/reply.c
new file mode 100644
index 000000000000..9e3559d1ed4a
--- /dev/null
+++ b/ipc/kdbus/reply.c
@@ -0,0 +1,262 @@
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/uio.h>
+
+#include "bus.h"
+#include "connection.h"
+#include "endpoint.h"
+#include "message.h"
+#include "metadata.h"
+#include "domain.h"
+#include "item.h"
+#include "notify.h"
+#include "policy.h"
+#include "reply.h"
+#include "util.h"
+
+/**
+ * kdbus_reply_new() - Allocate and set up a new kdbus_reply object
+ * @reply_src:		The connection a reply is expected from
+ * @reply_dst:		The connection this reply object belongs to
+ * @msg:		Message associated with the reply
+ * @name_entry:		Name entry used to send the message
+ * @sync:		Whether or not to make this reply synchronous
+ *
+ * Allocate and fill a new kdbus_reply object.
+ *
+ * Return: New kdbus_conn object on success, ERR_PTR on error.
+ */
+struct kdbus_reply *kdbus_reply_new(struct kdbus_conn *reply_src,
+				    struct kdbus_conn *reply_dst,
+				    const struct kdbus_msg *msg,
+				    struct kdbus_name_entry *name_entry,
+				    bool sync)
+{
+	struct kdbus_reply *r;
+	int ret = 0;
+
+	if (atomic_inc_return(&reply_dst->request_count) >
+	    KDBUS_CONN_MAX_REQUESTS_PENDING) {
+		ret = -EMLINK;
+		goto exit_dec_request_count;
+	}
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r) {
+		ret = -ENOMEM;
+		goto exit_dec_request_count;
+	}
+
+	kref_init(&r->kref);
+	INIT_LIST_HEAD(&r->entry);
+	r->reply_src = kdbus_conn_ref(reply_src);
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
+exit_dec_request_count:
+	if (ret < 0) {
+		atomic_dec(&reply_dst->request_count);
+		return ERR_PTR(ret);
+	}
+
+	return r;
+}
+
+static void __kdbus_reply_free(struct kref *kref)
+{
+	struct kdbus_reply *reply =
+		container_of(kref, struct kdbus_reply, kref);
+
+	atomic_dec(&reply->reply_dst->request_count);
+	kdbus_conn_unref(reply->reply_src);
+	kdbus_conn_unref(reply->reply_dst);
+	kfree(reply);
+}
+
+/**
+ * kdbus_reply_ref() - Increase reference on kdbus_reply
+ * @r:		The reply, may be %NULL
+ *
+ * Return: The reply object with an extra reference
+ */
+struct kdbus_reply *kdbus_reply_ref(struct kdbus_reply *r)
+{
+	if (r)
+		kref_get(&r->kref);
+	return r;
+}
+
+/**
+ * kdbus_reply_unref() - Decrease reference on kdbus_reply
+ * @r:		The reply, may be %NULL
+ *
+ * Return: NULL
+ */
+struct kdbus_reply *kdbus_reply_unref(struct kdbus_reply *r)
+{
+	if (r)
+		kref_put(&r->kref, __kdbus_reply_free);
+	return NULL;
+}
+
+/**
+ * kdbus_reply_link() - Link reply object into target connection
+ * @r:		Reply to link
+ */
+void kdbus_reply_link(struct kdbus_reply *r)
+{
+	if (WARN_ON(!list_empty(&r->entry)))
+		return;
+
+	list_add(&r->entry, &r->reply_dst->reply_list);
+	kdbus_reply_ref(r);
+}
+
+/**
+ * kdbus_reply_unlink() - Unlink reply object from target connection
+ * @r:		Reply to unlink
+ */
+void kdbus_reply_unlink(struct kdbus_reply *r)
+{
+	if (!list_empty(&r->entry)) {
+		list_del_init(&r->entry);
+		kdbus_reply_unref(r);
+	}
+}
+
+/**
+ * kdbus_sync_reply_wakeup() - Wake a synchronously blocking reply
+ * @reply:	The reply object
+ * @err:	Error code to set on the remote side
+ *
+ * Remove the synchronous reply object from its connection reply_list, and
+ * wake up remote peer (method origin) with the appropriate synchronous reply
+ * code.
+ */
+void kdbus_sync_reply_wakeup(struct kdbus_reply *reply, int err)
+{
+	if (WARN_ON(!reply->sync))
+		return;
+
+	reply->waiting = false;
+	reply->err = err;
+	wake_up_interruptible(&reply->reply_dst->wait);
+}
+
+/**
+ * kdbus_reply_find() - Find the corresponding reply object
+ * @replying:	The replying connection
+ * @reply_dst:	The connection the reply will be sent to
+ *		(method origin)
+ * @cookie:	The cookie of the requesting message
+ *
+ * Lookup a reply object that should be sent as a reply by
+ * @replying to @reply_dst with the given cookie.
+ *
+ * For optimizations, callers should first check 'request_count' of
+ * @reply_dst to see if the connection has issued any requests
+ * that are waiting for replies, before calling this function.
+ *
+ * Callers must take the @reply_dst lock.
+ *
+ * Return: the corresponding reply object or NULL if not found
+ */
+struct kdbus_reply *kdbus_reply_find(struct kdbus_conn *replying,
+				     struct kdbus_conn *reply_dst,
+				     u64 cookie)
+{
+	struct kdbus_reply *r, *reply = NULL;
+
+	list_for_each_entry(r, &reply_dst->reply_list, entry) {
+		if (r->reply_src == replying &&
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
+ * kdbus_reply_list_scan_work() - Worker callback to scan the replies of a
+ *				  connection for exceeded timeouts
+ * @work:		Work struct of the connection to scan
+ *
+ * Walk the list of replies stored with a connection and look for entries
+ * that have exceeded their timeout. If such an entry is found, a timeout
+ * notification is sent to the waiting peer, and the reply is removed from
+ * the list.
+ *
+ * The work is rescheduled to the nearest timeout found during the list
+ * iteration.
+ */
+void kdbus_reply_list_scan_work(struct work_struct *work)
+{
+	struct kdbus_conn *conn =
+		container_of(work, struct kdbus_conn, work.work);
+	struct kdbus_reply *reply, *reply_tmp;
+	u64 deadline = ~0ULL;
+	struct timespec64 ts;
+	u64 now;
+
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
+		WARN_ON(reply->reply_dst != conn);
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
+			kdbus_notify_reply_timeout(conn->ep->bus, conn->id,
+						   reply->cookie);
+
+		kdbus_reply_unlink(reply);
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
diff --git a/ipc/kdbus/reply.h b/ipc/kdbus/reply.h
new file mode 100644
index 000000000000..7cecea210bf5
--- /dev/null
+++ b/ipc/kdbus/reply.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+ * Copyright (C) 2013-2014 Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013-2014 David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * Copyright (C) 2013-2014 Linux Foundation
+ * Copyright (C) 2014 Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __KDBUS_REPLY_H
+#define __KDBUS_REPLY_H
+
+/**
+ * struct kdbus_reply - an entry of kdbus_conn's list of replies
+ * @kref:		Ref-count of this object
+ * @entry:		The entry of the connection's reply_list
+ * @reply_src:		The connection the reply will be sent from
+ * @reply_dst:		The connection the reply will be sent to
+ * @queue_entry:	The queue entry item that is prepared by the replying
+ *			connection
+ * @deadline_ns:	The deadline of the reply, in nanoseconds
+ * @cookie:		The cookie of the requesting message
+ * @name_id:		ID of the well-known name the original msg was sent to
+ * @sync:		The reply block is waiting for synchronous I/O
+ * @waiting:		The condition to synchronously wait for
+ * @interrupted:	The sync reply was left in an interrupted state
+ * @err:		The error code for the synchronous reply
+ */
+struct kdbus_reply {
+	struct kref kref;
+	struct list_head entry;
+	struct kdbus_conn *reply_src;
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
+struct kdbus_reply *kdbus_reply_new(struct kdbus_conn *reply_src,
+				    struct kdbus_conn *reply_dst,
+				    const struct kdbus_msg *msg,
+				    struct kdbus_name_entry *name_entry,
+				    bool sync);
+
+struct kdbus_reply *kdbus_reply_ref(struct kdbus_reply *r);
+struct kdbus_reply *kdbus_reply_unref(struct kdbus_reply *r);
+
+void kdbus_reply_link(struct kdbus_reply *r);
+void kdbus_reply_unlink(struct kdbus_reply *r);
+
+struct kdbus_reply *kdbus_reply_find(struct kdbus_conn *replying,
+				     struct kdbus_conn *reply_dst,
+				     u64 cookie);
+
+void kdbus_sync_reply_wakeup(struct kdbus_reply *reply, int err);
+void kdbus_reply_list_scan_work(struct work_struct *work);
+
+#endif /* __KDBUS_REPLY_H */
diff --git a/ipc/kdbus/util.h b/ipc/kdbus/util.h
index 33d31f6274e0..241bbcc1c19f 100644
--- a/ipc/kdbus/util.h
+++ b/ipc/kdbus/util.h
@@ -19,7 +19,7 @@
 #include <linux/ioctl.h>
 #include <linux/uidgid.h>
 
-#include "kdbus.h"
+#include <uapi/linux/kdbus.h>
 
 /* all exported addresses are 64 bit */
 #define KDBUS_PTR(addr) ((void __user *)(uintptr_t)(addr))
-- 
2.2.1
