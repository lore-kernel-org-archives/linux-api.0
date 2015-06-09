From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHSET v3 0/4] pagemap: make useable for non-privilege users
Date: Tue, 09 Jun 2015 23:00:13 +0300
Message-ID: <20150609195333.21971.58194.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patchset makes pagemap useable again in the safe way. It adds bit
'map-exlusive' which is set if page is mapped only here and restores
access for non-privileged users but hides pfn from them.

Last patch removes page-shift bits and completes migration to the new
pagemap format: flags soft-dirty and mmap-exlusive are available only
in the new format.

v3: check permissions in ->open

---

Konstantin Khlebnikov (4):
      pagemap: check permissions and capabilities at open time
      pagemap: add mmap-exclusive bit for marking pages mapped only here
      pagemap: hide physical addresses from non-privileged users
      pagemap: switch to the new format and do some cleanup


 Documentation/vm/pagemap.txt |    3 -
 fs/proc/task_mmu.c           |  219 +++++++++++++++++++-----------------------
 tools/vm/page-types.c        |   35 +++----
 3 files changed, 118 insertions(+), 139 deletions(-)

--
Signature
