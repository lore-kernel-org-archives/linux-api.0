From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] openat2: switch to __attribute__((packed)) for open_how
Date: Sun, 15 Dec 2019 20:48:24 +0100
Message-ID: <87o8w9bcaf.fsf@mid.deneb.enyo.de>
References: <20191213222351.14071-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191213222351.14071-1-cyphar@cyphar.com> (Aleksa Sarai's
        message of "Sat, 14 Dec 2019 09:23:50 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Aleksa Sarai:

> diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
> index 43ca5ceab6e3..eb1535c8fa2e 100644
> --- a/tools/testing/selftests/openat2/helpers.h
> +++ b/tools/testing/selftests/openat2/helpers.h
> @@ -32,17 +32,16 @@
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
>  
> -#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
> +#define OPEN_HOW_SIZE_VER0	18 /* sizeof first published struct */
>  #define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0

A userspace ABI that depends on GCC extensions probably isn't a good
idea.  Even with GCC, it will not work well with some future
extensions because it pretty much rules out having arrays or other
members that are access through pointers.  Current GCC does not carry
over the packed-ness of the struct to addresses of its members.
