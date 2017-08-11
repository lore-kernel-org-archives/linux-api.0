From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 2/6] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Date: Sat, 12 Aug 2017 09:27:08 +1000
Message-ID: <20170811232708.GT21024@dastard>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150243356799.8777.11625037981403766282.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150243356799.8777.11625037981403766282.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 10, 2017 at 11:39:28PM -0700, Dan Williams wrote:
> >From falloc.h:
> 
>     FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
>     file logical-to-physical extent offset mappings in the file. The
>     purpose is to allow an application to assume that there are no holes
>     or shared extents in the file and that the metadata needed to find
>     all the physical extents of the file is stable and can never be
>     dirtied.
> 
> For now this patch only permits setting the in-memory state of
> S_IOMAP_IMMMUTABLE. Support for clearing and persisting the state is
> saved for later patches.
> 
> The implementation is careful to not allow the immutable state to change
> while any process might have any established mappings. It reuses the
> existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
> extents and fill all holes in the file. It then holds XFS_ILOCK_EXCL
> while it validates the file is in the proper state and sets
> S_IOMAP_IMMUTABLE.

SO I've been thinking about this - I'm thinking that we need to
separate the changes to the extent map from the action of sealing
the extent map.

That is, I have a need to freeze an extent map without any
modification to it at all and breaking all the sharing and filling
all the holes completely screws up the file layout I need to
preserve. i.e. I want to be able to freeze the maps of a pair of
reflinked files so I can use FIEMAP to query only the changed blocks
and then read out the data in the private/changed blocks in the
reflinked file. I only need a temporary seal (if we crash it goes
away), so maybe there's another command modifier flag needed here,
too.

The DAX allocation requirements can be handled by a preallocation
call to filll holes with zeros, followed by an unshare call to break
all the COW mappings, and then the extent map can be sealed. If you
need to check for holes after sealing, SEEK_HOLE will tell you what
you need to know...

My preference really is for each fallocate command to do just one
thing - having the seal operation also modify the extent map
means it's not useful for the use cases where we need the extent map
to remain unmodified....

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
