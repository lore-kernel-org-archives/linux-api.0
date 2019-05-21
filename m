From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 0/7] mm: process_vm_mmap() -- syscall for duplication a
 process mapping
Date: Tue, 21 May 2019 18:20:16 +0200
Message-ID: <CAG48ez2BcVCwYGmAo4MwZ2crZ9f7=qKrORcN=fYz=K5xP2xfgQ@mail.gmail.com>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
 <CALCETrU221N6uPmdaj4bRDDsf+Oc5tEfPERuyV24wsYKHn+spA@mail.gmail.com> <9638a51c-4295-924f-1852-1783c7f3e82d@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9638a51c-4295-924f-1852-1783c7f3e82d@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@suse.com>, Keith Busch <keith.busch@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Weiny Ira <ira.weiny@intel.com>, Andrey Konovalov <andreyknvl@google.com>, arunks@codeaurora.org, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Rik van Riel <riel@surriel.com>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Nicholas Piggin <npiggin@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@r>
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 5:52 PM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> On 21.05.2019 17:43, Andy Lutomirski wrote:
> > On Mon, May 20, 2019 at 7:01 AM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> >> New syscall, which allows to clone a remote process VMA
> >> into local process VM. The remote process's page table
> >> entries related to the VMA are cloned into local process's
> >> page table (in any desired address, which makes this different
> >> from that happens during fork()). Huge pages are handled
> >> appropriately.
[...]
> >> There are several problems with process_vm_writev() in this example:
> >>
> >> 1)it causes pagefault on remote process memory, and it forces
> >>   allocation of a new page (if was not preallocated);
> >
> > I don't see how your new syscall helps.  You're writing to remote
> > memory.  If that memory wasn't allocated, it's going to get allocated
> > regardless of whether you use a write-like interface or an mmap-like
> > interface.
>
> No, the talk is not about just another interface for copying memory.
> The talk is about borrowing of remote task's VMA and corresponding
> page table's content. Syscall allows to copy part of page table
> with preallocated pages from remote to local process. See here:
>
> [task1]                                                        [task2]
>
> buf = mmap(NULL, n * PAGE_SIZE, PROT_READ|PROT_WRITE,
>            MAP_PRIVATE|MAP_ANONYMOUS, ...);
>
> <task1 populates buf>
>
>                                                                buf = process_vm_mmap(pid_of_task1, addr, n * PAGE_SIZE, ...);
> munmap(buf);
>
>
> process_vm_mmap() copies PTEs related to memory of buf in task1 to task2
> just like in the way we do during fork syscall.
>
> There is no copying of buf memory content, unless COW happens. This is
> the principal difference to process_vm_writev(), which just allocates
> pages in remote VM.
>
> > Keep in mind that, on x86, just the hardware part of a
> > page fault is very slow -- populating the memory with a syscall
> > instead of a fault may well be faster.
>
> It is not as slow, as disk IO has. Just compare, what happens in case of anonymous
> pages related to buf of task1 are swapped:
>
> 1)process_vm_writev() reads them back into memory;
>
> 2)process_vm_mmap() just copies swap PTEs from task1 page table
>   to task2 page table.
>
> Also, for faster page faults one may use huge pages for the mappings.
> But really, it's funny to think about page faults, when there are
> disk IO problems I shown.
[...]
> > That only doubles the amount of memory if you let n
> > scale linearly with p, which seems unlikely.
> >
> >>
> >> 3)received data has no a chance to be properly swapped for
> >>   a long time.
> >
> > ...
> >
> >> a)kernel moves @buf pages into swap right after recv();
> >> b)process_vm_writev() reads the data back from swap to pages;
> >
> > If you're under that much memory pressure and thrashing that badly,
> > your performance is going to be awful no matter what you're doing.  If
> > you indeed observe this behavior under normal loads, then this seems
> > like a VM issue that should be addressed in its own right.
>
> I don't think so. Imagine: a container migrates from one node to another.
> The nodes are the same, say, every of them has 4GB of RAM.
>
> Before the migration, the container's tasks used 4GB of RAM and 8GB of swap.
> After the page server on the second node received the pages, we want these
> pages become swapped as soon as possible, and we don't want to read them from
> swap to pass a read consumer.

But you don't have to copy that memory into the container's tasks all
at once, right? Can't you, every time you've received a few dozen
kilobytes of data or whatever, shove them into the target task? That
way you don't have problems with swap because the time before the data
has arrived in its final VMA is tiny.
