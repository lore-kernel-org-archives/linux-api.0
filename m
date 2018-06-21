From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH -next v3 0/4] rhashtable: guarantee initial allocation
Date: Thu, 21 Jun 2018 14:28:21 -0700
Message-ID: <20180621212825.3059-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net
List-Id: linux-api@vger.kernel.org

Changes from v2:
lkml.kernel.org/r/20180601160125.30031-1-dave@stgolabs.net

- Dropped original patch 1 (which removed the EINVAL returns
  for WARN_ON) as well as patch 5.
- Added a new patch 1, which simplifies the alloc after mhocko's
  changes (originally suggested by Linus).
- Use max_t instead of min_t for the resize.

Changes from v1
lkml.kernel.org/r/20180524211135.27760-1-dave@stgolabs.net

- patch 2 is reworked a bit based on the commments from Herbert Xu.
  o upon failure, retry immediately with GFP_NOFAIL (simpler)
  o the caller now passes the needed semantics, not bucket_table_alloc().
  o we consider min_size when resizing, not just HASH_MIN_SIZE.

- removed patch 3; not need after Michal's patch.

Hi,

This series is the result of the discussion with Linus around ipc
subsystem initialization and how it behaves with error return when
calling rhashtable_init()[1]. Instead of caring about the error
or calling the infamous BUG_ON, Linus suggested we guarantee the
rhashtable allocation.

First two patches deal with the rhashtable_init() changes, while the
patches 3+4 remove some ipc hacks we no longer need.

Please consider for v4.19.

[0] https://lkml.org/lkml/2018/5/23/758

Thanks!

Davidlohr Bueso (4):
  lib/rhashtable: simplify bucket_table_alloc()
  lib/rhashtable: guarantee initial hashtable allocation
  ipc: get rid of ids->tables_initialized hack
  ipc: simplify ipc initialization

 include/linux/ipc_namespace.h |  1 -
 ipc/msg.c                     |  9 ++++-----
 ipc/namespace.c               | 20 ++++----------------
 ipc/sem.c                     | 10 ++++------
 ipc/shm.c                     |  9 ++++-----
 ipc/util.c                    | 41 +++++++++++++----------------------------
 ipc/util.h                    | 18 +++++++++---------
 lib/rhashtable.c              | 19 ++++++++++++-------
 8 files changed, 50 insertions(+), 77 deletions(-)

-- 
2.16.4
