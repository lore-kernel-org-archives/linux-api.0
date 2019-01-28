From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 09/18] io_uring: use fget/fput_many() for file references
Date: Mon, 28 Jan 2019 22:56:33 +0100
Message-ID: <CAG48ez0WzBEG5w5faFZ_DjU_62aTT=iBEPHEdYZuyq-LGRJtPw@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-10-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-10-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
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
[...]
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

This looks wrong.

Looking at "[PATCH 05/18] Add io_uring IO interface", as far as I can
tell, io_ring_submit() is called via __io_uring_enter() <-
sys_io_uring_enter() with an unchecked argument "unsigned int
to_submit" that is then, in this patch, stored in state->ios_left and
then used here. On a 32-bit platform, file->f_count is only 32 bits
wide, so I think you can then trivially overflow the reference count,
leading to use-after-free. Am I missing something?

> +       state->fd = fd;
> +       state->has_refs = state->ios_left;
> +       state->used_refs = 1;
> +       state->ios_left--;
> +       return state->file;
> +}
[...]
> +static void io_submit_state_start(struct io_submit_state *state,
> +                                 struct io_ring_ctx *ctx, unsigned max_ios)
> +{
> +       blk_start_plug(&state->plug);
> +       state->file = NULL;
> +       state->ios_left = max_ios;
> +}
> +
>  static void io_commit_sqring(struct io_ring_ctx *ctx)
>  {
>         struct io_sq_ring *ring = ctx->sq_ring;
> @@ -879,11 +974,13 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
>
>  static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
>  {
> +       struct io_submit_state state, *statep = NULL;
>         int i, ret = 0, submit = 0;
> -       struct blk_plug plug;
>
> -       if (to_submit > IO_PLUG_THRESHOLD)
> -               blk_start_plug(&plug);
> +       if (to_submit > IO_PLUG_THRESHOLD) {
> +               io_submit_state_start(&state, ctx, to_submit);
> +               statep = &state;
> +       }
[...]

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
