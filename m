From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 09/18] io_uring: use fget/fput_many() for file references
Date: Wed, 30 Jan 2019 00:31:05 +0100
Message-ID: <CAG48ez3_1mY1Fb91Q3H-S2+4OiMsV5F9v78JX+YMjWqLteHpzw@mail.gmail.com>
References: <20190129192702.3605-1-axboe@kernel.dk> <20190129192702.3605-10-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190129192702.3605-10-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
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
[...]
> +static void io_file_put(struct io_submit_state *state, struct file *file)
> +{
> +       if (!state) {
> +               fput(file);
> +       } else if (state->file) {
> +               int diff = state->has_refs - state->used_refs;
> +
> +               if (diff)
> +                       fput_many(state->file, diff);
> +               state->file = NULL;
> +       }
> +}

Hmm, this function confuses me.
The state==NULL path works as I'd expect, it calls fput() on the file.
But if `state!=NULL && state->file==NULL`, it does nothing, it never
uses `file`.
And if `state->file!=NULL`, it drops the excess bias on the file's
refcount, but it doesn't drop the current reference - and again
without even looking at `file`.

So when io_prep_rw() uses io_file_get() to grab a reference on a file
it hasn't seen before, it will acquire `ios_left` references and
actually use one of them; then if it goes through the out_fput error
path, it goes through the path for `state->file!=NULL`, drops
`ios_left-1` references (leaving the refcount elevated by 1), and
forgets about the file?

> +/*
> + * Get as many references to a file as we have IOs left in this submission,
> + * assuming most submissions are for one file, or at least that each file
> + * has more than one submission.
> + */
> +static struct file *io_file_get(struct io_submit_state *state, int fd)
> +{
> +       if (!state)
> +               return fget(fd);
> +
> +       if (state->file) {
> +               if (state->fd == fd) {
> +                       state->used_refs++;
> +                       state->ios_left--;
> +                       return state->file;
> +               }
> +               io_file_put(state, NULL);
> +       }
> +       state->file = fget_many(fd, state->ios_left);
> +       if (!state->file)
> +               return NULL;
> +
> +       state->fd = fd;
> +       state->has_refs = state->ios_left;
> +       state->used_refs = 1;
> +       state->ios_left--;
> +       return state->file;
> +}
> +
>  static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> -                     bool force_nonblock)
> +                     bool force_nonblock, struct io_submit_state *state)
>  {
>         struct io_ring_ctx *ctx = req->ctx;
>         struct kiocb *kiocb = &req->rw;
> @@ -487,7 +560,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>         int fd, ret;
>
>         fd = READ_ONCE(sqe->fd);
> -       kiocb->ki_filp = fget(fd);
> +       kiocb->ki_filp = io_file_get(state, fd);
>         if (unlikely(!kiocb->ki_filp))
>                 return -EBADF;
>         kiocb->ki_pos = READ_ONCE(sqe->off);
> @@ -528,7 +601,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>         }
>         return 0;
>  out_fput:
> -       fput(kiocb->ki_filp);
> +       io_file_put(state, kiocb->ki_filp);
>         return ret;
>  }
[...]
> +static void io_submit_state_start(struct io_submit_state *state,
> +                                 struct io_ring_ctx *ctx, unsigned max_ios)

There are various places in your series where you use raw "unsigned"
instead of "unsigned int"; when I run your tree through checkpatch.pl,
it complains about that and a few other things. Please fix the
checkpatch warnings (except for warnings where you know that they
shouldn't apply here for some reason).

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
