From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 11:43:09 -0400
Message-ID: <56FD458D.3020007@gmail.com>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
 <20160331003242.GA5813@localhost.localdomain>
 <20160331075529.GB4209@infradead.org>
 <3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2016-03-31 11:31, Andreas Dilger wrote:
> On Mar 31, 2016, at 1:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
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
>
> Because of snapshots that could hold references to the old blocks,
> there isn't even the guarantee that the previous fallocated blocks will
> be released in a reasonable time to free up an equal amount of space.

That really depends on how it's done.  AFAIK, unwritten extents on BTRFS 
are block reservations which make sure that you can write there (IOW, 
the unwritten extent gets converted to a regular extent in-place, not 
via COW).  This means that it is possible to guarantee that the first 
write to that area will work, which is technically all that POSIX 
requires.  This in turn means that stuff like SystemD and RDBMS software 
don't exactly see things working as they expect them too, but that's 
because they make assumptions based on existing technology.

