From: Jann Horn <jannh@google.com>
Subject: Re: For review: documentation of clone3() system call
Date: Tue, 29 Oct 2019 16:20:37 +0100
Message-ID: <CAG48ez1pH9fGacQF6m7=R39bDMRqNR_ML7d2v-e=-kVLJhBuPA@mail.gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <CAG48ez3q=BeNcuVTKBN79kJui4vC6nw0Bfq6xc-i0neheT17TA@mail.gmail.com>
 <20191028172143.4vnnjpdljfnexaq5@wittgenstein> <CAG48ez20hn8vToY+=C62nA-rbUfxh=JD6N-f7XVS3_GZOoPjxw@mail.gmail.com>
 <20191029112706.p5dd5yzpcgouo6n5@wittgenstein> <20191029142622.jxmssu4s4ndui7bw@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191029142622.jxmssu4s4ndui7bw@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Florian Weimer <fweimer@redhat.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 3:26 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Tue, Oct 29, 2019 at 12:27:07PM +0100, Christian Brauner wrote:
> > On Mon, Oct 28, 2019 at 08:09:13PM +0100, Jann Horn wrote:
> > > On Mon, Oct 28, 2019 at 6:21 PM Christian Brauner
> > > <christian.brauner@ubuntu.com> wrote:
> > > > where stack + stack_size is addition on a void pointer which usually
> > > > clang and gcc are not very happy about.
> > > > I wanted to bring this up on the mailing list soon: If possible, I don't
> > > > want userspace to need to know about stack direction and just have stack
> > > > point to the beginning and then have the kernel do the + stack_size
> > > > after the copy_clone_args_from_user() if the arch needs it. For example,
> > > > by having a dumb helder similar to copy_thread_tls()/coyp_thread() that
> > > > either does the + stack_size or not. Right now, clone3() is supported on
> > > > parisc and afaict, the stack grows upwards for it. I'm not sure if there
> > > > are obvious reasons why that won't work or it would be a bad idea...
> > >
> > > That would mean adding a new clone flag that redefines how those
> > > parameters work and describing the current behavior in the manpage as
> > > the behavior without the flag (which doesn't exist on 5.3), right?
> >
> > I would break API and if someone reports breakage we'll revert and go
> > the more complicated route you outlined (see [1]).
>
> @Jann, I think the following patch might even be enough?...
[...]
> +static inline void clone3_prepare_stack(struct kernel_clone_args *kargs)
> +{
> +#if !defined(CONFIG_STACK_GROWSUP) && !defined(CONFIG_IA64)
> +       kargs->stack += kargs->stack_size;
> +#endif
> +}

I guess it might work as long as nobody is actually using clone3 yet
and you can get this patch into the 5.3 stable tree and any distro
kernels on 5.3 before people do start using clone3?
