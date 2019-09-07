From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v12 11/12] open: openat2(2) syscall
Date: Sat, 07 Sep 2019 08:40:47 -0400
Message-ID: <7236f382d72130f2afbbe8940e72cc67e5c6dce0.camel@kernel.org>
References: <20190904201933.10736-1-cyphar@cyphar.com>
         <20190904201933.10736-12-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190904201933.10736-12-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>
Cc: Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.
List-Id: linux-api@vger.kernel.org

On Thu, 2019-09-05 at 06:19 +1000, Aleksa Sarai wrote:
> The most obvious syscall to add support for the new LOOKUP_* scoping
> flags would be openat(2). However, there are a few reasons why this is
> not the best course of action:
> 
>  * The new LOOKUP_* flags are intended to be security features, and
>    openat(2) will silently ignore all unknown flags. This means that
>    users would need to avoid foot-gunning themselves constantly when
>    using this interface if it were part of openat(2). This can be fixed
>    by having userspace libraries handle this for users[1], but should be
>    avoided if possible.
> 
>  * Resolution scoping feels like a different operation to the existing
>    O_* flags. And since openat(2) has limited flag space, it seems to be
>    quite wasteful to clutter it with 5 flags that are all
>    resolution-related. Arguably O_NOFOLLOW is also a resolution flag but
>    its entire purpose is to error out if you encounter a trailing
>    symlink -- not to scope resolution.
> 
>  * Other systems would be able to reimplement this syscall allowing for
>    cross-OS standardisation rather than being hidden amongst O_* flags
>    which may result in it not being used by all the parties that might
>    want to use it (file servers, web servers, container runtimes, etc).
> 
>  * It gives us the opportunity to iterate on the O_PATH interface. In
>    particular, the new @how->upgrade_mask field for fd re-opening is
>    only possible because we have a clean slate without needing to re-use
>    the ACC_MODE flag design nor the existing openat(2) @mode semantics.
> 
> To this end, we introduce the openat2(2) syscall. It provides all of the
> features of openat(2) through the @how->flags argument, but also
> also provides a new @how->resolve argument which exposes RESOLVE_* flags
> that map to our new LOOKUP_* flags. It also eliminates the long-standing
> ugliness of variadic-open(2) by embedding it in a struct.
> 
> In order to allow for userspace to lock down their usage of file
> descriptor re-opening, openat2(2) has the ability for users to disallow
> certain re-opening modes through @how->upgrade_mask. At the moment,
> there is no UPGRADE_NOEXEC.
> 
> [1]: https://github.com/openSUSE/libpathrs
> 
> Suggested-by: Christian Brauner <christian@brauner.io>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>  arch/alpha/kernel/syscalls/syscall.tbl      |  1 +
>  arch/arm/tools/syscall.tbl                  |  1 +
>  arch/arm64/include/asm/unistd.h             |  2 +-
>  arch/arm64/include/asm/unistd32.h           |  2 +
>  arch/ia64/kernel/syscalls/syscall.tbl       |  1 +
>  arch/m68k/kernel/syscalls/syscall.tbl       |  1 +
>  arch/microblaze/kernel/syscalls/syscall.tbl |  1 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl   |  1 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl   |  1 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl   |  1 +
>  arch/parisc/kernel/syscalls/syscall.tbl     |  1 +
>  arch/powerpc/kernel/syscalls/syscall.tbl    |  1 +
>  arch/s390/kernel/syscalls/syscall.tbl       |  1 +
>  arch/sh/kernel/syscalls/syscall.tbl         |  1 +
>  arch/sparc/kernel/syscalls/syscall.tbl      |  1 +
>  arch/x86/entry/syscalls/syscall_32.tbl      |  1 +
>  arch/x86/entry/syscalls/syscall_64.tbl      |  1 +
>  arch/xtensa/kernel/syscalls/syscall.tbl     |  1 +
>  fs/open.c                                   | 94 ++++++++++++++++-----
>  include/linux/fcntl.h                       | 19 ++++-
>  include/linux/fs.h                          |  4 +-
>  include/linux/syscalls.h                    | 14 ++-
>  include/uapi/asm-generic/unistd.h           |  5 +-
>  include/uapi/linux/fcntl.h                  | 42 +++++++++
>  24 files changed, 168 insertions(+), 30 deletions(-)
> 

[...]

> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index 1d338357df8a..479baf2da10e 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -93,5 +93,47 @@
>  
>  #define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
>  
> +/**
> + * Arguments for how openat2(2) should open the target path. If @resolve is
> + * zero, then openat2(2) operates identically to openat(2).
> + *
> + * However, unlike openat(2), unknown bits in @flags result in -EINVAL rather
> + * than being silently ignored. In addition, @mode (or @upgrade_mask) must be
> + * zero unless one of {O_CREAT, O_TMPFILE, O_PATH} are set.
> + *

After thinking about this a bit, I wonder if we might be better served
with a new set of OA2_* flags instead of repurposing the O_* flags?

Yes, those flags are familiar, but this is an entirely new syscall. We
have a chance to make a fresh start. Does something like O_LARGEFILE
have any real place in openat2? I'd argue no.

Also, once you want to add a new flag, then we get into the mess of how
to document whether open/openat also support it. It'd be good to freeze
changes on those syscalls and aim to only introduce new functionality in
openat2.

That would also allow us to drop some flags from openat2 that we really
don't need, and maybe expand the flag space to 64 bits initially, to
allow for expansion into the future.

Thoughts?

> + * @flags: O_* flags.
> + * @mode: O_CREAT/O_TMPFILE file mode.
> + * @upgrade_mask: UPGRADE_* flags (to restrict O_PATH re-opening).
> + * @resolve: RESOLVE_* flags.
> + */
> +struct open_how {
> +	__u32 flags;
> +	union {
> +		__u16 mode;
> +		__u16 upgrade_mask;
> +	};
> +	__u16 resolve;
> +};
> +
> +#define OPEN_HOW_SIZE_VER0	8 /* sizeof first published struct */
> +

Hmm, there is no version field. When you want to expand this in the
future, what is the plan? Add a new flag to indicate that it's some
length?


> +/* how->resolve flags for openat2(2). */
> +#define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
> +					(includes bind-mounts). */
> +#define RESOLVE_NO_MAGICLINKS	0x02 /* Block traversal through procfs-style
> +					"magic-links". */
> +#define RESOLVE_NO_SYMLINKS	0x04 /* Block traversal through all symlinks
> +					(implies OEXT_NO_MAGICLINKS) */
> +#define RESOLVE_BENEATH		0x08 /* Block "lexical" trickery like
> +					"..", symlinks, and absolute
> +					paths which escape the dirfd. */
> +#define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
> +					be scoped inside the dirfd
> +					(similar to chroot(2)). */
> +
> +/* how->upgrade flags for openat2(2). */
> +/* First bit is reserved for a future UPGRADE_NOEXEC flag. */
> +#define UPGRADE_NOREAD		0x02 /* Block re-opening with MAY_READ. */
> +#define UPGRADE_NOWRITE		0x04 /* Block re-opening with MAY_WRITE. */
>  
>  #endif /* _UAPI_LINUX_FCNTL_H */

-- 
Jeff Layton <jlayton@kernel.org>
