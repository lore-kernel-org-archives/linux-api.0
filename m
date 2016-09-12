From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm, mincore2(): retrieve dax and tlb-size
 attributes of an address range
Date: Mon, 12 Sep 2016 13:09:10 +0300
Message-ID: <20160912100910.GC23346@node.shutemov.name>
References: <147361509579.17004.5258725187329709824.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147361509579.17004.5258725187329709824.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Sep 11, 2016 at 10:31:35AM -0700, Dan Williams wrote:
> As evidenced by this bug report [1], userspace libraries are interested
> in whether a mapping is DAX mapped, i.e. no intervening page cache.
> Rather than using the ambiguous VM_MIXEDMAP flag in smaps, provide an
> explicit "is dax" indication as a new flag in the page vector populated
> by mincore.
> 
> There are also cases, particularly for testing and validating a
> configuration to know the hardware mapping geometry of the pages in a
> given process address range.  Consider filesystem-dax where a
> configuration needs to take care to align partitions and block
> allocations before huge page mappings might be used, or
> anonymous-transparent-huge-pages where a process is opportunistically
> assigned large pages.  mincore2() allows these configurations to be
> surveyed and validated.
> 
> The implementation takes advantage of the unused bits in the per-page
> byte returned for each PAGE_SIZE extent of a given address range.  The
> new format of each vector byte is:
> 
> (TLB_SHIFT - PAGE_SHIFT) << 2 | vma_is_dax() << 1 | page_present
> 
> [1]: https://lkml.org/lkml/2016/9/7/61
> 
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/syscalls.h               |    2 +
>  include/uapi/asm-generic/mman-common.h |    3 +
>  kernel/sys_ni.c                        |    1 
>  mm/mincore.c                           |  126 +++++++++++++++++++++++++-------
>  4 files changed, 104 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index d02239022bd0..4aa2ee7e359a 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -467,6 +467,8 @@ asmlinkage long sys_munlockall(void);
>  asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
>  asmlinkage long sys_mincore(unsigned long start, size_t len,
>  				unsigned char __user * vec);
> +asmlinkage long sys_mincore2(unsigned long start, size_t len,
> +				unsigned char __user * vec, int flags);

We had few attempts to extand mincore(2) interface/functionality before.
None of them ended up in upsteam.

How this attempt compares to previous?

-- 
 Kirill A. Shutemov
