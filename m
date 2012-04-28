From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] core dump: re-purpose VM_ALWAYSDUMP to user
 controlled VM_DONTDUMP
Date: Sat, 28 Apr 2012 19:29:32 +1200
Message-ID: <CAKgNAkg=fcSJvB98zJZX2n_wGvxewxHvh3r8XjXiKYG1N_oX_Q@mail.gmail.com>
References: <cover.1331137504.git.jbaron@redhat.com> <CAHO5Pa0cyvD-zUh-RRyOwvu2FGQYOMn_thFQt3_64BDi-wB=GQ@mail.gmail.com>
 <20120427184311.GB13762@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120427184311.GB13762-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mcgrathr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, avi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Jason,

On Sat, Apr 28, 2012 at 6:43 AM, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Apr 24, 2012 at 10:42:16AM +1200, Michael Kerrisk wrote:
>> Jason,
>>
>> On Thu, Mar 8, 2012 at 6:00 AM, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> > Hi,
>> >
>> > The motivation for this change was that I was looking at a way for=
 a qemu-kvm
>> > process, to exclude the guest memory from its core dump, which can=
 be quite
>> > large. There are already a number of filter flags in
>> > /proc/<pid>/coredump_filter, however, these allow one to specify '=
types' of
>> > kernel memory, not specific address ranges (which is needed in thi=
s case).
>> >
>> > Since there are no more vma flags available, the first patch elimi=
nates the
>> > need for the 'VM_ALWAYSDUMP' flag. The flag is used internally by =
the kernel to
>> > mark vdso and vsyscall pages. However, it is simple enough to chec=
k if a vma
>> > covers a vdso or vsyscall page without the need for this flag.
>> >
>> > The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new
>> > 'VM_DONTDUMP' flag, which can be set by userspace using new madvis=
e flags:
>> > 'MADV_DONTDUMP', and unset via 'MADV_DUMP'. The core dump filters =
continue to
>> > work the same as before unless 'MADV_DONTDUMP' is set on the regio=
n.
>> >
>> > The qemu code which implements this features is at:
>> > http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch
>> >
>> > In my testing the qemu core dump shrunk from 383MB -> 13MB with th=
is patch.
>> >
>> > I also believe that the 'MADV_DONTDUMP' flag might be useful for s=
ecurity
>> > sensitive apps, which might want to select which areas are dumped.
>>
>> Since we have
>> MADV_DODUMP
>> MADV_DONTDUMP
>> MADV_NODUMP
>> heading for userspace in 3.4, would you be willing to write patches
>> for the madvise(2) man page to describe these flags?
>>
>> See http://www.kernel.org/doc/man-pages/download.html for details on
>> accessing man-pages Git.
>>
>> Cheers,
>>
>> Michael
>>
>> PS Please also CC linux-api@ when making API/ABI changes.
>>
>
> Ok, here's a stab at manpage patch, let me know if I should send it a=
s a
> separate patch. Thanks.
>
> -Jason
>
>
> diff --git a/man2/madvise.2 b/man2/madvise.2
> index 36f988a..472c23a 100644
> --- a/man2/madvise.2
> +++ b/man2/madvise.2
> @@ -247,6 +247,22 @@ Ensures that memory in the address range specifi=
ed by
> =A0and
> =A0.IR length
> =A0will not be collapsed into huge pages.
> +.TP
> +.BR MADV_DONTDUMP " (since Linux 3.4)"
> +Explicitly exclude from a core dump those pages in the range specifi=
ed by
> +.I addr
> +and
> +.IR length .
> +Applications may have large areas of memory which are known not to b=
e useful in
> +diagnosing a core dump. This specification takes precedence over the=
 bit mask that
> +is set via the
> +.I /proc/PID/coredump_filter
> +file (see
> +.BR core (5)).
> +.TP
> +.BR MADV_DODUMP " (since Linux 3.4)"
> +Undo the effect of an earlier
> +.BR MADV_DONTDUMP.
> =A0.SH "RETURN VALUE"
> =A0On success
> =A0.BR madvise ()
> @@ -356,4 +372,5 @@ from the system call, as it should).
> =A0.BR mmap (2),
> =A0.BR mprotect (2),
> =A0.BR msync (2),
> -.BR munmap (2)
> +.BR munmap (2),
> +.BR core (5)

Thanks! I tweaked this patch a little and applied the version below.

Cheers,

Michael

--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -247,6 +247,24 @@ Ensures that memory in the address range specified=
 by
 and
 .IR length
 will not be collapsed into huge pages.
+.TP
+.BR MADV_DONTDUMP " (since Linux 3.4)"
+Exclude from a core dump those pages in the range specified by
+.I addr
+and
+.IR length .
+This is useful in applications that have large areas of memory
+that are known not to be useful in a core dump.
+The effect of
+.BR MADV_DONTDUMP
+takes precedence over the bit mask that is set via the
+.I /proc/PID/coredump_filter
+file (see
+.BR core (5)).
+.TP
+.BR MADV_DODUMP " (since Linux 3.4)"
+Undo the effect of an earlier
+.BR MADV_DONTDUMP .
 .SH "RETURN VALUE"
 On success
 .BR madvise ()
@@ -356,4 +374,5 @@ from the system call, as it should).
 .BR mmap (2),
 .BR mprotect (2),
 .BR msync (2),
-.BR munmap (2)
+.BR munmap (2),
+.BR core (5)

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
