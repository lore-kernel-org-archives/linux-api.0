From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/19] iomap: wire up the iopoll method
Date: Sat, 9 Feb 2019 10:25:45 +0100
Message-ID: <e49f04c6-ab75-d0ed-feb0-ab5d02c854a5@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-5-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-5-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Store the request queue the last bio was submitted to in the iocb
> private data in addition to the cookie so that we find the right block
> device.  Also refactor the common direct I/O bio submission code into a
> nice little helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Modified to use bio_set_polled().
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/gfs2/file.c        |  2 ++
>   fs/iomap.c            | 43 ++++++++++++++++++++++++++++---------------
>   fs/xfs/xfs_file.c     |  1 +
>   include/linux/iomap.h |  1 +
>   4 files changed, 32 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
