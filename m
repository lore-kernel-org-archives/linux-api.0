From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: selective block polling and preadv2/pwritev2 revisited V3
Date: Thu, 03 Mar 2016 16:52:55 +0100
Message-ID: <2369295.6CpmrvqZVS@wuerfel>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <56D853B5.9000906@dev.mellanox.co.il> <20160303151116.GA24614@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160303151116.GA24614-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 03 March 2016 16:11:16 Christoph Hellwig wrote:
> 
> This series allows to selectively enable/disable polling for completions
> in the block layer on a per-I/O basis.  For this it resurrects the
> preadv2/pwritev2 syscalls that Milosz prepared a while ago (and which
> are much simpler now due to VFS changes that happened in the meantime).
> That approach also had a man page update prepared, which I will resubmit
> with the current flags once this series makes it in.
> 
> Polling for block I/O is important to reduce the latency on flash and
> post-flash storage technologies.  On the fastest NVMe controller I have
> access to it almost halves latencies from over 7 microseconds to about 4
> microseonds.  But it only is usesful if we actually care for the latency
> of this particular I/O, and generally is a waste if enabled for all I/O
> to a given device.  This series uses the per-I/O flags in preadv2/pwritev2
> to control this behavior.  The alternative would be a new O_* flag set
> at open time or using fcntl, but this is still to corse-grained for some
> applications and we're starting to run out out of open flags.
> 
> Note that there are plenty of other use cases for preadv2/pwritev2 as well,
> but I'd like to concentrate on this one for now.  Example are: non-blocking
> reads (the original purpose), per-I/O O_SYNC, user space support for T10
> DIF/DIX applications tags and probably some more.

If we decide to revise the asm-generic/unistd.h system call list
for future architecture ports, can the syscalls replace all of
read/write/readv/writev/pread64/write64/preadv/pwritev, or would
it be better to keep all of them around indefinitely?

When we introduced the generic syscall table, I tried to limit
it to the syscalls that are actually needed and avoid all duplications,
but since then we have added a couple of calls that can replace old
ones, and we might want to do that when risc-v gets merged.

	Arnd
