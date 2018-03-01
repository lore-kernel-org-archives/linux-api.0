From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH V1 09/12] audit: add containerid support for
	config/feature/user records
Date: Thu,  1 Mar 2018 14:41:12 -0500
Message-ID: <5e116a00c87ddf4c2f991f2f2fb2cf7d6a22d4f7.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1519930146.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1519930146.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1519930146.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, madzcar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add container ID information to configuration change, feature set change
and user generated standalone records.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/audit.c       | 50 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/auditfilter.c |  5 ++++-
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index f5cd0bc..a4c0bad 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -358,8 +358,9 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
 {
 	struct audit_buffer *ab;
 	int rc = 0;
+	struct audit_context *context = audit_alloc_local();
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return rc;
 	audit_log_format(ab, "%s=%u old=%u", function_name, new, old);
@@ -369,6 +370,8 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
 		allow_changes = 0; /* Something weird, deny request */
 	audit_log_format(ab, " res=%d", allow_changes);
 	audit_log_end(ab);
+	audit_log_container_info(context, "config", audit_get_containerid(current));
+	audit_free_context(context);
 	return rc;
 }
 
@@ -1016,7 +1019,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	return err;
 }
 
-static void audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
+static void audit_log_common_recv_msg(struct audit_context *context,
+				      struct audit_buffer **ab, u16 msg_type)
 {
 	uid_t uid = from_kuid(&init_user_ns, current_uid());
 	pid_t pid = task_tgid_nr(current);
@@ -1026,7 +1030,7 @@ static void audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
 		return;
 	}
 
-	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
+	*ab = audit_log_start(context, GFP_KERNEL, msg_type);
 	if (unlikely(!*ab))
 		return;
 	audit_log_format(*ab, "pid=%d uid=%u", pid, uid);
@@ -1055,16 +1059,19 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 				     u32 old_lock, u32 new_lock, int res)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
 
 	if (audit_enabled == AUDIT_OFF)
 		return;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
 	audit_log_task_info(ab, current);
 	audit_log_format(ab, " feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
 	audit_log_end(ab);
+	audit_log_container_info(context, "feature", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 static int audit_set_feature(struct sk_buff *skb)
@@ -1293,13 +1300,15 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */
+			struct audit_context *context = audit_alloc_local();
+
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
 				err = tty_audit_push();
 				if (err)
 					break;
 			}
-			audit_log_common_recv_msg(&ab, msg_type);
+			audit_log_common_recv_msg(context, &ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY)
 				audit_log_format(ab, " msg='%.*s'",
 						 AUDIT_MESSAGE_TEXT_MAX,
@@ -1315,6 +1324,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_log_end(ab);
+			audit_log_container_info(context, "user",
+						 audit_get_containerid(current));
+			audit_free_context(context);
 		}
 		break;
 	case AUDIT_ADD_RULE:
@@ -1322,9 +1334,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlmsg_len(nlh) < sizeof(struct audit_rule_data))
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+			struct audit_context *context = audit_alloc_local();
+
+			audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
 			audit_log_format(ab, " audit_enabled=%d res=0", audit_enabled);
 			audit_log_end(ab);
+			audit_log_container_info(context, "config",
+						 audit_get_containerid(current));
+			audit_free_context(context);
 			return -EPERM;
 		}
 		err = audit_rule_change(msg_type, seq, data, nlmsg_len(nlh));
@@ -1332,17 +1349,23 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_LIST_RULES:
 		err = audit_list_rules_send(skb, seq);
 		break;
-	case AUDIT_TRIM:
+	case AUDIT_TRIM: {
+		struct audit_context *context = audit_alloc_local();
 		audit_trim_trees();
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+		audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=trim res=1");
 		audit_log_end(ab);
+		audit_log_container_info(context, "config",
+					 audit_get_containerid(current));
+		audit_free_context(context);
 		break;
+	}
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
 		u32 sizes[2];
 		size_t msglen = nlmsg_len(nlh);
 		char *old, *new;
+		struct audit_context *context = audit_alloc_local();
 
 		err = -EINVAL;
 		if (msglen < 2 * sizeof(u32))
@@ -1364,7 +1387,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* OK, here comes... */
 		err = audit_tag_tree(old, new);
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+		audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
 
 		audit_log_format(ab, " op=make_equiv old=");
 		audit_log_untrustedstring(ab, old);
@@ -1374,6 +1397,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_log_end(ab);
 		kfree(old);
 		kfree(new);
+		audit_log_container_info(context, "config",
+					 audit_get_containerid(current));
+		audit_free_context(context);
 		break;
 	}
 	case AUDIT_SIGNAL_INFO:
@@ -1415,6 +1441,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		struct audit_tty_status s, old;
 		struct audit_buffer	*ab;
 		unsigned int t;
+		struct audit_context *context = audit_alloc_local();
 
 		memset(&s, 0, sizeof(s));
 		/* guard against past and future API changes */
@@ -1433,12 +1460,15 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		old.enabled = t & AUDIT_TTY_ENABLE;
 		old.log_passwd = !!(t & AUDIT_TTY_LOG_PASSWD);
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+		audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=tty_set old-enabled=%d new-enabled=%d"
 				 " old-log_passwd=%d new-log_passwd=%d res=%d",
 				 old.enabled, s.enabled, old.log_passwd,
 				 s.log_passwd, !err);
 		audit_log_end(ab);
+		audit_log_container_info(context, "config",
+					 audit_get_containerid(current));
+		audit_free_context(context);
 		break;
 	}
 	default:
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index c4c8746..5f7f4d6 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1109,11 +1109,12 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
 	struct audit_buffer *ab;
 	uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(current));
 	unsigned int sessionid = audit_get_sessionid(current);
+	struct audit_context *context = audit_alloc_local();
 
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (!ab)
 		return;
 	audit_log_format(ab, "auid=%u ses=%u" ,loginuid, sessionid);
@@ -1122,6 +1123,8 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
 	audit_log_end(ab);
+	audit_log_container_info(context, "config", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 /**
-- 
1.8.3.1
