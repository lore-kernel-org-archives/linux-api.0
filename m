From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH -next 0/6] rhashtable: guarantee first allocation
Date: Thu, 24 May 2018 14:11:29 -0700
Message-ID: <20180524211135.27760-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
List-Id: linux-api@vger.kernel.org

Hi,

This series is the result of the discussion with Linus around ipc
subsystem initialization and how it behaves with error return when
calling rhashtable_init()[1]. Instead of caring about the error
or calling the infamous BUG_ON, Linus suggested we guarantee the
rhashtable allocation.

First two patches modify rhashtable_init() to just return 0, future
patches I guess can update more callers.

patch 3 is a nit I found while reading the code and just makes use
kvmalloc_array().

patch 4+5 remove some ipc hacks we no longer need.

patch 6 updates the rhashtable test module. Trivial.

Please consider for v4.18.

Thanks!

[0] https://lkml.org/lkml/2018/5/23/758

Davidlohr Bueso (6):
  lib/rhashtable: convert param sanitations to WARN_ON
  lib/rhashtable: guarantee initial hashtable allocation
  lib/bucket_locks: use kvmalloc_array()
  ipc: get rid of ids->tables_initialized hack
  ipc: simplify ipc initialization
  lib/test_rhashtable: rhashtable_init() can no longer fail

 include/linux/ipc_namespace.h |  1 -
 ipc/msg.c                     |  9 ++++----
 ipc/namespace.c               | 20 ++++--------------
 ipc/sem.c                     | 10 ++++-----
 ipc/shm.c                     |  9 ++++----
 ipc/util.c                    | 41 ++++++++++++------------------------
 ipc/util.h                    | 18 ++++++++--------
 lib/bucket_locks.c            |  2 +-
 lib/rhashtable.c              | 49 ++++++++++++++++++++++++++++++++++---------
 lib/test_rhashtable.c         |  6 +-----
 10 files changed, 79 insertions(+), 86 deletions(-)

-- 
2.13.6
