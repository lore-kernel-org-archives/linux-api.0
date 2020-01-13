From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 2/4] mm: introduce external memory hinting API
Date: Mon, 13 Jan 2020 10:39:34 -0800
Message-ID: <20200113183934.GC110363@google.com>
References: <20200110213433.94739-1-minchan@kernel.org>
 <20200110213433.94739-3-minchan@kernel.org>
 <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, christian.brauner@ubuntu.com
List-Id: linux-api@vger.kernel.org

On Mon, Jan 13, 2020 at 11:47:11AM +0300, Kirill Tkhai wrote:
> On 11.01.2020 00:34, Minchan Kim wrote:
> > There are usecases that System Management Software(SMS) want to give
> > a memory hint to other processes because it's not known to the
> > application. In the case of Android, ActivityManagerService daemon
> > manges app's life cycle and that daemon must be able to initiate
> > reclaim on its own without any app involvement.
> > 
> > To solve the issue, this patch introduces new syscall process_madvise(2).
> > It uses pidfd of an external processs to give the hint.
> > 
> >  int process_madvise(int pidfd, void *addr, size_t length, int advise,
> > 			unsigned long flag);
> > 
> > Since it could affect other process's address range, only privileged
> > process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
> > gives it the right to ptrace the process could use it successfully.
> > The flag argument is reserved for future use if we need to extend the
> > API.
> > 
> > Supporting all hints madvise has/will supported/support to process_madvise
> > is rather risky. Because we are not sure all hints make sense from external
> > process and implementation for the hint may rely on the caller being
> > in the current context so it could be error-prone. Thus, I just limited
> > hints as MADV_[COLD|PAGEOUT] in this patch.
> > 
> > If someone want to add other hints, we could hear hear the usecase and
> > review it for each hint. It's more safe for maintainace rather than
> > introducing a buggy syscall but hard to fix it later.
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  arch/alpha/kernel/syscalls/syscall.tbl      |  1 +
> >  arch/arm/tools/syscall.tbl                  |  1 +
> >  arch/arm64/include/asm/unistd.h             |  2 +-
> >  arch/arm64/include/asm/unistd32.h           |  2 +
> >  arch/ia64/kernel/syscalls/syscall.tbl       |  1 +
> >  arch/m68k/kernel/syscalls/syscall.tbl       |  1 +
> >  arch/microblaze/kernel/syscalls/syscall.tbl |  1 +
> >  arch/mips/kernel/syscalls/syscall_n32.tbl   |  1 +
> >  arch/mips/kernel/syscalls/syscall_n64.tbl   |  1 +
> >  arch/parisc/kernel/syscalls/syscall.tbl     |  1 +
> >  arch/powerpc/kernel/syscalls/syscall.tbl    |  1 +
> >  arch/s390/kernel/syscalls/syscall.tbl       |  1 +
> >  arch/sh/kernel/syscalls/syscall.tbl         |  1 +
> >  arch/sparc/kernel/syscalls/syscall.tbl      |  1 +
> >  arch/x86/entry/syscalls/syscall_32.tbl      |  1 +
> >  arch/x86/entry/syscalls/syscall_64.tbl      |  1 +
> >  arch/xtensa/kernel/syscalls/syscall.tbl     |  1 +
> >  include/linux/syscalls.h                    |  2 +
> >  include/uapi/asm-generic/unistd.h           |  5 +-
> >  kernel/sys_ni.c                             |  1 +
> >  mm/madvise.c                                | 64 +++++++++++++++++++++
> >  21 files changed, 89 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
> > index e56950f23b49..776c61803315 100644
> > --- a/arch/alpha/kernel/syscalls/syscall.tbl
> > +++ b/arch/alpha/kernel/syscalls/syscall.tbl
> > @@ -477,3 +477,4 @@
> >  # 545 reserved for clone3
> >  546	common	watch_devices			sys_watch_devices
> >  547	common	openat2				sys_openat2
> > +548	common	process_madvise			sys_process_madvise
> > diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
> > index 7fb2f4d59210..a43381542276 100644
> > --- a/arch/arm/tools/syscall.tbl
> > +++ b/arch/arm/tools/syscall.tbl
> > @@ -451,3 +451,4 @@
> >  435	common	clone3				sys_clone3
> >  436	common	watch_devices			sys_watch_devices
> >  437	common	openat2				sys_openat2
> > +438	common	process_madvise			sys_process_madvise
> > diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> > index 8aa00ccb0b96..b722e47377a5 100644
> > --- a/arch/arm64/include/asm/unistd.h
> > +++ b/arch/arm64/include/asm/unistd.h
> > @@ -38,7 +38,7 @@
> >  #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
> >  #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
> >  
> > -#define __NR_compat_syscalls		438
> > +#define __NR_compat_syscalls		439
> >  #endif
> >  
> >  #define __ARCH_WANT_SYS_CLONE
> > diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> > index 31f0ce25719e..5c82557d408f 100644
> > --- a/arch/arm64/include/asm/unistd32.h
> > +++ b/arch/arm64/include/asm/unistd32.h
> > @@ -883,6 +883,8 @@ __SYSCALL(__NR_clone3, sys_clone3)
> >  __SYSCALL(__NR_watch_devices, sys_watch_devices)
> >  #define __NR_openat2 437
> >  __SYSCALL(__NR_openat2, sys_openat2)
> > +#define __NR_openat2 438
> > +__SYSCALL(__NR_process_madvise, process_madvise)
> >  
> >  /*
> >   * Please add new compat syscalls above this comment and update
> > diff --git a/arch/ia64/kernel/syscalls/syscall.tbl b/arch/ia64/kernel/syscalls/syscall.tbl
> > index b9aa59931905..c156abc9a298 100644
> > --- a/arch/ia64/kernel/syscalls/syscall.tbl
> > +++ b/arch/ia64/kernel/syscalls/syscall.tbl
> > @@ -358,3 +358,4 @@
> >  # 435 reserved for clone3
> >  436	common	watch_devices			sys_watch_devices
> >  437	common	openat2				sys_openat2
> > +438	common	process_madvise			sys_process_madvise
> > diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
> > index 868c1ef89d35..5b6034b6650f 100644
> > --- a/arch/m68k/kernel/syscalls/syscall.tbl
> > +++ b/arch/m68k/kernel/syscalls/syscall.tbl
> > @@ -437,3 +437,4 @@
> >  # 435 reserved for clone3
> >  436	common	watch_devices			sys_watch_devices
> >  437	common	openat2				sys_openat2
> > +438	common	process_madvise			sys_process_madvise
> > diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
> > index 544b4cef18b3..4bef584af09c 100644
> > --- a/arch/microblaze/kernel/syscalls/syscall.tbl
> > +++ b/arch/microblaze/kernel/syscalls/syscall.tbl
> > @@ -443,3 +443,4 @@
> >  435	common	clone3				sys_clone3
> >  436	common	watch_devices			sys_watch_devices
> >  437	common	openat2				sys_openat2
> > +438	common	process_madvise			sys_process_madvise
> > diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
> > index 05e8aee5dae7..94fbd0fcccce 100644
> > --- a/arch/mips/kernel/syscalls/syscall_n32.tbl
> > +++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
> > @@ -376,3 +376,4 @@
> >  435	n32	clone3				__sys_clone3
> >  436	n32	watch_devices			sys_watch_devices
> >  437	n32	openat2				sys_openat2
> > +437	n32	process_madivse			sys_process_madvise
> 
> 438. And several places below has the same mistake.

Thanks. I fixed.

< snip >

> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 0c901de531e4..e15dfb4df7bf 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/falloc.h>
> >  #include <linux/fadvise.h>
> >  #include <linux/sched.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/ksm.h>
> >  #include <linux/fs.h>
> >  #include <linux/file.h>
> > @@ -993,6 +994,18 @@ madvise_behavior_valid(int behavior)
> >  	}
> >  }
> >  
> > +static bool
> > +process_madvise_behavior_valid(int behavior)
> > +{
> > +	switch (behavior) {
> > +	case MADV_COLD:
> > +	case MADV_PAGEOUT:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> >  /*
> >   * madvise_common - request behavior hint to address range of the target process
> >   *
> > @@ -1169,3 +1182,54 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
> >  {
> >  	return madvise_common(current, current->mm, start, len_in, behavior);
> >  }
> > +
> > +SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
> > +		size_t, len_in, int, behavior, unsigned long, flags)
> 
> I don't like the interface. The fact we have pidfd does not mean,
> we have to use it for new syscalls always. A user may want to set
> madvise for specific pid from console and pass pid as argument.
> pidfd would be an overkill in this case.

I am curious what is our plan for pid and pidfd once we introduced pidfd.
Ccing pidfd maintainer.

Since pid has clear problems, pidfd was born so not sure we should keep
both options for new coming API.

Since this is hinting API, performance wouldn't be critical requirment.
Rather than, it aims for a certain target process so that keep the process
during the operation without concern of reusing pid, which is perfectly
matched with pidfd.

> We usually call "kill -9 pid" from console. Why shouldn't process_madvise()
> allow this?

It's a syscall but not command which uses the syscall for implementation.

> 
> I suggent to extend first argument to work with both pid and pidfd.
> Look at what we have for waitid(idtype, id_t id, ...) for example:
> 
>        idtype == P_PID
>               Wait for the child whose process ID matches id.
> 
>        idtype == P_PIDFD (since Linux 5.4)
>               Wait for the child referred to by the PID file descriptor specified in id.  (See pidfd_open(2) for  further  information  on
>               PID file descriptors.)

IMO, it's okay to extend existing syscall to support new pidfd but I'm not
convinced why we should support both options for this memory hinting API
fron the beginning.

I'm not strong against of supporting both options but it would be much better
to have strong justification or guide whehter we should support both or only
pidfd so that upcoming APIs will follow the strategy.

> 
> We may use @flags argument for this.

> 
> > +{
> > +	int ret;
> > +	struct fd f;
> > +	struct pid *pid;
> > +	struct task_struct *task;
> > +	struct mm_struct *mm;
> > +
> > +	if (flags != 0)
> > +		return -EINVAL;
> > +
> > +	if (!process_madvise_behavior_valid(behavior))
> > +		return -EINVAL;
> > +
> > +	f = fdget(pidfd);
> > +	if (!f.file)
> > +		return -EBADF;
> > +
> > +	pid = pidfd_pid(f.file);
> > +	if (IS_ERR(pid)) {
> > +		ret = PTR_ERR(pid);
> > +		goto err;
> > +	}
> 
> From here:
> 
> > +	rcu_read_lock();
> > +	task = pid_task(pid, PIDTYPE_PID);
> > +	if (!task) {
> > +		rcu_read_unlock();
> > +		ret = -ESRCH;
> > +		goto err;
> > +	}
> > +
> > +	get_task_struct(task);
> > +	rcu_read_unlock();
> 
> to here your code is a copy of existing get_pid_task(). We should the primitive instead.

Fixed.

> 
> > +
> > +	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
> > +	if (IS_ERR_OR_NULL(mm)) {
> > +		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
> > +		goto release_task;
> > +	}
> > +
> > +	ret = madvise_common(task, mm, start, len_in, behavior);
> > +	mmput(mm);
> > +release_task:
> > +	put_task_struct(task);
> > +err:
> 
> Maybe s/err:/fdput:/ for uniformity with the above "release_task:"?

Fixed.

Thanks for the review.
