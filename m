From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5/8] x86, pkeys: allocation/free syscalls
Date: Wed, 01 Jun 2016 22:48:18 +0200
Message-ID: <5864297.Wx4gj9qW7E@wuerfel>
References: <20160531152814.36E0B9EE@viggo.jf.intel.com> <20160531152822.FE8D405E@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160531152822.FE8D405E@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, dave.hansen@linux.intel.com
List-Id: linux-api@vger.kernel.org

On Tuesday, May 31, 2016 8:28:22 AM CEST Dave Hansen wrote:
> diff -puN arch/x86/entry/syscalls/syscall_32.tbl~pkeys-116-syscalls-allocation arch/x86/entry/syscalls/syscall_32.tbl
> --- a/arch/x86/entry/syscalls/syscall_32.tbl~pkeys-116-syscalls-allocation      2016-05-31 08:27:49.150115539 -0700
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl    2016-05-31 08:27:49.176116712 -0700
> @@ -387,3 +387,5 @@
>  378    i386    preadv2                 sys_preadv2                     compat_sys_preadv2
>  379    i386    pwritev2                sys_pwritev2                    compat_sys_pwritev2
>  380    i386    pkey_mprotect           sys_pkey_mprotect
> +381    i386    pkey_alloc              sys_pkey_alloc
> +382    i386    pkey_free               sys_pkey_free
> diff -puN arch/x86/entry/syscalls/syscall_64.tbl~pkeys-116-syscalls-allocation arch/x86/entry/syscalls/syscall_64.tbl
> --- a/arch/x86/entry/syscalls/syscall_64.tbl~pkeys-116-syscalls-allocation      2016-05-31 08:27:49.152115629 -0700
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl    2016-05-31 08:27:49.177116758 -0700
> @@ -336,6 +336,8 @@
>  327    64      preadv2                 sys_preadv2
>  328    64      pwritev2                sys_pwritev2
>  329    common  pkey_mprotect           sys_pkey_mprotect
> +330    common  pkey_alloc              sys_pkey_alloc
> +331    common  pkey_free               sys_pkey_free
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> 

Could you also add the system call numbers to
include/uapi/asm-generic/unistd.h at the same time?

Even if the support is x86 specific for the forseeable future, it may
be good to reserve the number just in case.
The other architecture specific syscall lists are usually left to the
individual arch maintainers, most a lot of the newer architectures
share this table.

	Arnd

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
