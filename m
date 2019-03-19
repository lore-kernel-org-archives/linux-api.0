From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] userfaultfd/sysctl: add
 vm.unprivileged_userfaultfd
Date: Tue, 19 Mar 2019 09:11:04 +0200
Message-ID: <20190319071104.GA6392@rapoport-lnx>
References: <20190319030722.12441-1-peterx@redhat.com>
 <20190319030722.12441-2-peterx@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319030722.12441-2-peterx@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Hugh Dickins <hughd@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Maxime Coquelin <maxime.coquelin@redhat.com>, Maya Gokhale <gokhale2@llnl.gov>, Jerome Glisse <jglisse@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Martin Cracauer <cracauer@cons.org>, Denis Plotnikov <dplotnikov@virtuozzo.com>, linux-mm@kvack.org, Marty McFadden <mcfadden8@llnl.gov>, Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>, "Kirill A . Shutemov" <kirill@shutemov.name>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Peter,

On Tue, Mar 19, 2019 at 11:07:22AM +0800, Peter Xu wrote:
> Add a global sysctl knob "vm.unprivileged_userfaultfd" to control
> whether userfaultfd is allowed by unprivileged users.  When this is
> set to zero, only privileged users (root user, or users with the
> CAP_SYS_PTRACE capability) will be able to use the userfaultfd
> syscalls.
> 
> Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
> Suggested-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

Just one minor note below

> ---
>  Documentation/sysctl/vm.txt   | 12 ++++++++++++
>  fs/userfaultfd.c              |  5 +++++
>  include/linux/userfaultfd_k.h |  2 ++
>  kernel/sysctl.c               | 12 ++++++++++++
>  4 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 187ce4f599a2..f146712f67bb 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -61,6 +61,7 @@ Currently, these files are in /proc/sys/vm:
>  - stat_refresh
>  - numa_stat
>  - swappiness
> +- unprivileged_userfaultfd
>  - user_reserve_kbytes
>  - vfs_cache_pressure
>  - watermark_boost_factor
> @@ -818,6 +819,17 @@ The default value is 60.
> 
>  ==============================================================
> 
> +unprivileged_userfaultfd
> +
> +This flag controls whether unprivileged users can use the userfaultfd
> +syscalls.  Set this to 1 to allow unprivileged users to use the
> +userfaultfd syscalls, or set this to 0 to restrict userfaultfd to only
> +privileged users (with SYS_CAP_PTRACE capability).

Can you please fully spell "system call"?

> +
> +The default value is 1.
> +
> +==============================================================
> +
>  - user_reserve_kbytes
> 
>  When overcommit_memory is set to 2, "never overcommit" mode, reserve
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 89800fc7dc9d..7e856a25cc2f 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -30,6 +30,8 @@
>  #include <linux/security.h>
>  #include <linux/hugetlb.h>
> 
> +int sysctl_unprivileged_userfaultfd __read_mostly = 1;
> +
>  static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
> 
>  enum userfaultfd_state {
> @@ -1921,6 +1923,9 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
>  	struct userfaultfd_ctx *ctx;
>  	int fd;
> 
> +	if (!sysctl_unprivileged_userfaultfd && !capable(CAP_SYS_PTRACE))
> +		return -EPERM;
> +
>  	BUG_ON(!current->mm);
> 
>  	/* Check the UFFD_* constants for consistency.  */
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 37c9eba75c98..ac9d71e24b81 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -28,6 +28,8 @@
>  #define UFFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>  #define UFFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS)
> 
> +extern int sysctl_unprivileged_userfaultfd;
> +
>  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
> 
>  extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 7578e21a711b..9b8ff1881df9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -66,6 +66,7 @@
>  #include <linux/kexec.h>
>  #include <linux/bpf.h>
>  #include <linux/mount.h>
> +#include <linux/userfaultfd_k.h>
> 
>  #include <linux/uaccess.h>
>  #include <asm/processor.h>
> @@ -1704,6 +1705,17 @@ static struct ctl_table vm_table[] = {
>  		.extra1		= (void *)&mmap_rnd_compat_bits_min,
>  		.extra2		= (void *)&mmap_rnd_compat_bits_max,
>  	},
> +#endif
> +#ifdef CONFIG_USERFAULTFD
> +	{
> +		.procname	= "unprivileged_userfaultfd",
> +		.data		= &sysctl_unprivileged_userfaultfd,
> +		.maxlen		= sizeof(sysctl_unprivileged_userfaultfd),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
>  #endif
>  	{ }
>  };
> -- 
> 2.17.1
> 

-- 
Sincerely yours,
Mike.
