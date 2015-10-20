From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp filters
Date: Tue, 20 Oct 2015 13:26:01 -0700
Message-ID: <CAGXu5jLxioKseJ8TPyPqty1MwF5FMUsmkU3j=e66OZFCxFz53Q@mail.gmail.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
	<1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
	<20151020202024.GA5772@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151020202024.GA5772@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tycho.andersen@canonical.com>, Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 1:20 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/20, Tycho Andersen wrote:
>>
>> +long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
>> +                     void __user *data)
>> +{
>> +     struct seccomp_filter *filter;
>> +     struct sock_fprog_kern *fprog;
>> +     long ret;
>> +     unsigned long count = 0;
>> +
>> +     if (!capable(CAP_SYS_ADMIN) ||
>> +         current->seccomp.mode != SECCOMP_MODE_DISABLED) {
>> +             return -EACCES;
>> +     }
>> +
>> +     spin_lock_irq(&task->sighand->siglock);
>> +     if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
>> +             ret = -EINVAL;
>> +             goto out_task;
>> +     }
>> +
>> +     filter = task->seccomp.filter;
>> +     while (filter) {
>> +             filter = filter->prev;
>> +             count++;
>> +     }
>> +
>> +     if (filter_off >= count) {
>> +             ret = -ENOENT;
>> +             goto out_task;
>> +     }
>> +     count -= filter_off;
>> +
>> +     filter = task->seccomp.filter;
>> +     while (filter && count > 1) {
>> +             filter = filter->prev;
>> +             count--;
>> +     }
>> +
>> +     if (WARN_ON(count != 1)) {
>> +             /* The filter tree shouldn't shrink while we're using it. */
>> +             ret = -ENOENT;
>> +             goto out_task;
>> +     }
>> +
>> +     fprog = filter->prog->orig_prog;
>> +     if (!fprog) {
>> +             /* This must be a new non-cBPF filter, since we save every
>> +              * every cBPF filter's orig_prog above when
>> +              * CONFIG_CHECKPOINT_RESTORE is enabled.
>> +              */
>> +             ret = -EMEDIUMTYPE;
>> +             goto out_task;
>> +     }
>> +
>> +     ret = fprog->len;
>> +     if (!data)
>> +             goto out_task;
>> +
>> +     if (copy_to_user(data, fprog->filter, bpf_classic_proglen(fprog))) {
>> +             ret = -EFAULT;
>> +             goto out_task;
>> +     }
>
> Oh wait, I didn't notice this when I looked at v7.
>
> No, you can't do copy_to_user() from atomic context. You need to pin this
> filter, drop the lock/irq, then copy_to_user().

Which CONFIGs would yell about this? CONFIG_DEBUG_ATOMIC_SLEEP?

-Kees

-- 
Kees Cook
Chrome OS Security
