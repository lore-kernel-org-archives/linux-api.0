From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Wed, 27 Mar 2019 22:12:36 +0000
Message-ID: <CAGLj2rHpYAOGz0h0k2pS4JwFSQkMmRSUWxa4BtO+7BUMD21vdQ@mail.gmail.com>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io>
 <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com> <20190327213404.pv4wqtkjbufkx36u@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327213404.pv4wqtkjbufkx36u@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 9:34 PM Christian Brauner <christian@brauner.io> wrote:
>
> On Wed, Mar 27, 2019 at 07:38:13PM +0000, Jonathan Kowalski wrote:
> > Christian,
> >
> > Giving this some thought, it looks fine to me, but I am not convinced
> > this should take a pid argument. I much prefer if obtaining a pidfd
>
> The signatures for pidfd_open() you're suggesting are conflicting. Even
> taking into account that you're referring to Andy's version

My version pidfd_open takes a pid, the pid namespace to search it in,
and has an optional flags value to extend it further in the future to
an immediate need. This is a simpler version of the pidctl's GET_PIDFD
command that you yourself proposed in the last patch, and you don't
need two namespace arguments, just one here (in that case you were
passing -1 in either of those anyway).

so pidctl(PIDCMD_GET_PIDFD, pid, source, -1, 0) becomes
pidfd_open(pid, source, 0);
pidctl(PIDCMD_GET_PIDFD, pid, -1, target or -1, 0) would be
pidfd_open(pid, -1, 0);

The target was just there due to it having to support
comparison/translation commands, but it did not serve much purpose
except the pid was reachable in both. I am not sure that is needed if
you just want a pidfd for pid relative to a namespace.

What I prefer is dropping the pid argument from *your* pidfd_open,
rename it to procfd/procpidfd_open to give it a clearer name, and have
the signature the same as what Andy suggested. This system call is
tied to CONFIG_PROC_FS, all it does is take a pidfd, a proc rootfd,
and return the /proc/<PID> dir fd. It is up to you if you want to
support procpidfd to pidfd conversion, I don't think there was any
usecase mentioned regarding that far, so you may just ignore it.

>
> int procfd = pidfd_open(procrootfd, pidfd, PIDFD_TO_PROCFD); //name
>
> the "not convinced this should take a pid argument" confuses me wrt to
> the proposed second signature:
>
> pidfd_open(pid_t pid, int ns, unsigned int flags);
>
> > goes in the translation stuff, that has very real usecases, and you
> > would end up duplicating the same thing over in two places.
> >
> > If the /proc/<PID> dir fd of a pidfd is relative to its procrootfd, a
> > pid's pidfd is also relative to its namespace. Currently, you change
>
> Pass a /proc/<pid> file descriptor that you have been given access to to
> pidfd_open() and retrieve a pidfd to that process.

It would be nice if it would be free of /proc entirely. The usecase
this system call is after is helping race free translation from pidfd
to procfd. pidfd_open as a separate system call as mentioned above
sounds much cleaner to me, and it works regardless of what /proc is
(compiled in, mounted, not compiled in, no access, etc).

>
> > things which would mean I now have to setns and spawn a child that
> > passes me back the pidfd for a pid in the said namespace.
>
> There are two scenarios:
> - you're in a cousin pid namespace
> - you're in an ancestor pid namespace
>
> If you're in an ancestor pid namespace you can just get a pidfd based on
> the pid of the process in your namespace. If you're in a cousin
> pid namespace it seems reasonable that you have to do a setns to get a
> pidfd. After all, you're not able to see any pids in there by default.
> If you want pidfd to a cousin pid namespace prove that you can access it
> by attaching to the owning user namespace of the pid namespace and get
> your pidfd.

Yes, but you break the part that you had working in the pidctl
patchset, I learn the pid of a process in a child pidns, and I am able
to get a pidfd for it with the pid relative to the passed in namespace
descriptor. You could even get a pidfd for an ancestor process, given
it explicitly gives you its namespace descriptor (or a cousin pidns,
but that still means userspace will pass the namespace descriptor
explicitly), but it is up to you if you want to limit its scope to
down the hierarchy strictly (and it would be nice to know now so that
you don't end up wasting more time later, and the next patchset is
hopefully the last one before merge modulo nits).

>
> >
> > I prefer Andy's version of
> >
> >   int procrootfd = open("/proc", O_DIRECTORY | O_RDONLY);
> >   int procfd = pidfd_open(procrootfd, pidfd, PIDFD_TO_PROCFD); //name
> > this procfd_open, maybe
> >
> > This is just a nicer race free openat.
> >
> > But, Joel and you agreed that it makes sense to split out the
> > translation stuff out of pidfds.
>
> I don't quite remember that part.
>
> I honestly think that the version proposed here covers for the most part
> what we want and provides a decent compromise by avoiding ioctl()s for
> the translation bits, allows us to not split this into multiple

I was not wanting to suggest an ioctl to burden you further, but it
occured to me that you would have to do less, as it already has
support to determine ownership and is meant for such tasks in
ioctl_ns(2), but I don't care if it's a translate_pid system call.

> syscalls, and also allows retrieving pidfds from other pid namespaces
> provided that one has gotten access to a file descriptor for
> /proc/<pid>. If really needed at some point - I doubt we will - you
> can extend pidfd_open() to take the flag CLONE_NEWPID:
>
> int pidfd = pidfd_open(pid, pid_ns_fd, -1, CLONE_NEWPID);
>
> and get pidfd for another pid namespace back.
>
> Christian
>
> >
> > My suggestion would be to extend ioctl_ns(2) then. It already provides
> > a (rather clumsy) mechanism to determine the relationship by comparing
> > st_dev and st_ino, which userspace can do itself for two namespace
> > descriptors. For translation, you can extend this namespace ioctl
> > (there is one to get a owner UID, you could add one to get a relative
> > PID).
> >
> > Then, your pidfd call will be:
> >
> > pidfd_open(pid_t pid, int ns, unsigned int flags);
> >
> > You would also be able to compile out anything procfs related (include
> > the new API to procfs dir fd translation), otherwise, the way to open
> > pidfds is in this call, and without CONFIG_PROC_FS=Y, this is as good
> > as pidfd_open(pid_t pid) (of which a better version I propose above).
> > The new API should be its own thing, and the procfs translation tuple
> > its own thing, tied to the proc fs option. pidfds need not have any
> > relation to /proc.
>
> They don't have a relation to procfs right now in this syscall. Works
> fine without procfs. That's the point.

Yes, but then you might as well put the translation thing to procfs in
its own system call, and take out pidctl's PIDCMD_GET_PIDFD in its
own, and keep the translate_pid system call as is from Eric's tree.

This gives you three clearly focused APIs:

procfd_open(int procrootfd, int pidfd, unsigned int flags);

pass in a /proc dir fd, and get back the /proc/<PID> dir fd of PID it
maps to, this a race free openat. That's it. flags could tell it to
give a thread's dir fd in the future. It only does translation (and
I'd like to know why the /proc/<PID> to pidfd translation is
necessary, is there a real use case? that will break the namespace
scoping you have in the current iteration of your patch too).

pidfd_open(pid_t pid, int nsfd, unsigned int flags);

Give me a pidfd for the pid relative to the namespace descriptor. It
is up to you if you want to strictly check that the current task has
this pid reachable from jts namespace, or rely on the fact that it
cannot acquire the namespace fd for a cousin or an ancestor without a
cooperating process that passes it in explicitly (again, would be nice
to know what others think about opening it up, i may be missing holes
in the swiss cheese that do allow you get hold of such a namespace
descriptor easily, in which case making it strictly down the hierarchy
is the most sensible).

and translate_pid

translate_pid(pid_t pid, int sourcens, int targetns, ...) as Konstantin had.


>
> >
> > For this procfd conversion system call, I would also lift any
> > namespace related restrictions if you are planning to, given the
> > constraint that I can only open a pidfd from an ancestor namespace
> > with the new pidfd_open system call, or acquire it through a
> > cooperative userspace process by fd passing otherwise, and I need the
> > /proc root fd, having both only permits me to open the said process's
> > /proc/<PID> dir fd subject to normal access restrictions. This means
> > the simplified procfd_open can be used to do metadata access without
> > even talking of PIDs at all, your process could live in its own world
> > and, given it has the authority to open the /proc directory, be able
> > to purely collect metadata based on the two file descriptors it is
> > given.
> >
> > Once you have the restriction in the same call that allows you to open
> > a pidfd for an addressable PID from the given namespace fd, you can
> > finally remove the restriction to signal across namespaces once the
> > siginfo stuff is sorted out, as that will only work when you
> > explicitly push the fd into a sandbox, the process cannot get it out
> > of thin air on its own (and you already mentioned it has nothing to do
> > with security). What I do worry about is one can use NS_GET_PARENT
> > ioctl to get the parent pidns if the owning userns is the same, and
> > just passing that gives me back a pidfd for the task. **So, you might
> > want to add the constraint that the PID is actually reachable by the
> > current task as well, apart from being reachable in the passed in
> > namespace.**
> >
> > Lastly, I also see no need of /proc/<PID> dir fd to pidfd conversion,
> > I would even recommend getting rid of that, so we only have one type
> > of pidfd, the anon inode one. What is the usecase behind that? It
> > would only be needed if you did not have a way to be able to metadata
> > access through a pidfd, which would be the case only prior to this
> > patch.
> >
> > I think this would simplify a lot of things, and ioctl_ns(2) is
> > probably already the place to do comparison operations and query
> > operations on hierarichal namespaces, just adding the relative PID bit
> > will make it gain feature parity with translate_pid.
