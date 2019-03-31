From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 16:33:48 +0100
Message-ID: <CAGLj2rELekFugPJ8OGH8wxFabmZ1UJBORwywpZrStKjohTF63A@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
 <CAHk-=wjka0W1g3asQp2H=5ot=kkS-Mp+Cx6KHr0rNkGFfCOLYA@mail.gmail.com>
 <CAHk-=wi1kQDVN22qv7M=bWU+CngZZXcPAMKCsDZMeuY3k2tkyg@mail.gmail.com>
 <20190331010716.GA189578@google.com> <CAG48ez387kGbD_dLqEbZ1U9rKFbfP0EF9cMVjQT6nwc9=Y9CNw@mail.gmail.com>
 <20190331040810.GB189578@google.com> <CAG48ez2gb94SqS30Ai4+VBHhnzBp5Po9_u00nMrvUW6Wqq6hPA@mail.gmail.com>
 <CAHk-=wiZ40LVjnXSi9iHLE_-ZBsWFGCgdmNiYZUXn1-V5YBg2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiZ40LVjnXSi9iHLE_-ZBsWFGCgdmNiYZUXn1-V5YBg2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>, Christian Brauner <christian@brauner.io>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 3:59 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Mar 30, 2019 at 9:47 PM Jann Horn <jannh@google.com> wrote:
> >
> > Sure, given a pidfd_clone() syscall, as long as the parent of the
> > process is giving you a pidfd for it and you don't have to deal with
> > grandchildren created by fork() calls outside your control, that
> > works.
>
> Don't do pidfd_clone() and pidfd_wait().
>
> Both of those existing system calls already get a "flags" argument.
> Just make a WPIDFD (for waitid) and CLONE_PIDFD (for clone) bit, and
> make the existing system calls just take/return a pidfd.

clone is out of flags, so there will have to be a new system call.

I am not sure about the waitid bit. Are you suggesting it takes a
pidfd and waits using it? I was thinking if we could make the pidfd
itself pollable and readable for exit status. At pidfd_open time, you
pass the flag and only if you're a parent you get a readable instance,
if not, a pollable one for everyone (eg. for an indirect child as a
reaper), and it fails for threads.

Then, the pidfd clone2 returns can also be polled and read from.

The main pain point is, currently when I ptrace from a thread a
process, I need to use waitpid (waitid throws away ptrace critical
information), and since ptrace works on a thread by thread basis, only
the attached thread can do the waitpid. This means I cannot do
anything else from the attached thread concurrently. waitfd was
supposed to solve this (back in 2009) but it never made it in, and
clone4 from Josh Triplett did something similar (returned exit status
over the clonefd).

FreeBSD's process descriptors are also pollable (which is where all
this work was originally inspired from) and it would help with
adoption if semantics were similar. Besides that, it would help
libraries to be able to host their own set of children without
affecting the entire process's waiting logic oe mucking with the
SIGCHLD handler (you wouldn't need signals).

>
> Side note: we could (should?) also make the default maxpid just be
> larger. It needs to fit in an 'int', but MAXINT instead of 65535 would
> likely alreadt make a lot of these attacks harder.
>
> There was some really old legacy reason why we actually limited it to
> 65535 originally.  It was old and crufty even back when..
>
>                Linus
>
>               Linus
