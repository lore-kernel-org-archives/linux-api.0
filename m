From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Wed, 10 Jun 2015 17:29:31 +0000
Message-ID: <20150610172931.GD4069@ubuntumail>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com>
 <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
 <20150610163149.GA5092@redhat.com>
 <CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
> On Wed, Jun 10, 2015 at 9:31 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 06/09, Andy Lutomirski wrote:
> >>
> >> On Tue, Jun 9, 2015 at 5:49 PM, Tycho Andersen
> >> >
> >> > @@ -556,6 +556,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> >> >         if (data & ~(unsigned long)PTRACE_O_MASK)
> >> >                 return -EINVAL;
> >> >
> >> > +       if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
> >
> > Well, we should do this if
> >
> >                         (data & O_SUSPEND) && !(flags & O_SUSPEND)
> >
> > or at least if
> >
> >                         (data ^ flags) & O_SUSPEND
> >
> >
> >> > +               if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> >> > +                   !config_enabled(CONFIG_SECCOMP))
> >> > +                       return -EINVAL;
> >> > +
> >> > +               if (!capable(CAP_SYS_ADMIN))
> >> > +                       return -EPERM;
> >>
> >> I tend to think that we should also require that current not be using
> >> seccomp.  Otherwise, in principle, there's a seccomp bypass for
> >> privileged-but-seccomped programs.
> >
> > Andy, I simply can't understand why do we need any security check at all.
> >
> > OK, yes, in theory we can have a seccomped CAP_SYS_ADMIN process, seccomp
> > doesn't filter ptrace, you hack that process and force it to attach to
> > another CAP_SYS_ADMIN/seccomped process, etc, etc... Looks too paranoid
> > to me.
> 
> I've sometimes considered having privileged processes I write fork and
> seccomp their child.  Of course, if you're allowing ptrace through
> your seccomp filter, you open a giant can of worms, but I think we
> should take the more paranoid approach to start and relax it later as

I really do intend to look at your old proposed tree for improving that...
have only done a once-over so far, though.

> needed.  After all, for the intended use of this patch, stuff will
> break regardless of what we do if the ptracer is itself seccomped.
> 
> I could be convinced that if the ptracer is outside seccomp then we
> shouldn't need the CAP_SYS_ADMIN check.  That would at least make this
> work in a user namespace.
> 
> >> > @@ -590,6 +590,10 @@ void secure_computing_strict(int this_syscall)
> >> >  {
> >> >         int mode = current->seccomp.mode;
> >> >
> >> > +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
> >> > +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> >> > +               return;
> >> > +
> >> >         if (mode == 0)
> >> >                 return;
> >> >         else if (mode == SECCOMP_MODE_STRICT)
> >> > @@ -691,6 +695,10 @@ u32 seccomp_phase1(struct seccomp_data *sd)
> >> >         int this_syscall = sd ? sd->nr :
> >> >                 syscall_get_nr(current, task_pt_regs(current));
> >> >
> >> > +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
> >> > +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> >> > +               return SECCOMP_PHASE1_OK;
> >> > +
> >>
> >> If it's not hard, it might still be nice to try to fold this into
> >> mode.  This code is rather hot.  If it would be a mess, then don't
> >> worry about it for now.
> >
> > IMO, this would be a mess ;) At least compared to this simple patch.
> >
> > Suppose we add SECCOMP_MODE_SUSPENDED. Not only this adds the problems
> > with detach if the tracer dies.
> >
> > We need to change copy_seccomp(). And it is not clear what should we
> > do if the child is traced too.
> >
> > We need to change prctl_set_seccomp() paths.
> >
> > And even the "tracee->seccomp.mode = SECCOMP_MODE_SUSPENDED" code needs
> > some locking even if the tracee is stopped, we need to avoid the races
> > with SECCOMP_FILTER_FLAG_TSYNC from other threads.
> >
> 
> Agreed.  Let's hold off until this becomes a problem (if it ever does).
> 
> --Andy
