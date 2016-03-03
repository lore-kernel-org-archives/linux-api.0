From: Christoph Hellwig <hch@lst.de>
Subject: selective block polling and preadv2/pwritev2 revisited V3
Date: Thu, 3 Mar 2016 16:11:16 +0100
Message-ID: <20160303151116.GA24614@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <56D853B5.9000906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D853B5.9000906@dev.mellanox.co.il>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 05:09:41PM +0200, Sagi Grimberg wrote:
> Heh... Looks like you got your cover-letters mixed up :)

Looks like it indeed..

Here is the right one:


This series allows to selectively enable/disable polling for completions
in the block layer on a per-I/O basis.  For this it resurrects the
preadv2/pwritev2 syscalls that Milosz prepared a while ago (and which
are much simpler now due to VFS changes that happened in the meantime).
That approach also had a man page update prepared, which I will resubmit
with the current flags once this series makes it in.

Polling for block I/O is important to reduce the latency on flash and
post-flash storage technologies.  On the fastest NVMe controller I have
access to it almost halves latencies from over 7 microseconds to about 4
microseonds.  But it only is usesful if we actually care for the latency
of this particular I/O, and generally is a waste if enabled for all I/O
to a given device.  This series uses the per-I/O flags in preadv2/pwritev2
to control this behavior.  The alternative would be a new O_* flag set
at open time or using fcntl, but this is still to corse-grained for some
applications and we're starting to run out out of open flags.

Note that there are plenty of other use cases for preadv2/pwritev2 as well,
but I'd like to concentrate on this one for now.  Example are: non-blocking
reads (the original purpose), per-I/O O_SYNC, user space support for T10
DIF/DIX applications tags and probably some more.

Changes since V2:
 - minor style fixes
 - various changelog updates
 - dropped the unused REQ_POLL flag

Changes since V1:
 - rebased on top of Linux 4.5-rc5

