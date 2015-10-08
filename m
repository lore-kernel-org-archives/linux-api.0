From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v6] seccomp, ptrace: add support for dumping seccomp filters
Date: Thu, 8 Oct 2015 10:39:36 -0700
Message-ID: <CAGXu5j+7G+jaUhFyMa8LO0wtwox7kZjOXeTLxBr04QsRw5ypcA@mail.gmail.com>
References: <1444211179-24925-1-git-send-email-tycho.andersen@canonical.com>
	<1444211179-24925-2-git-send-email-tycho.andersen@canonical.com>
	<5614F323.9050805@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5614F323.9050805-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 7, 2015 at 3:25 AM, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org> wrote:
> On 10/07/2015 11:46 AM, Tycho Andersen wrote:
>>
>> This patch adds support for dumping a process' (classic BPF) seccomp
>> filters via ptrace.
>>
>> PTRACE_SECCOMP_GET_FILTER allows the tracer to dump the user's classic BPF
>> seccomp filters. addr should be an integer which represents the ith
>> seccomp
>> filter (0 is the most recently installed filter). data should be a struct
>> sock_filter * with enough room for the ith filter, or NULL, in which case
>> the filter is not saved. The return value for this command is the number
>> of
>> BPF instructions the program represents, or negative in the case of
>> errors.
>> A command specific error is ENOENT, which indicates that there is no ith
>> filter in this seccomp tree.
>>
>> A caveat with this approach is that there is no way to get explicitly at
>> the heirarchy of seccomp filters, and users need to memcmp() filters to
>> decide which are inherited. This means that a task which installs two of
>> the same filter can potentially confuse users of this interface.
>>
>> Signed-off-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> CC: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> CC: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
>> CC: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> CC: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
>> ---
>>   include/linux/seccomp.h     | 11 +++++++++
>>   include/uapi/linux/ptrace.h |  2 ++
>>   kernel/ptrace.c             |  5 ++++
>>   kernel/seccomp.c            | 57
>> ++++++++++++++++++++++++++++++++++++++++++++-
>>   4 files changed, 74 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
>> index f426503..8861b5b 100644
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -95,4 +95,15 @@ static inline void get_seccomp_filter(struct
>> task_struct *tsk)
>>         return;
>>   }
>>   #endif /* CONFIG_SECCOMP_FILTER */
>> +
>> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
>> +extern long seccomp_get_filter(struct task_struct *task, long n,
>> +                              void __user *data);
>> +#else
>> +static inline long seccomp_get_filter(struct task_struct *task,
>> +                                     long n, void __user *data)
>> +{
>> +       return -EINVAL;
>
>
> Nit: -ENOTSUP would probably be the better choice? -EINVAL might just
> be confusing to users? (Would be unclear to them whether there's actual
> support of dumping or whether it's just an invalid argument.)

I'm not sure what the convention should be here. Calling ptrace with
bad args returns -EINVAL, so distinguishing the new command being
missing vs the new command have invalid argument isn't obvious. I
don't think this should return -ENOTSUP since then we only know we've
got a kernel that is new enough to know what PTRACE_SECCOMP_GET_FILTER
is but that it was built without CONFIG_SECCOMP_FILTER and
CONFIG_CHECKPOINT_RESTORE. That's a narrow error condition, so
probably we should stick to -EINVAL.

At least for seccomp, the "is this supported" test has been to send
almost bad arguments and get an EFAULT out of it. That tells you the
feature exists.

In this case, I think -EINVAL makes sense, but I could be talked out of it.

>> +}
>> +#endif /* CONFIG_SECCOMP_FILTER && CONFIG_CHECKPOINT_RESTORE */
>>   #endif /* _LINUX_SECCOMP_H */
>
> ...
>
>> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
>> index 787320d..b760bae 100644
>> --- a/kernel/ptrace.c
>> +++ b/kernel/ptrace.c
>> @@ -1016,6 +1016,11 @@ int ptrace_request(struct task_struct *child, long
>> request,
>>                 break;
>>         }
>>   #endif
>> +
>> +       case PTRACE_SECCOMP_GET_FILTER:
>> +               ret = seccomp_get_filter(child, addr, datavp);
>> +               break;
>> +
>>         default:
>>                 break;
>>         }
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 06858a7..c8a4564 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -347,6 +347,7 @@ static struct seccomp_filter
>> *seccomp_prepare_filter(struct sock_fprog *fprog)
>>   {
>>         struct seccomp_filter *sfilter;
>>         int ret;
>> +       bool save_orig = config_enabled(CONFIG_CHECKPOINT_RESTORE);
>>
>>         if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
>>                 return ERR_PTR(-EINVAL);
>> @@ -370,7 +371,7 @@ static struct seccomp_filter
>> *seccomp_prepare_filter(struct sock_fprog *fprog)
>>                 return ERR_PTR(-ENOMEM);
>>
>>         ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
>> -                                       seccomp_check_filter, false);
>> +                                       seccomp_check_filter, save_orig);
>>         if (ret < 0) {
>>                 kfree(sfilter);
>>                 return ERR_PTR(ret);
>> @@ -867,3 +868,57 @@ long prctl_set_seccomp(unsigned long seccomp_mode,
>> char __user *filter)
>>         /* prctl interface doesn't have flags, so they are always zero. */
>>         return do_seccomp(op, 0, uargs);
>>   }
>> +
>> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
>> +long seccomp_get_filter(struct task_struct *task, long n, void __user
>> *data)
>> +{
>> +       struct seccomp_filter *filter;
>> +       struct sock_fprog_kern *fprog;
>> +       long ret;
>> +
>> +       if (n < 0)
>> +               return -EINVAL;
>
>
> I would probably give 'n' a better name, maybe 'filter_off' to denote an
> offset in the task's filter list?
>
> So, it's called as seccomp_get_filter(child, addr, datavp), and addr is
> an unsigned long in ptrace_request(). Any reasons why making this 'long n'
> with adding this above check?
>
>> +       spin_lock_irq(&current->sighand->siglock);
>> +       if (!capable(CAP_SYS_ADMIN) ||
>
>
> The capability check should probably happen before taking the task's
> spinlock.

I don't have a strong opinion about this. Any races here are crazy
anyway, so I don't think there's a reason to optimize. I'd probably be
conservative and leave the spin lock as-is.

>
>> +           current->seccomp.mode != SECCOMP_MODE_DISABLED) {
>> +               ret = -EACCES;
>> +               goto out_self;
>> +       }
>> +
>> +       spin_lock_irq(&task->sighand->siglock);
>> +       if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
>> +               ret = -EINVAL;
>> +               goto out_task;
>> +       }
>> +
>> +       filter = task->seccomp.filter;
>> +       while (n > 0 && filter) {
>> +               filter = filter->prev;
>> +               n--;
>> +       }
>> +
>> +       if (!filter) {
>> +               ret = -ENOENT;
>> +               goto out_task;
>> +       }
>> +
>> +       fprog = filter->prog->orig_prog;
>
>
> You could add this check ...
>
>
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=93d08b6966cf730ea669d4d98f43627597077153
>
> ... here as well, so we don't get surprises in future. ;)

Oh yes, please. Gotta double-check !fprog.

>
>
>> +       ret = fprog->len;
>> +       if (!data)
>> +               goto out_task;
>> +
>> +       if (copy_to_user(data, fprog->filter, bpf_classic_proglen(fprog)))
>> {
>> +               ret = -EFAULT;
>> +               goto out_task;
>> +       }
>> +
>> +out_task:
>> +       spin_unlock_irq(&task->sighand->siglock);
>> +
>> +out_self:
>> +       spin_unlock_irq(&current->sighand->siglock);
>> +       return ret;
>> +}
>> +#endif
>>
>

-Kees

-- 
Kees Cook
Chrome OS Security
