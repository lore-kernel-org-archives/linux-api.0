From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 0/7] mm: process_vm_mmap() -- syscall for duplication a
 process mapping
Date: Tue, 21 May 2019 07:43:54 -0700
Message-ID: <CALCETrU221N6uPmdaj4bRDDsf+Oc5tEfPERuyV24wsYKHn+spA@mail.gmail.com>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Keith Busch <keith.busch@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, alexander.h.duyck@linux.intel.com, Weiny Ira <ira.weiny@intel.com>, Andrey Konovalov <andreyknvl@google.com>, arunks@codeaurora.org, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Rik van Riel <riel@surriel.com>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Nicholas Piggin <npiggin@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>, Jerome
List-Id: linux-api@vger.kernel.org

On Mon, May 20, 2019 at 7:01 AM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
>

> [Summary]
>
> New syscall, which allows to clone a remote process VMA
> into local process VM. The remote process's page table
> entries related to the VMA are cloned into local process's
> page table (in any desired address, which makes this different
> from that happens during fork()). Huge pages are handled
> appropriately.
>
> This allows to improve performance in significant way like
> it's shows in the example below.
>
> [Description]
>
> This patchset adds a new syscall, which makes possible
> to clone a VMA from a process to current process.
> The syscall supplements the functionality provided
> by process_vm_writev() and process_vm_readv() syscalls,
> and it may be useful in many situation.
>
> For example, it allows to make a zero copy of data,
> when process_vm_writev() was previously used:
>
>         struct iovec local_iov, remote_iov;
>         void *buf;
>
>         buf = mmap(NULL, n * PAGE_SIZE, PROT_READ|PROT_WRITE,
>                    MAP_PRIVATE|MAP_ANONYMOUS, ...);
>         recv(sock, buf, n * PAGE_SIZE, 0);
>
>         local_iov->iov_base = buf;
>         local_iov->iov_len = n * PAGE_SIZE;
>         remove_iov = ...;
>
>         process_vm_writev(pid, &local_iov, 1, &remote_iov, 1 0);
>         munmap(buf, n * PAGE_SIZE);
>
>         (Note, that above completely ignores error handling)
>
> There are several problems with process_vm_writev() in this example:
>
> 1)it causes pagefault on remote process memory, and it forces
>   allocation of a new page (if was not preallocated);

I don't see how your new syscall helps.  You're writing to remote
memory.  If that memory wasn't allocated, it's going to get allocated
regardless of whether you use a write-like interface or an mmap-like
interface.  Keep in mind that, on x86, just the hardware part of a
page fault is very slow -- populating the memory with a syscall
instead of a fault may well be faster.

>
> 2)amount of memory for this example is doubled in a moment --
>   n pages in current and n pages in remote tasks are occupied
>   at the same time;

This seems disingenuous.  If you're writing p pages total in chunks of
n pages, you will use a total of p pages if you use mmap and p+n if
you use write.  That only doubles the amount of memory if you let n
scale linearly with p, which seems unlikely.

>
> 3)received data has no a chance to be properly swapped for
>   a long time.

...

> a)kernel moves @buf pages into swap right after recv();
> b)process_vm_writev() reads the data back from swap to pages;

If you're under that much memory pressure and thrashing that badly,
your performance is going to be awful no matter what you're doing.  If
you indeed observe this behavior under normal loads, then this seems
like a VM issue that should be addressed in its own right.

>         buf = mmap(NULL, n * PAGE_SIZE, PROT_READ|PROT_WRITE,
>                    MAP_PRIVATE|MAP_ANONYMOUS, ...);
>         recv(sock, buf, n * PAGE_SIZE, 0);
>
> [Task 2]
>         buf2 = process_vm_mmap(pid_of_task1, buf, n * PAGE_SIZE, NULL, 0);
>
> This creates a copy of VMA related to buf from task1 in task2's VM.
> Task1's page table entries are copied into corresponding page table
> entries of VM of task2.

You need to fully explain a whole bunch of details that you're
ignored.  For example, if the remote VMA is MAP_ANONYMOUS, do you get
a CoW copy of it?  I assume you don't since the whole point is to
write to remote memory, but it's at the very least quite unusual in
Linux to have two different anonymous VMAs such that writing one of
them changes the other one.  But there are plenty of other questions.
What happens if the remote VMA is a gate area or other special mapping
(vDSO, vvar area, etc)?  What if the remote memory comes from a driver
that wasn't expecting the mapping to get magically copied to a
different process?

This new API seems quite dangerous and complex to me, and I don't
think the value has been adequately demonstrated.
