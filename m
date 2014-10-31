From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/5] kdbus: extend structures with security pointer for lsm
Date: Fri, 31 Oct 2014 17:36:33 +0100
Message-ID: <1414773397-26490-2-git-send-email-k.lewandowsk@samsung.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: pmoore@redhat.com, jkosina@suse.cz, linux-api@vger.kernel.org, inux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk, daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com, marcel@holtmann.org, tixxdz@opendz.org, javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk, linux-security-module@vger.kernel.org, lmctlx@gmail.com, r.krypa@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
---
 drivers/misc/kdbus/bus.h        | 2 ++
 drivers/misc/kdbus/connection.h | 2 ++
 drivers/misc/kdbus/domain.h     | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/misc/kdbus/bus.h b/drivers/misc/kdbus/bus.h
index fd9d843..5c403ef 100644
--- a/drivers/misc/kdbus/bus.h
+++ b/drivers/misc/kdbus/bus.h
@@ -49,6 +49,7 @@
  * @conn_hash:		Map of connection IDs
  * @monitors_list:	Connections that monitor this bus
  * @meta:		Meta information about the bus creator
+ * @security:		LSM security blob
  *
  * A bus provides a "bus" endpoint / device node.
  *
@@ -84,6 +85,7 @@ struct kdbus_bus {
 	struct list_head monitors_list;
 
 	struct kdbus_meta *meta;
+	void *security;
 };
 
 int kdbus_bus_make_user(const struct kdbus_cmd_make *make,
diff --git a/drivers/misc/kdbus/connection.h b/drivers/misc/kdbus/connection.h
index 01a5bd8..f39e040 100644
--- a/drivers/misc/kdbus/connection.h
+++ b/drivers/misc/kdbus/connection.h
@@ -64,6 +64,7 @@
  *			waits for replies from the peer
  * @wait:		Wake up this endpoint
  * @queue:		The message queue associcated with this connection
+ * @security:		LSM security blob
  */
 struct kdbus_conn {
 	struct kref kref;
@@ -98,6 +99,7 @@ struct kdbus_conn {
 	atomic_t reply_count;
 	wait_queue_head_t wait;
 	struct kdbus_queue queue;
+	void *security;
 };
 
 struct kdbus_kmsg;
diff --git a/drivers/misc/kdbus/domain.h b/drivers/misc/kdbus/domain.h
index f51cdb5..db2d0db 100644
--- a/drivers/misc/kdbus/domain.h
+++ b/drivers/misc/kdbus/domain.h
@@ -35,6 +35,7 @@
  * @bus_list:		Buses in this domain
  * @user_hash:		Accounting of user resources
  * @user_idr:		Map of all users; smallest possible index
+ * @security:		LSM security blob
  *
  * A domain provides a "control" device node. Every domain has its
  * own major number for its endpoint device nodes.
@@ -62,6 +63,7 @@ struct kdbus_domain {
 	struct list_head bus_list;
 	DECLARE_HASHTABLE(user_hash, 6);
 	struct idr user_idr;
+	void *security;
 };
 
 /**
-- 
2.1.1

