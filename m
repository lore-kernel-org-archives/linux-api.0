From: Henk Slager <eye1tm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 18:47:50 +0200
Message-ID: <CAPmG0jZEM0a7J1=LZMQ-Y6oM0BgB04uDKdb7MZgNso4QAt=mPA@mail.gmail.com>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
	<20160331075529.GB4209@infradead.org>
	<3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3E147309-67EA-4B29-B4E0-883BA03B7BFC-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Liu Bo <bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 31, 2016 at 5:31 PM, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
> On Mar 31, 2016, at 1:55 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>
>> On Wed, Mar 30, 2016 at 05:32:42PM -0700, Liu Bo wrote:
>>> Well, btrfs fallocate doesn't allocate space if it's a shared one
>>> because it thinks the space is already allocated.  So a later overwrite
>>> over this shared extent may hit enospc errors.
>>
>> And this makes it an incorrect implementation of posix_fallocate,
>> which glibcs implements using fallocate if available.
>
> It isn't really useful for a COW filesystem to implement fallocate()
> to reserve blocks.  Even if it did allocate all of the blocks on the
> initial fallocate() call, when it comes time to overwrite these blocks
> new blocks need to be allocated as the old ones will not be overwritten.

There are also use-cases on BTRFS with CoW disabled, like operations
on virtual machine images that aren't snapshotted.
Those files tend to be big and having fallocate() implemented and
working like for e.g. XFS, in order to achieve space and speed
efficiency, makes sense IMHO.
