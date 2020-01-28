From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Tue, 28 Jan 2020 15:26:42 +0000
Message-ID: <20200128152641.GA29776@willie-the-truck>
References: <20200123014627.71720-1-bgeffon@google.com>
 <20200127053056.213679-1-bgeffon@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200127053056.213679-1-bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nathan Chancellor <natechancellor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Brian,

On Sun, Jan 26, 2020 at 09:30:56PM -0800, Brian Geffon wrote:
> When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is
> set, the source mapping will not be removed. Instead it will be
> cleared as if a brand new anonymous, private mapping had been created
> atomically as part of the mremap() call.  If a userfaultfd was watching
> the source, it will continue to watch the new mapping.  For a mapping
> that is shared or not anonymous, MREMAP_DONTUNMAP will cause the
> mremap() call to fail. MREMAP_DONTUNMAP requires that MREMAP_FIXED is
> also used. The final result is two equally sized VMAs where the
> destination contains the PTEs of the source.
>    
> We hope to use this in Chrome OS where with userfaultfd we could write
> an anonymous mapping to disk without having to STOP the process or worry
> about VMA permission changes.
>    
> This feature also has a use case in Android, Lokesh Gidra has said
> that "As part of using userfaultfd for GC, We'll have to move the physical
> pages of the java heap to a separate location. For this purpose mremap
> will be used. Without the MREMAP_DONTUNMAP flag, when I mremap the java
> heap, its virtual mapping will be removed as well. Therefore, we'll
> require performing mmap immediately after. This is not only time consuming
> but also opens a time window where a native thread may call mmap and
> reserve the java heap's address range for its own usage. This flag
> solves the problem."

Hmm, this sounds like you're dealing with a multi-threaded environment,
yet your change only supports private mappings. How does that work?

It's also worrying because, with two private mappings of the same anonymous
memory live simultaneously, you run the risk of hitting D-cache aliasing
issues on some architectures and losing coherency between them as a result
(even in a single-threaded scenario). Is userspace just supposed to deal
with this, or should we be enforcing SHMLBA alignment?
 
> Signed-off-by: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/mman.h |  5 +++--
>  mm/mremap.c               | 38 +++++++++++++++++++++++++++++++-------
>  2 files changed, 34 insertions(+), 9 deletions(-)

Could you also a include a patch to update the mremap man page, please?

https://www.kernel.org/doc/man-pages/patches.html

Cheers,

Will
