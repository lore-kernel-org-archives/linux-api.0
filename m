From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 10:43:52 +0200
Message-ID: <57ba3752-c4a6-d2a4-1a4d-a0e13bccd473@rasmusvillemoes.dk>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190904201933.10736-2-cyphar@cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>
Cc: Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-ia6
List-Id: linux-api@vger.kernel.org

On 04/09/2019 22.19, Aleksa Sarai wrote:
> A common pattern for syscall extensions is increasing the size of a
> struct passed from userspace, such that the zero-value of the new fields
> result in the old kernel behaviour (allowing for a mix of userspace and
> kernel vintages to operate on one another in most cases). This is done
> in both directions -- hence two helpers -- though it's more common to
> have to copy user space structs into kernel space.
> 
> Previously there was no common lib/ function that implemented
> the necessary extension-checking semantics (and different syscalls
> implemented them slightly differently or incompletely[1]). A future
> patch replaces all of the common uses of this pattern to use the new
> copy_struct_{to,from}_user() helpers.
> 
> [1]: For instance {sched_setattr,perf_event_open,clone3}(2) all do do
>      similar checks to copy_struct_from_user() while rt_sigprocmask(2)
>      always rejects differently-sized struct arguments.
> 
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
> diff --git a/lib/struct_user.c b/lib/struct_user.c
> new file mode 100644
> index 000000000000..7301ab1bbe98
> --- /dev/null
> +++ b/lib/struct_user.c
> @@ -0,0 +1,182 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2019 SUSE LLC
> + * Copyright (C) 2019 Aleksa Sarai <cyphar@cyphar.com>
> + */
> +
> +#include <linux/types.h>
> +#include <linux/export.h>
> +#include <linux/uaccess.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +
> +#define BUFFER_SIZE 64
> +
> +/*
> + * "memset(p, 0, size)" but for user space buffers. Caller must have already
> + * checked access_ok(p, size).
> + */

Isn't this __clear_user() exactly (perhaps except for the return value)?
Perhaps not every arch has that?

> +static int __memzero_user(void __user *p, size_t s)
> +{
> +	const char zeros[BUFFER_SIZE] = {};
> +	while (s > 0) {
> +		size_t n = min(s, sizeof(zeros));
> +
> +		if (__copy_to_user(p, zeros, n))
> +			return -EFAULT;
> +
> +		p += n;
> +		s -= n;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * copy_struct_to_user: copy a struct to user space
> + * @dst:   Destination address, in user space.
> + * @usize: Size of @dst struct.
> + * @src:   Source address, in kernel space.
> + * @ksize: Size of @src struct.
> + *
> + * Returns (in all cases, some data may have been copied):
> + *  * -EFBIG:  (@usize < @ksize) and there are non-zero trailing bytes in @src.
> + *  * -EFAULT: access to user space failed.
> + */
> +int copy_struct_to_user(void __user *dst, size_t usize,
> +			const void *src, size_t ksize)
> +{
> +	size_t size = min(ksize, usize);
> +	size_t rest = abs(ksize - usize);

Eh, I'd avoid abs() here due to the funkiness of the implicit type
conversions - ksize-usize has type size_t, then that's coerced to an int
(or a long maybe?), the abs is applied which return an int/long (or
unsigned versions?). Something like "rest = max(ksize, usize) - size;"
is more obviously correct and doesn't fall into any
narrowing/widening/sign extending traps.

> +	if (unlikely(usize > PAGE_SIZE))
> +		return -EFAULT;

Please don't. That is a restriction on all future extensions - once a
kernel is shipped with a syscall using this helper with that arbitrary
restriction in place, that syscall is forever prevented from extending
its arg struct beyond PAGE_SIZE (which is arch-dependent anyway). Sure,
it's hard to imagine, but who'd have thought 32 O_* or CLONE_* bits
weren't enough for everybody?

This is only for future compatibility, and if someone runs an app
compiled against 7.3 headers on a 5.4 kernel, they probably don't care
about performance, but they would like their app to run.

[If we ever create such a large ABI struct that doesn't fit on stack,
we'd have to extend our API a little to create a dup_struct_from_user()
that does the kmalloc() for us and then calls copy_struct_from_user() -
but we might want that long before we hit PAGE_SIZE structs].

> +	if (unlikely(!access_ok(dst, usize)))
> +		return -EFAULT;
> +
> +	/* Deal with trailing bytes. */
> +	if (usize < ksize) {
> +		if (memchr_inv(src + size, 0, rest))
> +			return -EFBIG;
> +	} else if (usize > ksize) {
> +		if (__memzero_user(dst + size, rest))
> +			return -EFAULT;

I think that could simply be __clear_user().

> +	}
> +	/* Copy the interoperable parts of the struct. */
> +	if (__copy_to_user(dst, src, size))
> +		return -EFAULT;

I think I understand why you put this last instead of handling the
buffer in the "natural" order. However,
I'm wondering whether we should actually do this copy before checking
that the extra kernel bytes are 0 - the user will still be told that
there was some extra information via the -EFBIG/-E2BIG return, but maybe
in some cases the part he understands is good enough. But I also guess
we have to look to existing users to see whether that would prevent them
from being converted to using this helper.

linux-api folks, WDYT?

> +	return 0;

Maybe more useful to "return size;", some users might want to know/pass
on how much was actually copied.

> +}
> +EXPORT_SYMBOL(copy_struct_to_user);

Can't we wait with this until a modular user shows up? The primary users
are syscalls, which can't be modular AFAIK.

> +/**
> + * copy_struct_from_user: copy a struct from user space
> + * @dst:   Destination address, in kernel space. This buffer must be @ksize
> + *         bytes long.
> + * @ksize: Size of @dst struct.
> + * @src:   Source address, in user space.
> + * @usize: (Alleged) size of @src struct.
> + *
> + * Copies a struct from user space to kernel space, in a way that guarantees
> + * backwards-compatibility for struct syscall arguments (as long as future
> + * struct extensions are made such that all new fields are *appended* to the
> + * old struct, and zeroed-out new fields have the same meaning as the old
> + * struct).
> + *
> + * @ksize is just sizeof(*dst), and @usize should've been passed by user space.
> + * The recommended usage is something like the following:
> + *
> + *   SYSCALL_DEFINE2(foobar, const struct foo __user *, uarg, size_t, usize)
> + *   {
> + *      int err;
> + *      struct foo karg = {};
> + *
> + *      err = copy_struct_from_user(&karg, sizeof(karg), uarg, size);
> + *      if (err)
> + *        return err;
> + *
> + *      // ...
> + *   }
> + *
> + * There are three cases to consider:
> + *  * If @usize == @ksize, then it's copied verbatim.
> + *  * If @usize < @ksize, then the user space has passed an old struct to a
> + *    newer kernel. The rest of the trailing bytes in @dst (@ksize - @usize)
> + *    are to be zero-filled.
> + *  * If @usize > @ksize, then the user space has passed a new struct to an
> + *    older kernel. The trailing bytes unknown to the kernel (@usize - @ksize)
> + *    are checked to ensure they are zeroed, otherwise -E2BIG is returned.
> + *
> + * Returns (in all cases, some data may have been copied):
> + *  * -E2BIG:  (@usize > @ksize) and there are non-zero trailing bytes in @src.
> + *  * -E2BIG:  @usize is "too big" (at time of writing, >PAGE_SIZE).
> + *  * -EFAULT: access to user space failed.
> + */
> +int copy_struct_from_user(void *dst, size_t ksize,
> +			  const void __user *src, size_t usize)
> +{
> +	size_t size = min(ksize, usize);
> +	size_t rest = abs(ksize - usize);

As above.

> +	if (unlikely(usize > PAGE_SIZE))
> +		return -EFAULT;

As above.

> +	if (unlikely(!access_ok(src, usize)))
> +		return -EFAULT;
> +
> +	/* Deal with trailing bytes. */
> +	if (usize < ksize)
> +		memset(dst + size, 0, rest);
> +	else if (usize > ksize) {
> +		const void __user *addr = src + size;
> +		char buffer[BUFFER_SIZE] = {};
> +
> +		while (rest > 0) {
> +			size_t bufsize = min(rest, sizeof(buffer));
> +
> +			if (__copy_from_user(buffer, addr, bufsize))
> +				return -EFAULT;
> +			if (memchr_inv(buffer, 0, bufsize))
> +				return -E2BIG;
> +
> +			addr += bufsize;
> +			rest -= bufsize;
> +		}

I'd create a __user_is_zero() helper for this - that way the two
branches in the two helpers become nicely symmetric, each just calling a
single helper that deals appropriately with the tail. And we can discuss
how to implement __user_is_zero() in another bikeshed.

> +	}
> +	/* Copy the interoperable parts of the struct. */
> +	if (__copy_from_user(dst, src, size))
> +		return -EFAULT;

If you do move up the __copy_to_user(), please move this as well - on
the kernel side, we certainly don't care that we copied some bytes to a
local buffer which we then ignore because the user had a non-zero tail.
But if __copy_to_user() is kept last in copy_struct_to_user(), this
should stay for symmetry.

> +	return 0;

As above.

> +}
> +EXPORT_SYMBOL(copy_struct_from_user);

As above.

Rasmus
