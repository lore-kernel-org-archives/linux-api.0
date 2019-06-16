From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH NOTFORMERGE 0/5] Extend remote madvise API to KSM hints
Date: Sun, 16 Jun 2019 10:58:30 +0200
Message-ID: <20190616085835.953-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi, Minchan.

This is a set of commits based on our discussion on your submission [1].

First 2 implement minor suggestions just for you to not forget to take
them into account.

uio.h inclusion was needed for me to be able to compile your series
successfully. Also please note I had to enable "Transparent Hugepage
Support" as well as "Enable idle page tracking" options, otherwise the
build failed. I guess this can be addressed by you better since the
errors are introduced with MADV_COLD introduction.

Last 2 commits are the actual KSM hints enablement. The first one
implements additional check for the case where the mmap_sem is taken for
write, and the second one just allows KSM hints to be used by the remote
interface.

I'm not Cc'ing else anyone except two mailing lists to not distract
people unnecessarily. If you are fine with this addition, please use it
for your next iteration of process_madvise(), and then you'll Cc all the
people needed.

Thanks.

[1] https://lore.kernel.org/lkml/20190531064313.193437-1-minchan@kernel.org/

Oleksandr Natalenko (5):
  mm: rename madvise_core to madvise_common
  mm: revert madvise_inject_error line split
  mm: include uio.h to madvise.c
  mm/madvise: employ mmget_still_valid for write lock
  mm/madvise: allow KSM hints for remote API

 mm/madvise.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
2.22.0
