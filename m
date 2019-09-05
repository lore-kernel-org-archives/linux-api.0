From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 13:29:59 +0200
Message-ID: <20190905112958.ldzyzyuqn5akkhzy@wittgenstein>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905110544.d6c5t7rx25kvywmi@wittgenstein>
 <ae415ea8-4442-d81c-3b46-2ae5fb35bbdf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ae415ea8-4442-d81c-3b46-2ae5fb35bbdf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@red>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 01:17:38PM +0200, Rasmus Villemoes wrote:
> On 05/09/2019 13.05, Christian Brauner wrote:
> > On Thu, Sep 05, 2019 at 06:19:22AM +1000, Aleksa Sarai wrote:
> 
> >> +	if (unlikely(!access_ok(dst, usize)))
> >> +		return -EFAULT;
> >> +
> >> +	/* Deal with trailing bytes. */
> >> +	if (usize < ksize) {
> >> +		if (memchr_inv(src + size, 0, rest))
> >> +			return -EFBIG;
> >> +	} else if (usize > ksize) {
> >> +		if (__memzero_user(dst + size, rest))
> >> +			return -EFAULT;
> > 
> > Is zeroing that memory really our job? Seems to me we should just check
> > it is zeroed.
> 
> Of course it is, otherwise you'd require userspace to clear the output
> buffer it gives us, which in the majority of cases is wasted work. It's
> much easier to reason about if we just say "the kernel populates [uaddr,
> uaddr + usize)".

I don't really mind either way so sure. :)
