From: John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH] move_pages.2: remove ENOENT from the list of possible return values
Date: Wed, 18 Dec 2019 21:13:47 -0800
Message-ID: <20191219051347.1278026-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christopher Lameter <cl@linux.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Brice Goglin <Brice.Goglin@inria.fr>, Yang Shi <yang.shi@linux.alibaba.com>
List-Id: linux-api@vger.kernel.org

Linux kernel commit e78bbfa82624 ("mm: stop returning -ENOENT from
sys_move_pages() if nothing got migrated") had the effect of *never*
returning -ENOENT, in any situation. So we need to update the man page
to reflect that ENOENT is not a possible return value.

Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Hi,

This fix for the man page was ACK'd by Michal, here:

https://lore.kernel.org/r/20191218101711.GB21485@dhcp22.suse.cz

thanks,
John Hubbard
NVIDIA

 man2/move_pages.2 | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/man2/move_pages.2 b/man2/move_pages.2
index 2d96468fa..1bf1053f2 100644
--- a/man2/move_pages.2
+++ b/man2/move_pages.2
@@ -191,12 +191,6 @@ was specified or an attempt was made to migrate pages =
of a kernel thread.
 .B ENODEV
 One of the target nodes is not online.
 .TP
-.B ENOENT
-No pages were found that require moving.
-All pages are either already
-on the target node, not present, had an invalid address or could not be
-moved because they were mapped by multiple processes.
-.TP
 .B EPERM
 The caller specified
 .B MPOL_MF_MOVE_ALL
--=20
2.24.1
