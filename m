From: adam.manzanares@wdc.com
Subject: [PATCH v3 0/3] AIO add per-command iopriority
Date: Tue,  8 May 2018 10:41:59 -0700
Message-ID: <20180508174202.2537-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

This is the per-I/O equivalent of the ioprio_set system call.
See the following link for performance implications on a SATA HDD:
https://lkml.org/lkml/2016/12/6/495

First patch factors ioprio_check_cap function out of ioprio_set system call to 
also be used by the aio ioprio interface.

Second patch converts kiocb ki_hint field to a u16 to avoid kiocb bloat.

Third patch passes ioprio hint from aio iocb to kiocb and enables block_dev 
usage of the per I/O ioprio feature.

v2: merge patches
    use IOCB_FLAG_IOPRIO
    validate intended use with IOCB_IOPRIO
    add linux-api and linux-block to cc

v3: add ioprio_check_cap function
    convert kiocb ki_hint to u16
    use ioprio_check_cap when adding ioprio to kiocb in aio.c

Adam Manzanares (3):
  block: add ioprio_check_cap function
  fs: Convert kiocb rw_hint from enum to u16
  fs: Add aio iopriority support for block_dev

 block/ioprio.c               | 22 ++++++++++++++++------
 fs/aio.c                     | 16 ++++++++++++++++
 fs/block_dev.c               |  2 ++
 include/linux/fs.h           | 17 +++++++++++++++--
 include/linux/ioprio.h       |  2 ++
 include/uapi/linux/aio_abi.h |  1 +
 6 files changed, 52 insertions(+), 8 deletions(-)

-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
