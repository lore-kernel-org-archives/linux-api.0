From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/19] fs: add fget_many() and fput_many()
Date: Sat, 9 Feb 2019 10:41:04 +0100
Message-ID: <25f32b18-54b9-0566-920b-2b90ef5ede72@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-9-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-9-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> Some uses cases repeatedly get and put references to the same file, but
> the only exposed interface is doing these one at the time. As each of
> these entail an atomic inc or dec on a shared structure, that cost can
> add up.
> 
> Add fget_many(), which works just like fget(), except it takes an
> argument for how many references to get on the file. Ditto fput_many(),
> which can drop an arbitrary number of references to a file.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/file.c            | 15 ++++++++++-----
>   fs/file_table.c      |  9 +++++++--
>   include/linux/file.h |  2 ++
>   include/linux/fs.h   |  4 +++-
>   4 files changed, 22 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
