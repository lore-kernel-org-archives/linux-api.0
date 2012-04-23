From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] core dump: re-purpose VM_ALWAYSDUMP to user
 controlled VM_DONTDUMP
Date: Tue, 24 Apr 2012 10:42:16 +1200
Message-ID: <CAHO5Pa0cyvD-zUh-RRyOwvu2FGQYOMn_thFQt3_64BDi-wB=GQ@mail.gmail.com>
References: <cover.1331137504.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1331137504.git.jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mcgrathr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, avi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Jason,

On Thu, Mar 8, 2012 at 6:00 AM, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> The motivation for this change was that I was looking at a way for a qemu-kvm
> process, to exclude the guest memory from its core dump, which can be quite
> large. There are already a number of filter flags in
> /proc/<pid>/coredump_filter, however, these allow one to specify 'types' of
> kernel memory, not specific address ranges (which is needed in this case).
>
> Since there are no more vma flags available, the first patch eliminates the
> need for the 'VM_ALWAYSDUMP' flag. The flag is used internally by the kernel to
> mark vdso and vsyscall pages. However, it is simple enough to check if a vma
> covers a vdso or vsyscall page without the need for this flag.
>
> The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new
> 'VM_DONTDUMP' flag, which can be set by userspace using new madvise flags:
> 'MADV_DONTDUMP', and unset via 'MADV_DUMP'. The core dump filters continue to
> work the same as before unless 'MADV_DONTDUMP' is set on the region.
>
> The qemu code which implements this features is at:
> http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch
>
> In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.
>
> I also believe that the 'MADV_DONTDUMP' flag might be useful for security
> sensitive apps, which might want to select which areas are dumped.

Since we have
MADV_DODUMP
MADV_DONTDUMP
MADV_NODUMP
heading for userspace in 3.4, would you be willing to write patches
for the madvise(2) man page to describe these flags?

See http://www.kernel.org/doc/man-pages/download.html for details on
accessing man-pages Git.

Cheers,

Michael

PS Please also CC linux-api@ when making API/ABI changes.


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
