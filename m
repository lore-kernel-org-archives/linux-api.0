From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Harden userfaultfd
Date: Wed, 12 Feb 2020 14:41:00 -0500
Message-ID: <20200212194100.GA29809@redhat.com>
References: <20200211225547.235083-1-dancol@google.com>
 <202002112332.BE71455@keescook>
 <CAG48ez0ogRxvCK1aCnviN+nBqp6gmbUD7NjaMKvA7bF=esAc1A@mail.gmail.com>
 <20200212171416.GD1083891@xz-x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200212171416.GD1083891@xz-x1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nosh Minwalla <nosh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nick Kralevich <nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lokesh Gidra <lokeshgidra-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SElinux list <selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello everyone,

On Wed, Feb 12, 2020 at 12:14:16PM -0500, Peter Xu wrote:
> Right. AFAICT QEMU uses it far more than disk IOs.  A guest page can
> be accessed by any kernel component on the destination host during a
> postcopy procedure.  It can be as simple as when a vcpu writes to a
> missing guest page which still resides on the source host, then KVM
> will get a page fault and trap into userfaultfd asking for that page.
> The same thing happens to other modules like vhost, etc., as long as a
> missing guest page is touched by a kernel module.

Correct.

How does the android garbage collection work to make sure there cannot
be kernel faults on the missing memory?

If I understood correctly (I didn't have much time to review sorry)
what's proposed with regard to limiting uffd events from kernel
faults, the only use case I know that could deal with it is the
UFFD_FEATURE_SIGBUS but that's not normal userfaultfd: that's also the
only feature required from uffd to implement a pure malloc library in
userland that never takes the mmap sem for writing to implement
userland mremap/mmap/munmap lib calls (as those will convert to
UFFDIO_ZEROPAGE and MADV_DONTNEED internally to the lib and there will
be always a single vma). We just need to extend UFFDIO_ZEROPAGE to map
the THP zeropage to make this future pure-uffd malloc lib perform
better.

On the other end I'm also planning a mremap_vma_merge userland syscall
that will merge fragmented vmas.

Currently once you have a nice heap all contiguous but with small
objects and you free the fragments you can't build THP anymore even if
you make the memory virtually contiguous again by calling mremap. That
just build up a ton of vmas slowing down the app forever and also
preventing THP collapsing ever again.

mremap_vma_merge will require no new kernel feature, but it
fundamentally must be able to handle kernel faults. If databases
starts to use that, how can you enable this feature without breaking
random apps then?

So it'd be a feature usable only by one user (Android) perhaps? And
only until you start defragging the vmas of small objects?

Thanks,
Andrea
