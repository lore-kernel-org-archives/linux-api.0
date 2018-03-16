From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH ghak32 V2 07/13] audit: add container aux record to
	watch/tree/mark
Date: Fri, 16 Mar 2018 05:00:34 -0400
Message-ID: <737f914a88d048b9985984c0ce1f946c30ca374c.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, madzcar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add container ID auxiliary record to mark, watch and tree rule
configuration standalone records.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/audit_fsnotify.c |  5 ++++-
 kernel/audit_tree.c     |  5 ++++-
 kernel/audit_watch.c    | 33 +++++++++++++++++++--------------
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index 52f368b..18c110d 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -124,10 +124,11 @@ static void audit_mark_log_rule_change(struct audit_fsnotify_mark *audit_mark, c
 {
 	struct audit_buffer *ab;
 	struct audit_krule *rule = audit_mark->rule;
+	struct audit_context *context = audit_alloc_local();
 
 	if (!audit_enabled)
 		return;
-	ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start(context, GFP_NOFS, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return;
 	audit_log_format(ab, "auid=%u ses=%u op=%s",
@@ -138,6 +139,8 @@ static void audit_mark_log_rule_change(struct audit_fsnotify_mark *audit_mark, c
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=1", rule->listnr);
 	audit_log_end(ab);
+	audit_log_container_info(context, "config", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 void audit_remove_mark(struct audit_fsnotify_mark *audit_mark)
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 67e6956..7c085be 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -496,8 +496,9 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 static void audit_tree_log_remove_rule(struct audit_krule *rule)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return;
 	audit_log_format(ab, "op=remove_rule");
@@ -506,6 +507,8 @@ static void audit_tree_log_remove_rule(struct audit_krule *rule)
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=1", rule->listnr);
 	audit_log_end(ab);
+	audit_log_container_info(context, "config", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 static void kill_rules(struct audit_tree *tree)
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 9eb8b35..60d75a2 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -238,20 +238,25 @@ static struct audit_watch *audit_dupe_watch(struct audit_watch *old)
 
 static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watch *w, char *op)
 {
-	if (audit_enabled) {
-		struct audit_buffer *ab;
-		ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
-		if (unlikely(!ab))
-			return;
-		audit_log_format(ab, "auid=%u ses=%u op=%s",
-				 from_kuid(&init_user_ns, audit_get_loginuid(current)),
-				 audit_get_sessionid(current), op);
-		audit_log_format(ab, " path=");
-		audit_log_untrustedstring(ab, w->path);
-		audit_log_key(ab, r->filterkey);
-		audit_log_format(ab, " list=%d res=1", r->listnr);
-		audit_log_end(ab);
-	}
+	struct audit_buffer *ab;
+	struct audit_context *context = audit_alloc_local();
+
+	if (!audit_enabled)
+		return;
+
+	ab = audit_log_start(context, GFP_NOFS, AUDIT_CONFIG_CHANGE);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab, "auid=%u ses=%u op=%s",
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 audit_get_sessionid(current), op);
+	audit_log_format(ab, " path=");
+	audit_log_untrustedstring(ab, w->path);
+	audit_log_key(ab, r->filterkey);
+	audit_log_format(ab, " list=%d res=1", r->listnr);
+	audit_log_end(ab);
+	audit_log_container_info(context, "config", audit_get_containerid(current));
+	audit_free_context(context);
 }
 
 /* Update inode info in audit rules based on filesystem event. */
-- 
1.8.3.1
