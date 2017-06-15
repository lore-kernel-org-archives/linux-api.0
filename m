From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 0/10 v12] No wait AIO
Date: Thu, 15 Jun 2017 16:51:41 -0500
Message-ID: <1003b3e8-a775-e8ac-d1ca-11055d941a98@suse.de>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
 <20170615112528.7cbdfd6cdf26a5c13450acdf@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170615112528.7cbdfd6cdf26a5c13450acdf@linux-foundation.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org



On 06/15/2017 01:25 PM, Andrew Morton wrote:
> On Thu, 15 Jun 2017 10:59:52 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> 
>> This series adds nonblocking feature to asynchronous I/O writes.
>> io_submit() can be delayed because of a number of reason:
>>  - Block allocation for files
>>  - Data writebacks for direct I/O
>>  - Sleeping because of waiting to acquire i_rwsem
>>  - Congested block device
>>
>> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
>> any of these conditions are met. This way userspace can push most
>> of the write()s to the kernel to the best of its ability to complete
>> and if it returns -EAGAIN, can defer it to another thread.
>>
>> In order to enable this, IOCB_RW_FLAG_NOWAIT is introduced in
>> uapi/linux/aio_abi.h. If set for aio_rw_flags, it translates to
>> IOCB_NOWAIT for struct iocb, REQ_NOWAIT for bio.bi_opf and IOMAP_NOWAIT for
>> iomap. aio_rw_flags is a new flag replacing aio_reserved1. We could
>> not use aio_flags because it is not currently checked for invalidity
>> in the kernel.
>>
>> This feature is provided for direct I/O of asynchronous I/O only. I have
>> tested it against xfs, ext4, and btrfs while I intend to add more filesystems.
>> The nowait feature is for request based devices. In the future, I intend to
>> add support to stacked devices such as md.
>>
>> Applications will have to check supportability by sending a async direct write
>> and any other error besides -EAGAIN would mean it is not supported.
>>
> 
> How accurate it this?  For example, the changes to
> generic_file_direct_write() appear to greatly reduce the chances of
> blocking but there are surely race opportunities which will still
> result in userspace unexpectedly experiencing blocking in a succeednig
> write() call?

We are not reducing the chance of blocking, but detecting if the call
would block and return to userspace as soon as possible rather than
waiting for the blocking factor. One of the blocking factor is the mutex
inode->i_rwsem (formerly i_mutex). The performance gain should come from
the application depending on how they use it. Here is an example:

A database application has compute and I/O threads. This effort will
allow the compute threads to push writes without the need of context
switch to I/O thread, since it knows that it will end soon enough
without blocking. If a IOCB does block (and returns -EAGAIN), it would
be deferred to the I/O thread. Usually the compute thread should know
the offsets of writes, and be careful not to overwrite other writes.

> 
> If correct then I think there should be some discussion and perhaps
> testing results in the changelog.

I will be posting one test case to xfstests.


> I have only minor quibbles - I'll grab the patch series for some -next
> testing (at least).
> 

I agree to the quibbles you have on patch 02/10. Should I send the
entire fixed series, just the 02/10 patch, or would you prefer to fix it?

-- 
Goldwyn
