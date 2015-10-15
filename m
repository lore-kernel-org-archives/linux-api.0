From: Christoph Hellwig <hch@lst.de>
Subject: Persistent Reservation API V4
Date: Thu, 15 Oct 2015 14:10:46 +0200
Message-ID: <1444911052-9423-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: keith.busch@intel.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This series adds support for a simplified Persistent Reservation API
to the block layer.  The intent is that both in-kernel and userspace
consumers can use the API instead of having to hand craft SCSI or NVMe
command through the various pass through interfaces.  It also adds
DM support as getting reservations through dm-multipath is a major
pain with the current scheme.

The ioctl API is documented in Documentation/block/pr.txt, but to
fully understand the concept you'll have to read up the SPC spec,
PRs are too complicated that trying to rephrase them into different
terminology is just going to create confusion.

Note that Mike wants to include the DM patches so through the DM
tree, so they are only included for reference.

I also have a set of simple test tools available at

	git://git.infradead.org/users/hch/pr-tests.git

Changes since V3:
  - added NVMe support (from Keith Busch)
  - add a CAP_SYS_ADMIN check for the ioctl
  - tr=D1=96vial rebase to Jens' latests block tree

Changes since V2:
  - added an ignore flag to the reserve opertion as well, and redid
    the ioctl API to have general flags fields
  - rebased on top of the latest block layer tree updates

Changes since V1:
  - rename DM ->ioctl to ->prepare_ioctl
  - rename dm_get_ioctl_table to dm_get_live_table_for_ioctl
  - merge two DM patches into one
  - various spelling fixes
