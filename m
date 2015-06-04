From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Thu, 4 Jun 2015 15:05:29 -0600
Message-ID: <20150604210529.GJ3160@smitten>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
 <20150604183149.GA560@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150604183149.GA560@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Hi Oleg,

On Thu, Jun 04, 2015 at 08:31:49PM +0200, Oleg Nesterov wrote:
> On 06/03, Tycho Andersen wrote:
> >
> > @@ -556,6 +557,11 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> >  	if (data & ~(unsigned long)PTRACE_O_MASK)
> >  		return -EINVAL;
> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +	if (data & PTRACE_O_SUSPEND_SECCOMP && !may_suspend_seccomp())
> > +		return -EPERM;
> > +#endif
> > +
> 
> Well. This -EPERM doesn't look consistent...
> 
> if config_enabled(CONFIG_CHECKPOINT_RESTORE) == F, we return success
> but PTRACE_O_SUSPEND_SECCOMP has no effect because of another ifdef in
> seccomp.
>
> OTOH, if CONFIG_SECCOMP=n, this option has no effect too but we return
> -EPERM even.

Yes, something like:

if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
        if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
            !config_enabled(CONFIG_SECCOMP))
                return -EINVAL;

        if (!may_suspend_seccomp())
                return -EPERM;
}

I guess.

> Also. Suppose that the tracer sets SUSPEND_SECCOMP and then drops
> CAP_SYS_ADMIN. After that it can't set or clear other ptrace options.

Is this a case we're concerned about? I think this should be ok (i.e.
"don't do that" :).

> So if we really want the security checks (I still think we do not ;)
> then we should probably check "flags & SUSPEND_SECCOMP" as well.

Good point.

> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +bool may_suspend_seccomp(void)
> > +{
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return false;
> > +
> > +	if (current->seccomp.mode != SECCOMP_MODE_DISABLED)
> > +		return false;
> 
> Heh. OK, I won't argue with the new check too ;)

Actually now that I think about it I agree with you, these checks
don't seem necessary. Even inside a user namespace, if you can ptrace
a process you can make it do whatever you want irrespective of
seccomp, as long as it has the necessary capabilities. Once the
seccomp checks are run after ptrace, they'll be enforced so you
couldn't have it call whatever you want in the first place.

Still, perhaps I'm missing something...

Tycho
