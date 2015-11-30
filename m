From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v5 01/12] mm: support madvise(MADV_FREE)
Date: Mon, 30 Nov 2015 18:22:30 +0900
Message-ID: <20151130092229.GA10745@bbox>
References: <1448865583-2446-1-git-send-email-minchan@kernel.org>
 <1448865583-2446-2-git-send-email-minchan@kernel.org>
 <565C06C9.7040906@nextfour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <565C06C9.7040906@nextfour.com>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Andy Lutomirski <luto@amacapital.net>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 10:20:25AM +0200, Mika Penttil=E4 wrote:
> > +		 * If pmd isn't transhuge but the page is THP and
> > +		 * is owned by only this process, split it and
> > +		 * deactivate all pages.
> > +		 */
> > +		if (PageTransCompound(page)) {
> > +			if (page=5Fmapcount(page) !=3D 1)
> > +				goto out;
> > +			get=5Fpage(page);
> > +			if (!trylock=5Fpage(page)) {
> > +				put=5Fpage(page);
> > +				goto out;
> > +			}
> > +			pte=5Funmap=5Funlock(orig=5Fpte, ptl);
> > +			if (split=5Fhuge=5Fpage(page)) {
> > +				unlock=5Fpage(page);
> > +				put=5Fpage(page);
> > +				pte=5Foffset=5Fmap=5Flock(mm, pmd, addr, &ptl);
> > +				goto out;
> > +			}
> > +			pte =3D pte=5Foffset=5Fmap=5Flock(mm, pmd, addr, &ptl);
> > +			pte--;
> > +			addr -=3D PAGE=5FSIZE;
> > +			continue;
> > +		}
>=20
> looks like this leaks page count if split=5Fhuge=5Fpage() is succesfull
> (returns zero).

Even, I missed unlock=5Fpage.
Thanks for the review!

>From d22483fae454b100bcf73d514dd7d903fd84f744 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 30 Oct 2015 16:01:37 +0900
Subject: [PATCH v5 01/12] mm: support madvise(MADV=5FFREE)

Linux doesn't have an ability to free pages lazy while other OS already
have been supported that named by madvise(MADV=5FFREE).

The gain is clear that kernel can discard freed pages rather than swapping
out or OOM if memory pressure happens.

Without memory pressure, freed pages would be reused by userspace without
another additional overhead(ex, page fault + allocation + zeroing).

Jason Evans said:

: Facebook has been using MAP=5FUNINITIALIZED
: (https://lkml.org/lkml/2012/1/18/308) in some of its applications for
: several years, but there are operational costs to maintaining this
: out-of-tree in our kernel and in jemalloc, and we are anxious to retire it
: in favor of MADV=5FFREE.  When we first enabled MAP=5FUNINITIALIZED it
: increased throughput for much of our workload by ~5%, and although the
: benefit has decreased using newer hardware and kernels, there is still
: enough benefit that we cannot reasonably retire it without a replacement.
:
: Aside from Facebook operations, there are numerous broadly used
: applications that would benefit from MADV=5FFREE.  The ones that immediat=
ely
: come to mind are redis, varnish, and MariaDB.  I don't have much insight
: into Android internals and development process, but I would hope to see
: MADV=5FFREE support eventually end up there as well to benefit applicatio=
ns
: linked with the integrated jemalloc.
:
: jemalloc will use MADV=5FFREE once it becomes available in the Linux kern=
el.
: In fact, jemalloc already uses MADV=5FFREE or equivalent everywhere it's
: available: *BSD, OS X, Windows, and Solaris -- every platform except Linux
: (and AIX, but I'm not sure it even compiles on AIX).  The lack of
: MADV=5FFREE on Linux forced me down a long series of increasingly
: sophisticated heuristics for madvise() volume reduction, and even so this
: remains a common performance issue for people using jemalloc on Linux.
: Please integrate MADV=5FFREE; many people will benefit substantially.

How it works:

When madvise syscall is called, VM clears dirty bit of ptes of the range.
If memory pressure happens, VM checks dirty bit of page table and if it
found still "clean", it means it's a "lazyfree pages" so VM could discard
the page instead of swapping out.  Once there was store operation for the
page before VM peek a page to reclaim, dirty bit is set so VM can swap out
the page instead of discarding.

One thing we should notice is that basically, MADV=5FFREE relies on dirty b=
it
in page table entry to decide whether VM allows to discard the page or not.
IOW, if page table entry includes marked dirty bit, VM shouldn't discard
the page.

However, as a example, if swap-in by read fault happens, page table entry
doesn't have dirty bit so MADV=5FFREE could discard the page wrongly.

For avoiding the problem, MADV=5FFREE did more checks with PageDirty
and PageSwapCache. It worked out because swapped-in page lives on
swap cache and since it is evicted from the swap cache, the page has
PG=5Fdirty flag. So both page flags check effectively prevent
wrong discarding by MADV=5FFREE.

However, a problem in above logic is that swapped-in page has
PG=5Fdirty still after they are removed from swap cache so VM cannot
consider the page as freeable any more even if madvise=5Ffree is
called in future.

Look at below example for detail.

    ptr =3D malloc();
    memset(ptr);
    ..
    ..
    .. heavy memory pressure so all of pages are swapped out
    ..
    ..
    var =3D *ptr; -> a page swapped-in and could be removed from
                   swapcache. Then, page table doesn't mark
                   dirty bit and page descriptor includes PG=5Fdirty
    ..
    ..
    madvise=5Ffree(ptr); -> It doesn't clear PG=5Fdirty of the page.
    ..
    ..
    ..
    .. heavy memory pressure again.
    .. In this time, VM cannot discard the page because the page
    .. has *PG=5Fdirty*

To solve the problem, this patch clears PG=5Fdirty if only the page is owned
exclusively by current process when madvise is called because PG=5Fdirty
represents ptes's dirtiness in several processes so we could clear it only
if we own it exclusively.

Firstly, heavy users would be general allocators(ex, jemalloc, tcmalloc
and hope glibc supports it) and jemalloc/tcmalloc already have supported
the feature for other OS(ex, FreeBSD)

barrios@blaptop:~/benchmark/ebizzy$ lscpu
Architecture:          x86=5F64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                12
On-line CPU(s) list:   0-11
Thread(s) per core:    1
Core(s) per socket:    1
Socket(s):             12
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 2
Stepping:              3
CPU MHz:               3200.185
BogoMIPS:              6400.53
Virtualization:        VT-x
Hypervisor vendor:     KVM
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              4096K
NUMA node0 CPU(s):     0-11
ebizzy benchmark(./ebizzy -S 10 -n 512)

Higher avg is better.

 vanilla-jemalloc		MADV=5Ffree-jemalloc

1 thread
records: 10			    records: 10
avg:	2961.90			    avg:   12069.70
std:	  71.96(2.43%)		    std:     186.68(1.55%)
max:	3070.00			    max:   12385.00
min:	2796.00			    min:   11746.00

2 thread
records: 10			    records: 10
avg:	5020.00			    avg:   17827.00
std:	 264.87(5.28%)		    std:     358.52(2.01%)
max:	5244.00			    max:   18760.00
min:	4251.00			    min:   17382.00

4 thread
records: 10			    records: 10
avg:	8988.80			    avg:   27930.80
std:	1175.33(13.08%)		    std:    3317.33(11.88%)
max:	9508.00			    max:   30879.00
min:	5477.00			    min:   21024.00

8 thread
records: 10			    records: 10
avg:   13036.50			    avg:   33739.40
std:	 170.67(1.31%)		    std:    5146.22(15.25%)
max:   13371.00			    max:   40572.00
min:   12785.00			    min:   24088.00

16 thread
records: 10			    records: 10
avg:   11092.40			    avg:   31424.20
std:	 710.60(6.41%)		    std:    3763.89(11.98%)
max:   12446.00			    max:   36635.00
min:	9949.00			    min:   25669.00

32 thread
records: 10			    records: 10
avg:   11067.00			    avg:   34495.80
std:	 971.06(8.77%)		    std:    2721.36(7.89%)
max:   12010.00			    max:   38598.00
min:	9002.00			    min:   30636.00

In summary, MADV=5FFREE is about much faster than MADV=5FDONTNEED.

Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/rmap.h                   |   1 +
 include/linux/vm=5Fevent=5Fitem.h          |   1 +
 include/uapi/asm-generic/mman-common.h |   1 +
 mm/madvise.c                           | 170 +++++++++++++++++++++++++++++=
++++
 mm/rmap.c                              |   8 ++
 mm/swap=5Fstate.c                        |   5 +-
 mm/vmscan.c                            |  10 +-
 mm/vmstat.c                            |   1 +
 8 files changed, 192 insertions(+), 5 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 77d1ba57d495..04d2aec64e57 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -85,6 +85,7 @@ enum ttu=5Fflags {
 	TTU=5FUNMAP =3D 1,			/* unmap mode */
 	TTU=5FMIGRATION =3D 2,		/* migration mode */
 	TTU=5FMUNLOCK =3D 4,		/* munlock mode */
+	TTU=5FLZFREE =3D 8,			/* lazy free mode */
=20
 	TTU=5FIGNORE=5FMLOCK =3D (1 << 8),	/* ignore mlock */
 	TTU=5FIGNORE=5FACCESS =3D (1 << 9),	/* don't age */
diff --git a/include/linux/vm=5Fevent=5Fitem.h b/include/linux/vm=5Fevent=
=5Fitem.h
index e1f8c993e73b..67c1dbd19c6d 100644
--- a/include/linux/vm=5Fevent=5Fitem.h
+++ b/include/linux/vm=5Fevent=5Fitem.h
@@ -25,6 +25,7 @@ enum vm=5Fevent=5Fitem { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR=5FALL=5FZONES(PGALLOC),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
+		PGLAZYFREED,
 		FOR=5FALL=5FZONES(PGREFILL),
 		FOR=5FALL=5FZONES(PGSTEAL=5FKSWAPD),
 		FOR=5FALL=5FZONES(PGSTEAL=5FDIRECT),
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-gene=
ric/mman-common.h
index a74dd84bbb6d..0e821e3c3d45 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -39,6 +39,7 @@
 #define MADV=5FSEQUENTIAL	2		/* expect sequential page references */
 #define MADV=5FWILLNEED	3		/* will need these pages */
 #define MADV=5FDONTNEED	4		/* don't need these pages */
+#define MADV=5FFREE	5		/* free pages only if memory pressure */
=20
 /* common parameters: try to keep these consistent across architectures */
 #define MADV=5FREMOVE	9		/* remove these pages & resources */
diff --git a/mm/madvise.c b/mm/madvise.c
index c889fcbb530e..ed137fde4459 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -20,6 +20,9 @@
 #include <linux/backing-dev.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/mmu=5Fnotifier.h>
+
+#include <asm/tlb.h>
=20
 /*
  * Any behaviour which results in changes to the vma->vm=5Fflags needs to
@@ -32,6 +35,7 @@ static int madvise=5Fneed=5Fmmap=5Fwrite(int behavior)
 	case MADV=5FREMOVE:
 	case MADV=5FWILLNEED:
 	case MADV=5FDONTNEED:
+	case MADV=5FFREE:
 		return 0;
 	default:
 		/* be safe, default to 1. list exceptions explicitly */
@@ -256,6 +260,163 @@ static long madvise=5Fwillneed(struct vm=5Farea=5Fstr=
uct *vma,
 	return 0;
 }
=20
+static int madvise=5Ffree=5Fpte=5Frange(pmd=5Ft *pmd, unsigned long addr,
+				unsigned long end, struct mm=5Fwalk *walk)
+
+{
+	struct mmu=5Fgather *tlb =3D walk->private;
+	struct mm=5Fstruct *mm =3D tlb->mm;
+	struct vm=5Farea=5Fstruct *vma =3D walk->vma;
+	spinlock=5Ft *ptl;
+	pte=5Ft *orig=5Fpte, *pte, ptent;
+	struct page *page;
+
+	split=5Fhuge=5Fpmd(vma, pmd, addr);
+	if (pmd=5Ftrans=5Funstable(pmd))
+		return 0;
+
+	orig=5Fpte =3D pte =3D pte=5Foffset=5Fmap=5Flock(mm, pmd, addr, &ptl);
+	arch=5Fenter=5Flazy=5Fmmu=5Fmode();
+	for (; addr !=3D end; pte++, addr +=3D PAGE=5FSIZE) {
+		ptent =3D *pte;
+
+		if (!pte=5Fpresent(ptent))
+			continue;
+
+		page =3D vm=5Fnormal=5Fpage(vma, addr, ptent);
+		if (!page)
+			continue;
+
+		/*
+		 * If pmd isn't transhuge but the page is THP and
+		 * is owned by only this process, split it and
+		 * deactivate all pages.
+		 */
+		if (PageTransCompound(page)) {
+			if (page=5Fmapcount(page) !=3D 1)
+				goto out;
+			get=5Fpage(page);
+			if (!trylock=5Fpage(page)) {
+				put=5Fpage(page);
+				goto out;
+			}
+			pte=5Funmap=5Funlock(orig=5Fpte, ptl);
+			if (split=5Fhuge=5Fpage(page)) {
+				unlock=5Fpage(page);
+				put=5Fpage(page);
+				pte=5Foffset=5Fmap=5Flock(mm, pmd, addr, &ptl);
+				goto out;
+			}
+			put=5Fpage(page);
+			unlock=5Fpage(page);
+			pte =3D pte=5Foffset=5Fmap=5Flock(mm, pmd, addr, &ptl);
+			pte--;
+			addr -=3D PAGE=5FSIZE;
+			continue;
+		}
+
+		VM=5FBUG=5FON=5FPAGE(PageTransCompound(page), page);
+
+		if (PageSwapCache(page) || PageDirty(page)) {
+			if (!trylock=5Fpage(page))
+				continue;
+			/*
+			 * If page is shared with others, we couldn't clear
+			 * PG=5Fdirty of the page.
+			 */
+			if (page=5Fmapcount(page) !=3D 1) {
+				unlock=5Fpage(page);
+				continue;
+			}
+
+			if (PageSwapCache(page) && !try=5Fto=5Ffree=5Fswap(page)) {
+				unlock=5Fpage(page);
+				continue;
+			}
+
+			ClearPageDirty(page);
+			unlock=5Fpage(page);
+		}
+
+		if (pte=5Fyoung(ptent) || pte=5Fdirty(ptent)) {
+			/*
+			 * Some of architecture(ex, PPC) don't update TLB
+			 * with set=5Fpte=5Fat and tlb=5Fremove=5Ftlb=5Fentry so for
+			 * the portability, remap the pte with old|clean
+			 * after pte clearing.
+			 */
+			ptent =3D ptep=5Fget=5Fand=5Fclear=5Ffull(mm, addr, pte,
+							tlb->fullmm);
+
+			ptent =3D pte=5Fmkold(ptent);
+			ptent =3D pte=5Fmkclean(ptent);
+			set=5Fpte=5Fat(mm, addr, pte, ptent);
+			tlb=5Fremove=5Ftlb=5Fentry(tlb, pte, addr);
+		}
+	}
+out:
+	arch=5Fleave=5Flazy=5Fmmu=5Fmode();
+	pte=5Funmap=5Funlock(orig=5Fpte, ptl);
+	cond=5Fresched();
+	return 0;
+}
+
+static void madvise=5Ffree=5Fpage=5Frange(struct mmu=5Fgather *tlb,
+			     struct vm=5Farea=5Fstruct *vma,
+			     unsigned long addr, unsigned long end)
+{
+	struct mm=5Fwalk free=5Fwalk =3D {
+		.pmd=5Fentry =3D madvise=5Ffree=5Fpte=5Frange,
+		.mm =3D vma->vm=5Fmm,
+		.private =3D tlb,
+	};
+
+	tlb=5Fstart=5Fvma(tlb, vma);
+	walk=5Fpage=5Frange(addr, end, &free=5Fwalk);
+	tlb=5Fend=5Fvma(tlb, vma);
+}
+
+static int madvise=5Ffree=5Fsingle=5Fvma(struct vm=5Farea=5Fstruct *vma,
+			unsigned long start=5Faddr, unsigned long end=5Faddr)
+{
+	unsigned long start, end;
+	struct mm=5Fstruct *mm =3D vma->vm=5Fmm;
+	struct mmu=5Fgather tlb;
+
+	if (vma->vm=5Fflags & (VM=5FLOCKED|VM=5FHUGETLB|VM=5FPFNMAP))
+		return -EINVAL;
+
+	/* MADV=5FFREE works for only anon vma at the moment */
+	if (!vma=5Fis=5Fanonymous(vma))
+		return -EINVAL;
+
+	start =3D max(vma->vm=5Fstart, start=5Faddr);
+	if (start >=3D vma->vm=5Fend)
+		return -EINVAL;
+	end =3D min(vma->vm=5Fend, end=5Faddr);
+	if (end <=3D vma->vm=5Fstart)
+		return -EINVAL;
+
+	lru=5Fadd=5Fdrain();
+	tlb=5Fgather=5Fmmu(&tlb, mm, start, end);
+	update=5Fhiwater=5Frss(mm);
+
+	mmu=5Fnotifier=5Finvalidate=5Frange=5Fstart(mm, start, end);
+	madvise=5Ffree=5Fpage=5Frange(&tlb, vma, start, end);
+	mmu=5Fnotifier=5Finvalidate=5Frange=5Fend(mm, start, end);
+	tlb=5Ffinish=5Fmmu(&tlb, start, end);
+
+	return 0;
+}
+
+static long madvise=5Ffree(struct vm=5Farea=5Fstruct *vma,
+			     struct vm=5Farea=5Fstruct **prev,
+			     unsigned long start, unsigned long end)
+{
+	*prev =3D vma;
+	return madvise=5Ffree=5Fsingle=5Fvma(vma, start, end);
+}
+
 /*
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
@@ -379,6 +540,14 @@ madvise=5Fvma(struct vm=5Farea=5Fstruct *vma, struct v=
m=5Farea=5Fstruct **prev,
 		return madvise=5Fremove(vma, prev, start, end);
 	case MADV=5FWILLNEED:
 		return madvise=5Fwillneed(vma, prev, start, end);
+	case MADV=5FFREE:
+		/*
+		 * XXX: In this implementation, MADV=5FFREE works like
+		 * MADV=5FDONTNEED on swapless system or full swap.
+		 */
+		if (get=5Fnr=5Fswap=5Fpages() > 0)
+			return madvise=5Ffree(vma, prev, start, end);
+		/* passthrough */
 	case MADV=5FDONTNEED:
 		return madvise=5Fdontneed(vma, prev, start, end);
 	default:
@@ -398,6 +567,7 @@ madvise=5Fbehavior=5Fvalid(int behavior)
 	case MADV=5FREMOVE:
 	case MADV=5FWILLNEED:
 	case MADV=5FDONTNEED:
+	case MADV=5FFREE:
 #ifdef CONFIG=5FKSM
 	case MADV=5FMERGEABLE:
 	case MADV=5FUNMERGEABLE:
diff --git a/mm/rmap.c b/mm/rmap.c
index 6f371261dd12..321b633ee559 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1508,6 +1508,13 @@ static int try=5Fto=5Funmap=5Fone(struct page *page,=
 struct vm=5Farea=5Fstruct *vma,
 		 * See handle=5Fpte=5Ffault() ...
 		 */
 		VM=5FBUG=5FON=5FPAGE(!PageSwapCache(page), page);
+
+		if (!PageDirty(page) && (flags & TTU=5FLZFREE)) {
+			/* It's a freeable page by MADV=5FFREE */
+			dec=5Fmm=5Fcounter(mm, MM=5FANONPAGES);
+			goto discard;
+		}
+
 		if (swap=5Fduplicate(entry) < 0) {
 			set=5Fpte=5Fat(mm, address, pte, pteval);
 			ret =3D SWAP=5FFAIL;
@@ -1528,6 +1535,7 @@ static int try=5Fto=5Funmap=5Fone(struct page *page, =
struct vm=5Farea=5Fstruct *vma,
 	} else
 		dec=5Fmm=5Fcounter(mm, mm=5Fcounter=5Ffile(page));
=20
+discard:
 	page=5Fremove=5Frmap(page, PageHuge(page));
 	page=5Fcache=5Frelease(page);
=20
diff --git a/mm/swap=5Fstate.c b/mm/swap=5Fstate.c
index d783872d746c..676ff2991380 100644
--- a/mm/swap=5Fstate.c
+++ b/mm/swap=5Fstate.c
@@ -185,13 +185,12 @@ int add=5Fto=5Fswap(struct page *page, struct list=5F=
head *list)
 	 * deadlock in the swap out path.
 	 */
 	/*
-	 * Add it to the swap cache and mark it dirty
+	 * Add it to the swap cache.
 	 */
 	err =3D add=5Fto=5Fswap=5Fcache(page, entry,
 			=5F=5FGFP=5FHIGH|=5F=5FGFP=5FNOMEMALLOC|=5F=5FGFP=5FNOWARN);
=20
-	if (!err) {	/* Success */
-		SetPageDirty(page);
+	if (!err) {
 		return 1;
 	} else {	/* -ENOMEM radix-tree allocation failure */
 		/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4589cfdbe405..c2f69445190c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -908,6 +908,7 @@ static unsigned long shrink=5Fpage=5Flist(struct list=
=5Fhead *page=5Flist,
 		int may=5Fenter=5Ffs;
 		enum page=5Freferences references =3D PAGEREF=5FRECLAIM=5FCLEAN;
 		bool dirty, writeback;
+		bool lazyfree =3D false;
=20
 		cond=5Fresched();
=20
@@ -1051,6 +1052,7 @@ static unsigned long shrink=5Fpage=5Flist(struct list=
=5Fhead *page=5Flist,
 				goto keep=5Flocked;
 			if (!add=5Fto=5Fswap(page, page=5Flist))
 				goto activate=5Flocked;
+			lazyfree =3D true;
 			may=5Fenter=5Ffs =3D 1;
=20
 			/* Adding to swap updated mapping */
@@ -1062,8 +1064,9 @@ static unsigned long shrink=5Fpage=5Flist(struct list=
=5Fhead *page=5Flist,
 		 * processes. Try to unmap it here.
 		 */
 		if (page=5Fmapped(page) && mapping) {
-			switch (try=5Fto=5Funmap(page,
-					ttu=5Fflags|TTU=5FBATCH=5FFLUSH)) {
+			switch (try=5Fto=5Funmap(page, lazyfree ?
+				(ttu=5Fflags | TTU=5FBATCH=5FFLUSH | TTU=5FLZFREE) :
+				(ttu=5Fflags | TTU=5FBATCH=5FFLUSH))) {
 			case SWAP=5FFAIL:
 				goto activate=5Flocked;
 			case SWAP=5FAGAIN:
@@ -1188,6 +1191,9 @@ static unsigned long shrink=5Fpage=5Flist(struct list=
=5Fhead *page=5Flist,
 		 */
 		=5F=5FClearPageLocked(page);
 free=5Fit:
+		if (lazyfree && !PageDirty(page))
+			count=5Fvm=5Fevent(PGLAZYFREED);
+
 		nr=5Freclaimed++;
=20
 		/*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d13cd8eebf70..38929dc79c3d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -781,6 +781,7 @@ const char * const vmstat=5Ftext[] =3D {
=20
 	"pgfault",
 	"pgmajfault",
+	"pglazyfreed",
=20
 	TEXTS=5FFOR=5FZONES("pgrefill")
 	TEXTS=5FFOR=5FZONES("pgsteal=5Fkswapd")
--=20
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
