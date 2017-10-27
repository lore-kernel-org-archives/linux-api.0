From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Date: Fri, 27 Oct 2017 11:13:01 +0200
Message-ID: <20171027091301.GG31161@quack2.suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
 <20171024222322.GX3666@dastard>
 <20171026154804.GF31161@quack2.suse.cz>
 <20171027064301.GC22931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171027064301.GC22931-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 27-10-17 08:43:01, Christoph Hellwig wrote:
> On Thu, Oct 26, 2017 at 05:48:04PM +0200, Jan Kara wrote:
> > But now that I look at XFS implementation again, it misses handling
> > of VM_FAULT_NEEDSYNC in xfs_filemap_pfn_mkwrite() (ext4 gets this right).
> > I'll fix this by using __xfs_filemap_fault() for xfs_filemap_pfn_mkwrite()
> > as well since it mostly duplicates it anyway... Thanks for inquiring!
> 
> My first patches move xfs_filemap_pfn_mkwrite to use __xfs_filemap_fault,
> but that didn't work.  Wish I'd remember why, though.

Maybe due to the additional check on IS_DAX(inode) in __xfs_filemap_fault()
which could do the wrong thing if per-inode DAX flag is switched? Because
otherwise __xfs_filemap_fault(vmf, PE_SIZE_PTE, true) does exactly the same
thing as xfs_filemap_pfn_mkwrite() did.

If we do care about per-inode DAX flag switching, I can just fixup
xfs_filemap_pfn_mkwrite() but my understanding was that we ditched the idea
at least until someone comes up with a reliable way to implement that...

							Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
