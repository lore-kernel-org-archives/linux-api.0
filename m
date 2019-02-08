From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/19] io_uring: add fsync support
Date: Fri, 8 Feb 2019 16:31:22 -0700
Message-ID: <3fb6c108-63c2-6eb4-8e7e-006580277f9f@kernel.dk>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-7-axboe@kernel.dk>
 <CAG48ez1zUf9GqZyoD3XEEYyeg2zrBSAO5uKT3MKHOPMk6eujDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez1zUf9GqZyoD3XEEYyeg2zrBSAO5uKT3MKHOPMk6eujDQ@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 2/8/19 3:36 PM, Jann Horn wrote:
> On Fri, Feb 8, 2019 at 6:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> Add a new fsync opcode, which either syncs a range if one is passed,
>> or the whole file if the offset and length fields are both cleared
>> to zero.  A flag is provided to use fdatasync semantics, that is only
>> force out metadata which is required to retrieve the file data, but
>> not others like metadata.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> [...]
>> +static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>> +                   bool force_nonblock)
>> +{
>> +       struct io_ring_ctx *ctx = req->ctx;
>> +       loff_t sqe_off = READ_ONCE(sqe->off);
>> +       loff_t sqe_len = READ_ONCE(sqe->len);
>> +       loff_t end = sqe_off + sqe_len;
>> +       unsigned fsync_flags;
>> +       struct file *file;
>> +       int ret, fd;
>> +
>> +       /* fsync always requires a blocking context */
>> +       if (force_nonblock)
>> +               return -EAGAIN;
>> +
>> +       if (unlikely(sqe->addr || sqe->ioprio))
>> +               return -EINVAL;
>> +
>> +       fsync_flags = READ_ONCE(sqe->fsync_flags);
>> +       if (unlikely(fsync_flags & ~IORING_FSYNC_DATASYNC))
>> +               return -EINVAL;
>> +
>> +       fd = READ_ONCE(sqe->fd);
>> +       file = fget(fd);
> 
> This always runs on the workqueue, right? Is it possible to call
> fget() on a workqueue?

Oops yes, I've now split that into a io_prep_fsync() and io_fsync()
part so that it works correctly with this new method. Also added a
liburing test for this.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
