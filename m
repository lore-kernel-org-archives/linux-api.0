From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Date: Tue, 24 Oct 2017 15:08:08 +0200
Message-ID: <20171024130808.GC8556@quack2.suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-2-jack@suse.cz>
 <20171020072707.GA18000@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171020072707.GA18000-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 20-10-17 00:27:07, Christoph Hellwig wrote:
> >  	if (file) {
> >  		struct inode *inode = file_inode(file);
> > +		unsigned long flags_mask = file->f_op->mmap_supported_flags;
> > +
> > +		if (!flags_mask)
> > +			flags_mask = LEGACY_MAP_MASK;
> >  
> >  		switch (flags & MAP_TYPE) {
> >  		case MAP_SHARED:
> > +			/*
> > +			 * Silently ignore unsupported flags - MAP_SHARED has
> > +			 * traditionally behaved like that and we don't want
> > +			 * to break compatibility.
> > +			 */
> > +			flags &= flags_mask;
> > +			/*
> > +			 * Force use of MAP_SHARED_VALIDATE with non-legacy
> > +			 * flags. E.g. MAP_SYNC is dangerous to use with
> > +			 * MAP_SHARED as you don't know which consistency model
> > +			 * you will get.
> > +			 */
> > +			flags &= LEGACY_MAP_MASK;
> > +			/* fall through */
> > +		case MAP_SHARED_VALIDATE:
> > +			if (flags & ~flags_mask)
> > +				return -EOPNOTSUPP;
> 
> Hmmm.  I'd expect this to worth more like:
> 
> 		case MAP_SHARED:
> 			/* Ignore all new flags that need validation: */
> 			flags &= LEGACY_MAP_MASK;
> 			/*FALLTHROUGH*/
> 		case MAP_SHARED_VALIDATE:
> 			if (flags & ~file->f_op->mmap_supported_flags)
> 				return -EOPNOTSUPP;
> 
> with the legacy mask always implicitly support as indicated in my
> comment to the XFS patch.

I was thinking about this. Originally I thought that mmap_supported_flags
would allow also to declare some legacy flags as unsupported and also it
seemed as a nicer symmetric interface to me. But I guess the need to mask
out legacy flags is mostly theoretical so I'm fine giving that up. So I'll
change this as you suggest.

> Although even the ignoring in MAP_SHARED seems dangerous, but I guess
> we need that to keep strict backwards compatibility.  In world I'd
> rather do
> 
> 	case MAP_SHARED:
> 		if (flags & ~LEGACY_MAP_MASK)
> 			return -EINVAL;

Yes, I think just ignoring new flags for MAP_SHARED is safer...

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
