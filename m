From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] clone3: validate stack arguments
Date: Thu, 31 Oct 2019 17:46:53 +0100
Message-ID: <20191031164653.GA24629@redhat.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106504-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Content-Disposition: inline
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, GNU C Library <libc-alpha@sourceware.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/31, Christian Brauner wrote:
>
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -51,6 +51,10 @@
>   *               sent when the child exits.
>   * @stack:       Specify the location of the stack for the
>   *               child process.
> + *               Note, @stack is expected to point to the
> + *               lowest address. The stack direction will be
> + *               determined by the kernel and set up
> + *               appropriately based on @stack_size.

I can't review this patch, I have no idea what does stack_size mean
if !arch/x86.

x86 doesn't use stack_size unless a kthread does kernel_thread(), so
this change is probably fine...

Hmm. Off-topic question, why did 7f192e3cd3 ("fork: add clone3") add
"& ~CSIGNAL" in kernel_thread() ? This looks pointless and confusing
to me...

> +static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
> +{
> +=09if (kargs->stack =3D=3D 0) {
> +=09=09if (kargs->stack_size > 0)
> +=09=09=09return false;
> +=09} else {
> +=09=09if (kargs->stack_size =3D=3D 0)
> +=09=09=09return false;

So to implement clone3_wrapper(void *bottom_of_stack) you need to do

=09clone3_wrapper(void *bottom_of_stack)
=09{
=09=09struct clone_args args =3D {
=09=09=09...
=09=09=09// make clone3_stack_valid() happy
=09=09=09.stack =3D bottom_of_stack - 1,
=09=09=09.stack_size =3D 1,
=09=09};
=09}

looks a bit strange. OK, I agree, this example is very artificial.
But why do you think clone3() should nack stack_size =3D=3D 0 ?

> +=09=09if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
> +=09=09=09return false;

Why?

Oleg.
