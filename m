From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: [PATCH RFC v2 0/4] some fixes and clean up for mempolicy
Date: Fri, 27 Oct 2017 18:14:21 +0800
Message-ID: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, salls@cs.ucsb.edu
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tanxiaojun@huawei.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patchset is triggered by Xiojun's report of ltp test fail[1],
and I have sent a patch to resolve it by check nodes_empty of new_nodes[2].

The new version is to follow Vlastimil's suggestion, which fix by checking
the new_nodes value in function get_nodes. And I just split them to small
patches for easy to review and discussion. For more detail, please look
into each patches.

Change logs of v2:
 * fix get_nodes's mask miscalculation
 * remove redundant check in get_nodes
 * fix the check of nodemask from user - per Vlastimil

Any comment and complain is welome.

Thanks
Yisheng Xie

[1] https://patchwork.kernel.org/patch/10012005/
[2] https://patchwork.kernel.org/patch/10013329/

Yisheng Xie (4):
  mm/mempolicy: Fix get_nodes() mask miscalculation
  mm/mempolicy: remove redundant check in get_nodes
  mm/mempolicy: fix the check of nodemask from user
  mm/mempolicy: add nodes_empty check in SYSC_migrate_pages

 mm/mempolicy.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
1.7.12.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
