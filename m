From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 08/10] sysfs: Add support for permanently empty directories to serve as mount points.
Date: Fri, 15 May 2015 21:09:53 -0500
Message-ID: <87fv6xtgr2.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87siaxuvik.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 May 2015 21:05:39 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Add two functions sysfs_create_mount_point and sysfs_remove_mount_point
that hang a permanently empty directory off of a kobject or remove a
permanently emptpy directory hanging from a kobject.  Export these new
functions so modular filesystems can use them.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/sysfs/dir.c        | 34 ++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h | 16 ++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0b45ff42f374..94374e435025 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -121,3 +121,37 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 
 	return kernfs_rename_ns(kn, new_parent, kn->name, new_ns);
 }
+
+/**
+ * sysfs_create_mount_point - create an always empty directory
+ * @parent_kobj:  kobject that will contain this always empty directory
+ * @name: The name of the always empty directory to add
+ */
+int sysfs_create_mount_point(struct kobject *parent_kobj, const char *name)
+{
+	struct kernfs_node *kn, *parent = parent_kobj->sd;
+
+	kn = kernfs_create_empty_dir(parent, name);
+	if (IS_ERR(kn)) {
+		if (PTR_ERR(kn) == -EEXIST)
+			sysfs_warn_dup(parent, name);
+		return PTR_ERR(kn);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_mount_point);
+
+/**
+ *	sysfs_remove_mount_point - remove an always empty directory.
+ *	@parent_kobj: kobject that will contain this always empty directory
+ *	@name: The name of the always empty directory to remove
+ *
+ */
+void sysfs_remove_mount_point(struct kobject *parent_kobj, const char *name)
+{
+	struct kernfs_node *parent = parent_kobj->sd;
+
+	kernfs_remove_by_name_ns(parent, name, NULL);
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_mount_point);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 99382c0df17e..3e7e41acc451 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -210,6 +210,10 @@ int __must_check sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
 int __must_check sysfs_move_dir_ns(struct kobject *kobj,
 				   struct kobject *new_parent_kobj,
 				   const void *new_ns);
+int __must_check sysfs_create_mount_point(struct kobject *parent_kobj,
+					  const char *name);
+void sysfs_remove_mount_point(struct kobject *parent_kobj,
+			      const char *name);
 
 int __must_check sysfs_create_file_ns(struct kobject *kobj,
 				      const struct attribute *attr,
@@ -298,6 +302,18 @@ static inline int sysfs_move_dir_ns(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_create_mount_point(struct kobject *parent_kobj,
+					   const char *name)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_mount_point(struct kobject *parent_kobj,
+					    const char *name)
+{
+	return 0;
+}
+
 static inline int sysfs_create_file_ns(struct kobject *kobj,
 				       const struct attribute *attr,
 				       const void *ns)
-- 
2.2.1
