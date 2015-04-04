From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 3 Apr 2015 20:42:09 -0700
Message-ID: <20150403204209.75405f37.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150330073604.GB22229@infradead.org>
	<20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeremy Allison <jra@samba.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, 30 Mar 2015 13:26:25 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> d) fincore() is more expensive

Actually, I kinda take that back.  fincore() will be faster than
preadv2() in the case of a pagecache miss, and slower in the case of a
pagecache hit.

The breakpoint appears to be a hit rate of 30% - if fewer than 30% of
queries find the page in pagecache, fincore() will be faster than
preadv2().

This is because for a pagecache miss, fincore() will be about twice as
fast as preadv2().  For a pagecache hit, fincore()+pread() is 55%
slower than preadv2().  If there are lots of misses, fincore() is
faster overall.




Minimal fincore() implementation is below.  It doesn't implement the
page_map!=NULL mode at all and will be slow for large areas - it needs
to be taught about radix_tree_for_each_*().  But it's good enough for
testing.  

On a slow machine, in nanoseconds:

null syscall:		528
fincore (miss):		674
fincore (hit):		729
single byte pread:	1026
single byte preadv:	1134

pread() is a bit faster than preadv() and samba uses pread(), so the
implementations are:

	if (fincore(fd, NULL, offset, len) == len)
		pread();
	else
		punt();

	if (preadv2(fd, ..., offset, len) == len)
		...
	else
		punt();

fincore+pread, pagecache-hit:	1755ns
fincore+pread, pagecache-miss:	674ns
preadv():			1134ns (preadv2() will be a little faster for misses)



Now, a pagecache hit rate of 30% sounds high so one would think that
fincore+pread is clearly ahead.  But the pagecache hit rate in this
code will actually be quite high, because of readahead.

For a large linear read of a file which is perfectly laid out on disk
and is fully *uncached*, the hit rates will be as good as 99.8%,
because readahead is bringing in data in 2MB blobs.

In practice I expect that fincore()+pread() will be slower for linear
reads of medium to large files and faster for small files and seeky
accesses.

How much does all this matter?  Not much.  On a fast machine a
single-byte pread() takes 240ns.  So if your server thread is handling
25000 requests/sec, we're only talking 0.6% overhead.

Note that we can trivially monitor the hit rate with either preadv2()
or fincore()+pread(): just count how many times all the data is there
versus how many times it isn't.



Also, note that we can use *both* fincore() and preadv2() to detect the
problematic page-just-disappeared race:

	if (fincore(fd, NULL, offset, len) == len) {
		if (preadv2(fd, offset, len) != len)
			printf("race just happened");

It would be great if someone could apply the below, modify the
preadv2() callsite as above and determine under what conditions (if
any) the page-stealing race occurs.



 arch/x86/syscalls/syscall_64.tbl |    1 
 include/linux/syscalls.h         |    2 
 mm/Makefile                      |    2 
 mm/fincore.c                     |   65 +++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 1 deletion(-)

diff -puN arch/x86/syscalls/syscall_64.tbl~fincore arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~fincore
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -331,6 +331,7 @@
 322	64	execveat		stub_execveat
 323	64	preadv2			sys_preadv2
 324	64	pwritev2		sys_pwritev2
+325	common	fincore			sys_fincore
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~fincore include/linux/syscalls.h
--- a/include/linux/syscalls.h~fincore
+++ a/include/linux/syscalls.h
@@ -880,6 +880,8 @@ asmlinkage long sys_process_vm_writev(pi
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+asmlinkage long sys_fincore(int fd, unsigned char __user *page_map,
+			    loff_t offset, size_t len);
 asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 			    const char __user *uargs);
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
diff -puN mm/Makefile~fincore mm/Makefile
--- a/mm/Makefile~fincore
+++ a/mm/Makefile
@@ -19,7 +19,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o vmacache.o \
+			   compaction.o vmacache.o fincore.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o $(mmu-y)
 
diff -puN /dev/null mm/fincore.c
--- /dev/null
+++ a/mm/fincore.c
@@ -0,0 +1,65 @@
+#include <linux/syscalls.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/hugetlb.h>
+
+SYSCALL_DEFINE4(fincore, int, fd, unsigned char __user *, page_map,
+		loff_t, offset, size_t, len)
+{
+	struct fd f;
+	struct address_space *mapping;
+	loff_t cur_off;
+	loff_t end;
+	pgoff_t pgoff;
+	long ret = 0;
+
+	if (offset < 0 || (ssize_t)len <= 0)
+		return -EINVAL;
+
+	f = fdget(fd);
+
+	if (!f.file)
+		return -EBADF;
+
+	if (is_file_hugepages(f.file)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!S_ISREG(file_inode(f.file)->i_mode)) {
+		ret = -EBADF;
+		goto out;
+	}
+
+	end = min_t(loff_t, offset + len, i_size_read(file_inode(f.file)));
+	pgoff = offset >> PAGE_CACHE_SHIFT;
+	mapping = f.file->f_mapping;
+
+	/*
+	 * We probably need to do somethnig here to reduce the chance of the
+	 * pages being reclaimed between fincore() and read().  eg,
+	 * SetPageReferenced(page) or mark_page_accessed(page) or
+	 * activate_page(page).
+	 */
+	for (cur_off = offset; cur_off < end ; ) {
+		struct page *page;
+		loff_t end_of_coverage;
+
+		page = find_get_page(mapping, pgoff);
+		if (!page || !PageUptodate(page))
+			break;
+		page_cache_release(page);
+
+		pgoff++;
+		end_of_coverage = min_t(loff_t, pgoff << PAGE_CACHE_SHIFT, end);
+		ret += end_of_coverage - cur_off;
+		cur_off = (cur_off + PAGE_CACHE_SIZE) & PAGE_CACHE_MASK;
+	}
+
+out:
+	fdput(f);
+	return ret;
+}
_

