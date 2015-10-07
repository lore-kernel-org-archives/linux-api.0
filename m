From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v6] seccomp, ptrace: add support for dumping seccomp filters
Date: Wed, 07 Oct 2015 12:25:39 +0200
Message-ID: <5614F323.9050805@iogearbox.net>
References: <1444211179-24925-1-git-send-email-tycho.andersen@canonical.com> <1444211179-24925-2-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444211179-24925-2-git-send-email-tycho.andersen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho.andersen@canonical.com>, Kees Cook <keescook@chromium.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/07/2015 11:46 AM, Tycho Andersen wrote:
> This patch adds support for dumping a process' (classic BPF) seccomp
> filters via ptrace.
>
> PTRACE_SECCOMP_GET_FILTER allows the tracer to dump the user's classic BPF
> seccomp filters. addr should be an integer which represents the ith seccomp
> filter (0 is the most recently installed filter). data should be a struct
> sock_filter * with enough room for the ith filter, or NULL, in which case
> the filter is not saved. The return value for this command is the number of
> BPF instructions the program represents, or negative in the case of errors.
> A command specific error is ENOENT, which indicates that there is no ith
> filter in this seccomp tree.
>
> A caveat with this approach is that there is no way to get explicitly at
> the heirarchy of seccomp filters, and users need to memcmp() filters to
> decide which are inherited. This means that a task which installs two of
> the same filter can potentially confuse users of this interface.
>
> Signed-off-by: Tycho Andersen <tycho.andersen@canonical.com>
> CC: Kees Cook <keescook@chromium.org>
> CC: Will Drewry <wad@chromium.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> CC: Alexei Starovoitov <ast@kernel.org>
> CC: Daniel Borkmann <daniel@iogearbox.net>
> ---
>   include/linux/seccomp.h     | 11 +++++++++
>   include/uapi/linux/ptrace.h |  2 ++
>   kernel/ptrace.c             |  5 ++++
>   kernel/seccomp.c            | 57 ++++++++++++++++++++++++++++++++++++++++++++-
>   4 files changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index f426503..8861b5b 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -95,4 +95,15 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
>   	return;
>   }
>   #endif /* CONFIG_SECCOMP_FILTER */
> +
> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> +extern long seccomp_get_filter(struct task_struct *task, long n,
> +			       void __user *data);
> +#else
> +static inline long seccomp_get_filter(struct task_struct *task,
> +				      long n, void __user *data)
> +{
> +	return -EINVAL;

Nit: -ENOTSUP would probably be the better choice? -EINVAL might just
be confusing to users? (Would be unclear to them whether there's actual
support of dumping or whether it's just an invalid argument.)

> +}
> +#endif /* CONFIG_SECCOMP_FILTER && CONFIG_CHECKPOINT_RESTORE */
>   #endif /* _LINUX_SECCOMP_H */
...
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 787320d..b760bae 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1016,6 +1016,11 @@ int ptrace_request(struct task_struct *child, long request,
>   		break;
>   	}
>   #endif
> +
> +	case PTRACE_SECCOMP_GET_FILTER:
> +		ret = seccomp_get_filter(child, addr, datavp);
> +		break;
> +
>   	default:
>   		break;
>   	}
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 06858a7..c8a4564 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -347,6 +347,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
>   {
>   	struct seccomp_filter *sfilter;
>   	int ret;
> +	bool save_orig = config_enabled(CONFIG_CHECKPOINT_RESTORE);
>
>   	if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
>   		return ERR_PTR(-EINVAL);
> @@ -370,7 +371,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
>   		return ERR_PTR(-ENOMEM);
>
>   	ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
> -					seccomp_check_filter, false);
> +					seccomp_check_filter, save_orig);
>   	if (ret < 0) {
>   		kfree(sfilter);
>   		return ERR_PTR(ret);
> @@ -867,3 +868,57 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
>   	/* prctl interface doesn't have flags, so they are always zero. */
>   	return do_seccomp(op, 0, uargs);
>   }
> +
> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> +long seccomp_get_filter(struct task_struct *task, long n, void __user *data)
> +{
> +	struct seccomp_filter *filter;
> +	struct sock_fprog_kern *fprog;
> +	long ret;
> +
> +	if (n < 0)
> +		return -EINVAL;

I would probably give 'n' a better name, maybe 'filter_off' to denote an
offset in the task's filter list?

So, it's called as seccomp_get_filter(child, addr, datavp), and addr is
an unsigned long in ptrace_request(). Any reasons why making this 'long n'
with adding this above check?

> +	spin_lock_irq(&current->sighand->siglock);
> +	if (!capable(CAP_SYS_ADMIN) ||

The capability check should probably happen before taking the task's spinlock.

> +	    current->seccomp.mode != SECCOMP_MODE_DISABLED) {
> +		ret = -EACCES;
> +		goto out_self;
> +	}
> +
> +	spin_lock_irq(&task->sighand->siglock);
> +	if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
> +		ret = -EINVAL;
> +		goto out_task;
> +	}
> +
> +	filter = task->seccomp.filter;
> +	while (n > 0 && filter) {
> +		filter = filter->prev;
> +		n--;
> +	}
> +
> +	if (!filter) {
> +		ret = -ENOENT;
> +		goto out_task;
> +	}
> +
> +	fprog = filter->prog->orig_prog;

You could add this check ...

   https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=93d08b6966cf730ea669d4d98f43627597077153

... here as well, so we don't get surprises in future. ;)

> +	ret = fprog->len;
> +	if (!data)
> +		goto out_task;
> +
> +	if (copy_to_user(data, fprog->filter, bpf_classic_proglen(fprog))) {
> +		ret = -EFAULT;
> +		goto out_task;
> +	}
> +
> +out_task:
> +	spin_unlock_irq(&task->sighand->siglock);
> +
> +out_self:
> +	spin_unlock_irq(&current->sighand->siglock);
> +	return ret;
> +}
> +#endif
>
