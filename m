From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Fri, 1 Feb 2019 18:04:29 +0100
Message-ID: <CAG48ez09iOOnPz83b6HxktYHTfouS2GD6i3PfQEjp8WCp+3-VA@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-6-axboe@kernel.dk>
 <CAG48ez0vDqDH4ks7q4L3F+xt-4kVQrN1yw34QwFAmwQyy27FTw@mail.gmail.com>
 <e9326a77-54c5-e2b8-d9e5-663261462597@kernel.dk> <CAG48ez17NW0GJVRC6dFcHZTgQifFz5og1XCUbXkHKhr6f=j74Q@mail.gmail.com>
 <05cb18f7a97a6151c305cdb7240c4abc995aed59.camel@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <05cb18f7a97a6151c305cdb7240c4abc995aed59.camel@fb.com>
Sender: owner-linux-aio@kvack.org
To: Matt Mullins <mmullins@fb.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, "avi@scylladb.com" <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 1, 2019 at 5:57 PM Matt Mullins <mmullins@fb.com> wrote:
> On Tue, 2019-01-29 at 00:59 +0100, Jann Horn wrote:
> > On Tue, Jan 29, 2019 at 12:47 AM Jens Axboe <axboe@kernel.dk> wrote:
> > > On 1/28/19 3:32 PM, Jann Horn wrote:
> > > > On Mon, Jan 28, 2019 at 10:35 PM Jens Axboe <axboe@kernel.dk> wrote=
:
> > > > > The submission queue (SQ) and completion queue (CQ) rings are sha=
red
> > > > > between the application and the kernel. This eliminates the need =
to
> > > > > copy data back and forth to submit and complete IO.
> > > > >
> > > > > IO submissions use the io_uring_sqe data structure, and completio=
ns
> > > > > are generated in the form of io_uring_sqe data structures. The SQ
> > > > > ring is an index into the io_uring_sqe array, which makes it poss=
ible
> > > > > to submit a batch of IOs without them being contiguous in the rin=
g.
> > > > > The CQ ring is always contiguous, as completion events are inhere=
ntly
> > > > > unordered, and hence any io_uring_cqe entry can point back to an
> > > > > arbitrary submission.
> > > > >
> > > > > Two new system calls are added for this:
> > > > >
> > > > > io_uring_setup(entries, params)
> > > > >         Sets up a context for doing async IO. On success, returns=
 a file
> > > > >         descriptor that the application can mmap to gain access t=
o the
> > > > >         SQ ring, CQ ring, and io_uring_sqes.
> > > > >
> > > > > io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigset=
size)
> > > > >         Initiates IO against the rings mapped to this fd, or wait=
s for
> > > > >         them to complete, or both. The behavior is controlled by =
the
> > > > >         parameters passed in. If 'to_submit' is non-zero, then we=
'll
> > > > >         try and submit new IO. If IORING_ENTER_GETEVENTS is set, =
the
> > > > >         kernel will wait for 'min_complete' events, if they aren'=
t
> > > > >         already available. It's valid to set IORING_ENTER_GETEVEN=
TS
> > > > >         and 'min_complete' =3D=3D 0 at the same time, this allows=
 the
> > > > >         kernel to return already completed events without waiting
> > > > >         for them. This is useful only for polling, as for IRQ
> > > > >         driven IO, the application can just check the CQ ring
> > > > >         without entering the kernel.
> > > > >
> > > > > With this setup, it's possible to do async IO with a single syste=
m
> > > > > call. Future developments will enable polled IO with this interfa=
ce,
> > > > > and polled submission as well. The latter will enable an applicat=
ion
> > > > > to do IO without doing ANY system calls at all.
> > > > >
> > > > > For IRQ driven IO, an application only needs to enter the kernel =
for
> > > > > completions if it wants to wait for them to occur.
> > > > >
> > > > > Each io_uring is backed by a workqueue, to support buffered async=
 IO
> > > > > as well. We will only punt to an async context if the command wou=
ld
> > > > > need to wait for IO on the device side. Any data that can be acce=
ssed
> > > > > directly in the page cache is done inline. This avoids the slowne=
ss
> > > > > issue of usual threadpools, since cached data is accessed as quic=
kly
> > > > > as a sync interface.
> > > > >
> > > > > Sample application: https://urldefense.proofpoint.com/v2/url?u=3D=
http-3A__git.kernel.dk_cgit_fio_plain_t_io-5Furing.c&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3DpqM-eO4A2hNFhIFiX-7eGg&m=3DMGr14pOzNbC7Z-8_dV4GMiH3Abkk=
H0RSQoQ894Tu0yc&s=3DmgbcubzOMiCpFpnwW-HA3ey0YDYPkgMIZ7Bmy4w6Chc&e=3D
> > > >
> > > > [...]
> > > > > +static int io_prep_rw(struct io_kiocb *req, const struct io_urin=
g_sqe *sqe,
> > > > > +                     bool force_nonblock)
> > > > > +{
> > > > > +       struct kiocb *kiocb =3D &req->rw;
> > > > > +       int ret;
> > > > > +
> > > > > +       kiocb->ki_filp =3D fget(sqe->fd);
> > > > > +       if (unlikely(!kiocb->ki_filp))
> > > > > +               return -EBADF;
> > > > > +       kiocb->ki_pos =3D sqe->off;
> > > > > +       kiocb->ki_flags =3D iocb_flags(kiocb->ki_filp);
> > > > > +       kiocb->ki_hint =3D ki_hint_validate(file_write_hint(kiocb=
->ki_filp));
> > > > > +       if (sqe->ioprio) {
> > > > > +               ret =3D ioprio_check_cap(sqe->ioprio);
> > > > > +               if (ret)
> > > > > +                       goto out_fput;
> > > > > +
> > > > > +               kiocb->ki_ioprio =3D sqe->ioprio;
> > > > > +       } else
> > > > > +               kiocb->ki_ioprio =3D get_current_ioprio();
> > > > > +
> > > > > +       ret =3D kiocb_set_rw_flags(kiocb, sqe->rw_flags);
> > > > > +       if (unlikely(ret))
> > > > > +               goto out_fput;
> > > > > +       if (force_nonblock) {
> > > > > +               kiocb->ki_flags |=3D IOCB_NOWAIT;
> > > > > +               req->flags |=3D REQ_F_FORCE_NONBLOCK;
> > > > > +       }
> > > > > +       if (kiocb->ki_flags & IOCB_HIPRI) {
> > > > > +               ret =3D -EINVAL;
> > > > > +               goto out_fput;
> > > > > +       }
> > > > > +
> > > > > +       kiocb->ki_complete =3D io_complete_rw;
> > > > > +       return 0;
> > > > > +out_fput:
> > > > > +       fput(kiocb->ki_filp);
> > > > > +       return ret;
> > > > > +}
> > > >
> > > > [...]
> > > > > +static ssize_t io_read(struct io_kiocb *req, const struct io_uri=
ng_sqe *sqe,
> > > > > +                      bool force_nonblock)
> > > > > +{
> > > > > +       struct iovec inline_vecs[UIO_FASTIOV], *iovec =3D inline_=
vecs;
> > > > > +       struct kiocb *kiocb =3D &req->rw;
> > > > > +       struct iov_iter iter;
> > > > > +       struct file *file;
> > > > > +       ssize_t ret;
> > > > > +
> > > > > +       ret =3D io_prep_rw(req, sqe, force_nonblock);
> > > > > +       if (ret)
> > > > > +               return ret;
> > > > > +       file =3D kiocb->ki_filp;
> > > > > +
> > > > > +       ret =3D -EBADF;
> > > > > +       if (unlikely(!(file->f_mode & FMODE_READ)))
> > > > > +               goto out_fput;
> > > > > +       ret =3D -EINVAL;
> > > > > +       if (unlikely(!file->f_op->read_iter))
> > > > > +               goto out_fput;
> > > > > +
> > > > > +       ret =3D io_import_iovec(req->ctx, READ, sqe, &iovec, &ite=
r);
> > > > > +       if (ret)
> > > > > +               goto out_fput;
> > > > > +
> > > > > +       ret =3D rw_verify_area(READ, file, &kiocb->ki_pos, iov_it=
er_count(&iter));
> > > > > +       if (!ret) {
> > > > > +               ssize_t ret2;
> > > > > +
> > > > > +               /* Catch -EAGAIN return for forced non-blocking s=
ubmission */
> > > > > +               ret2 =3D call_read_iter(file, kiocb, &iter);
> > > > > +               if (!force_nonblock || ret2 !=3D -EAGAIN)
> > > > > +                       io_rw_done(kiocb, ret2);
> > > > > +               else
> > > > > +                       ret =3D -EAGAIN;
> > > > > +       }
> > > > > +       kfree(iovec);
> > > > > +out_fput:
> > > > > +       if (unlikely(ret))
> > > > > +               fput(file);
> > > > > +       return ret;
> > > > > +}
> > > >
> > > > [...]
> > > > > +static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_ki=
ocb *req,
> > > > > +                          struct sqe_submit *s, bool force_nonbl=
ock)
> > > > > +{
> > > > > +       const struct io_uring_sqe *sqe =3D s->sqe;
> > > > > +       ssize_t ret;
> > > > > +
> > > > > +       if (unlikely(s->index >=3D ctx->sq_entries))
> > > > > +               return -EINVAL;
> > > > > +       req->user_data =3D sqe->user_data;
> > > > > +
> > > > > +       ret =3D -EINVAL;
> > > > > +       switch (sqe->opcode) {
> > > > > +       case IORING_OP_NOP:
> > > > > +               ret =3D io_nop(req, sqe);
> > > > > +               break;
> > > > > +       case IORING_OP_READV:
> > > > > +               ret =3D io_read(req, sqe, force_nonblock);
> > > > > +               break;
> > > > > +       case IORING_OP_WRITEV:
> > > > > +               ret =3D io_write(req, sqe, force_nonblock);
> > > > > +               break;
> > > > > +       default:
> > > > > +               ret =3D -EINVAL;
> > > > > +               break;
> > > > > +       }
> > > > > +
> > > > > +       return ret;
> > > > > +}
> > > > > +
> > > > > +static void io_sq_wq_submit_work(struct work_struct *work)
> > > > > +{
> > > > > +       struct io_kiocb *req =3D container_of(work, struct io_kio=
cb, work);
> > > > > +       struct sqe_submit *s =3D &req->submit;
> > > > > +       u64 user_data =3D s->sqe->user_data;
> > > > > +       struct io_ring_ctx *ctx =3D req->ctx;
> > > > > +       mm_segment_t old_fs =3D get_fs();
> > > > > +       struct files_struct *old_files;
> > > > > +       int ret;
> > > > > +
> > > > > +        /* Ensure we clear previously set forced non-block flag =
*/
> > > > > +       req->flags &=3D ~REQ_F_FORCE_NONBLOCK;
> > > > > +
> > > > > +       old_files =3D current->files;
> > > > > +       current->files =3D ctx->sqo_files;
> > > >
> > > > I think you're not supposed to twiddle with current->files without
> > > > holding task_lock(current).
> > >
> > > 'current' is the work queue item in this case, do we need to protect
> > > against anything else? I can add the locking around the assignments
> > > (both places).
> >
> > Stuff like proc_fd_link() uses get_files_struct(), which grabs a
> > reference to your current files_struct protected only by task_lock();
> > and it doesn't use anything like READ_ONCE(), so even if the object
> > lifetime is not a problem, get_files_struct() could potentially crash
> > due to a double-read (reading task->files twice and assuming that the
> > result will be the same). As far as I can tell, this procfs code also
> > works on kernel threads.
> >
> > > > > +       if (!mmget_not_zero(ctx->sqo_mm)) {
> > > > > +               ret =3D -EFAULT;
> > > > > +               goto err;
> > > > > +       }
> > > > > +
> > > > > +       use_mm(ctx->sqo_mm);
> > > > > +       set_fs(USER_DS);
> > > > > +
> > > > > +       ret =3D __io_submit_sqe(ctx, req, s, false);
> > > > > +
> > > > > +       set_fs(old_fs);
> > > > > +       unuse_mm(ctx->sqo_mm);
> > > > > +       mmput(ctx->sqo_mm);
> > > > > +err:
> > > > > +       if (ret) {
> > > > > +               io_cqring_add_event(ctx, user_data, ret, 0);
> > > > > +               io_free_req(req);
> > > > > +       }
> > > > > +       current->files =3D old_files;
> > > > > +}
> > > >
> > > > [...]
> > > > > +static int io_sq_offload_start(struct io_ring_ctx *ctx)
> > > > > +{
> > > > > +       int ret;
> > > > > +
> > > > > +       ctx->sqo_mm =3D current->mm;
> > > >
> > > > What keeps this thing alive?
> > >
> > > I think we're deadling with the same thing as the files below, I'll
> > > defer to that.
> > >
> > > > > +       /*
> > > > > +        * This is safe since 'current' has the fd installed, and=
 if that gets
> > > > > +        * closed on exit, then fops->release() is invoked which =
waits for the
> > > > > +        * async contexts to flush and exit before exiting.
> > > > > +        */
> > > > > +       ret =3D -EBADF;
> > > > > +       ctx->sqo_files =3D current->files;
> > > > > +       if (!ctx->sqo_files)
> > > > > +               goto err;
> > > >
> > > > That's gnarly. Adding Al Viro to the thread.
> > > >
> > > > I think you misunderstand the semantics of f_op->release. The ->flu=
sh
> > > > handler is invoked whenever a file descriptor is closed through
> > > > filp_close() (via deletion of the files_struct, sys_close(),
> > > > sys_dup2(), ...), so if you had used that one, _maybe_ this would
> > > > work. But the ->release handler only runs when the _last_ reference=
 to
> > > > a struct file has been dropped - so you can, for example, fork() a
> > > > child, then exit() in the parent, and the ->release handler isn't
> > > > invoked. So I don't see how this can work.
> > >
> > > The anonfd is CLOEXEC. The idea is exactly that it only runs when the
> > > last reference to the file has been dropped. Not sure why you think I
> > > need ->flush() here?
> >
> > Can't I just use fcntl(fd, F_SETFD, fd, 0) to clear the CLOEXEC flag?
> > Or send the fd via SCM_RIGHTS?
> >
> > > > But even if you had abused ->flush for this instead: close_files()
> > > > currently has a comment in it that claims that "this is the last
> > > > reference to the files structure"; this change would make that clai=
m
> > > > untrue.
> > >
> > > Let me see if I can explain my intent better than that comment... We
> > > know the parent who set up the io_uring instance will be around for a=
s
> > > long as io_uring instance persists.
> >
> > That's the part that I think is wrong: As far as I can tell, the
> > parent can go away and you won't notice.
> >
> > Also, note that "the parent" is different things for ->files and ->mm.
> > You can have a multithreaded process whose threads don't have the same
> > ->files, or multiple process that share ->files without sharing ->mm,
> > ...
>
> This had actually been get_files_struct() in early versions, and I had
> reported to Jens that it allows something like
>
> int main() {
>   struct io_uring_params uring_params =3D {
>         .flags =3D IORING_SETUP_SQPOLL,
>   };
>   int uring_fd =3D syscall(425 /* io_uring_setup */, 16, &uring_params);
> }
>
> to leak both the files_struct and the kthread, as the files_struct and
> the uring context form a circular reference.  I haven't really come up
> with a good way to reconcile the requirements here; perhaps we need an
> exit_uring() akin to exit_aio()?

Oh, yuck. Uuuh... can we make "struct files_struct" doubly-refcounted,
like "struct mm_struct"? One reference type to keep the contents
intact (the reference type you normally use, and the type used by
uring when the thread is running), and one reference type to just keep
the struct itself existing, but without preserving its contents
(reference held consistently by the uring thread)?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
