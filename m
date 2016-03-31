From: Liu Bo <bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Wed, 30 Mar 2016 17:32:42 -0700
Message-ID: <20160331003242.GA5813@localhost.localdomain>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
Reply-To: bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160330182755.GC2236-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Christoph and I have been working on adding reflink and CoW support to
> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
> that future file writes cannot ENOSPC, I extended the XFS fallocate
> handler to unshare any shared blocks via the copy on write mechanism I
> built for it.  However, Christoph shared the following concerns with
> me about that interpretation:
> 
> > I know that I suggested unsharing blocks on fallocate, but it turns out
> > this is causing problems.  Applications expect falloc to be a fast
> > metadata operation, and copying a potentially large number of blocks
> > is against that expextation.  This is especially bad for the NFS
> > server, which should not be blocked for a long time in a synchronous
> > operation.
> > 
> > I think we'll have to remove the unshare and just fail the fallocate
> > for a reflinked region for now.  I still think it makes sense to expose
> > an unshare operation, and we probably should make that another
> > fallocate mode.

I'm expecting fallocate to be fast, too.

Well, btrfs fallocate doesn't allocate space if it's a shared one
because it thinks the space is already allocated.  So a later overwrite
over this shared extent may hit enospc errors.

> 
> With that in mind, how do you all think we ought to resolve this?
> Should we add a new fallocate mode flag that means "unshare the shared
> blocks"?  Obviously, this unshare flag cannot be used in conjunction
> with hole punching, zero range, insert range, or collapse range.  This
> breaks the expectation that writing to a file after fallocate won't
> ENOSPC.
> 
> Or is it ok that fallocate could block, potentially for a long time as
> we stream cows through the page cache (or however unshare works
> internally)?  Those same programs might not be expecting fallocate to
> take a long time.
> 
> Can we do better than either solution?  It occurs to me that XFS does
> unshare by reading the file data into the pagecache, marking the pages
> dirty, and flushing the dirty pages; performance could be improved by
> skipping the flush at the end.  We won't ENOSPC, because the XFS
> delalloc system is careful enough to check that there are enough free
> blocks to handle both the allocation and the metadata updates.  The
> only gap in this scheme that I can see is if we fallocate, crash, and
> upon restart the program then tries to write without retrying the
> fallocate.  Can we trade some performance for the added requirement
> that we must fallocate -> write -> fsync, and retry the trio if we
> crash before the fsync returns?  I think that's already an implicit
> requirement, so we might be ok here.
> 
> Opinions?  I rather like the last option, though I've only just
> thought of it and have not had time to examine it thoroughly, and it's
> specific to XFS. :)

I'd vote for another mode for 'unshare the shared blocks'.

Thanks,

-liubo
