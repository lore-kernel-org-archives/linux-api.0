From: Christoph Hellwig <hch@lst.de>
Subject: io_pgetevents & aio fsync V2
Date: Wed, 28 Mar 2018 09:26:33 +0200
Message-ID: <20180328072639.16885-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
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

Changes since V1:
 - remove a BUG_ON_ONE(is_sync_kiocb(kiocb));
 - moved cancellation patches to the poll series
 - improve a list_empty check

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
