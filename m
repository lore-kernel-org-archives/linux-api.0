From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v9 1/6] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Date: Thu, 12 Oct 2017 15:51:27 +0200
Message-ID: <20171012135127.GG29293@quack2.suse.cz>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923320.9144.6119113178052262946.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150776923320.9144.6119113178052262946.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 680506faceae..2649c00581a0 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1389,6 +1389,18 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		struct inode *inode = file_inode(file);
>  
>  		switch (flags & MAP_TYPE) {
> +		case MAP_SHARED_VALIDATE:
> +			if ((flags & ~LEGACY_MAP_MASK) == 0) {
> +				/*
> +				 * If all legacy mmap flags, downgrade
> +				 * to MAP_SHARED, i.e. invoke ->mmap()
> +				 * instead of ->mmap_validate()
> +				 */
> +				flags &= ~MAP_TYPE;
> +				flags |= MAP_SHARED;
> +			} else if (!file->f_op->mmap_validate)
> +				return -EOPNOTSUPP;
> +			/* fall through */
>  		case MAP_SHARED:
>  			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
>  				return -EACCES;

When thinking a bit more about this I've realized one problem: Currently
user can call mmap() with MAP_SHARED type and MAP_SYNC or MAP_DIRECT flags
and he will get the new semantics (if the kernel happens to support it).  I
think that is undesirable and we should force usage of MAP_SHARED_VALIDATE
when you want to use flags outside of LEGACY_MAP_MASK. So I'd just mask off
non-legacy flags for MAP_SHARED mappings (so they would be silently ignored
as they used to be until now).

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
