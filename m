From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 3/8] namespaces: expose ns instance serial numbers in proc
Date: Wed, 20 Aug 2014 21:09:36 -0400
Message-ID: <cd6cd0622ce677b639afae18a69ff79c72490bab.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Expose the namespace instace serial numbers in the proc filesystem at
/proc/<pid>/ns/<ns>_snum.  The link text gives the serial number in hex.

"snum" was chosen instead of "seq" for consistency with inum and there are a
number of other uses of "seq" in the namespace code.

Suggested-by: Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/proc/namespaces.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 8902609..e953e0a 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -47,12 +47,15 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
 	struct inode *inode = dentry->d_inode;
 	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
 
-	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
-		ns_ops->name, inode->i_ino);
+	if (strstr(dentry->d_iname, "_snum"))
+		return dynamic_dname(dentry, buffer, buflen, "%s_snum:[%llx]",
+			ns_ops->name, ns_ops->snum(PROC_I(inode)->ns.ns));
+	else
+		return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
+			ns_ops->name, inode->i_ino);
 }
 
-const struct dentry_operations ns_dentry_operations =
-{
+const struct dentry_operations ns_dentry_operations = {
 	.d_delete	= always_delete_dentry,
 	.d_dname	= ns_dname,
 };
@@ -160,7 +163,10 @@ static int proc_ns_readlink(struct dentry *dentry, char __user *buffer, int bufl
 	if (!ns)
 		goto out_put_task;
 
-	snprintf(name, sizeof(name), "%s:[%u]", ns_ops->name, ns_ops->inum(ns));
+	if (strstr(dentry->d_iname, "_snum"))
+		snprintf(name, sizeof(name), "%s_snum:[%llx]", ns_ops->name, ns_ops->snum(ns));
+	else
+		snprintf(name, sizeof(name), "%s:[%u]", ns_ops->name, ns_ops->inum(ns));
 	res = readlink_copy(buffer, buflen, name);
 	ns_ops->put(ns);
 out_put_task:
@@ -210,16 +216,23 @@ static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
-	if (ctx->pos >= 2 + ARRAY_SIZE(ns_entries))
+	if (ctx->pos >= 2 + 2 * ARRAY_SIZE(ns_entries))
 		goto out;
 	entry = ns_entries + (ctx->pos - 2);
 	last = &ns_entries[ARRAY_SIZE(ns_entries) - 1];
 	while (entry <= last) {
 		const struct proc_ns_operations *ops = *entry;
+		char name[50];
+
 		if (!proc_fill_cache(file, ctx, ops->name, strlen(ops->name),
 				     proc_ns_instantiate, task, ops))
 			break;
 		ctx->pos++;
+		snprintf(name, sizeof(name), "%s_snum", ops->name);
+		if (!proc_fill_cache(file, ctx, name, strlen(name),
+				     proc_ns_instantiate, task, ops))
+			break;
+		ctx->pos++;
 		entry++;
 	}
 out:
@@ -247,9 +260,13 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
 
 	last = &ns_entries[ARRAY_SIZE(ns_entries)];
 	for (entry = ns_entries; entry < last; entry++) {
-		if (strlen((*entry)->name) != len)
+		char name[50];
+
+		snprintf(name, sizeof(name), "%s_snum", (*entry)->name);
+		if (strlen((*entry)->name) != len && strlen(name) != len)
 			continue;
-		if (!memcmp(dentry->d_name.name, (*entry)->name, len))
+		if (!memcmp(dentry->d_name.name, (*entry)->name, len)
+		    || !memcmp(dentry->d_name.name, name, len))
 			break;
 	}
 	if (entry == last)
-- 
1.7.1
