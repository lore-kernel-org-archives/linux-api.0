From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO buffers
Date: Wed, 30 Jan 2019 00:08:44 +0100
Message-ID: <CAG48ez1m22z0Pqi0cT=UZdsA14SCM5579T1d40cZdyD6KqBw_g@mail.gmail.com>
References: <20190129192702.3605-1-axboe@kernel.dk> <20190129192702.3605-13-axboe@kernel.dk>
 <CAG48ez2VkeSEZA+9H4UAcg86uC77gU=UkTG8L1V58TuR9pDEqg@mail.gmail.com>
 <dd366179-c003-752f-743d-2bea4f6b796c@kernel.dk> <CAG48ez3x5x+P=8L1p-bHvcUnypeT1TizkXq2+Q0bCP0GdE-bog@mail.gmail.com>
 <87b25ce2-a5bc-3e81-ddba-5c932c71b40f@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <87b25ce2-a5bc-3e81-ddba-5c932c71b40f@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 30, 2019 at 12:06 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/29/19 4:03 PM, Jann Horn wrote:
> > On Tue, Jan 29, 2019 at 11:56 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 1/29/19 3:44 PM, Jann Horn wrote:
> >>> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> If we have fixed user buffers, we can map them into the kernel when we
> >>>> setup the io_context. That avoids the need to do get_user_pages() for
> >>>> each and every IO.
> >>>>
> >>>> To utilize this feature, the application must call io_uring_register()
> >>>> after having setup an io_uring context, passing in
> >>>> IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer
> >>>> to an iovec array, and the nr_args should contain how many iovecs the
> >>>> application wishes to map.
> >>>>
> >>>> If successful, these buffers are now mapped into the kernel, eligible
> >>>> for IO. To use these fixed buffers, the application must use the
> >>>> IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
> >>>> set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
> >>>> must point to somewhere inside the indexed buffer.
> >>>>
> >>>> The application may register buffers throughout the lifetime of the
> >>>> io_uring context. It can call io_uring_register() with
> >>>> IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
> >>>> buffers, and then register a new set. The application need not
> >>>> unregister buffers explicitly before shutting down the io_uring context.
> > [...]
> >>>> +       imu = &ctx->user_bufs[index];
> >>>> +       buf_addr = READ_ONCE(sqe->addr);
> >>>> +       if (buf_addr < imu->ubuf || buf_addr + len > imu->ubuf + imu->len)
> >>>
> >>> This can wrap around if `buf_addr` or `len` is very big, right? Then
> >>> you e.g. get past the first check because `buf_addr` is sufficiently
> >>> big, and get past the second check because `buf_addr + len` wraps
> >>> around and becomes small.
> >>
> >> Good point. I wonder if we have a verification helper for something like
> >> this?
> >
> > check_add_overflow() exists, I guess that might help a bit. I don't
> > think I've seen a more specific helper for this situation.
>
> Hmm, not super appropriate. How about something ala:
>
> if (buf_addr + len < buf_addr)
>     ... overflow ...
>
> ?

Sure, sounds good.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
