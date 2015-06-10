From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Wed, 10 Jun 2015 18:31:49 +0200
Message-ID: <20150610163149.GA5092@redhat.com>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com> <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tycho Andersen <tycho.andersen@canonical.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On 06/09, Andy Lutomirski wrote:
>
> On Tue, Jun 9, 2015 at 5:49 PM, Tycho Andersen
> >
> > @@ -556,6 +556,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> >         if (data & ~(unsigned long)PTRACE_O_MASK)
> >                 return -EINVAL;
> >
> > +       if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {

Well, we should do this if

			(data & O_SUSPEND) && !(flags & O_SUSPEND)

or at least if

			(data ^ flags) & O_SUSPEND


> > +               if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> > +                   !config_enabled(CONFIG_SECCOMP))
> > +                       return -EINVAL;
> > +
> > +               if (!capable(CAP_SYS_ADMIN))
> > +                       return -EPERM;
>
> I tend to think that we should also require that current not be using
> seccomp.  Otherwise, in principle, there's a seccomp bypass for
> privileged-but-seccomped programs.

Andy, I simply can't understand why do we need any security check at all.

OK, yes, in theory we can have a seccomped CAP_SYS_ADMIN process, seccomp
doesn't filter ptrace, you hack that process and force it to attach to
another CAP_SYS_ADMIN/seccomped process, etc, etc... Looks too paranoid
to me.

But damn, I said many times that I won't argue ;)

> > @@ -590,6 +590,10 @@ void secure_computing_strict(int this_syscall)
> >  {
> >         int mode = current->seccomp.mode;
> >
> > +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
> > +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> > +               return;
> > +
> >         if (mode == 0)
> >                 return;
> >         else if (mode == SECCOMP_MODE_STRICT)
> > @@ -691,6 +695,10 @@ u32 seccomp_phase1(struct seccomp_data *sd)
> >         int this_syscall = sd ? sd->nr :
> >                 syscall_get_nr(current, task_pt_regs(current));
> >
> > +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
> > +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> > +               return SECCOMP_PHASE1_OK;
> > +
>
> If it's not hard, it might still be nice to try to fold this into
> mode.  This code is rather hot.  If it would be a mess, then don't
> worry about it for now.

IMO, this would be a mess ;) At least compared to this simple patch.

Suppose we add SECCOMP_MODE_SUSPENDED. Not only this adds the problems
with detach if the tracer dies.

We need to change copy_seccomp(). And it is not clear what should we
do if the child is traced too.

We need to change prctl_set_seccomp() paths.

And even the "tracee->seccomp.mode = SECCOMP_MODE_SUSPENDED" code needs
some locking even if the tracee is stopped, we need to avoid the races
with SECCOMP_FILTER_FLAG_TSYNC from other threads.

Oleg.
