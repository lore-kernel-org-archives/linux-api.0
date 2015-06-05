From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Fri, 5 Jun 2015 23:16:50 +0200
Message-ID: <20150605211650.GA25718@redhat.com>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com> <20150604183149.GA560@redhat.com> <20150604210529.GJ3160@smitten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150604210529.GJ3160@smitten>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho.andersen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Hi Tycho,

On 06/04, Tycho Andersen wrote:
>
> On Thu, Jun 04, 2015 at 08:31:49PM +0200, Oleg Nesterov wrote:
> > Also. Suppose that the tracer sets SUSPEND_SECCOMP and then drops
> > CAP_SYS_ADMIN. After that it can't set or clear other ptrace options.
>
> Is this a case we're concerned about? I think this should be ok (i.e.
> "don't do that" :).

Sure, I won't insist. Just this looks a bit confusing. I mean, if you
read this code it is not clear why may_suspend_seccomp() is called even
if the tracer changes other bits, and "data & PTRACE_O_SUSPEND" is true
only because the tracer does _not_ change this option.

IOW, imo the code will just look better if may_suspend_seccomp() is
called only when PTRACE_O_SUSPEND is set.  But this is minor, feel free
to ignore.

> > > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > > +bool may_suspend_seccomp(void)
> > > +{
> > > +	if (!capable(CAP_SYS_ADMIN))
> > > +		return false;
> > > +
> > > +	if (current->seccomp.mode != SECCOMP_MODE_DISABLED)
> > > +		return false;
> >
> > Heh. OK, I won't argue with the new check too ;)
>
> Actually now that I think about it I agree with you, these checks
> don't seem necessary. Even inside a user namespace, if you can ptrace
> a process you can make it do whatever you want irrespective of
> seccomp, as long as it has the necessary capabilities. Once the
> seccomp checks are run after ptrace, they'll be enforced so you
> couldn't have it call whatever you want in the first place.

Good ;)

> Still, perhaps I'm missing something...

Kees, Andy?

Oleg.
