From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 0/6] Harden userfaultfd
Date: Wed, 12 Feb 2020 18:41:19 -0500
Message-ID: <20200212234119.GB29809@redhat.com>
References: <20200211225547.235083-1-dancol@google.com>
 <202002112332.BE71455@keescook>
 <CAG48ez0ogRxvCK1aCnviN+nBqp6gmbUD7NjaMKvA7bF=esAc1A@mail.gmail.com>
 <20200212171416.GD1083891@xz-x1>
 <20200212194100.GA29809@redhat.com>
 <CAKOZuevusieaKCt5r-jnQ5ArGfw5Otszq2CAcrqFi6MYxkKwtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuevusieaKCt5r-jnQ5ArGfw5Otszq2CAcrqFi6MYxkKwtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Tim Murray <timmurray@google.com>, Nosh Minwalla <nosh@google.com>, Nick Kralevich <nnk@google.com>, Lokesh Gidra <lokeshgidra@google.com>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, SElinux list <selinux@vger.kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Daniel,

On Wed, Feb 12, 2020 at 12:04:39PM -0800, Daniel Colascione wrote:
> We don't pass pointers to the heap into system calls. (Big primitive
> arrays, ByteBuffer, etc. are allocated off the regular heap.)

That sounds pretty restrictive, I wonder what you gain by enforcing
that invariant or if it just happened incidentally for some other
reason?  Do you need to copy that memory every time if you need to do
I/O on it? Are you sure this won't need to change any time soon to
increase performance?

> I don't understand what you mean. The purpose of preventing UFFD from
> handling kernel faults is exploit mitigation.

That part was clear. What wasn't clear is what the new feature
does exactly and what it blocks, because it's all about blocking or
how does it make things more secure?

> The key requirement here is the ability to prevent unprivileged
> processes from using UFFD to widen kernel exploit windows by
> preventing UFFD from taking kernel faults. Forcing unprivileged
> processes to use UFFD only with UFFD_FEATURE_SIGBUS would satisfy this
> requirement, but it's much less flexible and unnecessarily couples two
> features.

I mentioned it in case you could use something like that model.

> > On the other end I'm also planning a mremap_vma_merge userland syscall
> > that will merge fragmented vmas.
> 
> This is probably a separate discussion, but does that operation really
> need to be a system call? Historically, userspace has operated mostly

mremap_vma_merge was not intended as a system call, if implemented as
a system call it wouldn't use uffd.

> on page ranges and not VMAs per se, and the kernel has been free to

Userland doesn't need to know anything.. unless it wants to optimize.

The userland can know full well if it does certain mremap operations
and puts its ranges virtually contiguous in a non linear way, so that
the kernel cannot merge the vmas.

> merge and split VMAs as needed for its internal purposes. This
> approach has serious negative side effects (like making munmap
> fallible: see [1]), but it is what it is.
> 
> [1] https://lore.kernel.org/linux-mm/CAKOZuetOD6MkGPVvYFLj5RXh200FaDyu3sQqZviVRhTFFS3fjA@mail.gmail.com/

The fact it's fallible is a secondary concern here. Even if you make
it unlimited, if it grows it slowdown everything and also prevents THP
to be collapsed. Even the scalability of the mmap_sem worsens.

> > Currently once you have a nice heap all contiguous but with small
> > objects and you free the fragments you can't build THP anymore even if
> > you make the memory virtually contiguous again by calling mremap. That
> > just build up a ton of vmas slowing down the app forever and also
> > preventing THP collapsing ever again.
> 
> Shouldn't the THP background kthread take care of merging VMAs?

The solution can't depend on any THP feature, because the buildup of
vmas is a scalability issue and a performance regression over time
even if THP is not configured in the kernel. However once that's
solved THP also gets naturally optimized.

What should happen (in my view) is just the simplest solution that can
defrag and forcefully merge the vmas without having to stop or restart
the app.

> Presumably, those apps wouldn't issue the system call on address
> ranges managed with a non-kernel-fault UFFD.

So the new security feature won't have to block kernel faults on those
apps and they can run side by side with the blocked app?

> We shouldn't be fragmenting at all, either at the memory level or the
> VMA level. The GC is a moving collector, and we don't punch holes in
> the heap.

That sounds good.

Thanks,
Andrea
