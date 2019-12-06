From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: [PATCH] move_pages.2: not return ENOENT if the page are already on the target nodes
Date: Fri,  6 Dec 2019 09:34:50 +0800
Message-ID: <1575596090-115377-1-git-send-email-yang.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com, cl@linux.com, jhubbard@nvidia.com, mhocko@suse.com, cai@lca.pw, akpm@linux-foundation.org
Cc: yang.shi@linux.alibaba.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Since commit e78bbfa82624 ("mm: stop returning -ENOENT
from sys_move_pages() if nothing got migrated"), move_pages doesn't
return -ENOENT anymore if the pages are already on the target nodes, but
this change is never reflected in manpage.

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
 man2/move_pages.2 | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/man2/move_pages.2 b/man2/move_pages.2
index 2d96468..2a2f3cd 100644
--- a/man2/move_pages.2
+++ b/man2/move_pages.2
@@ -192,9 +192,8 @@ was specified or an attempt was made to migrate pages of a kernel thread.
 One of the target nodes is not online.
 .TP
 .B ENOENT
-No pages were found that require moving.
-All pages are either already
-on the target node, not present, had an invalid address or could not be
+No pages were found.
+All pages are either not present, had an invalid address or could not be
 moved because they were mapped by multiple processes.
 .TP
 .B EPERM
-- 
1.8.3.1
