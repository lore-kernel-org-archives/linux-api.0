From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFC] add manpages for Memory Protection Keys
Date: Thu, 10 Mar 2016 18:07:25 +0100
Message-ID: <56E1A9CD.9030903@gmail.com>
References: <1457559619-16510-1-git-send-email-dave.hansen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457559619-16510-1-git-send-email-dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dave-gkUM19QKKo4@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/09/2016 10:40 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
> 
> Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> ---
>  man2/mprotect.2   | 35 ++++++++++++++++++++--
>  man2/pkey_alloc.2 | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  man2/pkey_get.2   | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man2/sigaction.2  |  6 ++++
>  man7/pkey.7       | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 292 insertions(+), 3 deletions(-)
>  create mode 100644 man2/pkey_alloc.2
>  create mode 100644 man2/pkey_get.2
>  create mode 100644 man7/pkey.7
> 
> diff --git a/man2/mprotect.2 b/man2/mprotect.2
> index ae305f6..80ce909 100644
> --- a/man2/mprotect.2
> +++ b/man2/mprotect.2
> @@ -29,6 +29,7 @@
>  .\" Modified 2004-08-16 by Andi Kleen <ak-h9bWGtP8wOw@public.gmane.org>
>  .\" 2007-06-02, mtk: Fairly substantial rewrites and additions, and
>  .\" a much improved example program.
> +.\" 2016-03-03, added pkey_mprotect, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
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
> @@ -74,10 +78,18 @@ The memory can be modified.
>  .TP
>  .B PROT_EXEC
>  The memory can be executed.
> +.PP
> +.I pkey
> +is the protection key to assign to the memory.
> +A pkey must be allocated with
> +.BR pkey_alloc (2)
> +before it is passed to pkey_mprotect ().

==> new line:

.BR pkey_mprotect ().

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
> @@ -95,6 +107,8 @@ to mark it
>  .B EINVAL
>  \fIaddr\fP is not a valid pointer,
>  or not a multiple of the system page size.
> +Or: \fIpkey\fP has not been allocated with
> +.BR pkey_alloc (2)
>  .\" Or: both PROT_GROWSUP and PROT_GROWSDOWN were specified in 'prot'.
>  .TP
>  .B ENOMEM
> @@ -165,6 +179,20 @@ but at a minimum can allow write access only if
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
>  .SH EXAMPLE
>  .\" sigaction.2 refers to this example
>  .PP
> @@ -246,3 +274,4 @@ main(int argc, char *argv[])
>  .SH SEE ALSO
>  .BR mmap (2),
>  .BR sysconf (3)
> +.BR pkey (7)

In a commit message, you note:

"On systems that do not support
protection keys, it still works, but requires that key=0."

I think this could be added in NOTES.


> diff --git a/man2/pkey_alloc.2 b/man2/pkey_alloc.2
> new file mode 100644
> index 0000000..13fec90
> --- /dev/null
> +++ b/man2/pkey_alloc.2
> @@ -0,0 +1,82 @@
> +.\" Copyright (C) 2016 Intel Corporation
> +.\"
> +.\" %%%license_start(verbatim)
> +.\" permission is granted to make and distribute verbatim copies of this
> +.\" manual provided the copyright notice and this permission notice are
> +.\" preserved on all copies.
> +.\"
> +.\" permission is granted to copy and distribute modified versions of this
> +.\" manual under the conditions for verbatim copying, provided that the
> +.\" entire resulting derived work is distributed under the terms of a
> +.\" permission notice identical to this one.
> +.\"
> +.\" since the linux kernel and libraries are constantly changing, this
> +.\" manual page may be incorrect or out-of-date.  the author(s) assume no
> +.\" responsibility for errors or omissions, or for damages resulting from
> +.\" the use of the information contained herein.  the author(s) may not
> +.\" have taken the same level of care in the production of this manual,
> +.\" which is licensed free of charge, as they might when working
> +.\" professionally.
> +.\"
> +.\" formatted or processed versions of this manual, if unaccompanied by
> +.\" the source, must acknowledge the copyright and author of this work.
> +.\" %%%license_end
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
> +and
> +.BR pkey_free ()
> +allow or disallow the calling process to use the given
> +protection key for all protection-key-related operations.

Actually, the above paragraph doesn't explain what pkey_free() does.
That explanation should, I think, be in a separate paragraph below
the description of 'flags'.

> +.PP
> +.I flags
> +may contain zero or more disable operations:
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

At the start of the following paragraph, add

.(RB pkey_alloc ())

so that the reader knows that this error applies only for that syscall.

> +All protection keys available for the current process have
> +been allocated.  The number of keys available is architecture
> +an implementation-specfic and may be reduced by kernel-internal
> +use of certain keys.  There are currently 15 keys available to
> +user programs on x86.

Here, there should be a VERSIONS section noting the Linux kernel
version where these system calls appeared and a CONFORMING TO
section noting that these system calls are Linux-specific.

> +.SH SEE ALSO
> +.BR pkey_mprotect (2),

Move above line after the next line.

> +.BR pkey_get (2),
> +.BR pkey_set (2),
> +.BR pkey (7)
> diff --git a/man2/pkey_get.2 b/man2/pkey_get.2
> new file mode 100644
> index 0000000..89a6015
> --- /dev/null
> +++ b/man2/pkey_get.2
> @@ -0,0 +1,88 @@
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
> +.BI "int pkey_get(int " pkey);
> +.BI "int pkey_set(int " pkey ", unsigned long " access_rights ");"
> +.fi
> +.SH DESCRIPTION
> +.BR pkey_get ()
> +and
> +.BR pkey_set ()
> +query or set the current set of rights for the calling
> +thread for the given protection key.
> +When rights for a key are disabled, any future access
> +to any memory region with that key set will generate
> +a SIGSEGV.  Access rights are private to each thread.

Rewrite the preceding paragraph as

===
.BR pkey_set ()
sets the current set of rights for the calling
thread for the protection key specified by
.IR pkey .
When rights for a key are disabled, any future access
to any memory region with that key set will generate a
.B SIGSEGV
signal.
Access rights are private to each thread.
.PP
.I access_rights
may contain zero or more disable operations:
.TP
.B PKEY_DISABLE_ACCESS
Disable all access to memory protected by the specified protection key.
.TP
.B PKEY_DISABLE_WRITE
Disable write access to memory protected by the specified protection key.

The
.pkey_get ()
system call returns the current set of rights assigned for the protection key,
.IR pkey .
===

The next three paragraphs should I think be moved to a NOTES section
lower in the page.

> +.PP
> +When any signal handler is invoked, the thread is temporarily
> +given a new, default set of protection key rights that override
> +whatever rights were set in the interrupted context.  The
> +thread's protection key rights are restored when the signal
> +handler returns.
>
> +Any call to

Make the preceding line: "The effects of a call to"

> +.BR pkey_set ()
> +from a signal handler will not persist when the signal handler
> +returns.
> +
> +This signal behavior is unusual and is due to the fact that
> +the x86 PKRU register (which stores \fIaccess_rights\fP)
> +is managed with the same hardware mechanism (XSAVE) that
> +manages floating point registers.  The signal behavior is
> +the same as that of a floating point register.

In a previous review of the pages, I asked:

[[
And I have a question (and the answer probably should 
be documented in the manual page).  What happens when 
one signal handler interrupts the execution of another? 
Do pkey_set() calls in the first handler persist into the 
second handler? I presume not, but it would be good to 
be a little more explicit about this.
]]

I think this point does need to be covered in the man page.

> +.PP
> +.I access_rights
> +may contain zero or more disable operations:
> +.B PKEY_DISABLE_ACCESS
> +and/or
> +.B PKEY_DISABLE_WRITE

The above paragraph should be moved up. See my rewrite above.

> +.SH RETURN VALUE
> +On success,
> +.BR pkey_set ()
> +returns zero.
> +.BR pkey_get ()
> +returns a mask containing one or more of the disable operations

s/one/zero/ ?

> +listed above.
> +On error, \-1 is returned, and
> +.I errno
> +is set appropriately.
> +.SH ERRORS
> +.TP
> +.B EINVAL
> +An invalid protection key or access_rights was specified.

Make that last line:

.I pkey
or
.I access_rights
is invalid.


Here, there should be a VERSIONS section noting the Linux kernel
version where these system calls appeared and a CONFORMING TO
section noting that these system calls are Linux-specific.
 
> +.SH SEE ALSO

Order the section 2 pages alphabetically:

> +.BR pkey_mprotect (2),
> +.BR pkey_alloc (2),
> +.BR pkey_free (2),
> +.BR pkey (7),
> diff --git a/man2/sigaction.2 b/man2/sigaction.2
> index 3704e74..18c1f44 100644
> --- a/man2/sigaction.2
> +++ b/man2/sigaction.2
> @@ -620,6 +620,12 @@ Address not mapped to object.
>  .TP
>  .B SEGV_ACCERR
>  Invalid permissions for mapped object.
> +.TP
> +.B SEGV_PKUERR
> +Access was denied by memory protection keys.  See:
> +.BR pkeys (7).
> +The protection key which applied to this access is available via
> +.I si_pkey

So, pi_key needs to be added to the structure definition shown earlier in 
the page.

>  .RE
>  .PP
>  The following values can be placed in
> diff --git a/man7/pkey.7 b/man7/pkey.7
> new file mode 100644
> index 0000000..d3da531
> --- /dev/null
> +++ b/man7/pkey.7
> @@ -0,0 +1,84 @@
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
> +.BR mmap (2)

s/$/,/

> +, but always act to further restrict these traditional permission

s/, //

> +mechanisms.
> +
> +To use this feature, the processor must support it, and Linux
> +must contain support for the feature on a given processor.  As of
> +early 2016 only future Intel x86 processors are supported, and this
> +hardware supports 16 protection keys in each process.  However,
> +pkey 0 is used as the default key, so a maximum of 15 are available
> +for actual application use.

Is there a recommended way for an application to discover whether the
system supports pkeys? If so, that should be documented here.

> +
> +.SS Protection Keys system calls
> +The Linux kernel implements the following pkey-related system calls:
> +.BR pkey_mprotect (2),
> +.BR pkey_alloc (2),
> +.BR pkey_free (2),
> +.BR pkey_set (2),
> +and
> +.BR pkey_get (2) .
> +.SS /proc/[number]/smaps  (since Linux 4.6)
> +Each line contains information about a memory range used by the process,
> +displaying\(emamong other information\(emthe the pkeys for each range on
> +a line labeled: "ProtectionKey:".

The above piece should be done as a patch to the 'smaps'
entry in proc(5).

> +
> +.SH NOTES
> +The Linux pkey system calls and
> +.I /proc/[number]/smaps
> +interface are available only

The detail about smaps should also be in the patch to proc(5).

> +if the kernel was configured and built with the
> +.BR CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> +option.
> +.SH SEE ALSO

Order the following list alphabetically:

> +.BR pkey_mprotect (2),
> +.BR pkey_alloc (2),
> +.BR pkey_free (2),
> +.BR pkey_set (2),
> +.BR pkey_get (2),

Would it be possible to get a small, complete working example program
in one of these pages? The axample could show how pkeys override
traditional memory protections. I appreciate that the rest of us do
not yet have suitable hardware, but presumably you do.

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
