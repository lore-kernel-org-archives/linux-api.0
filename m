From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
Date: Wed, 16 Aug 2017 10:28:21 -0700
Message-ID: <CAPcyv4i+GbwcqMwKscTmTAuoXnQNfqBtHsxUu-L0+NzNO2f4Lw@mail.gmail.com>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <150286946864.8837.17147962029964281564.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 16, 2017 at 12:44 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> MAP_DIRECT is an mmap(2) flag with the following semantics:
>
>   MAP_DIRECT
>   When specified with MAP_SHARED a successful fault in this range
>   indicates that the kernel is maintaining the block map (user linear
>   address to file offset to physical address relationship) in a manner
>   that no external agent can observe any inconsistent changes. In other
>   words, the block map of the mapping is effectively pinned, or the kernel
>   is otherwise able to exchange a new physical extent atomically with
>   respect to any hardware / software agent. As implied by this definition
>   a successful fault in a MAP_DIRECT range bypasses kernel indirections
>   like the page-cache, and all updates are carried directly through to the
>   underlying file physical blocks (modulo cpu cache effects).
>
>   ETXTBSY may be returned to any third party operation on the file that
>   attempts to update the block map (allocate blocks / convert unwritten
>   extents / break shared extents). However, whether a filesystem returns
>   EXTBSY for a certain state of the block relative to a MAP_DIRECT mapping
>   is filesystem and kernel version dependent.
>
>   Some filesystems may extend these operation restrictions outside the
>   mapped range and return ETXTBSY to any file operations that might mutate
>   the block map. MAP_DIRECT faults may fail with a SIGBUS if the
>   filesystem needs to write the block map to satisfy the fault. For
>   example, if the mapping was established over a hole in a sparse file.
>
>   ERRORS
>   EACCES A MAP_DIRECT mapping was requested and PROT_WRITE was not set,
>   or the requesting process is missing CAP_LINUX_IMMUTABLE.
>
>   EINVAL MAP_ANONYMOUS or MAP_PRIVATE was specified with MAP_DIRECT.
>
>   EOPNOTSUPP The filesystem explicitly does not support the flag
>
>   SIGBUS Attempted to write a MAP_DIRECT mapping at a file offset that
>          might require block-map updates.
>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
[..]
> diff --git a/include/linux/mman.h b/include/linux/mman.h
> index 0e1de42c836f..7c9e3d11027f 100644
> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -7,16 +7,6 @@
>  #include <linux/atomic.h>
>  #include <uapi/linux/mman.h>
>
> -#ifndef MAP_32BIT
> -#define MAP_32BIT 0
> -#endif
> -#ifndef MAP_HUGE_2MB
> -#define MAP_HUGE_2MB 0
> -#endif
> -#ifndef MAP_HUGE_1GB
> -#define MAP_HUGE_1GB 0
> -#endif

This was inadvertent, we need this to build on non-x86 archs, will fix.
