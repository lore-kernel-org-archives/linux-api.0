From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH v2] Introduce v3 namespaced file capabilities
Date: Fri, 28 Apr 2017 23:15:34 -0500
Message-ID: <20170429041534.GA25594@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>
List-Id: linux-api@vger.kernel.org

Root in a non-initial user ns cannot be trusted to write a traditional
security.capability xattr.  If it were allowed to do so, then any
unprivileged user on the host could map his own uid to root in a private
namespace, write the xattr, and execute the file with privilege on the
host.

However supporting file capabilities in a user namespace is very
desirable.  Not doing so means that any programs designed to run with
limited privilege must continue to support other methods of gaining and
dropping privilege.  For instance a program installer must detect
whether file capabilities can be assigned, and assign them if so but set
setuid-root otherwise.  The program in turn must know how to drop
partial capabilities, and do so only if setuid-root.

This patch introduces v3 of the security.capability xattr.  It builds a
vfs_ns_cap_data struct by appending a uid_t rootid to struct
vfs_cap_data.  This is the absolute uid_t (that is, the uid_t in user
namespace which mounted the filesystem, usually init_user_ns) of the
root id in whose namespaces the file capabilities may take effect.

When a task asks to write a v2 security.capability xattr, if it is
privileged with respect to the userns which mounted the filesystem, then
nothing should change.  Otherwise, the kernel will transparently rewrite
the xattr as a v3 with the appropriate rootid.  This is done during the
execution of setxattr() to catch user-space-initiated capability writes.
Subsequently, any task executing the file which has the noted kuid as
its root uid, or which is in a descendent user_ns of such a user_ns,
will run the file with capabilities.

Similarly when asking to read file capabilities, a v3 capability will
be presented as v2 if it applies to the caller's namespace.

If a task writes a v3 security.capability, then it can provide a uid for
the xattr so long as the uid is valid in its own user namespace, and it
is privileged with CAP_SETFCAP over its namespace.  The kernel will
translate that rootid to an absolute uid, and write that to disk.  After
this, a task in the writer's namespace will not be able to use those
capabilities (unless rootid was 0), but a task in a namespace where the
given uid is root will.

Only a single security.capability xattr may exist at a time for a given
file.  A task may overwrite an existing xattr so long as it is
privileged over the inode.  Note this is a departure from previous
semantics, which required privilege to remove a security.capability
xattr.  This check can be re-added if deemed useful.

This allows a simple setxattr to work, allows tar/untar to work, and
allows us to tar in one namespace and untar in another while preserving
the capability, without risking leaking privilege into a parent
namespace.

A patch to linux-test-project adding a new set of tests for this
functionality is in the nsfscaps branch at github.com/hallyn/ltp

Changelog:
   Nov 02 2016: fix invalid check at refuse_fcap_overwrite()
   Nov 07 2016: convert rootid from and to fs user_ns
   (From ebiederm: mar 28 2017)
     commoncap.c: fix typos - s/v4/v3
     get_vfs_caps_from_disk: clarify the fs_ns root access check
     nsfscaps: change the code split for cap_inode_setxattr()
   Apr 09 2017:
       don't return v3 cap for caps owned by current root.
      return a v2 cap for a true v2 cap in non-init ns
   Apr 18 2017:
      . Change the flow of fscap writing to support s_user_ns writing.
      . Remove refuse_fcap_overwrite().  The value of the previous
        xattr doesn't matter.
   Apr 24 2017:
      . incorporate Eric's incremental diff
      . move cap_convert_nscap to setxattr and simplify its usage
---
 fs/xattr.c                      |   6 +
 include/linux/capability.h      |   3 +-
 include/linux/security.h        |   2 +
 include/uapi/linux/capability.h |  22 +++-
 security/commoncap.c            | 269 +++++++++++++++++++++++++++++++++++++---
 5 files changed, 279 insertions(+), 23 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 7e3317c..0a9dea4 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -444,6 +444,12 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
 			posix_acl_fix_xattr_from_user(kvalue, size);
+		else if (strcmp(kname, XATTR_NAME_CAPS) == 0) {
+			error = cap_convert_nscap(d, &kvalue, size);
+			if (error < 0)
+				goto out;
+			size = error;
+		}
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 6ffb67e..a5dcdcf 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -14,7 +14,6 @@
 
 #include <uapi/linux/capability.h>
 
-
 #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
 #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
 
@@ -248,4 +247,6 @@ extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
 /* audit system wants to get cap info from files as well */
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
 
+extern int cap_convert_nscap(struct dentry *dentry, void **value, size_t size);
+
 #endif /* !_LINUX_CAPABILITY_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index 96899fa..bd49cc1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -86,6 +86,8 @@ extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
 extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
+extern int cap_inode_getsecurity(struct inode *inode, const char *name,
+				 void **buffer, bool alloc);
 extern int cap_mmap_addr(unsigned long addr);
 extern int cap_mmap_file(struct file *file, unsigned long reqprot,
 			 unsigned long prot, unsigned long flags);
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 49bc062..fd4f87d 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -60,9 +60,13 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32_2           2
 #define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
 
-#define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
-#define VFS_CAP_U32             VFS_CAP_U32_2
-#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
+#define VFS_CAP_REVISION_3	0x03000000
+#define VFS_CAP_U32_3           2
+#define XATTR_CAPS_SZ_3         (sizeof(__le32)*(2 + 2*VFS_CAP_U32_3))
+
+#define XATTR_CAPS_SZ           XATTR_CAPS_SZ_3
+#define VFS_CAP_U32             VFS_CAP_U32_3
+#define VFS_CAP_REVISION	VFS_CAP_REVISION_3
 
 struct vfs_cap_data {
 	__le32 magic_etc;            /* Little endian */
@@ -72,6 +76,18 @@ struct vfs_cap_data {
 	} data[VFS_CAP_U32];
 };
 
+/*
+ * same as vfs_cap_data but with a rootid at the end
+ */
+struct vfs_ns_cap_data {
+	__le32 magic_etc;
+	struct {
+		__le32 permitted;    /* Little endian */
+		__le32 inheritable;  /* Little endian */
+	} data[VFS_CAP_U32];
+	__le32 rootid;
+};
+
 #ifndef __KERNEL__
 
 /*
diff --git a/security/commoncap.c b/security/commoncap.c
index 78b3783..a1a2935 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -332,6 +332,208 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return error;
 }
 
+static bool rootid_owns_currentns(kuid_t kroot)
+{
+	struct user_namespace *ns;
+
+	if (!uid_valid(kroot))
+		return false;
+
+	for (ns = current_user_ns(); ; ns = ns->parent) {
+		if (from_kuid(ns, kroot) == 0)
+			return true;
+		if (ns == &init_user_ns)
+			break;
+	}
+
+	return false;
+}
+
+static __u32 sansflags(__u32 m)
+{
+	return m & ~VFS_CAP_FLAGS_EFFECTIVE;
+}
+
+static bool is_v2header(size_t size, __le32 magic)
+{
+	__u32 m = le32_to_cpu(magic);
+	if (size != XATTR_CAPS_SZ_2)
+		return false;
+	return sansflags(m) == VFS_CAP_REVISION_2;
+}
+
+static bool is_v3header(size_t size, __le32 magic)
+{
+	__u32 m = le32_to_cpu(magic);
+
+	if (size != XATTR_CAPS_SZ_3)
+		return false;
+	return sansflags(m) == VFS_CAP_REVISION_3;
+}
+
+/*
+ * getsecurity: We are called for security.* before any attempt to read the
+ * xattr from the inode itself.
+ *
+ * This gives us a chance to read the on-disk value and convert it.  If we
+ * return -EOPNOTSUPP, then vfs_getxattr() will call the i_op handler.
+ *
+ * Note we are not called by vfs_getxattr_alloc(), but that is only called
+ * by the integrity subsystem, which really wants the unconverted values -
+ * so that's good.
+ */
+int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
+			  bool alloc)
+{
+	int size, ret;
+	kuid_t kroot;
+	uid_t root, mappedroot;
+	char *tmpbuf = NULL;
+	struct vfs_cap_data *cap;
+	struct vfs_ns_cap_data *nscap;
+	struct dentry *dentry;
+	struct user_namespace *fs_ns;
+
+	if (strcmp(name, "capability") != 0)
+		return -EOPNOTSUPP;
+
+	dentry = d_find_alias(inode);
+	if (!dentry)
+		return -EINVAL;
+
+	size = sizeof(struct vfs_ns_cap_data);
+	ret = vfs_getxattr_alloc(dentry, XATTR_NAME_CAPS,
+				 &tmpbuf, size, GFP_NOFS);
+
+	if (ret < 0)
+		return ret;
+
+	fs_ns = inode->i_sb->s_user_ns;
+	cap = (struct vfs_cap_data *) tmpbuf;
+	if (is_v2header(ret, cap->magic_etc)) {
+		/* If this is sizeof(vfs_cap_data) then we're ok with the
+		 * on-disk value, so return that.  */
+		if (alloc)
+			*buffer = tmpbuf;
+		else
+			kfree(tmpbuf);
+		return ret;
+	} else if (!is_v3header(ret, cap->magic_etc)) {
+		kfree(tmpbuf);
+		return -EINVAL;
+	}
+
+	nscap = (struct vfs_ns_cap_data *) tmpbuf;
+	root = le32_to_cpu(nscap->rootid);
+	kroot = make_kuid(fs_ns, root);
+
+	/* If the root kuid maps to a valid uid in current ns, then return
+	 * this as a nscap. */
+	mappedroot = from_kuid(current_user_ns(), kroot);
+	if (mappedroot != (uid_t)-1 && mappedroot != (uid_t)0) {
+		if (alloc) {
+			*buffer = tmpbuf;
+			nscap->rootid = cpu_to_le32(mappedroot);
+		} else
+			kfree(tmpbuf);
+		return size;
+	}
+
+	if (!rootid_owns_currentns(kroot)) {
+		kfree(tmpbuf);
+		return -EOPNOTSUPP;
+	}
+
+	/* This comes from a parent namespace.  Return as a v2 capability */
+	size = sizeof(struct vfs_cap_data);
+	if (alloc) {
+		*buffer = kmalloc(size, GFP_ATOMIC);
+		if (*buffer) {
+			struct vfs_cap_data *cap = *buffer;
+			__le32 nsmagic, magic;
+			magic = VFS_CAP_REVISION_2;
+			nsmagic = le32_to_cpu(nscap->magic_etc);
+			if (nsmagic & VFS_CAP_FLAGS_EFFECTIVE)
+				magic |= VFS_CAP_FLAGS_EFFECTIVE;
+			memcpy(&cap->data, &nscap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
+			cap->magic_etc = cpu_to_le32(magic);
+		}
+	}
+	kfree(tmpbuf);
+	return size;
+}
+
+static kuid_t rootid_from_xattr(const void *value, size_t size,
+				struct user_namespace *task_ns)
+{
+	const struct vfs_ns_cap_data *nscap = value;
+	uid_t rootid = 0;
+
+	if (size == XATTR_CAPS_SZ_3)
+		rootid = le32_to_cpu(nscap->rootid);
+
+	return make_kuid(task_ns, rootid);
+}
+
+static bool validheader(size_t size, __le32 magic)
+{
+	return is_v2header(size, magic) || is_v3header(size, magic);
+}
+
+/*
+ * User requested a write of security.capability.  If needed, update the
+ * xattr to change from v2 to v3, or to fixup the v3 rootid.
+ *
+ * If all is ok, we return the new size, on error return < 0.
+ */
+int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size)
+{
+	struct vfs_ns_cap_data *nscap;
+	uid_t nsrootid;
+	const struct vfs_cap_data *cap = *ivalue;
+	__u32 magic, nsmagic;
+	struct inode *inode = d_backing_inode(dentry);
+	struct user_namespace *task_ns = current_user_ns(),
+		*fs_ns = inode->i_sb->s_user_ns;
+	kuid_t rootid;
+	size_t newsize;
+
+	if (!*ivalue)
+		return -EINVAL;
+	if (!validheader(size, cap->magic_etc))
+		return -EINVAL;
+	if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
+		return -EPERM;
+	if (size == XATTR_CAPS_SZ_2)
+		if (ns_capable(inode->i_sb->s_user_ns, CAP_SETFCAP))
+			/* user is privileged, just write the v2 */
+			return size;
+
+	rootid = rootid_from_xattr(*ivalue, size, task_ns);
+	if (!uid_valid(rootid))
+		return -EINVAL;
+
+	nsrootid = from_kuid(fs_ns, rootid);
+	if (nsrootid == -1)
+		return -EINVAL;
+
+	newsize = sizeof(struct vfs_ns_cap_data);
+	nscap = kmalloc(newsize, GFP_ATOMIC);
+	if (!nscap)
+		return -ENOMEM;
+	nscap->rootid = cpu_to_le32(nsrootid);
+	nsmagic = VFS_CAP_REVISION_3;
+	magic = le32_to_cpu(cap->magic_etc);
+	if (magic & VFS_CAP_FLAGS_EFFECTIVE)
+		nsmagic |= VFS_CAP_FLAGS_EFFECTIVE;
+	nscap->magic_etc = cpu_to_le32(nsmagic);
+	memcpy(&nscap->data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
+
+	kvfree(*ivalue);
+	*ivalue = nscap;
+	return newsize;
+}
+
 /*
  * Calculate the new process capability sets from the capability sets attached
  * to a file.
@@ -385,7 +587,10 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
 	__u32 magic_etc;
 	unsigned tocopy, i;
 	int size;
-	struct vfs_cap_data caps;
+	struct vfs_ns_cap_data data, *nscaps = &data;
+	struct vfs_cap_data *caps = (struct vfs_cap_data *) &data;
+	kuid_t rootkuid;
+	struct user_namespace *fs_ns = inode->i_sb->s_user_ns;
 
 	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
 
@@ -393,18 +598,20 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
 		return -ENODATA;
 
 	size = __vfs_getxattr((struct dentry *)dentry, inode,
-			      XATTR_NAME_CAPS, &caps, XATTR_CAPS_SZ);
+			      XATTR_NAME_CAPS, &data, XATTR_CAPS_SZ);
 	if (size == -ENODATA || size == -EOPNOTSUPP)
 		/* no data, that's ok */
 		return -ENODATA;
+
 	if (size < 0)
 		return size;
 
 	if (size < sizeof(magic_etc))
 		return -EINVAL;
 
-	cpu_caps->magic_etc = magic_etc = le32_to_cpu(caps.magic_etc);
+	cpu_caps->magic_etc = magic_etc = le32_to_cpu(caps->magic_etc);
 
+	rootkuid = make_kuid(fs_ns, 0);
 	switch (magic_etc & VFS_CAP_REVISION_MASK) {
 	case VFS_CAP_REVISION_1:
 		if (size != XATTR_CAPS_SZ_1)
@@ -416,15 +623,27 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
 			return -EINVAL;
 		tocopy = VFS_CAP_U32_2;
 		break;
+	case VFS_CAP_REVISION_3:
+		if (size != XATTR_CAPS_SZ_3)
+			return -EINVAL;
+		tocopy = VFS_CAP_U32_3;
+		rootkuid = make_kuid(fs_ns, le32_to_cpu(nscaps->rootid));
+		break;
+
 	default:
 		return -EINVAL;
 	}
+	/* Limit the caps to the mounter of the filesystem
+	 * or the more limited uid specified in the xattr.
+	 */
+	if (!rootid_owns_currentns(rootkuid))
+		return -ENODATA;
 
 	CAP_FOR_EACH_U32(i) {
 		if (i >= tocopy)
 			break;
-		cpu_caps->permitted.cap[i] = le32_to_cpu(caps.data[i].permitted);
-		cpu_caps->inheritable.cap[i] = le32_to_cpu(caps.data[i].inheritable);
+		cpu_caps->permitted.cap[i] = le32_to_cpu(caps->data[i].permitted);
+		cpu_caps->inheritable.cap[i] = le32_to_cpu(caps->data[i].inheritable);
 	}
 
 	cpu_caps->permitted.cap[CAP_LAST_U32] &= CAP_LAST_U32_VALID_MASK;
@@ -462,8 +681,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
 	if (rc < 0) {
 		if (rc == -EINVAL)
-			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
-				__func__, rc, bprm->filename);
+			printk(KERN_NOTICE "Invalid argument reading file caps for %s\n",
+					bprm->filename);
 		else if (rc == -ENODATA)
 			rc = 0;
 		goto out;
@@ -660,15 +879,19 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		       const void *value, size_t size, int flags)
 {
-	if (!strcmp(name, XATTR_NAME_CAPS)) {
-		if (!capable(CAP_SETFCAP))
-			return -EPERM;
+	/* Ignore non-security xattrs */
+	if (strncmp(name, XATTR_SECURITY_PREFIX,
+			sizeof(XATTR_SECURITY_PREFIX) - 1) != 0)
+		return 0;
+
+	/*
+	 * For XATTR_NAME_CAPS the check will be done in
+	 * cap_convert_nscap(), called by setxattr()
+	 */
+	if (strcmp(name, XATTR_NAME_CAPS) == 0)
 		return 0;
-	}
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
@@ -686,15 +909,22 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  */
 int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
-	if (!strcmp(name, XATTR_NAME_CAPS)) {
-		if (!capable(CAP_SETFCAP))
+	/* Ignore non-security xattrs */
+	if (strncmp(name, XATTR_SECURITY_PREFIX,
+			sizeof(XATTR_SECURITY_PREFIX) - 1) != 0)
+		return 0;
+
+	if (strcmp(name, XATTR_NAME_CAPS) == 0) {
+		/* security.capability gets namespaced */
+		struct inode *inode = d_backing_inode(dentry);
+		if (!inode)
+			return -EINVAL;
+		if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
 			return -EPERM;
 		return 0;
 	}
 
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
@@ -1082,6 +1312,7 @@ struct security_hook_list capability_hooks[] = {
 	LSM_HOOK_INIT(bprm_secureexec, cap_bprm_secureexec),
 	LSM_HOOK_INIT(inode_need_killpriv, cap_inode_need_killpriv),
 	LSM_HOOK_INIT(inode_killpriv, cap_inode_killpriv),
+	LSM_HOOK_INIT(inode_getsecurity, cap_inode_getsecurity),
 	LSM_HOOK_INIT(mmap_addr, cap_mmap_addr),
 	LSM_HOOK_INIT(mmap_file, cap_mmap_file),
 	LSM_HOOK_INIT(task_fix_setuid, cap_task_fix_setuid),
-- 
2.7.4

