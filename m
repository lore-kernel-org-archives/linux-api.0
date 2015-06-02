From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 22:02:10 +0300
Message-ID: <556DFDB2.3050205@parallels.com>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com> <20150602182829.GA23449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150602182829.GA23449-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


>> +int suspend_seccomp(struct task_struct *task)
>> +{
>> +	int ret = -EACCES;
>> +
>> +	spin_lock_irq(&task->sighand->siglock);
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		goto out;
> 
> I am puzzled ;) Why do we need ->siglock? And even if we need it, why
> we can't check CAP_SYS_ADMIN lockless?
> 
> And I am not sure I understand why do we need the additional security
> check, but I leave this to you and Andy.
> 
> If you have the rights to trace this task, then you can do anything
> the tracee could do without the filtering.

I think _this_ check is required, otherwise the seccomp-ed task (in
filtered mode) fork-s a child, then this child ptrace-attach to parent
(allowed) then suspend its seccomd. And -- we have unpriviledged process 
de-seccomped.

-- Pavel
