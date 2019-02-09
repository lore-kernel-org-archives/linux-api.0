From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/19] io_uring: use fget/fput_many() for file references
Date: Sat, 9 Feb 2019 10:42:53 +0100
Message-ID: <b2fdc431-4ad3-9d15-39c8-9d0e7736fa22@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-10-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-10-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> Add a separate io_submit_state structure, to cache some of the things
> we need for IO submission.
> 
> One such example is file reference batching. io_submit_state. We get as
> many references as the number of sqes we are submitting, and drop
> unused ones if we end up switching files. The assumption here is that
> we're usually only dealing with one fd, and if there are multiple,
> hopefuly they are at least somewhat ordered. Could trivially be extended
> to cover multiple fds, if needed.
> 
> On the completion side we do the same thing, except this is trivially
> done just locally in io_iopoll_reap().
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c | 142 ++++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 121 insertions(+), 21 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
