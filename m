From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 08:21:39 -0700
Message-ID: <CAKOZues=PUZzKWoL10qiaLXgbDwE0YjygSdf4ZZSZHvOYMO=3w@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
 <CAHk-=wjka0W1g3asQp2H=5ot=kkS-Mp+Cx6KHr0rNkGFfCOLYA@mail.gmail.com>
 <CAHk-=wi1kQDVN22qv7M=bWU+CngZZXcPAMKCsDZMeuY3k2tkyg@mail.gmail.com>
 <20190331010716.GA189578@google.com> <CAG48ez387kGbD_dLqEbZ1U9rKFbfP0EF9cMVjQT6nwc9=Y9CNw@mail.gmail.com>
 <20190331040810.GB189578@google.com> <CAG48ez2gb94SqS30Ai4+VBHhnzBp5Po9_u00nMrvUW6Wqq6hPA@mail.gmail.com>
 <CAHk-=wiZ40LVjnXSi9iHLE_-ZBsWFGCgdmNiYZUXn1-V5YBg2g@mail.gmail.com> <20190331150507.zpyugdvtmr6rgpda@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190331150507.zpyugdvtmr6rgpda@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 8:05 AM Christian Brauner <christian@brauner.io> wrote:
>
> On Sun, Mar 31, 2019 at 07:52:28AM -0700, Linus Torvalds wrote:
> > On Sat, Mar 30, 2019 at 9:47 PM Jann Horn <jannh@google.com> wrote:
> > >
> > > Sure, given a pidfd_clone() syscall, as long as the parent of the
> > > process is giving you a pidfd for it and you don't have to deal with
> > > grandchildren created by fork() calls outside your control, that
> > > works.
> >
> > Don't do pidfd_clone() and pidfd_wait().
> >
> > Both of those existing system calls already get a "flags" argument.
> > Just make a WPIDFD (for waitid) and CLONE_PIDFD (for clone) bit, and
> > make the existing system calls just take/return a pidfd.
>
> Yes, that's one of the options I was considering but was afraid of
> pitching it because of the very massive opposition I got
> regarding"multiplexers". I'm perfectly happy with doing it this way.

This approach is fine by me, FWIW. I like it more than a general-purpose pidctl.

> Btw, the /proc/<pid> race issue that is mentioned constantly is simply
> avoidable by placing the pid that the pidfd has stashed relative to the
> callers' procfs mount's pid namespace in the pidfd's fdinfo. So there's
> not even a need to really go through /proc/<pid> in the first place. A
> caller wanting to get metadata access and avoid a race with pid
> recycling can then simply do:
>
> int pidfd = pidfd_open(pid, 0);
> int pid = parse_fdinfo("/proc/self/fdinfo/<pidfd>");
> int procpidfd = open("/proc/<pid>", ...);

IMHO, it's worth documenting this procedure in the pidfd man page.

> /* Test if process still exists by sending signal 0 through our pidfd. */

Are you planning on officially documenting this incantation in the
pidfd man page?

> int ret = pidfd_send_signal(pid, 0, NULL, PIDFD_SIGNAL_THREAD);
> if (ret < 0 && errno == ESRCH) {
>         /* pid has been recycled and procpidfd refers to another process */
> }

I was going to suggest that WNOHANG also works for this purpose, but
that idea raises another question: normally, you can wait*(2) on a
process only once. Are you imagining waitid on a pidfd succeeding more
than one? ISTM that the pidfd would need to internally store not just
a struct pid, but the exit status as well or some way to get to it.
