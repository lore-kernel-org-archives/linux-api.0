From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 09/10] xfs: nowait aio support
Date: Tue, 30 May 2017 11:13:29 -0500
Message-ID: <f105d585-e88c-b037-9905-d0c608c609d9@suse.de>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
 <20170528093113.GB14519@infradead.org>
 <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
 <20170529083338.GC1899@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170529083338.GC1899-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adam.manzanares-Sjgp3cTcYWE@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 05/29/2017 03:33 AM, Christoph Hellwig wrote:
> On Sun, May 28, 2017 at 09:38:26PM -0500, Goldwyn Rodrigues wrote:
>>
>>
>> On 05/28/2017 04:31 AM, Christoph Hellwig wrote:
>>> Despite my previous reviewed-by tag this will need another fix:
>>>
>>> xfs_file_iomap_begin needs to return EAGAIN if we don't have the extent
>>> list in memoery already.  E.g. something like this:
>>>
>>> 	if ((flags & IOMAP_NOWAIT) && !(ip->i_d.if_flags & XFS_IFEXTENTS)) {
>>> 		error = -EAGAIN;
>>> 		goto out_unlock;
>>> 	}
>>>
>>> right after locking the ilock.
>>>
>>
>> I am not sure if it is right to penalize the application to write to
>> file which has been freshly opened (and is the first one to open). It
>> basically means extent maps needs to be read from disk. Do you see a
>> reason it would have a non-deterministic wait if it is the only user? I
>> understand the block layer can block if it has too many requests though.
> 
> For either a read or a write we might have to read in the extent list
> (note that for few enough extents they are stored in the inode and
> we won't have to), in which case the call will block and by the
> semantics you define we'll need to return -EAGAIN.

Yes, that is right. I will include it in.

> 
> Btw, can you write a small blurb up for the man page to document these
> ѕemantics in man-page like language?
> 

Yes, but which man page would it belong to?
Should it be a subsection of errors in io_getevents/io_submit. We don't
want to add ERRORS to io_getevents() because it would be the return
value of the io_getevents call, and not the ones in the iocb structure.
Should it be a new man page, say for iocb(7/8)?



-- 
Goldwyn
