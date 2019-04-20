From: Christian Brauner <christian@brauner.io>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add CLONE_PIDFD]
Date: Sat, 20 Apr 2019 13:15:11 +0200
Message-ID: <D2514402-C7FA-4465-8B37-6C0579F4CD84@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io> <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net> <20190415195911.z7b7miwsj67ha54y@yavin> <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com> <20190420071406.GA22257@ip-172-31-15-78>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190420071406.GA22257@ip-172-31-15-78>
Sender: linux-kernel-owner@vger.kernel.org
To: Kevin Easton <kevin@guarana.org>, Andy Lutomirski <luto@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On April 20, 2019 9:14:06 AM GMT+02:00, Kevin Easton <kevin@guarana=2Eorg> =
wrote:
>On Mon, Apr 15, 2019 at 01:29:23PM -0700, Andy Lutomirski wrote:
>> On Mon, Apr 15, 2019 at 12:59 PM Aleksa Sarai <cyphar@cyphar=2Ecom>
>wrote:
>> >
>> > On 2019-04-15, Enrico Weigelt, metux IT consult <lkml@metux=2Enet>
>wrote:
>> > > > This patchset makes it possible to retrieve pid file
>descriptors at
>> > > > process creation time by introducing the new flag CLONE_PIDFD
>to the
>> > > > clone() system call as previously discussed=2E
>> > >
>> > > Sorry, for highjacking this thread, but I'm curious on what
>things to
>> > > consider when introducing new CLONE_* flags=2E
>> > >
>> > > The reason I'm asking is:
>> > >
>> > > I'm working on implementing plan9-like fs namespaces, where
>unprivileged
>> > > processes can change their own namespace at will=2E For that,
>certain
>> > > traditional unix'ish things have to be disabled, most notably
>suid=2E
>> > > As forbidding suid can be helpful in other scenarios, too, I
>thought
>> > > about making this its own feature=2E Doing that switch on clone()
>seems
>> > > a nice place for that, IMHO=2E
>> >
>> > Just spit-balling -- is no_new_privs not sufficient for this
>usecase?
>> > Not granting privileges such as setuid during execve(2) is the main
>> > point of that flag=2E
>> >
>>=20
>> I would personally *love* it if distros started setting no_new_privs
>> for basically all processes=2E  And pidfd actually gets us part of the
>> way toward a straightforward way to make sudo and su still work in a
>> no_new_privs world: su could call into a daemon that would spawn the
>> privileged task, and su would get a (read-only!) pidfd back and then
>> wait for the fd and exit=2E  I suppose that, done naively, this might
>> cause some odd effects with respect to tty handling, but I bet it's
>> solveable=2E  I suppose it would be nifty if there were a way for a
>> process, by mutual agreement, to reparent itself to an unrelated
>> process=2E
>>=20
>> Anyway, clone(2) is an enormous mess=2E  Surely the right solution here
>> is to have a whole new process creation API that takes a big,
>> extensible struct as an argument, and supports *at least* the full
>> abilities of posix_spawn() and ideally covers all the use cases for
>> fork() + do stuff + exec()=2E  It would be nifty if this API also had a
>> way to say "add no_new_privs and therefore enable extra functionality
>> that doesn't work without no_new_privs"=2E  This functionality would
>> include things like returning a future extra-privileged pidfd that
>> gives ptrace-like access=2E
>>=20
>> As basic examples, the improved process creation API should take a
>> list of dup2() operations to perform, fds to remove the O_CLOEXEC
>flag
>> from, fds to close (or, maybe even better, a list of fds to *not*
>> close), a list of rlimit changes to make, a list of signal changes to
>> make, the ability to set sid, pgrp, uid, gid (as in
>> setresuid/setresgid), the ability to do capset() operations, etc=2E=20
>The
>> posix_spawn() API, for all that it's rather complicated, covers a
>> bunch of the basics pretty well=2E
>
>The idea of a system call that takes an infinitely-extendable laundry
>list of operations to perform in kernel space seems quite inelegant, if
>only for the error-reporting reason=2E
>
>Instead, I suggest that what you'd want is a way to create a new
>embryonic process that has no address space and isn't yet schedulable=2E
>You then just need other-process-directed variants of all the normal
>setup functions - so pr_openat(pidfd, dirfd, pathname, flags, mode),
>pr_sigaction(pidfd, signum, act, oldact), pr_dup2(pidfd, oldfd, newfd)
>etc=2E
>
>Then when it's all set up you pr_execve() to kick it off=2E
>
>    - Kevin

I proposed a version of this a while back when we first started talking ab=
out this=2E
