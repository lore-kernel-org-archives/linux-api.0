From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Tue, 9 Oct 2018 18:24:14 +0200
Message-ID: <20181009162413.sry5hnplvvpjggd4@brauner.io>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
 <20180927224839.GF15491@cisco.cisco.com>
 <20181008145803.ycawjwhc3mwkdogf@brauner.io>
 <20181009142833.GA10149@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009142833.GA10149@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 09, 2018 at 07:28:33AM -0700, Tycho Andersen wrote:
> On Mon, Oct 08, 2018 at 04:58:05PM +0200, Christian Brauner wrote:
> > On Thu, Sep 27, 2018 at 04:48:39PM -0600, Tycho Andersen wrote:
> > > On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
> > > > I have to say, I'm vaguely nervous about changing the semantics here
> > > > for passing back the fd as the return code from the seccomp() syscall.
> > > > Alternatives seem less appealing, though: changing the meaning of the
> > > > uargs parameter when SECCOMP_FILTER_FLAG_NEW_LISTENER is set, for
> > > > example. Hmm.
> > > 
> > > From my perspective we can drop this whole thing. The only thing I'll
> > > ever use is the ptrace version. Someone at some point (I don't
> > > remember who, maybe stgraber) suggested this version would be useful
> > > as well.
> > 
> > So I think we want to have the ability to get an fd via seccomp().
> > Especially, if we all we worry about are weird semantics. When we
> > discussed this we knew the whole patchset was going to be weird. :)
> > 
> > This is a seccomp feature so seccomp should - if feasible - equip you
> > with everything to use it in a meaningful way without having to go
> > through a different kernel api. I know ptrace and seccomp are
> > already connected but I still find this cleaner. :)
> > 
> > Another thing is that the container itself might be traced for some
> > reason while you still might want to get an fd out.
> 
> Sure, I don't see the problem here.

How'd you to PTRACE_ATTACH in that case?

Anyway, the whole point is as we've discusses in the other thread we
really want a one-syscall-only, purely-seccomp() based way of getting
the fd. There are multiple options to get the fd even when you block
sendmsg()/socket() whatever and there's no good reason to only be able
to get the fd via a three-syscall-ptrace dance. :)
