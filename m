From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Thu, 24 Oct 2019 12:02:59 +0300
Message-ID: <20191024090258.GA9802@linux.ibm.com>
References: <20191012191602.45649-1-dancol@google.com>
 <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
 <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
 <CALCETrUyq=J37gU-MYXqLdoi7uH7iNNVRjvcGUT11JA1QuTFyg@mail.gmail.com>
 <CAG48ez3P27-xqdjKLqfP_0Q_v9K92CgEjU4C=kob2Ax7=NoZbA@mail.gmail.com>
 <20191023190959.GA9902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191023190959.GA9902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 23, 2019 at 03:09:59PM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Sat, Oct 12, 2019 at 06:14:23PM -0700, Andy Lutomirski wrote:
> > [adding more people because this is going to be an ABI break, sigh]
> 
> That wouldn't break the ABI, no more than when if you boot a kernel
> built with CONFIG_USERFAULTFD=n.
> 
> All non-cooperative features can be removed any time in a backwards
> compatible way, the only precaution is to mark their feature bits as
> reserved so they can't be reused for something else later.
> 
> > least severely restricted.  A .read implementation MUST NOT ACT ON THE
> > CALLING TASK.  Ever.  Just imagine the effect of passing a userfaultfd
> > as stdin to a setuid program.
> 
> With UFFD_EVENT_FORK, the newly created uffd that controls the child,
> is not passed to the parent nor to the child. Instead it's passed to
> the CRIU monitor only, which has to be already running as root and is
> fully trusted and acts a hypervisor (despite there is no hypervisor).
> 
> By the time execve runs and any suid bit in the execve'd inode becomes
> relevant, well before the new userland executable code can run, the
> kernel throws away the "old_mm" controlled by any uffd and all
> attached uffds are released as well.
> 
> All I found is your "A .read implementation MUST NOT ACT ON THE
> CALLING TASK" as an explanation that something is broken but I need
> further clarification.
> 
> Of course I can see you can always open a uffd and pass it to any task
> you are going to execve on, but that simply means the suid program
> will be able to control you, not the other way around. If you don't
> want to be controlled by the next task, no matter if suid or not, just
> don't that. What I don't see is how you're going to control the suid
> binary from the outside, the suid binary at most will block in the
> poll, read and write syscalls and get garbage or write some garbage
> and get an error, it won't get signals and it cannot block in any page
> fault either, it's not immediately clear what's out of ordinary.
> 
> On Mon, Oct 14, 2019 at 06:04:22PM +0200, Jann Horn wrote:
> > FWIW, <https://codesearch.debian.net/search?q=UFFD_FEATURE_EVENT_FORK&literal=1>
> > just shows the kernel, kernel selftests, and strace code for decoding
> > syscall arguments. CRIU uses it though (probably for postcopy live
> > migration / lazy migration?), I guess that code isn't in debian for
> > some reason.
> 
> https://criu.org/Userfaultfd#Limitations

That's no the reason that UFFD_FEATURE_EVENT_FORK does not show up in
Debian code search, CRIU simply is not there. Debian packages CRIU only in
experimental and I believe that's not indexed by the code search.

As for the limitations, the races were fixed, I just forgot to update the
wiki. As for the supported memory types and COW pages, these only affect
efficiency of post-copy, but not the correctness.
 
> The CRIU developers did a truly amazing job by making container post
> copy live migration work great for a subset of apps, that alone was an
> amazing achievement. Is that achievement enough to use post copy live
> migration of bare metal containers in production? Unfortunately
> probably not and not just in debian.
 
I don't know if anybody is using post-copy migration of containers in
production, but I don't think that the reason for that would be technical.
IMHO it's more about prevailing perception that there is no need to migrate
containers at all, not only with post-copy, and, as the result, slow rate
of adoption of container migration in general.

> If you're wrong and UFFDIO_EVENT_FORK isn't currently buggy and in
> turn it isn't causing further maintenance burden, there is no hurry of
> removing them, but in the long term, if none of the non-cooperative
> features find its way in production (like it was reasonable to expect
> initially), they must be removed from the kernel anyway, not just
> UFFD_EVEN_FORK but all non-cooperative features associated with it.

... 
 
> On my side, instead of trying to fix whatever issue in
> UFFD_EVENT_FORK, I'd prefer to spend my time reviewing the uffd-wp
> feature from Peter and the page fault enhancement patchset that Peter
> and Linus were discussing. uffd-wp has the potential to drop fork()
> from all apps calling fork() only to do an atomic snapshot of their
> memory. Replacing fork() also means the uffd manager thread can decide
> how much memory to reserve to the snapshot and it can start throttling
> waiting for I/O completion if the threshold is exceeded, while fork
> COWs cannot throttle and all apps using fork() risk to hit on x2
> memory usage which can become oom-killer material if the memory size
> of the process is huge. The side benefit is also that the way
> userfaultfd works the fault granularity is entirely in control of
> userland (because it's always userland that resolves the fault), it
> could decide to use 8k or 16k even if that doesn't match the hardware
> page size. That will allow to keep THP on without risking to hit on 2M
> cows during the snapshot. Being able to keep THP enabled in nosql db
> without hitting on slow 2M COW copies during snapshot, should allow a
> further overall performance improvement when the snapshot is not
> running than what it is possible today. In a completely different use
> case, uffd-wp will also avoid JITs to set a dirty bit every time they
> modify any data in memory. It should also be possible to provide the
> same soft-dirty information in O(1) instead of O(N).

If I remember correctly, there was an intention to deprecate soft-dirty in
favor of uffd-wp, which brings us back to the necessity to have
non-cooperative uffd because otherwise even pre-copy in CRIU will be broken
and that *is* used in production.
 
> Thanks,
> Andrea
> 

-- 
Sincerely yours,
Mike.
