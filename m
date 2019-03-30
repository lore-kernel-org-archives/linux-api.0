From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 17:59:34 +0000
Message-ID: <CAGLj2rEtNNs0BXHuGkjpT4seHuh=Lj79iVYP-n117+Dv+ThcJA@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io> <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <CAGLj2rHk5pPYg-uo4HjYQQkJJjM0ePohtLJr2TrucuOaU_skxw@mail.gmail.com> <20190330175241.4itdnx3tl5upzjxd@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190330175241.4itdnx3tl5upzjxd@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 5:52 PM Christian Brauner <christian@brauner.io> wrote:
>
> On Sat, Mar 30, 2019 at 05:50:20PM +0000, Jonathan Kowalski wrote:
> > On Sat, Mar 30, 2019 at 5:24 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Sat, Mar 30, 2019 at 10:12 AM Christian Brauner <christian@brauner.io> wrote:
> > > >
> > > >
> > > > To clarify, what the Android guys really wanted to be part of the api is
> > > > a way to get race-free access to metadata associated with a given pidfd.
> > > > And the idea was that *if and only if procfs is mounted* you could do:
> > > >
> > > > int pidfd = pidfd_open(1234, 0);
> > > >
> > > > int procfd = open("/proc", O_RDONLY | O_CLOEXEC);
> > > > int procpidfd = ioctl(pidfd, PIDFD_TO_PROCFD, procfd);
> > >
> > > And my claim is that this is three system calls - one of them very
> > > hacky - to just do
> > >
> > >     int pidfd = open("/proc/%d", O_PATH);
> > >
> > > and you're done. It acts as the pidfd _and_ the way to get the
> > > associated status files etc.
> > >
> > > So there is absolutely zero advantage to going through pidfd_open().
> > >
> > > No. No. No.
> > >
> > > So the *only* reason for "pidfd_open()" is if you don't have /proc in
> > > the first place. In which case the whole PIDFD_TO_PROCFD is bogus.
> > >
> > > Yeah, yeah, if you want to avoid going through the pathname
> > > translation, that's one thing, but if that's your aim, then you again
> > > should also just admit that PIDFD_TO_PROCFD is disgusting and wrong,
> > > and you're basically saying "ok, I'm not going to do /proc at all".
> > >
> > > So I'm ok with the whole "simpler, faster, no-proc pidfd", but then it
> > > really has to be *SIMPLER* and *NO PROCFS*.
> > >
> >
> > (Resending because accidently it wasn't a reply-all)
> >
> > If you go with pidfd_open, that should also mean you remove the
> > ability to be able to use /proc/<PID> dir fds in pidfd_send_signal.
> >
> > Otherwise the semantics are hairy: I can only pidfd_open a task
> > reachable from my active namespace, but somehow also be able to open a
>
> You can easily setns() to another pid namespace and get a pidfd there.
> That's how most namespace interactions work right now. We already had
> that discussion.

Only if it is a child namespace, or you have the relevant capabilities to setns.

Currently, if I just put a task in PID namespace, it can see /proc of
an ancestor PID namespace, and opendir /proc/<PID>, this is accepted
by pidfd_send_signal.

If you ever allow signalling across PID namespaces (because file
descriptors should be able to do that, they are not namespaced, see
files, sockets, etc), it will become a problem. Getting pidfds from
outside my active namespace should require userspace cooperation.

So, opening a pidfd should be limited to what *I* can see in my
namespace, like every other namespace. That is what a namespace is,
and PIDs have their own namespace, they're not exposed in the
filesystem namespace.
