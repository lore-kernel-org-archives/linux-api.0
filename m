From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/19] fs: add an iopoll method to struct file_operations
Date: Sat, 9 Feb 2019 10:20:54 +0100
Message-ID: <4232068f-17c8-1f8c-a556-6254172bcd85@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-2-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-2-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> This new methods is used to explicitly poll for I/O completion for an
> iocb.  It must be called for any iocb submitted asynchronously (that
> is with a non-null ki_complete) which has the IOCB_HIPRI flag set.
> 
> The method is assisted by a new ki_cookie field in struct iocb to store
> the polling cookie.
> 
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   Documentation/filesystems/vfs.txt | 3 +++
>   include/linux/fs.h                | 2 ++
>   2 files changed, 5 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
