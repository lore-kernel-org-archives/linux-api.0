From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 20:23:03 +0200
Message-ID: <20190905182303.7f6bxpa2enbgcegv@wittgenstein>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905180750.GQ1131@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190905180750.GQ1131@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@r>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 07:07:50PM +0100, Al Viro wrote:
> On Thu, Sep 05, 2019 at 06:19:22AM +1000, Aleksa Sarai wrote:
> > +/*
> > + * "memset(p, 0, size)" but for user space buffers. Caller must have already
> > + * checked access_ok(p, size).
> > + */
> > +static int __memzero_user(void __user *p, size_t s)
> > +{
> > +	const char zeros[BUFFER_SIZE] = {};
> > +	while (s > 0) {
> > +		size_t n = min(s, sizeof(zeros));
> > +
> > +		if (__copy_to_user(p, zeros, n))
> > +			return -EFAULT;
> > +
> > +		p += n;
> > +		s -= n;
> > +	}
> > +	return 0;
> > +}
> 
> That's called clear_user().
> 
> > +int copy_struct_to_user(void __user *dst, size_t usize,
> > +			const void *src, size_t ksize)
> > +{
> > +	size_t size = min(ksize, usize);
> > +	size_t rest = abs(ksize - usize);
> > +
> > +	if (unlikely(usize > PAGE_SIZE))
> > +		return -EFAULT;
> 
> Why?

Because every caller of that function right now has that limit set
anyway iirc. So we can either remove it from here and place it back for
the individual callers or leave it in the helper.
Also, I'm really asking, why not? Is it unreasonable to have an upper
bound on the size (for a long time probably) or are you disagreeing with
PAGE_SIZE being used? PAGE_SIZE limit is currently used by sched, perf,
bpf, and clone3 and in a few other places.
