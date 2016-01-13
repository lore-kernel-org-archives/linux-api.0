From: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Date: Tue, 12 Jan 2016 20:36:58 -0600
Message-ID: <20160113023658.GA1551@zzz>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
 <20151219085559.12478.33700.stgit@birch.djwong.org>
 <20160112060714.GA4980@zzz>
 <20160112091432.GB7832@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160112091432.GB7832-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 12, 2016 at 01:14:32AM -0800, Darrick J. Wong wrote:
> 
> Frankly, I also wouldn't mind changing the VFS dedupe ioctl that to something
> that resembles the clone_range interface:
> 
> int ioctl(int dest_fd, FIDEDUPERANGE, struct file_dedupe_range * arg);

Getting rid of the vectorization certainly avoids a lot of API complexity.  I
don't know precisely why it was made vectorized in the first place, but to me it
seems it shouldn't be vectorized unless there's a strong reason for it to be.

> Not sure what you mean by 'symmetric', but in any case the convention seems
> to be that src_fd's storage is shared with dest_fd if there's a match.
> ...
> I think the result of an earlier discussion was that src_fd must be readable,
> and dest_fd must be writable or appendable.

Deduplication is a strange operation since you're not "reading" or "writing" in
the traditional sense.  All file data stays exactly the same from a user
perspective.

So rather than arbitrarily say that you're "reading" from one file and "writing"
to the other, one possibility is to have an API where you submit two files and
the implementation decides how to best deduplicate them.  That could involve
sharing existing extents in file 1 with file 2; or sharing existing extents in
file 2 with file 1; or creating a new extent and referencing it from each file.
It would be up to the implementation to choose the most efficient approach.

But I take it that the existing btrfs ioctl doesn't work that way, and it always
will share the existing extents in file 1 with file 2.

That's probably a perfectly fine way to do it, but I was wondering whether it
really makes sense to hard-code that detail in the API, since an API could be
defined more generally.

And from a practical perpective, people using the ioctl to deduplicate two files
need to know which one to submit to the API as the "source" and which as the
"destination", if it matters.

Related to this are the permissions you need on each file descriptor.  Since
deduplication isn't "reading" or "writing" in the traditional sense it could,
theoretically, be argued that no permissions at all should be required: neither
FMODE_READ nor FMODE_WRITE.

Most likely are concerns that would make that a bad idea, though.  Perhaps
someone could create mischief by causing fragmentation in system files.

If this was previously discussed, can you point me to that discussion?

The proposed man page is also very brief on permissions, only mentioning them
indirectly in the error codes section.

> > The man page also says you get EPERM if "dest_fd is immutable" and ETXTBSY if
> > "one of the files is a swap file", which I don't see actually happening in
> > the implementation; it seems those error codes perhaps exist at all for this
> > ioctl but rather be left to open(..., O_WRONLY).
> 
> Those could be hoisted to the VFS (from the XFS implementation), I think.

If the destination file has to already be open for writing then it can't be
immutable.  So I don't think that error code is needed.  Checking for an active
swapfile, on the other hand, may be valid, although I don't see such a check
anywhere in the version of the code I'm looking at.

> I'll later take a look at how many of these issues apply to clone/clone_range.

clone and clone_range seem to avoid the two biggest issues I saw: they aren't
vectorized, and there's a natural distinction between the "source" and the
"destination" of the operation.  They definitely need careful consideration as
well, though.
