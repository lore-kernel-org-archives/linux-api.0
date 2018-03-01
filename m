From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH V1 07/12] audit: add container aux record to watch/tree/mark
Date: Thu,  1 Mar 2018 14:41:10 -0500
Message-ID: <6c071b3e4fbe848ccd692c7dc27c9f75589852c0.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add container ID information to mark, watch and tree rule standalone
records.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
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
index fd35312..2ad85d4 100644
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
