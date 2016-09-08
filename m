From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 3/3] ioctl_xfs_ioc_getfsmap.2: document XFS_IOC_GETFSMAP
 ioctl
Date: Fri, 9 Sep 2016 09:38:06 +1000
Message-ID: <20160908233806.GB30056@dastard>
References: <147216758326.32321.8525481353986871349.stgit@birch.djwong.org>
 <147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
 <32A3DAED-21FC-4252-B53E-3503764342E8@dilger.ca>
 <20160830190949.GA8262@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160830190949.GA8262-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 30, 2016 at 12:09:49PM -0700, Darrick J. Wong wrote:
> > I recall for FIEMAP that some filesystems may not have files aligned
> > to sector offsets, and we just used byte offsets.  Storage like
> > NVDIMMs are cacheline granular, so I don't think it makes sense to
> > tie this to old disk sector sizes.  Alternately, the units could be
> > in terms of fs blocks as returned by statvfs.st_bsize, but mixing
> > units for fmv_block, fmv_offset, fmv_length is uneeded complexity.
> 
> Ugh.  I'd rather just change the units to bytes rather than force all
> the users to multiply things. :)

Yup, units need to be either in disk addresses (i.e. 512 byte units)
or bytes. If people can't handle disk addresses (seems to be the
case), the bytes it should be.

> I'd much rather just add more special owner codes for any other
> filesystem that has distinguishable metadata types that are not
> covered by the existing OWN_ codes.  We /do/ have 2^64 possible
> values, so it's not like we're going to run out.

This is diagnositc information as much as anything, just like
fiemap is diagnostic information. So if we have specific type
information, it needs to be reported accurately to be useful.

Hence I really don't care if the users and developers of other fs
types don't understand what the special owner codes that a specific
filesystem returns mean. i.e. it's not useful user information -
only a tool that groks the specific filesystem is going to be able
to anything useful with special owner codes. So, IMO, there's little
point trying to make them generic or to even trying to define and
explain them in the man page....

> > It seems like there are several fields in the structure that are used for
> > only input or only output?  Does it make more sense to have one structure
> > used only for the input request, and then the array of values returned be
> > in a different structure?  I'm not necessarily requesting that it be changed,
> > but it definitely is something I noticed a few times while reading this doc.
> 
> I've been thinking about rearranging this a bit, since the flags
> handling is very awkward with the current array structure.  Each
> rmap has its own flags; we may someday want to pass operation flags
> into the ioctl; and we currently have one operation flag to pass back
> to userspace.  Each of those flags can be a separate field.  I think
> people will get confused about FMV_OF_* and FMV_HOF_* being referenced
> in oflags, and iflags has no meaning for returned records.

Yup, that's what I initially noticed when I glanced at this. The XFS
getbmap interface is just plain nasty, and we shouldn't be copying
that API pattern if we can help it.

> So, this instead?
> 
> struct getfsmap_rec {
> 	u32 device;		/* device id */
> 	u32 flags;		/* mapping flags */
> 	u64 block;		/* physical addr, bytes */
> 	u64 owner;		/* inode or special owner code */
> 	u64 offset;		/* file offset of mapping, bytes */
> 	u64 length;		/* length of segment, bytes */
> 	u64 reserved;		/* will be set to zero */
> }; /* 48 bytes */
> 
> struct getfsmap_head {
> 	u32 iflags;		/* none defined yet */
> 	u32 oflags;		/* FMV_HOF_DEV_T */
> 	u32 count;		/* # entries in recs array */
> 	u32 entries;		/* # entries filled in (output) */
> 	u64 reserved[2]; 	/* must be zero */
> 
> 	struct getfsmap_rec keys[2]; /* low and high keys for the mapping search */
> 	struct getfsmap_rec recs[0];
> }; /* 32 bytes + 2*48 = 128 bytes */
> 
> #define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct getfsmap_head)
> 
> This also means that userspace can set up for the next ioctl
> invocation with memcpy(&head->keys[0], &head->recs[head->entries - 1]).
> 
> Yes, I think I like this better.  Everyone else, please chime in. :)

That's pretty much the structure I was going to suggest - it matches
the fiemap pattern. i.e control parameters are separated from record
data. I'd dump a bit more reserved space in the structure, though;
we've got heaps of flag space for future expansion, but if we need
to pass new parameters into/out of the kernel we'll quickly use the
reserved space.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
