From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Wed, 27 Mar 2019 19:38:13 +0000
Message-ID: <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327162147.23198-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Christian,

Giving this some thought, it looks fine to me, but I am not convinced
this should take a pid argument. I much prefer if obtaining a pidfd
goes in the translation stuff, that has very real usecases, and you
would end up duplicating the same thing over in two places.

If the /proc/<PID> dir fd of a pidfd is relative to its procrootfd, a
pid's pidfd is also relative to its namespace. Currently, you change
things which would mean I now have to setns and spawn a child that
passes me back the pidfd for a pid in the said namespace.

I prefer Andy's version of

  int procrootfd = open("/proc", O_DIRECTORY | O_RDONLY);
  int procfd = pidfd_open(procrootfd, pidfd, PIDFD_TO_PROCFD); //name
this procfd_open, maybe

This is just a nicer race free openat.

But, Joel and you agreed that it makes sense to split out the
translation stuff out of pidfds.

My suggestion would be to extend ioctl_ns(2) then. It already provides
a (rather clumsy) mechanism to determine the relationship by comparing
st_dev and st_ino, which userspace can do itself for two namespace
descriptors. For translation, you can extend this namespace ioctl
(there is one to get a owner UID, you could add one to get a relative
PID).

Then, your pidfd call will be:

pidfd_open(pid_t pid, int ns, unsigned int flags);

You would also be able to compile out anything procfs related (include
the new API to procfs dir fd translation), otherwise, the way to open
pidfds is in this call, and without CONFIG_PROC_FS=Y, this is as good
as pidfd_open(pid_t pid) (of which a better version I propose above).
The new API should be its own thing, and the procfs translation tuple
its own thing, tied to the proc fs option. pidfds need not have any
relation to /proc.

For this procfd conversion system call, I would also lift any
namespace related restrictions if you are planning to, given the
constraint that I can only open a pidfd from an ancestor namespace
with the new pidfd_open system call, or acquire it through a
cooperative userspace process by fd passing otherwise, and I need the
/proc root fd, having both only permits me to open the said process's
/proc/<PID> dir fd subject to normal access restrictions. This means
the simplified procfd_open can be used to do metadata access without
even talking of PIDs at all, your process could live in its own world
and, given it has the authority to open the /proc directory, be able
to purely collect metadata based on the two file descriptors it is
given.

Once you have the restriction in the same call that allows you to open
a pidfd for an addressable PID from the given namespace fd, you can
finally remove the restriction to signal across namespaces once the
siginfo stuff is sorted out, as that will only work when you
explicitly push the fd into a sandbox, the process cannot get it out
of thin air on its own (and you already mentioned it has nothing to do
with security). What I do worry about is one can use NS_GET_PARENT
ioctl to get the parent pidns if the owning userns is the same, and
just passing that gives me back a pidfd for the task. **So, you might
want to add the constraint that the PID is actually reachable by the
current task as well, apart from being reachable in the passed in
namespace.**

Lastly, I also see no need of /proc/<PID> dir fd to pidfd conversion,
I would even recommend getting rid of that, so we only have one type
of pidfd, the anon inode one. What is the usecase behind that? It
would only be needed if you did not have a way to be able to metadata
access through a pidfd, which would be the case only prior to this
patch.

I think this would simplify a lot of things, and ioctl_ns(2) is
probably already the place to do comparison operations and query
operations on hierarichal namespaces, just adding the relative PID bit
will make it gain feature parity with translate_pid.
