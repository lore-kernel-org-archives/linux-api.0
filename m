From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 09:48:43 -0700
Message-ID: <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325162052.28987-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, khlebnikov@yandex-team.ru, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, nagarathnam.muthusamy@oracle.com, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Joel Fernandes <joel@joelfernand>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 9:21 AM Christian Brauner <christian@brauner.io> wrote:
> The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> I quote Konstantins original patchset first that has already been acked and
> picked up by Eric before and whose functionality is preserved in this
> syscall. Multiple people have asked when this patchset will be sent in
> for merging (cf. [1], [2]). It has recently been revived by Nagarathnam
> Muthusamy from Oracle [3].
>
> The intention of the original translate_pid() syscall was twofold:
> 1. Provide translation of pids between pid namespaces
> 2. Provide implicit pid namespace introspection
>
> Both functionalities are preserved. The latter task has been improved
> upon though. In the original version of the pachset passing pid as 1
> would allow to deterimine the relationship between the pid namespaces.
> This is inherhently racy. If pid 1 inside a pid namespace has died it
> would report false negatives. For example, if pid 1 inside of the target
> pid namespace already died, it would report that the target pid
> namespace cannot be reached from the source pid namespace because it
> couldn't find the pid inside of the target pid namespace and thus
> falsely report to the user that the two pid namespaces are not related.
> This problem is simple to avoid. In the new version we simply walk the
> list of ancestors and check whether the namespace are related to each
> other. By doing it this way we can reliably report what the relationship
> between two pid namespace file descriptors looks like.
>
> Additionally, this syscall has been extended to allow the retrieval of
> pidfds independent of procfs. These pidfds can e.g. be used with the new
> pidfd_send_signal() syscall we recently merged. The ability to retrieve
> pidfds independent of procfs had already been requested in the
> pidfd_send_signal patchset by e.g. Andrew [4] and later again by Alexey
> [5]. A use-case where a kernel is compiled without procfs but where
> pidfds are still useful has been outlined by Andy in [6]. Regular
> anon-inode based file descriptors are used that stash a reference to
> struct pid in file->private_data and drop that reference on close.
>
> With this translate_pid() has three closely related but still distinct
> functionalities. To clarify the semantics and to make it easier for
> userspace to use the syscall it has:
> - gained a command argument and three commands clearly reflecting the
>   distinct functionalities (PIDCMD_QUERY_PID, PIDCMD_QUERY_PIDNS,
>   PIDCMD_GET_PIDFD).
> - been renamed to pidctl()

Having made these changes, you've built a general-purpose command
command multiplexer, not one operation that happens to be flexible.
The general-purpose command multiplexer is a common antipattern:
multiplexers make it hard to talk about different kernel-provided
operations using the common vocabulary we use to distinguish
kernel-related operations, the system call number. socketcall, for
example, turned out to be cumbersome for users like SELinux policy
writers. People had to do work work later to split socketcall into
fine-grained system calls. Please split the pidctl system call so that
the design is clean from the start and we avoid work later. System
calls are cheap.

Also, I'm still confused about how metadata access is supposed to work
for these procfs-less pidfs. If I use PIDCMD_GET_PIDFD on a process,
You snipped out a portion of a previous email in which I asked about
your thoughts on this question. With the PIDCMD_GET_PIDFD command in
place, we have two different kinds of file descriptors for processes,
one derived from procfs and one that's independent. The former works
with openat(2). The latter does not. To be very specific; if I'm
writing a function that accepts a pidfd and I get a pidfd that comes
from PIDCMD_GET_PIDFD, how am I supposed to get the equivalent of
smaps or oom_score_adj or statm for the named process in a race-free
manner?
