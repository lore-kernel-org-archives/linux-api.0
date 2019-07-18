From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v9 08/10] open: openat2(2) syscall
Date: Thu, 18 Jul 2019 16:48:12 +0200
Message-ID: <845e4364-685f-343b-46fb-c418766dce3e@rasmusvillemoes.dk>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-9-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190706145737.5299-9-cyphar@cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-m
List-Id: linux-api@vger.kernel.org

On 06/07/2019 16.57, Aleksa Sarai wrote:
> 
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -928,24 +928,32 @@ struct file *open_with_fake_path(const struct path *path, int flags,
>  }
>  EXPORT_SYMBOL(open_with_fake_path);
>  
> -static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
> +static inline int build_open_flags(struct open_how how, struct open_flags *op)
>  {

How does passing such a huge struct by value affect code generation?
Does gcc actually inline the function (and does it even inline the old
one given that it's already non-trivial and has more than one caller).

>  	int lookup_flags = 0;
> -	int acc_mode = ACC_MODE(flags);
> +	int opath_mask = 0;
> +	int acc_mode = ACC_MODE(how.flags);
> +
> +	if (how.resolve & ~VALID_RESOLVE_FLAGS)
> +		return -EINVAL;
> +	if (!(how.flags & (O_PATH | O_CREAT | __O_TMPFILE)) && how.mode != 0)
> +		return -EINVAL;
> +	if (memchr_inv(how.reserved, 0, sizeof(how.reserved)))
> +		return -EINVAL;

How about passing how by const reference, and copy the few fields you
need to local variables. That would at least simplify this patch by
eliminating a lot of the

> -	flags &= VALID_OPEN_FLAGS;
> +	how.flags &= VALID_OPEN_FLAGS;
>  
> -	if (flags & (O_CREAT | __O_TMPFILE))
> -		op->mode = (mode & S_IALLUGO) | S_IFREG;
> +	if (how.flags & (O_CREAT | __O_TMPFILE))
> +		op->mode = (how.mode & S_IALLUGO) | S_IFREG;

churn.

>  
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index 2868ae6c8fc1..e59917292213 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -4,13 +4,26 @@
>  
>  #include <uapi/linux/fcntl.h>
>  
> -/* list of all valid flags for the open/openat flags argument: */
> +/* Should open_how.mode be set for older syscalls wrappers? */
> +#define OPENHOW_MODE(flags, mode) \
> +	(((flags) | (O_CREAT | __O_TMPFILE)) ? (mode) : 0)
> +

Typo: (((flags) & (O_CREAT | __O_TMPFILE)) ? (mode) : 0)

> +/**
> + * Arguments for how openat2(2) should open the target path. If @extra is zero,
> + * then openat2(2) is identical to openat(2).
> + *
> + * @flags: O_* flags (unknown flags ignored).
> + * @mode: O_CREAT file mode (ignored otherwise).

should probably say "O_CREAT/O_TMPFILE file mode".

> + * @upgrade_mask: restrict how the O_PATH may be re-opened (ignored otherwise).
> + * @resolve: RESOLVE_* flags (-EINVAL on unknown flags).
> + * @reserved: reserved for future extensions, must be zeroed.
> + */
> +struct open_how {
> +	__u32 flags;
> +	union {
> +		__u16 mode;
> +		__u16 upgrade_mask;
> +	};
> +	__u16 resolve;

So mode and upgrade_mask are naturally u16 aka mode_t. And yes, they
probably never need to be used together, so the union works. That then
makes the next member 2-byte aligned, so using a u16 for the resolve
flags brings us to an 8-byte boundary, and 11 unused flag bits should be
enough for a while. But it seems a bit artificial to cram all this
together and then add 56 bytes of reserved space.

Rasmus
