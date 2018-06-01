From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH -next v2 0/5] rhashtable: guarantee first allocation
Date: Fri,  1 Jun 2018 09:01:20 -0700
Message-ID: <20180601160125.30031-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
List-Id: linux-api@vger.kernel.org

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

First two patches modify rhashtable_init() to just return 0, future
patches will update more callers, particularly those that use BUG_ON.

patch 3+4 remove some ipc hacks we no longer need.

patch 5 updates the rhashtable test module. Trivial.

Please consider for v4.18.

Thanks!

[0] https://lkml.org/lkml/2018/5/23/758

Davidlohr Bueso (5):
  lib/rhashtable: convert param sanitations to WARN_ON
  lib/rhashtable: guarantee initial hashtable allocation
  ipc: get rid of ids->tables_initialized hack
  ipc: simplify ipc initialization
  lib/test_rhashtable: rhashtable_init() can no longer fail

 include/linux/ipc_namespace.h |  1 -
 ipc/msg.c                     |  9 ++++-----
 ipc/namespace.c               | 20 ++++----------------
 ipc/sem.c                     | 10 ++++------
 ipc/shm.c                     |  9 ++++-----
 ipc/util.c                    | 41 +++++++++++++----------------------------
 ipc/util.h                    | 18 +++++++++---------
 lib/rhashtable.c              | 22 ++++++++++++++--------
 lib/test_rhashtable.c         |  6 +-----
 9 files changed, 53 insertions(+), 83 deletions(-)

-- 
2.16.3
