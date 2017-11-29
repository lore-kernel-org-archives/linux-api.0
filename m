From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v4 2/4] vm: add a syscall to map a process memory into a
 pipe
Date: Tue, 28 Nov 2017 23:42:46 -0800
Message-ID: <20171129074245.GA32319@outlook.office365.com>
References: <1511767181-22793-1-git-send-email-rppt@linux.vnet.ibm.com>
 <1511767181-22793-3-git-send-email-rppt@linux.vnet.ibm.com>
 <20171127154249.39e60ecf72019216f2f1782d@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127154249.39e60ecf72019216f2f1782d-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 03:42:49PM -0800, Andrew Morton wrote:
> On Mon, 27 Nov 2017 09:19:39 +0200 Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > 
> > It is a hybrid of process_vm_readv() and vmsplice().
> > 
> > vmsplice can map memory from a current address space into a pipe.
> > process_vm_readv can read memory of another process.
> > 
> > A new system call can map memory of another process into a pipe.
> > 
> > ssize_t process_vmsplice(pid_t pid, int fd, const struct iovec *iov,
> >                         unsigned long nr_segs, unsigned int flags)
> > 
> > All arguments are identical with vmsplice except pid which specifies a
> > target process.
> > 
> > Currently if we want to dump a process memory to a file or to a socket,
> > we can use process_vm_readv() + write(), but it works slow, because data
> > are copied into a temporary user-space buffer.
> > 
> > A second way is to use vmsplice() + splice(). It is more effective,
> > because data are not copied into a temporary buffer, but here is another
> > problem. vmsplice works with the currect address space, so it can be
> > used only if we inject our code into a target process.
> > 
> > The second way suffers from a few other issues:
> > * a process has to be stopped to run a parasite code
> > * a number of pipes is limited, so it may be impossible to dump all
> >   memory in one iteration, and we have to stop process and inject our
> >   code a few times.
> > * pages in pipes are unreclaimable, so it isn't good to hold a lot of
> >   memory in pipes.
> > 
> > The introduced syscall allows to use a second way without injecting any
> > code into a target process.
> > 
> > My experiments shows that process_vmsplice() + splice() works two time
> > faster than process_vm_readv() + write().
> >
> > It is particularly useful on a pre-dump stage. On this stage we enable a
> > memory tracker, and then we are dumping  a process memory while a
> > process continues work. On the first iteration we are dumping all
> > memory, and then we are dumpung only modified memory from a previous
> > iteration.  After a few pre-dump operations, a process is stopped and
> > dumped finally. The pre-dump operations allow to significantly decrease
> > a process downtime, when a process is migrated to another host.
> 
> What is the overall improvement in a typical dumping operation?
> 
> Does that improvement justify the addition of a new syscall, and all
> that this entails?  If so, why?

In criu, we have a pre-dump operation, which is used to reduce a process
downtime during live migration of processes. The pre-dump operation
allows to dump memory without stopping processes. On the first
iteration, criu pre-dump dumps the whole memory of processes, on the
second iteration it saves only changed pages after the first pre-dump
and so on.

The primary goal here is to do this operation without a downtime of
processes, or as maximum this downtime has to be as small as possible.

Currently when we are doing pre-dump, we do next steps:

1. stop all processes by ptrace
2. inject a parasite code into each process to call vmsplice
3. read /proc/pid/pagemap and splice all dirty pages into pipes
4. reset the soft-dirty memory tracker
5. resume processes
6. splice memory from pipe to sockets

But this way has a few limitations:

1. We need to inject a parasite code into processes. This operation is
slow, and it requires to stop processes, so we can't do this step many
times. As result, we have to splice the whole memory to pipes at once.

2. A number of pipes are limited, and a size of each pipe is limited

A default limit for a number of file descriptors is 1024. šThe reliable
maximum pipe size is 3354624 bytes.

š š š š pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
š š š š š š š š š š š š š š šGFP_KERNEL_ACCOUNT);

so the maximum pipe size can be calculated by this formula:
(1 << PAGE_ALLOC_COSTLY_ORDER) * PAGE_SIZE / sizeof(struct
kernel_pipe_buffer)) * PAGE_SIZE)

This means that we can dump only 1.5 GB of memory.

The major issue of this way is that we need to inject a parasite code
and we can't do this many times, so we have to splice the whole memory
in one iteration.

With the introduced syscall, we are able to splice memory without a
parasite code and even without stopping processes, so we can dump memory
in a few iterations.

> 
> Are there any other applications of this syscall?
> 


For example, gdb can use it to generate a core file, it can splice
memory of a process into a pipe and then splice it from the pipe to a file.
This method works much faster than using PTRACE_PEEK* commands.

This syscall can be interesting for users of process_vm_readv(), in case
if they read memory to send it to somewhere else.

process_vmsplice() may be useful for debuggers from another side.
process_vmsplice() attaches a real process page to a pipe, so we can
splice it once and observe how it is being changed many times.

Thanks,
Andrei
