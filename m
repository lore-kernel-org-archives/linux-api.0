From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 16:14:46 -0700
Message-ID: <CAKOZueuP3GNvvp_O0tTb0YgTeo17JRKRKRH_ztmqKZHtew85Bg@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <20190325201544.7o2kwuie3infcblp@brauner.io>
 <20190325211132.GA6494@google.com> <CAG48ez0K9xcSf28rXOy3k0dEL3b_4b-DfcdCO=JO7vVZeJoBcA@mail.gmail.com>
 <20190325214338.GA16969@google.com> <CAGLj2rEODAg+Y5D5Oxy3Gp-Yg6mqeisPnLQJ334TWSdrPW1L7A@mail.gmail.com>
 <CAKOZuetkCKKs7sWgDNL3R5GMyXyrjLf0VZsHvh92VmYkdQcBCA@mail.gmail.com> <CAGLj2rGi_+oh=qp=kK0fOq=AEKt5b9oHZXKCWvWPPEHPquOvSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rGi_+oh=qp=kK0fOq=AEKt5b9oHZXKCWvWPPEHPquOvSA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthus>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 3:37 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
>
> On Mon, Mar 25, 2019 at 10:07 PM Daniel Colascione <dancol@google.com> wrote:
> >
> > On Mon, Mar 25, 2019 at 2:55 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
> > >
> > > On Mon, Mar 25, 2019 at 9:43 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > >
> > > > On Mon, Mar 25, 2019 at 10:19:26PM +0100, Jann Horn wrote:
> > > > > On Mon, Mar 25, 2019 at 10:11 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > > >
> > > > > But often you don't just want to wait for a single thing to happen;
> > > > > you want to wait for many things at once, and react as soon as any one
> > > > > of them happens. This is why the kernel has epoll and all the other
> > > > > "wait for event on FD" APIs. If waiting for a process isn't possible
> > > > > with fd-based APIs like epoll, users of this API have to spin up
> > > > > useless helper threads.
> > > >
> > > > This is true. I almost forgot about the polling requirement, sorry. So then a
> > > > new syscall it is.. About what to wait for, that can be a separate parameter
> > > > to pidfd_wait then.
> > > >
> > >
> > > This introduces a time window where the process changes state between
> > > "get pidfd" and "setup waitfd", it would be simpler if the pidfd
> > > itself supported .poll and on termination the exit status was made
> > > readable from the file descriptor.
> >
> > I don't see a race here. Process state moves in one direction, so
> > there's no race. If you want the poll to end when a process exits and
> > the process exits before you poll, the poll should finish immediately.
> > If the process exits before you even create the polling FD, whatever
> > creates the polling FD can fail with ESRCH, which is what usually
> > happens when you try to do anything with a process that's gone. Either
> > way, whatever's trying to set up the poll knows the state of the
> > process and there's no possibility of a missed wakeup.
> >
>
> poll will possibly work and return immediately, but you won't be able
> to read back anything, because for the kernel there will be no waiter
> before you open one. If you make pidfd pollable and readable (for
> parents, as an example), the poll ends immediately but there will
> something to read from the fd.

You can lose exit status this way. That's not a problem, though,
because *without* synchronization between the exiting process and the
waiting process, the waiting process can lose the race no matter what,
and *with* synchronization, there's no change of losing the
information. (It's just like a condition variable.) Today,
synchronization between a parent and child is automatic (because
zombies), but direct children work reliably with pidfd too: the
descriptor that pidfd_clone (or whatever it ends up being called)
returns will *always* be created before the child process and so will
*always* have exit status information available, even with some
non-SIGCHLD option applied.

> > > Further, in the clone4 patchset, there was a mechanism to autoreap
> > > such a process so that it does not interfere with waiting a process
> > > does normally. How do you intend to handle this case if anyone except
> > > the parent is wanting to *wait* on the process (a second process,
> > > without reaping, so as to not disrupt any waiting in the parent), and
> > > for things like libraries that finally can manage their own set of
> > > process when pidfd_clone is added, by excluding this process from the
> > > process's normal wait handling logic.
> >
> > I think that discussion is best had around pidfd_clone. pidfd waiting
> > functionality shouldn't affect wait* in any way nor affect a zombie
> > transition or reaping.
>
> So this is more akin to waitfd and traditional wait* and friends, and
> a single notification fd for possibly multiple children?

I don't know what gave you this idea. I'm talking about a model in
which you wait for one child with one open file description.

> I just wanted
> to be sure one would (should) be able to use a pidfd obtained from
> pidfd_clone without affecting the existing waitfd, and other
> primitives.

I don't think the use of pidfd *waiting*, by itself, should affect the
current fork/wait/zombie model of process exit delivery. That is, by
default, a process should transition to the zombie state, send SIGCHLD
to its parent, and then get reaped at exactly the same times it does
today, with exactly the same semantics we have today. Pidfd waiting
should be an "add on".

> The same application's components should be able to host
> their own set of children using such an API (think libraries) and
> without affecting the process.

Agreed. To be clear, you're talking about something slightly different
from pure pidfd waiting. There should be some way to *create* a
process in such a way that it's not visible to wait(-1), doesn't
generate SIGCHLD, and so on. It would be great for libraries to create
and manage worker processes transparently, even in the presence of
some other thread sitting on wait(-1). I don't think the specific form
of this option affects how pidfd waiting works though. Do you?

> > > Moreover, should anyone except the parent process be allowed to open a
> > > readable pidfd (or waitfd), without additional capabilities?
> >
> > That's a separate discussion. See
> > https://lore.kernel.org/lkml/CAKOZueussVwABQaC+O9fW+MZayccvttKQZfWg0hh-cZ+1ykXig@mail.gmail.com/, where we talked about permissions extensively. Anyone can hammer on
> > /proc today or hammer on kill(pid, 0) to learn about a process
> > exiting, so anyone should be able to wait for a process to die --- it
> > just automates what anyone can do manually. What's left is the
> > question of who should be able to learn a process's exit code. As I
> > mentioned in the linked email, process exit codes are public on
> > FreeBSD, and the simplest option is to make them public in Linux too.
>
> People might be using them in ways that convey information between the
> parent and child something else shouldn't be able to know.

In theory, yes, there's an information leak. In practice, I don't
think that it actually matters. Can you think of a concrete security
hole that would be opened by allowing anyone to inspect process exit
status? Having thought of it, have you filed for a FreeBSD CVE? :-)
That is, I'd expect that any security hole *in practice* created by
allowing public inspection of error states would have already appeared
on systems that allow public notification of error states (since most
programs are portable), so I don't think there's a problem here in
practice.

I'd much rather make exit codes knowable publicly than not: declaring
that public exit status is public sidesteps a lot of weird setuid
issues --- see the thread I linked --- and makes things like pkill(1)
more useful --- because they could report whether a process died due
to the signal pkill sent or due to some other reason.

> They might
> be relying on this assumption that it is private. I don't think
> opening it up without requiring *some* privileges is safe.

/proc/pid/stat already reports exit codes to non-parents when 1) the
process whose stat is being read has exited but has not yet been
reaped, and 2) the reader would pass a ptrace(2) exit status on the
zombie (or would have, before the zombie became a zombie). A similar
model might work as a compromise option for us here: a policy of "as
broad as /proc/pid/stat" discloses no new information except in very
minor edge case of a child of a process with SIGCHLD set to SIG_IGN.

I would still prefer completely public status information for
simplicity and flexibility reasons though.

> Also, taking this further, if the structure being returned from a read
> isn't just the exit code but something more elaborate (you have
> mentioned siginfo previously), or even statistics like getrusage, I
> would be concerned if anyone except those with CAP_SYS_PTRACE or so
> should be able to obtain such a readable pidfd/waitfd.

It seems reasonable to provide different waiters with different levels
of access.
