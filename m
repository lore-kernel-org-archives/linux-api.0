From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 07:13:50 -0400
Message-ID: <56FD066E.4080204@gmail.com>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org> <56FC21DE.7090308@gmail.com>
 <20160331075801.GC4209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20160331075801.GC4209@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2016-03-31 03:58, Christoph Hellwig wrote:
> On Wed, Mar 30, 2016 at 02:58:38PM -0400, Austin S. Hemmelgarn wrote:
>> Nothing that I can find in the man-pages or API documentation for Linux's
>> fallocate explicitly says that it will be fast.  There are bits that say it
>> should be efficient, but that is not itself well defined (given context, I
>> would assume it to mean that it doesn't use as much I/O as writing out that
>> many bytes of zero data, not necessarily that it will return quickly).
>
> And that's pretty much as narrow as an defintion we get.  But apparently
> gfs2 already breaks that expectation :(
GFS2 breaks other expectations as well (mostly stuff with locking) in 
arguably more significant ways, so I would not personally consider it to 
be precedent for breaking this on other filesystems.
>
>>> delalloc system is careful enough to check that there are enough free
>>> blocks to handle both the allocation and the metadata updates.  The
>>> only gap in this scheme that I can see is if we fallocate, crash, and
>>> upon restart the program then tries to write without retrying the
>>> fallocate.  Can we trade some performance for the added requirement
>>> that we must fallocate -> write -> fsync, and retry the trio if we
>>> crash before the fsync returns?  I think that's already an implicit
>>> requirement, so we might be ok here.
>> Most of the software I've seen that doesn't use fallocate like this is
>> either doing odd things otherwise, or is just making sure it has space for
>> temporary files, so I think it is probably safe to require this.
>
> posix_fallocate gurantees you that you don't get ENOSPC from the write,
> and there is plenty of software relying on that or crashing / cause data
> integrity problems that way.
>
posix_fallocate is not the same thing as the fallocate syscall.  It's 
there for compatibility, it has less functionality, and most 
importantly, it _can_ be slow (because at least glibc will emulate it if 
the underlying FS doesn't support fallocate, which means it's no faster 
than just using dd).
