From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] clone3: validate stack arguments
Date: Fri, 1 Nov 2019 13:32:57 +0100
Message-ID: <20191101123257.GA508@redhat.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
 <20191031164653.GA24629@redhat.com>
 <20191101110639.icbfihw3fk2nzz4o@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191101110639.icbfihw3fk2nzz4o@wittgenstein>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, GNU C Library <libc-alpha@sourceware.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/01, Christian Brauner wrote:
>
> On Thu, Oct 31, 2019 at 05:46:53PM +0100, Oleg Nesterov wrote:
> > On 10/31, Christian Brauner wrote:
> > >
> > > --- a/include/uapi/linux/sched.h
> > > +++ b/include/uapi/linux/sched.h
> > > @@ -51,6 +51,10 @@
> > >   *               sent when the child exits.
> > >   * @stack:       Specify the location of the stack for the
> > >   *               child process.
> > > + *               Note, @stack is expected to point to the
> > > + *               lowest address. The stack direction will be
> > > + *               determined by the kernel and set up
> > > + *               appropriately based on @stack_size.
> >
> > I can't review this patch, I have no idea what does stack_size mean
> > if !arch/x86.
>
> In short: nothing at all if it weren't for ia64 (and maybe parisc).
> But let me provide some (hopefully useful) context.

Thanks...

> (Probably most of
> that is well-know,

Certainly not to me ;) Thanks.

> > > +static inline bool clone3_stack_valid(struct kernel_clone_args *karg=
s)
> > > +{
> > > +=09if (kargs->stack =3D=3D 0) {
> > > +=09=09if (kargs->stack_size > 0)
> > > +=09=09=09return false;
> > > +=09} else {
> > > +=09=09if (kargs->stack_size =3D=3D 0)
> > > +=09=09=09return false;
> >
> > So to implement clone3_wrapper(void *bottom_of_stack) you need to do
> >
> > =09clone3_wrapper(void *bottom_of_stack)
> > =09{
> > =09=09struct clone_args args =3D {
> > =09=09=09...
> > =09=09=09// make clone3_stack_valid() happy
> > =09=09=09.stack =3D bottom_of_stack - 1,
> > =09=09=09.stack_size =3D 1,
> > =09=09};
> > =09}
> >
> > looks a bit strange. OK, I agree, this example is very artificial.
> > But why do you think clone3() should nack stack_size =3D=3D 0 ?
>
> In short, consistency.

And in my opinion this stack_size =3D=3D 0 check destroys the consistency,
see below.

But just in case, let me say that overall I personally like this change.

> The best thing imho, is to clearly communicate to userspace that stack
> needs to point to the lowest address and stack_size to the initial range
> of the stack pointer

Agreed.

But the kernel can't verify that "stack" actually points to the lowest
address and stack_size is actually the stack size. Consider another
artificial

    =09clone3_wrapper(void *bottom_of_stack, unsigned long offs)
    =09{
    =09=09struct clone_args args =3D {
    =09=09=09...
    =09=09=09// make clone3_stack_valid() happy
    =09=09=09.stack =3D bottom_of_stack - offs,
    =09=09=09.stack_size =3D offs,
    =09=09};
    =09=09sys_clone3(args);
    =09}
=09
Now,

=09clone3_wrapper(bottom_of_stack, offs);

is same thing for _any_ offs except offs =3D=3D 0 will fail. Why? To me thi=
s
is not consistent, I think the "stack_size =3D=3D 0" check buys nothing and
only adds some confusion.

Say, stack_size =3D=3D 1 is "obviously wrong" too, this certainly means tha=
t
"stack" doesn't point to the lowest address (or the child will corrupt the
memory), but it works.

OK, I won't insist. Perhaps it can help to detect the case when a user
forgets to pass the correct stack size.

> > > +=09=09if (!access_ok((void __user *)kargs->stack, kargs->stack_size)=
)
> > > +=09=09=09return false;
> >
> > Why?
>
> It's nice of us to tell userspace _before_ we have created a thread that
> it messed up its parameters instead of starting a thread that then
> immediately crashes.

Heh. Then why this code doesn't verify that at least stack + stack_size is
properly mmaped with PROT_READ|WRITE?

Oleg.
