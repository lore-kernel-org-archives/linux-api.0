From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: mark remap_file_pages() syscall as deprecated
Date: Thu, 12 Jun 2014 07:48:44 +0200
Message-ID: <CAHO5Pa31WVrtG+2hU1grbLHiEPjkM_eB4JgSStskX8AvDjQRKA@mail.gmail.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1399552888-11024-2-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399552888-11024-2-git-send-email-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kirill,

On Thu, May 8, 2014 at 2:41 PM, Kirill A. Shutemov
<kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> The remap_file_pages() system call is used to create a nonlinear mapp=
ing,
> that is, a mapping in which the pages of the file are mapped into a
> nonsequential order in memory. The advantage of using remap_file_page=
s()
> over using repeated calls to mmap(2) is that the former approach does=
 not
> require the kernel to create additional VMA (Virtual Memory Area) dat=
a
> structures.
>
> Supporting of nonlinear mapping requires significant amount of non-tr=
ivial
> code in kernel virtual memory subsystem including hot paths. Also to =
get
> nonlinear mapping work kernel need a way to distinguish normal page t=
able
> entries from entries with file offset (pte_file). Kernel reserves fla=
g in
> PTE for this purpose. PTE flags are scarce resource especially on som=
e CPU
> architectures. It would be nice to free up the flag for other usage.
>
> Fortunately, there are not many users of remap_file_pages() in the wi=
ld.
> It's only known that one enterprise RDBMS implementation uses the sys=
call
> on 32-bit systems to map files bigger than can linearly fit into 32-b=
it
> virtual address space. This use-case is not critical anymore since 64=
-bit
> systems are widely available.
>
> The plan is to deprecate the syscall and replace it with an emulation=
=2E
> The emulation will create new VMAs instead of nonlinear mappings. It'=
s
> going to work slower for rare users of remap_file_pages() but ABI is
> preserved.
>
> One side effect of emulation (apart from performance) is that user ca=
n hit
> vm.max_map_count limit more easily due to additional VMAs. See commen=
t for
> DEFAULT_MAX_MAP_COUNT for more details on the limit.

Best to CC linux-api@
(https://www.kernel.org/doc/man-pages/linux-api-ml.html) on patches
like this, as well as the man-pages maintainer, so that something goes
into the man page. I added the following into the man page:

       Note:  this  system  call  is (since Linux 3.16) deprecated and
       will eventually be replaced by a  slower  in-kernel  emulation.
       Those  few  applications  that use this system call should con=E2=
=80=90
       sider migrating to alternatives.

Okay?

Cheers,

Michael


> Signed-off-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  Documentation/vm/remap_file_pages.txt | 28 +++++++++++++++++++++++++=
+++
>  mm/fremap.c                           |  4 ++++
>  2 files changed, 32 insertions(+)
>  create mode 100644 Documentation/vm/remap_file_pages.txt
>
> diff --git a/Documentation/vm/remap_file_pages.txt b/Documentation/vm=
/remap_file_pages.txt
> new file mode 100644
> index 000000000000..560e4363a55d
> --- /dev/null
> +++ b/Documentation/vm/remap_file_pages.txt
> @@ -0,0 +1,28 @@
> +The remap_file_pages() system call is used to create a nonlinear map=
ping,
> +that is, a mapping in which the pages of the file are mapped into a
> +nonsequential order in memory. The advantage of using remap_file_pag=
es()
> +over using repeated calls to mmap(2) is that the former approach doe=
s not
> +require the kernel to create additional VMA (Virtual Memory Area) da=
ta
> +structures.
> +
> +Supporting of nonlinear mapping requires significant amount of non-t=
rivial
> +code in kernel virtual memory subsystem including hot paths. Also to=
 get
> +nonlinear mapping work kernel need a way to distinguish normal page =
table
> +entries from entries with file offset (pte_file). Kernel reserves fl=
ag in
> +PTE for this purpose. PTE flags are scarce resource especially on so=
me CPU
> +architectures. It would be nice to free up the flag for other usage.
> +
> +Fortunately, there are not many users of remap_file_pages() in the w=
ild.
> +It's only known that one enterprise RDBMS implementation uses the sy=
scall
> +on 32-bit systems to map files bigger than can linearly fit into 32-=
bit
> +virtual address space. This use-case is not critical anymore since 6=
4-bit
> +systems are widely available.
> +
> +The plan is to deprecate the syscall and replace it with an emulatio=
n.
> +The emulation will create new VMAs instead of nonlinear mappings. It=
's
> +going to work slower for rare users of remap_file_pages() but ABI is
> +preserved.
> +
> +One side effect of emulation (apart from performance) is that user c=
an hit
> +vm.max_map_count limit more easily due to additional VMAs. See comme=
nt for
> +DEFAULT_MAX_MAP_COUNT for more details on the limit.
> diff --git a/mm/fremap.c b/mm/fremap.c
> index 34feba60a17e..12c3bb63b7f9 100644
> --- a/mm/fremap.c
> +++ b/mm/fremap.c
> @@ -152,6 +152,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long,=
 start, unsigned long, size,
>         int has_write_lock =3D 0;
>         vm_flags_t vm_flags =3D 0;
>
> +       pr_warn_once("%s (%d) uses depricated remap_file_pages() sysc=
all. "
> +                       "See Documentation/vm/remap_file_pages.txt.\n=
",
> +                       current->comm, current->pid);
> +
>         if (prot)
>                 return err;
>         /*
> --
> 2.0.0.rc2
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>



--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
