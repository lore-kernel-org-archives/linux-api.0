From: Christoph Hellwig <hch@lst.de>
Subject: io_pgetevents & aio fsync V3
Date: Sun, 15 Apr 2018 17:01:01 +0200
Message-ID: <20180415150108.1341-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi all,

this patch adds workqueue based fsync offload.  Version of this
patch have been floating around for a couple years, but we now
have a user with seastar used by ScyllaDB (who sponsored this
work) that really wants this in addition to the aio poll support.
More details are in the patch itself.

Because the iocb types have been defined sine day one (and probably
were supported by RHEL3) libaio already supports these calls as-is.

This also pulls in the aio cleanups and io_pgetevents support previously
submitted and review as part of the aio poll series.  The aio poll
series will be resubmitted on top of this series

A git tree is available here:

    git://git.infradead.org/users/hch/vfs.git aio-fsync.3

Gitweb:

    http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-fsync.3

Changes since V2:
 - don't introduce a use after free for lockdep sb release tracking
 - set up list for cancellation before I/O submission

Changes since V1:
 - remove a BUG_ON_ONE(is_sync_kiocb(kiocb));
 - moved cancellation patches to the poll series
 - improve a list_empty check
