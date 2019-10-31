From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] clone3: validate stack arguments
Date: Thu, 31 Oct 2019 14:27:30 +0000
Message-ID: <7f59e7e573aa40f08cb0e465d8d0150e@AcuMS.aculab.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'Christian Brauner' <christian.brauner@ubuntu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

>From Christian Brauner
> Sent: 31 October 2019 11:36
> 
> Validate the stack arguments and setup the stack depening on whether or not
> it is growing down or up.
> 
...
> -static bool clone3_args_valid(const struct kernel_clone_args *kargs)
> +/**
> + * clone3_stack_valid - check and prepare stack
> + * @kargs: kernel clone args
> + *
> + * Verify that the stack arguments userspace gave us are sane.
> + * In addition, set the stack direction for userspace since it's easy for us to
> + * determine.
> + */
> +static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
> +{
> +	if (kargs->stack == 0) {
> +		if (kargs->stack_size > 0)
> +			return false;
> +	} else {
> +		if (kargs->stack_size == 0)
> +			return false;
> +
> +		if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
> +			return false;

Does access_ok() do anything useful here?
It only verifies that the buffer isn't in kernel space.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
