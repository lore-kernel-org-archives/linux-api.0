From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Wed, 23 Oct 2019 13:05:47 -0700
Message-ID: <CAKOZuetKkM=PK2QA8LdXwM8cM8qJvFu4u5bjePWai3XRnHe-pA@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
 <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
 <CALCETrUyq=J37gU-MYXqLdoi7uH7iNNVRjvcGUT11JA1QuTFyg@mail.gmail.com>
 <CAG48ez3P27-xqdjKLqfP_0Q_v9K92CgEjU4C=kob2Ax7=NoZbA@mail.gmail.com> <20191023190959.GA9902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023190959.GA9902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 23, 2019 at 12:10 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Sat, Oct 12, 2019 at 06:14:23PM -0700, Andy Lutomirski wrote:
> > [adding more people because this is going to be an ABI break, sigh]
>
> That wouldn't break the ABI, no more than when if you boot a kernel
> built with CONFIG_USERFAULTFD=n.

The change Andy is proposing would convert programs that work with
CONFIG_USERFAULTFD=y today into programs that don't work with
CONFIG_USERFAULTFD. Whether that counts as an ABI break is above my
ability to decide, but IMHO, I think it should count. Such a change at
least merits more-than-usual scrutiny. I'd love to get Linus's
opinion.

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

The phrase "CRIU monitor" above stands out.  :-) Not every process
that uses userfaultfd will be CRIU-related, and in particular, there's
no requirement right now that limits UFFD_EVENT_FORK to privileged
processes.

The attack Andy is describing involves a random unprivileged process
creating a userfaultfd file object, configuring it to UFFD_EVENT_FORK,
somehow (stdin, SCM_RIGHTS, binder, etc.) passing that FD to a
more-privileged process, and convincing that privileged process to
read(2) that FD and disturb its file descriptor table, which in turn
can cause EoP or all kinds of other havoc. This is a serious bug that
needs some kind of fix.

> On Mon, Oct 14, 2019 at 06:04:22PM +0200, Jann Horn wrote:
> > FWIW, <https://codesearch.debian.net/search?q=UFFD_FEATURE_EVENT_FORK&literal=1>
> > just shows the kernel, kernel selftests, and strace code for decoding
> > syscall arguments. CRIU uses it though (probably for postcopy live
> > migration / lazy migration?), I guess that code isn't in debian for
> > some reason.
>
> https://criu.org/Userfaultfd#Limitations
>
> The CRIU developers did a truly amazing job by making container post
> copy live migration work great for a subset of apps, that alone was an
> amazing achievement. Is that achievement enough to use post copy live
> migration of bare metal containers in production? Unfortunately
> probably not and not just in debian.

Nobody is claiming that there's anything wrong with UFFD. That UFFD is
being used for features that have nothing to do with CRIU or
containerization is a signal that UFFD's creators made a good,
general-purpose tool. (We're considering it for two completely
unrelated purposes in Android in fact.) I don't think we can assume
that the UFFD feature has gone unused on the basis of CRIU's
slower-than-hoped-for adoption. Who's using it for something?
*Probably* nobody, but like I said above, it's worth thinking about
and being careful.

> In my view there's simply no justification not to use virtual machines
> when the alternative requires so much more code to be written and so
> much more complexity to be dealt with.

This is a debate that won't get resolved here. A ton of work has gone
into namespaces, migration, various cgroup things, and so on, and I
don't see that work getting torn out.

> While at it, as far as userfaultfd is concerned I'd rather see people
> spend time to write a malloc library that uses userfaultfd with the
> UFFD_FEATURE_SIGBUS features and it replaces mmap with UFFDIO_ZEROPAGE
> (plus adding the THP accelleration currently missing)

I'd also like to see realloc(3) use mremap(2) in real implementations
and for C++ to grow an allocator interface that can use realloc(3).
But I think that's a separate matter.

> and munmap with
> MADV_DONTNEED to do allocations and freeing of memory with full
> scalability without ever hitting on the map sem for writing.

Some allocators, e.g., jemalloc, already use MADV_DONTNEED.

> fork COWs cannot throttle

Sure they can. Can't we stick processes in a memcg and set a
memory.high threshold beyond which threads in that cgroup will enter
direct reclaim on page allocations? I'd call that throttling.

> and all apps using fork() risk to hit on x2
> memory usage which can become oom-killer material if the memory size
> of the process is huge.

fork is one of the reasons people use overcommit all the time. I'd
like to see a lot less overcommit in the world.

> On my side, instead of trying to fix whatever issue in
> UFFD_EVENT_FORK,

This issue *has* to get fixed one way or another.
