From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 07:18:55 -0400
Message-ID: <56FD079F.3060606@gmail.com>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
 <20160331003242.GA5813@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160331003242.GA5813@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: bo.li.liu@oracle.com, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2016-03-30 20:32, Liu Bo wrote:
> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
>> Hi all,
>>
>> Christoph and I have been working on adding reflink and CoW support to
>> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
>> that future file writes cannot ENOSPC, I extended the XFS fallocate
>> handler to unshare any shared blocks via the copy on write mechanism I
>> built for it.  However, Christoph shared the following concerns with
>> me about that interpretation:
>>
>>> I know that I suggested unsharing blocks on fallocate, but it turns out
>>> this is causing problems.  Applications expect falloc to be a fast
>>> metadata operation, and copying a potentially large number of blocks
>>> is against that expextation.  This is especially bad for the NFS
>>> server, which should not be blocked for a long time in a synchronous
>>> operation.
>>>
>>> I think we'll have to remove the unshare and just fail the fallocate
>>> for a reflinked region for now.  I still think it makes sense to expose
>>> an unshare operation, and we probably should make that another
>>> fallocate mode.
>
> I'm expecting fallocate to be fast, too.
>
> Well, btrfs fallocate doesn't allocate space if it's a shared one
> because it thinks the space is already allocated.  So a later overwrite
> over this shared extent may hit enospc errors.
And this _really_ should get fixed, otherwise glibc will add a check for 
running posix_fallocate against BTRFS and force emulation, and people 
_will_ complain about performance.

