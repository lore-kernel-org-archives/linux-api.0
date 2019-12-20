From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2 0/2] openat2: minor uapi cleanups
Date: Sat, 21 Dec 2019 01:03:26 +1100
Message-ID: <20191220140328.20907-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Florian Weimer <fweimer@redhat.com>, David Laight <david.laight@aculab.com>, Christian Brauner <christian.brauner@ubuntu.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Patch changelog:
  v2:
   * Add include <linux/types.h> to openat2.h. [Florian Weimer]
   * Move OPEN_HOW_SIZE_* constants out of UAPI. [Florian Weimer]
   * Switch from __aligned_u64 to __u64 since it isn't necessary.
     [David Laight]
  v1: <https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar@cyphar.com/>

While openat2(2) is still not yet in Linus's tree, we can take this
opportunity to iron out some small warts that weren't noticed earlier:

  * A fix was suggested by Florian Weimer, to separate the openat2
    definitions so glibc can use the header directly. I've put the
    maintainership under VFS but let me know if you'd prefer it belong
    ot the fcntl folks.

  * Having heterogenous field sizes in an extensible struct results in
    "padding hole" problems when adding new fields (in addition the
    correct error to use for non-zero padding isn't entirely clear ).
    The simplest solution is to just copy clone(3)'s model -- always use
    u64s. It will waste a little more space in the struct, but it
    removes a possible future headache.

Aleksa Sarai (2):
  openat2: drop open_how->__padding field
  uapi: split openat2(2) definitions from fcntl.h

 MAINTAINERS                                   |  1 +
 fs/open.c                                     |  2 -
 include/linux/fcntl.h                         |  4 ++
 include/uapi/linux/fcntl.h                    | 37 +-----------------
 include/uapi/linux/openat2.h                  | 39 +++++++++++++++++++
 tools/testing/selftests/openat2/helpers.h     |  7 ++--
 .../testing/selftests/openat2/openat2_test.c  | 24 ++++--------
 7 files changed, 56 insertions(+), 58 deletions(-)
 create mode 100644 include/uapi/linux/openat2.h


base-commit: 912dfe068c43fa13c587b8d30e73d335c5ba7d44
-- 
2.24.0
