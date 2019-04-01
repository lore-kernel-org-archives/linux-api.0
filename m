From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 11:03:24 +0100
Message-ID: <CAGLj2rHzS4=1OMv_q-t1+_nMd7q9EnDJAdOo=QzoHXwgcUZq+g@mail.gmail.com>
References: <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <20190331220259.qntxynluk765hpnt@brauner.io> <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
 <20190331223355.vfbnnkmevl63etvv@brauner.io> <CAG48ez0OnfkrEc5SmeaPpuv2aQ31kxkoFeaSVFwu7z1m=tN-9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0OnfkrEc5SmeaPpuv2aQ31kxkoFeaSVFwu7z1m=tN-9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 1:53 AM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Apr 1, 2019 at 12:33 AM Christian Brauner <christian@brauner.io> wrote:
> > On Sun, Mar 31, 2019 at 03:16:47PM -0700, Linus Torvalds wrote:
> > > On Sun, Mar 31, 2019 at 3:03 PM Christian Brauner <christian@brauner.io> wrote:
> > > > Thanks for the input. The problem Jann and I saw with this is that it
> > > > would be awkward to have the kernel open a file in some procfs instance,
> > > > since then userspace would have to specify which procfs instance the fd
> > > > should come from.
> > >
> > > I would actually suggest we just make the rules be that the
> > > pidfd_open() always return the internal /proc entry regardless of any
> > > mount-point (or any "hidepid") but also suggest that exactly *because*
> > > it gives you visibility into the target pid, you'd basically require
> > > the strictest kind of control of the process you're trying to get the
> > > pidfd of.
> > >
> > > Ie likely something along the lines of
> > >
> > >         ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS)

This then restricts the usage of the API under YAMA etc to processes
which have CAP_SYS_PTRACE or are parents wanting to manage their
children (which has worked fine for all these years anyway).

If they were just stable file descriptors referring to the process,
none of it would be a problem. You would just need normal permissions
when signalling using the pidfd (and depending on if you have CAP_KILL
in the owning userns, you could send any signal to it), ptrace
privileges when you use the pidfd with ptrace itself (suppose we
extend it to take a pidfd in the future, and it has a well established
model), so there is some separation of responsibilities. This is more
useful in general for userspace IMO.

All of the complication comes from the fact that we're trying to bind
a pid reference to also its /proc directory, and there's now another
way to get to that apart from the mount namespace, when there is
already a race free to do so yourself.

> >
> > I can live with that but I would like to hear what Jann thinks too if
> > that's ok.
>
> Ah, yes. That seems reasonable. And, as Linus said, pidfd_open() is
> less important if you can just do open("/proc/...") on systems with
> procfs instead.
>
> One minor detail to keep in mind for the future is that in a
> straightforward implementation of this concept, if a non-capable
> process is running in a mount namespace, but in the initial network
> namespace, without any reachable /proc mount, it will be able to look
> at information about other processes' network connections by first
> using pidfd_open() on itself or by using clone(CLONE_PIDFD), then
> looking at the "net" directory under the resulting file descriptor.
