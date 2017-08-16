From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v5 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
Date: Wed, 16 Aug 2017 19:47:17 +0300
Message-ID: <20170816164717.xjbtbdjtwnhvzukg@node.shutemov.name>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150286946261.8837.1454297295346610351.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170816111541.6c4ulnipt5cxgfsb@node.shutemov.name>
 <CAPcyv4gB1JycB_1k6mKe-_OwjZv1a7vPV6Hh393-U_HQ15RWEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gB1JycB_1k6mKe-_OwjZv1a7vPV6Hh393-U_HQ15RWEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 16, 2017 at 09:35:11AM -0700, Dan Williams wrote:
> On Wed, Aug 16, 2017 at 4:15 AM, Kirill A. Shutemov
> <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> > On Wed, Aug 16, 2017 at 12:44:22AM -0700, Dan Williams wrote:
> >> diff --git a/include/linux/mman.h b/include/linux/mman.h
> >> index c8367041fafd..0e1de42c836f 100644
> >> --- a/include/linux/mman.h
> >> +++ b/include/linux/mman.h
> >> @@ -7,6 +7,40 @@
> >>  #include <linux/atomic.h>
> >>  #include <uapi/linux/mman.h>
> >>
> >> +#ifndef MAP_32BIT
> >> +#define MAP_32BIT 0
> >> +#endif
> >> +#ifndef MAP_HUGE_2MB
> >> +#define MAP_HUGE_2MB 0
> >> +#endif
> >> +#ifndef MAP_HUGE_1GB
> >> +#define MAP_HUGE_1GB 0
> >> +#endif
> >> +
> >> +/*
> >> + * The historical set of flags that all mmap implementations implicitly
> >> + * support when file_operations.mmap_supported_mask is zero.
> >> + */
> >> +#define LEGACY_MAP_SUPPORTED_MASK (MAP_SHARED \
> >> +             | MAP_PRIVATE \
> >> +             | MAP_FIXED \
> >> +             | MAP_ANONYMOUS \
> >> +             | MAP_UNINITIALIZED \
> >> +             | MAP_GROWSDOWN \
> >> +             | MAP_DENYWRITE \
> >> +             | MAP_EXECUTABLE \
> >> +             | MAP_LOCKED \
> >> +             | MAP_NORESERVE \
> >> +             | MAP_POPULATE \
> >> +             | MAP_NONBLOCK \
> >> +             | MAP_STACK \
> >> +             | MAP_HUGETLB \
> >> +             | MAP_32BIT \
> >> +             | MAP_HUGE_2MB \
> >> +             | MAP_HUGE_1GB)
> >> +
> >> +#define      MAP_SUPPORTED_MASK (LEGACY_MAP_SUPPORTED_MASK)
> >> +
> >>  extern int sysctl_overcommit_memory;
> >>  extern int sysctl_overcommit_ratio;
> >>  extern unsigned long sysctl_overcommit_kbytes;
> >
> > Since we looking into mmap(2) ABI, maybe we should consider re-defining
> > MAP_DENYWRITE and MAP_EXECUTABLE as 0 in hope that we would be able to
> > re-use these bits in the future? These flags are ignored now anyway.
> 
> Yes, we can make these -EOPNOTSUPP in the new syscall.

You cannot detect them, if we would redefine them as 0. :)

-- 
 Kirill A. Shutemov
