From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Date: Wed, 27 Jun 2018 20:45:00 -0500
Message-ID: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zhibin Li <zhibli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

mmap(2) says the syscall will return EINVAL if "flags contained neither
MAP_PRIVATE or MAP_SHARED, or contained both of these values."
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
However, commit 
1c972597 ("mm: introduce MAP_SHARED_VALIDATE ...")
introduced a new flag, MAP_SHARED_VALIDATE, with a value of 0x3,
which is indistinguishable from (MAP_SHARED|MAP_PRIVATE).

Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
passes without error, which is a regression.

I'm not sure of the best way out of this, other than to change the
API description to say that MAP_SHARED_VALIDATE is only allowed in
combination with "new" flags, and reject it if it's used only with
flags contained in LEGACY_MAP_MASK.

This will require the mmap(2) manpage to enumerate which flags don't
require validation, as well, so the user knows when to use the
VALIDATE flag.

I'm not super happy with this, because it also means that code
which explicitly asks for mmap(MAP_SHARED|MAP_PRIVATE|MAP_SYNC) will
also pass, but I'm not sure there's anything to do about that.

Reported-by: Zhibin Li <zhibli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

diff --git a/mm/mmap.c b/mm/mmap.c
index d1eb87ef4b1a..b1dc84466365 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1440,6 +1440,16 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
 			return -EOVERFLOW;
+		/*
+		 * MAP_SHARED_VALIDATE is indistinguishable from
+		 * (MAP_SHARED|MAP_PRIVATE) which must return -EINVAL.
+		 * If the flags contain MAP_SHARED_VALIDATE and none of the
+		 * non-legacy flags, the user gets EINVAL.
+		 */
+		if (((flags & MAP_SHARED_VALIDATE) == MAP_SHARED_VALIDATE) &&
+		    !(flags & ~LEGACY_MAP_MASK)) {
+			return -EINVAL;
+		}
 
 		flags_mask = LEGACY_MAP_MASK | file->f_op->mmap_supported_flags;
