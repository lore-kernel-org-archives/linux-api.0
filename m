From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2 4/4] samples: Add example of using PTRACE_GETFD in
 conjunction with user trap
Date: Tue, 10 Dec 2019 09:13:00 -0700
Message-ID: <20191210161300.GE22803@cisco>
References: <20191209070646.GA32477@ircssh-2.c.rugged-nimbus-611.internal>
 <20191209192959.GB10721@redhat.com>
 <BE3E056F-0147-4A00-8FF7-6CC9DE02A30C@ubuntu.com>
 <20191209204635.GC10721@redhat.com>
 <20191210111051.j5opodgjalqigx6q@wittgenstein>
 <CAMp4zn84YQHz62x-nxZFBgMEW9AiMt75q_rO83uaGg=YtyKV-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn84YQHz62x-nxZFBgMEW9AiMt75q_rO83uaGg=YtyKV-w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, cyphar@cyphar.com, Andy Lutomirski <luto@amacapital.net>, viro@zeniv.linux.org.uk, Jed Davis <jld@mozilla.com>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, Emilio Cobos =?iso-8859-1?Q?=C1lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 10, 2019 at 08:07:45AM -0800, Sargun Dhillon wrote:
> On Tue, Dec 10, 2019 at 3:10 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > [I'm expanding the Cc to a few Firefox and glibc people since we've been
> >  been talking about replacing SECCOMP_RET_TRAP with
> >  SECCOMP_RET_USER_NOTIF for a bit now because the useage of
> >  SECCOMP_RET_TRAP in the broker blocks desirable core glibc changes.
> >  Even if just for their lurking pleasure. :)]
> >
> > On Mon, Dec 09, 2019 at 09:46:35PM +0100, Oleg Nesterov wrote:
> > > On 12/09, Christian Brauner wrote
> > >
> > > I agree, and I won't really argue...
> > >
> > > but the changelog in 2/4 says
> > >
> > >       The requirement that the tracer has attached to the tracee prior to the
> > >       capture of the file descriptor may be lifted at a later point.
> > >
> > > so may be we should do this right now?
> >
> > I think so, yes. This doesn't strike me as premature optimization but
> > rather as a core design questions.
> >
> > >
> > > plus this part
> > >
> > >       @@ -1265,7 +1295,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
> > >               }
> > >
> > >               ret = ptrace_check_attach(child, request == PTRACE_KILL ||
> > >       -                                 request == PTRACE_INTERRUPT);
> > >       +                                 request == PTRACE_INTERRUPT ||
> > >       +                                 request == PTRACE_GETFD);
> > >
> > > actually means "we do not need ptrace, but we do not know where else we
> > > can add this fd_install(get_task_file()).
> >
> > Right, I totally get your point and I'm not a fan of this being in
> > ptrace() either.
> >
> > The way I see is is that the main use-case for this feature is the
> > seccomp notifier and I can see this being useful. So the right place to
> > plumb this into might just be seccomp and specifically on to of the
> > notifier.
> > If we don't care about getting and setting fds at random points of
> > execution it might make sense to add new options to the notify ioctl():
> >
> > #define SECCOMP_IOCTL_NOTIF_GET_FD      SECCOMP_IOWR(3, <sensible struct>)
> > #define SECCOMP_IOCTL_NOTIF_SET_FD      SECCOMP_IOWR(4, <sensible struct>)
> >
> > which would let you get and set fds while the supervisee is blocked.
> >
> > Christian
> Doesn't SECCOMP_IOCTL_NOTIF_GET_FD have some ambiguity to it?
> Specifically, because
> multiple processes can have the same notifier attached to them?

The id member corresponds to a particular syscall from a particular
pid, which makes it unique.

> If we
> choose to go down the
> route of introducing an ioctl (which I'm not at all opposed to), I
> would rather do it on pidfd. We
> can then plumb seccomp notifier to send pidfd instead of raw pid. In
> the mean time, folks
> can just open up /proc/${PID}, and do the check cookie dance.

This might be more generally useful, the problem is synchronization, I
guess.

Tycho
