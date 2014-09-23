From: Peter Feiner <pfeiner@google.com>
Subject: [PATCH v2 1/3] tools: add .gitignore entries for selftests
Date: Tue, 23 Sep 2014 12:55:18 -0700
Message-ID: <1411502120-28219-2-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
 <1411502120-28219-1-git-send-email-pfeiner@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411502120-28219-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Feiner <pfeiner@google.com>
List-Id: linux-api@vger.kernel.org

Ignore the binaries built for selftests in 'git status' output to make
development more pleasant. Without this patch, you see

       tools/testing/selftests/breakpoints/breakpoint_test
       tools/testing/selftests/efivarfs/create-read
       tools/testing/selftests/efivarfs/open-unlink
       tools/testing/selftests/kcmp/kcmp_test
       tools/testing/selftests/memfd/memfd_test
       tools/testing/selftests/mqueue/mq_open_tests
       tools/testing/selftests/mqueue/mq_perf_tests
       tools/testing/selftests/net/psock_fanout
       tools/testing/selftests/net/psock_tpacket
       tools/testing/selftests/net/socket
       tools/testing/selftests/ptrace/peeksiginfo
       tools/testing/selftests/timers/posix_timers
       tools/testing/selftests/vm/hugepage-mmap
       tools/testing/selftests/vm/hugepage-shm
       tools/testing/selftests/vm/hugetlbfstest
       tools/testing/selftests/vm/map_hugetlb
       tools/testing/selftests/vm/thuge-gen
       tools/testing/selftests/mount/unprivileged-remount-test

in the list of untracked files.

Signed-off-by: Peter Feiner <pfeiner@google.com>

---

v1 -> v2:
	* added changelog blurb
	* added mount/.gitignore for unprivileged-remount-test
---
 tools/testing/selftests/breakpoints/.gitignore | 1 +
 tools/testing/selftests/efivarfs/.gitignore    | 2 ++
 tools/testing/selftests/mount/.gitignore       | 1 +
 tools/testing/selftests/ptrace/.gitignore      | 1 +
 tools/testing/selftests/timers/.gitignore      | 1 +
 tools/testing/selftests/vm/.gitignore          | 9 +++++----
 6 files changed, 11 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 create mode 100644 tools/testing/selftests/mount/.gitignore
 create mode 100644 tools/testing/selftests/ptrace/.gitignore
 create mode 100644 tools/testing/selftests/timers/.gitignore

diff --git a/tools/testing/selftests/breakpoints/.gitignore b/tools/testing/selftests/breakpoints/.gitignore
new file mode 100644
index 0000000..ad66922
--- /dev/null
+++ b/tools/testing/selftests/breakpoints/.gitignore
@@ -0,0 +1 @@
+/breakpoint_test
diff --git a/tools/testing/selftests/efivarfs/.gitignore b/tools/testing/selftests/efivarfs/.gitignore
new file mode 100644
index 0000000..66c6e85
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/.gitignore
@@ -0,0 +1,2 @@
+/create-read
+/open-unlink
diff --git a/tools/testing/selftests/mount/.gitignore b/tools/testing/selftests/mount/.gitignore
new file mode 100644
index 0000000..7ffb29f
--- /dev/null
+++ b/tools/testing/selftests/mount/.gitignore
@@ -0,0 +1 @@
+/unprivileged-remount-test
diff --git a/tools/testing/selftests/ptrace/.gitignore b/tools/testing/selftests/ptrace/.gitignore
new file mode 100644
index 0000000..d348b86
--- /dev/null
+++ b/tools/testing/selftests/ptrace/.gitignore
@@ -0,0 +1 @@
+/peeksiginfo
diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/selftests/timers/.gitignore
new file mode 100644
index 0000000..ac85e5b
--- /dev/null
+++ b/tools/testing/selftests/timers/.gitignore
@@ -0,0 +1 @@
+/posix_timers
diff --git a/tools/testing/selftests/vm/.gitignore b/tools/testing/selftests/vm/.gitignore
index ff1bb16..e57961f 100644
--- a/tools/testing/selftests/vm/.gitignore
+++ b/tools/testing/selftests/vm/.gitignore
@@ -1,4 +1,5 @@
-hugepage-mmap
-hugepage-shm
-map_hugetlb
-thuge-gen
+/hugepage-mmap
+/hugepage-shm
+/map_hugetlb
+/thuge-gen
+/hugetlbfstest
-- 
2.1.0.rc2.206.gedb03e5
