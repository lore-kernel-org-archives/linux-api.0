From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Tue, 9 Oct 2018 07:28:33 -0700
Message-ID: <20181009142833.GA10149@cisco>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
 <20180927224839.GF15491@cisco.cisco.com>
 <20181008145803.ycawjwhc3mwkdogf@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181008145803.ycawjwhc3mwkdogf@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 08, 2018 at 04:58:05PM +0200, Christian Brauner wrote:
> On Thu, Sep 27, 2018 at 04:48:39PM -0600, Tycho Andersen wrote:
> > On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
> > > I have to say, I'm vaguely nervous about changing the semantics here
> > > for passing back the fd as the return code from the seccomp() syscall.
> > > Alternatives seem less appealing, though: changing the meaning of the
> > > uargs parameter when SECCOMP_FILTER_FLAG_NEW_LISTENER is set, for
> > > example. Hmm.
> > 
> > From my perspective we can drop this whole thing. The only thing I'll
> > ever use is the ptrace version. Someone at some point (I don't
> > remember who, maybe stgraber) suggested this version would be useful
> > as well.
> 
> So I think we want to have the ability to get an fd via seccomp().
> Especially, if we all we worry about are weird semantics. When we
> discussed this we knew the whole patchset was going to be weird. :)
> 
> This is a seccomp feature so seccomp should - if feasible - equip you
> with everything to use it in a meaningful way without having to go
> through a different kernel api. I know ptrace and seccomp are
> already connected but I still find this cleaner. :)
> 
> Another thing is that the container itself might be traced for some
> reason while you still might want to get an fd out.

Sure, I don't see the problem here.

> Also, I wonder what happens if you want to filter the ptrace() syscall
> itself? Then you'd deadlock?

No, are you confusing the tracee with the tracer here? Filtering
ptrace() will happen just like any other syscall... what would you
deadlock with?

> Also, it seems that getting an fd via ptrace requires CAP_SYS_ADMIN in
> the inital user namespace (which I just realized now) whereas getting
> the fd via seccomp() doesn't seem to.

Yep, I'll leave this discussion to the other thread.

Tycho
