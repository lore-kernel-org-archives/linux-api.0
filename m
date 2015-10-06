From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 97/98] HACK include/uapi/linux/elfcore.h: use
 __kernel_pid_t and remove elf_greg_t stuff in userspace
Date: Tue, 6 Oct 2015 22:20:02 +0300
Message-ID: <20151006192002.GN6104@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-98-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-98-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Trying to find out what would be an acceptable fix for elfcore.h but..

On Sat, May 30, 2015 at 05:39:29PM +0200, Mikko Rapeli wrote:
> __kernel_pid_t change feels like right one. Commenting out elf_greg_t
> things in userspace does not but exporting x86/include/asm/elf.h and =
its
> dependencies to userspace does not feel right either. Hence HACK.
>=20
> Fixes userspace compilation errors like:
>=20
> error: unknown type name =E2=80=98elf_greg_t=E2=80=99
>  typedef elf_greg_t greg_t;
> error: unknown type name =E2=80=98pid_t=E2=80=99
>   pid_t pr_pid;

Ugh. This opens up a can of worms. And not just a single can. Every
architecture supported by Linux has one, for every supported binary
format.

So uapi has a number of headers for exporting process core dump
related structs and defines to userspace. Sadly elfcore.h does not comp=
ile in
userspace as is and practically depends on architecture specific
defines for the elf file format and all the way done to some memory
management details which are not part of uapi.

Since the headers are not exported to userspace, a grep with
elf_greg_t definition in my /usr/include shows that gcc has its own mod=
ified
version of these headers which have the details which gdb needs, in
sys/procfs.h, sys/user.h and friends. Also linux-tools has it's own mod=
ified
versions of these headers with comments like
"Make sure these layouts match the linux/elfcore.h native definitions."

Search on Debian source code tree shows that real users of linux/elfcor=
e.h
don't really exist and everyone has had to create their own copies
with all relevant dependencies to make things work in user space.

On the long term would be nice if these header file worm cans were clea=
ned
up but for the short term I'd like to get elfcore.h compiling so that I=
 can
continue fiddling with kernel header sanity tests and API and ABI
compatibility checks. For this reason I'd like to propose this dumb sol=
ution
for now which:

 * removes typedef elf_greg_t greg_t and friends from userspace headers
 * removes struct elf_prstatus from userspace headers

Comments?

--- a/include/uapi/linux/elfcore.h
+++ b/include/uapi/linux/elfcore.h
@@ -15,15 +15,7 @@ struct elf_siginfo
        int     si_errno;                       /* errno */
 };
=20
-
-#ifndef __KERNEL__
-typedef elf_greg_t greg_t;
-typedef elf_gregset_t gregset_t;
-typedef elf_fpregset_t fpregset_t;
-typedef elf_fpxregset_t fpxregset_t;
-#define NGREG ELF_NGREG
-#endif
-
+#ifdef __KERNEL__
 /*
  * Definitions to generate Intel SVR4-like core files.
  * These mostly have the same names as the SVR4 types with "elf_"
@@ -48,10 +40,10 @@ struct elf_prstatus
        struct sigaltstack pr_altstack; /* Alternate stack info */
        struct sigaction pr_action;     /* Signal action for current si=
g */
 #endif
-       pid_t   pr_pid;
-       pid_t   pr_ppid;
-       pid_t   pr_pgrp;
-       pid_t   pr_sid;
+       __kernel_pid_t  pr_pid;
+       __kernel_pid_t  pr_ppid;
+       __kernel_pid_t  pr_pgrp;
+       __kernel_pid_t  pr_sid;
        struct timeval pr_utime;        /* User time */
        struct timeval pr_stime;        /* System time */
        struct timeval pr_cutime;       /* Cumulative user time */
@@ -72,6 +64,7 @@ struct elf_prstatus
 #endif
        int pr_fpvalid;         /* True if math co-processor being used=
=2E  */
 };
+#endif /* __KERNEL__ */
=20
 #define ELF_PRARGSZ    (80)    /* Number of chars for args */
=20
@@ -84,7 +77,7 @@ struct elf_prpsinfo
        unsigned long pr_flag;  /* flags */
        __kernel_uid_t  pr_uid;
        __kernel_gid_t  pr_gid;
-       pid_t   pr_pid, pr_ppid, pr_pgrp, pr_sid;
+       __kernel_pid_t  pr_pid, pr_ppid, pr_pgrp, pr_sid;
        /* Lots missing */
        char    pr_fname[16];   /* filename of executable */
        char    pr_psargs[ELF_PRARGSZ]; /* initial part of arg list */


> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/linux/elfcore.h | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/uapi/linux/elfcore.h b/include/uapi/linux/elfcor=
e.h
> index 569737c..b9d1233 100644
> --- a/include/uapi/linux/elfcore.h
> +++ b/include/uapi/linux/elfcore.h
> @@ -17,11 +17,13 @@ struct elf_siginfo
> =20
> =20
>  #ifndef __KERNEL__
> +#if 0
>  typedef elf_greg_t greg_t;
>  typedef elf_gregset_t gregset_t;
>  typedef elf_fpregset_t fpregset_t;
>  typedef elf_fpxregset_t fpxregset_t;
>  #define NGREG ELF_NGREG
> +#endif /* 0 */
>  #endif
>  /*
> @@ -48,10 +50,10 @@ struct elf_prstatus
>  	struct sigaltstack pr_altstack;	/* Alternate stack info */
>  	struct sigaction pr_action;	/* Signal action for current sig */
>  #endif
> -	pid_t	pr_pid;
> -	pid_t	pr_ppid;
> -	pid_t	pr_pgrp;
> -	pid_t	pr_sid;
> +	__kernel_pid_t	pr_pid;
> +	__kernel_pid_t	pr_ppid;
> +	__kernel_pid_t	pr_pgrp;
> +	__kernel_pid_t	pr_sid;
>  	struct timeval pr_utime;	/* User time */
>  	struct timeval pr_stime;	/* System time */
>  	struct timeval pr_cutime;	/* Cumulative user time */
> @@ -59,7 +61,9 @@ struct elf_prstatus
>  #if 0
>  	long	pr_instr;		/* Current instruction */
>  #endif
> +#ifdef __KERNEL__
>  	elf_gregset_t pr_reg;	/* GP registers */
> +#endif /* __KERNEL__ */
>  #ifdef CONFIG_BINFMT_ELF_FDPIC
>  	/* When using FDPIC, the loadmap addresses need to be communicated
>  	 * to GDB in order for GDB to do the necessary relocations.  The
> @@ -84,7 +88,7 @@ struct elf_prpsinfo
>  	unsigned long pr_flag;	/* flags */
>  	__kernel_uid_t	pr_uid;
>  	__kernel_gid_t	pr_gid;
> -	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
> +	__kernel_pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
>  	/* Lots missing */
>  	char	pr_fname[16];	/* filename of executable */
>  	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
> --=20
> 2.1.4
>=20
