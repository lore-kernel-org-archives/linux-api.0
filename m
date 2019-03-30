From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 18:37:19 +0100
Message-ID: <20190330173718.hqopamhtxsq2l5bm@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io>
 <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io>
 <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagara>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 10:24:19AM -0700, Linus Torvalds wrote:
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

Understood.

> really has to be *SIMPLER* and *NO PROCFS*.
> 
> PIDFD_TO_PROCFD violates *everything*.
