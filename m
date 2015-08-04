From: Christoph Hellwig <hch@lst.de>
Subject: Persistent Reservation API
Date: Tue,  4 Aug 2015 09:11:05 +0200
Message-ID: <1438672271-11309-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This series adds support for a simplified persistent reservation API
to the block layer.  The intent is that both in-kernel and userspace
consumers can use the API instead of having to hand craft SCSI or NVMe
command through the various pass through interfaces.  It also adds
DM support as getting reservations through dm-multipath is a major
pain with the current scheme.

NVMe support currently isn't included as I don't have a multihost
NVMe setup to test on, but if I can find a volunteer to test it I'm
happy to write the code for it.

The ioctl API is documented in Documentation/block/pr.txt, but to
fully understand the concept you'll have to read up the SPC spec,
PRs are too complicated that trying to rephrase them into different
terminology is just going to create confusion.

I also have a set of simple test tools available at:

	git://git.infradead.org/users/hch/pr-tests.git

