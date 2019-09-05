From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 19:07:50 +0100
Message-ID: <20190905180750.GQ1131@ZenIV.linux.org.uk>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190904201933.10736-2-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Alexander
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 06:19:22AM +1000, Aleksa Sarai wrote:
> +/*
> + * "memset(p, 0, size)" but for user space buffers. Caller must have already
> + * checked access_ok(p, size).
> + */
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

That's called clear_user().

> +int copy_struct_to_user(void __user *dst, size_t usize,
> +			const void *src, size_t ksize)
> +{
> +	size_t size = min(ksize, usize);
> +	size_t rest = abs(ksize - usize);
> +
> +	if (unlikely(usize > PAGE_SIZE))
> +		return -EFAULT;

Why?

> +	} else if (usize > ksize) {
> +		if (__memzero_user(dst + size, rest))
> +			return -EFAULT;
> +	}
> +	/* Copy the interoperable parts of the struct. */
> +	if (__copy_to_user(dst, src, size))
> +		return -EFAULT;

Why not simply clear_user() and copy_to_user()?

> +int copy_struct_from_user(void *dst, size_t ksize,
> +			  const void __user *src, size_t usize)
> +{
> +	size_t size = min(ksize, usize);
> +	size_t rest = abs(ksize - usize);

Cute, but... you would be just as well without that 'rest' thing.

> +
> +	if (unlikely(usize > PAGE_SIZE))
> +		return -EFAULT;

Again, why?

> +	if (unlikely(!access_ok(src, usize)))
> +		return -EFAULT;

Why not simply copy_from_user() here?

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

Frankly, that looks like a candidate for is_all_zeroes_user().
With the loop like above serving as a dumb default.  And on
badly alighed address it _will_ be dumb.  Probably too much
so - something like
	if ((unsigned long)addr & 1) {
		u8 v;
		if (get_user(v, (__u8 __user *)addr))
			return -EFAULT;
		if (v)
			return -E2BIG;
		addr++;
	}
	if ((unsigned long)addr & 2) {
		u16 v;
		if (get_user(v, (__u16 __user *)addr))
			return -EFAULT;
		if (v)
			return -E2BIG;
		addr +=2;
	}
	if ((unsigned long)addr & 4) {
		u32 v;
		if (get_user(v, (__u32 __user *)addr))
			return -EFAULT;
		if (v)
			return -E2BIG;
	}
	<read the rest like you currently do>
would be saner, and things like x86 could trivially add an
asm variant - it's not hard.  Incidentally, memchr_inv() is
an overkill in this case...
