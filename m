From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Wed, 25 Mar 2015 17:19:33 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1503251710400.31453@chino.kir.corp.google.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org> <550A5FF8.90504@gmail.com> <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com> <550E6D9D.1060507@gmail.com>
 <5512E0C0.6060406@suse.cz> <55131F70.7020503@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55131F70.7020503-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 25 Mar 2015, Daniel Micay wrote:

> > I'm not sure I get your description right. The problem I know about is
> > where "purging" means madvise(MADV_DONTNEED) and khugepaged later
> > collapses a new hugepage that will repopulate the purged parts,
> > increasing the memory usage. One can limit this via
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none . That
> > setting doesn't affect the page fault THP allocations, which however
> > happen only in newly accessed hugepage-sized areas and not partially
> > purged ones, though.
> 
> Since jemalloc doesn't unmap memory but instead does recycling itself in
> userspace, it ends up with large spans of free virtual memory and gets
> *lots* of huge pages from the page fault heuristic. It keeps track of
> active vs. dirty (not purged) vs. clean (purged / untouched) ranges
> everywhere, and will purge dirty ranges as they build up.
> 
> The THP allocation on page faults mean it ends up with memory that's
> supposed to be clean but is really not.
> 
> A worst case example with the (up until recently) default chunk size of
> 4M is allocating a bunch of 2.1M allocations. Chunks are naturally
> aligned, so each one can be represented as 2 huge pages. It increases
> memory usage by nearly *50%*. The allocator thinks the tail is clean
> memory, but it's not. When the allocations are freed, it will purge the
> 2.1M at the head (once enough dirty memory builds up) but all of the
> tail memory will be leaked until something else is allocated there and
> then freed.
> 

With tcmalloc, it's simple to always expand the heap by mmaping 2MB ranges 
for size classes <= 2MB, allocate its own metadata from an arena that is 
also expanded in 2MB range, and always do madvise(MADV_DONTNEED) for the 
longest span on the freelist when it does periodic memory freeing back to 
the kernel, and even better if the freed memory splits at most one 
hugepage.  When memory is pulled from the freelist of memory that has 
already been returned to the kernel, you can return a span that will make 
it eligible to be collapsed into a hugepage based on your setting of 
max_ptes_none, trying to consolidate the memory as much as possible.  If 
your malloc is implemented in a way to understand the benefit of 
hugepages, and how much memory you're willing to sacrifice (max_ptes_none) 
for it, then you should _never_ be increasing memory usage by 50%.
