From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 12:27:42 -0700
Message-ID: <CALCETrVYHYfogj3nTY-3ui87+tVi3mG3D4=Xdk-_MpisG8BczA@mail.gmail.com>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <20150602182829.GA23449@redhat.com> <556DFDB2.3050205@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <556DFDB2.3050205-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 2, 2015 at 12:02 PM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>
>>> +int suspend_seccomp(struct task_struct *task)
>>> +{
>>> +    int ret = -EACCES;
>>> +
>>> +    spin_lock_irq(&task->sighand->siglock);
>>> +
>>> +    if (!capable(CAP_SYS_ADMIN))
>>> +            goto out;
>>
>> I am puzzled ;) Why do we need ->siglock? And even if we need it, why
>> we can't check CAP_SYS_ADMIN lockless?
>>
>> And I am not sure I understand why do we need the additional security
>> check, but I leave this to you and Andy.
>>
>> If you have the rights to trace this task, then you can do anything
>> the tracee could do without the filtering.
>
> I think _this_ check is required, otherwise the seccomp-ed task (in
> filtered mode) fork-s a child, then this child ptrace-attach to parent
> (allowed) then suspend its seccomd. And -- we have unpriviledged process
> de-seccomped.

The interaction between ptrace and seccomp is already highly screwy,
and seccomp users can often escape using ptrace.  That being said, I'd
rather not further enshrine it.

It might be worth changing the check to verify that the task trying to
suspect seccomp isn't itself subject to seccomp.  That should get most
of the safety.  We are already kind of screwed if someone tries to run
criu under seccomp due to unresolved nesting issues.

--Andy
