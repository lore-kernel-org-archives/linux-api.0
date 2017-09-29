From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 0/1] mm: only dispaly online cpus of the numa node
Date: Fri, 29 Sep 2017 17:53:24 +0800
Message-ID: <1506678805-15392-1-git-send-email-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm <linux-mm@kvack.org>
Cc: Tianhong Ding <dingtianhong@huawei.com>, Hanjun Guo <guohanjun@huawei.com>, Libin <huawei.libin@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Zhen Lei <thunder.leizhen@huawei.com>
List-Id: linux-api@vger.kernel.org

v1 -> v2:
Replace local variable "cpumask_var_t mask" with dynamic memory alloc: alloc_cpumask_var,
to avoid possible stack overflow.

Zhen Lei (1):
  mm: only dispaly online cpus of the numa node

 drivers/base/node.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.5.0


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
