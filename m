From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Date: Tue, 15 Aug 2017 14:42:50 +0200
Message-ID: <20170815124250.GG27505@quack2.suse.cz>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150277754211.23945.458876600578531019.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 14-08-17 23:12:22, Dan Williams wrote:
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index ff151814a02d..73fdc0ada9ee 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -306,6 +306,7 @@ struct vm_area_struct {
>  	struct mm_struct *vm_mm;	/* The address space we belong to. */
>  	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
>  	unsigned long vm_flags;		/* Flags, see mm.h. */
> +	unsigned long fs_flags;		/* fs flags, see MAP_DIRECT etc */
>  
>  	/*
>  	 * For areas with an address space and backing store,

Ah, OK, here are VMA flags I was missing in the previous patch :) But why
did you create separate fs_flags field for this? on 64-bit archs there's
still space in vm_flags and frankly I don't see why we should separate
MAP_DIRECT or MAP_SYNC from other flags? After all a difference in these
flags must also prevent VMA merging (which you forgot to handle I think)
and they need to be copied on split (which happens by chance even now).

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
