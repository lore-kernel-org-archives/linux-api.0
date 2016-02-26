From: Stephen Bates <Stephen.Bates@pmcs.com>
Subject: RE: selective block polling and preadv2/pwritev2 revisited V2
Date: Fri, 26 Feb 2016 15:06:45 +0000
Message-ID: <36F6EBABA23FEF4391AF72944D228901EB714D26@BBYEXM01.pmc-sierra.internal>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1456160876-14560-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@fb.com" <axboe@fb.com>
Cc: "milosz@adfin.com" <milosz@adfin.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> 
> This series allows to selectively enable/disable polling for completions in the
> block layer on a per-I/O basis.  For this it resurrects the
> preadv2/pwritev2 syscalls that Milosz prepared a while ago (and which are
> much simpler now due to VFS changes that happened in the meantime).
> That approach also had a man page update prepared, which I will resubmit
> with the current flags once this series makes it in.
> 
> Polling for block I/O is important to reduce the latency on flash and post-flash
> storage technologies.  On the fastest NVMe controller I have access to it
> almost halves latencies from over 7 microseconds to about 4 microseonds.
> But it only is usesful if we actually care for the latency of this particular I/O,
> and generally is a waste if enabled for all I/O to a given device.  This series
> uses the per-I/O flags in preadv2/pwritev2 to control this behavior.  The
> alternative would be a new O_* flag set at open time or using fcntl, but this is
> still to corse-grained for some applications and we're starting to run out out
> of open flags.

Thanks Christoph for re-submitting this. I for one am very supportive of being able to set priority (and other) flags on a per IO basis. I did some testing of this on a NVMe SSD that uses DRAM rather than NAND as its backing store. My performance absolutes are a bit worse than yours but the improvement of HIPRI over a normal IO was about the same with one thread (3-4us) and was a little bit more (6-7us) at a higher thread count. 

I used a fork of fio with a (rather ugly) hack to enable the new syscalls [1]. I then tested this on a per-thread basis using the following simple shell script. 

#!/bin/bash

FIO=/home/mtr/batesste/fio-git/fio
FILE=/dev/nvme0n1
THREADS=5
TIME=30

$FIO --name lowpri --filename=$FILE --size=1G --direct=1 \
    --ioengine=pvsync --rw=randread --bs=4k --runtime=$TIME \
    --numjobs=$THREADS --iodepth=1 --randrepeat=0 \
    --refill_buffers \
    --name hipri --filename=$FILE --size=1G --direct=1 \
    --ioengine=pv2sync --rw=randread --bs=4k --runtime=$TIME \
    --numjobs=$THREADS --iodepth=1 --randrepeat=0 \
    --refill_buffers

I also reviewed the code and it all looks good to me!

For the series:

Reviewed-by: Stephen Bates <stephen.bates@pmcs.com>
Tested-by: Stephen Bates <stephen.bates@pmcs.com> 

> Note that there are plenty of other use cases for preadv2/pwritev2 as well,
> but I'd like to concentrate on this one for now.  Example are: non-blocking
> reads (the original purpose), per-I/O O_SYNC, user space support for T10
> DIF/DIX applications tags and probably some more.
> 

 Totally agree!

[1] https://github.com/sbates130272/fio/tree/hipri
