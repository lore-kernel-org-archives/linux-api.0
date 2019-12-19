From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/2] uapi: split openat2(2) definitions from fcntl.h
Date: Thu, 19 Dec 2019 12:07:13 +0100
Message-ID: <87a77oy3oe.fsf@oldenburg2.str.redhat.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
        <20191219105533.12508-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219105533.12508-2-cyphar@cyphar.com> (Aleksa Sarai's
        message of "Thu, 19 Dec 2019 21:55:29 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, David Laight <david.laight@aculab.com>, Christian Brauner <christian.brauner@ubuntu.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Aleksa Sarai:

> diff --git a/include/uapi/linux/openat2.h b/include/uapi/linux/openat2.h
> new file mode 100644
> index 000000000000..19ef775e8e5e
> --- /dev/null
> +++ b/include/uapi/linux/openat2.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_OPENAT2_H
> +#define _UAPI_LINUX_OPENAT2_H

I think you should include the relevant header for __align_u64
etc. here.

[=E2=80=A6]
> + * Arguments for how openat2(2) should open the target path. If @resolve=
 is
> + * zero, then openat2(2) operates very similarly to openat(2).
> + *
> + * However, unlike openat(2), unknown bits in @flags result in -EINVAL r=
ather
> + * than being silently ignored. @mode must be zero unless one of {O_CREA=
T,
> + * O_TMPFILE} are set.
> + *
> + * @flags: O_* flags.
> + * @mode: O_CREAT/O_TMPFILE file mode.
> + * @resolve: RESOLVE_* flags.
> + */
> +struct open_how {
> +	__aligned_u64 flags;
> +	__u16 mode;
> +	__u16 __padding[3]; /* must be zeroed */
> +	__aligned_u64 resolve;
> +};
> +
> +#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
> +#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0

Are these really useful for the UAPI header?  Is there a situation where
OPEN_HOW_SIZE_LATEST would be different from sizeof (struct open_how)?

The header is not compatible with the assembler anyway, so the numeric
constant does not seem useful.

Thanks,
Florian
