From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH v6] seccomp, ptrace: add support for dumping seccomp
 filters
Date: Wed, 7 Oct 2015 11:37:04 +0100
Message-ID: <20151007103704.GA2547@hopstrocity>
References: <1444211179-24925-1-git-send-email-tycho.andersen@canonical.com>
 <1444211179-24925-2-git-send-email-tycho.andersen@canonical.com>
 <5614F323.9050805@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5614F323.9050805@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Daniel,

On Wed, Oct 07, 2015 at 12:25:39PM +0200, Daniel Borkmann wrote:
> On 10/07/2015 11:46 AM, Tycho Andersen wrote:
> >+
> >+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> >+extern long seccomp_get_filter(struct task_struct *task, long n,
> >+			       void __user *data);
> >+#else
> >+static inline long seccomp_get_filter(struct task_struct *task,
> >+				      long n, void __user *data)
> >+{
> >+	return -EINVAL;
> 
> Nit: -ENOTSUP would probably be the better choice? -EINVAL might just
> be confusing to users? (Would be unclear to them whether there's actual
> support of dumping or whether it's just an invalid argument.)

Fine with me, the rest of the seccomp functions in this file use
-EINVAL, so I'm just copying that. Kees?

> >+}
> >+#endif /* CONFIG_SECCOMP_FILTER && CONFIG_CHECKPOINT_RESTORE */
> >  #endif /* _LINUX_SECCOMP_H */
> ...
> >diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> >index 787320d..b760bae 100644
> >--- a/kernel/ptrace.c
> >+++ b/kernel/ptrace.c
> >@@ -1016,6 +1016,11 @@ int ptrace_request(struct task_struct *child, long request,
> >  		break;
> >  	}
> >  #endif
> >+
> >+	case PTRACE_SECCOMP_GET_FILTER:
> >+		ret = seccomp_get_filter(child, addr, datavp);
> >+		break;
> >+
> >  	default:
> >  		break;
> >  	}
> >diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> >index 06858a7..c8a4564 100644
> >--- a/kernel/seccomp.c
> >+++ b/kernel/seccomp.c
> >@@ -347,6 +347,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
> >  {
> >  	struct seccomp_filter *sfilter;
> >  	int ret;
> >+	bool save_orig = config_enabled(CONFIG_CHECKPOINT_RESTORE);
> >
> >  	if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
> >  		return ERR_PTR(-EINVAL);
> >@@ -370,7 +371,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
> >  		return ERR_PTR(-ENOMEM);
> >
> >  	ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
> >-					seccomp_check_filter, false);
> >+					seccomp_check_filter, save_orig);
> >  	if (ret < 0) {
> >  		kfree(sfilter);
> >  		return ERR_PTR(ret);
> >@@ -867,3 +868,57 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
> >  	/* prctl interface doesn't have flags, so they are always zero. */
> >  	return do_seccomp(op, 0, uargs);
> >  }
> >+
> >+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> >+long seccomp_get_filter(struct task_struct *task, long n, void __user *data)
> >+{
> >+	struct seccomp_filter *filter;
> >+	struct sock_fprog_kern *fprog;
> >+	long ret;
> >+
> >+	if (n < 0)
> >+		return -EINVAL;
> 
> I would probably give 'n' a better name, maybe 'filter_off' to denote an
> offset in the task's filter list?

Ok, I can make that change.

> So, it's called as seccomp_get_filter(child, addr, datavp), and addr is
> an unsigned long in ptrace_request(). Any reasons why making this 'long n'
> with adding this above check?

No, I think just an oversight; I'll switch it to unsigned.

> >+	spin_lock_irq(&current->sighand->siglock);
> >+	if (!capable(CAP_SYS_ADMIN) ||
> 
> The capability check should probably happen before taking the task's spinlock.

We (probably) don't need the lock at all since we're just reading, but
seccomp_may_assign_mode() asserts that things are locked before it
checks current->seccomp.mode, so I lock here as well (and that's the
only reason to lock), so if we lock after, we don't need to lock at
all.

> >+	    current->seccomp.mode != SECCOMP_MODE_DISABLED) {
> >+		ret = -EACCES;
> >+		goto out_self;
> >+	}
> >+
> >+	spin_lock_irq(&task->sighand->siglock);
> >+	if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
> >+		ret = -EINVAL;
> >+		goto out_task;
> >+	}
> >+
> >+	filter = task->seccomp.filter;
> >+	while (n > 0 && filter) {
> >+		filter = filter->prev;
> >+		n--;
> >+	}
> >+
> >+	if (!filter) {
> >+		ret = -ENOENT;
> >+		goto out_task;
> >+	}
> >+
> >+	fprog = filter->prog->orig_prog;
> 
> You could add this check ...
> 
>   https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=93d08b6966cf730ea669d4d98f43627597077153
> 
> ... here as well, so we don't get surprises in future. ;)

Ok :). Then we need to bikeshed which error code, though. I proposed
EMEDIUMTYPE before, but I'm happy to use whatever.

Thanks for the review.

Tycho
