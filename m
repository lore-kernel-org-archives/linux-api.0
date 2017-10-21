From: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Subject: [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 15:45:57 +0200
Message-ID: <20171021134558.21195-1-nicolas__28543.8140425414$1508593769$gmane$org@belouin.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Fasheh <mfasheh-rOS7oXVqrJRBDgjK7y7TUQ@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Phillip Lougher <phillip-Y7wUz+saRi+tmTQ+vhA3Yw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TZUIDd8j+nm9g@public.gmane.org
Cc: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

with CAP_SYS_ADMIN being bloated, the usefulness of using it to
flag a process to be entrusted for e.g reading and writing trusted
xattr is near zero.
CAP_TRUSTED aims to provide userland with a way to mark a process as
entrusted to do specific (not specially admin-centered) actions. It
would for example allow a process to red/write the trusted xattrs.

Signed-off-by: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
---
 include/uapi/linux/capability.h     | 6 +++++-
 security/selinux/include/classmap.h | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ce230aa6d928..27e457b93c84 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -369,7 +369,11 @@ struct vfs_ns_cap_data {
 
 #define CAP_SYS_MOUNT		38
 
-#define CAP_LAST_CAP         CAP_SYS_MOUNT
+/* Allow read/write trusted xattr */
+
+#define CAP_TRUSTED		39
+
+#define CAP_LAST_CAP         CAP_TRUSTED
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index a873dce97fd5..f5dc8e109f5a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -24,9 +24,10 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
+		"wake_alarm", "block_suspend", "audit_read", "sys_mount", \
+		"trusted"
 
-#if CAP_LAST_CAP > CAP_SYS_MOUNT
+#if CAP_LAST_CAP > CAP_TRUSTED
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
-- 
2.14.2
