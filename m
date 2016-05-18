From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH RFC] user-namespaced file capabilities - now with more magic
Date: Wed, 18 May 2016 16:57:52 -0500
Message-ID: <20160518215752.GA9187@mail.hallyn.com>
References: <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
 <20160502035452.GA31837@mail.hallyn.com>
 <87h9egp2oq.fsf@x220.int.ebiederm.org>
 <CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
 <20160503051921.GA31551@mail.hallyn.com>
 <87bn4nhejj.fsf@x220.int.ebiederm.org>
 <20160507231012.GA11076@pc.thejh.net>
 <20160511210221.GA24015@mail.hallyn.com>
 <20160516211523.GA5282@mail.hallyn.com>
 <20160516214804.GA5926@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160516214804.GA5926@mail.hallyn.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>, LSM <linux-security-module@vger.kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

This patch introduces a new security.nscapability xattr.  It
is mostly like security.capability, but also lists a 'rootid'.
This is the uid_t (in init_user_ns) of the root id (uid 0 in a
namespace) in whose namespaces the file capabilities may take
effect.

A privileged (cap_setfcap) process in the initial user ns may
set and read this xattr directly.  However, its real intent is
to be used as a transparent fallback in user namespaces.

Root in a user ns cannot be trusted to write security.capability
xattrs, because any user on the host could map his own uid to root
in a namespace, write the xattr, and execute the file with privilege
on the host.

With this patch, when root in a user ns asks to write security.capability,
the kernel will transparently write a security.nscapability xattr
instead, filling in the kuid of the calling user's root uid.  Subsequently,
any task executing the file which has the noted k_uid as its root uid,
or which is in a descendent user_ns of such a user_ns, will run the
file with capabilities.

When reading the security.capability xattr from a non-init user_ns, a valid
security.nscapability will be shown if it exists.  Such a task is not
allowed to read security.nscapability.  This could be accomodated, however
it requires the kernel to convert the kuid_t to a valid uid in the reader's
user_ns.  So for now it's simply not supported.

Only a single security.nscapability xattr may be written.  This patch
could be expanded to allow a list of capabilities and rootids, however
I do not believe that to be a worthwhile use case.

This allows a simple setxattr to work, allows tar/untar to
work, and allows us to tar in one namespace and untar in
another while preserving the capability, without risking
leaking privilege into a parent namespace.

Note - listxattr is not being handled here.  So results of that can be
inconsistent with get/setxattr.  Fixing that will require yet more
deceit in fs/xattr.c.

Note2 - it may be less sneaky to hide all the magic behind the
security.nscapability xattr.  So userspace would need to know to
use that xattr name when needed, but with the same format as
security.capability.  The kuid_t rootid would be filled in by the
kernel.  That's a middle ground between my last patch and this one.

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 fs/xattr.c                      |  18 ++-
 include/linux/capability.h      |   8 +-
 include/uapi/linux/capability.h |  19 +++
 include/uapi/linux/xattr.h      |   3 +
 security/commoncap.c            | 253 ++++++++++++++++++++++++++++++++++++++--
 5 files changed, 291 insertions(+), 10 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 4861322..5c0e7ae 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -94,11 +94,26 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 {
 	struct inode *inode = dentry->d_inode;
 	int error = -EOPNOTSUPP;
+	void *wvalue = NULL;
+	size_t wsize = 0;
 	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
 				   XATTR_SECURITY_PREFIX_LEN);
 
-	if (issec)
+	if (issec) {
 		inode->i_flags &= ~S_NOSEC;
+		/* if root in a non-init user_ns tries to set
+		 * security.capability, write a security.nscapability
+		 * in its place */
+		if (!strcmp(name, "security.capability") &&
+				current_user_ns() != &init_user_ns) {
+			cap_setxattr_make_nscap(dentry, value, size, &wvalue, &wsize);
+			if (!wvalue)
+				return -EPERM;
+			value = wvalue;
+			size = wsize;
+			name = "security.nscapability";
+		}
+	}
 	if (inode->i_op->setxattr) {
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
@@ -114,6 +129,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 			fsnotify_xattr(dentry);
 	}
 
+	kfree(wvalue);
 	return error;
 }
 
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 00690ff..9376146 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -13,7 +13,7 @@
 #define _LINUX_CAPABILITY_H
 
 #include <uapi/linux/capability.h>
-
+#include <linux/uidgid.h>
 
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
 #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
@@ -31,6 +31,9 @@ struct cpu_vfs_cap_data {
 	kernel_cap_t inheritable;
 };
 
+#define NS_CAPS_VERSION(x) (x & 0xFF)
+#define NS_CAPS_FLAGS(x) ((x >> 8) & 0xFF)
+
 #define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
@@ -240,4 +243,7 @@ extern bool file_ns_capable(const struct file *file, struct user_namespace *ns,
 /* audit system wants to get cap info from files as well */
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
 
+extern void cap_setxattr_make_nscap(struct dentry *dentry, const void *value,
+		size_t size, void **wvalue, size_t *wsize);
+
 #endif /* !_LINUX_CAPABILITY_H */
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 12c37a1..1f7e4c6 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -62,6 +62,9 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32_2           2
 #define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
 
+/* version number for security.nscapability xattrs hdr->hdr_info */
+#define VFS_NS_CAP_REVISION     1
+
 #define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
@@ -74,6 +77,22 @@ struct vfs_cap_data {
 	} data[VFS_CAP_U32];
 };
 
+#define VFS_NS_CAP_EFFECTIVE    0x1
+/*
+ * 32-bit hdr_info contains
+ * 16 leftmost: reserved
+ * next 8: flags (only VFS_NS_CAP_EFFECTIVE so far)
+ * last 8: version
+ */
+struct vfs_ns_cap_data {
+       __le32 magic_etc;
+       __le32 rootid;
+       struct {
+               __le32 permitted;    /* Little endian */
+               __le32 inheritable;  /* Little endian */
+       } data[VFS_CAP_U32];
+};
+
 #ifndef __KERNEL__
 
 /*
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index 1590c49..67c80ab 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -68,6 +68,9 @@
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
+#define XATTR_NS_CAPS_SUFFIX "nscapability"
+#define XATTR_NAME_NS_CAPS XATTR_SECURITY_PREFIX XATTR_NS_CAPS_SUFFIX
+
 #define XATTR_POSIX_ACL_ACCESS  "posix_acl_access"
 #define XATTR_NAME_POSIX_ACL_ACCESS XATTR_SYSTEM_PREFIX XATTR_POSIX_ACL_ACCESS
 #define XATTR_POSIX_ACL_DEFAULT  "posix_acl_default"
diff --git a/security/commoncap.c b/security/commoncap.c
index 48071ed..53161bc 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -310,13 +310,18 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 	struct inode *inode = d_backing_inode(dentry);
 	int error;
 
-	if (!inode->i_op->getxattr)
+	if (!inode || !inode->i_op->getxattr)
 	       return 0;
 
+	error = inode->i_op->getxattr(dentry, XATTR_NAME_NS_CAPS, NULL, 0);
+	if (error > 0)
+		return 1;
+
 	error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
-	if (error <= 0)
-		return 0;
-	return 1;
+	if (error > 0)
+		return 1;
+
+	return 0;
 }
 
 /**
@@ -330,11 +335,155 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 int cap_inode_killpriv(struct dentry *dentry)
 {
 	struct inode *inode = d_backing_inode(dentry);
+	int ret1, ret2;
 
-	if (!inode->i_op->removexattr)
+	if (!inode || !inode->i_op->removexattr)
 	       return 0;
 
-	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+	ret1 = inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+	ret2 = inode->i_op->removexattr(dentry, XATTR_NAME_NS_CAPS);
+
+	if (ret1 != 0 && ret1 != -ENODATA)
+		return ret1;
+	if (ret2 == -ENODATA)
+		return 0;
+	return ret2;
+}
+
+/*
+ * getsecurity: We are called if reading of security.capable
+ * failed.  Since that does not exist, check whether the
+ * security.nscapability exists.  If it does, convert the kuid
+ * into the caller's context and return it
+ */
+static int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer, bool alloc)
+{
+	int error, ret;
+	struct user_namespace *ns;
+	kuid_t kroot;
+	uid_t root;
+	char *tmpbuf = NULL;
+	bool foundroot = false;
+	struct vfs_ns_cap_data *nscap;
+	struct dentry *dentry;
+
+	if (!inode->i_op->getxattr)
+		return -EOPNOTSUPP;
+
+	/* TODO - do we want to return the capability with the rootid converted
+	 * if this is security.nscapability?  It's not critical, so just say
+	 * no for now. */
+	if (strcmp(name, "nscapability") == 0 && current_user_ns() != &init_user_ns)
+		return -EPERM;
+
+	if (strcmp(name, "capability") != 0)
+		return -EOPNOTSUPP;
+
+	dentry = d_find_alias(inode);
+	if (!dentry)
+		return -EINVAL;
+
+	ret = vfs_getxattr_alloc(dentry, "security.nscapability",
+			&tmpbuf, 0, GFP_NOFS);
+
+	if (ret != sizeof(struct vfs_ns_cap_data)) {
+		kfree(tmpbuf);
+		return -EOPNOTSUPP;
+	}
+
+	/* verify the uid maps to a ancestor root uid, if so convert
+	   this to a valid security.capability */
+	nscap = (struct vfs_ns_cap_data *) tmpbuf;
+	root = le32_to_cpu(nscap->rootid);
+	kroot = make_kuid(&init_user_ns, root);
+	for (ns = current_user_ns(); ; ns = ns->parent) {
+		if (from_kuid(ns, kroot) == 0) {
+			foundroot = true;
+			break;
+		}
+		if (ns == &init_user_ns)
+			break;
+	}
+	if (!foundroot) {
+		kfree(tmpbuf);
+		return -EOPNOTSUPP;
+	}
+
+	error = sizeof(struct vfs_cap_data);
+	if (alloc) {
+		*buffer = kmalloc(sizeof(struct vfs_cap_data), GFP_ATOMIC);
+		if (*buffer) {
+			struct vfs_ns_cap_data *cap = *buffer;
+			__le32 nsmagic, magic;
+			memcpy(&cap->data, &nscap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
+			nsmagic = le32_to_cpu(nscap->magic_etc);
+			magic = VFS_CAP_REVISION;
+			if (NS_CAPS_FLAGS(nsmagic) & VFS_NS_CAP_EFFECTIVE)
+				magic |= VFS_CAP_FLAGS_EFFECTIVE;
+			cap->magic_etc = cpu_to_le32(magic);
+		}
+	}
+	kfree(tmpbuf);
+	return error;
+}
+
+static bool dentry_has_nonns_capability(struct dentry *dentry)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	int error;
+
+	if (!inode || !inode->i_op->getxattr)
+		return false;
+	error = inode->i_op->getxattr(dentry, "security.capability", NULL, 0);
+	if (error >= 0)
+		return true;
+	return false;
+}
+
+/*
+ * Use requested a write of security.capability but is in a non-init
+ * userns.  So we construct and write a security.nscapability.
+ *
+ * If all is ok, wvalue has an allocated new value.  Otherwise, wvalue
+ * is NULL.
+ */
+void cap_setxattr_make_nscap(struct dentry *dentry, const void *value, size_t size,
+				    void **wvalue, size_t *wsize)
+{
+	struct vfs_ns_cap_data nscap;
+	const struct vfs_cap_data *cap = value;
+	__u32 magic, nsmagic;
+	struct user_namespace *ns = current_user_ns();
+	struct inode *inode = d_backing_inode(dentry);
+	kuid_t rootid;
+
+	if (!value || size != sizeof(struct vfs_cap_data))
+		return;
+	if (!inode || !capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
+		return;
+
+	/* refuse if security.capability exists */
+	if (dentry_has_nonns_capability(dentry))
+		return;
+
+	rootid = make_kuid(ns, 0);
+	if (!uid_valid(rootid))
+		return;
+
+	nscap.rootid = cpu_to_le32(from_kuid(&init_user_ns, rootid));
+	nsmagic = VFS_NS_CAP_REVISION;
+	magic = le32_to_cpu(cap->magic_etc);
+	if (magic & VFS_CAP_FLAGS_EFFECTIVE)
+		nsmagic |= VFS_NS_CAP_REVISION << 8;
+	nscap.magic_etc = cpu_to_le32(nsmagic);
+	memcpy(&nscap.data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
+
+	*wsize = sizeof(struct vfs_ns_cap_data);
+	*wvalue = kmalloc(*wsize, GFP_ATOMIC);
+	if (!*wvalue)
+		return;
+	memcpy(*wvalue, &nscap, *wsize);
+	return;
 }
 
 /*
@@ -438,6 +587,68 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
 	return 0;
 }
 
+int get_vfs_ns_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	unsigned i;
+	u32 magic_etc;
+	ssize_t size;
+	struct vfs_ns_cap_data nscap;
+	bool foundroot = false;
+	kuid_t kroot;
+	uid_t root;
+	struct user_namespace *ns;
+
+	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
+
+	if (!inode || !inode->i_op->getxattr)
+		return -ENODATA;
+
+	size = inode->i_op->getxattr((struct dentry *)dentry, XATTR_NAME_NS_CAPS,
+			&nscap, sizeof(nscap));
+	if (size == -ENODATA || size == -EOPNOTSUPP)
+		/* no data, that's ok */
+		return -ENODATA;
+	if (size < 0)
+		return size;
+	if (size != sizeof(nscap))
+		return -EINVAL;
+
+	root = le32_to_cpu(nscap.rootid);
+	kroot = make_kuid(&init_user_ns, root);
+	for (ns = current_user_ns(); ; ns = ns->parent) {
+		if (from_kuid(ns, kroot) == 0) {
+			foundroot = true;
+			break;
+		}
+		if (ns == &init_user_ns)
+			break;
+	}
+	if (!foundroot)
+		return -ENODATA;
+
+	magic_etc = le32_to_cpu(nscap.magic_etc);
+
+	if (NS_CAPS_VERSION(magic_etc) != VFS_NS_CAP_REVISION)
+		return -EINVAL;
+
+	cpu_caps->magic_etc = VFS_CAP_REVISION_2;
+	if (NS_CAPS_FLAGS(magic_etc) & VFS_NS_CAP_EFFECTIVE)
+		cpu_caps->magic_etc |= VFS_CAP_FLAGS_EFFECTIVE;
+	/* copy the entry */
+	CAP_FOR_EACH_U32(i) {
+		if (i >= VFS_CAP_U32_2)
+			break;
+		cpu_caps->permitted.cap[i] = le32_to_cpu(nscap.data[i].permitted);
+		cpu_caps->inheritable.cap[i] = le32_to_cpu(nscap.data[i].inheritable);
+	}
+
+	cpu_caps->permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
+	cpu_caps->inheritable.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
+
+	return 0;
+}
+
 /*
  * Attempt to get the on-exec apply capability sets for an executable file from
  * its xattrs and, if present, apply them to the proposed credentials being
@@ -457,10 +668,12 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 		return 0;
 
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
+	if (rc == -ENODATA)
+		rc = get_vfs_ns_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
 	if (rc < 0) {
 		if (rc == -EINVAL)
-			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
-				__func__, rc, bprm->filename);
+			printk(KERN_NOTICE "Invalid argument reading file caps for %s\n",
+					bprm->filename);
 		else if (rc == -ENODATA)
 			rc = 0;
 		goto out;
@@ -657,6 +870,18 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		       const void *value, size_t size, int flags)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (current_user_ns() == &init_user_ns && !capable(CAP_SETFCAP))
+			return -EPERM;
+		/* for non-init userns we'll check permission later in
+		 * cap_setxattr_make_nscap() */
+		return 0;
+	}
+
+	if (!strcmp(name, XATTR_NAME_NS_CAPS)) {
+		/* only initial userns is allowed to set security.nscapability
+		 * directly.  We could be more flexible, but would need to
+		 * convert the rootid to target ns.  Defer.
+		 */
 		if (!capable(CAP_SETFCAP))
 			return -EPERM;
 		return 0;
@@ -682,12 +907,23 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  */
 int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
+	struct inode *inode = d_backing_inode(dentry);
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
 			return -EPERM;
 		return 0;
 	}
 
+	if (!strcmp(name, XATTR_NAME_NS_CAPS)) {
+		/* do allow root to clear this capability out if they really
+		 * want to */
+		if (!inode)
+			return -EINVAL;
+		if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	}
+
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
 	    !capable(CAP_SYS_ADMIN))
@@ -1078,6 +1314,7 @@ struct security_hook_list capability_hooks[] = {
 	LSM_HOOK_INIT(bprm_secureexec, cap_bprm_secureexec),
 	LSM_HOOK_INIT(inode_need_killpriv, cap_inode_need_killpriv),
 	LSM_HOOK_INIT(inode_killpriv, cap_inode_killpriv),
+	LSM_HOOK_INIT(inode_getsecurity, cap_inode_getsecurity),
 	LSM_HOOK_INIT(mmap_addr, cap_mmap_addr),
 	LSM_HOOK_INIT(mmap_file, cap_mmap_file),
 	LSM_HOOK_INIT(task_fix_setuid, cap_task_fix_setuid),
-- 
2.7.4

