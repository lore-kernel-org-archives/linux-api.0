From: adam.manzanares@wdc.com
Subject: [PATCH v5 0/5] AIO add per-command iopriority
Date: Mon, 21 May 2018 09:01:42 -0700
Message-ID: <20180521160147.2372-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

This is the per-I/O equivalent of the ioprio_set system call.
See the following link for performance implications on a SATA HDD:
https://lkml.org/lkml/2016/12/6/495

First patch factors ioprio_check_cap function out of ioprio_set system call to
also be used by the aio ioprio interface.

Second patch converts kiocb ki_hint field to a u16 to avoid kiocb bloat.

Third patch passes ioprio hint from aio iocb to kiocb and inititalizes kiocb
ioprio value appropriately when it is not explicitly set.

Fourth patch enables the feature for blkdev.

Fifth patch enables the feature for iomap direct IO

Note: this work is based on top of linux-vfs/for-next

v2: merge patches
    use IOCB_FLAG_IOPRIO
    validate intended use with IOCB_IOPRIO
    add linux-api and linux-block to cc

v3: add ioprio_check_cap function
    convert kiocb ki_hint to u16
    use ioprio_check_cap when adding ioprio to kiocb in aio.c

v4: handle IOCB_IOPRIO in aio_prep_rw
    note patch 3 depends on patch 1 in commit msg

v5: rename ki_hint_valid -> ki_hint_validate 
	remove ki_hint_validate comment and whitespace
	remove IOCB_IOPRIO flag
	initialize kiocb to have no priority 

Adam Manzanares (5):
  block: add ioprio_check_cap function
  fs: Convert kiocb rw_hint from enum to u16
  fs: Add aio iopriority support
  fs: blkdev set bio prio from kiocb prio
  fs: iomap dio set bio prio from kiocb prio

 block/ioprio.c               | 22 ++++++++++++++++------
 drivers/block/loop.c         |  3 +++
 fs/aio.c                     | 16 ++++++++++++++++
 fs/block_dev.c               |  1 +
 fs/iomap.c                   |  1 +
 include/linux/fs.h           | 16 ++++++++++++++--
 include/linux/ioprio.h       |  2 ++
 include/uapi/linux/aio_abi.h |  1 +
 8 files changed, 54 insertions(+), 8 deletions(-)

-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
