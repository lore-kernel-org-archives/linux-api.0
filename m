From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 15:16:47 -0700
Message-ID: <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
References: <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <20190331220259.qntxynluk765hpnt@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190331220259.qntxynluk765hpnt@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@red>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 3:03 PM Christian Brauner <christian@brauner.io> wrote:
>
> Thanks for the input. The problem Jann and I saw with this is that it
> would be awkward to have the kernel open a file in some procfs instance,
> since then userspace would have to specify which procfs instance the fd
> should come from.

I would actually suggest we just make the rules be that the
pidfd_open() always return the internal /proc entry regardless of any
mount-point (or any "hidepid") but also suggest that exactly *because*
it gives you visibility into the target pid, you'd basically require
the strictest kind of control of the process you're trying to get the
pidfd of.

Ie likely something along the lines of

        ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS)

kind of requirements.

But honestly, just how much do you need pidfd_open()? If this is
purely because somebody goes "oh, ASCII is expensive", then just stop
doing it entirely. It's not. It's fine. Going throuigh a filesystem is
a *good* thing, exactly because it allows MIS to control it.

So it's entirely possible that the right answer is: "just open
/proc/<pid>/", and accept the fact that everybody has it anyway, and
people who don't have it don't get the new functionality (with the
possible exception of clone(CLONE_PIDFD), which only gives you access
to a child you created yourself.

          Linus
