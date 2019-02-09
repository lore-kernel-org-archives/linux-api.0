From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/19] block: add bio_set_polled() helper
Date: Sat, 9 Feb 2019 10:24:06 +0100
Message-ID: <331ba3f1-979f-01aa-74c1-fa5c53cb5a96@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-4-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-4-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> For the upcoming async polled IO, we can't sleep allocating requests.
> If we do, then we introduce a deadlock where the submitter already
> has async polled IO in-flight, but can't wait for them to complete
> since polled requests must be active found and reaped.
> 
> Utilize the helper in the blockdev DIRECT_IO code.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/block_dev.c      |  4 ++--
>   include/linux/bio.h | 14 ++++++++++++++
>   2 files changed, 16 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
