From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Wed, 10 Jun 2015 13:18:53 -0700
Message-ID: <CAGXu5jJovcC1S4OANpqbVe6e86xr4W9Y7897MsSDOpvEqezpnA@mail.gmail.com>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com>
	<CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
	<20150610163149.GA5092@redhat.com>
	<CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 10, 2015 at 10:20 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Wed, Jun 10, 2015 at 9:31 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 06/09, Andy Lutomirski wrote:
>>>
>>> On Tue, Jun 9, 2015 at 5:49 PM, Tycho Andersen
>>> >
>>> > @@ -556,6 +556,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>>> >         if (data & ~(unsigned long)PTRACE_O_MASK)
>>> >                 return -EINVAL;
>>> >
>>> > +       if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
>>
>> Well, we should do this if
>>
>>                         (data & O_SUSPEND) && !(flags & O_SUSPEND)
>>
>> or at least if
>>
>>                         (data ^ flags) & O_SUSPEND
>>
>>
>>> > +               if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
>>> > +                   !config_enabled(CONFIG_SECCOMP))
>>> > +                       return -EINVAL;
>>> > +
>>> > +               if (!capable(CAP_SYS_ADMIN))
>>> > +                       return -EPERM;
>>>
>>> I tend to think that we should also require that current not be using
>>> seccomp.  Otherwise, in principle, there's a seccomp bypass for
>>> privileged-but-seccomped programs.
>>
>> Andy, I simply can't understand why do we need any security check at all.
>>
>> OK, yes, in theory we can have a seccomped CAP_SYS_ADMIN process, seccomp
>> doesn't filter ptrace, you hack that process and force it to attach to
>> another CAP_SYS_ADMIN/seccomped process, etc, etc... Looks too paranoid
>> to me.
>
> I've sometimes considered having privileged processes I write fork and
> seccomp their child.  Of course, if you're allowing ptrace through
> your seccomp filter, you open a giant can of worms, but I think we
> should take the more paranoid approach to start and relax it later as
> needed.  After all, for the intended use of this patch, stuff will
> break regardless of what we do if the ptracer is itself seccomped.
>
> I could be convinced that if the ptracer is outside seccomp then we
> shouldn't need the CAP_SYS_ADMIN check.  That would at least make this
> work in a user namespace.

But not if that namespace is running under a manager that has added a
seccomp filter to do things like drop finit_module, as lxc does.

Let's start with CAP_SYS_ADMIN, and when we have an actual use-case,
we can change it then.

>
>>> > @@ -590,6 +590,10 @@ void secure_computing_strict(int this_syscall)
>>> >  {
>>> >         int mode = current->seccomp.mode;
>>> >
>>> > +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
>>> > +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
>>> > +               return;
>>> > +
>>> >         if (mode == 0)
>>> >                 return;
>>> >         else if (mode == SECCOMP_MODE_STRICT)
>>> > @@ -691,6 +695,10 @@ u32 seccomp_phase1(struct seccomp_data *sd)
>>> >         int this_syscall = sd ? sd->nr :
>>> >                 syscall_get_nr(current, task_pt_regs(current));
>>> >
>>> > +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
>>> > +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
>>> > +               return SECCOMP_PHASE1_OK;
>>> > +
>>>
>>> If it's not hard, it might still be nice to try to fold this into
>>> mode.  This code is rather hot.  If it would be a mess, then don't
>>> worry about it for now.
>>
>> IMO, this would be a mess ;) At least compared to this simple patch.
>>
>> Suppose we add SECCOMP_MODE_SUSPENDED. Not only this adds the problems
>> with detach if the tracer dies.
>>
>> We need to change copy_seccomp(). And it is not clear what should we
>> do if the child is traced too.
>>
>> We need to change prctl_set_seccomp() paths.
>>
>> And even the "tracee->seccomp.mode = SECCOMP_MODE_SUSPENDED" code needs
>> some locking even if the tracee is stopped, we need to avoid the races
>> with SECCOMP_FILTER_FLAG_TSYNC from other threads.
>>
>
> Agreed.  Let's hold off until this becomes a problem (if it ever does).

Arg, right, no. I don't want this represented in seccomp.mode. Way too
much would get touched for little benefit.

Thanks! And sorry Tycho as we all disagree about how to disagree with
your patch... :)

-- 
Kees Cook
Chrome OS Security
