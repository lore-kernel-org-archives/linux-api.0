From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 0/2] openat2: minor uapi cleanups
Date: Thu, 19 Dec 2019 21:55:31 +1100
Message-ID: <20191219105533.12508-4-cyphar@cyphar.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219105533.12508-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Florian Weimer <fweimer@redhat.com>, David Laight <david.laight@aculab.com>, Christian Brauner <christian.brauner@ubuntu.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

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
  uapi: split openat2(2) definitions from fcntl.h
  openat2: drop open_how->__padding field

 MAINTAINERS                                   |  1 +
 fs/open.c                                     |  2 -
 include/uapi/linux/fcntl.h                    | 37 +----------------
 include/uapi/linux/openat2.h                  | 40 +++++++++++++++++++
 tools/testing/selftests/openat2/helpers.h     |  3 +-
 .../testing/selftests/openat2/openat2_test.c  | 24 ++++-------
 6 files changed, 51 insertions(+), 56 deletions(-)
 create mode 100644 include/uapi/linux/openat2.h


base-commit: 912dfe068c43fa13c587b8d30e73d335c5ba7d44
-- 
2.24.0
