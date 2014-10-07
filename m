From: Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
Date: Tue, 7 Oct 2014 09:13:20 -0700
Message-ID: <20141007161320.GA17858@google.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-11-git-send-email-aarcange@redhat.com>
 <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
 <20141006085540.GD2336@work-vm>
 <20141006164156.GA31075@redhat.com>
 <CA+55aFxAOYBny+QwXfkPy-P3rs-RPr5SLYLcPNBiFO3waBXtQA@mail.gmail.com>
 <20141007141913.GC2342@redhat.com>
 <20141007155247.GD2342@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141007155247.GD2342-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Robert Love <rlove-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Adamushko <dmitry.adamushko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mike Hommey <mh-YmoObPS1fuhg9hUCZPvPmw@public.gmane.org>, Taras
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 05:52:47PM +0200, Andrea Arcangeli wrote:
> I probably grossly overestimated the benefits of resolving the
> userfault with a zerocopy page move, sorry. [...]

For posterity, I think it's worth noting that most expensive aspect of a TLB
shootdown is the interprocessor interrupt necessary to flush other CPUs' TLBs.
On a many-core machine, copying 4K of data looks pretty cheap compared to
taking an interrupt and invalidating TLBs on many cores :-)

> [...] So if we entirely drop the
> zerocopy behavior and the TLB flush of the old page like you
> suggested, the way to keep the userfaultfd mechanism decoupled from
> the userfault resolution mechanism would be to implement an
> atomic-copy syscall. That would work for SIGBUS userfaults too without
> requiring a pseudofd then. It would be enough then to call
> mcopy_atomic(userfault_addr,tmp_addr,len) with the only constraints
> that len must be a multiple of PAGE_SIZE. Of course mcopy_atomic
> wouldn't page fault or call GUP into the destination address (it can't
> otherwise the in-flight partial copy would be visible to the process,
> breaking the atomicity of the copy), but it would fill in the
> pte/trans_huge_pmd with the same strict behavior that remap_anon_pages
> currently has (in turn it would by design bypass the VM_USERFAULT
> check and be ideal for resolving userfaults).
> 
> mcopy_atomic could then be also extended to tmpfs and it would work
> without requiring the source page to be a tmpfs page too without
> having to convert page types on the fly.
> 
> If I add mcopy_atomic, the patch in subject (10/17) can be dropped of
> course so it'd be even less intrusive than the current
> remap_anon_pages and it would require zero TLB flush during its
> runtime (it would just require an atomic copy).

I like this new approach. It will be good to have a single interface for
resolving anon and tmpfs userfaults.

> So should I try to embed a mcopy_atomic inside userfault_write or can
> I expose it to userland as a standalone new syscall? Or should I do
> something different? Comments?

One interesting (ab)use of userfault_write would be that the faulting process
and the fault-handling process could be different, which would be necessary
for post-copy live migration in CRIU (http://criu.org).

Aside from the asthetic difference, I can't think of any advantage in favor of
a syscall.

Peter
