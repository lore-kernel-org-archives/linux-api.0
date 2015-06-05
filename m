From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Fri, 5 Jun 2015 15:26:56 -0600
Message-ID: <20150605212656.GH31599@hopstrocity>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
 <20150604183149.GA560@redhat.com>
 <20150604210529.GJ3160@smitten>
 <20150605211650.GA25718@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150605211650.GA25718-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 05, 2015 at 11:16:50PM +0200, Oleg Nesterov wrote:
> Hi Tycho,
> 
> On 06/04, Tycho Andersen wrote:
> >
> > On Thu, Jun 04, 2015 at 08:31:49PM +0200, Oleg Nesterov wrote:
> > > Also. Suppose that the tracer sets SUSPEND_SECCOMP and then drops
> > > CAP_SYS_ADMIN. After that it can't set or clear other ptrace options.
> >
> > Is this a case we're concerned about? I think this should be ok (i.e.
> > "don't do that" :).
> 
> Sure, I won't insist. Just this looks a bit confusing. I mean, if you
> read this code it is not clear why may_suspend_seccomp() is called even
> if the tracer changes other bits, and "data & PTRACE_O_SUSPEND" is true
> only because the tracer does _not_ change this option.
> 
> IOW, imo the code will just look better if may_suspend_seccomp() is
> called only when PTRACE_O_SUSPEND is set.  But this is minor, feel free
> to ignore.

Oh, I understand now. I think this is fixed in v3 that I just sent,
but may go away in any case if we remove the checks...

> > > > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > > > +bool may_suspend_seccomp(void)
> > > > +{
> > > > +	if (!capable(CAP_SYS_ADMIN))
> > > > +		return false;
> > > > +
> > > > +	if (current->seccomp.mode != SECCOMP_MODE_DISABLED)
> > > > +		return false;
> > >
> > > Heh. OK, I won't argue with the new check too ;)
> >
> > Actually now that I think about it I agree with you, these checks
> > don't seem necessary. Even inside a user namespace, if you can ptrace
> > a process you can make it do whatever you want irrespective of
> > seccomp, as long as it has the necessary capabilities. Once the
> > seccomp checks are run after ptrace, they'll be enforced so you
> > couldn't have it call whatever you want in the first place.
> 
> Good ;)
> 
> > Still, perhaps I'm missing something...
> 
> Kees, Andy?

Doh, just sent v3. If you guys are convinced too, then I can send v4
with these checks removed.

Tycho
