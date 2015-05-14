From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 12/23] userfaultfd: Rename uffd_api.bits into .features fixup
Date: Thu, 14 May 2015 19:31:09 +0200
Message-ID: <1431624680-20153-13-git-send-email-aarcange@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
List-Id: linux-api@vger.kernel.org

Update comment.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/uapi/linux/userfaultfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 5e1c2f7..03f21cb 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -10,7 +10,7 @@
 #define _LINUX_USERFAULTFD_H
 
 #define UFFD_API ((__u64)0xAA)
-/* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
+/* FIXME: add "|UFFD_FEATURE_WP" to UFFD_API_FEATURES after implementing it */
 #define UFFD_API_FEATURES (UFFD_FEATURE_WRITE_BIT)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
