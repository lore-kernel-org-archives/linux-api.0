From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 14:17:09 -0700
Message-ID: <CAKOZuevWPTuiGGcYiQoo2VJL-2mN1J9aPmR9gaCFy6uxJN24HQ@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <20190325201544.7o2kwuie3infcblp@brauner.io>
 <20190325211132.GA6494@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325211132.GA6494@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthus>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 2:11 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Mon, Mar 25, 2019 at 09:15:45PM +0100, Christian Brauner wrote:
> > On Mon, Mar 25, 2019 at 01:36:14PM -0400, Joel Fernandes wrote:
> > > On Mon, Mar 25, 2019 at 09:48:43AM -0700, Daniel Colascione wrote:
> > > > On Mon, Mar 25, 2019 at 9:21 AM Christian Brauner <christian@brauner.io> wrote:
> > > > > The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> > > > > I quote Konstantins original patchset first that has already been acked and
> > > > > picked up by Eric before and whose functionality is preserved in this
> > > > > syscall. Multiple people have asked when this patchset will be sent in
> > > > > for merging (cf. [1], [2]). It has recently been revived by Nagarathnam
> > > > > Muthusamy from Oracle [3].
> > > > >
> > > > > The intention of the original translate_pid() syscall was twofold:
> > > > > 1. Provide translation of pids between pid namespaces
> > > > > 2. Provide implicit pid namespace introspection
> > > > >
> > > > > Both functionalities are preserved. The latter task has been improved
> > > > > upon though. In the original version of the pachset passing pid as 1
> > > > > would allow to deterimine the relationship between the pid namespaces.
> > > > > This is inherhently racy. If pid 1 inside a pid namespace has died it
> > > > > would report false negatives. For example, if pid 1 inside of the target
> > > > > pid namespace already died, it would report that the target pid
> > > > > namespace cannot be reached from the source pid namespace because it
> > > > > couldn't find the pid inside of the target pid namespace and thus
> > > > > falsely report to the user that the two pid namespaces are not related.
> > > > > This problem is simple to avoid. In the new version we simply walk the
> > > > > list of ancestors and check whether the namespace are related to each
> > > > > other. By doing it this way we can reliably report what the relationship
> > > > > between two pid namespace file descriptors looks like.
> > > > >
> > > > > Additionally, this syscall has been extended to allow the retrieval of
> > > > > pidfds independent of procfs. These pidfds can e.g. be used with the new
> > > > > pidfd_send_signal() syscall we recently merged. The ability to retrieve
> > > > > pidfds independent of procfs had already been requested in the
> > > > > pidfd_send_signal patchset by e.g. Andrew [4] and later again by Alexey
> > > > > [5]. A use-case where a kernel is compiled without procfs but where
> > > > > pidfds are still useful has been outlined by Andy in [6]. Regular
> > > > > anon-inode based file descriptors are used that stash a reference to
> > > > > struct pid in file->private_data and drop that reference on close.
> > > > >
> > > > > With this translate_pid() has three closely related but still distinct
> > > > > functionalities. To clarify the semantics and to make it easier for
> > > > > userspace to use the syscall it has:
> > > > > - gained a command argument and three commands clearly reflecting the
> > > > >   distinct functionalities (PIDCMD_QUERY_PID, PIDCMD_QUERY_PIDNS,
> > > > >   PIDCMD_GET_PIDFD).
> > > > > - been renamed to pidctl()
> > > >
> > > [snip]
> > > > Also, I'm still confused about how metadata access is supposed to work
> > > > for these procfs-less pidfs. If I use PIDCMD_GET_PIDFD on a process,
> > > > You snipped out a portion of a previous email in which I asked about
> > > > your thoughts on this question. With the PIDCMD_GET_PIDFD command in
> > > > place, we have two different kinds of file descriptors for processes,
> > > > one derived from procfs and one that's independent. The former works
> > > > with openat(2). The latter does not. To be very specific; if I'm
> > > > writing a function that accepts a pidfd and I get a pidfd that comes
> > > > from PIDCMD_GET_PIDFD, how am I supposed to get the equivalent of
> > > > smaps or oom_score_adj or statm for the named process in a race-free
> > > > manner?
> > >
> > > This is true, that such usecase will not be supportable.  But the advantage
> > > on the other hand, is that suchs "pidfd" can be made pollable or readable in
> > > the future. Potentially allowing us to return exit status without a new
> > > syscall (?). And we can add IOCTLs to the pidfd descriptor which we cannot do
> > > with proc.
> > >
> > > But.. one thing we could do for Daniel usecase is if a /proc/pid directory fd
> > > can be translated into a "pidfd" using another syscall or even a node, like
> > > /proc/pid/handle or something. I think this is what Christian suggested in
> > > the previous threads.
> >
> > Andy - and Jann who I just talked to - have proposed solutions for this.
> > Jann's idea is similar to what you suggested, Joel. You could e.g. do an
> > ioctl() handler for /proc that would give you a dirfd back for a given
> > pidfd. The advantage is that pidfd_clone() can then give back pidfds
> > without having to care in what procfs the process is supposed to live.
> > That makes things a lot easier. But pidfds for the general case should
> > be anon inodes. It's clean, it's simple and it is way more secure.
>
> That makes sense to me, it is clean and I agree let us do that.
>
> Also for the "blocking on pid exit status" usecase, instead of adding a new
> syscall like pidfd_wait, lets just make that a new IOCTL to the

Please, no ioctls.

> file_operations of the anon_inode pidfd file. This will lets us specify
> exactly what to wait on (wait on death or wait on zombie) and lets us

I don't like per-open-file-description state. Ever try to set
O_NONBLOCK on standard input? It results in a broken terminal
configuration. pidfd wait mode would be similar. Processes and
intraprocess components share file descriptors all the time for
various reasons, and making the wait mode specific to the open file
description causes "spooky action at a distance" and bugs. If you need
a configurable wait mode, you should create a new open file
description that encodes that wait mode for its entire lifetime.

> avoid
> having a new syscall

Please stop using the "this lets us avoid making a new system call"
justification for interface design. System calls are cheap to add, and
going to lengths to avoid making a new system call frequently makes
interfaces worse in various ways.

> and create new fd just for waiting.

I think it's fine to make a new FD for waiting, especially if you only
need a new FD for a non-default wait mode.
