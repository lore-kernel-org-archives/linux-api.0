From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v15 7/9] open: introduce openat2(2) syscall
Date: Wed, 13 Nov 2019 02:29:06 +0000
Message-ID: <20191113022906.GD26530@ZenIV.linux.org.uk>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-8-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191105090553.6350-8-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 08:05:51PM +1100, Aleksa Sarai wrote:
  
> +/*
> + * Arguments for how openat2(2) should open the target path. If @resolve is
> + * zero, then openat2(2) operates very similarly to openat(2).
> + *
> + * However, unlike openat(2), unknown bits in @flags result in -EINVAL rather
> + * than being silently ignored. @mode must be zero unless one of {O_CREAT,
> + * O_TMPFILE} are set, and @upgrade_mask must be zero unless O_PATH is set.
> + *
> + * @flags: O_* flags.
> + * @mode: O_CREAT/O_TMPFILE file mode.
> + * @upgrade_mask: UPGRADE_* flags (to restrict O_PATH re-opening).

???

> + * @resolve: RESOLVE_* flags.
> + */
> +struct open_how {
> +	__aligned_u64 flags;
> +	__u16 mode;
> +	__u16 __padding[3]; /* must be zeroed */
> +	__aligned_u64 resolve;
> +};
