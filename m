From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Wed, 25 Mar 2015 19:31:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1503251914260.16714@chino.kir.corp.google.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org> <550A5FF8.90504@gmail.com> <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com> <550E6D9D.1060507@gmail.com>
 <5512E0C0.6060406@suse.cz> <55131F70.7020503@gmail.com> <alpine.DEB.2.10.1503251710400.31453@chino.kir.corp.google.com> <551351CA.3090803@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551351CA.3090803-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 25 Mar 2015, Daniel Micay wrote:

> > With tcmalloc, it's simple to always expand the heap by mmaping 2MB ranges 
> > for size classes <= 2MB, allocate its own metadata from an arena that is 
> > also expanded in 2MB range, and always do madvise(MADV_DONTNEED) for the 
> > longest span on the freelist when it does periodic memory freeing back to 
> > the kernel, and even better if the freed memory splits at most one 
> > hugepage.  When memory is pulled from the freelist of memory that has 
> > already been returned to the kernel, you can return a span that will make 
> > it eligible to be collapsed into a hugepage based on your setting of 
> > max_ptes_none, trying to consolidate the memory as much as possible.  If 
> > your malloc is implemented in a way to understand the benefit of 
> > hugepages, and how much memory you're willing to sacrifice (max_ptes_none) 
> > for it, then you should _never_ be increasing memory usage by 50%.
> 
> If khugepaged was the only source of huge pages, sure. The primary
> source of huge pages is the heuristic handing out an entire 2M page on
> the first page fault in a 2M range.
> 

The behavior is a property of what you brk() or mmap() to expand your 
heap, you can intentionally require it to fault hugepages or not fault 
hugepages without any special madvise().

With the example above, the implementation I wrote specifically tries to 
sbrk() in 2MB regions and hands out allocator metadata via a memory arena 
doing the same thing.  Memory is treated as being on a normal freelist so 
that it is considered resident, i.e. the same as faulting 4KB, freeing it, 
before tcmalloc does madvise(MADV_DONTNEED), and we naturally prefer to 
hand that out before going to the returned freelist or mmap() as fallback.  
There will always be fragmentation in your normal freelist spans, so 
there's always wasted memory (with or without thp).  There should never be 
a case where you're always mapping 2MB aligned regions and then only 
touching a small portion of it, for >2MB size classes you could easily map 
only the size required and you would never get an excess of memory due to 
thp at fault.

I think this may be tangential to the thread, though, since this has 
nothing to do with mremap() or any new mremap() flag.

If the thp faulting behavior is going to be changed, then it would need to 
be something that is opted into and not by any system tunable or madvise() 
flag.  It would probably need to be a prctl() like PR_SET_THP_DISABLE is 
that would control only fault behavior.
