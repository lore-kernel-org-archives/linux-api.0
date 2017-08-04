From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Date: Thu, 3 Aug 2017 19:38:11 -0700
Message-ID: <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <150181368442.32119.13336247800141074356.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[ adding linux-api to the cover letter for notification, will send the
full set to linux-api for v3 ]

On Thu, Aug 3, 2017 at 7:28 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Changes since v1 [1]:
> * Add IS_IOMAP_IMMUTABLE() checks to xfs ioctl paths that perform block
>   map changes (xfs_alloc_file_space and xfs_free_file_space) (Darrick)
>
> * Rather than complete a partial write, fail all writes that would
>   attempt to extend the file size (Darrick)
>
> * Introduce FALLOC_FL_UNSEAL_BLOCK_MAP as an explicit operation type for
>   clearing S_IOMAP_IMMUTABLE (Dave)
>
> * Rework xfs_seal_file_space() to first complete hole-fill and unshare
>   operations and then check the file for suitability under
>   XFS_ILOCK_EXCL. (Darrick)
>
> * Add an FS_XFLAG_IOMAP_IMMUTABLE flag so the immutable state can be
>   seen by xfs_io. (Dave)
>
> * Move the setting of S_IOMAP_IMMUTABLE to be atomic with respect to the
>   successful transaction that records XFS_DIFLAG2_IOMAP_IMMUTABLE.
>   (Darrick, Dave)
>
> * Switch to a 'goto out_unlock' style in xfs_seal_file_space() to
>   cleanup 'if / else' tree, and use the mapping_mapped() helper. (Dave)
>
> * Rely on XFS_MMAPLOCK_EXCL for reading a stable state of
>   mapping->i_mmap. (Dave)
>
> [1]: http://marc.info/?l=linux-fsdevel&m=150135785712967&w=2
>
> ---
>
> The daxfile proposal a few weeks back [2] sought to piggy back on the
> swapfile implementation to approximate a block map immutable file. This
> is an idea Dave originated last year to solve the dax "flush from
> userspace" problem [3].
>
> The discussion yielded several results. First, Christoph pointed out
> that swapfiles are subtly broken [4].  Second, Darrick [5] and Dave [6]
> proposed how to properly implement a block map immutable file.  Finally,
> Dave identified some improvements to swapfiles that can be built on the
> block-map-immutable mechanism. These patches seek to implement the first
> part of the proposal and save the swapfile work to build on top once the
> base mechanism is complete.
>
> While the initial motivation for this feature is support for
> byte-addressable updates of persistent memory and managing cache
> maintenance from userspace, the applications of the feature are broader.
> In addition to being the start of a better swapfile mechanism it can
> also support a DMA-to-storage use case.  This use case enables
> data-acquisition hardware to DMA directly to a storage device address
> while being safe in the knowledge that storage mappings will not change.
>
> [2]: https://lkml.org/lkml/2017/6/16/790
> [3]: https://lkml.org/lkml/2016/9/11/159
> [4]: https://lkml.org/lkml/2017/6/18/31
> [5]: https://lkml.org/lkml/2017/6/20/49
> [6]: https://www.spinics.net/lists/linux-xfs/msg07871.html
>
> ---
>
> Dan Williams (5):
>       fs, xfs: introduce S_IOMAP_IMMUTABLE
>       fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
>       fs, xfs: introduce FALLOC_FL_UNSEAL_BLOCK_MAP
>       xfs: introduce XFS_DIFLAG2_IOMAP_IMMUTABLE
>       xfs: toggle XFS_DIFLAG2_IOMAP_IMMUTABLE in response to fallocate
>
>
>  fs/attr.c                   |   10 ++
>  fs/open.c                   |   22 +++++
>  fs/read_write.c             |    3 +
>  fs/xfs/libxfs/xfs_format.h  |    5 +
>  fs/xfs/xfs_bmap_util.c      |  181 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_util.h      |    5 +
>  fs/xfs/xfs_file.c           |   16 +++-
>  fs/xfs/xfs_inode.c          |    2
>  fs/xfs/xfs_ioctl.c          |    7 ++
>  fs/xfs/xfs_iops.c           |    8 +-
>  include/linux/falloc.h      |    4 +
>  include/linux/fs.h          |    2
>  include/uapi/linux/falloc.h |   20 +++++
>  include/uapi/linux/fs.h     |    1
>  mm/filemap.c                |    5 +
>  15 files changed, 282 insertions(+), 9 deletions(-)
