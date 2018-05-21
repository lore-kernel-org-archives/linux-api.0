From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 0/5] AIO add per-command iopriority
Date: Mon, 21 May 2018 16:57:37 -0400
Message-ID: <x49fu2kvi9q.fsf@segfault.boston.devel.redhat.com>
References: <20180521160147.2372-1-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180521160147.2372-1-adam.manzanares@wdc.com> (adam
	manzanares's message of "Mon, 21 May 2018 09:01:42 -0700")
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org, tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradead.org
List-Id: linux-api@vger.kernel.org

Hi, Adam,

adam.manzanares@wdc.com writes:

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
> Third patch passes ioprio hint from aio iocb to kiocb and inititalizes kiocb
> ioprio value appropriately when it is not explicitly set.
>
> Fourth patch enables the feature for blkdev.
>
> Fifth patch enables the feature for iomap direct IO
>
> Note: this work is based on top of linux-vfs/for-next

I'll cook up a libaio test case.  Can you put together a man-pages
update for this?

Thanks!
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
