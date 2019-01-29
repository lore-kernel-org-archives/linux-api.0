From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 17:18:50 +0100
Message-ID: <CAK8P3a38-FLBH0sp0vaebv29M5oDyiUkwwmVY+9_S3vSER9n5Q@mail.gmail.com>
References: <20190123153536.7081-1-axboe@kernel.dk> <20190123153536.7081-6-axboe@kernel.dk>
 <20190128145700.GA9795@lst.de> <2729ab43-b2bf-44b0-d41d-dbb495ddffbf@kernel.dk>
 <20190129063043.GC2996@lst.de> <CAK8P3a1x4BsFfacxOmaDXKOKmmQ2j0ypX2+mCNCbjH3E7nC4DQ@mail.gmail.com>
 <4b12d149-99f7-0b2e-0c3f-9b477ce48520@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <4b12d149-99f7-0b2e-0c3f-9b477ce48520@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>, linux-block <linux-block@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 29, 2019 at 4:20 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/29/19 4:58 AM, Arnd Bergmann wrote:
> > On Tue, Jan 29, 2019 at 7:30 AM Christoph Hellwig <hch@lst.de> wrote:
> >>> On Mon, Jan 28, 2019 at 11:25:12AM -0700, Jens Axboe wrote:
> >>>> Especially with poll support now in the series, don't we need a =D1=
=95igmask
> >>>> argument similar to pselect/ppoll/io_pgetevents now to deal with sig=
nal
> >>>> blocking during waiting for events?
> >>>
> >>> Is there any way to avoid passing in the sigset_t size? If it's just =
a
> >>> 32-bit/64-bit thing, surely the in_compat_syscall() could cover it? O=
r
> >>> are there other cases that need to be catered to?
> >>
> >> As far as I can tell we never look at it, never looked at it and don't
> >> have any plans to look at it anytime soon.  But when I tried to omit
> >> it for io_pgetevents I got stong pushback and thus had to add the
> >> crazy double indirection calling convention.
>
> That's good info. I am currently using set_user_sigmask() for it.
> I'd really like to avoid having to pass in a sigset_t size for the
> system call, however.

I really wouldn't do it, given that all other signal handling interfaces
are prepared for longer signal masks. You /could/ probably extend
it later with a flags bit to signify a longer mask instead of using
the entire register to hold the bit length, it just seems really
inconsistent with all other system calls.

      Arnd




> What's the best way of achieving that? Can I get
> away with doing something like this:
>
>         if (in_compat_syscall()) {
>                 const compat_sigset_t __user *compat_sig;
>
>                 compat_sig =3D (const compat_sigset_t __user *) sig;
>                 ret =3D set_compat_user_sigmask(compat_sig, &ksigmask,
>                                                 &sigsaved, _NSIG_WORDS);
>         } else {
>                 ret =3D set_user_sigmask(sig, &ksigmask, &sigsaved,
>                                                 _NSIG_WORDS);
>         }

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
