From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp
 filters
Date: Wed, 21 Oct 2015 15:33:06 -0600
Message-ID: <20151021213306.GF30729@hopstrocity>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
 <1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
 <20151020202024.GA5772@redhat.com>
 <20151020220814.GA3232@hopstrocity>
 <20151021185146.GA27176@redhat.com>
 <20151021191533.GD30729@hopstrocity>
 <20151021210756.GA641@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151021210756.GA641@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Oleg,

On Wed, Oct 21, 2015 at 11:07:56PM +0200, Oleg Nesterov wrote:
> On 10/21, Tycho Andersen wrote:
> >
> > Hi Oleg,
> >
> > On Wed, Oct 21, 2015 at 08:51:46PM +0200, Oleg Nesterov wrote:
> > > > +
> > > > +	if (WARN_ON(count != 1)) {
> > > > +		/* The filter tree shouldn't shrink while we're using it. */
> > > > +		ret = -ENOENT;
> > >
> > > Yes. but this looks a bit confusing. If we want this WARN_ON() check
> > > because we are paranoid, then we should do
> > >
> > > 	WARN_ON(count != 1 || filter);
> >
> > I guess you mean !filter here? We want filter to be non-null, because
> > we use it later.
> 
> Yes, yes, sorry for confusion. And (if we could race with shrink) it
> could be NULL so this paranoid check is not complete.

Yep, but you're right that we shouldn't be able to race, so it is
mostly unnecessary.

> > > And "while we're using it" look misleading, we rely on ->siglock.
> > >
> > > Plus if we could be shrinked the additional check can't help anyway,
> > > we can used the free filter. So I don't really understand this check
> > > and "filter != NULL" in the previous "while (filter && count > 1)".
> > > Nevermind...
> >
> > Just paranoia. You're right that we could get rid of WARN_ON and the
> > null check. I can send an updated patch to drop these bits if
> > necessary. Kees?
> 
> Just in case, I am fine either way, this is minor.
> 
> > > In short. Who can attach a filter without "save => true" ?
> >
> > There are two kinds of BPF programs, a "classic" instruction set, and
> > an "extended" one (which has more features, like maps, that seccomp
> > probably wants to use someday). Right now, the kernel only supports
> > adding filters via the classic interface, which saves the orig_prog
> > and then converts it into the "extended" instruction set for internal
> > use in the kernel. This ptrace command just dumps the classic
> > programs.
> 
> OK,
> 
> > In the future, if there exists a seccomp interface to add extended BPF
> > programs directly, they won't have an orig_prog, which will trigger
> > this error.
> 
> Hmm. It is not clear to me why this "new" interface won't or can't save
> orig_prog like we currently do. But this doesn't matter.

orig_prog is the classic BPF format, but if we import a program
directly from userspace as extended BPF, there was no classic to
convert from, so no concept of "original" program in that sense.

> If we know that currently this is not possible why should be confuse the
> reader? Can't we remove this code or turn it into WARN_ON(!orig_prog)
> to make it clear?

I guess to me it seems better to just future proof it, since we think
that this functionality may come soon, but I don't mind a WARN_ON
either.

> 
> And this leads to another question... If we expect that this interface
> can change later, then perhaps PTRACE_SECCOMP_GET_FILTER should also
> dump some header before copy_to_user(fprog->filter) ? Say, just
> "unsigned long version" == 0 for now. So that we can avoid
> PTRACE_SECCOMP_GET_FILTER_V2 in future.

So this is interesting. Like Kees mentioned, the bulk of the work
would be done by the bpf syscall. We'd still need some way to get
access to the fd itself, which we could (ab)use
PTRACE_SECCOMP_GET_FILTER for, by returning the fd + BPF_MAXINSNS (so
that it doesn't conflict with length) or something like that. Or add a
_V2 as you say. If there is some change we can make to have a nicer
interface than fd + BPF_MAXINSNS to future proof, I'm fine with making
it.

> Tycho, Kees, to clarify, it is not that I really think we should do this,
> up to you. I am just asking.

No problem, thanks for the reviews.

Tycho
