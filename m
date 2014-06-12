From: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: mark remap_file_pages() syscall as deprecated
Date: Thu, 12 Jun 2014 12:40:14 +0300 (EEST)
Message-ID: <20140612094014.BFEA4E00A2@blue.fi.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1399552888-11024-2-git-send-email-kirill.shutemov@linux.intel.com>
 <CAHO5Pa31WVrtG+2hU1grbLHiEPjkM_eB4JgSStskX8AvDjQRKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHO5Pa31WVrtG+2hU1grbLHiEPjkM_eB4JgSStskX8AvDjQRKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Michael Kerrisk wrote:
> Hi Kirill,
>=20
> On Thu, May 8, 2014 at 2:41 PM, Kirill A. Shutemov
> <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > The remap_file_pages() system call is used to create a nonlinear ma=
pping,
> > that is, a mapping in which the pages of the file are mapped into a
> > nonsequential order in memory. The advantage of using remap_file_pa=
ges()
> > over using repeated calls to mmap(2) is that the former approach do=
es not
> > require the kernel to create additional VMA (Virtual Memory Area) d=
ata
> > structures.
> >
> > Supporting of nonlinear mapping requires significant amount of non-=
trivial
> > code in kernel virtual memory subsystem including hot paths. Also t=
o get
> > nonlinear mapping work kernel need a way to distinguish normal page=
 table
> > entries from entries with file offset (pte_file). Kernel reserves f=
lag in
> > PTE for this purpose. PTE flags are scarce resource especially on s=
ome CPU
> > architectures. It would be nice to free up the flag for other usage=
=2E
> >
> > Fortunately, there are not many users of remap_file_pages() in the =
wild.
> > It's only known that one enterprise RDBMS implementation uses the s=
yscall
> > on 32-bit systems to map files bigger than can linearly fit into 32=
-bit
> > virtual address space. This use-case is not critical anymore since =
64-bit
> > systems are widely available.
> >
> > The plan is to deprecate the syscall and replace it with an emulati=
on.
> > The emulation will create new VMAs instead of nonlinear mappings. I=
t's
> > going to work slower for rare users of remap_file_pages() but ABI i=
s
> > preserved.
> >
> > One side effect of emulation (apart from performance) is that user =
can hit
> > vm.max_map_count limit more easily due to additional VMAs. See comm=
ent for
> > DEFAULT_MAX_MAP_COUNT for more details on the limit.
>=20
> Best to CC linux-api@
> (https://www.kernel.org/doc/man-pages/linux-api-ml.html) on patches
> like this, as well as the man-pages maintainer, so that something goe=
s
> into the man page. I added the following into the man page:
>=20
>        Note:  this  system  call  is (since Linux 3.16) deprecated an=
d
>        will eventually be replaced by a  slower  in-kernel  emulation=
=2E
>        Those  few  applications  that use this system call should con=
=E2=80=90
>        sider migrating to alternatives.
>=20
> Okay?

Yep. Looks okay to me.

--=20
 Kirill A. Shutemov
