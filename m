From: David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 2/3] inotify: add inotify_update_watch() syscall
Date: Thu,  3 Sep 2015 17:10:26 +0200
Message-ID: <1441293027-3363-3-git-send-email-dh.herrmann@gmail.com>
References: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

The current inotify API only provides a single function to add *and*
modify watch descriptors. There is no way to perform either operation
explicitly, but the kernel always automatically chooses what to do. If
the watch-descriptor exists, it is updated, otherwise a new descriptor is
allocated. This has quite nasty side-effects:

Imagine the case where an application monitors two independent files A
and B with two independent watch descriptors. If you now want to *change*
the watch-mask of A, you have to use inotify_add_watch(fd, "A", new_mask).
However, this might race with a file-system operation that links B over A,
thus this call to inotify_add_watch() will affect the watch-descriptor of
B. However, this is usually not what the caller wants, as the watch-masks
of A and B can be disjoint, and as such an unwanted update of B might
cause event loss. Hence, a call like inotify_update_watch() is needed,
which explicitly takes the watch-descriptor to modify. In this case, it
would still only update the watch-descriptor of A, even though the path
to A changed.

The underlying issue here is the automatism of inotify_add_watch(), which
does not allow the caller to distinguish an update operation from an ADD
operation. This race could be solved with a simple IN_EXCL (or IN_CREATE)
flag, which would cause inotify_add_watch() to *never* update existing
watch-descriptors, but fail with EEXIST instead. However, this still
prevents the caller from *updating* the flags of an explicitly passed
watch-descriptor. Furthermore, the fact that inotify objects identify
*INODES*, but the API takes *PATHS* calls for races. Therefore, we really
need an explicit update operation to allow user-space to modify watch
descriptors without having to re-create them and thus invalidating their
cache.

This patch implements inotify_update_watch() to extend the inotify API
with a way to explicity modify watch-descriptors, instead of going via
the file-system path-API of inotify_add_watch().

SYNOPSIS
    #include <sys/inotify.h>

    int inotify_update_watch(int fd, __u32 wd, __u32 mask);

DESCRIPTION
    inotify_update_watch() modifies an existing inotify watch descriptor,
    specified by 'wd', which was previously added via
    inotify_add_watch(2).  It updates the mask of events to be monitored
    via this watch descriptor according to the event mask specified by
    'mask'. If IN_MASK_ADD is passed, 'mask' is added to the existing set
    of flags on this watch descriptor, otherwise the existing mask is
    replaced by the new mask. See inotify(7) for a description of the
    further bits allowed in 'mask'.

    Flags that modify the file lookup behavior of inotify_add_watch(2)
    (IN_ONLYDIR, IN_DONT_FOLLOW) cannot be passed to
    inotify_update_watch(). They will be rejected with EINVAL.

RETURN VALUE
    On success, 0 is returned.  On error, -1 is returned, and errno is
    set appropriately.

ERRORS
    EBADF       'fd' is not a valid file descriptor.

    EINVAL      'fd' is not an inotify file descriptor; or 'mask' contains
                invalid or unsupported flags.

    ENXIO       'wd' is not a valid watch descriptor on this inotify
                instance.

CONFORMING TO
    This system call is Linux-specific.

SEE ALSO
    inotify(7), inotify_init(2), inotify_add_watch(2), inotify_rm_watch(2)

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl |  1 +
 arch/x86/entry/syscalls/syscall_64.tbl |  1 +
 fs/notify/inotify/inotify_user.c       | 37 ++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h               |  1 +
 kernel/sys_ni.c                        |  1 +
 5 files changed, 41 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index ef8187f..598b6cc 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -365,3 +365,4 @@
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
+359	i386	inotify_update_watch	sys_inotify_update_watch
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 9ef32d5..883a02e 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	inotify_update_watch	sys_inotify_update_watch
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 5a39ae8..1df7312 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -733,6 +733,43 @@ fput_and_out:
 	return ret;
 }
 
+SYSCALL_DEFINE3(inotify_update_watch, int, fd, __s32, wd, __u32, mask)
+{
+	struct inotify_inode_mark *mark;
+	struct fsnotify_group *group;
+	struct fd f;
+	int ret = 0;
+
+	/* disallow unknown flags and flags specific to inode lookup */
+	if (unlikely(mask & (IN_DONT_FOLLOW |
+			     IN_ONLYDIR |
+			     ~ALL_INOTIFY_BITS)))
+		return -EINVAL;
+
+	f = fdget(fd);
+	if (unlikely(!f.file))
+		return -EBADF;
+	if (unlikely(f.file->f_op != &inotify_fops)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	group = f.file->private_data;
+	mark = inotify_idr_find(group, wd);
+	if (unlikely(!mark)) {
+		ret = -ENXIO;
+		goto exit;
+	}
+
+	mutex_lock(&group->mark_mutex);
+	inotify_update_existing_watch(&mark->fsn_mark, mask);
+	mutex_unlock(&group->mark_mutex);
+
+exit:
+	fdput(f);
+	return ret;
+}
+
 SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 {
 	struct fsnotify_group *group;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b45c45b..40701b0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -744,6 +744,7 @@ asmlinkage long sys_inotify_init(void);
 asmlinkage long sys_inotify_init1(int flags);
 asmlinkage long sys_inotify_add_watch(int fd, const char __user *path,
 					u32 mask);
+asmlinkage long sys_inotify_update_watch(int fd, __s32 wd, __u32 mask);
 asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd);
 
 asmlinkage long sys_spu_run(int fd, __u32 __user *unpc,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 7995ef5..b556a33d 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -114,6 +114,7 @@ cond_syscall(compat_sys_socketcall);
 cond_syscall(sys_inotify_init);
 cond_syscall(sys_inotify_init1);
 cond_syscall(sys_inotify_add_watch);
+cond_syscall(sys_inotify_update_watch);
 cond_syscall(sys_inotify_rm_watch);
 cond_syscall(sys_migrate_pages);
 cond_syscall(sys_move_pages);
-- 
2.5.1
