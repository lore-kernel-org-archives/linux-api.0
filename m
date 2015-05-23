From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 22/23] userfaultfd: avoid mmap_sem read recursion in
 mcopy_atomic
Date: Sat, 23 May 2015 03:04:15 +0200
Message-ID: <20150523010415.GC4251@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-23-git-send-email-aarcange@redhat.com>
 <20150522131822.74f374dd5a75a0285577c714@linux-foundation.org>
 <20150522204809.GB4251@redhat.com>
 <20150522141830.f969b285ad072a23bb28f196@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150522141830.f969b285ad072a23bb28f196@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, Fengguang Wu <fengguan>
List-Id: linux-api@vger.kernel.org

On Fri, May 22, 2015 at 02:18:30PM -0700, Andrew Morton wrote:
> 
> There's a more serious failure with i386 allmodconfig:
> 
> fs/userfaultfd.c:145:2: note: in expansion of macro 'BUILD_BUG_ON'
>   BUILD_BUG_ON(sizeof(struct uffd_msg) != 32);
> 
> I'm surprised the feature is even reachable on i386 builds?

Unless we risk to run out of vma->vm_flags there's no particular
reason not to enable it on 32bit (even if we run out, making vm_flags
an unsigned long long is a few liner patch). Certainly it's less
useful on 32bit as there's a 3G limit but the max vmas per process are
still a small fraction of that. Especially if used for the volatile
pages on demand notification of page reclaim, it could end up useful
on arm32 (S6 is 64bit I think and latest snapdragon is too, so perhaps
it's too late anyway, but again it's not big deal).

Removing the BUILD_BUG_ON I think is not ok here because while I'm ok
to support 32bit archs, I don't want translation, the 64bit kernel
should talk with the 32bit app directly without a layer in between.

I tried to avoid using packet as without packed I could not get the
alignment wrong (and future union also couldn't get it wrong), and I
could avoid those reserved1/2/3, but it's more robust to use it in
combination with the BUILD_BUG_ON to detect right away problems like
this with 32bit builds that aligns things differently.

I'm actually surprised the buildbot that sends me email about all
archs didn't actually send me anything about it for 32bit x86?
Perhaps I'm overlooking something or x86 32bit (or any other 32bit
arch for that matter) isn't being checked?  This is actually a fairly
recent change, perhaps the buildbot was shutdown recently? That
buildbot was very useful to detect for problems like this.

===
>From 2f0a48670dc515932dec8b983871ec35caeba553 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Sat, 23 May 2015 02:26:32 +0200
Subject: [PATCH] userfaultfd: update the uffd_msg structure to be the same on
 32/64bit

Avoiding to using packed allowed the code to be nicer and it avoided
the reserved1/2/3 but the structure must be the same for 32bit and
64bit archs so x86 applications built with the 32bit ABI can run on
the 64bit kernel without requiring translation of the data read
through the read syscall.

$ gcc -m64 p.c && ./a.out
32
0
16
8
8
16
24
$ gcc -m32 p.c && ./a.out
32
0
16
8
8
16
24

int main()
{
	printf("%lu\n", sizeof(struct uffd_msg));
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->event);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.pagefault.address);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.pagefault.flags);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.reserved.reserved1);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.reserved.reserved2);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.reserved.reserved3);
}

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/uapi/linux/userfaultfd.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index c8a543f..00d28e2 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -59,9 +59,13 @@
 struct uffd_msg {
 	__u8	event;
 
+	__u8	reserved1;
+	__u16	reserved2;
+	__u32	reserved3;
+
 	union {
 		struct {
-			__u32	flags;
+			__u64	flags;
 			__u64	address;
 		} pagefault;
 
@@ -72,7 +76,7 @@ struct uffd_msg {
 			__u64	reserved3;
 		} reserved;
 	} arg;
-};
+} __attribute__((packed));
 
 /*
  * Start at 0x12 and not at 0 to be more strict against bugs.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
