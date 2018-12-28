From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 RESEND] signal: add pidfd_send_signal() syscall
Date: Fri, 28 Dec 2018 15:20:12 -0800
Message-ID: <20181228152012.dbf0508c2508138efc5f2bbe@linux-foundation.org>
References: <20181228224853.26032-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181228224853.26032-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, keescook@chromium.org, jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Fri, 28 Dec 2018 23:48:53 +0100 Christian Brauner <christian@brauner.io> wrote:

> The kill() syscall operates on process identifiers (pid). After a process
> has exited its pid can be reused by another process. If a caller sends a
> signal to a reused pid it will end up signaling the wrong process. This
> issue has often surfaced and there has been a push to address this problem [1].
> 
> This patch uses file descriptors (fd) from proc/<pid> as stable handles on
> struct pid. Even if a pid is recycled the handle will not change. The fd
> can be used to send signals to the process it refers to.
> Thus, the new syscall pidfd_send_signal() is introduced to solve this
> problem. Instead of pids it operates on process fds (pidfd).

I can't see a description of what happens when the target process has
exited.  Is the task_struct pinned by the fd?  Does the entire procfs
directory remain visible?  Just one entry within it?  Does the pid
remain reserved?  Do attempts to signal that fd return errors? 
etcetera.  These behaviors should be described in the changelog and
manipulate please.

The code in signal.c appears to be compiled in even when
CONFIG_PROC_FS=y.  Can we add the appropriate ifdefs and an entry in
sys_ni.c?

A selftest in toole/testing/selftests would be nice.  And it will be
helpful to architecture maintainers as they wire this up.

The feature doesn't have its own Kconfig setting.  Perhaps it should?
It should presumably depend on PROC_FS.

I must say that I dislike the linkage to procfs.  procfs is a
high-level thing which is manipulated using syscalls.  To turn around
and make a syscall dependent upon the presence of procfs seems just ...
wrong.  Is there a cleaner way of obtaining the fd?  Another syscall
perhaps.

This fd-for-a-process sounds like a handy thing and people may well
think up other uses for it in the future, probably unrelated to
signals.  Are the code and the interface designed to permit such future
applications?  I guess "no" - it presently assumes that anything which
is written to that fd is a signal.  Perhaps there should be a tag at
the start of the message (which is what it is) which identifies the
message's type?

Now I think about it, why a new syscall?  This thing is looking rather
like an ioctl?
