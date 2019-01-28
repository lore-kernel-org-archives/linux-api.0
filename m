From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 00:59:32 +0100
Message-ID: <CAG48ez17NW0GJVRC6dFcHZTgQifFz5og1XCUbXkHKhr6f=j74Q@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-6-axboe@kernel.dk>
 <CAG48ez0vDqDH4ks7q4L3F+xt-4kVQrN1yw34QwFAmwQyy27FTw@mail.gmail.com> <e9326a77-54c5-e2b8-d9e5-663261462597@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <e9326a77-54c5-e2b8-d9e5-663261462597@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 12:47 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/28/19 3:32 PM, Jann Horn wrote:
> > On Mon, Jan 28, 2019 at 10:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> The submission queue (SQ) and completion queue (CQ) rings are shared
> >> between the application and the kernel. This eliminates the need to
> >> copy data back and forth to submit and complete IO.
> >>
> >> IO submissions use the io_uring_sqe data structure, and completions
> >> are generated in the form of io_uring_sqe data structures. The SQ
> >> ring is an index into the io_uring_sqe array, which makes it possible
> >> to submit a batch of IOs without them being contiguous in the ring.
> >> The CQ ring is always contiguous, as completion events are inherently
> >> unordered, and hence any io_uring_cqe entry can point back to an
> >> arbitrary submission.
> >>
> >> Two new system calls are added for this:
> >>
> >> io_uring_setup(entries, params)
> >>         Sets up a context for doing async IO. On success, returns a file
> >>         descriptor that the application can mmap to gain access to the
> >>         SQ ring, CQ ring, and io_uring_sqes.
> >>
> >> io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
> >>         Initiates IO against the rings mapped to this fd, or waits for
> >>         them to complete, or both. The behavior is controlled by the
> >>         parameters passed in. If 'to_submit' is non-zero, then we'll
> >>         try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
> >>         kernel will wait for 'min_complete' events, if they aren't
> >>         already available. It's valid to set IORING_ENTER_GETEVENTS
> >>         and 'min_complete' == 0 at the same time, this allows the
> >>         kernel to return already completed events without waiting
> >>         for them. This is useful only for polling, as for IRQ
> >>         driven IO, the application can just check the CQ ring
> >>         without entering the kernel.
> >>
> >> With this setup, it's possible to do async IO with a single system
> >> call. Future developments will enable polled IO with this interface,
> >> and polled submission as well. The latter will enable an application
> >> to do IO without doing ANY system calls at all.
> >>
> >> For IRQ driven IO, an application only needs to enter the kernel for
> >> completions if it wants to wait for them to occur.
> >>
> >> Each io_uring is backed by a workqueue, to support buffered async IO
> >> as well. We will only punt to an async context if the command would
> >> need to wait for IO on the device side. Any data that can be accessed
> >> directly in the page cache is done inline. This avoids the slowness
> >> issue of usual threadpools, since cached data is accessed as quickly
> >> as a sync interface.
> >>
> >> Sample application: http://git.kernel.dk/cgit/fio/plain/t/io_uring.c
> > [...]
> >> +static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> >> +                     bool force_nonblock)
> >> +{
> >> +       struct kiocb *kiocb = &req->rw;
> >> +       int ret;
> >> +
> >> +       kiocb->ki_filp = fget(sqe->fd);
> >> +       if (unlikely(!kiocb->ki_filp))
> >> +               return -EBADF;
> >> +       kiocb->ki_pos = sqe->off;
> >> +       kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
> >> +       kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
> >> +       if (sqe->ioprio) {
> >> +               ret = ioprio_check_cap(sqe->ioprio);
> >> +               if (ret)
> >> +                       goto out_fput;
> >> +
> >> +               kiocb->ki_ioprio = sqe->ioprio;
> >> +       } else
> >> +               kiocb->ki_ioprio = get_current_ioprio();
> >> +
> >> +       ret = kiocb_set_rw_flags(kiocb, sqe->rw_flags);
> >> +       if (unlikely(ret))
> >> +               goto out_fput;
> >> +       if (force_nonblock) {
> >> +               kiocb->ki_flags |= IOCB_NOWAIT;
> >> +               req->flags |= REQ_F_FORCE_NONBLOCK;
> >> +       }
> >> +       if (kiocb->ki_flags & IOCB_HIPRI) {
> >> +               ret = -EINVAL;
> >> +               goto out_fput;
> >> +       }
> >> +
> >> +       kiocb->ki_complete = io_complete_rw;
> >> +       return 0;
> >> +out_fput:
> >> +       fput(kiocb->ki_filp);
> >> +       return ret;
> >> +}
> > [...]
> >> +static ssize_t io_read(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> >> +                      bool force_nonblock)
> >> +{
> >> +       struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> >> +       struct kiocb *kiocb = &req->rw;
> >> +       struct iov_iter iter;
> >> +       struct file *file;
> >> +       ssize_t ret;
> >> +
> >> +       ret = io_prep_rw(req, sqe, force_nonblock);
> >> +       if (ret)
> >> +               return ret;
> >> +       file = kiocb->ki_filp;
> >> +
> >> +       ret = -EBADF;
> >> +       if (unlikely(!(file->f_mode & FMODE_READ)))
> >> +               goto out_fput;
> >> +       ret = -EINVAL;
> >> +       if (unlikely(!file->f_op->read_iter))
> >> +               goto out_fput;
> >> +
> >> +       ret = io_import_iovec(req->ctx, READ, sqe, &iovec, &iter);
> >> +       if (ret)
> >> +               goto out_fput;
> >> +
> >> +       ret = rw_verify_area(READ, file, &kiocb->ki_pos, iov_iter_count(&iter));
> >> +       if (!ret) {
> >> +               ssize_t ret2;
> >> +
> >> +               /* Catch -EAGAIN return for forced non-blocking submission */
> >> +               ret2 = call_read_iter(file, kiocb, &iter);
> >> +               if (!force_nonblock || ret2 != -EAGAIN)
> >> +                       io_rw_done(kiocb, ret2);
> >> +               else
> >> +                       ret = -EAGAIN;
> >> +       }
> >> +       kfree(iovec);
> >> +out_fput:
> >> +       if (unlikely(ret))
> >> +               fput(file);
> >> +       return ret;
> >> +}
> > [...]
> >> +static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >> +                          struct sqe_submit *s, bool force_nonblock)
> >> +{
> >> +       const struct io_uring_sqe *sqe = s->sqe;
> >> +       ssize_t ret;
> >> +
> >> +       if (unlikely(s->index >= ctx->sq_entries))
> >> +               return -EINVAL;
> >> +       req->user_data = sqe->user_data;
> >> +
> >> +       ret = -EINVAL;
> >> +       switch (sqe->opcode) {
> >> +       case IORING_OP_NOP:
> >> +               ret = io_nop(req, sqe);
> >> +               break;
> >> +       case IORING_OP_READV:
> >> +               ret = io_read(req, sqe, force_nonblock);
> >> +               break;
> >> +       case IORING_OP_WRITEV:
> >> +               ret = io_write(req, sqe, force_nonblock);
> >> +               break;
> >> +       default:
> >> +               ret = -EINVAL;
> >> +               break;
> >> +       }
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static void io_sq_wq_submit_work(struct work_struct *work)
> >> +{
> >> +       struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> >> +       struct sqe_submit *s = &req->submit;
> >> +       u64 user_data = s->sqe->user_data;
> >> +       struct io_ring_ctx *ctx = req->ctx;
> >> +       mm_segment_t old_fs = get_fs();
> >> +       struct files_struct *old_files;
> >> +       int ret;
> >> +
> >> +        /* Ensure we clear previously set forced non-block flag */
> >> +       req->flags &= ~REQ_F_FORCE_NONBLOCK;
> >> +
> >> +       old_files = current->files;
> >> +       current->files = ctx->sqo_files;
> >
> > I think you're not supposed to twiddle with current->files without
> > holding task_lock(current).
>
> 'current' is the work queue item in this case, do we need to protect
> against anything else? I can add the locking around the assignments
> (both places).

Stuff like proc_fd_link() uses get_files_struct(), which grabs a
reference to your current files_struct protected only by task_lock();
and it doesn't use anything like READ_ONCE(), so even if the object
lifetime is not a problem, get_files_struct() could potentially crash
due to a double-read (reading task->files twice and assuming that the
result will be the same). As far as I can tell, this procfs code also
works on kernel threads.

> >> +       if (!mmget_not_zero(ctx->sqo_mm)) {
> >> +               ret = -EFAULT;
> >> +               goto err;
> >> +       }
> >> +
> >> +       use_mm(ctx->sqo_mm);
> >> +       set_fs(USER_DS);
> >> +
> >> +       ret = __io_submit_sqe(ctx, req, s, false);
> >> +
> >> +       set_fs(old_fs);
> >> +       unuse_mm(ctx->sqo_mm);
> >> +       mmput(ctx->sqo_mm);
> >> +err:
> >> +       if (ret) {
> >> +               io_cqring_add_event(ctx, user_data, ret, 0);
> >> +               io_free_req(req);
> >> +       }
> >> +       current->files = old_files;
> >> +}
> > [...]
> >> +static int io_sq_offload_start(struct io_ring_ctx *ctx)
> >> +{
> >> +       int ret;
> >> +
> >> +       ctx->sqo_mm = current->mm;
> >
> > What keeps this thing alive?
>
> I think we're deadling with the same thing as the files below, I'll
> defer to that.
>
> >> +       /*
> >> +        * This is safe since 'current' has the fd installed, and if that gets
> >> +        * closed on exit, then fops->release() is invoked which waits for the
> >> +        * async contexts to flush and exit before exiting.
> >> +        */
> >> +       ret = -EBADF;
> >> +       ctx->sqo_files = current->files;
> >> +       if (!ctx->sqo_files)
> >> +               goto err;
> >
> > That's gnarly. Adding Al Viro to the thread.
> >
> > I think you misunderstand the semantics of f_op->release. The ->flush
> > handler is invoked whenever a file descriptor is closed through
> > filp_close() (via deletion of the files_struct, sys_close(),
> > sys_dup2(), ...), so if you had used that one, _maybe_ this would
> > work. But the ->release handler only runs when the _last_ reference to
> > a struct file has been dropped - so you can, for example, fork() a
> > child, then exit() in the parent, and the ->release handler isn't
> > invoked. So I don't see how this can work.
>
> The anonfd is CLOEXEC. The idea is exactly that it only runs when the
> last reference to the file has been dropped. Not sure why you think I
> need ->flush() here?

Can't I just use fcntl(fd, F_SETFD, fd, 0) to clear the CLOEXEC flag?
Or send the fd via SCM_RIGHTS?

> > But even if you had abused ->flush for this instead: close_files()
> > currently has a comment in it that claims that "this is the last
> > reference to the files structure"; this change would make that claim
> > untrue.
>
> Let me see if I can explain my intent better than that comment... We
> know the parent who set up the io_uring instance will be around for as
> long as io_uring instance persists.

That's the part that I think is wrong: As far as I can tell, the
parent can go away and you won't notice.

Also, note that "the parent" is different things for ->files and ->mm.
You can have a multithreaded process whose threads don't have the same
->files, or multiple process that share ->files without sharing ->mm,
...

> When we are tearing down the
> io_uring, then we wait for any async contexts (like the one above) to
> exit. Once they are exited, it's safe to proceed with the exit and
> teardown ->files[].

But you only do that teardown on ->release, right? And ->release
doesn't have much to do with the process lifetime.

> That's the idea... Not trying to be clever, some of this dates back to
> the aio weirdness where it was impossible to have cross references like
> this, since it would lead to teardown deadlocks with how exit_aio() is
> used. I can probably grab a struct files reference above, but currently
> I don't see why it's needed.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
