From: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Subject: [PATCH] userns/capability: Add user namespace capability
Date: Sat, 17 Oct 2015 17:58:04 +0200
Message-ID: <5622700C.9090107@miglix.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add capability CAP_SYS_USER_NS.
Tasks having CAP_SYS_USER_NS are allowed to create a new user namespace
when calling clone or unshare with CLONE_NEWUSER.

Rationale:

Linux 3.8 saw the introduction of unpriviledged user namespaces,
allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" root
inside a separate user namespace. Before that, any namespace creation
required CAP_SYS_ADMIN (or, in practice, the user had to be root).
Unfortunately, there have been some security-relevant bugs in the
meantime. Because of the fairly complex nature of user namespaces, it is
reasonable to say that future vulnerabilties can not be excluded. Some
distributions even wholly disable user namespaces because of this.

Both options, user namespaces with and without CAP_SYS_ADMIN, can be
said to represent the extreme end of the spectrum. In practice, there is
no reason for every process to have the abilitiy to create user
namespaces. Indeed, only very few and specialized programs require user
namespaces. This seems to be a perfect fit for the (file) capability
system: Priviledged users could manually allow only a certain executable
to be able to create user namespaces by setting a certain capability,
I'd suggest the name CAP_SYS_USER_NS. Executables completely unrelated
to user namespaces should and can not create them.

The capability should only be required in the "root" user namespace (the
user namespace with level 0) though, to allow nested user namespaces to
work as intended. If a user namespace has a level greater than 0, the
original process must have had CAP_SYS_USER_NS, so it is "trusted" anyway.

One question remains though: Does this break userspace executables that
expect being able to create user namespaces without priviledge? Since
creating user namespaces without CAP_SYS_ADMIN was not possible before
Linux 3.8, programs should already expect a potential EPERM upon calling
clone. Since creating a user namespace without CAP_SYS_USER_NS would
also cause EPERM, we should be on the safe side.

Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
---
 include/uapi/linux/capability.h     | 5 ++++-
 kernel/cred.c                       | 7 ++++++-
 security/selinux/include/classmap.h | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 12c37a1..d83540f 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -351,8 +351,11 @@ struct vfs_cap_data {
  #define CAP_AUDIT_READ		37
 +/* Allow creating user namespaces (CLONE_NEWUSER) using clone() and unshare() */
 -#define CAP_LAST_CAP         CAP_AUDIT_READ
+#define CAP_SYS_USER_NS      38
+
+#define CAP_LAST_CAP         CAP_SYS_USER_NS
  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 diff --git a/kernel/cred.c b/kernel/cred.c
index 71179a0..847d499 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -345,7 +345,12 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		return -ENOMEM;
  	if (clone_flags & CLONE_NEWUSER) {
-		ret = create_user_ns(new);
+		if (new->user_ns->level == 0 &&
+		    !has_capability(p, CAP_SYS_USER_NS)) {
+			ret = -EPERM;
+		} else {
+			ret = create_user_ns(new);
+		}
 		if (ret < 0)
 			goto error_put;
 	}
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 5a4eef5..07cec76 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -39,7 +39,7 @@ struct security_class_mapping secclass_map[] = {
 	    "linux_immutable", "net_bind_service", "net_broadcast",
 	    "net_admin", "net_raw", "ipc_lock", "ipc_owner", "sys_module",
 	    "sys_rawio", "sys_chroot", "sys_ptrace", "sys_pacct", "sys_admin",
-	    "sys_boot", "sys_nice", "sys_resource", "sys_time",
+	    "sys_boot", "sys_nice", "sys_resource", "sys_time", "sys_user_ns",
 	    "sys_tty_config", "mknod", "lease", "audit_write",
 	    "audit_control", "setfcap", NULL } },
 	{ "filesystem",
-- 
2.6.1
