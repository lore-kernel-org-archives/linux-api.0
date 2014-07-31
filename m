From: Frediano Ziglio <frediano.ziglio@citrix.com>
Subject: [PATCH 2/2] xen: Implement ioctl to restrict event
 channels to a specific domain
Date: Thu, 31 Jul 2014 14:18:07 +0100
Message-ID: <E1XCqFO-00063u-Df@lists.xen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel <xen-devel@lists.xenproject.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a RESTRICT ioctl to /dev/xen/evtchn, which allows an event channel
file descriptor to be restricted to only working with a particular domain.

Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
---
 drivers/xen/evtchn.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/xen/evtchn.h | 13 +++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 00f40f0..a9934b7 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -71,8 +71,12 @@ struct per_user_data {
 	wait_queue_head_t evtchn_wait;
 	struct fasync_struct *evtchn_async_queue;
 	const char *name;
+
+	domid_t restrict_domid;
 };
 
+#define UNRESTRICTED_DOMID ((domid_t)-1)
+
 struct user_evtchn {
 	struct rb_node node;
 	struct per_user_data *user;
@@ -349,6 +353,10 @@ static long evtchn_ioctl(struct file *file,
 		struct ioctl_evtchn_bind_virq bind;
 		struct evtchn_bind_virq bind_virq;
 
+		rc = -EACCES;
+		if (u->restrict_domid != UNRESTRICTED_DOMID)
+			break;
+
 		rc = -EFAULT;
 		if (copy_from_user(&bind, uarg, sizeof(bind)))
 			break;
@@ -374,6 +382,11 @@ static long evtchn_ioctl(struct file *file,
 		if (copy_from_user(&bind, uarg, sizeof(bind)))
 			break;
 
+		rc = -EACCES;
+		if (u->restrict_domid != UNRESTRICTED_DOMID &&
+		    u->restrict_domid != bind.remote_domain)
+			break;
+
 		bind_interdomain.remote_dom  = bind.remote_domain;
 		bind_interdomain.remote_port = bind.remote_port;
 		rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_interdomain,
@@ -391,6 +404,10 @@ static long evtchn_ioctl(struct file *file,
 		struct ioctl_evtchn_bind_unbound_port bind;
 		struct evtchn_alloc_unbound alloc_unbound;
 
+		rc = -EACCES;
+		if (u->restrict_domid != UNRESTRICTED_DOMID)
+			break;
+
 		rc = -EFAULT;
 		if (copy_from_user(&bind, uarg, sizeof(bind)))
 			break;
@@ -459,6 +476,27 @@ static long evtchn_ioctl(struct file *file,
 		break;
 	}
 
+	case IOCTL_EVTCHN_RESTRICT_DOMID: {
+		struct ioctl_evtchn_restrict_domid ierd;
+
+		rc = -EACCES;
+		if (u->restrict_domid != UNRESTRICTED_DOMID)
+			break;
+
+		rc = -EFAULT;
+		if (copy_from_user(&ierd, uarg, sizeof(ierd)))
+			break;
+
+		rc = -EINVAL;
+		if (ierd.domid == 0 || ierd.domid >= DOMID_FIRST_RESERVED)
+			break;
+
+		u->restrict_domid = ierd.domid;
+		rc = 0;
+
+		break;
+	}
+
 	default:
 		rc = -ENOSYS;
 		break;
@@ -514,6 +552,8 @@ static int evtchn_open(struct inode *inode, struct file *filp)
 	mutex_init(&u->ring_cons_mutex);
 	spin_lock_init(&u->ring_prod_lock);
 
+	u->restrict_domid = UNRESTRICTED_DOMID;
+
 	filp->private_data = u;
 
 	return nonseekable_open(inode, filp);
diff --git a/include/uapi/xen/evtchn.h b/include/uapi/xen/evtchn.h
index 14e833e..72f5492 100644
--- a/include/uapi/xen/evtchn.h
+++ b/include/uapi/xen/evtchn.h
@@ -85,4 +85,17 @@ struct ioctl_evtchn_notify {
 #define IOCTL_EVTCHN_RESET				\
 	_IOC(_IOC_NONE, 'E', 5, 0)
 
+/* Restrict this file descriptor so that it can only be applied to a
+ * nominated domain.  Once a file descriptor has been restricted it
+ * cannot be de-restricted, and must be closed and re-openned.  Event
+ * channels which were bound before restricting remain bound
+ * afterwards, and can be notified as usual.
+ */
+#define IOCTL_EVTCHN_RESTRICT_DOMID			\
+	_IOC(_IOC_NONE, 'E', 6, sizeof(struct ioctl_evtchn_restrict_domid))
+struct ioctl_evtchn_restrict_domid {
+	domid_t domid;
+};
+
+
 #endif /* __LINUX_PUBLIC_EVTCHN_H__ */
-- 
1.9.1
