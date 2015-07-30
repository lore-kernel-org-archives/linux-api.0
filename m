From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v8 4/6] block: loop: prepare for supporing direct IO
Date: Thu, 30 Jul 2015 11:21:44 -0400
Message-ID: <CACVXFVNKcpL=OQ+9NrCSogKDX2=q1MBmsgUBaFb0SgPMhT96tA@mail.gmail.com>
References: <1438256184-23645-1-git-send-email-ming.lei@canonical.com>
	<1438256184-23645-5-git-send-email-ming.lei@canonical.com>
	<20150730150900.GA13082@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150730150900.GA13082@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>, Maxim Patlasov <mpatlasov@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 11:09 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jul 30, 2015 at 07:36:22AM -0400, Ming Lei wrote:
>> This patches provides one interface for enabling direct IO
>> from user space:
>>
>>       - userspace(such as losetup) can pass 'file' which is
>>       opened/fcntl as O_DIRECT
>>
>> Also __loop_update_dio() is introduced to check if direct I/O
>> can be used on current loop setting.
>>
>> The last big change is to introduce LO_FLAGS_DIRECT_IO flag
>> for userspace to know if direct IO is used to access backing
>> file.
>
> Maybe i'm missing something because I was too busy to follow the
> current discussion, but this still doesn't check that the loop
> device sector size is aligned to the sector size of the underlying
> filesystem.
>
> E.g. with this you could create a loop device with a 512 byte
> sector size on a filesystem with 4k sector size, and it would attempt
> to use direct I/O and fail.

The I/O size & offset has to be checked in I/O path, see patch 6 please,
could you comment on that patch?

>
>> +     unsigned dio_align = inode->i_sb->s_bdev ?
>> +             (bdev_io_min(inode->i_sb->s_bdev) - 1) : 0;
>> +
>> +     /*
>> +      * We support direct I/O only if lo_offset is aligned
>> +      * with the min I/O size of backing device.
>> +      *
>> +      * Request's offset and size will be checked in I/O path.
>> +      */
>> +     if (dio) {
>> +             if (!dio_align || (lo->lo_offset & dio_align))
>> +                     use_dio = false;
>
> Also this means you'll never use direct I/O on network filesystems,
> which really would benefit from it.

OK, that can be done by removing !dio_align in above check.

Thanks,
