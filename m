From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Sat, 13 Jun 2015 09:06:39 -0600
Message-ID: <20150613150639.GA8128@hopstrocity>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com>
 <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
 <20150610163149.GA5092@redhat.com>
 <CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw@mail.gmail.com>
 <CAGXu5jJovcC1S4OANpqbVe6e86xr4W9Y7897MsSDOpvEqezpnA@mail.gmail.com>
 <CALCETrUSjKVWoMM8aVeevAZRHqtiE7zOSUvjdW_yCBTnR07Ahg@mail.gmail.com>
 <CAGXu5jKD8nj-E87em6BqS_TAeca4-kqL2u7jqYFompzqPrvqfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKD8nj-E87em6BqS_TAeca4-kqL2u7jqYFompzqPrvqfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 12, 2015 at 04:29:00PM -0700, Kees Cook wrote:
> On Fri, Jun 12, 2015 at 4:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> > On Wed, Jun 10, 2015 at 1:18 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> >> On Wed, Jun 10, 2015 at 10:20 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> >>> On Wed, Jun 10, 2015 at 9:31 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >>>> On 06/09, Andy Lutomirski wrote:
> >>>>>
> >>>>> On Tue, Jun 9, 2015 at 5:49 PM, Tycho Andersen
> >>>>> >
> >>>>> > @@ -556,6 +556,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> >>>>> >         if (data & ~(unsigned long)PTRACE_O_MASK)
> >>>>> >                 return -EINVAL;
> >>>>> >
> >>>>> > +       if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
> >>>>
> >>>> Well, we should do this if
> >>>>
> >>>>                         (data & O_SUSPEND) && !(flags & O_SUSPEND)
> >>>>
> >>>> or at least if
> >>>>
> >>>>                         (data ^ flags) & O_SUSPEND
> >>>>
> >>>>
> >>>>> > +               if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> >>>>> > +                   !config_enabled(CONFIG_SECCOMP))
> >>>>> > +                       return -EINVAL;
> >>>>> > +
> >>>>> > +               if (!capable(CAP_SYS_ADMIN))
> >>>>> > +                       return -EPERM;
> >>>>>
> >>>>> I tend to think that we should also require that current not be using
> >>>>> seccomp.  Otherwise, in principle, there's a seccomp bypass for
> >>>>> privileged-but-seccomped programs.
> >>>>
> >>>> Andy, I simply can't understand why do we need any security check at all.
> >>>>
> >>>> OK, yes, in theory we can have a seccomped CAP_SYS_ADMIN process, seccomp
> >>>> doesn't filter ptrace, you hack that process and force it to attach to
> >>>> another CAP_SYS_ADMIN/seccomped process, etc, etc... Looks too paranoid
> >>>> to me.
> >>>
> >>> I've sometimes considered having privileged processes I write fork and
> >>> seccomp their child.  Of course, if you're allowing ptrace through
> >>> your seccomp filter, you open a giant can of worms, but I think we
> >>> should take the more paranoid approach to start and relax it later as
> >>> needed.  After all, for the intended use of this patch, stuff will
> >>> break regardless of what we do if the ptracer is itself seccomped.
> >>>
> >>> I could be convinced that if the ptracer is outside seccomp then we
> >>> shouldn't need the CAP_SYS_ADMIN check.  That would at least make this
> >>> work in a user namespace.
> >>
> >> But not if that namespace is running under a manager that has added a
> >> seccomp filter to do things like drop finit_module, as lxc does.
> >
> > In that case, criu isn't going to handle seccomp right regardless of
> > what our security check is, so I think we can safely deal with the
> > security aspects of that case once we figure out the functionality
> > part.
> >
> > IOW, I think I still like the direct "you must not be seccomped in
> > order to suspend seccomp" rule.
> 
> Adding that restriction would be fine by me.

Ok, I just sent v5 with this change. I didn't carry your ack in the
hopes that I could get you to take this patch in the seccomp tree. Let
me know if that's not the right thing to do.

Thanks,

Tycho
