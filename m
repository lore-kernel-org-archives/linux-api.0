From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] nowait aio: Introduce RWF_NOWAIT
Date: Tue, 18 Apr 2017 23:39:30 -0700
Message-ID: <20170419063930.GB20053@infradead.org>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-3-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170414120257.8932-3-rgoldwyn@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

>  	}
>  
> -
>  	/* prevent overflows */

Weird whitespace change.

> @@ -1593,6 +1593,11 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	}
>  
>  	req->common.ki_flags |= iocb_rw_flags(iocb->aio_rw_flags);
> +	if ((req->common.ki_flags & IOCB_NOWAIT) &&
> +	    !(req->common.ki_flags & IOCB_DIRECT)) {
> +			ret = -EINVAL;
> +			goto out_put_req;
> +		}

Wrong indentation.  Also I think this should be EOPNOTSUPP here.
