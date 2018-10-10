From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from
 ptrace
Date: Wed, 10 Oct 2018 19:15:02 +0200
Message-ID: <20181010171500.wh4yygmh7u6ynqid@brauner.io>
References: <20181008162147.ubfxxsv2425l2zsp@brauner.io>
 <CAG48ez3O+wAkq+0yDfoMt73ybnCOEPpi3Mu-uF57_v=6hA8ZEw@mail.gmail.com>
 <20181008181815.pwnqxngj22mhm2vj@brauner.io>
 <CAG48ez3PEce4ynRnDk=yfsAOuFGH=YMmuf13CAxEt07Yjk3ZCw@mail.gmail.com>
 <20181009132850.fp6yne2vgmfpi27k@brauner.io>
 <CAG48ez2EV8Z=Egn7hNpXd86bHdvQhVxStqE1N=U2L2R7sA-gjg@mail.gmail.com>
 <CAHC9VhQfzJgG3i=Q8C+pGY2Lpr+2MRTwxgUWec_heGOecd=xRg@mail.gmail.com>
 <CAG48ez2hTBFwmA65FXv0zJjc0_wpc1S-uOBn1t+X=0vPH25YvQ@mail.gmail.com>
 <20181010153956.zzlatxdlcwolbs6k@brauner.io>
 <20181010165458.GA5607@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010165458.GA5607@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Jann Horn <jannh@google.com>, Paul Moore <paul@paul-moore.com>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, suda.akihiro@lab.ntt.co.jp, Oleg Nesterov <oleg@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 10, 2018 at 09:54:58AM -0700, Tycho Andersen wrote:
> On Wed, Oct 10, 2018 at 05:39:57PM +0200, Christian Brauner wrote:
> > On Wed, Oct 10, 2018 at 05:33:43PM +0200, Jann Horn wrote:
> > > On Wed, Oct 10, 2018 at 5:32 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Tue, Oct 9, 2018 at 9:36 AM Jann Horn <jannh@google.com> wrote:
> > > > > +cc selinux people explicitly, since they probably have opinions on this
> > > >
> > > > I just spent about twenty minutes working my way through this thread,
> > > > and digging through the containers archive trying to get a good
> > > > understanding of what you guys are trying to do, and I'm not quite
> > > > sure I understand it all.  However, from what I have seen, this
> > > > approach looks very ptrace-y to me (I imagine to others as well based
> > > > on the comments) and because of this I think ensuring the usual ptrace
> > > > access controls are evaluated, including the ptrace LSM hooks, is the
> > > > right thing to do.
> > > 
> > > Basically the problem is that this new ptrace() API does something
> > > that doesn't just influence the target task, but also every other task
> > > that has the same seccomp filter. So the classic ptrace check doesn't
> > > work here.
> > 
> > Just to throw this into the mix: then maybe ptrace() isn't the right
> > interface and we should just go with the native seccomp() approach for
> > now.
> 
> Please no :).
> 
> I don't buy your arguments that 3-syscalls vs. one is better. If I'm
> doing this setup with a new container, I have to do
> clone(CLONE_FILES), do this seccomp thing, so that my parent can pick
> it up again, then do another clone without CLONE_FILES, because in the
> general case I don't want to share my fd table with the container,
> wait on the middle task for errors, etc. So we're still doing a bunch
> of setup, and it feels more awkward than ptrace, with at least as many
> syscalls, and it only works for your children.

You're talking about the case where you already have shot yourself in
the foot by blocking basically all other sensible ways of getting the fd
out.

Also, this was meant to show that parts of your initial justification
for implementing the ptrace() way of getting an fd doesn't really stand.
And it doesn't really. Even with ptrace() you can get into situations
where you're not able to get an fd. (see prior threads)

> 
> I don't mind leaving capable(CAP_SYS_ADMIN) for the ptrace() part,

Again, (prior threads) ptrace() or no ptrace() is something I do not
particularly care about as long as we have the
non-capable(CAP_SYS_ADMIN) seccomp() way of getting an fd out.

> though. So if that's ok, then I think we can agree :)
> 
> Tycho
