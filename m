From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Wed, 3 Jun 2015 11:10:23 -0600
Message-ID: <20150603171023.GG3337@hopstrocity>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <20150602182829.GA23449@redhat.com>
 <20150603144303.GC3160@smitten>
 <20150603164121.GA19189@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150603164121.GA19189-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Oleg,

On Wed, Jun 03, 2015 at 06:41:21PM +0200, Oleg Nesterov wrote:
> On 06/03, Tycho Andersen wrote:
> >
> > On Tue, Jun 02, 2015 at 08:28:29PM +0200, Oleg Nesterov wrote:
> > > On 06/01, Tycho Andersen wrote:
> > > >
> > > > --- a/include/linux/seccomp.h
> > > > +++ b/include/linux/seccomp.h
> > > > @@ -25,6 +25,9 @@ struct seccomp_filter;
> > > >  struct seccomp {
> > > >  	int mode;
> > > >  	struct seccomp_filter *filter;
> > > > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > > > +	bool suspended;
> > > > +#endif
> > >
> > > Then afaics you need to change copy_seccomp() to clear ->suspended.
> > > At least if the child is not traced.
> >
> > Yes, thank you.
> 
> And if we really need to play with TIF_NOTSC, then copy_seccomp() should
> set it too if SUSPEND has cleared in parent's flags.
> 
> > > But why do we bother to play with TIF_NOTSC, could you explain?
> >
> > The procedure for restoring is to call seccomp suspend, restore the
> > seccomp filters (and potentially other stuff), and then resume them at
> > the end. If the other stuff happens to use RDTSC, the process gets
> > killed because TIF_NOTSC has been set.
> 
> This is clear, just I thought that CRIU doesn't use rdtsc on behalf of
> the traced task...

Unfortunately it does (I think to print timestamps in logs, although I
didn't look closely).

> > We can work around this in criu by doing the seccomp restore as the
> > very last thing before the final sigreturn,
> 
> Not sure I understand... You need to suspend at "dump" time too afaics,
> otherwise, say, syscall_seized() can fail because this syscall is nacked
> by seccomp?

Yes, but thankfully criu's dump code doesn't seem to use RDTSC, so it
just happens to work. Of course, if the dump code starts to use it,
we'll have to revisit this change.

> > but that seems like the
> > seccomp suspend API is incomplete, IMO. However, since both you and
> > Andy complained, perhaps I should remove it :)
> 
> Well, this is up to you ;)
> 
> But. Note that a process can also disable TSC via PR_SET_TSC. So if
> dump or restore can't work without enabling TSC you probably want to
> handle this case too.
> 
> And this makes me think that this needs a separate interface. I dunno.

I guess if we want to disable the TSC we need to save the state
irrespective of seccomp. I think I will ignore this for now, since we
can work around it in CRIU, and hope that we don't have to revisit it
because of the complexity r.e. tracer dying you mention below.

Tycho

> > > And I am not sure I understand why do we need the additional security
> > > check, but I leave this to you and Andy.
> >
> > Yes, it is required to prevent the case Pavel mentions (although there
> > are other ways to get around seccomp with ptrace, the goal here is to
> > not depend on that behavior so that when it is eventually fixed this
> > doesn't break).
> 
> I still do not think it makes any sense. again, if you can trace this
> process then you can disable the filtering anyway. Lets assume that
> seccomp_run_filters() acks, say, sys_getpid(). Or fork() in the case
> Pavel mentioned, this doesn't matter. Now you can force the tracee to
> call this syscall, then change syscall_nr.
>
> But as I said I won't argue, please forget.
>
> > Ok, this has changed slightly with the "always resume on
> > detach/unlink" change Pavel suggested,
> 
> To remind, it is not easy to restore TIF_NOTSC if the tracer dies.
> 
> PTRACE_DETACH can do this because the tracee can't be woken up. But
> personally I'd prefer the expicit RESUME request rather than "rely
> on PTRACE_DETACH".
> 
> If we avoid the TSC games, then, again, please consider
> PTRACE_O_SECCOMP_DISABLE. This will solve the problems with
> fork/detach/tracer-death automatically.
> 
> Oleg.
> 
