From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 08/10] sysfs: Add support for permanently empty
	directories.
Date: Thu, 14 May 2015 12:35:02 -0500
Message-ID: <87fv6zhxkp.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87pp63jcca.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Thu, 14 May 2015 12:30:45 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Add two functions sysfs_create_empty_dir and sysfs_remove_empty_dir
that hang a permanently empty directory off of a kobject or remove
a permanently emptpy directory hanging from a kobject.  Export
these new functions so modular filesystems can use them.

As all permanently empty directories are, are names and used
for mouting other filesystems this seems like the right abstraction.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/sysfs/dir.c        | 34 ++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h | 16 ++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0b45ff42f374..8244741474d7 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -121,3 +121,37 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 
 	return kernfs_rename_ns(kn, new_parent, kn->name, new_ns);
 }
+
+/**
+ * sysfs_create_empty_dir - create an always empty directory
+ * @parent_kobj:  kobject that will contain this always empty directory
+ * @name: The name of the always empty directory to add
+ */
+int sysfs_create_empty_dir(struct kobject *parent_kobj, const char *name)
+{
+	struct kernfs_node *kn, *parent = parent_kobj->sd;
+
+	kn = kernfs_create_empty_dir(parent, name, NULL);
+	if (IS_ERR(kn)) {
+		if (PTR_ERR(kn) == -EEXIST)
+			sysfs_warn_dup(parent, name);
+		return PTR_ERR(kn);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_empty_dir);
+
+/**
+ *	sysfs_remove_empty_dir - remove an always empty directory.
+ *	@parent_kobj: kobject that will contain this always empty directory
+ *	@name: The name of the always empty directory to remove
+ *
+ */
+void sysfs_remove_empty_dir(struct kobject *parent_kobj, const char *name)
+{
+	struct kernfs_node *parent = parent_kobj->sd;
+
+	kernfs_remove_by_name_ns(parent, name, NULL);
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_empty_dir);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 99382c0df17e..e156d419de75 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -210,6 +210,10 @@ int __must_check sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
 int __must_check sysfs_move_dir_ns(struct kobject *kobj,
 				   struct kobject *new_parent_kobj,
 				   const void *new_ns);
+int __must_check sysfs_create_empty_dir(struct kobject *parent_kobj,
+					const char *name);
+void sysfs_remove_empty_dir(struct kobject *parent_kobj,
+			    const char *name);
 
 int __must_check sysfs_create_file_ns(struct kobject *kobj,
 				      const struct attribute *attr,
@@ -298,6 +302,18 @@ static inline int sysfs_move_dir_ns(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_create_empty_dir(struct kobject *parent_kobj,
+					 const char *name)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_empty_dir(struct kobject *parent_kobj,
+					  const char *name)
+{
+	return 0;
+}
+
 static inline int sysfs_create_file_ns(struct kobject *kobj,
 				       const struct attribute *attr,
 				       const void *ns)
-- 
2.2.1
