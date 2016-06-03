From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFCv3] add manpages for Memory Protection Keys
Date: Thu, 2 Jun 2016 19:25:45 -0500
Message-ID: <647d23bf-a163-deee-d0ec-f961ecfb0b90@gmail.com>
References: <1464826600-17110-1-git-send-email-dave.hansen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464826600-17110-1-git-send-email-dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dave-gkUM19QKKo4@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Dave,

On 06/01/2016 07:16 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Changes from last version:
>  * clarified that calling pkey_free() on a pkey in use by
>    a mapping is bad.
> 
> Memory Protection Keys for User pages is an Intel CPU feature
> which will first appear on Skylake Servers, but will also be
> supported on future non-server parts (there is also a QEMU
> implementation).  It provides a mechanism for enforcing
> page-based protections, but without requiring modification of the
> page tables when an application wishes to change permissions.
> 
> I have propsed adding five new system calls to support this feature.
> The five calls are distributed across three man-pages (one existing
> and 2 new), plus a new pkey(7) page which serves as a general
> overview of the feature.
> 
> The system calls for this feature are not currently upstream but
> can be found here:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/daveh/x86-pkeys.git/

Some general points:

* It would be better if this patch was split out into pieces, one 
  for each new syscall man page, and one for each changed existing 
  page.
* The patch doesn't apply as given. It would be great to get a parch
  against the latest man-pages version.

Would you be willing to take care of the above for a future patch?

Some specific comments below.

> Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> ---
>  man2/mprotect.2   |  45 ++++++++++++-
>  man2/pkey_alloc.2 | 103 +++++++++++++++++++++++++++++
>  man2/pkey_get.2   | 110 +++++++++++++++++++++++++++++++
>  man2/sigaction.2  |   9 +++
>  man5/proc.5       |   8 +++
>  man7/pkey.7       | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 464 insertions(+), 3 deletions(-)
>  create mode 100644 man2/pkey_alloc.2
>  create mode 100644 man2/pkey_get.2
>  create mode 100644 man7/pkey.7
> 
> diff --git a/man2/mprotect.2 b/man2/mprotect.2
> index ae305f6..742af70 100644
> --- a/man2/mprotect.2
> +++ b/man2/mprotect.2
> @@ -29,6 +29,7 @@
>  .\" Modified 2004-08-16 by Andi Kleen <ak-h9bWGtP8wOw@public.gmane.org>
>  .\" 2007-06-02, mtk: Fairly substantial rewrites and additions, and
>  .\" a much improved example program.
> +.\" 2016-03-03, added pkey_mprotect, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>

These days, we don't bother with internal changelogs, since there's 
the git log, so the previous change can be removed.

>  .\"
>  .\" FIXME The following protection flags need documenting:
>  .\"         PROT_SEM
> @@ -38,16 +39,19 @@
>  .\"
>  .TH MPROTECT 2 2015-07-23 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> -mprotect \- set protection on a region of memory
> +mprotect, pkey_mprotect \- set protection on a region of memory
>  .SH SYNOPSIS
>  .nf
>  .B #include <sys/mman.h>
>  .sp
>  .BI "int mprotect(void *" addr ", size_t " len ", int " prot );
> +.BI "int pkey_mprotect(void *" addr ", size_t " len ", int " prot ", int " pkey ");
>  .fi
>  .SH DESCRIPTION
>  .BR mprotect ()
> -changes protection for the calling process's memory page(s)
> +and
> +.BR pkey_mprotect ()
> +change protection for the calling process's memory page(s)
>  containing any part of the address range in the
>  interval [\fIaddr\fP,\ \fIaddr\fP+\fIlen\fP\-1].
>  .I addr
> @@ -74,10 +78,19 @@ The memory can be modified.
>  .TP
>  .B PROT_EXEC
>  The memory can be executed.
> +.PP
> +.I pkey
> +is the protection key to assign to the memory.
> +A pkey must be allocated with
> +.BR pkey_alloc (2)
> +before it is passed to
> +.BR pkey_mprotect ().
>  .SH RETURN VALUE
>  On success,
>  .BR mprotect ()
> -returns zero.
> +and
> +.BR pkey_mprotect ()
> +return zero.
>  On error, \-1 is returned, and
>  .I errno
>  is set appropriately.
> @@ -95,6 +108,8 @@ to mark it
>  .B EINVAL
>  \fIaddr\fP is not a valid pointer,
>  or not a multiple of the system page size.
> +Or: \fIpkey\fP has not been allocated with
> +.BR pkey_alloc (2)
>  .\" Or: both PROT_GROWSUP and PROT_GROWSDOWN were specified in 'prot'.
>  .TP
>  .B ENOMEM
> @@ -165,6 +180,29 @@ but at a minimum can allow write access only if
>  has been set, and must not allow any access if
>  .B PROT_NONE
>  has been set.
> +
> +Applications should be careful when mixing use of
> +.BR mprotect ()
> +and
> +.BR pkey_mprotect () .
> +On x86, when
> +.BR mprotect ()
> +is used with
> +.IR prot
> +set to
> +.B PROT_EXEC
> +a pkey is may be allocated and set on the memory implicitly
> +by the kernel, but only when the pkey was 0 previously.
> +
> +On systems that do not support protection keys in hardware,
> +.BR pkey_mprotect ()
> +may still be used, but
> +.IR pkey
> +must be set to 0.  When called this way, the operation of

The convention for man-pages is that new sentences always start 
of new source lines. (This makes subsequent patches less "noisy", 
since the common unit of change in a text is a sentence.)
Could you fix this throughout please?

> +.BR pkey_mprotect ()
> +is equivalent to
> +.BR mprotect ().
> +

Remove preceding blank line.

>  .SH EXAMPLE
>  .\" sigaction.2 refers to this example
>  .PP
> @@ -246,3 +284,4 @@ main(int argc, char *argv[])
>  .SH SEE ALSO
>  .BR mmap (2),
>  .BR sysconf (3)
> +.BR pkey (7)
> diff --git a/man2/pkey_alloc.2 b/man2/pkey_alloc.2
> new file mode 100644
> index 0000000..e931f82
> --- /dev/null
> +++ b/man2/pkey_alloc.2
> @@ -0,0 +1,103 @@
> +.\" Copyright (C) 2016 Intel Corporation
> +.\"
> +.\" %%%LICENSE_START(VERBATIM)
> +.\" Permission is granted to make and distribute verbatim copies of this
> +.\" manual provided the copyright notice and this permission notice are
> +.\" preserved on all copies.
> +.\"
> +.\" Permission is granted to copy and distribute modified versions of this
> +.\" manual under the conditions for verbatim copying, provided that the
> +.\" entire resulting derived work is distributed under the terms of a
> +.\" permission notice identical to this one.
> +.\"
> +.\" Since the Linux kernel and libraries are constantly changing, this
> +.\" manual page may be incorrect or out-of-date.  The author(s) assume no
> +.\" responsibility for errors or omissions, or for damages resulting from
> +.\" the use of the information contained herein.  The author(s) may not
> +.\" have taken the same level of care in the production of this manual,
> +.\" which is licensed free of charge, as they might when working
> +.\" professionally.
> +.\"
> +.\" Formatted or processed versions of this manual, if unaccompanied by
> +.\" the source, must acknowledge the copyright and author of this work.
> +.\" %%%LICENSE_END
> +.\"
> +.\" Created 2016-03-03 by Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
> +.\"
> +.\"
> +.TH PKEY_ALLOC 2 2016-03-03 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +pkey_alloc, pkey_free \- allocate or free a protection key
> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/mman.h>
> +.sp
> +.BI "int pkey_alloc(unsigned long " flags ", unsigned long " access_rights ");"
> +.BI "int pkey_free(int " pkey ");"
> +.fi
> +.SH DESCRIPTION
> +.BR pkey_alloc ()
> +allocates a protection key and allows it to be passed to
> +the other interfaces that accept a protection key like
> +.BR pkey_mprotect (),
> +.BR pkey_set ()
> +and
> +.BR pkey_get ().
> +.PP
> +.BR pkey_free ()
> +frees a protection key and makes it available to later

s/to/for/

> +allocations.  After a protection key has been freed, it may

The convention for man-pages is that new sentences always start 
of new source lines. Could you fix this throughout please?

> +no longer be used in any protection-key-related operations.
> +.PP
> +.RB ( pkey_alloc ())
> +.I flags
> +may contain zero or more disable operations:

Why "zero or more" rather than "zero or one"? I mean:
what sense could it make to OR together PKEY_DISABLE_ACCESS and
PKEY_DISABLE_WRITE?

> +.TP
> +.B PKEY_DISABLE_ACCESS
> +Disable all data access to memory covered by the returned protection key.
> +.TP
> +.B PKEY_DISABLE_WRITE
> +Disable write access to memory covered by the returned protection key.
> +.SH RETURN VALUE
> +On success,
> +.BR pkey_alloc ()
> +returns a positive protection key value.
> +.BR pkey_free ()
> +returns zero.
> +On error, \-1 is returned, and
> +.I errno
> +is set appropriately.
> +.SH ERRORS
> +.TP
> +.B EINVAL
> +.IR pkey ,
> +.IR flags ,
> +or
> +.I access_rights
> +is invalid.
> +.TP
> +.B ENOSPC
> +.(RB pkey_alloc ())
> +All protection keys available for the current process have
> +been allocated.  The number of keys available is architecture

s/architecture/architecture-specific/

> +an implementation-specfic and may be reduced by kernel-internal

s/an/and/

> +use of certain keys.  There are currently 15 keys available to
> +user programs on x86.
> +.SH VERSIONS
> +.BR pkey_alloc ()
> +and
> +.BR pkey_free ()
> +were added to Linux in kernel <FIXME>;
> +library support was added to glibc in version <FIXME>.
> +.SH CONFORMING TO
> +The
> +.BR pkey_alloc ()
> +and
> +.BR pkey_free ()
> +system calls are Linux-specific.
> +.SH
> +.SH SEE ALSO
> +.BR pkey_get (2),
> +.BR pkey_mprotect (2),
> +.BR pkey_set (2),
> +.BR pkey (7)
> diff --git a/man2/pkey_get.2 b/man2/pkey_get.2
> new file mode 100644
> index 0000000..ece9c46
> --- /dev/null
> +++ b/man2/pkey_get.2
> @@ -0,0 +1,110 @@
> +.\" Copyright (C) 2016 Intel Corporation
> +.\"
> +.\" %%%LICENSE_START(VERBATIM)
> +.\" Permission is granted to make and distribute verbatim copies of this
> +.\" manual provided the copyright notice and this permission notice are
> +.\" preserved on all copies.
> +.\"
> +.\" Permission is granted to copy and distribute modified versions of this
> +.\" manual under the conditions for verbatim copying, provided that the
> +.\" entire resulting derived work is distributed under the terms of a
> +.\" permission notice identical to this one.
> +.\"
> +.\" Since the Linux kernel and libraries are constantly changing, this
> +.\" manual page may be incorrect or out-of-date.  The author(s) assume no
> +.\" responsibility for errors or omissions, or for damages resulting from
> +.\" the use of the information contained herein.  The author(s) may not
> +.\" have taken the same level of care in the production of this manual,
> +.\" which is licensed free of charge, as they might when working
> +.\" professionally.
> +.\"
> +.\" Formatted or processed versions of this manual, if unaccompanied by
> +.\" the source, must acknowledge the copyright and author of this work.
> +.\" %%%LICENSE_END
> +.\"
> +.\" Created 2016-03-03 by Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
> +.\"
> +.\"
> +.TH PKEY_GET 2 2016-03-03 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +pkey_get, pkey_set \- manage protection key access permissions
> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/mman.h>
> +.sp
> +.BI "int pkey_get(int " pkey ", unsigned long " flags ");
> +.BI "int pkey_set(int " pkey ", unsigned long " access_rights ", unsigned long " flags ");"
> +.fi
> +.SH DESCRIPTION
> +.BR pkey_set ()
> +sets the current set of rights for the calling
> +thread for the protection key specified by
> +.IR pkey .
> +When rights for a key are disabled, any future access
> +to any memory region with that key set will generate a
> +.B SIGSEGV
> +signal.
> +Access rights are private to each thread.
> +.PP
> +.I access_rights
> +may contain zero or more disable operations:

See my earlier comments on "zero or more".

> +.TP
> +.B PKEY_DISABLE_ACCESS
> +Disable all access to memory protected by the specified protection key.
> +.TP
> +.B PKEY_DISABLE_WRITE
> +Disable write access to memory protected by the specified protection key.
> +.SH RETURN VALUE
> +On success,
> +.BR pkey_set ()
> +returns zero.
> +.BR pkey_get ()
> +returns a mask containing zero or more of the disable operations
> +listed above.
> +On error, \-1 is returned, and
> +.I errno
> +is set appropriately.
> +.SH ERRORS
> +.TP
> +.B EINVAL
> +.I pkey
> +or
> +.I access_rights
> +is invalid.
> +.SH NOTES
> +When any signal handler is invoked, the thread is temporarily
> +given a new, default set of protection key rights that override
> +whatever rights were set in the interrupted context.  The
> +thread's protection key rights are restored when the signal
> +handler returns.
> +
> +The effects of a call to
> +.BR pkey_set ()
> +from a signal handler will not persist when control passes out of
> +the signal handler.
> +This is true both when the handler returns to a normal,
> +nonsignal context, and when the signal handler is interrupted
> +by another signal handler.
> +
> +This signal behavior is unusual and is due to the fact that
> +the x86 PKRU register (which stores \fIaccess_rights\fP)
> +is managed with the same hardware mechanism (XSAVE) that
> +manages floating point registers.  The signal behavior is

s/floating point/floating-point/
(and in next line)

> +the same as that of a floating point register.
> +.SH VERSIONS
> +.BR pkey_get ()
> +and
> +.BR pkey_set ()
> +were added to Linux in kernel <FIXME>;
> +library support was added to glibc in version <FIXME>.
> +.SH CONFORMING TO
> +The
> +.BR pkey_get ()
> +and
> +.BR pkey_set ()
> +system calls are Linux-specific.
> +.SH SEE ALSO
> +.BR pkey_alloc (2),
> +.BR pkey_free (2),
> +.BR pkey_mprotect (2),
> +.BR pkey (7),
> diff --git a/man2/sigaction.2 b/man2/sigaction.2
> index 3704e74..ed5b874 100644
> --- a/man2/sigaction.2
> +++ b/man2/sigaction.2
> @@ -45,6 +45,7 @@
>  .\" 2010-06-11 mtk, improvements to discussion of various siginfo_t fields.
>  .\" 2015-01-17, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>  .\"	Added notes on ptrace SIGTRAP and SYS_SECCOMP.
> +.\" 2016-03-10, Dave Hansen, add si_pkey
>  .\"
>  .TH SIGACTION 2 2015-08-08 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> @@ -305,6 +306,8 @@ siginfo_t {
>                                (since Linux 3.5) */
>      unsigned int si_arch;  /* Architecture of attempted system call
>                                (since Linux 3.5) */
> +    unsigned int si_pkey;  /* Protection key set on si_addr
> +                              (since Linux <FIXME>) */
>  }
>  .fi
>  .in
> @@ -620,6 +623,12 @@ Address not mapped to object.
>  .TP
>  .B SEGV_ACCERR
>  Invalid permissions for mapped object.
> +.TP
> +.B SEGV_PKUERR
> +Access was denied by memory protection keys.  See:
> +.BR pkeys (7).
> +The protection key which applied to this access is available via
> +.I si_pkey
>  .RE
>  .PP
>  The following values can be placed in
> diff --git a/man5/proc.5 b/man5/proc.5
> index 768d920..e3132a1 100644
> --- a/man5/proc.5
> +++ b/man5/proc.5
> @@ -47,6 +47,7 @@
>  .\"     and /proc/[pid]/fdinfo/*.
>  .\" 2008-06-19, mtk, Documented /proc/[pid]/status.
>  .\" 2008-07-15, mtk, added /proc/config.gz
> +.\" 2016-03-10, Dave Hansen, added ProtectionKey to /proc/[pid]/smaps
>  .\"
>  .\" FIXME . cross check against Documentation/filesystems/proc.txt
>  .\" to see what information could be imported from that file
> @@ -1471,6 +1472,13 @@ The codes are the following:
>      nh  - no-huge page advise flag
>      mg  - mergeable advise flag
>  
> +"ProtectionKey" field contains the memory protection key (see
> +.BR pkeys (5))
> +associated with the virtual memory area.  Only present if the
> +kernel was built with the
> +.B CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> +configuration option. (since Linux 4.6)
> +
>  The
>  .IR /proc/[pid]/smaps
>  file is present only if the
> diff --git a/man7/pkey.7 b/man7/pkey.7
> new file mode 100644
> index 0000000..815ad7f
> --- /dev/null
> +++ b/man7/pkey.7
> @@ -0,0 +1,192 @@
> +.\" Copyright (C) 2016 Intel Corporation
> +.\"
> +.\" %%%LICENSE_START(VERBATIM)
> +.\" Permission is granted to make and distribute verbatim copies of this
> +.\" manual provided the copyright notice and this permission notice are
> +.\" preserved on all copies.
> +.\"
> +.\" Permission is granted to copy and distribute modified versions of this
> +.\" manual under the conditions for verbatim copying, provided that the
> +.\" entire resulting derived work is distributed under the terms of a
> +.\" permission notice identical to this one.
> +.\"
> +.\" Since the Linux kernel and libraries are constantly changing, this
> +.\" manual page may be incorrect or out-of-date.  The author(s) assume no
> +.\" responsibility for errors or omissions, or for damages resulting from
> +.\" the use of the information contained herein.  The author(s) may not
> +.\" have taken the same level of care in the production of this manual,
> +.\" which is licensed free of charge, as they might when working
> +.\" professionally.
> +.\"
> +.\" Formatted or processed versions of this manual, if unaccompanied by
> +.\" the source, must acknowledge the copyright and authors of this work.
> +.\" %%%LICENSE_END
> +.\"
> +.\" Created 2016-03-03 by Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
> +.\"
> +.TH PKEYS 7 2016-03-03 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +pkeys \- overview of Memory Protection Keys
> +.SH DESCRIPTION
> +

Remove preceding blank line.

> +Memory Protection Keys (pkeys) are an extension to existing
> +page-based memory permissions.  Normal page permissions using
> +page tables require expensive system calls and TLB invalidations
> +when changing permissions.  Memory Protection Keys provide a
> +mechanism for changing protections without requiring modification
> +of the page tables on every permission change.
> +
> +To use pkeys, software must first "tag" a page in the pagetables
> +with a pkey.  After this tag is in place, an application only has
> +to change the contents of a register in order to remove write
> +access, or all access to a tagged page.
> +
> +pkeys work in conjunction with the existing PROT_READ / PROT_WRITE /
> +PROT_EXEC permissions passed to system calls like
> +.BR mprotect (2)
> +and
> +.BR mmap (2),
> +but always act to further restrict these traditional permission
> +mechanisms.
> +
> +To use this feature, the processor must support it, and Linux
> +must contain support for the feature on a given processor.  As of
> +early 2016 only future Intel x86 processors are supported, and this
> +hardware supports 16 protection keys in each process.  However,
> +pkey 0 is used as the default key, so a maximum of 15 are available
> +for actual application use.

I think we need here (or somewhere) an explanation of what the 
"default key" is.

> +
> +Any application wanting to use protection keys needs to be able
> +to function without them.  They might be unavailable because the
> +hardware that the application runs on does not support them, the
> +kernel code does not contain support, the kernel support has been
> +disabled, or because the keys have all been allocated, perhaps by
> +a library the application is using.  It is recommended that
> +applications wanting to use protection keys should simply call
> +.BR pkey_alloc ()
> +instead of attempting to detect support for the
> +feature in any other way.
> +
> +Hardware support for protection keys may be enumerated with
> +the cpuid instruction.  Details on how to do this can be
> +found in the Intel Software Developers Manual.  The kernel
> +performs this enumeration and exposes the information in
> +/proc/cpuinfo under the "flags" field.  "pku" in this field
> +indicates hardware support for protection keys and "ospke"
> +indicates that the kernel contains and has enabled protection
> +keys support.
> +.SS Protection Keys system calls
> +The Linux kernel implements the following pkey-related system calls:
> +.BR pkey_mprotect (2),
> +.BR pkey_alloc (2),
> +.BR pkey_free (2),
> +.BR pkey_set (2),
> +and
> +.BR pkey_get (2) .
> +.SH NOTES
> +The Linux pkey system calls and are available only

s/and //

> +if the kernel was configured and built with the
> +.BR CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> +option.
> +.SH EXAMPLE
> +.PP
> +The program below allocates a page of memory with read/write
> +permissions via PROT_READ|PROT_WRITE.  It then writes some
> +data to the memory and successfully reads it back.  After
> +that, it attempts to allocate a protection key and
> +disallows access to it by passsing
> +.BR PKEY_DISABLE_ACCESS
> +to
> +.BR pkey_set.

s/pkey_set/pkey_set (2)/

> +It then tried to access
> +.BR buffer
> +which we now expect to cause a fatal signal to the application.
> +.in +4n
> +.nf
> +.RB "$" " ./a.out"
> +buffer contains: 73
> +about to read buffer again...
> +Segmentation fault (core dumped)
> +.fi
> +.in
> +.SS Program source
> +\&
> +.nf
> +#define _GNU_SOURCE
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +#include <stdio.h>
> +#include <sys/mman.h>
> +#include <assert.h>
> +
> +int sys_pkey_get(int pkey, unsigned long flags)
> +{
> +        return syscall(SYS_pkey_get, pkey);

In man-pages code examples, we use 4-space indents. Could you 
amend please?

Also, at various places in the code here, remove the "sys_" prefixes
in the function names.

> +}
> +
> +int sys_pkey_set(int pkey, unsigned long rights, unsigned long flags)
> +{
> +        return syscall(SYS_pkey_set, pkey, rights, flags);
> +}
> +
> +int sys_pkey_mprotect(void *ptr, size_t size, unsigned long orig_prot, unsigned long pkey)
> +{
> +        return syscall(SYS_pkey_mprotect, ptr, size, orig_prot, pkey);
> +}
> +
> +int pkey_alloc(void)
> +{
> +        return syscall(SYS_pkey_alloc, 0, 0);
> +}
> +
> +int pkey_free(unsigned long pkey)
> +{
> +        return syscall(SYS_pkey_free, pkey);
> +}
> +
> +int main(void)
> +{
> +        int err;

This isn't always an error value...
s/err/status/
(throughout)

> +        int pkey;
> +        int *buffer;
> +
> +        /* Allocate one page of memory: */
> +        buffer = mmap(NULL, getpagesize(), PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> +        assert(buffer != (void *)-1);

Change "(void *)-1" to MAP_FAILED

Also, using assert() for error checking is undesirable. See the setns(2)
for a preferable alternative. Could you amend throughout please.

> +
> +        /* Put some randome data in to the page (still OK to touch): */

s/randome/random/

> +        (*buffer) = __LINE__;
> +        printf("buffer contains: %d\\n", *buffer);
> +
> +        /* Allocate a protection key: */
> +        pkey = pkey_alloc();
> +        assert(pkey > 0);
> +
> +        /* Disable access to any memory with "pkey" set,
> +         * even though there is none right now. */
> +        err = sys_pkey_set(pkey, PKEY_DISABLE_ACCESS, 0);

Add error checking code here please.

> +
> +        /*
> +         * set the protection key on "buffer":
> +         * Note that it is still read/write as far as mprotect() is,
> +         * concerned and the previous pkey_set() overrides it.
> +         */
> +        err = sys_pkey_mprotect(buffer, getpagesize(), PROT_READ|PROT_WRITE, pkey);
> +        assert(!err);
> +
> +        printf("about to read buffer again...\\n");
> +        /* this will crash, because we have disallowed access: */
> +        printf("buffer contains: %d\\n", *buffer);
> +
> +        err = pkey_free(pkey);
> +        assert(!err);
> +
> +        return 0;
> +}
> +

Removve blank line above.

> +.SH SEE ALSO
> +.BR pkey_alloc (2),
> +.BR pkey_free (2),
> +.BR pkey_get (2),
> +.BR pkey_mprotect (2),
> +.BR pkey_set (2),

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
