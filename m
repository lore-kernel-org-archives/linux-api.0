From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH] pagemap: update documentation
Date: Thu, 16 Jul 2015 21:47:42 +0300
Message-ID: <20150716184742.8858.14639.stgit@buzz>
References: <20150714152516.29844.69929.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714152516.29844.69929.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Notes about recent changes.

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 Documentation/vm/pagemap.txt |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
index 3cfbbb333ea1..aab39aa7dd8f 100644
--- a/Documentation/vm/pagemap.txt
+++ b/Documentation/vm/pagemap.txt
@@ -16,12 +16,17 @@ There are three components to pagemap:
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
     * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
-    * Bit  56    page exlusively mapped
+    * Bit  56    page exclusively mapped (since 4.2)
     * Bits 57-60 zero
-    * Bit  61    page is file-page or shared-anon
+    * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
     * Bit  63    page present
 
+   Since Linux 4.0 only users with the CAP_SYS_ADMIN capability can get PFNs:
+   for unprivileged users from 4.0 till 4.2 open fails with -EPERM, starting
+   from from 4.2 PFN field is zeroed if user has no CAP_SYS_ADMIN capability.
+   Reason: information about PFNs helps in exploiting Rowhammer vulnerability.
+
    If the page is not present but in swap, then the PFN contains an
    encoding of the swap file number and the page's offset into the
    swap. Unmapped pages return a null PFN. This allows determining
@@ -160,3 +165,8 @@ Other notes:
 Reading from any of the files will return -EINVAL if you are not starting
 the read on an 8-byte boundary (e.g., if you sought an odd number of bytes
 into the file), or if the size of the read is not a multiple of 8 bytes.
+
+Before Linux 3.11 pagemap bits 55-60 were used for "page-shift" (which is
+always 12 at most architectures). Since Linux 3.11 their meaning changes
+after first clear of soft-dirty bits. Since Linux 4.2 they are used for
+flags unconditionally.
