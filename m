From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] openat2: switch to __attribute__((packed)) for open_how
Date: Sat, 14 Dec 2019 23:17:50 +0100
Message-ID: <a328b91d-fd8f-4f27-b3c2-91a9c45f18c0@rasmusvillemoes.dk>
References: <20191213222351.14071-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191213222351.14071-1-cyphar@cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>
Cc: dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 13/12/2019 23.23, Aleksa Sarai wrote:
> The design of the original open_how struct layout was such that it
> ensured that there would be no un-labelled (and thus potentially
> non-zero) padding to avoid issues with struct expansion, as well as
> providing a uniform representation on all architectures (to avoid
> complications with OPEN_HOW_SIZE versioning).
> 
> However, there were a few other desirable features which were not
> fulfilled by the previous struct layout:
> 
>  * Adding new features (other than new flags) should always result in
>    the struct getting larger. However, by including a padding field, it
>    was possible for new fields to be added without expanding the
>    structure. This would somewhat complicate version-number based
>    checking of feature support.
> 
>  * A non-zero bit in __padding yielded -EINVAL when it should arguably
>    have been -E2BIG (because the padding bits are effectively
>    yet-to-be-used fields). However, the semantics are not entirely clear
>    because userspace may expect -E2BIG to only signify that the
>    structure is too big. It's much simpler to just provide the guarantee
>    that new fields will always result in a struct size increase, and
>    -E2BIG indicates you're using a field that's too recent for an older
>    kernel.

And when the first extension adds another u64 field, that padding has to
be added back in and checked for being 0, at which point the padding is
again yet-to-be-used fields. So what exactly is the problem with
returning EINVAL now?

>  * The padding wasted space needlessly, and would very likely not be
>    used up entirely by future extensions for a long time (because it
>    couldn't fit a u64).

Who knows, it does fit a u32. And if the struct is to be 8-byte aligned
(see below), it doesn't actually waste space.

> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index d886bdb585e4..0e070c7f568a 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -109,17 +109,16 @@
>   * O_TMPFILE} are set.
>   *
>   * @flags: O_* flags.
> - * @mode: O_CREAT/O_TMPFILE file mode.
>   * @resolve: RESOLVE_* flags.
> + * @mode: O_CREAT/O_TMPFILE file mode.
>   */
>  struct open_how {
> -	__aligned_u64 flags;
> +	__u64 flags;
> +	__u64 resolve;
>  	__u16 mode;
> -	__u16 __padding[3]; /* must be zeroed */
> -	__aligned_u64 resolve;
> -};
> +} __attribute__((packed));

IIRC, gcc assumes such a struct has alignment 1, which means that it
will generate horrible code to access it. So if you do this (and I don't
think it's a good idea), I think you'd also want to include a
__attribute__((__aligned__(8))) - or perhaps that can be accomplished by
just keeping flags as an explicitly aligned member. But that will of
course bump its sizeof() back to 24, at which point it seems better to
just make the padding explicit.

Rasmus
