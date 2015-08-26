From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Persistent Reservation API V3
Date: Wed, 26 Aug 2015 18:56:49 +0200
Message-ID: <1440608214-14497-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This series adds support for a simplified Persistent Reservation API
to the block layer.  The intent is that both in-kernel and userspace
consumers can use the API instead of having to hand craft SCSI or NVMe
command through the various pass through interfaces.  It also adds
DM support as getting reservations through dm-multipath is a major
pain with the current scheme.

NVMe support currently isn't included as I don't have a multihost
NVMe setup to test on, but Keith offered to test it and I'll have
a patch for it shortly.

The ioctl API is documented in Documentation/block/pr.txt, but to
fully understand the concept you'll have to read up the SPC spec,
PRs are too complicated that trying to rephrase them into different
terminology is just going to create confusion.

Note that Mike wants to include the DM patches so through the DM
tree, so they are only included for reference.

I also have a set of simple test tools available at:

	git://git.infradead.org/users/hch/pr-tests.git

Changes since V2:
  - added an ignore flag to the reserve opertion as well, and redid
    the ioctl API to have general flags fields
  - rebased on top of the latest block layer tree updates
Changes since V1:
  - rename DM ->ioctl to ->prepare_ioctl
  - rename dm_get_ioctl_table to dm_get_live_table_for_ioctl
  - merge two DM patches into one
  - various spelling fixes
