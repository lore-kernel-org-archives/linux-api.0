From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v18 11/13] open: introduce openat2(2) syscall
Date: Mon, 16 Dec 2019 20:20:17 +0100
Message-ID: <20191216192158.B9F19832924A@oldenburg2.str.redhat.com>
References: <20191206141338.23338-1-cyphar@cyphar.com>
	<20191206141338.23338-12-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-108113-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20191206141338.23338-12-cyphar@cyphar.com> (Aleksa Sarai's
	message of "Sat, 7 Dec 2019 01:13:36 +1100")
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Jonathan Corbet <corbet@lwn.net>, linux-ia64@vger.kernel.org, linux-doc@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, linux-api@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>lin
List-Id: linux-api@vger.kernel.org

* Aleksa Sarai:

> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index 1d338357df8a..58c3a0e543c6 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -93,5 +93,40 @@
> =20
>  #define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
> =20
> +/*
> + * Arguments for how openat2(2) should open the target path. If @resol=
ve is
> + * zero, then openat2(2) operates very similarly to openat(2).
> + *
> + * However, unlike openat(2), unknown bits in @flags result in -EINVAL=
 rather
> + * than being silently ignored. @mode must be zero unless one of {O_CR=
EAT,
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
> +
> +/* how->resolve flags for openat2(2). */
> +#define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
> +					(includes bind-mounts). */
> +#define RESOLVE_NO_MAGICLINKS	0x02 /* Block traversal through procfs-s=
tyle
> +					"magic-links". */
> +#define RESOLVE_NO_SYMLINKS	0x04 /* Block traversal through all symlin=
ks
> +					(implies OEXT_NO_MAGICLINKS) */
> +#define RESOLVE_BENEATH		0x08 /* Block "lexical" trickery like
> +					"..", symlinks, and absolute
> +					paths which escape the dirfd. */
> +#define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
> +					be scoped inside the dirfd
> +					(similar to chroot(2)). */
> =20
>  #endif /* _UAPI_LINUX_FCNTL_H */

Would it be possible to move these to a new UAPI header?

In glibc, we currently do not #include <linux/fcntl.h>.  We need some of
the AT_* constants in POSIX mode, and the header is not necessarily
namespace-clean.  If there was a separate header for openat2 support, we
could use that easily, and we would only have to maintain the baseline
definitions (which never change).

Thanks,
Florian
