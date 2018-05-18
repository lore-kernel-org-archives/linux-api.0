From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 0/3] AIO add per-command iopriority
Date: Thu, 17 May 2018 20:41:32 -0600
Message-ID: <3ec960cf-e14c-6ff6-3356-186136f43df7@kernel.dk>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517203803.2664-1-adam.manzanares@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bcrl@kvack.org
Cc: mingo@kernel.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 5/17/18 2:38 PM, adam.manzanares@wdc.com wrote:
> From: Adam Manzanares <adam.manzanares@wdc.com>
> 
> This is the per-I/O equivalent of the ioprio_set system call.
> See the following link for performance implications on a SATA HDD:
> https://lkml.org/lkml/2016/12/6/495
> 
> First patch factors ioprio_check_cap function out of ioprio_set system call to
> also be used by the aio ioprio interface.
> 
> Second patch converts kiocb ki_hint field to a u16 to avoid kiocb bloat.
> 
> Third patch passes ioprio hint from aio iocb to kiocb and enables block_dev
> usage of the per I/O ioprio feature.
> 
> v2: merge patches
>     use IOCB_FLAG_IOPRIO
>     validate intended use with IOCB_IOPRIO
>     add linux-api and linux-block to cc
> 
> v3: add ioprio_check_cap function
>     convert kiocb ki_hint to u16
>     use ioprio_check_cap when adding ioprio to kiocb in aio.c
> 
> v4: handle IOCB_IOPRIO in aio_prep_rw
>     note patch 3 depends on patch 1 in commit msg
> 
> Adam Manzanares (3):
>   block: add ioprio_check_cap function
>   fs: Convert kiocb rw_hint from enum to u16
>   fs: Add aio iopriority support for block_dev
> 
>  block/ioprio.c               | 22 ++++++++++++++++------
>  fs/aio.c                     | 16 ++++++++++++++++
>  fs/block_dev.c               |  2 ++
>  include/linux/fs.h           | 17 +++++++++++++++--
>  include/linux/ioprio.h       |  2 ++
>  include/uapi/linux/aio_abi.h |  1 +
>  6 files changed, 52 insertions(+), 8 deletions(-)

This looks fine to me now. I can pick up #1 for 4.18 - and 2+3 as well,
unless someone else wants to take them.

-- 
Jens Axboe
