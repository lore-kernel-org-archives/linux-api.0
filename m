From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 07/10] block: return on congested block device
Date: Thu, 15 Jun 2017 10:42:58 -0600
Message-ID: <6e138fe9-ad88-bf94-f0bb-c95d2f3cb705@kernel.dk>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
 <20170615160002.17233-8-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170615160002.17233-8-rgoldwyn@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On 06/15/2017 09:59 AM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> A new bio operation flag REQ_NOWAIT is introduced to identify bio's
> orignating from iocb with IOCB_NOWAIT. This flag indicates
> to return immediately if a request cannot be made instead
> of retrying.
> 
> Stacked devices such as md (the ones with make_request_fn hooks)
> currently are not supported because it may block for housekeeping.
> For example, an md can have a part of the device suspended.
> For this reason, only request based devices are supported.
> In the future, this feature will be expanded to stacked devices
> by teaching them how to handle the REQ_NOWAIT flags.

Looks fine to me now. I don't know what tree will take these patches,
but if it's not block, then you can add:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
