From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Date: Sun, 16 Nov 2014 11:12:19 -0800
Message-ID: <20141116191219.GD5032@thin>
References: <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
 <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
 <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
 <87vbmfq1uw.fsf@x220.int.ebiederm.org>
 <20141116133230.GA32030@thunk.org>
 <CALCETrUPsH_So2Mgk38Fe_pjp5Y+cgjzCUe7fzFcnsFzivHeNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUPsH_So2Mgk38Fe_pjp5Y+cgjzCUe7fzFcnsFzivHeNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 16, 2014 at 07:42:30AM -0800, Andy Lutomirski wrote:
> On Sun, Nov 16, 2014 at 5:32 AM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> > On Sat, Nov 15, 2014 at 09:08:07PM -0600, Eric W. Biederman wrote:
> >>
> >> That may be a bug with the user namespace permission check.  Perhaps we
> >> shouldn't allow dropping groups that aren't mapped in the user
> >> namespace.
> >
> > I'm not saying that we can't change the behavior of whether or not a
> > user can drop a group permission.  I'm just saying that we need to do
> > so consciously.  The setgroups()/getgroups() ABI isn't part of
> > POSIX/SuSv3 so we wouldn't be breaking POSIX compatibility, for those
> > people who care about that.
> 
> It may make sense to reach out to some place like oss-security.
> 
> FWIW, I think we should ask, at the same time, about:
> 
>  - Dropping supplementary groups.
>  - Switching gid/egid/sgid to a supplementary group.
>  - Denying ptrace of a process with supplementary groups that the
> tracer doesn't have.

I wonder how crazy it would be to just require either CAP_SYS_PTRACE or
cred1 == cred2 (as in, you have *exactly* the same credentials as the
target)?

> Also, I much prefer a sysctl to a boot option.  Boot options are nasty
> to configure in many distributions.

Agreed.

- Josh Triplett
