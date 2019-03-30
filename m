From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 06:25:09 +0000
Message-ID: <CAGLj2rEtgiJfmKgo4bJvmBYp1Y5f1SELVfEu7Ayfi62zOAxjGQ@mail.gmail.com>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io>
 <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com>
 <20190327213404.pv4wqtkjbufkx36u@brauner.io> <CAGLj2rHpYAOGz0h0k2pS4JwFSQkMmRSUWxa4BtO+7BUMD21vdQ@mail.gmail.com>
 <20190327222543.huugotqcew6jyytv@brauner.io> <CAGLj2rG0Sbho6MnPSmcS73Xj=oG92E4W_QLRu4dD8NfweoUm5Q@mail.gmail.com>
 <20190328103813.eogszrqbitw3e7k7@brauner.io> <CAKOZueusdFurOb_uFZ3PDmZeJvYvHVKMx6=TpiWPERkKRiHfiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueusdFurOb_uFZ3PDmZeJvYvHVKMx6=TpiWPERkKRiHfiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyp>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 5:35 AM Daniel Colascione <dancol@google.com> wrote:
>
> On Thu, Mar 28, 2019 at 3:38 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > > All that said, thanks for the work on this once again. My intention is
> > > just that we don't end up with an API that could have been done better
> > > and be cleaner to use for potential users in the coming years.
> >
> > Thanks for your input on all of this. I still don't find multiplexers in
> > the style of seccomp()/fsconfig()/keyctl() to be a problem since they
> > deal with a specific task. They are very much different from ioctl()s in
> > that regard. But since Joel, you, and Daniel found the pidctl() approach
> > not very nice I dropped it. The interface needs to be satisfactory for
> > all of us especially since Android and other system managers will be the
> > main consumers.
>
> Thanks.
>
> > So let's split this into pidfd_open(pid_t pid, unsigned int flags) which
> > allows to cleanly get pidfds independent procfs and do the translation
> > to procpidfds in an ioctl() as we've discussed in prior threads. This
>
> I sustain my objection to adding an ioctl. Compared to a system call,
> an ioctl has a more rigid interface, greater susceptibility to
> programmer error (due to the same ioctl control code potentially doing
> different things for different file types), longer path length, and
> more awkward filtering/monitoring/auditing/tracing. We've discussed
> this issue at length before, and I thought we all agreed to use system
> calls, not ioctl, for core kernel functionality. So why is an ioctl
> suddenly back on the table? The way I see it, an ioctl has no
> advantages except for 1) conserving system call numbers, which are not
> scarce, and 2) avoiding the system call number coordination problem
> (and the coordination problem isn't a factor for core kernel code). I
> don't understand everyone's reluctance to add new system calls. What
> am I missing? Why would we give up all the advantages that a system
> call gives us?
>

I agree in general, but in this particular case a system call or an
ioctl doesn't matter much, all it does is take the pidfd, the command,
and /proc's dir fd.

If you start adding a system call for every specific operation on file
descriptors, it *will* become a problem. Besides, the translation is
just there because it is racy to do in userspace,  it is not some well
defined core kernel functionality. Therefore, it is just a way to
enter the kernel to do the openat in a race free and safe manner.

As is, the facility being provided through an ioctl on the pidfd is
not something I'd consider a problem. I think the translation stuff
should also probably be an extension of ioctl_ns(2) (but I wouldn't be
opposed if translate_pid is resurrected as is).

For anything more involved than ioctl(pidfd, PIDFD_TO_PROCFD,
procrootfd), I'd agree that a system call would be a cleaner
interface, otherwise, if you cannot generalise it, using ioctls as a
command interface is probably the better tradeoff here.

> I also don't understand Andy's argument on the other thread that an
> ioctl is okay if it's an "operation on an FD" --- *most* system calls
> are operations on FDs. We don't have an ioctl for sendmsg(2) and it's
> an "operation on an FD".
