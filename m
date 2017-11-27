From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 2/4] vm: add a syscall to map a process memory into a
 pipe
Date: Mon, 27 Nov 2017 15:42:49 -0800
Message-ID: <20171127154249.39e60ecf72019216f2f1782d@linux-foundation.org>
References: <1511767181-22793-1-git-send-email-rppt@linux.vnet.ibm.com>
        <1511767181-22793-3-git-send-email-rppt@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511767181-22793-3-git-send-email-rppt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@virtuozzo.com>
List-Id: linux-api@vger.kernel.org

On Mon, 27 Nov 2017 09:19:39 +0200 Mike Rapoport <rppt@linux.vnet.ibm.com> wrote:

> From: Andrei Vagin <avagin@virtuozzo.com>
> 
> It is a hybrid of process_vm_readv() and vmsplice().
> 
> vmsplice can map memory from a current address space into a pipe.
> process_vm_readv can read memory of another process.
> 
> A new system call can map memory of another process into a pipe.
> 
> ssize_t process_vmsplice(pid_t pid, int fd, const struct iovec *iov,
>                         unsigned long nr_segs, unsigned int flags)
> 
> All arguments are identical with vmsplice except pid which specifies a
> target process.
> 
> Currently if we want to dump a process memory to a file or to a socket,
> we can use process_vm_readv() + write(), but it works slow, because data
> are copied into a temporary user-space buffer.
> 
> A second way is to use vmsplice() + splice(). It is more effective,
> because data are not copied into a temporary buffer, but here is another
> problem. vmsplice works with the currect address space, so it can be
> used only if we inject our code into a target process.
> 
> The second way suffers from a few other issues:
> * a process has to be stopped to run a parasite code
> * a number of pipes is limited, so it may be impossible to dump all
>   memory in one iteration, and we have to stop process and inject our
>   code a few times.
> * pages in pipes are unreclaimable, so it isn't good to hold a lot of
>   memory in pipes.
> 
> The introduced syscall allows to use a second way without injecting any
> code into a target process.
> 
> My experiments shows that process_vmsplice() + splice() works two time
> faster than process_vm_readv() + write().
>
> It is particularly useful on a pre-dump stage. On this stage we enable a
> memory tracker, and then we are dumping  a process memory while a
> process continues work. On the first iteration we are dumping all
> memory, and then we are dumpung only modified memory from a previous
> iteration.  After a few pre-dump operations, a process is stopped and
> dumped finally. The pre-dump operations allow to significantly decrease
> a process downtime, when a process is migrated to another host.

What is the overall improvement in a typical dumping operation?

Does that improvement justify the addition of a new syscall, and all
that this entails?  If so, why?

Are there any other applications of this syscall?
