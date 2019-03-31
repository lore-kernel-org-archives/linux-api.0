From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 07:52:28 -0700
Message-ID: <CAHk-=wiZ40LVjnXSi9iHLE_-ZBsWFGCgdmNiYZUXn1-V5YBg2g@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
 <CAHk-=wjka0W1g3asQp2H=5ot=kkS-Mp+Cx6KHr0rNkGFfCOLYA@mail.gmail.com>
 <CAHk-=wi1kQDVN22qv7M=bWU+CngZZXcPAMKCsDZMeuY3k2tkyg@mail.gmail.com>
 <20190331010716.GA189578@google.com> <CAG48ez387kGbD_dLqEbZ1U9rKFbfP0EF9cMVjQT6nwc9=Y9CNw@mail.gmail.com>
 <20190331040810.GB189578@google.com> <CAG48ez2gb94SqS30Ai4+VBHhnzBp5Po9_u00nMrvUW6Wqq6hPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2gb94SqS30Ai4+VBHhnzBp5Po9_u00nMrvUW6Wqq6hPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>, Christian Brauner <christian@brauner.io>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 9:47 PM Jann Horn <jannh@google.com> wrote:
>
> Sure, given a pidfd_clone() syscall, as long as the parent of the
> process is giving you a pidfd for it and you don't have to deal with
> grandchildren created by fork() calls outside your control, that
> works.

Don't do pidfd_clone() and pidfd_wait().

Both of those existing system calls already get a "flags" argument.
Just make a WPIDFD (for waitid) and CLONE_PIDFD (for clone) bit, and
make the existing system calls just take/return a pidfd.

Side note: we could (should?) also make the default maxpid just be
larger. It needs to fit in an 'int', but MAXINT instead of 65535 would
likely alreadt make a lot of these attacks harder.

There was some really old legacy reason why we actually limited it to
65535 originally.  It was old and crufty even back when..

               Linus

              Linus
