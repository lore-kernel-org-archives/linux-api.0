From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH] selftests/userfaultfd: Fix compiler warnings on 32-bit
Date: Sun,  6 Sep 2015 12:10:16 +0200
Message-ID: <1441534216-24558-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 32-bit:

    userfaultfd.c: In function 'locking_thread':
    userfaultfd.c:152: warning: left shift count >= width of type
    userfaultfd.c: In function 'uffd_poll_thread':
    userfaultfd.c:295: warning: cast to pointer from integer of different size
    userfaultfd.c: In function 'uffd_read_thread':
    userfaultfd.c:332: warning: cast to pointer from integer of different size

Fix the shift warning by splitting the shift in two parts, and the
integer/pointer warnigns by adding intermediate casts to "unsigned
long".

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
 tools/testing/selftests/vm/userfaultfd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 0c0b8395335261b9..b619f672131ea787 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -147,7 +147,8 @@ static void *locking_thread(void *arg)
 			if (sizeof(page_nr) > sizeof(rand_nr)) {
 				if (random_r(&rand, &rand_nr))
 					fprintf(stderr, "random_r 2 error\n"), exit(1);
-				page_nr |= ((unsigned long) rand_nr) << 32;
+				page_nr |= (((unsigned long) rand_nr) << 16) <<
+					   16;
 			}
 		} else
 			page_nr += 1;
@@ -290,7 +291,8 @@ static void *uffd_poll_thread(void *arg)
 				msg.event), exit(1);
 		if (msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE)
 			fprintf(stderr, "unexpected write fault\n"), exit(1);
-		offset = (char *)msg.arg.pagefault.address - area_dst;
+		offset = (char *)(unsigned long)msg.arg.pagefault.address -
+			 area_dst;
 		offset &= ~(page_size-1);
 		if (copy_page(offset))
 			userfaults++;
@@ -327,7 +329,8 @@ static void *uffd_read_thread(void *arg)
 		if (bounces & BOUNCE_VERIFY &&
 		    msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WRITE)
 			fprintf(stderr, "unexpected write fault\n"), exit(1);
-		offset = (char *)msg.arg.pagefault.address - area_dst;
+		offset = (char *)(unsigned long)msg.arg.pagefault.address -
+			 area_dst;
 		offset &= ~(page_size-1);
 		if (copy_page(offset))
 			(*this_cpu_userfaults)++;
-- 
1.9.1
