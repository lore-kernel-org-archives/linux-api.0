From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 5/5] fs: iomap dio set bio prio from kiocb prio
Date: Mon, 21 May 2018 16:59:25 -0400
Message-ID: <x49wovwu3ma.fsf@segfault.boston.devel.redhat.com>
References: <20180521160147.2372-1-adam.manzanares@wdc.com>
	<20180521160147.2372-6-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180521160147.2372-6-adam.manzanares@wdc.com> (adam
	manzanares's message of "Mon, 21 May 2018 09:01:47 -0700")
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org, tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradead.org
List-Id: linux-api@vger.kernel.org

adam.manzanares@wdc.com writes:

> From: Adam Manzanares <adam.manzanares@wdc.com>
>
> Now that kiocb has an ioprio field copy this over to the bio when it is
> created from the kiocb during direct IO.
>
> Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


> ---
>  fs/iomap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/iomap.c b/fs/iomap.c
> index afd163586aa0..65aae194aeca 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -919,6 +919,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		bio->bi_iter.bi_sector =
>  			(iomap->addr + pos - iomap->offset) >> 9;
>  		bio->bi_write_hint = dio->iocb->ki_hint;
> +		bio->bi_ioprio = dio->iocb->ki_ioprio;
>  		bio->bi_private = dio;
>  		bio->bi_end_io = iomap_dio_bio_end_io;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
