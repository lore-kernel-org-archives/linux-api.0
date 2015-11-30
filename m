From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: [PATCH RFC] Introduce new security.nscapability xattr
Date: Mon, 30 Nov 2015 16:43:56 -0600
Message-ID: <20151130224356.GA27972@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, lxc-devel@lists.linuxcontainers.org, Richard Weinberger <richard@nod.at>, LSM <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

A common way for daemons to run with minimal privilege is to start as root,
perhaps setuid-root, choose a desired capability set, set PR_SET_KEEPCAPS,
then change uid to non-root.  A simpler way to achieve this is to set file
capabilities on a not-setuid-root binary.  However, when installing a package
inside a (user-namespaced) container, packages cannot be installed with file
capabilities.  For this reason, containers must install ping setuid-root.

To achieve this, we would need for containers to be able to request file
capabilities be added to a file without causing these to be honored in the
initial user namespace.

To this end, the patch below introduces a new capability xattr format.  The
main enhancement over the existing security.capability xattr is that we
tag capability sets with a uid - the uid of the root user in the namespace
where the capabilities are set.  The capabilities will be ignored in any
other namespace.  The special case of uid == -1 (which must only ever be
able to be set by kuid 0) means use the capabilities in all namespaces.

An alternative format would use a pair of uids to indicate a range of rootids.
This would allow root in a user namespace with uids 100000-165536 mapped to
set the xattr once on a file, then launch nested containers wherein the file
could be used with privilege.  That's not what this patch does, but would be
a trivial change if people think it would be worthwhile.

This patch does not actually address the real problem, which is setting the
xattrs from inside containers.  For that, I think the best solution is to
add a pair of new system calls, setfcap and getfcap. Userspace would for
instance call fsetfcap(fd, cap_user_header_t, cap_user_data_t), to which
the kernel would, if not in init_user_ns, react by writing an appropriate
security.nscapability xattr.

The libcap2 library's cap_set_file/cap_get_file could be switched over
transparently to use this to hide its use from all callers.

Comments appreciated.

Note - In this patch, file capabilities only work for containers which have
a root uid defined.  We may want to allow -1 uids to work in all
namespaces.  There certainly would be uses for this, but I'm a bit unsettled
about the implications of allowing a program privilege in a container where
there is no uid with privilege.  This needs more thought.

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 include/linux/capability.h      |  15 +++++
 include/uapi/linux/capability.h |  47 ++++++++++++++
 include/uapi/linux/xattr.h      |   3 +
 security/commoncap.c            | 135 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 194 insertions(+), 6 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index af9f0b9..24ac18e 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -13,6 +13,7 @@
 #define _LINUX_CAPABILITY_H
 
 #include <uapi/linux/capability.h>
+#include <linux/uidgid.h>
 
 
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
@@ -31,6 +32,20 @@ struct cpu_vfs_cap_data {
 	kernel_cap_t inheritable;
 };
 
+struct cpu_vfs_ns_cap_data {
+	__u32 flags;
+	kuid_t rootid;
+	kernel_cap_t permitted;
+	kernel_cap_t inheritable;
+};
+
+struct cpu_vfs_ns_cap_header {
+	__u32 hdr_info;
+	struct cpu_vfs_ns_cap_data caps[0];
+};
+#define NS_CAPS_VERSION(x) (x & 0xFF)
+#define NS_CAPS_NCAPS(x) ( (x >> 8) & 0xFF )
+
 #define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 12c37a1..2211a33 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -62,10 +62,14 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32_2           2
 #define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
 
+/* version number for security.nscapability xattrs hdr->hdr_info */
+#define VFS_NS_CAP_REVISION     1
+
 #define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
+
 struct vfs_cap_data {
 	__le32 magic_etc;            /* Little endian */
 	struct {
@@ -74,6 +78,49 @@ struct vfs_cap_data {
 	} data[VFS_CAP_U32];
 };
 
+/*
+ * Q: do we want version in the header, or in the data?
+ * If it is in the header, then a container will need to
+ * make sure it is writing the same data.
+ *
+ * Actually, perhaps we simply do not support writing the
+ * xattr, we just use a new system call to get/set the fscap.
+ * The kernel can be in charge of watching the version numbers.
+ * After all, we can't allow the container to override the
+ * fscaps of the init ns.
+ *
+ * @flags currently only containers the effective bit.  The
+ * other bits are reserved, and must be 0 at the moment.
+ * @rootid contains the kuid value of the root in the namespace
+ * for which this capability should be used.  If -1, then this
+ * works for all namespaces.  Only root in the initial ns can
+ * use this.
+ *
+ * Q: do we want to use a range instead?  Then root in a container
+ * could allow one binary with one capability to be used by any
+ * nested containers.
+ */
+#define VFS_NS_CAP_EFFECTIVE    0x1
+struct vfs_ns_cap_data {
+	__le32 flags;
+	__le32 rootid;
+	struct {
+		__le32 permitted;    /* Little endian */
+		__le32 inheritable;  /* Little endian */
+	} data[VFS_CAP_U32];
+};
+
+/*
+ * 32-bit hdr_info contains
+ * 16 leftmost: reserved
+ * next 8: ncaps
+ * last 8: version
+ */
+struct vfs_ns_cap_header {
+	__le32 hdr_info;
+	/* ncaps * vfs_ns_cap_data */
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
index 1832cf7..c44edf3 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -308,6 +308,10 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 	if (!inode->i_op->getxattr)
 	       return 0;
 
+	error = inode->i_op->getxattr(dentry, XATTR_NAME_NS_CAPS, NULL, 0);
+	if (error > 0)
+		return 1;
+
 	error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
 	if (error <= 0)
 		return 0;
@@ -325,11 +329,17 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 int cap_inode_killpriv(struct dentry *dentry)
 {
 	struct inode *inode = d_backing_inode(dentry);
+	int ret1, ret2;;
 
 	if (!inode->i_op->removexattr)
 	       return 0;
 
-	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+	ret1 = inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+	ret2 = inode->i_op->removexattr(dentry, XATTR_NAME_NS_CAPS);
+
+	if (ret1 != 0)
+		return ret1;
+	return ret2;
 }
 
 /*
@@ -433,6 +443,117 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
 	return 0;
 }
 
+int get_vfs_ns_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	unsigned tocopy, i;
+	int ret = 0, size, expected;
+	unsigned len = 0;
+	struct vfs_ns_cap_header *hdr;
+	struct vfs_ns_cap_data *cap, *nscap = NULL;
+	__u16 ncaps, version;
+	__u32 hdr_info;
+	kuid_t current_root, caprootuid;
+
+	memset(cpu_caps, 0, sizeof(*cpu_caps));
+
+	if (!inode || !inode->i_op->getxattr)
+		return -ENODATA;
+
+	/* get the size */
+	size = inode->i_op->getxattr((struct dentry *)dentry, XATTR_NAME_NS_CAPS,
+			NULL, 0);
+	if (size == -ENODATA || size == -EOPNOTSUPP)
+		/* no data, that's ok */
+		return -ENODATA;
+	if (size < 0)
+		return size;
+	if (size < sizeof(struct cpu_vfs_ns_cap_header))
+		return -EINVAL;
+	if (size > sizeof(struct cpu_vfs_ns_cap_header) + 255 * sizeof(struct vfs_ns_cap_data))
+		return -EINVAL;
+	len = size;
+
+	hdr = kmalloc(len + 1, GFP_NOFS);
+	if (!hdr)
+		return -ENOMEM;
+
+	size = inode->i_op->getxattr((struct dentry *)dentry, XATTR_NAME_NS_CAPS, hdr,
+				   len);
+	if (size < 0) {
+		ret = size;
+		goto out;
+	}
+
+	if (size != len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	hdr_info = le32_to_cpu(hdr->hdr_info);
+	version = NS_CAPS_VERSION(hdr_info);
+	ncaps = NS_CAPS_NCAPS(hdr_info);
+
+	if (version != VFS_NS_CAP_REVISION) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	expected = sizeof(*hdr) + ncaps * sizeof(*cap);
+	if (size != expected) {
+		ret = -EINVAL;
+		goto out;
+	}
+	tocopy = VFS_CAP_U32;
+
+	/* find an applicable entry */
+	/* a global entry (uid == -1) takes precedence */
+	current_root = make_kuid(current_user_ns(), 0);
+	if (!uid_valid(current_root)) {
+		/* no root user in this namespace;  no capabilities */
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0, cap = (void *) hdr + sizeof(*hdr); i < ncaps; cap += sizeof(*cap), i++) {
+		uid_t uid = le32_to_cpu(cap->rootid);
+		if (uid == -1) {
+			nscap = cap;
+			break;
+		}
+
+		caprootuid = make_kuid(&init_user_ns, uid);
+		if (uid_eq(caprootuid, current_root))
+			nscap = cap;
+	}
+
+	if (!nscap) {
+		/* nothing found for this namespace */
+		ret = -ENODATA;
+		goto out;
+	}
+
+	/* copy the entry */
+	CAP_FOR_EACH_U32(i) {
+		if (i >= tocopy)
+			break;
+		cpu_caps->permitted.cap[i] = le32_to_cpu(nscap->data[i].permitted);
+		cpu_caps->inheritable.cap[i] = le32_to_cpu(nscap->data[i].inheritable);
+	}
+
+	cpu_caps->permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
+	cpu_caps->inheritable.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
+
+	cpu_caps->magic_etc = VFS_CAP_REVISION_2;
+	if (nscap->flags & VFS_NS_CAP_EFFECTIVE)
+		cpu_caps->magic_etc |= VFS_CAP_FLAGS_EFFECTIVE;
+
+out:
+	kfree(hdr);
+
+	return ret;
+}
+
 /*
  * Attempt to get the on-exec apply capability sets for an executable file from
  * its xattrs and, if present, apply them to the proposed credentials being
@@ -451,11 +572,13 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
 		return 0;
 
-	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
+	rc = get_vfs_ns_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
+	if (rc == -ENODATA)
+		rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
 	if (rc < 0) {
 		if (rc == -EINVAL)
-			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
-				__func__, rc, bprm->filename);
+			printk(KERN_NOTICE "Got EINVAL reading file caps for %s\n",
+				bprm->filename);
 		else if (rc == -ENODATA)
 			rc = 0;
 		goto out;
@@ -651,7 +774,7 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		       const void *value, size_t size, int flags)
 {
-	if (!strcmp(name, XATTR_NAME_CAPS)) {
+	if (!strcmp(name, XATTR_NAME_CAPS) || !strcmp(name, XATTR_NAME_NS_CAPS)) {
 		if (!capable(CAP_SETFCAP))
 			return -EPERM;
 		return 0;
@@ -677,7 +800,7 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  */
 int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
-	if (!strcmp(name, XATTR_NAME_CAPS)) {
+	if (!strcmp(name, XATTR_NAME_CAPS) || !strcmp(name, XATTR_NAME_NS_CAPS)) {
 		if (!capable(CAP_SETFCAP))
 			return -EPERM;
 		return 0;
-- 
2.5.0

