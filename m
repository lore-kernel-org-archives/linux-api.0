From: Will Newton <will.newton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 1 Apr 2009 15:39:27 +0100
Message-ID: <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
References: <49D071A8.4010703@petalogix.com>
	 <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
	 <200903301717.57184.arnd@arndb.de> <200904011611.53355.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200904011611.53355.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Geert Uytterhoeven <geert.uytterhoeven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, michal.simek-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Liqin <liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 1, 2009 at 3:11 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:

> I've spent more time on my asm-generic patches and believe I now
> have an unistd.h implementation that can be used by the new
> architectures (score and microblaze) so they don't have to go
> through the error-prone process of coming up with their own lists.

I appreciate your work on this, it should make porting to a new arch
much less error-prone.

> It would be good if more people could in particular look over the
> system call lists. I have left the syscalls that I think should
> be dropped in #ifdef __ARCH_WANT_SYSCALL_{DEPRECATED,NO_AT,NO_FLAGS,O=
=46F_T}
> so that it becomes easy to reenable them temporarily while porting
> the libc, and to easily see which ones get left out.
>
> I have also changed checksyscalls.sh to stop complaining when
> the old syscalls are not present.
>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
> =A0include/asm-generic/posix_types.h | =A0162 ++++++
> =A0include/asm-generic/types.h =A0 =A0 =A0 | =A0 63 ++
> =A0include/asm-generic/unistd.h =A0 =A0 =A0| =A0829 +++++++++++++++++=
++++++++++++
> =A0kernel/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A0kernel/syscall_table.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 12 +
> =A0scripts/checksyscalls.sh =A0 =A0 =A0 =A0 =A0| =A0 93 +++-
> =A06 files changed, 1157 insertions(+), 3 deletions(-)
>
>
> diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/=
posix_types.h
> new file mode 100644
> index 0000000..4772f74
> --- /dev/null
> +++ b/include/asm-generic/posix_types.h
> @@ -0,0 +1,162 @@
> +#ifndef __ASM_GENERIC_POSIX_TYPES_H
> +#define __ASM_GENERIC_POSIX_TYPES_H
> +
> +#include <asm/types.h>
> +
> +/*
> + * This file is generally used by user-level software, so you need t=
o
> + * be a little careful about namespace pollution etc.
> + *
> + * First the types that are often defined in different ways across
> + * architectures, so that you can override them.
> + */
> +
> +#ifndef __kernel_ino_t
> +typedef unsigned long =A0__kernel_ino_t;
> +#endif
> +
> +#ifndef __kernel_mode_t
> +typedef unsigned int =A0 __kernel_mode_t;
> +#endif
> +
> +#ifndef __kernel_nlink_t
> +typedef unsigned long =A0__kernel_nlink_t;
> +#endif
> +
> +#ifndef __kernel_pid_t
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_pid_t;
> +#endif
> +
> +#ifndef __kernel_ipc_pid_t
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_ipc_pid_t;
> +#endif
> +
> +#ifndef __kernel_uid_t
> +typedef unsigned int =A0 __kernel_uid_t;
> +typedef unsigned int =A0 __kernel_gid_t;
> +#endif
> +
> +#ifndef __kernel_suseconds_t
> +typedef long =A0 =A0 =A0 =A0 =A0 __kernel_suseconds_t;
> +#endif
> +
> +#ifndef __kernel_daddr_t
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_daddr_t;
> +#endif
> +
> +#ifndef __kernel_uid32_t
> +typedef __kernel_uid_t __kernel_uid32_t;
> +typedef __kernel_gid_t __kernel_gid32_t;
> +#endif
> +
> +#ifndef __kernel_old_uid_t
> +typedef __kernel_uid_t __kernel_old_uid_t;
> +typedef __kernel_gid_t __kernel_old_gid_t;
> +#endif
> +
> +#ifndef __kernel_old_dev_t
> +typedef unsigned int =A0 __kernel_old_dev_t;
> +#endif
> +
> +#ifndef __kernel_size_t
> +#if __BITS_PER_LONG !=3D 64
> +typedef unsigned int =A0 __kernel_size_t;
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_ssize_t;
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_ptrdiff_t;
> +#else
> +typedef unsigned long =A0__kernel_size_t;
> +typedef long =A0 =A0 =A0 =A0 =A0 __kernel_ssize_t;
> +typedef long =A0 =A0 =A0 =A0 =A0 __kernel_ptrdiff_t;
> +#endif
> +#endif
> +
> +/*
> + * anything below here should be completely generic
> + */
> +typedef long =A0 =A0 =A0 =A0 =A0 __kernel_off_t;
> +typedef long long =A0 =A0 =A0__kernel_loff_t;
> +typedef long =A0 =A0 =A0 =A0 =A0 __kernel_time_t;
> +typedef long =A0 =A0 =A0 =A0 =A0 __kernel_clock_t;
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_timer_t;
> +typedef int =A0 =A0 =A0 =A0 =A0 =A0__kernel_clockid_t;
> +typedef char * =A0 =A0 =A0 =A0 __kernel_caddr_t;
> +typedef unsigned short __kernel_uid16_t;
> +typedef unsigned short __kernel_gid16_t;
> +
> +typedef struct {
> + =A0 =A0 =A0 int =A0 =A0 val[2];
> +} __kernel_fsid_t;
> +
> +#ifdef __KERNEL__
> +
> +#undef __FD_SET
> +static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__f=
dsetp)
> +{
> + =A0 =A0 =A0 unsigned long __tmp =3D __fd / __NFDBITS;
> + =A0 =A0 =A0 unsigned long __rem =3D __fd % __NFDBITS;
> + =A0 =A0 =A0 __fdsetp->fds_bits[__tmp] |=3D (1UL<<__rem);
> +}
> +
> +#undef __FD_CLR
> +static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__f=
dsetp)
> +{
> + =A0 =A0 =A0 unsigned long __tmp =3D __fd / __NFDBITS;
> + =A0 =A0 =A0 unsigned long __rem =3D __fd % __NFDBITS;
> + =A0 =A0 =A0 __fdsetp->fds_bits[__tmp] &=3D ~(1UL<<__rem);
> +}
> +
> +#undef __FD_ISSET
> +static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_s=
et *__p)
> +{
> + =A0 =A0 =A0 unsigned long __tmp =3D __fd / __NFDBITS;
> + =A0 =A0 =A0 unsigned long __rem =3D __fd % __NFDBITS;
> + =A0 =A0 =A0 return (__p->fds_bits[__tmp] & (1UL<<__rem)) !=3D 0;
> +}
> +
> +/*
> + * This will unroll the loop for the normal constant case (8 ints,
> + * for a 256-bit fd_set)
> + */
> +#undef __FD_ZERO
> +static inline void __FD_ZERO(__kernel_fd_set *__p)
> +{
> + =A0 =A0 =A0 unsigned long *__tmp =3D __p->fds_bits;
> + =A0 =A0 =A0 int __i;
> +
> + =A0 =A0 =A0 if (__builtin_constant_p(__FDSET_LONGS)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (__FDSET_LONGS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 16:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 0] =3D 0; __tmp[=
 1] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 2] =3D 0; __tmp[=
 3] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 4] =3D 0; __tmp[=
 5] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 6] =3D 0; __tmp[=
 7] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 8] =3D 0; __tmp[=
 9] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[10] =3D 0; __tmp[=
11] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[12] =3D 0; __tmp[=
13] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[14] =3D 0; __tmp[=
15] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 8:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 0] =3D 0; __tmp[=
 1] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 2] =3D 0; __tmp[=
 3] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 4] =3D 0; __tmp[=
 5] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 6] =3D 0; __tmp[=
 7] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 4:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 0] =3D 0; __tmp[=
 1] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp[ 2] =3D 0; __tmp[=
 3] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 __i =3D __FDSET_LONGS;
> + =A0 =A0 =A0 while (__i) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __i--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *__tmp =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __tmp++;
> + =A0 =A0 =A0 }
> +}
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* __ASM_GENERIC_POSIX_TYPES_H */
> diff --git a/include/asm-generic/types.h b/include/asm-generic/types.=
h
> new file mode 100644
> index 0000000..147b553
> --- /dev/null
> +++ b/include/asm-generic/types.h
> @@ -0,0 +1,63 @@
> +#ifndef _ASM_GENERIC_TYPES_H
> +#define _ASM_GENERIC_TYPES_H
> +
> +/*
> + * int-ll64 is used practically everywhere now,
> + * so use it as a reasonable default.
> + */
> +#include <asm-generic/int-ll64.h>
> +
> +#ifndef __ASSEMBLY__
> +
> +typedef unsigned short umode_t;
> +
> +#endif /* __ASSEMBLY__ */
> +
> +/*
> + * There seems to be no way of detecting this automatically from use=
r
> + * space, so 64 bit architectures should override this in their type=
s.h.
> + */
> +#ifndef __BITS_PER_LONG
> +#define __BITS_PER_LONG 32
> +#endif

Why is this define required? It doesn't seem to be in any existing head=
ers.

> +
> +/*
> + * These aren't exported outside the kernel to avoid name space clas=
hes
> + */
> +#ifdef __KERNEL__
> +
> +#ifdef CONFIG_64BIT
> +#define BITS_PER_LONG 64
> +#else
> +#define BITS_PER_LONG 32
> +#endif /* CONFIG_64BIT */
> +
> +#if BITS_PER_LONG !=3D __BITS_PER_LONG
> +#error cannot determine word size
> +#endif
> +
> +#ifndef __ASSEMBLY__
> +
> +/*
> + * DMA addresses may be very different from physical addresses
> + * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
> + * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
> + * physical addresses.
> + * This default defines dma_addr_t to have the same size as
> + * phys_addr_t, which is the most common way.
> + * Do not define the dma64_addr_t type, which never really
> + * worked.
> + */
> +#ifndef dma_addr_t
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +typedef u64 dma_addr_t;
> +#else
> +typedef u32 dma_addr_t;
> +#endif /* CONFIG_PHYS_ADDR_T_64BIT */
> +#endif /* dma_addr_t */
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* _ASM_GENERIC_TYPES_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
