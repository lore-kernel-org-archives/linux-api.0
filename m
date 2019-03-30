From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 18:12:16 +0100
Message-ID: <20190330171215.3yrfxwodstmgzmxy@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io>
 <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagara>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 10:04:33AM -0700, Linus Torvalds wrote:
> On Sat, Mar 30, 2019 at 9:34 AM Daniel Colascione <dancol@google.com> wrote:
> >
> > Just to be clear, I'm not proposing granting secret access to procfs,
> > and as far as I can see, nobody else is either. We've been talking
> > about making it easier to avoid races when you happen to want a pidfd
> > and a procfs fd that point to the same process
> 
> So I thought that was the whole point of just opening /proc/<pid>.
> Exactly because that way you can then use openat() from there on.

To clarify, what the Android guys really wanted to be part of the api is
a way to get race-free access to metadata associated with a given pidfd.
And the idea was that *if and only if procfs is mounted* you could do:

int pidfd = pidfd_open(1234, 0);

int procfd = open("/proc", O_RDONLY | O_CLOEXEC);
int procpidfd = ioctl(pidfd, PIDFD_TO_PROCFD, procfd);

and then we internally verify that the struct pid that the pidfd is
refering to, is still the same as the one that /proc/<pid> is refering
to and only then do we return an fd for the process /proc/<pid>
directory which would then allow you to do, e.g.:

int statusfd = openat(procpidfd, "status", O_RDONLY | O_CLOEXEC);

this would provide race-free access to metadat but again, only if /proc
is mounted and available to the user. But if that's an instant NAK we
will definitely *not* do this.
