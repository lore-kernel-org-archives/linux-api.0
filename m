From: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 0/2] core dump: re-purpose VM_ALWAYSDUMP to
 user controlled VM_DONTDUMP
Date: Fri, 27 Apr 2012 14:43:15 -0400
Message-ID: <20120427184311.GB13762@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
	<CAHO5Pa0cyvD-zUh-RRyOwvu2FGQYOMn_thFQt3_64BDi-wB=GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0cyvD-zUh-RRyOwvu2FGQYOMn_thFQt3_64BDi-wB=GQ@mail.gmail.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: mcgrathr@google.com, Linux API <linux-api@vger.kernel.org>, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, avi@redhat.com, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 24, 2012 at 10:42:16AM +1200, Michael Kerrisk wrote:
> Jason,
> 
> On Thu, Mar 8, 2012 at 6:00 AM, Jason Baron <jbaron@redhat.com> wrote:
> > Hi,
> >
> > The motivation for this change was that I was looking at a way for a qemu-kvm
> > process, to exclude the guest memory from its core dump, which can be quite
> > large. There are already a number of filter flags in
> > /proc/<pid>/coredump_filter, however, these allow one to specify 'types' of
> > kernel memory, not specific address ranges (which is needed in this case).
> >
> > Since there are no more vma flags available, the first patch eliminates the
> > need for the 'VM_ALWAYSDUMP' flag. The flag is used internally by the kernel to
> > mark vdso and vsyscall pages. However, it is simple enough to check if a vma
> > covers a vdso or vsyscall page without the need for this flag.
> >
> > The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new
> > 'VM_DONTDUMP' flag, which can be set by userspace using new madvise flags:
> > 'MADV_DONTDUMP', and unset via 'MADV_DUMP'. The core dump filters continue to
> > work the same as before unless 'MADV_DONTDUMP' is set on the region.
> >
> > The qemu code which implements this features is at:
> > http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch
> >
> > In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.
> >
> > I also believe that the 'MADV_DONTDUMP' flag might be useful for security
> > sensitive apps, which might want to select which areas are dumped.
> 
> Since we have
> MADV_DODUMP
> MADV_DONTDUMP
> MADV_NODUMP
> heading for userspace in 3.4, would you be willing to write patches
> for the madvise(2) man page to describe these flags?
> 
> See http://www.kernel.org/doc/man-pages/download.html for details on
> accessing man-pages Git.
> 
> Cheers,
> 
> Michael
> 
> PS Please also CC linux-api@ when making API/ABI changes.
> 

Ok, here's a stab at manpage patch, let me know if I should send it as a
separate patch. Thanks.

-Jason


diff --git a/man2/madvise.2 b/man2/madvise.2
index 36f988a..472c23a 100644
--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -247,6 +247,22 @@ Ensures that memory in the address range specified by
 and
 .IR length
 will not be collapsed into huge pages.
+.TP
+.BR MADV_DONTDUMP " (since Linux 3.4)"
+Explicitly exclude from a core dump those pages in the range specified by
+.I addr
+and
+.IR length .
+Applications may have large areas of memory which are known not to be useful in
+diagnosing a core dump. This specification takes precedence over the bit mask that
+is set via the
+.I /proc/PID/coredump_filter
+file (see
+.BR core (5)).
+.TP
+.BR MADV_DODUMP " (since Linux 3.4)"
+Undo the effect of an earlier
+.BR MADV_DONTDUMP.
 .SH "RETURN VALUE"
 On success
 .BR madvise ()
@@ -356,4 +372,5 @@ from the system call, as it should).
 .BR mmap (2),
 .BR mprotect (2),
 .BR msync (2),
-.BR munmap (2)
+.BR munmap (2),
+.BR core (5)
