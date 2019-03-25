From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 22:37:25 +0000
Message-ID: <CAGLj2rGi_+oh=qp=kK0fOq=AEKt5b9oHZXKCWvWPPEHPquOvSA@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <20190325201544.7o2kwuie3infcblp@brauner.io>
 <20190325211132.GA6494@google.com> <CAG48ez0K9xcSf28rXOy3k0dEL3b_4b-DfcdCO=JO7vVZeJoBcA@mail.gmail.com>
 <20190325214338.GA16969@google.com> <CAGLj2rEODAg+Y5D5Oxy3Gp-Yg6mqeisPnLQJ334TWSdrPW1L7A@mail.gmail.com>
 <CAKOZuetkCKKs7sWgDNL3R5GMyXyrjLf0VZsHvh92VmYkdQcBCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetkCKKs7sWgDNL3R5GMyXyrjLf0VZsHvh92VmYkdQcBCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthus>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 10:07 PM Daniel Colascione <dancol@google.com> wrote:
>
> On Mon, Mar 25, 2019 at 2:55 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
> >
> > On Mon, Mar 25, 2019 at 9:43 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > On Mon, Mar 25, 2019 at 10:19:26PM +0100, Jann Horn wrote:
> > > > On Mon, Mar 25, 2019 at 10:11 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > >
> > > > But often you don't just want to wait for a single thing to happen;
> > > > you want to wait for many things at once, and react as soon as any one
> > > > of them happens. This is why the kernel has epoll and all the other
> > > > "wait for event on FD" APIs. If waiting for a process isn't possible
> > > > with fd-based APIs like epoll, users of this API have to spin up
> > > > useless helper threads.
> > >
> > > This is true. I almost forgot about the polling requirement, sorry. So then a
> > > new syscall it is.. About what to wait for, that can be a separate parameter
> > > to pidfd_wait then.
> > >
> >
> > This introduces a time window where the process changes state between
> > "get pidfd" and "setup waitfd", it would be simpler if the pidfd
> > itself supported .poll and on termination the exit status was made
> > readable from the file descriptor.
>
> I don't see a race here. Process state moves in one direction, so
> there's no race. If you want the poll to end when a process exits and
> the process exits before you poll, the poll should finish immediately.
> If the process exits before you even create the polling FD, whatever
> creates the polling FD can fail with ESRCH, which is what usually
> happens when you try to do anything with a process that's gone. Either
> way, whatever's trying to set up the poll knows the state of the
> process and there's no possibility of a missed wakeup.
>

poll will possibly work and return immediately, but you won't be able
to read back anything, because for the kernel there will be no waiter
before you open one. If you make pidfd pollable and readable (for
parents, as an example), the poll ends immediately but there will
something to read from the fd.

> > Further, in the clone4 patchset, there was a mechanism to autoreap
> > such a process so that it does not interfere with waiting a process
> > does normally. How do you intend to handle this case if anyone except
> > the parent is wanting to *wait* on the process (a second process,
> > without reaping, so as to not disrupt any waiting in the parent), and
> > for things like libraries that finally can manage their own set of
> > process when pidfd_clone is added, by excluding this process from the
> > process's normal wait handling logic.
>
> I think that discussion is best had around pidfd_clone. pidfd waiting
> functionality shouldn't affect wait* in any way nor affect a zombie
> transition or reaping.

So this is more akin to waitfd and traditional wait* and friends, and
a single notification fd for possibly multiple children? I just wanted
to be sure one would (should) be able to use a pidfd obtained from
pidfd_clone without affecting the existing waitfd, and other
primitives. The same application's components should be able to host
their own set of children using such an API (think libraries) and
without affecting the process.

>
> > Moreover, should anyone except the parent process be allowed to open a
> > readable pidfd (or waitfd), without additional capabilities?
>
> That's a separate discussion. See
> https://lore.kernel.org/lkml/CAKOZueussVwABQaC+O9fW+MZayccvttKQZfWg0hh-cZ+1ykXig@mail.gmail.com/, where we talked about permissions extensively. Anyone can hammer on
> /proc today or hammer on kill(pid, 0) to learn about a process
> exiting, so anyone should be able to wait for a process to die --- it
> just automates what anyone can do manually. What's left is the
> question of who should be able to learn a process's exit code. As I
> mentioned in the linked email, process exit codes are public on
> FreeBSD, and the simplest option is to make them public in Linux too.

People might be using them in ways that convey information between the
parent and child something else shouldn't be able to know. They might
be relying on this assumption that it is private. I don't think
opening it up without requiring *some* privileges is safe.

Also, taking this further, if the structure being returned from a read
isn't just the exit code but something more elaborate (you have
mentioned siginfo previously), or even statistics like getrusage, I
would be concerned if anyone except those with CAP_SYS_PTRACE or so
should be able to obtain such a readable pidfd/waitfd.
