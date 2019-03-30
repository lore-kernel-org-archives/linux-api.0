From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 17:50:20 +0000
Message-ID: <CAGLj2rHk5pPYg-uo4HjYQQkJJjM0ePohtLJr2TrucuOaU_skxw@mail.gmail.com>
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
Cc: Christian Brauner <christian@brauner.io>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagar>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 5:24 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Mar 30, 2019 at 10:12 AM Christian Brauner <christian@brauner.io> wrote:
> >
> >
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
>
> Yeah, yeah, if you want to avoid going through the pathname
> translation, that's one thing, but if that's your aim, then you again
> should also just admit that PIDFD_TO_PROCFD is disgusting and wrong,
> and you're basically saying "ok, I'm not going to do /proc at all".
>
> So I'm ok with the whole "simpler, faster, no-proc pidfd", but then it
> really has to be *SIMPLER* and *NO PROCFS*.
>

(Resending because accidently it wasn't a reply-all)

If you go with pidfd_open, that should also mean you remove the
ability to be able to use /proc/<PID> dir fds in pidfd_send_signal.

Otherwise the semantics are hairy: I can only pidfd_open a task
reachable from my active namespace, but somehow also be able to open a
pidfd if I happen to see someone's /proc in my mount namespace and
have the access to open it?

> PIDFD_TO_PROCFD violates *everything*.
>
>                       Linus
