From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Thu, 4 Jun 2015 11:10:43 -0700
Message-ID: <CAGXu5jLM8BSwXu8XU9d4QU7mQ=oOh=dYKY3_DcBa_zjrGpK7dQ@mail.gmail.com>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
	<CAGXu5jLBm6ZBptsDTrNV6OrFSwoZ__k3867-Ji+6oYuTQ8ncWQ@mail.gmail.com>
	<20150604180303.GA32421@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604180303.GA32421-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 4, 2015 at 11:03 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/04, Kees Cook wrote:
>>
>> On Wed, Jun 3, 2015 at 3:09 PM, Tycho Andersen
>> > @@ -556,6 +557,11 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>> >         if (data & ~(unsigned long)PTRACE_O_MASK)
>> >                 return -EINVAL;
>> >
>> > +#ifdef CONFIG_CHECKPOINT_RESTORE
>> > +       if (data & PTRACE_O_SUSPEND_SECCOMP && !may_suspend_seccomp())
>> > +               return -EPERM;
>> > +#endif
>>
>> I'd like to avoid seeing any #ifdefs added to the .c files. Using a
>> static inline for may_suspend_seccomp() should cause this statement to
>> be eliminated by the compiler.
>
> Agreed, me too, but see below.
>
>> > @@ -590,6 +590,11 @@ void secure_computing_strict(int this_syscall)
>> >  {
>> >         int mode = current->seccomp.mode;
>> >
>> > +#ifdef CONFIG_CHECKPOINT_RESTORE
>> > +       if (unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
>> > +               return;
>> > +#endif
>>
>> Could PT_SUSPEND_SECCOMP be defined to "0" with not
>> CONFIG_CHECKPOINT_RESTORE? Then this wouldn't need ifdefs, and should
>> be similarly eliminated by the compiler.
>
> Yes, but this way we add another ugly ifdef into .h, and if you read
> this code it is not clear that this check should be eliminated by gcc.
>
> I'd suggest
>
>         if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
>             unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
>                 return;

Ah! Yes, that makes things nicer.

-Kees

-- 
Kees Cook
Chrome OS Security
