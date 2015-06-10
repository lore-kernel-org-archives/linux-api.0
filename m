From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Wed, 10 Jun 2015 09:19:00 -0600
Message-ID: <20150610151900.GB10632@hopstrocity>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com>
 <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Tue, Jun 09, 2015 at 06:08:42PM -0700, Andy Lutomirski wrote:
>
> > +       if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
> > +               if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> > +                   !config_enabled(CONFIG_SECCOMP))
> > +                       return -EINVAL;
> > +
> > +               if (!capable(CAP_SYS_ADMIN))
> > +                       return -EPERM;
> 
> I tend to think that we should also require that current not be using
> seccomp.  Otherwise, in principle, there's a seccomp bypass for
> privileged-but-seccomped programs.  In any event, CRIU isn't going to
> work well if you run the restorer under seccomp, since it'll start
> nesting in a manner that probably isn't desirable.

Ok, I can resend with that. (sorry Oleg :)

> > +       }
> > +
> >         /* Avoid intermediate state when all opts are cleared */
> >         flags = child->ptrace;
> >         flags &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index 980fd26..645e42d 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
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

The part I'm not immediately clear on is what to do when the tracer
dies and the task is running. Oleg pointed out that we can't play with
TIF_SECCOMP (or we could, but restoring it in this case is
complicated), and I'm not sure if playing with ->seccomp.mode has any
similar complications. I /think/ it should be ok to just re-enable it,
but I'm not sure.

I'd like to leave this patch as is (modulo the extra check) for now.
I'm still looking at a way to export mode 2 filters, so there will
hopefully be more patches in this area soon and we can reexamine then.

Thanks for the review.

Tycho
