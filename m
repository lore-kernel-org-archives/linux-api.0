From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/11] capsicum: convert callers to use fgetr() etc
Date: Fri, 25 Jul 2014 14:47:01 +0100
Message-ID: <1406296033-32693-6-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Convert places that use fget()-like functions to use the
equivalent fgetr() variant instead.

Annotate each such call with an indication of what operations will
be performed on the retrieved struct file, to allow future policing
of rights associated with file descriptors.

Also change each call site to cope with an ERR_PTR return from
fgetr() rather than a plain NULL failure from fget().

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/alpha/kernel/osf_sys.c                     |   6 +-
 arch/ia64/kernel/perfmon.c                      |  54 +++++++-----
 arch/parisc/hpux/fs.c                           |   6 +-
 arch/powerpc/kvm/powerpc.c                      |   4 +-
 arch/powerpc/platforms/cell/spu_syscalls.c      |  15 ++--
 drivers/base/dma-buf.c                          |   6 +-
 drivers/block/loop.c                            |  14 +--
 drivers/block/nbd.c                             |   2 +-
 drivers/infiniband/core/ucma.c                  |   4 +-
 drivers/infiniband/core/uverbs_cmd.c            |   6 +-
 drivers/infiniband/core/uverbs_main.c           |   4 +-
 drivers/infiniband/hw/usnic/usnic_transport.c   |   2 +-
 drivers/md/md.c                                 |   8 +-
 drivers/staging/android/sync.c                  |   2 +-
 drivers/staging/lustre/lustre/llite/file.c      |   6 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c     |   7 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c   |   7 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c |   4 +-
 drivers/vfio/pci/vfio_pci.c                     |   7 +-
 drivers/vfio/pci/vfio_pci_intrs.c               |   6 +-
 drivers/vfio/vfio.c                             |   6 +-
 drivers/vhost/net.c                             |   6 +-
 drivers/video/fbdev/msm/mdp.c                   |   5 +-
 fs/aio.c                                        |  37 +++++++-
 fs/autofs4/dev-ioctl.c                          |  17 ++--
 fs/autofs4/inode.c                              |   4 +-
 fs/btrfs/ioctl.c                                |  21 +++--
 fs/btrfs/send.c                                 |   7 +-
 fs/cifs/ioctl.c                                 |   6 +-
 fs/coda/inode.c                                 |   4 +-
 fs/coda/psdev.c                                 |   2 +-
 fs/compat.c                                     |  18 ++--
 fs/compat_ioctl.c                               |  14 ++-
 fs/eventfd.c                                    |  18 ++--
 fs/eventpoll.c                                  |  19 +++--
 fs/ext4/ioctl.c                                 |   6 +-
 fs/fcntl.c                                      | 101 ++++++++++++++++++++--
 fs/fhandle.c                                    |   7 +-
 fs/fuse/inode.c                                 |  10 ++-
 fs/ioctl.c                                      |  12 ++-
 fs/locks.c                                      |   8 +-
 fs/notify/fanotify/fanotify_user.c              |  16 ++--
 fs/notify/inotify/inotify_user.c                |  12 +--
 fs/ocfs2/cluster/heartbeat.c                    |   8 +-
 fs/open.c                                       |  42 +++++----
 fs/proc/namespaces.c                            |   6 +-
 fs/read_write.c                                 | 109 ++++++++++++++----------
 fs/readdir.c                                    |  18 ++--
 fs/select.c                                     |  11 ++-
 fs/signalfd.c                                   |   7 +-
 fs/splice.c                                     |  35 +++++---
 fs/stat.c                                       |  10 ++-
 fs/statfs.c                                     |   9 +-
 fs/sync.c                                       |  21 +++--
 fs/timerfd.c                                    |  40 +++++++--
 fs/utimes.c                                     |  10 ++-
 fs/xattr.c                                      |  26 +++---
 fs/xfs/xfs_ioctl.c                              |  14 +--
 ipc/mqueue.c                                    |  30 +++----
 kernel/events/core.c                            |  15 ++--
 kernel/module.c                                 |  10 ++-
 kernel/sys.c                                    |   6 +-
 kernel/taskstats.c                              |   4 +-
 kernel/time/posix-clock.c                       |  27 +++---
 mm/fadvise.c                                    |   7 +-
 mm/internal.h                                   |  19 +++++
 mm/memcontrol.c                                 |  12 +--
 mm/mmap.c                                       |   7 +-
 mm/nommu.c                                      |  10 ++-
 mm/readahead.c                                  |   6 +-
 net/9p/trans_fd.c                               |  10 +--
 sound/core/pcm_native.c                         |  10 ++-
 virt/kvm/eventfd.c                              |   6 +-
 virt/kvm/vfio.c                                 |  12 +--
 74 files changed, 698 insertions(+), 385 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 1402fcc11c2c..8f2d9597096b 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -146,7 +146,7 @@ SYSCALL_DEFINE4(osf_getdirentries, unsigned int, fd,
 		long __user *, basep)
 {
 	int error;
-	struct fd arg = fdget(fd);
+	struct fd arg = fdgetr(fd, CAP_READ);
 	struct osf_dirent_callback buf = {
 		.ctx.actor = osf_filldir,
 		.dirent = dirent,
@@ -154,8 +154,8 @@ SYSCALL_DEFINE4(osf_getdirentries, unsigned int, fd,
 		.count = count
 	};
 
-	if (!arg.file)
-		return -EBADF;
+	if (IS_ERR(arg.file))
+		return PTR_ERR(arg.file);
 
 	error = iterate_dir(arg.file, &buf.ctx);
 	if (error >= 0)
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 5845ffea67c3..2c214b4ddea0 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -471,6 +471,7 @@ typedef struct {
 	int		cmd_flags;
 	unsigned int	cmd_narg;
 	size_t		cmd_argsize;
+	u64		cmd_right;
 	int		(*cmd_getsize)(void *arg, size_t *sz);
 } pfm_cmd_desc_t;
 
@@ -4620,31 +4621,40 @@ pfm_exit_thread(struct task_struct *task)
 /*
  * functions MUST be listed in the increasing order of their index (see permfon.h)
  */
-#define PFM_CMD(name, flags, arg_count, arg_type, getsz) { name, #name, flags, arg_count, sizeof(arg_type), getsz }
-#define PFM_CMD_S(name, flags) { name, #name, flags, 0, 0, NULL }
+#define PFM_CMD(name, flags, arg_count, arg_type, right, getsz) \
+	{ name, #name, flags, arg_count, sizeof(arg_type), right, getsz }
+#define PFM_CMD_S(name, flags, right) \
+	{ name, #name, flags, 0, 0, right, NULL }
 #define PFM_CMD_PCLRWS	(PFM_CMD_FD|PFM_CMD_ARG_RW|PFM_CMD_STOP)
 #define PFM_CMD_PCLRW	(PFM_CMD_FD|PFM_CMD_ARG_RW)
-#define PFM_CMD_NONE	{ NULL, "no-cmd", 0, 0, 0, NULL}
+#define PFM_CMD_NONE	{ NULL, "no-cmd", 0, 0, 0, 0, NULL}
 
 static pfm_cmd_desc_t pfm_cmd_tab[]={
 /* 0  */PFM_CMD_NONE,
-/* 1  */PFM_CMD(pfm_write_pmcs, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_reg_t, NULL),
-/* 2  */PFM_CMD(pfm_write_pmds, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_reg_t, NULL),
-/* 3  */PFM_CMD(pfm_read_pmds, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_reg_t, NULL),
-/* 4  */PFM_CMD_S(pfm_stop, PFM_CMD_PCLRWS),
-/* 5  */PFM_CMD_S(pfm_start, PFM_CMD_PCLRWS),
+/* 1  */PFM_CMD(pfm_write_pmcs, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_reg_t,
+		CAP_WRITE, NULL),
+/* 2  */PFM_CMD(pfm_write_pmds, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_reg_t,
+		CAP_WRITE, NULL),
+/* 3  */PFM_CMD(pfm_read_pmds, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_reg_t,
+		CAP_READ, NULL),
+/* 4  */PFM_CMD_S(pfm_stop, PFM_CMD_PCLRWS, CAP_PERFMON),
+/* 5  */PFM_CMD_S(pfm_start, PFM_CMD_PCLRWS, CAP_PERFMON),
 /* 6  */PFM_CMD_NONE,
 /* 7  */PFM_CMD_NONE,
-/* 8  */PFM_CMD(pfm_context_create, PFM_CMD_ARG_RW, 1, pfarg_context_t, pfm_ctx_getsize),
+/* 8  */PFM_CMD(pfm_context_create, PFM_CMD_ARG_RW, 1, pfarg_context_t,
+		CAP_PERFMON, pfm_ctx_getsize),
 /* 9  */PFM_CMD_NONE,
-/* 10 */PFM_CMD_S(pfm_restart, PFM_CMD_PCLRW),
+/* 10 */PFM_CMD_S(pfm_restart, PFM_CMD_PCLRW, CAP_PERFMON),
 /* 11 */PFM_CMD_NONE,
-/* 12 */PFM_CMD(pfm_get_features, PFM_CMD_ARG_RW, 1, pfarg_features_t, NULL),
-/* 13 */PFM_CMD(pfm_debug, 0, 1, unsigned int, NULL),
+/* 12 */PFM_CMD(pfm_get_features, PFM_CMD_ARG_RW, 1, pfarg_features_t,
+		CAP_READ, NULL),
+/* 13 */PFM_CMD(pfm_debug, 0, 1, unsigned int, CAP_PERFMON, NULL),
 /* 14 */PFM_CMD_NONE,
-/* 15 */PFM_CMD(pfm_get_pmc_reset, PFM_CMD_ARG_RW, PFM_CMD_ARG_MANY, pfarg_reg_t, NULL),
-/* 16 */PFM_CMD(pfm_context_load, PFM_CMD_PCLRWS, 1, pfarg_load_t, NULL),
-/* 17 */PFM_CMD_S(pfm_context_unload, PFM_CMD_PCLRWS),
+/* 15 */PFM_CMD(pfm_get_pmc_reset, PFM_CMD_ARG_RW, PFM_CMD_ARG_MANY,
+		pfarg_reg_t, CAP_READ, NULL),
+/* 16 */PFM_CMD(pfm_context_load, PFM_CMD_PCLRWS, 1, pfarg_load_t,
+		CAP_READ, NULL),
+/* 17 */PFM_CMD_S(pfm_context_unload, PFM_CMD_PCLRWS, CAP_READ),
 /* 18 */PFM_CMD_NONE,
 /* 19 */PFM_CMD_NONE,
 /* 20 */PFM_CMD_NONE,
@@ -4659,8 +4669,10 @@ static pfm_cmd_desc_t pfm_cmd_tab[]={
 /* 29 */PFM_CMD_NONE,
 /* 30 */PFM_CMD_NONE,
 /* 31 */PFM_CMD_NONE,
-/* 32 */PFM_CMD(pfm_write_ibrs, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_dbreg_t, NULL),
-/* 33 */PFM_CMD(pfm_write_dbrs, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_dbreg_t, NULL)
+/* 32 */PFM_CMD(pfm_write_ibrs, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_dbreg_t,
+		CAP_WRITE, NULL),
+/* 33 */PFM_CMD(pfm_write_dbrs, PFM_CMD_PCLRWS, PFM_CMD_ARG_MANY, pfarg_dbreg_t,
+		CAP_WRITE, NULL)
 };
 #define PFM_CMD_COUNT	(sizeof(pfm_cmd_tab)/sizeof(pfm_cmd_desc_t))
 
@@ -4866,13 +4878,13 @@ restart_args:
 
 	if (unlikely((cmd_flags & PFM_CMD_FD) == 0)) goto skip_fd;
 
-	ret = -EBADF;
-
-	f = fdget(fd);
-	if (unlikely(f.file == NULL)) {
+	f = fdgetr(fd, pfm_cmd_tab[cmd].cmd_right);
+	if (unlikely(IS_ERR(f.file)) {
 		DPRINT(("invalid fd %d\n", fd));
+		ret = PTR_ERR(f.file);
 		goto error_args;
 	}
+	ret = -EBADF;
 	if (unlikely(PFM_IS_FILE(f.file) == 0)) {
 		DPRINT(("fd %d not related to perfmon\n", fd));
 		goto error_args;
diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 2bedafea3d94..8a48b5d4bb15 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -105,9 +105,9 @@ int hpux_getdents(unsigned int fd, struct hpux_dirent __user *dirent, unsigned i
 	};
 	int error;
 
-	arg = fdget(fd);
-	if (!arg.file)
-		return -EBADF;
+	arg = fdgetr(fd, CAP_READ);
+	if (IS_ERR(arg.file))
+		return PTR_ERR(arg.file);
 
 	error = iterate_dir(arg.file, &buf.ctx);
 	if (error >= 0)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 61c738ab1283..39aa7a9f573e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -933,7 +933,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		struct kvm_device *dev;
 
 		r = -EBADF;
-		f = fdget(cap->args[0]);
+		f = fdgetr(cap->args[0], CAP_FSTAT);
 		if (!f.file)
 			break;
 
@@ -952,7 +952,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		struct kvm_device *dev;
 
 		r = -EBADF;
-		f = fdget(cap->args[0]);
+		f = fdgetr(cap->args[0], CAP_FSTAT);
 		if (!f.file)
 			break;
 
diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index 5e6e0bad6db6..6c3f10603c0f 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -77,11 +77,13 @@ SYSCALL_DEFINE4(spu_create, const char __user *, name, unsigned int, flags,
 		return -ENOSYS;
 
 	if (flags & SPU_CREATE_AFFINITY_SPU) {
-		struct fd neighbor = fdget(neighbor_fd);
-		ret = -EBADF;
-		if (neighbor.file) {
+		struct fd neighbor = fdgetr(neighbor_fd, CAP_READ, CAP_WRITE,
+					    CAP_MAPEXEC);
+		if (!IS_ERR(neighbor.file)) {
 			ret = calls->create_thread(name, flags, mode, neighbor.file);
 			fdput(neighbor);
+		} else {
+			ret = PTR_ERR(neighbor.file);
 		}
 	} else
 		ret = calls->create_thread(name, flags, mode, NULL);
@@ -100,11 +102,12 @@ asmlinkage long sys_spu_run(int fd, __u32 __user *unpc, __u32 __user *ustatus)
 	if (!calls)
 		return -ENOSYS;
 
-	ret = -EBADF;
-	arg = fdget(fd);
-	if (arg.file) {
+	arg = fdgetr(fd, CAP_READ, CAP_WRITE, CAP_MAPEXEC);
+	if (!IS_ERR(arg.file)) {
 		ret = calls->spu_run(arg.file, unpc, ustatus);
 		fdput(arg);
+	} else {
+		ret = PTR_ERR(arg.file);
 	}
 
 	spufs_calls_put(calls);
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 840c7fa80983..0e1cea1498ec 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -216,10 +216,10 @@ struct dma_buf *dma_buf_get(int fd)
 {
 	struct file *file;
 
-	file = fget(fd);
+	file = fgetr(fd, CAP_MMAP, CAP_READ, CAP_WRITE);
 
-	if (!file)
-		return ERR_PTR(-EBADF);
+	if (IS_ERR(file))
+		return (struct dma_buf *)file;
 
 	if (!is_dma_buf_file(file)) {
 		fput(file);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6cb1beb47c25..b589b8c4d2e9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -652,10 +652,11 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	if (!(lo->lo_flags & LO_FLAGS_READ_ONLY))
 		goto out;
 
-	error = -EBADF;
-	file = fget(arg);
-	if (!file)
+	file = fgetr(arg, CAP_PWRITE, CAP_PREAD, CAP_FSYNC, CAP_FSTAT);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
 		goto out;
+	}
 
 	inode = file->f_mapping->host;
 	old_file = lo->lo_backing_file;
@@ -834,10 +835,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	/* This is safe, since we have a reference from open(). */
 	__module_get(THIS_MODULE);
 
-	error = -EBADF;
-	file = fget(arg);
-	if (!file)
+	file = fgetr(arg, CAP_PWRITE, CAP_PREAD, CAP_FSYNC, CAP_FSTAT);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
 		goto out;
+	}
 
 	error = -EBUSY;
 	if (lo->lo_state != Lo_unbound)
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fb31b8ee4372..08381e2049b6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -651,7 +651,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 			nbd->disconnect = 0; /* we're connected now */
 			return 0;
 		}
-		return -EINVAL;
+		return err;
 	}
 
 	case NBD_SET_BLKSIZE:
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 56a4b7ca7ee3..b3b0b1aea8aa 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1406,8 +1406,8 @@ static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 		return -EFAULT;
 
 	/* Get current fd to protect against it being closed */
-	f = fdget(cmd.fd);
-	if (!f.file)
+	f = fdgetr(cmd.fd, CAP_READ, CAP_WRITE, CAP_POLL_EVENT);
+	if (IS_ERR(f.file))
 		return -ENOENT;
 
 	/* Validate current fd and prevent destruction of id. */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203ee7bcc..06db7ca75e1f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -719,9 +719,9 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	if (cmd.fd != -1) {
 		/* search for file descriptor */
-		f = fdget(cmd.fd);
-		if (!f.file) {
-			ret = -EBADF;
+		f = fdgetr(cmd.fd, CAP_FSTAT);
+		if (IS_ERR(f.file)) {
+			ret = PTR_ERR(f.file);
 			goto err_tree_mutex_unlock;
 		}
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 08219fb3338b..edaf0693ab12 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -566,9 +566,9 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd)
 {
 	struct ib_uverbs_event_file *ev_file = NULL;
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_LIST_END);
 
-	if (!f.file)
+	if (IS_ERR(f.file))
 		return NULL;
 
 	if (f.file->f_op != &uverbs_event_fops)
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index ddef6f77a78c..5e2265792b83 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -134,7 +134,7 @@ struct socket *usnic_transport_get_socket(int sock_fd)
 	char buf[25];
 
 	/* sockfd_lookup will internally do a fget */
-	sock = sockfd_lookup(sock_fd, &err);
+	sock = sockfd_lookupr(sock_fd, &err, CAP_SOCK_SERVER);
 	if (!sock) {
 		usnic_err("Unable to lookup socket for fd %d with err %d\n",
 				sock_fd, err);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 32fc19c540d4..aa031d9d3d06 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5973,12 +5973,14 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		struct inode *inode;
 		if (mddev->bitmap)
 			return -EEXIST; /* cannot add when bitmap is present */
-		mddev->bitmap_info.file = fget(fd);
+		mddev->bitmap_info.file = fgetr(fd, CAP_READ);
 
-		if (mddev->bitmap_info.file == NULL) {
+		if (IS_ERR(mddev->bitmap_info.file)) {
+			err = PTR_ERR(mddev->bitmap_info.file);
+			mddev->bitmap_info.file = NULL;
 			printk(KERN_ERR "%s: error: failed to get bitmap file\n",
 			       mdname(mddev));
-			return -EBADF;
+			return err;
 		}
 
 		inode = mddev->bitmap_info.file->f_mapping->host;
diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 18174f7c871c..cdc4b935de35 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -406,7 +406,7 @@ static void sync_fence_free_pts(struct sync_fence *fence)
 
 struct sync_fence *sync_fence_fdget(int fd)
 {
-	struct file *file = fget(fd);
+	struct file *file = fgetr(fd, CAP_IOCTL);
 
 	if (file == NULL)
 		return NULL;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 716e1ee0104f..76ab1a7bc335 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2186,9 +2186,9 @@ ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if ((file->f_flags & O_ACCMODE) == 0) /* O_RDONLY */
 			return -EPERM;
 
-		file2 = fget(lsl.sl_fd);
-		if (file2 == NULL)
-			return -EBADF;
+		file2 = fgetr(lsl.sl_fd, CAP_FSTAT);
+		if (IS_ERR(file2))
+			return PTR_ERR(file2);
 
 		rc = -EPERM;
 		if ((file2->f_flags & O_ACCMODE) != 0) /* O_WRONLY or O_RDWR */
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 4edf8a31221c..3dd88ece2608 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -880,10 +880,9 @@ static int lmv_hsm_ct_register(struct lmv_obd *lmv, unsigned int cmd, int len,
 		return -ENOTCONN;
 
 	/* at least one registration done, with no failure */
-	filp = fget(lk->lk_wfd);
-	if (filp == NULL) {
-		return -EBADF;
-	}
+	filp = fgetr(lk->lk_wfd, CAP_READ);
+	if (IS_ERR(filp))
+		return PTR_ERR(filp);
 	rc = libcfs_kkuc_group_add(filp, lk->lk_uid, lk->lk_group, lk->lk_data);
 	if (rc != 0 && filp != NULL)
 		fput(filp);
diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index 2663480a68c5..c30fd463b5e3 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -130,9 +130,12 @@ static ssize_t mdc_kuc_write(struct file *file, const char *buffer,
 	if (fd == 0) {
 		rc = libcfs_kkuc_group_put(KUC_GRP_HSM, lh);
 	} else {
-		struct file *fp = fget(fd);
+		struct file *fp = fgetr(fd, CAP_WRITE);
 
-		rc = libcfs_kkuc_msg_put(fp, lh);
+		if (IS_ERR(fp))
+			rc = PTR_ERR(fp);
+		else
+			rc = libcfs_kkuc_msg_put(fp, lh);
 		fput(fp);
 	}
 	OBD_FREE(lh, len);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index fca43cf1d671..1cd4b9e89619 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1606,7 +1606,9 @@ static int mdc_ioc_changelog_send(struct obd_device *obd,
 	cs->cs_obd = obd;
 	cs->cs_startrec = icc->icc_recno;
 	/* matching fput in mdc_changelog_send_thread */
-	cs->cs_fp = fget(icc->icc_id);
+	cs->cs_fp = fgetr(icc->icc_id, CAP_WRITE);
+	if (IS_ERR(cs->cs_fp))
+		cs->cs_fp = NULL;
 	cs->cs_flags = icc->icc_flags;
 
 	/*
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 010e0f8b8e4f..b264a0a947bc 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -638,9 +638,10 @@ reset_info_exit:
 		 */
 		for (i = 0; i < hdr.count; i++) {
 			struct vfio_group *group;
-			struct fd f = fdget(group_fds[i]);
-			if (!f.file) {
-				ret = -EBADF;
+			struct fd f = fdgetr(group_fds[i], CAP_FSTAT);
+
+			if (IS_ERR(f.file)) {
+				ret = PTR_ERR(f.file);
 				break;
 			}
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9dd49c9839ac..4591feea9004 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -149,9 +149,9 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
 	INIT_WORK(&virqfd->inject, virqfd_inject);
 
-	irqfd = fdget(fd);
-	if (!irqfd.file) {
-		ret = -EBADF;
+	irqfd = fdgetr(fd, CAP_WRITE);
+	if (IS_ERR(irqfd.file)) {
+		ret = PTR_ERR(irqfd.file);
 		goto err_fd;
 	}
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index f018d8d0f975..02cc422c19ef 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1036,9 +1036,9 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	if (atomic_read(&group->container_users))
 		return -EINVAL;
 
-	f = fdget(container_fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(container_fd, CAP_LIST_END);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	/* Sanity check, is this really our fd? */
 	if (f.file->f_op != &vfio_fops) {
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 8dae2f724a35..8f552d2b637e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -871,11 +871,11 @@ err:
 
 static struct socket *get_tap_socket(int fd)
 {
-	struct file *file = fget(fd);
+	struct file *file = fgetr(fd, CAP_READ, CAP_WRITE);
 	struct socket *sock;
 
-	if (!file)
-		return ERR_PTR(-EBADF);
+	if (IS_ERR(file))
+		return ERR_PTR(PTR_ERR(file));
 	sock = tun_get_socket(file);
 	if (!IS_ERR(sock))
 		return sock;
diff --git a/drivers/video/fbdev/msm/mdp.c b/drivers/video/fbdev/msm/mdp.c
index 113c7876c855..90c2c7f2c6c4 100644
--- a/drivers/video/fbdev/msm/mdp.c
+++ b/drivers/video/fbdev/msm/mdp.c
@@ -257,8 +257,9 @@ int get_img(struct mdp_img *img, struct fb_info *info,
 	    struct file **filep)
 {
 	int ret = 0;
-	struct fd f = fdget(img->memory_id);
-	if (f.file == NULL)
+	struct fd f = fdgetr(img->memory_id, CAP_FSTAT);
+
+	if (IS_ERR(f.file))
 		return -1;
 
 	if (MAJOR(file_inode(f.file)->i_rdev) == FB_MAJOR) {
diff --git a/fs/aio.c b/fs/aio.c
index 955947ef3e02..d69f35e49784 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1404,10 +1404,38 @@ rw_common:
 	return 0;
 }
 
+static struct capsicum_rights *
+aio_opcode_rights(struct capsicum_rights *rights, int opcode)
+{
+	switch (opcode) {
+	case IOCB_CMD_PREAD:
+	case IOCB_CMD_PREADV:
+		cap_rights_init(rights, CAP_PREAD);
+		break;
+
+	case IOCB_CMD_PWRITE:
+	case IOCB_CMD_PWRITEV:
+		cap_rights_init(rights, CAP_PWRITE);
+		break;
+
+	case IOCB_CMD_FSYNC:
+	case IOCB_CMD_FDSYNC:
+		cap_rights_init(rights, CAP_FSYNC);
+		break;
+
+	default:
+		cap_rights_init(rights, CAP_PREAD, CAP_PWRITE, CAP_POLL_EVENT,
+				CAP_FSYNC);
+		break;
+	}
+	return rights;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
 	struct kiocb *req;
+	struct capsicum_rights rights;
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
@@ -1430,9 +1458,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	if (unlikely(!req))
 		return -EAGAIN;
 
-	req->ki_filp = fget(iocb->aio_fildes);
-	if (unlikely(!req->ki_filp)) {
-		ret = -EBADF;
+	req->ki_filp = fget_rights(iocb->aio_fildes,
+				   aio_opcode_rights(&rights,
+						     iocb->aio_lio_opcode));
+	if (unlikely(IS_ERR(req->ki_filp))) {
+		ret = PTR_ERR(req->ki_filp);
+		req->ki_filp = NULL;
 		goto out_put_req;
 	}
 
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 5b570b6efa28..0d08289a1b79 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -371,9 +371,9 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 			goto out;
 		}
 
-		pipe = fget(pipefd);
-		if (!pipe) {
-			err = -EBADF;
+		pipe = fgetr(pipefd, CAP_READ, CAP_WRITE, CAP_FSYNC);
+		if (IS_ERR(pipe)) {
+			err = PTR_ERR(pipe);
 			goto out;
 		}
 		if (autofs_prepare_pipe(pipe) < 0) {
@@ -665,11 +665,16 @@ static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __use
 	 */
 	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
 	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
-		fp = fget(param->ioctlfd);
-		if (!fp) {
+		struct capsicum_rights rights;
+
+		cap_rights_init(&rights, CAP_IOCTL, CAP_FSTAT);
+		rights.nioctls = 1;
+		rights.ioctls = &cmd;
+		fp = fget_rights(param->ioctlfd, &rights);
+		if (IS_ERR(fp)) {
 			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
 				goto cont;
-			err = -EBADF;
+			err = PTR_ERR(fp);
 			goto out;
 		}
 
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 1c55388ae633..5330ef636410 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -305,9 +305,9 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
 	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
-	pipe = fget(pipefd);
+	pipe = fgetr(pipefd, CAP_WRITE, CAP_FSYNC);
 
-	if (!pipe) {
+	if (IS_ERR(pipe)) {
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 47aceb494d1d..2de27f13d0ee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1666,10 +1666,12 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		ret = btrfs_mksubvol(&file->f_path, name, namelen,
 				     NULL, transid, readonly, inherit);
 	} else {
-		struct fd src = fdget(fd);
+		struct fd src = fdgetr(fd, CAP_FSTAT);
 		struct inode *src_inode;
-		if (!src.file) {
-			ret = -EINVAL;
+		if (IS_ERR(src.file)) {
+			ret = PTR_ERR(src.file);
+			if (ret == -EBADF)
+				ret = -EINVAL;
 			goto out_drop_write;
 		}
 
@@ -3040,9 +3042,10 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 
 	for (i = 0, info = same->info; i < count; i++, info++) {
 		struct inode *dst;
-		struct fd dst_file = fdget(info->fd);
-		if (!dst_file.file) {
-			info->status = -EBADF;
+		struct fd dst_file = fdgetr(info->fd, CAP_FSTAT);
+
+		if (IS_ERR(dst_file.file)) {
+			info->status = PTR_ERR(dst_file.file);
 			continue;
 		}
 		dst = file_inode(dst_file.file);
@@ -3611,9 +3614,9 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	if (ret)
 		return ret;
 
-	src_file = fdget(srcfd);
-	if (!src_file.file) {
-		ret = -EBADF;
+	src_file = fdgetr(srcfd, CAP_FSTAT);
+	if (IS_ERR(src_file.file)) {
+		ret = PTR_ERR(src_file.file);
 		goto out_drop_write;
 	}
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa662181..9b201c68b30b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5573,9 +5573,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 	sctx->flags = arg->flags;
 
-	sctx->send_filp = fget(arg->send_fd);
-	if (!sctx->send_filp) {
-		ret = -EBADF;
+	sctx->send_filp = fgetr(arg->send_fd, CAP_PWRITE);
+	if (IS_ERR(sctx->send_filp)) {
+		ret = PTR_ERR(sctx->send_filp);
+		sctx->send_filp = NULL;
 		goto out;
 	}
 
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 45cb59bcc791..405eeee73ffb 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -61,9 +61,9 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 		return rc;
 	}
 
-	src_file = fdget(srcfd);
-	if (!src_file.file) {
-		rc = -EBADF;
+	src_file = fdgetr(srcfd, CAP_PREAD);
+	if (IS_ERR(src_file.file)) {
+		rc = PTR_ERR(src_file.file);
 		goto out_drop_write;
 	}
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index fe3afb2de880..ab5e79cfbc46 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -128,8 +128,8 @@ static int get_device_index(struct coda_mount_data *data)
 		return -1;
 	}
 
-	f = fdget(data->fd);
-	if (!f.file)
+	f = fdgetr(data->fd, CAP_FSTAT);
+	if (IS_ERR(f.file))
 		goto Ebadf;
 	inode = file_inode(f.file);
 	if (!S_ISCHR(inode->i_mode) || imajor(inode) != CODA_PSDEV_MAJOR) {
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 5c1e4242368b..5749ecfab46e 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -188,7 +188,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 		struct coda_open_by_fd_out *outp =
 			(struct coda_open_by_fd_out *)req->uc_data;
 		if (!outp->oh.result)
-			outp->fh = fget(outp->fd);
+			outp->fh = fgetr(outp->fd, CAP_LIST_END);
 	}
 
         wake_up(&req->uc_sleep);
diff --git a/fs/compat.c b/fs/compat.c
index 66d3d3c6b4b2..58c3992931c9 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -889,14 +889,14 @@ COMPAT_SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
 		struct compat_old_linux_dirent __user *, dirent, unsigned int, count)
 {
 	int error;
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_READ);
 	struct compat_readdir_callback buf = {
 		.ctx.actor = compat_fillonedir,
 		.dirent = dirent
 	};
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	error = iterate_dir(f.file, &buf.ctx);
 	if (buf.result)
@@ -979,9 +979,9 @@ COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		return -EFAULT;
 
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_READ);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	error = iterate_dir(f.file, &buf.ctx);
 	if (error >= 0)
@@ -1064,9 +1064,9 @@ COMPAT_SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		return -EFAULT;
 
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_READ);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	error = iterate_dir(f.file, &buf.ctx);
 	if (error >= 0)
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index e82289047272..68f3ab88f00f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1542,10 +1542,18 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
 		       compat_ulong_t, arg32)
 {
 	unsigned long arg = arg32;
-	struct fd f = fdget(fd);
-	int error = -EBADF;
-	if (!f.file)
+	struct capsicum_rights rights;
+	struct fd f;
+	int error;
+
+	cap_rights_init(&rights, CAP_IOCTL);
+	rights.nioctls = 1;
+	rights.ioctls = &cmd;
+	f = fdget_rights(fd, &rights);
+	if (IS_ERR(f.file)) {
+		error = PTR_ERR(f.file);
 		goto out;
+	}
 
 	/* RED-PEN how should LSM module know it's handling 32bit? */
 	error = security_file_ioctl(f.file, cmd, arg);
diff --git a/fs/eventfd.c b/fs/eventfd.c
index d6a88e7812f3..9c5216b59c6e 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -319,16 +319,17 @@ static const struct file_operations eventfd_fops = {
  * Returns a pointer to the eventfd file structure in case of success, or the
  * following error pointer:
  *
- * -EBADF    : Invalid @fd file descriptor.
- * -EINVAL   : The @fd file descriptor is not an eventfd file.
+ * -EBADF       : Invalid @fd file descriptor.
+ * -ENOTCAPABLE : The @fd file descriptor does not have the required rights.
+ * -EINVAL      : The @fd file descriptor is not an eventfd file.
  */
 struct file *eventfd_fget(int fd)
 {
 	struct file *file;
 
-	file = fget(fd);
-	if (!file)
-		return ERR_PTR(-EBADF);
+	file = fgetr(fd, CAP_WRITE);
+	if (IS_ERR(file))
+		return file;
 	if (file->f_op != &eventfd_fops) {
 		fput(file);
 		return ERR_PTR(-EINVAL);
@@ -350,9 +351,10 @@ EXPORT_SYMBOL_GPL(eventfd_fget);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 {
 	struct eventfd_ctx *ctx;
-	struct fd f = fdget(fd);
-	if (!f.file)
-		return ERR_PTR(-EBADF);
+	struct fd f = fdgetr(fd, CAP_WRITE);
+
+	if (IS_ERR(f.file))
+		return (struct eventfd_ctx *) f.file;
 	ctx = eventfd_ctx_fileget(f.file);
 	fdput(f);
 	return ctx;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index b10b48c2a7af..0cba830f834b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1836,15 +1836,18 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
 		goto error_return;
 
-	error = -EBADF;
-	f = fdget(epfd);
-	if (!f.file)
+	f = fdgetr(epfd, CAP_EPOLL_CTL);
+	if (IS_ERR(f.file)) {
+		error = PTR_ERR(f.file);
 		goto error_return;
+	}
 
 	/* Get the "struct file *" for the target file */
-	tf = fdget(fd);
-	if (!tf.file)
+	tf = fdgetr(fd, CAP_POLL_EVENT);
+	if (IS_ERR(tf.file)) {
+		error = PTR_ERR(tf.file);
 		goto error_fput;
+	}
 
 	/* The target file descriptor must support poll */
 	error = -EPERM;
@@ -1976,9 +1979,9 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 		return -EFAULT;
 
 	/* Get the "struct file *" for the eventpoll file */
-	f = fdget(epfd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(epfd, CAP_POLL_EVENT);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	/*
 	 * We have to check that the file structure underneath the fd
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0f2252ec274d..a26108969d9b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -419,9 +419,9 @@ group_extend_out:
 			return -EFAULT;
 		me.moved_len = 0;
 
-		donor = fdget(me.donor_fd);
-		if (!donor.file)
-			return -EBADF;
+		donor = fdgetr(me.donor_fd, CAP_PWRITE, CAP_FSTAT);
+		if (IS_ERR(donor.file))
+			return PTR_ERR(donor.file);
 
 		if (!(donor.file->f_mode & FMODE_WRITE)) {
 			err = -EBADF;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index abf82e05d7b3..322a260e225b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -355,13 +355,99 @@ static int check_fcntl_cmd(unsigned cmd)
 	return 0;
 }
 
+static bool fcntl_rights(unsigned int cmd, struct capsicum_rights *rights)
+{
+	switch (cmd) {
+	case F_DUPFD:
+	case F_DUPFD_CLOEXEC:
+		/*
+		 * Returning true (=>use wrapped file) implies that no rights
+		 * are needed.
+		 */
+		cap_rights_init(rights, 0);
+		return true;
+	case F_GETFD:
+	case F_SETFD:
+		cap_rights_init(rights, 0);
+		return false;
+	case F_GETFL:
+		cap_rights_init(rights, CAP_FCNTL);
+		rights->fcntls = CAP_FCNTL_GETFL;
+		return false;
+	case F_SETFL:
+		cap_rights_init(rights, CAP_FCNTL);
+		rights->fcntls = CAP_FCNTL_SETFL;
+		return false;
+	case F_GETOWN:
+	case F_GETOWN_EX:
+	case F_GETOWNER_UIDS:
+		cap_rights_init(rights, CAP_FCNTL);
+		rights->fcntls = CAP_FCNTL_GETOWN;
+		return false;
+	case F_SETOWN:
+	case F_SETOWN_EX:
+		cap_rights_init(rights, CAP_FCNTL);
+		rights->fcntls = CAP_FCNTL_SETOWN;
+		return false;
+	case F_GETLK:
+	case F_SETLK:
+	case F_SETLKW:
+#if BITS_PER_LONG == 32
+	case F_GETLK64:
+	case F_SETLK64:
+	case F_SETLKW64:
+#endif
+		cap_rights_init(rights, CAP_FLOCK);
+		return false;
+	case F_GETSIG:
+	case F_SETSIG:
+		cap_rights_init(rights, CAP_POLL_EVENT, CAP_FSIGNAL);
+		return false;
+	case F_GETLEASE:
+	case F_SETLEASE:
+		cap_rights_init(rights, CAP_FLOCK, CAP_FSIGNAL);
+		return false;
+	case F_NOTIFY:
+		cap_rights_init(rights, CAP_NOTIFY);
+		return false;
+	case F_SETPIPE_SZ:
+		cap_rights_init(rights, CAP_SETSOCKOPT);
+		return false;
+	case F_GETPIPE_SZ:
+		cap_rights_init(rights, CAP_GETSOCKOPT);
+		return false;
+	default:
+		cap_rights_set_all(rights);
+		return false;
+	}
+}
+
+static inline struct fd fcntl_fdget_raw(unsigned int fd, unsigned int cmd,
+					struct capsicum_rights *rights)
+{
+	struct fd f;
+
+	if (fcntl_rights(cmd, rights)) {
+		/* Use the file directly, don't attempt to unwrap */
+		f = fdget_raw(fd);
+		if (f.file == NULL)
+			f.file = ERR_PTR(-EBADF);
+	} else {
+		f = fdget_raw_rights(fd, NULL, rights);
+	}
+	return f;
+}
+
 SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
-{	
-	struct fd f = fdget_raw(fd);
+{
+	struct capsicum_rights rights;
+	struct fd f = fcntl_fdget_raw(fd, cmd, &rights);
 	long err = -EBADF;
 
-	if (!f.file)
+	if (IS_ERR(f.file)) {
+		err = PTR_ERR(f.file);
 		goto out;
+	}
 
 	if (unlikely(f.file->f_mode & FMODE_PATH)) {
 		if (!check_fcntl_cmd(cmd))
@@ -381,12 +467,15 @@ out:
 #if BITS_PER_LONG == 32
 SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 		unsigned long, arg)
-{	
-	struct fd f = fdget_raw(fd);
+{
+	struct capsicum_rights rights;
+	struct fd f = fcntl_fdget_raw(fd, cmd, &rights);
 	long err = -EBADF;
 
-	if (!f.file)
+	if (IS_ERR(f.file)) {
+		err = PTR_ERR(f.file);
 		goto out;
+	}
 
 	if (unlikely(f.file->f_mode & FMODE_PATH)) {
 		if (!check_fcntl_cmd(cmd))
diff --git a/fs/fhandle.c b/fs/fhandle.c
index 999ff5c3cab0..b9f9496838ac 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -121,9 +121,10 @@ static struct vfsmount *get_vfsmount_from_fd(int fd)
 		mnt = mntget(fs->pwd.mnt);
 		spin_unlock(&fs->lock);
 	} else {
-		struct fd f = fdget(fd);
-		if (!f.file)
-			return ERR_PTR(-EBADF);
+		struct fd f = fdgetr(fd, CAP_LOOKUP);
+
+		if (IS_ERR(f.file))
+			return (struct vfsmount *)f.file;
 		mnt = mntget(f.file->f_path.mnt);
 		fdput(f);
 	}
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 754dcf23de8a..4a49dca49c8f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1025,11 +1025,15 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sb->s_export_op = &fuse_export_operations;
 
-	file = fget(d.fd);
-	err = -EINVAL;
-	if (!file)
+	file = fgetr(d.fd, CAP_READ, CAP_WRITE);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		if (err == -EBADF)
+			err = -EINVAL;
 		goto err;
+	}
 
+	err = -EINVAL;
 	if ((file->f_op != &fuse_dev_operations) ||
 	    (file->f_cred->user_ns != &init_user_ns))
 		goto err_fput;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad36192..23ba2aac63da 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -604,10 +604,16 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {
 	int error;
-	struct fd f = fdget(fd);
+	struct capsicum_rights rights;
+	struct fd f;
 
-	if (!f.file)
-		return -EBADF;
+	cap_rights_init(&rights, CAP_IOCTL);
+	rights.nioctls = 1;
+	rights.ioctls = &cmd;
+	f = fdget_rights(fd, &rights);
+
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	error = security_file_ioctl(f.file, cmd, arg);
 	if (!error)
 		error = do_vfs_ioctl(f.file, fd, cmd, arg);
diff --git a/fs/locks.c b/fs/locks.c
index 717fbc404e6b..fdad193dc4b4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1828,19 +1828,21 @@ EXPORT_SYMBOL(flock_lock_file_wait);
  */
 SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_FLOCK);
 	struct file_lock *lock;
 	int can_sleep, unlock;
 	int error;
 
-	error = -EBADF;
-	if (!f.file)
+	if (IS_ERR(f.file)) {
+		error = PTR_ERR(f.file);
 		goto out;
+	}
 
 	can_sleep = !(cmd & LOCK_NB);
 	cmd &= ~LOCK_NB;
 	unlock = (cmd == LOCK_UN);
 
+	error = -EBADF;
 	if (!unlock && !(cmd & LOCK_MAND) &&
 	    !(f.file->f_mode & (FMODE_READ|FMODE_WRITE)))
 		goto out_putf;
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3fdc8a3e1134..b89f51c9182e 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -433,11 +433,12 @@ static int fanotify_find_path(int dfd, const char __user *filename,
 		 dfd, filename, flags);
 
 	if (filename == NULL) {
-		struct fd f = fdget(dfd);
+		struct fd f = fdgetr(dfd, CAP_FSTAT);
 
-		ret = -EBADF;
-		if (!f.file)
+		if (IS_ERR(f.file)) {
+			ret = PTR_ERR(f.file);
 			goto out;
+		}
 
 		ret = -ENOTDIR;
 		if ((flags & FAN_MARK_ONLYDIR) &&
@@ -457,7 +458,8 @@ static int fanotify_find_path(int dfd, const char __user *filename,
 		if (flags & FAN_MARK_ONLYDIR)
 			lookup_flags |= LOOKUP_DIRECTORY;
 
-		ret = user_path_at(dfd, filename, lookup_flags, path);
+		ret = user_path_atr(dfd, filename, lookup_flags, path,
+				    CAP_FSTAT, CAP_LOOKUP);
 		if (ret)
 			goto out;
 	}
@@ -822,9 +824,9 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
 #endif
 		return -EINVAL;
 
-	f = fdget(fanotify_fd);
-	if (unlikely(!f.file))
-		return -EBADF;
+	f = fdgetr(fanotify_fd, CAP_NOTIFY);
+	if (unlikely(IS_ERR(f.file)))
+		return PTR_ERR(f.file);
 
 	/* verify that this is indeed an fanotify instance */
 	ret = -EINVAL;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index cc423a30a0c8..18389f0d83f8 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -711,9 +711,9 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (unlikely(!f.file))
-		return -EBADF;
+	f = fdgetr(fd, CAP_NOTIFY);
+	if (unlikely(IS_ERR(f.file)))
+		return PTR_ERR(f.file);
 
 	/* verify that this is indeed an inotify instance */
 	if (unlikely(f.file->f_op != &inotify_fops)) {
@@ -749,9 +749,9 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 	struct fd f;
 	int ret = 0;
 
-	f = fdget(fd);
-	if (unlikely(!f.file))
-		return -EBADF;
+	f = fdgetr(fd, CAP_NOTIFY);
+	if (unlikely(IS_ERR(f.file)))
+		return PTR_ERR(f.file);
 
 	/* verify that this is indeed an inotify instance */
 	ret = -EINVAL;
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 73039295d0d1..4e49b06b6d52 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1740,9 +1740,13 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	if (fd < 0 || fd >= INT_MAX)
 		goto out;
 
-	f = fdget(fd);
-	if (f.file == NULL)
+	f = fdgetr(fd, CAP_FSTAT);
+	if (IS_ERR(f.file)) {
+		ret = PTR_ERR(f.file);
+		if (ret == -EBADF)
+			ret = -EINVAL;
 		goto out;
+	}
 
 	if (reg->hr_blocks == 0 || reg->hr_start_block == 0 ||
 	    reg->hr_block_bytes == 0)
diff --git a/fs/open.c b/fs/open.c
index ee16be3a7291..111b023a741c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -159,10 +159,11 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	error = -EINVAL;
 	if (length < 0)
 		goto out;
-	error = -EBADF;
-	f = fdget(fd);
-	if (!f.file)
+	f = fdgetr(fd, CAP_FTRUNCATE);
+	if (IS_ERR(f.file)) {
+		error = PTR_ERR(f.file);
 		goto out;
+	}
 
 	/* explicitly opened as large or we are on 64-bit box */
 	if (f.file->f_flags & O_LARGEFILE)
@@ -302,12 +303,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 SYSCALL_DEFINE4(fallocate, int, fd, int, mode, loff_t, offset, loff_t, len)
 {
-	struct fd f = fdget(fd);
-	int error = -EBADF;
+	struct fd f = fdgetr(fd, CAP_WRITE);
+	int error;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		error = do_fallocate(f.file, mode, offset, len);
 		fdput(f);
+	} else {
+		error = PTR_ERR(f.file);
 	}
 	return error;
 }
@@ -348,7 +351,7 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	old_cred = override_creds(override_cred);
 retry:
-	res = user_path_at(dfd, filename, lookup_flags, &path);
+	res = user_path_atr(dfd, filename, lookup_flags, &path, CAP_FSTAT);
 	if (res)
 		goto out;
 
@@ -426,13 +429,14 @@ out:
 
 SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 {
-	struct fd f = fdget_raw(fd);
+	struct fd f = fdgetr_raw(fd, CAP_FCHDIR);
 	struct inode *inode;
 	int error = -EBADF;
 
-	error = -EBADF;
-	if (!f.file)
+	if (IS_ERR(f.file)) {
+		error = PTR_ERR(f.file);
 		goto out;
+	}
 
 	inode = file_inode(f.file);
 
@@ -513,13 +517,15 @@ out_unlock:
 
 SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_FCHMOD);
 	int err = -EBADF;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		audit_inode(NULL, f.file->f_path.dentry, 0);
 		err = chmod_common(&f.file->f_path, mode);
 		fdput(f);
+	} else {
+		err = PTR_ERR(f.file);
 	}
 	return err;
 }
@@ -530,7 +536,7 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = user_path_atr(dfd, filename, lookup_flags, &path, CAP_FCHMODAT);
 	if (!error) {
 		error = chmod_common(&path, mode);
 		path_put(&path);
@@ -603,7 +609,7 @@ SYSCALL_DEFINE5(fchownat, int, dfd, const char __user *, filename, uid_t, user,
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = user_path_atr(dfd, filename, lookup_flags, &path, CAP_FCHOWNAT);
 	if (error)
 		goto out;
 	error = mnt_want_write(path.mnt);
@@ -634,11 +640,13 @@ SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group
 
 SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 {
-	struct fd f = fdget(fd);
-	int error = -EBADF;
+	struct fd f = fdgetr(fd, CAP_FCHOWN);
+	int error;
 
-	if (!f.file)
+	if (IS_ERR(f.file)) {
+		error = PTR_ERR(f.file);
 		goto out;
+	}
 
 	error = mnt_want_write_file(f.file);
 	if (error)
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 89026095f2b5..dc29c4d6f050 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -272,9 +272,9 @@ struct file *proc_ns_fget(int fd)
 {
 	struct file *file;
 
-	file = fget(fd);
-	if (!file)
-		return ERR_PTR(-EBADF);
+	file = fgetr(fd, CAP_SETNS);
+	if (IS_ERR(file))
+		return file;
 
 	if (file->f_op != &ns_file_operations)
 		goto out_invalid;
diff --git a/fs/read_write.c b/fs/read_write.c
index c6e0f20a9f94..ed96b1ad7207 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -275,9 +275,10 @@ static inline void fdput_pos(struct fd f)
 SYSCALL_DEFINE3(lseek, unsigned int, fd, off_t, offset, unsigned int, whence)
 {
 	off_t retval;
-	struct fd f = fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
+	struct fd f = fdgetr_pos(fd, CAP_SEEK);
+
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	retval = -EINVAL;
 	if (whence <= SEEK_MAX) {
@@ -303,11 +304,11 @@ SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
 		unsigned int, whence)
 {
 	int retval;
-	struct fd f = fdget_pos(fd);
+	struct fd f = fdgetr_pos(fd, CAP_SEEK);
 	loff_t offset;
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	retval = -EINVAL;
 	if (whence > SEEK_MAX)
@@ -554,15 +555,17 @@ static inline void file_pos_write(struct file *file, loff_t pos)
 
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
-	struct fd f = fdget_pos(fd);
-	ssize_t ret = -EBADF;
+	struct fd f = fdgetr_pos(fd, CAP_READ);
+	ssize_t ret;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_read(f.file, buf, count, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 	return ret;
 }
@@ -570,15 +573,17 @@ SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
 		size_t, count)
 {
-	struct fd f = fdget_pos(fd);
-	ssize_t ret = -EBADF;
+	struct fd f = fdgetr_pos(fd, CAP_WRITE);
+	ssize_t ret;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_write(f.file, buf, count, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	return ret;
@@ -593,12 +598,14 @@ SYSCALL_DEFINE4(pread64, unsigned int, fd, char __user *, buf,
 	if (pos < 0)
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (f.file) {
+	f = fdgetr(fd, CAP_PREAD);
+	if (!IS_ERR(f.file)) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
 			ret = vfs_read(f.file, buf, count, &pos);
 		fdput(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	return ret;
@@ -613,12 +620,14 @@ SYSCALL_DEFINE4(pwrite64, unsigned int, fd, const char __user *, buf,
 	if (pos < 0)
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (f.file) {
+	f = fdgetr(fd, CAP_PWRITE);
+	if (!IS_ERR(f.file)) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)  
 			ret = vfs_write(f.file, buf, count, &pos);
 		fdput(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	return ret;
@@ -878,15 +887,17 @@ EXPORT_SYMBOL(vfs_writev);
 SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 		unsigned long, vlen)
 {
-	struct fd f = fdget_pos(fd);
-	ssize_t ret = -EBADF;
+	struct fd f = fdgetr_pos(fd, CAP_READ);
+	ssize_t ret;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_readv(f.file, vec, vlen, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	if (ret > 0)
@@ -898,15 +909,17 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 		unsigned long, vlen)
 {
-	struct fd f = fdget_pos(fd);
-	ssize_t ret = -EBADF;
+	struct fd f = fdgetr_pos(fd, CAP_WRITE);
+	ssize_t ret;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_writev(f.file, vec, vlen, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	if (ret > 0)
@@ -926,17 +939,19 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 {
 	loff_t pos = pos_from_hilo(pos_h, pos_l);
 	struct fd f;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (f.file) {
+	f = fdgetr(fd, CAP_PREAD);
+	if (!IS_ERR(f.file)) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
 			ret = vfs_readv(f.file, vec, vlen, &pos);
 		fdput(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	if (ret > 0)
@@ -950,17 +965,19 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 {
 	loff_t pos = pos_from_hilo(pos_h, pos_l);
 	struct fd f;
-	ssize_t ret = -EBADF;
+	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (f.file) {
+	f = fdgetr(fd, CAP_PWRITE);
+	if (!IS_ERR(f.file)) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)
 			ret = vfs_writev(f.file, vec, vlen, &pos);
 		fdput(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 
 	if (ret > 0)
@@ -1055,12 +1072,12 @@ COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
 		compat_ulong_t, vlen)
 {
-	struct fd f = fdget_pos(fd);
+	struct fd f = fdgetr_pos(fd, CAP_READ);
 	ssize_t ret;
 	loff_t pos;
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	pos = f.file->f_pos;
 	ret = compat_readv(f.file, vec, vlen, &pos);
 	if (ret >= 0)
@@ -1078,9 +1095,9 @@ static long __compat_sys_preadv64(unsigned long fd,
 
 	if (pos < 0)
 		return -EINVAL;
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_PREAD);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PREAD)
 		ret = compat_readv(f.file, vec, vlen, &pos);
@@ -1132,12 +1149,12 @@ COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
 		const struct compat_iovec __user *, vec,
 		compat_ulong_t, vlen)
 {
-	struct fd f = fdget_pos(fd);
+	struct fd f = fdgetr_pos(fd, CAP_WRITE);
 	ssize_t ret;
 	loff_t pos;
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	pos = f.file->f_pos;
 	ret = compat_writev(f.file, vec, vlen, &pos);
 	if (ret >= 0)
@@ -1155,9 +1172,9 @@ static long __compat_sys_pwritev64(unsigned long fd,
 
 	if (pos < 0)
 		return -EINVAL;
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_PWRITE);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	ret = -ESPIPE;
 	if (f.file->f_mode & FMODE_PWRITE)
 		ret = compat_writev(f.file, vec, vlen, &pos);
@@ -1198,9 +1215,11 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	 * Get input file, and verify that it is ok..
 	 */
 	retval = -EBADF;
-	in = fdget(in_fd);
-	if (!in.file)
+	in = fdgetr(in_fd, CAP_PREAD);
+	if (IS_ERR(in.file)) {
+		retval = PTR_ERR(in.file);
 		goto out;
+	}
 	if (!(in.file->f_mode & FMODE_READ))
 		goto fput_in;
 	retval = -ESPIPE;
@@ -1220,9 +1239,11 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	 * Get output file, and verify that it is ok..
 	 */
 	retval = -EBADF;
-	out = fdget(out_fd);
-	if (!out.file)
+	out = fdgetr(out_fd, CAP_WRITE);
+	if (IS_ERR(out.file)) {
+		retval = PTR_ERR(out.file);
 		goto fput_in;
+	}
 	if (!(out.file->f_mode & FMODE_WRITE))
 		goto fput_out;
 	retval = -EINVAL;
diff --git a/fs/readdir.c b/fs/readdir.c
index 33fd92208cb7..284728df319a 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -110,14 +110,14 @@ SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
 		struct old_linux_dirent __user *, dirent, unsigned int, count)
 {
 	int error;
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_READ);
 	struct readdir_callback buf = {
 		.ctx.actor = fillonedir,
 		.dirent = dirent
 	};
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	error = iterate_dir(f.file, &buf.ctx);
 	if (buf.result)
@@ -206,9 +206,9 @@ SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		return -EFAULT;
 
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_READ);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	error = iterate_dir(f.file, &buf.ctx);
 	if (error >= 0)
@@ -286,9 +286,9 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!access_ok(VERIFY_WRITE, dirent, count))
 		return -EFAULT;
 
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_READ);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	error = iterate_dir(f.file, &buf.ctx);
 	if (error >= 0)
diff --git a/fs/select.c b/fs/select.c
index 467bb1cb3ea5..079bb7e9c126 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -449,8 +449,8 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					break;
 				if (!(bit & all_bits))
 					continue;
-				f = fdget(i);
-				if (f.file) {
+				f = fdgetr(i, CAP_POLL_EVENT);
+				if (!IS_ERR(f.file)) {
 					const struct file_operations *f_op;
 					f_op = f.file->f_op;
 					mask = DEFAULT_POLLMASK;
@@ -487,6 +487,9 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					} else if (busy_flag & mask)
 						can_busy_loop = true;
 
+				} else if (PTR_ERR(f.file) != -EBADF) {
+					retval = PTR_ERR(f.file);
+					break;
 				}
 			}
 			if (res_in)
@@ -757,9 +760,9 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait,
 	mask = 0;
 	fd = pollfd->fd;
 	if (fd >= 0) {
-		struct fd f = fdget(fd);
+		struct fd f = fdgetr(fd, CAP_POLL_EVENT);
 		mask = POLLNVAL;
-		if (f.file) {
+		if (!IS_ERR(f.file)) {
 			mask = DEFAULT_POLLMASK;
 			if (f.file->f_op->poll) {
 				pwait->_key = pollfd->events|POLLERR|POLLHUP;
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 424b7b65321f..f484c2db0c8a 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -288,9 +288,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		if (ufd < 0)
 			kfree(ctx);
 	} else {
-		struct fd f = fdget(ufd);
-		if (!f.file)
-			return -EBADF;
+		struct fd f = fdgetr(ufd, CAP_FSIGNAL);
+
+		if (IS_ERR(f.file))
+			return PTR_ERR(f.file);
 		ctx = f.file->private_data;
 		if (f.file->f_op != &signalfd_fops) {
 			fdput(f);
diff --git a/fs/splice.c b/fs/splice.c
index f5cb9ba84510..a72872e83d0b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1647,14 +1647,16 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, iov,
 		return 0;
 
 	error = -EBADF;
-	f = fdget(fd);
-	if (f.file) {
+	f = fdgetr(fd, CAP_WRITE);
+	if (!IS_ERR(f.file)) {
 		if (f.file->f_mode & FMODE_WRITE)
 			error = vmsplice_to_pipe(f.file, iov, nr_segs, flags);
 		else if (f.file->f_mode & FMODE_READ)
 			error = vmsplice_to_user(f.file, iov, nr_segs, flags);
 
 		fdput(f);
+	} else {
+		error = PTR_ERR(f.file);
 	}
 
 	return error;
@@ -1692,19 +1694,23 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 		return 0;
 
 	error = -EBADF;
-	in = fdget(fd_in);
-	if (in.file) {
+	in = fdgetr(fd_in, CAP_PREAD);
+	if (!IS_ERR(in.file)) {
 		if (in.file->f_mode & FMODE_READ) {
-			out = fdget(fd_out);
-			if (out.file) {
+			out = fdgetr(fd_out, CAP_PWRITE);
+			if (!IS_ERR(out.file)) {
 				if (out.file->f_mode & FMODE_WRITE)
 					error = do_splice(in.file, off_in,
 							  out.file, off_out,
 							  len, flags);
 				fdput(out);
+			} else {
+				error = PTR_ERR(out.file);
 			}
 		}
 		fdput(in);
+	} else {
+		error = PTR_ERR(in.file);
 	}
 	return error;
 }
@@ -2023,19 +2029,24 @@ SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
 		return 0;
 
 	error = -EBADF;
-	in = fdget(fdin);
-	if (in.file) {
+	in = fdgetr(fdin, CAP_READ);
+	if (!IS_ERR(in.file)) {
 		if (in.file->f_mode & FMODE_READ) {
-			struct fd out = fdget(fdout);
-			if (out.file) {
+			struct fd out = fdgetr(fdout, CAP_WRITE);
+
+			if (!IS_ERR(out.file)) {
 				if (out.file->f_mode & FMODE_WRITE)
 					error = do_tee(in.file, out.file,
 							len, flags);
 				fdput(out);
+			} else {
+				error = PTR_ERR(out.file);
 			}
 		}
- 		fdput(in);
- 	}
+		fdput(in);
+	} else {
+		error = PTR_ERR(in.file);
+	}
 
 	return error;
 }
diff --git a/fs/stat.c b/fs/stat.c
index ae0c3cef9927..f40b3530eab4 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -76,12 +76,14 @@ EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
-	struct fd f = fdget_raw(fd);
-	int error = -EBADF;
+	struct fd f = fdgetr_raw(fd, CAP_FSTAT);
+	int error;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		error = vfs_getattr(&f.file->f_path, stat);
 		fdput(f);
+	} else {
+		error = PTR_ERR(f.file);
 	}
 	return error;
 }
@@ -103,7 +105,7 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = user_path_atr(dfd, filename, lookup_flags, &path, CAP_FSTAT);
 	if (error)
 		goto out;
 
diff --git a/fs/statfs.c b/fs/statfs.c
index 083dc0ac9140..e2c6be447aa3 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -94,11 +94,14 @@ retry:
 
 int fd_statfs(int fd, struct kstatfs *st)
 {
-	struct fd f = fdget_raw(fd);
-	int error = -EBADF;
-	if (f.file) {
+	struct fd f = fdgetr_raw(fd, CAP_FSTATFS);
+	int error;
+
+	if (!IS_ERR(f.file)) {
 		error = vfs_statfs(&f.file->f_path, st);
 		fdput(f);
+	} else {
+		error = PTR_ERR(f.file);
 	}
 	return error;
 }
diff --git a/fs/sync.c b/fs/sync.c
index b28d1dd10e8b..663afe812600 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -148,12 +148,12 @@ void emergency_sync(void)
  */
 SYSCALL_DEFINE1(syncfs, int, fd)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_FSYNC);
 	struct super_block *sb;
 	int ret;
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	sb = f.file->f_dentry->d_sb;
 
 	down_read(&sb->s_umount);
@@ -199,12 +199,14 @@ EXPORT_SYMBOL(vfs_fsync);
 
 static int do_fsync(unsigned int fd, int datasync)
 {
-	struct fd f = fdget(fd);
-	int ret = -EBADF;
+	struct fd f = fdgetr(fd, CAP_FSYNC);
+	int ret;
 
-	if (f.file) {
+	if (!IS_ERR(f.file)) {
 		ret = vfs_fsync(f.file, datasync);
 		fdput(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 	return ret;
 }
@@ -310,10 +312,11 @@ SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
 	else
 		endbyte--;		/* inclusive */
 
-	ret = -EBADF;
-	f = fdget(fd);
-	if (!f.file)
+	f = fdgetr(fd, CAP_FSYNC, CAP_SEEK);
+	if (IS_ERR(f.file)) {
+		ret = PTR_ERR(f.file);
 		goto out;
+	}
 
 	i_mode = file_inode(f.file)->i_mode;
 	ret = -ESPIPE;
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 0013142c0475..daf04417e2cf 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -291,6 +291,32 @@ static const struct file_operations timerfd_fops = {
 	.llseek		= noop_llseek,
 };
 
+#ifdef CONFIG_SECURITY_CAPSICUM
+#define timerfd_fgetr(f, p, ...) \
+	_timerfd_fgetr((f), (p), __VA_ARGS__, 0ULL)
+static int _timerfd_fgetr(int fd, struct fd *p, ...)
+{
+	struct capsicum_rights rights;
+	struct fd f;
+	va_list ap;
+
+	va_start(ap, p);
+	f = fdget_rights(fd, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
+	if (f.file->f_op != &timerfd_fops) {
+		fdput(f);
+		return -EINVAL;
+	}
+	*p = f;
+	return 0;
+}
+
+#else
+
+#define timerfd_fgetr(f, p, ...) \
+	timerfd_fget((f), (p))
 static int timerfd_fget(int fd, struct fd *p)
 {
 	struct fd f = fdget(fd);
@@ -304,6 +330,8 @@ static int timerfd_fget(int fd, struct fd *p)
 	return 0;
 }
 
+#endif
+
 SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 {
 	int ufd;
@@ -359,7 +387,7 @@ static int do_timerfd_settime(int ufd, int flags,
 	    !timespec_valid(&new->it_interval))
 		return -EINVAL;
 
-	ret = timerfd_fget(ufd, &f);
+	ret = timerfd_fgetr(ufd, &f, CAP_WRITE, (old ? CAP_READ : 0));
 	if (ret)
 		return ret;
 	ctx = f.file->private_data;
@@ -397,8 +425,10 @@ static int do_timerfd_settime(int ufd, int flags,
 			hrtimer_forward_now(&ctx->t.tmr, ctx->tintv);
 	}
 
-	old->it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
-	old->it_interval = ktime_to_timespec(ctx->tintv);
+	if (old) {
+		old->it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+		old->it_interval = ktime_to_timespec(ctx->tintv);
+	}
 
 	/*
 	 * Re-program the timer to the new value ...
@@ -414,7 +444,7 @@ static int do_timerfd_gettime(int ufd, struct itimerspec *t)
 {
 	struct fd f;
 	struct timerfd_ctx *ctx;
-	int ret = timerfd_fget(ufd, &f);
+	int ret = timerfd_fgetr(ufd, &f, CAP_READ);
 	if (ret)
 		return ret;
 	ctx = f.file->private_data;
@@ -451,7 +481,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 
 	if (copy_from_user(&new, utmr, sizeof(new)))
 		return -EFAULT;
-	ret = do_timerfd_settime(ufd, flags, &new, &old);
+	ret = do_timerfd_settime(ufd, flags, &new, otmr ? &old : NULL);
 	if (ret)
 		return ret;
 	if (otmr && copy_to_user(otmr, &old, sizeof(old)))
diff --git a/fs/utimes.c b/fs/utimes.c
index aa138d64560a..1d451efd6ae2 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -152,10 +152,11 @@ long do_utimes(int dfd, const char __user *filename, struct timespec *times,
 		if (flags & AT_SYMLINK_NOFOLLOW)
 			goto out;
 
-		f = fdget(dfd);
-		error = -EBADF;
-		if (!f.file)
+		f = fdgetr(dfd, CAP_FUTIMES);
+		if (IS_ERR(f.file)) {
+			error = PTR_ERR(f.file);
 			goto out;
+		}
 
 		error = utimes_common(&f.file->f_path, times);
 		fdput(f);
@@ -166,7 +167,8 @@ long do_utimes(int dfd, const char __user *filename, struct timespec *times,
 		if (!(flags & AT_SYMLINK_NOFOLLOW))
 			lookup_flags |= LOOKUP_FOLLOW;
 retry:
-		error = user_path_at(dfd, filename, lookup_flags, &path);
+		error = user_path_atr(dfd, filename, lookup_flags, &path,
+				      CAP_FUTIMESAT);
 		if (error)
 			goto out;
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 3377dff18404..3013dc4cbf27 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -415,12 +415,12 @@ retry:
 SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 		const void __user *,value, size_t, size, int, flags)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_EXTATTR_SET);
 	struct dentry *dentry;
-	int error = -EBADF;
+	int error;
 
-	if (!f.file)
-		return error;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	dentry = f.file->f_path.dentry;
 	audit_inode(NULL, dentry, 0);
 	error = mnt_want_write_file(f.file);
@@ -522,11 +522,11 @@ retry:
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 		void __user *, value, size_t, size)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_EXTATTR_GET);
 	ssize_t error = -EBADF;
 
-	if (!f.file)
-		return error;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	audit_inode(NULL, f.file->f_path.dentry, 0);
 	error = getxattr(f.file->f_path.dentry, name, value, size);
 	fdput(f);
@@ -611,11 +611,11 @@ retry:
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_EXTATTR_LIST);
 	ssize_t error = -EBADF;
 
-	if (!f.file)
-		return error;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	audit_inode(NULL, f.file->f_path.dentry, 0);
 	error = listxattr(f.file->f_path.dentry, list, size);
 	fdput(f);
@@ -688,12 +688,12 @@ retry:
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_EXTATTR_DELETE);
 	struct dentry *dentry;
 	int error = -EBADF;
 
-	if (!f.file)
-		return error;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 	dentry = f.file->f_path.dentry;
 	audit_inode(NULL, dentry, 0);
 	error = mnt_want_write_file(f.file);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8bc1bbce7451..f2f8f199abe6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -76,9 +76,9 @@ xfs_find_handle(
 	struct xfs_inode	*ip;
 
 	if (cmd == XFS_IOC_FD_TO_HANDLE) {
-		f = fdget(hreq->fd);
-		if (!f.file)
-			return -EBADF;
+		f = fdgetr(hreq->fd, CAP_FSTAT);
+		if (IS_ERR(f.file))
+			return PTR_ERR(f.file);
 		inode = file_inode(f.file);
 	} else {
 		error = user_lpath((const char __user *)hreq->path, &path);
@@ -1443,8 +1443,8 @@ xfs_ioc_swapext(
 	int		error = 0;
 
 	/* Pull information for the target fd */
-	f = fdget((int)sxp->sx_fdtarget);
-	if (!f.file) {
+	f = fdgetr((int)sxp->sx_fdtarget, CAP_READ, CAP_WRITE, CAP_FSTAT);
+	if (IS_ERR(f.file)) {
 		error = XFS_ERROR(EINVAL);
 		goto out;
 	}
@@ -1456,8 +1456,8 @@ xfs_ioc_swapext(
 		goto out_put_file;
 	}
 
-	tmp = fdget((int)sxp->sx_fdtmp);
-	if (!tmp.file) {
+	tmp = fdgetr((int)sxp->sx_fdtmp, CAP_READ, CAP_WRITE, CAP_FSTAT);
+	if (IS_ERR(tmp.file)) {
 		error = XFS_ERROR(EINVAL);
 		goto out_put_file;
 	}
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 4fcf39af1776..f38639676b00 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -978,9 +978,9 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 
 	audit_mq_sendrecv(mqdes, msg_len, msg_prio, timeout ? &ts : NULL);
 
-	f = fdget(mqdes);
-	if (unlikely(!f.file)) {
-		ret = -EBADF;
+	f = fdgetr(mqdes, CAP_WRITE);
+	if (unlikely(IS_ERR(f.file))) {
+		ret = PTR_ERR(f.file);
 		goto out;
 	}
 
@@ -1094,9 +1094,9 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 
 	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
 
-	f = fdget(mqdes);
-	if (unlikely(!f.file)) {
-		ret = -EBADF;
+	f = fdgetr(mqdes, CAP_READ);
+	if (unlikely(IS_ERR(f.file))) {
+		ret = PTR_ERR(f.file);
 		goto out;
 	}
 
@@ -1229,9 +1229,9 @@ SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
 			skb_put(nc, NOTIFY_COOKIE_LEN);
 			/* and attach it to the socket */
 retry:
-			f = fdget(notification.sigev_signo);
-			if (!f.file) {
-				ret = -EBADF;
+			f = fdgetr(notification.sigev_signo, CAP_POLL_EVENT);
+			if (IS_ERR(f.file)) {
+				ret = PTR_ERR(f.file);
 				goto out;
 			}
 			sock = netlink_getsockbyfilp(f.file);
@@ -1254,9 +1254,9 @@ retry:
 		}
 	}
 
-	f = fdget(mqdes);
-	if (!f.file) {
-		ret = -EBADF;
+	f = fdgetr(mqdes, CAP_POLL_EVENT);
+	if (IS_ERR(f.file)) {
+		ret = PTR_ERR(f.file);
 		goto out;
 	}
 
@@ -1328,9 +1328,9 @@ SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mqdes,
 			return -EINVAL;
 	}
 
-	f = fdget(mqdes);
-	if (!f.file) {
-		ret = -EBADF;
+	f = fdgetr(mqdes, CAP_POLL_EVENT);
+	if (IS_ERR(f.file)) {
+		ret = PTR_ERR(f.file);
 		goto out;
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2bcbd7..b44e4c0d7dcb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -603,11 +603,11 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 {
 	struct perf_cgroup *cgrp;
 	struct cgroup_subsys_state *css;
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_FSTAT);
 	int ret = 0;
 
-	if (!f.file)
-		return -EBADF;
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	css = css_tryget_online_from_dir(f.file->f_dentry,
 					 &perf_event_cgrp_subsys);
@@ -3636,9 +3636,10 @@ static const struct file_operations perf_fops;
 
 static inline int perf_fget_light(int fd, struct fd *p)
 {
-	struct fd f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	struct fd f = fdgetr(fd, CAP_WRITE);
+
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	if (f.file->f_op != &perf_fops) {
 		fdput(f);
@@ -3689,7 +3690,7 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		int ret;
 		if (arg != -1) {
 			struct perf_event *output_event;
-			struct fd output;
+			struct fd output = { .file = NULL };
 			ret = perf_fget_light(arg, &output);
 			if (ret)
 				return ret;
diff --git a/kernel/module.c b/kernel/module.c
index 81e727cf6df9..f7f781dac164 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2513,14 +2513,18 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
 /* Sets info->hdr and info->len. */
 static int copy_module_from_fd(int fd, struct load_info *info)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_FEXECVE);
 	int err;
 	struct kstat stat;
 	loff_t pos;
 	ssize_t bytes = 0;
 
-	if (!f.file)
-		return -ENOEXEC;
+	if (IS_ERR(f.file)) {
+		err = PTR_ERR(f.file);
+		if (err == -EBADF)
+			err = -ENOEXEC;
+		return err;
+	}
 
 	err = security_kernel_module_from_file(f.file);
 	if (err)
diff --git a/kernel/sys.c b/kernel/sys.c
index 66a751ebf9d9..8d8ccf6cfb38 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1634,9 +1634,9 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	struct inode *inode;
 	int err;
 
-	exe = fdget(fd);
-	if (!exe.file)
-		return -EBADF;
+	exe = fdgetr(fd, CAP_FEXECVE);
+	if (IS_ERR(exe.file))
+		return PTR_ERR(exe.file);
 
 	inode = file_inode(exe.file);
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 13d2f7cd65db..1ad5fd005334 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -437,8 +437,8 @@ static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
-	f = fdget(fd);
-	if (!f.file)
+	f = fdgetr(fd, CAP_FSTAT);
+	if (IS_ERR(f.file))
 		return 0;
 
 	size = nla_total_size(sizeof(struct cgroupstats));
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index ce033c7aa2e8..0766473c77ea 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -246,13 +246,18 @@ struct posix_clock_desc {
 	struct posix_clock *clk;
 };
 
-static int get_clock_desc(const clockid_t id, struct posix_clock_desc *cd)
+static int get_clock_desc(const clockid_t id, struct posix_clock_desc *cd,
+			  u64 right)
 {
-	struct file *fp = fget(CLOCKID_TO_FD(id));
+	struct file *fp = fgetr(CLOCKID_TO_FD(id), right);
 	int err = -EINVAL;
 
-	if (!fp)
+	if (IS_ERR(fp)) {
+		err = PTR_ERR(fp);
+		if (err == -EBADF)
+			err = -EINVAL;
 		return err;
+	}
 
 	if (fp->f_op->open != posix_clock_open || !fp->private_data)
 		goto out;
@@ -278,7 +283,7 @@ static int pc_clock_adjtime(clockid_t id, struct timex *tx)
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_WRITE);
 	if (err)
 		return err;
 
@@ -302,7 +307,7 @@ static int pc_clock_gettime(clockid_t id, struct timespec *ts)
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_READ);
 	if (err)
 		return err;
 
@@ -321,7 +326,7 @@ static int pc_clock_getres(clockid_t id, struct timespec *ts)
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_READ);
 	if (err)
 		return err;
 
@@ -340,7 +345,7 @@ static int pc_clock_settime(clockid_t id, const struct timespec *ts)
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_WRITE);
 	if (err)
 		return err;
 
@@ -365,7 +370,7 @@ static int pc_timer_create(struct k_itimer *kit)
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_WRITE);
 	if (err)
 		return err;
 
@@ -385,7 +390,7 @@ static int pc_timer_delete(struct k_itimer *kit)
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_WRITE);
 	if (err)
 		return err;
 
@@ -404,7 +409,7 @@ static void pc_timer_gettime(struct k_itimer *kit, struct itimerspec *ts)
 	clockid_t id = kit->it_clock;
 	struct posix_clock_desc cd;
 
-	if (get_clock_desc(id, &cd))
+	if (get_clock_desc(id, &cd, CAP_READ))
 		return;
 
 	if (cd.clk->ops.timer_gettime)
@@ -420,7 +425,7 @@ static int pc_timer_settime(struct k_itimer *kit, int flags,
 	struct posix_clock_desc cd;
 	int err;
 
-	err = get_clock_desc(id, &cd);
+	err = get_clock_desc(id, &cd, CAP_WRITE);
 	if (err)
 		return err;
 
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 3bcfd81db45e..69d51a43dc56 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -27,7 +27,7 @@
  */
 SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 {
-	struct fd f = fdget(fd);
+	struct fd f;
 	struct address_space *mapping;
 	struct backing_dev_info *bdi;
 	loff_t endbyte;			/* inclusive */
@@ -36,8 +36,9 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 	unsigned long nrpages;
 	int ret = 0;
 
-	if (!f.file)
-		return -EBADF;
+	f = fdgetr(fd, CAP_LIST_END);
+	if (IS_ERR(f.file))
+		return PTR_ERR(f.file);
 
 	if (S_ISFIFO(file_inode(f.file)->i_mode)) {
 		ret = -ESPIPE;
diff --git a/mm/internal.h b/mm/internal.h
index 7f22a11fcc66..07f18aa9ccfb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -13,6 +13,8 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/capsicum.h>
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
@@ -91,6 +93,23 @@ static inline void get_page_foll(struct page *page)
 	}
 }
 
+static inline struct capsicum_rights *
+mmap_rights(struct capsicum_rights *rights,
+	    unsigned long prot,
+	    unsigned long flags)
+{
+#ifdef CONFIG_SECURITY_CAPSICUM
+	cap_rights_init(rights, CAP_MMAP);
+	if (prot & PROT_READ)
+		cap_rights_set(rights, CAP_MMAP_R);
+	if ((flags & MAP_SHARED) && (prot & PROT_WRITE))
+		cap_rights_set(rights, CAP_MMAP_W);
+	if (prot & PROT_EXEC)
+		cap_rights_set(rights, CAP_MMAP_X);
+#endif
+	return rights;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb0e6eb..d09576bcbf57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5868,9 +5868,9 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	init_waitqueue_func_entry(&event->wait, memcg_event_wake);
 	INIT_WORK(&event->remove, memcg_event_remove);
 
-	efile = fdget(efd);
-	if (!efile.file) {
-		ret = -EBADF;
+	efile = fdgetr(efd, CAP_WRITE);
+	if (IS_ERR(efile.file)) {
+		ret = PTR_ERR(efile.file);
 		goto out_kfree;
 	}
 
@@ -5880,9 +5880,9 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 		goto out_put_efile;
 	}
 
-	cfile = fdget(cfd);
-	if (!cfile.file) {
-		ret = -EBADF;
+	cfile = fdgetr(cfd, CAP_READ);
+	if (IS_ERR(cfile.file)) {
+		ret = PTR_ERR(cfile.file);
 		goto out_put_eventfd;
 	}
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 129b847d30cc..e2e3cf45feec 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1381,10 +1381,13 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 	unsigned long retval = -EBADF;
 
 	if (!(flags & MAP_ANONYMOUS)) {
+		struct capsicum_rights rights;
 		audit_mmap_fd(fd, flags);
-		file = fget(fd);
-		if (!file)
+		file = fget_rights(fd, mmap_rights(&rights, prot, flags));
+		if (IS_ERR(file)) {
+			retval = PTR_ERR(file);
 			goto out;
+		}
 		if (is_file_hugepages(file))
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
 		retval = -EINVAL;
diff --git a/mm/nommu.c b/mm/nommu.c
index 4a852f6c5709..3b1be7a25b39 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1496,13 +1496,17 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		unsigned long, fd, unsigned long, pgoff)
 {
 	struct file *file = NULL;
-	unsigned long retval = -EBADF;
+	unsigned long retval;
 
 	audit_mmap_fd(fd, flags);
 	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
+		struct capsicum_rights rights;
+
+		file = fget_rights(fd, mmap_rights(&rights, prot, flags));
+		if (IS_ERR(file)) {
+			retval = PTR_ERR(file);
 			goto out;
+		}
 	}
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
diff --git a/mm/readahead.c b/mm/readahead.c
index 0ca36a7770b1..781125653dcf 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -566,8 +566,8 @@ SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
 	struct fd f;
 
 	ret = -EBADF;
-	f = fdget(fd);
-	if (f.file) {
+	f = fdgetr(fd, CAP_PREAD);
+	if (!IS_ERR(f.file)) {
 		if (f.file->f_mode & FMODE_READ) {
 			struct address_space *mapping = f.file->f_mapping;
 			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
@@ -576,6 +576,8 @@ SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
 			ret = do_readahead(mapping, f.file, start, len);
 		}
 		fdput(f);
+	} else {
+		ret = PTR_ERR(f.file);
 	}
 	return ret;
 }
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 80d08f6664cb..6d0866ac873d 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -789,12 +789,12 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 	if (!ts)
 		return -ENOMEM;
 
-	ts->rd = fget(rfd);
-	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
+	ts->rd = fgetr(rfd, CAP_READ, CAP_POLL_EVENT);
+	ts->wr = fgetr(wfd, CAP_WRITE, CAP_POLL_EVENT);
+	if (IS_ERR(ts->rd) || IS_ERR(ts->wr)) {
+		if (!IS_ERR(ts->rd))
 			fput(ts->rd);
-		if (ts->wr)
+		if (!IS_ERR(ts->wr))
 			fput(ts->wr);
 		kfree(ts);
 		return -EIO;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index b653ab001fba..8bd3eb38f260 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1611,10 +1611,14 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 	struct snd_pcm_file *pcm_file;
 	struct snd_pcm_substream *substream1;
 	struct snd_pcm_group *group;
-	struct fd f = fdget(fd);
+	struct fd f = fdgetr(fd, CAP_LIST_END);
 
-	if (!f.file)
-		return -EBADFD;
+	if (IS_ERR(f.file)) {
+		res = PTR_ERR(f.file);
+		if (res == -EBADF)
+			return -EBADFD;
+		return res;
+	}
 	if (!is_pcm_file(f.file)) {
 		res = -EBADFD;
 		goto _badf;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 20c3af7692c5..f1e38c413731 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -311,9 +311,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	INIT_WORK(&irqfd->inject, irqfd_inject);
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
-	f = fdget(args->fd);
-	if (!f.file) {
-		ret = -EBADF;
+	f = fdgetr(args->fd, CAP_WRITE);
+	if (IS_ERR(f.file)) {
+		ret = PTR_ERR(f.file);
 		goto out;
 	}
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ba1a93f935c7..1f427fafa03b 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -124,9 +124,9 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 		if (get_user(fd, argp))
 			return -EFAULT;
 
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
+		f = fdgetr(fd, CAP_FSTAT);
+		if (IS_ERR(f.file))
+			return PTR_ERR(f.file);
 
 		vfio_group = kvm_vfio_group_get_external_user(f.file);
 		fdput(f);
@@ -164,9 +164,9 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 		if (get_user(fd, argp))
 			return -EFAULT;
 
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
+		f = fdgetr(fd, CAP_FSTAT);
+		if (IS_ERR(f.file))
+			return PTR_ERR(f.file);
 
 		vfio_group = kvm_vfio_group_get_external_user(f.file);
 		fdput(f);
-- 
2.0.0.526.g5318336
