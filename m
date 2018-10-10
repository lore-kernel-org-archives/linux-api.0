From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from
 ptrace
Date: Wed, 10 Oct 2018 09:54:58 -0700
Message-ID: <20181010165458.GA5607@cisco>
References: <CAG48ez3zaqOXH_jHN8=+jXjOf3vhFyWUkM_6KLPi9T8HcQySeg@mail.gmail.com>
 <20181008162147.ubfxxsv2425l2zsp@brauner.io>
 <CAG48ez3O+wAkq+0yDfoMt73ybnCOEPpi3Mu-uF57_v=6hA8ZEw@mail.gmail.com>
 <20181008181815.pwnqxngj22mhm2vj@brauner.io>
 <CAG48ez3PEce4ynRnDk=yfsAOuFGH=YMmuf13CAxEt07Yjk3ZCw@mail.gmail.com>
 <20181009132850.fp6yne2vgmfpi27k@brauner.io>
 <CAG48ez2EV8Z=Egn7hNpXd86bHdvQhVxStqE1N=U2L2R7sA-gjg@mail.gmail.com>
 <CAHC9VhQfzJgG3i=Q8C+pGY2Lpr+2MRTwxgUWec_heGOecd=xRg@mail.gmail.com>
 <CAG48ez2hTBFwmA65FXv0zJjc0_wpc1S-uOBn1t+X=0vPH25YvQ@mail.gmail.com>
 <20181010153956.zzlatxdlcwolbs6k@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010153956.zzlatxdlcwolbs6k@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Paul Moore <paul@paul-moore.com>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, suda.akihiro@lab.ntt.co.jp, Oleg Nesterov <oleg@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 10, 2018 at 05:39:57PM +0200, Christian Brauner wrote:
> On Wed, Oct 10, 2018 at 05:33:43PM +0200, Jann Horn wrote:
> > On Wed, Oct 10, 2018 at 5:32 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Tue, Oct 9, 2018 at 9:36 AM Jann Horn <jannh@google.com> wrote:
> > > > +cc selinux people explicitly, since they probably have opinions on this
> > >
> > > I just spent about twenty minutes working my way through this thread,
> > > and digging through the containers archive trying to get a good
> > > understanding of what you guys are trying to do, and I'm not quite
> > > sure I understand it all.  However, from what I have seen, this
> > > approach looks very ptrace-y to me (I imagine to others as well based
> > > on the comments) and because of this I think ensuring the usual ptrace
> > > access controls are evaluated, including the ptrace LSM hooks, is the
> > > right thing to do.
> > 
> > Basically the problem is that this new ptrace() API does something
> > that doesn't just influence the target task, but also every other task
> > that has the same seccomp filter. So the classic ptrace check doesn't
> > work here.
> 
> Just to throw this into the mix: then maybe ptrace() isn't the right
> interface and we should just go with the native seccomp() approach for
> now.

Please no :).

I don't buy your arguments that 3-syscalls vs. one is better. If I'm
doing this setup with a new container, I have to do
clone(CLONE_FILES), do this seccomp thing, so that my parent can pick
it up again, then do another clone without CLONE_FILES, because in the
general case I don't want to share my fd table with the container,
wait on the middle task for errors, etc. So we're still doing a bunch
of setup, and it feels more awkward than ptrace, with at least as many
syscalls, and it only works for your children.

I don't mind leaving capable(CAP_SYS_ADMIN) for the ptrace() part,
though. So if that's ok, then I think we can agree :)

Tycho
