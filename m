From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 09:08:31 -0700
Message-ID: <CAKOZues9uQyhOix2=NmWPFD3B7o7Fru+4PwDHODSAWZOsyyKNw@mail.gmail.com>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io>
 <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com>
 <20190327213404.pv4wqtkjbufkx36u@brauner.io> <CAGLj2rHpYAOGz0h0k2pS4JwFSQkMmRSUWxa4BtO+7BUMD21vdQ@mail.gmail.com>
 <20190327222543.huugotqcew6jyytv@brauner.io> <CAGLj2rG0Sbho6MnPSmcS73Xj=oG92E4W_QLRu4dD8NfweoUm5Q@mail.gmail.com>
 <20190328103813.eogszrqbitw3e7k7@brauner.io> <CAKOZueusdFurOb_uFZ3PDmZeJvYvHVKMx6=TpiWPERkKRiHfiw@mail.gmail.com>
 <CAGLj2rEtgiJfmKgo4bJvmBYp1Y5f1SELVfEu7Ayfi62zOAxjGQ@mail.gmail.com>
 <CAKOZuesjdfNptM9Pt_uzsDVefW6LXhHPHG2a3rJRAe0rpeWX6g@mail.gmail.com> <CAGLj2rGFOv-AcHSuxF2YBz=WKNi7iLGp3i5KzAq7E1fo14B9Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rGFOv-AcHSuxF2YBz=WKNi7iLGp3i5KzAq7E1fo14B9Lg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyp>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 7:30 AM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
>
> On Sat, Mar 30, 2019 at 7:39 AM Daniel Colascione <dancol@google.com> wrote:
> >
> >  [SNIP]
> >
> > Thanks again.
> >
> > I agree that the operation we're discussing has a simple signature,
> > but signature flexibility isn't the only reason to prefer a system
> > call over an ioctl. There are other reasons for preferring system
> > calls to ioctls (safety, tracing, etc.) that apply even if the
> > operation we're discussing has a relatively simple signature: for
> > example, every system call has a distinct and convenient ftrace event,
> > but ioctls don't; strace filtering Just Works on a
> > system-call-by-system-call basis, but it doesn't for ioctls; and
>
> It does for those with a unique number.

There's no such thing as a unique ioctl number though. Anyone is free
to create an ioctl with a conflicting number. Sure, you can guarantee
ioctl request number uniqueness within things that ship with the
kernel, but you can also guarantee system call number uniqueness, so
what do we gain by using an ioctl? And yes, you can do *some*
filtering based on ioctl command, but it's frequently more awkward
than the system call equivalent and sometimes doesn't work at all.
What's the strace -e pidfd_open equivalent for an ioctl? Grep isn't
quite equivalent.

> > documentation for system calls is much more discoverable (e.g., man
> > -k) than documentation for ioctls. Even if the distinction doesn't
> > matter much, IMHO, it still matters a little, enough to favor a system
> > call without an offsetting advantage for the ioctl option.
>
> It will be alongside other I/O operations in the pidfd man page.
>
> >
> > > If you start adding a system call for every specific operation on file
> > > descriptors, it *will* become a problem.
> >
> > I'm not sure what you mean. Do you mean that adding a top-level system
> > call for every operation that might apply to one specific kind of file
> > descriptor would lead, as the overall result, to the kernel having
> > enough system calls to cause negative consequences? I'm not sure I
> > agree, but accepting this idea for the sake of discussion: shouldn't
> > we be more okay with system calls for features present on almost all
> > systems --- like procfs --- even if we punt to ioctls very rarely-used
> > functionality, e.g., some hypothetical special squeak noise that you
> > could get some specific 1995 adlib clone to make?
>
> Consider if we were to do:
>
> int procpidfd_open(int pidfd, int procrootfd);
>
> This system call is useless besides a very specific operation for a
> very specific usecase on a file descriptor.

I don't understand this argument based on an operation being "very
specific". Are you suggesting that epoll_wait should have been an
ioctl? I don't see how an operation being specific to a type of file
descriptor is an argument for making that operation an ioctl instead
of a system call.

> Then, you figure you might
> want to support procpidfd back to pidfd (although YAGNI), so you will
> add a CMD or flags argument now,

Why would we need a system call at all? And why are we invoking
hypothetical argument B in an argument against adding operation A as a
system call? B doesn't exist yet. As Christian mentioned, we could
create a named /proc/pid/handle file which, when opened, would yield a
pidfd. More generally, though: if we expose new functionality, we can
make a new system call. Why is that worse than adding a new ioctl
code?

> int procpidfd_open(int pidfd, int procrootfd/procpidfd, unsigned int flags);
>
>   int procpidfd = procpidfd_open(fd, procrootfd, PIDFD_TO_PROCPIDFD);
>   int pidfd = procpidfd_open(-1, procpidfd, PROCPIDFD_TO_PIDFD);
>
> vs procpidfd2pidfd(int procpidfd); if you did not foresee the need.
> Then, you want pidfd2pid, and so on.
>
> If you don't, you will have to add a command interface in the new
> system call, which changes parameters depending on the flags. This is
> already starting to get ugly.

> In the end, it's a matter of taste,

I don't think it's quite a matter of taste. That idiom suggests that
the two options are roughly functionally equivalent. In this case,
there are clear and specific technical reasons to prefer system calls.
We're not talking about two equivalent approaches. Making the
operation a system call gives users more power, and we shouldn't
deprive them of this power without a good reason. So far, I haven't
seen such a reason.

>  this
> pattern if exploited leads to endless proliferation of the system call
> interface, often ridden with short-sighted APIs, because you cannot
> know if you want a focused call or a command style call.

Bad interfaces proliferate no matter what, and there's no difference
in support burden between an ioctl and a system call: both need to
work indefinitely. Are you saying that it's easier to remove a bad
interface if it's an ioctl instead of a system call? I don't recall
any precedent, but maybe I'm wrong.

> ioctl is
> already a command interface, and 10 system calls for each command is
> _NOT_ nice, from a user perspective.

syscall(2) is already a "command" interface, just with more automatic
features than ioctl. What do we gain by pushing the "command" down a
level from the syscall(2) multiplexer to the ioctl(2) multiplexer?

> > > Besides, the translation is
> > > just there because it is racy to do in userspace,  it is not some well
> > > defined core kernel functionality.
> > > Therefore, it is just a way to
> > > enter the kernel to do the openat in a race free and safe manner.
> >
> > I agree that the translation has to be done in the kernel, not
> > userspace, and that the kernel must provide to userspace some
> > interface for requesting that the translation happen: we're just
> > discussing the shape of this interface. Shouldn't all interfaces
> > provided by the kernel to userspace be equally well defined? I'm not
> > sure that the internal simplicity of the operation matters much
> > either. There are already explicit system calls for some
> > simple-to-implement things, e.g., timerfd_gettime. It's worth noting
> > that timerfd is (IIRC), like procfs, a feature that's both ubiquitous
> > and optional.
>
> It is well defined, it has a well defined signature, and it will error
> out if you don't use it properly. Again, what it does is very limited
> and niche. I am not sure it warrants a system call of its own.

Do we need to think in terms of whether a bit of functionality
"warrants" a system call? A system call is not expensive to add.
Instead of thinking of whether a function meets some bar for promotion
to a system call, we should be thinking of whether a function meets
the bar for demotion to ioctl. System calls are generally more useful
to users than ioctls, and all things being equal, creating an
interface more pleasant for users should be the priority.

> timerfd_gettime was an afterthought anyway, that's probably not a good
> example (it was more to just match the POSIX timers interface as the
> original timerfd never had support for querying, so the split into two
> steps, create and initialize, you could argue one could do it without
> a syscall, but it still has a well defined argument list, and
> accepting elaborate data structures into an ioctl is not a good
> interface to plumb, so that's easily justified).

TCGETS deals with an elaborate data structure.

In any case, I don't think the elaborate data structure argument is
relevant. The things that the system call mechanism lets you do that
the ioctl mechanism does not are independent of whether a system call
accepts simple or complex argument types. And ioctl and a system call
both specify a bit of kernel mode code to run: the difference is in
identifying that bit of kernel-side code to run and in the features
you get automatically through the call mechanism.

> It's much like socket and setsockopt/getsockopt in nature. I would
> even say APIs separating creation and configuration age well and are
> better, but a process doesn't fit such a model cleanly.
>
> > > As is, the facility being provided through an ioctl on the pidfd is
> > > not something I'd consider a problem.
> >
> > You're right that from a signature perspective, using an ioctl isn't a
> > problem. I just want to make sure we take into account the other,
> > non-signature advantages that system calls have over ioctls.
> >
> > > I think the translation stuff
> > > should also probably be an extension of ioctl_ns(2) (but I wouldn't be
> > > opposed if translate_pid is resurrected as is).
> > > For anything more involved than ioctl(pidfd, PIDFD_TO_PROCFD,
> > > procrootfd), I'd agree that a system call would be a cleaner
> > > interface, otherwise, if you cannot generalise it, using ioctls as a
> > > command interface is probably the better tradeoff here.
> >
> > Sure: I just want to better understand everyone else's thought process
> > here, having been frustrated with things like the termios ioctls being
> > ioctls.
>
> On that note, I don't buy the safety argument here, or the seccomp argument.
>
> You need to consider what this is, on a case by case basis.
>
> ioctl(pidfd, PIDFD_TO_PROCFD, procrootfd);
>
> See? You need /proc's root fd to be able to get to the /proc/<PID> dir
> fd, in a race free manner. You don't need to have the overhead of
> filtering to contain access, as privilege is bound to descriptors.

There's no filtering overhead when you haven't enabled filtering, right?

You seem to be making an argument that we should make this facility an
ioctl because we don't need the features that the system call
mechanism provides --- correct me if I'm wrong. Even if we can't see a
case for filtering or containment or tracing _today_, such a case
might arise in the future, as has happened many times before. Besides,
we haven't touched on the other features we get "for free" when we
make an operation a system call, e.g., explicit tracing support.  I
don't understand why we should forestall these uses cases, both
present and future, by using an ioctl instead of a system call,
especially when we get so little in return. I think there's a lot of
value in regularity and consistency and that making some operations
ioctls and some syscalls based on details like whether an operation
accepts a structure or a primitive makes the system less flexible and
understandable.

> [snip further discussion along the same lines]
