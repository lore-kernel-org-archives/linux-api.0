From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V6 10/10] audit: emit AUDIT_NS_INFO record with
	AUDIT_VIRT_CONTROL record
Date: Fri, 17 Apr 2015 03:35:57 -0400
Message-ID: <6d1846744df4efe1c62a22283150d9c9ca1c2412.1429252659.git.rgb@redhat.com>
References: <cover.1429252659.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1429252659.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1429252659.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1429252659.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/audit.h |    2 ++
 kernel/audit.c             |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 567b45f..b6a55fe 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -163,6 +163,8 @@
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
+#define AUDIT_VIRT_CONTROL	2500	/* Start, Pause, Stop VM */
+
 /* Rule flags */
 #define AUDIT_FILTER_USER	0x00	/* Apply rule to user-generated messages */
 #define AUDIT_FILTER_TASK	0x01	/* Apply rule at task creation (not syscall) */
diff --git a/kernel/audit.c b/kernel/audit.c
index a7b1b61..8a01d88 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -943,6 +943,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			}
 			audit_set_portid(ab, NETLINK_CB(skb).portid);
 			audit_log_end(ab);
+			if (msg_type == AUDIT_VIRT_CONTROL)
+				audit_log_ns_info(NULL);
 			mutex_lock(&audit_cmd_mutex);
 		}
 		break;
-- 
1.7.1
