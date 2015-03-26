From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Thu, 26 Mar 2015 18:25:32 +0100
Message-ID: <5514410C.7090408@suse.cz>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org> <550A5FF8.90504@gmail.com> <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com> <550E6D9D.1060507@gmail.com> <5512E0C0.6060406@suse.cz> <55131F70.7020503@gmail.com> <alpine.DEB.2.10.1503251710400.31453@chino.kir.corp.google.com> <551351CA.3090803@gmail.com> <alpine.DEB.2.10.1503251914260.16714@chino.kir.corp.google.com> <55137C06.9020608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55137C06.9020608-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/26/2015 04:24 AM, Daniel Micay wrote:
> It's all well and good to say that you shouldn't do that, but it's the
> basis of the design in jemalloc and other zone-based arena allocators.
>
> There's a chosen chunk size and chunks are naturally aligned. An
> allocation is either a span of chunks (chunk-aligned) or has metadata
> stored in the chunk header. This also means chunks can be assigned to
> arenas for a high level of concurrency. Thread caching is then only
> necessary for batching operations to amortize the cost of locking rather
> than to reduce contention. Per-CPU arenas can be implemented quite well
> by using sched_getcpu() to move threads around whenever it detects that
> another thread allocated from the arena.
>
> With >= 2M chunks, madvise purging works very well at the chunk level
> but there's also fine-grained purging within chunks and it completely
> breaks down from THP page faults.

Are you sure it's due to page faults and not khugepaged + high value 
(such as the default 511) of max_ptes_none? As reported here?

https://bugzilla.kernel.org/show_bug.cgi?id=93111

Once you have faulted in a THP, and then purged part of it and split it, 
I don't think page faults in the purged part can lead to a new THP 
collapse, only khugepaged can do that AFAIK.
And if you mmap smaller than 2M areas (i.e. your 256K chunks), that 
should prevent THP page faults on the first fault within the chunk as well.
