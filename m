From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH v3] seccomp: add ptrace options for suspend/resume
Date: Fri, 5 Jun 2015 16:06:19 -0600
Message-ID: <20150605220619.GI31599@hopstrocity>
References: <1433539312-3999-1-git-send-email-tycho.andersen@canonical.com>
 <20150605215208.GA27105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150605215208.GA27105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 05, 2015 at 11:52:08PM +0200, Oleg Nesterov wrote:
> Tycho,
> 
> I hate myself, but I have another nit ;) again, it is not that I think
> you should updtate the patch, just fyi...

No worries :)

> On 06/05, Tycho Andersen wrote:
> >
> > --- a/include/linux/seccomp.h
> > +++ b/include/linux/seccomp.h
> > @@ -95,4 +95,14 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
> >  	return;
> >  }
> >  #endif /* CONFIG_SECCOMP_FILTER */
> > +
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +extern bool may_suspend_seccomp(void);
> > +#else
> > +static inline bool may_suspend_seccomp(void)
> > +{
> > +	return false;
> > +}
> > +#endif
> 
> This looks wrong. There is no "extern may_suspend_seccomp()" if
> CONFIG_SECCOMP=n, kernel/seccomp.c is not compiled. So you need another
> ifdef(CONFIG_SECCOMP).
> 
> At the same time this does not matter and you do not need the dummy
> "inline" version at all:
> 
> > @@ -556,6 +557,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> >  	if (data & ~(unsigned long)PTRACE_O_MASK)
> >  		return -EINVAL;
> >  
> > +	if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
> > +		if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> > +		    !config_enabled(CONFIG_SECCOMP))
> > +			return -EINVAL;
> > +
> > +		if (!may_suspend_seccomp())
> > +			return -EPERM;
> 
> gcc will optimize out may_suspend_seccomp() unless both options are
> enabled.

Whoops, yes, you're right. I did build test in all the configurations
to catch stuff like this, but gcc was too smart for me. What's the
right thing to do, just leave out the definition of
may_suspend_seccomp all together, or add in another if defined() in
the header?

Maybe we will get rid of this pesky function all together though...

Tycho
