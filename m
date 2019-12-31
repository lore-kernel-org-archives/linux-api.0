From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V8 14/16] audit: check contid depth and add limit config param
Date: Tue, 31 Dec 2019 14:48:27 -0500
Message-ID: <28cf3e16f8440bcb852767d3ae13e1a56c19569c.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Clamp the depth of audit container identifier nesting to limit the
netlink and disk bandwidth used and to prevent losing information from
record text size overflow in the contid field.

Add a configuration parameter AUDIT_STATUS_CONTID_DEPTH_LIMIT (0x80) to
set the audit container identifier depth limit.  This can be used to
prevent overflow of the contid field in CONTAINER_OP and CONTAINER_ID
messages, losing information, and to limit bandwidth used by these
messages.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |  2 ++
 kernel/audit.c             | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/audit.h             |  2 ++
 3 files changed, 50 insertions(+)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index ea6638bb914b..dcb076b0d2e1 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -343,6 +343,7 @@ enum {
 #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
 #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
 #define AUDIT_STATUS_LOST		0x0040
+#define AUDIT_STATUS_CONTID_DEPTH_LIMIT	0x0080
 
 #define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
 #define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
@@ -471,6 +472,7 @@ struct audit_status {
 		__u32	feature_bitmap;	/* bitmap of kernel audit features */
 	};
 	__u32		backlog_wait_time;/* message queue wait timeout */
+	__u32		contid_depth_limit;/* container depth limit */
 };
 
 struct audit_features {
diff --git a/kernel/audit.c b/kernel/audit.c
index 68be59d1a89b..e5e39aedaf86 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -157,6 +157,7 @@ struct auditd_connection {
  * of container objects to tasks and refcount changes.  There should be
  * no need for interaction with tasklist_lock */
 static DEFINE_SPINLOCK(audit_contobj_list_lock);
+static u32 audit_contid_depth_limit = AUDIT_CONTID_DEPTH_LIMIT;
 
 static struct kmem_cache *audit_buffer_cache;
 
@@ -678,6 +679,20 @@ static int audit_set_backlog_wait_time(u32 timeout)
 				      &audit_backlog_wait_time, timeout);
 }
 
+static int audit_set_contid_depth_limit(u32 limit)
+{
+	int rc = 0;
+
+	if (limit > 20 * AUDIT_CONTID_DEPTH_LIMIT) {
+		rc = -ENOSPC;
+		audit_log_config_change("audit_contid_depth_limit",
+					limit, audit_contid_depth_limit, 0);
+		return rc;
+	}
+	return audit_do_config_change("audit_contid_depth_limit",
+				      &audit_contid_depth_limit, limit);
+}
+
 static int audit_set_enabled(u32 state)
 {
 	int rc;
@@ -1439,6 +1454,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.backlog		= skb_queue_len(&audit_queue);
 		s.feature_bitmap	= AUDIT_FEATURE_BITMAP_ALL;
 		s.backlog_wait_time	= audit_backlog_wait_time;
+		s.contid_depth_limit	= audit_contid_depth_limit;
 		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
@@ -1542,6 +1558,13 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			audit_log_config_change("lost", 0, lost, 1);
 			return lost;
 		}
+		if (s.mask & AUDIT_STATUS_CONTID_DEPTH_LIMIT) {
+			if (sizeof(s) > (size_t)nlh->nlmsg_len)
+				return -EINVAL;
+			err = audit_set_contid_depth_limit(s.contid_depth_limit);
+			if (err < 0)
+				return err;
+		}
 		break;
 	}
 	case AUDIT_GET_FEATURE:
@@ -2608,6 +2631,22 @@ int audit_signal_info(int sig, struct task_struct *t)
 	return audit_signal_info_syscall(t);
 }
 
+static int audit_contid_depth(struct audit_contobj *cont)
+{
+	struct audit_contobj *parent;
+	int depth = 1;
+
+	if (!cont)
+		return 0;
+
+	parent = cont->parent;
+	while (parent) {
+		depth++;
+		parent = parent->parent;
+	}
+	return depth;
+}
+
 static bool audit_contid_isowner(struct task_struct *tsk)
 {
 	if (tsk->audit && tsk->audit->cont)
@@ -2701,6 +2740,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				}
 				break;
 			}
+		/* Clamp max container id depth */
+		if (audit_contid_depth_limit != 0 &&
+		    audit_contid_depth(_audit_contobj(rcu_dereference(current->real_parent)))
+		    >= audit_contid_depth_limit) {
+			rc = -EMLINK;
+			goto conterror;
+		}
 		if (!newcont) {
 			newcont = kmalloc(sizeof(*newcont), GFP_ATOMIC);
 			if (newcont) {
diff --git a/kernel/audit.h b/kernel/audit.h
index de814fcbb38c..fbca07a49c03 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -220,6 +220,8 @@ static inline int audit_hash_contid(u64 contid)
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
 }
 
+#define AUDIT_CONTID_DEPTH_LIMIT	4
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-- 
1.8.3.1
