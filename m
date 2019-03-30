From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 19:00:03 +0100
Message-ID: <CAG48ez0F0FLcp_cd_aBVxp+M9k6RJYzOqKCjnD+oUBvt8+VM2w@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io> <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Daniel Colascione <dancol@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 6:24 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Mar 30, 2019 at 10:12 AM Christian Brauner <christian@brauner.io> wrote:
> > To clarify, what the Android guys really wanted to be part of the api is
> > a way to get race-free access to metadata associated with a given pidfd.
> > And the idea was that *if and only if procfs is mounted* you could do:
> >
> > int pidfd = pidfd_open(1234, 0);
> >
> > int procfd = open("/proc", O_RDONLY | O_CLOEXEC);
> > int procpidfd = ioctl(pidfd, PIDFD_TO_PROCFD, procfd);
>
> And my claim is that this is three system calls - one of them very
> hacky - to just do
>
>     int pidfd = open("/proc/%d", O_PATH);
>
> and you're done. It acts as the pidfd _and_ the way to get the
> associated status files etc.
>
> So there is absolutely zero advantage to going through pidfd_open().
>
> No. No. No.
>
> So the *only* reason for "pidfd_open()" is if you don't have /proc in
> the first place. In which case the whole PIDFD_TO_PROCFD is bogus.

So if, in the future, there is some sort of "create a new task and
return an fd to it" syscall, do you think it should always return
pidfds, or do you think it should return fds to /proc if procfs is
available? And if it should return fds to /proc, does that mean that
this "create a task" API should take an extra argument with a file
descriptor to the procfs instance you want to use?
(This can't always be implemented easily in userspace on top of normal
clone(), because if you create a task without a termination signal -
like a thread -, its PID can be recycled under you.)
An API like this would have less complexity stuffed into a single
syscall if it always returns pidfds, and if you then actually want an
fd to procfs, you can do the conversion that requires specifying a
procfs instance separately.

Of course, if you think that we shouldn't add an API for
pidfd-to-procfs conversion before we have an API for
clone()-with-an-fd-retval, that's understandable.
