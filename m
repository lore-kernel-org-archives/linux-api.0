From: Minchan Kim <minchan@kernel.org>
Subject: [RFCv2 6/6] mm: extend process_madvise syscall to support vector arrary
Date: Fri, 31 May 2019 15:43:13 +0900
Message-ID: <20190531064313.193437-7-minchan@kernel.org>
References: <20190531064313.193437-1-minchan@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531064313.193437-1-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

Currently, process_madvise syscall works for only one address range so
user should call the syscall several times to give hints to multiple
address ranges. However, it's not efficient to support atomicity of
address range opreations as well as performance perspective.

This patch extends process_madvise syscall to support multiple hints,
address ranges and return vaules so user could give hints all at once.

struct pr_madvise_param {
        int size;               /* the size of this structure */
        int cookie;             /* reserved to support atomicity */
        int nr_elem;            /* count of below arrary fields */
        int __user *hints;      /* hints for each range */
        /* to store result of each operation */
        const struct iovec __user *results;
        /* input address ranges */
        const struct iovec __user *ranges;
};

  int process_madvise(int pidfd, struct pr_madvise_param *u_param,
			unsigned long flags);

About cookie, Daniel Colascione suggested a idea[1] to support atomicity
as well as improving parsing speed of address ranges of the target process.
The process_getinfo(2) syscall could create vma configuration sequence
number and returns(e.g., the seq number will be increased when target process
holds mmap_sem exclusive lock) the number with address ranges as binary form.
With calling the this vector syscall with the sequence number and address
ranges we got from process_getinfo, we could detect there was race of
the target process address space layout and makes the fail of the syscall
if user want to have atomicity. It also speed up the address range
parsing because we don't need to parse human-friend strings from /proc fs.

[1] https://lore.kernel.org/lkml/20190520035254.57579-1-minchan@kernel.org/T/#m7694416fd179b2066a2c62b5b139b14e3894e224

struct pr_madvise_param {
    int size;               /* the size of this structure */
    int cookie;             /* reserved to support atomicity */
    int nr_elem;            /* count of below arrary fields */
    int *hints;      /* hints for each range */
    /* to store result of each operation */
    const struct iovec *results;
    /* input address ranges */
    const struct iovec *ranges;
};

int main(int argc, char *argv[])
{
        struct pr_madvise_param param;
        int hints[NR_ADDR_RANGE];
        int ret[NR_ADDR_RANGE];
        struct iovec ret_vec[NR_ADDR_RANGE];
        struct iovec range_vec[NR_ADDR_RANGE];
        void *addr[NR_ADDR_RANGE];
        pid_t pid;

        addr[0] = mmap(NULL, ALLOC_SIZE, PROT_READ|PROT_WRITE,
                          MAP_POPULATE|MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
        if (MAP_FAILED == addr[0]) {
                printf("Fail to alloc\n");
                return 1;
        }

        addr[1] = mmap(NULL, ALLOC_SIZE, PROT_READ|PROT_WRITE,
                          MAP_POPULATE|MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);

        if (MAP_FAILED == addr[1]) {
                printf("Fail to alloc\n");
                return 1;
        }

        ret_vec[0].iov_base = &ret[0];
        ret_vec[0].iov_len = sizeof(long);
        ret_vec[1].iov_base = &ret[1];
        ret_vec[1].iov_len = sizeof(long);
        range_vec[0].iov_base = addr[0];
        range_vec[0].iov_len = ALLOC_SIZE;
        range_vec[1].iov_base = addr[1];
        range_vec[1].iov_len = ALLOC_SIZE;

        hints[0] = MADV_COLD;
        hints[1] = MADV_PAGEOUT;

        param.size = sizeof(struct pr_madvise_param);
        param.cookie = 0;
        param.nr_elem = NR_ADDR_RANGE;
        param.hints = hints;
        param.results = ret_vec;
        param.ranges = range_vec;

        pid = fork();
        if (!pid) {
                sleep(10);
        } else {
                int pidfd = syscall(__NR_pidfd_open, pid, 0);
                if (pidfd < 0) {
                        printf("Fail to open process file descriptor\n");
                        return 1;
                }

                munmap(addr[0], ALLOC_SIZE);
                munmap(addr[1], ALLOC_SIZE);

                system("cat /proc/vmstat | egrep 'pswpout|deactivate'");
                if (syscall(__NR_process_madvise, pidfd, &param, 0))
                        perror("process_madvise fail\n");
                system("cat /proc/vmstat | egrep 'pswpout|deactivate'");
        }

	return 0;
}

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/syscalls.h               |   6 +-
 include/uapi/asm-generic/mman-common.h |  11 +++
 mm/madvise.c                           | 126 ++++++++++++++++++++++---
 3 files changed, 126 insertions(+), 17 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6ba081c955f6..05627718a547 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -872,9 +872,9 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
-asmlinkage long sys_process_madvise(int pidfd, unsigned long start,
-				size_t len, int behavior,
-				unsigned long cookie, unsigned long flags);
+asmlinkage long sys_process_madvise(int pidfd,
+				struct pr_madvise_param __user *u_params,
+				unsigned long flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index 92e347a89ddc..220c2b5eb961 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -75,4 +75,15 @@
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
 				 PKEY_DISABLE_WRITE)
 
+struct pr_madvise_param {
+	int size;		/* the size of this structure */
+	int cookie;		/* reserved to support atomicity */
+	int nr_elem;		/* count of below arrary fields */
+	int __user *hints;	/* hints for each range */
+	/* to store result of each operation */
+	const struct iovec __user *results;
+	/* input address ranges */
+	const struct iovec __user *ranges;
+};
+
 #endif /* __ASM_GENERIC_MMAN_COMMON_H */
diff --git a/mm/madvise.c b/mm/madvise.c
index fd205e928a1b..94d782097afd 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1107,6 +1107,56 @@ static int madvise_core(struct task_struct *task, struct mm_struct *mm,
 	return error;
 }
 
+static int pr_madvise_copy_param(struct pr_madvise_param __user *u_param,
+		struct pr_madvise_param *param)
+{
+	u32 size;
+	int ret;
+
+	memset(param, 0, sizeof(*param));
+
+	ret = get_user(size, &u_param->size);
+	if (ret)
+		return ret;
+
+	if (size > PAGE_SIZE)
+		return -E2BIG;
+
+	if (!size || size > sizeof(struct pr_madvise_param))
+		return -EINVAL;
+
+	ret = copy_from_user(param, u_param, size);
+	if (ret)
+		return -EFAULT;
+
+	return ret;
+}
+
+static int process_madvise_core(struct task_struct *tsk, struct mm_struct *mm,
+				int *behaviors,
+				struct iov_iter *iter,
+				const struct iovec *range_vec,
+				unsigned long riovcnt)
+{
+	int i;
+	long err;
+
+	for (i = 0; i < riovcnt && iov_iter_count(iter); i++) {
+		err = -EINVAL;
+		if (process_madvise_behavior_valid(behaviors[i]))
+			err = madvise_core(tsk, mm,
+				(unsigned long)range_vec[i].iov_base,
+				range_vec[i].iov_len, behaviors[i]);
+
+		if (copy_to_iter(&err, sizeof(long), iter) !=
+				sizeof(long)) {
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * The madvise(2) system call.
  *
@@ -1173,37 +1223,78 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 	return madvise_core(current, current->mm, start, len_in, behavior);
 }
 
-SYSCALL_DEFINE6(process_madvise, int, pidfd, unsigned long, start,
-		size_t, len_in, int, behavior, unsigned long, cookie,
-		unsigned long, flags)
+
+SYSCALL_DEFINE3(process_madvise, int, pidfd,
+				struct pr_madvise_param __user *, u_params,
+				unsigned long, flags)
 {
 	int ret;
 	struct fd f;
 	struct pid *pid;
 	struct task_struct *task;
 	struct mm_struct *mm;
+	struct pr_madvise_param params;
+	const struct iovec __user *result_vec, __user *range_vec;
+	int *behaviors;
+	struct iovec iovstack_result[UIO_FASTIOV];
+	struct iovec iovstack_r[UIO_FASTIOV];
+	struct iovec *iov_l = iovstack_result;
+	struct iovec *iov_r = iovstack_r;
+	struct iov_iter iter;
+	int nr_elem;
 
 	if (flags != 0)
 		return -EINVAL;
 
+	ret = pr_madvise_copy_param(u_params, &params);
+	if (ret)
+		return ret;
+
 	/*
-	 * We don't support cookie to gaurantee address space change
-	 * atomicity yet.
+	 * We don't support cookie to gaurantee address space atomicity yet.
+	 * Once we implment cookie, process_madvise_core need to hold mmap_sme
+	 * during entire operation to guarantee atomicity.
 	 */
-	if (cookie != 0)
+	if (params.cookie != 0)
 		return -EINVAL;
 
-	if (!process_madvise_behavior_valid(behavior))
-		return return -EINVAL;
+	range_vec = params.ranges;
+	result_vec = params.results;
+	nr_elem = params.nr_elem;
+
+	behaviors = kmalloc_array(nr_elem, sizeof(int), GFP_KERNEL);
+	if (!behaviors)
+		return -ENOMEM;
+
+	ret = copy_from_user(behaviors, params.hints, sizeof(int) * nr_elem);
+	if (ret < 0)
+		goto free_behavior_vec;
+
+	ret = import_iovec(READ, result_vec, params. nr_elem, UIO_FASTIOV,
+				&iov_l, &iter);
+	if (ret < 0)
+		goto free_behavior_vec;
+
+	if (!iov_iter_count(&iter)) {
+		ret = -EINVAL;
+		goto free_iovecs;
+	}
+
+	ret = rw_copy_check_uvector(CHECK_IOVEC_ONLY, range_vec, nr_elem,
+					UIO_FASTIOV, iovstack_r, &iov_r);
+	if (ret <= 0)
+		goto free_iovecs;
 
 	f = fdget(pidfd);
-	if (!f.file)
-		return -EBADF;
+	if (!f.file) {
+		ret = -EBADF;
+		goto free_iovecs;
+	}
 
 	pid = pidfd_pid(f.file);
 	if (IS_ERR(pid)) {
 		ret = PTR_ERR(pid);
-		goto err;
+		goto put_fd;
 	}
 
 	rcu_read_lock();
@@ -1211,7 +1302,7 @@ SYSCALL_DEFINE6(process_madvise, int, pidfd, unsigned long, start,
 	if (!task) {
 		rcu_read_unlock();
 		ret = -ESRCH;
-		goto err;
+		goto put_fd;
 	}
 
 	get_task_struct(task);
@@ -1225,11 +1316,18 @@ SYSCALL_DEFINE6(process_madvise, int, pidfd, unsigned long, start,
 		goto release_task;
 	}
 
-	ret = madvise_core(task, mm, start, len_in, behavior);
+	ret = process_madvise_core(task, mm, behaviors, &iter, iov_r, nr_elem);
 	mmput(mm);
 release_task:
 	put_task_struct(task);
-err:
+put_fd:
 	fdput(f);
+free_iovecs:
+	if (iov_r != iovstack_r)
+		kfree(iov_r);
+	kfree(iov_l);
+free_behavior_vec:
+	kfree(behaviors);
+
 	return ret;
 }
-- 
2.22.0.rc1.257.g3120a18244-goog
