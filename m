From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [PATCH v4 0/2] Create specific kconfig for kselftest
Date: Fri,  8 Jan 2016 15:27:32 +0800
Message-ID: <1452238054-15482-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, shuahkh@osg.samsung.com, yann.morin.1998@free.fr, khilman@linaro.org, tyler.baker@linaro.org, broonie@kernel.org, mpe@ellerman.id.au, dvhart@infradead.org, mmarek@suse.com, Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

There is a discussion about improving the usability of kselftest by
creating test-specific kconfig in recent kernel Summit. The first
three versions could be found at [1], [2], [3].

Patch 1 keep test-specific kconfig fragments inside each selftest so
that merge_configs.sh could build up a kernel configuration that can
test the specific or all feature(s).

Patch 2 add config option(kselftest-merge) in make file as a
helper to merge all the test config dependecies to .config.

Changes since v3:
1.  move the target kselftest-mergeconfig from scripts/kconfig/Makfile
    to toplevel Makefile. And rename to kselftest-merge to avoid the
    conflict with "%config" target.

Changes since v2:
1.  Fix the misuse of objtree and srctree in the
    kselftest-mergeconfig target.

Changes since v1:
1.  Add kselftest-mergeconfig in scripts/kconfig/Makefile according
    to the suggestion from Michael.

[1] http://www.spinics.net/lists/linux-api/msg15533.html
[2] http://www.spinics.net/lists/linux-api/msg15593.html
[3] http://comments.gmane.org/gmane.linux.kernel/2110565

Bamvor Jian Zhang (2):
  selftests: create test-specific kconfig fragments
  Makefile: add kselftest-merge

 Makefile                                      | 11 +++++++++++
 tools/testing/selftests/cpu-hotplug/config    |  2 ++
 tools/testing/selftests/firmware/config       |  1 +
 tools/testing/selftests/ftrace/config         |  1 +
 tools/testing/selftests/ipc/config            |  2 ++
 tools/testing/selftests/memory-hotplug/config |  4 ++++
 tools/testing/selftests/mount/config          |  2 ++
 tools/testing/selftests/net/config            |  3 +++
 tools/testing/selftests/pstore/config         |  4 ++++
 tools/testing/selftests/seccomp/config        |  2 ++
 tools/testing/selftests/static_keys/config    |  1 +
 tools/testing/selftests/user/config           |  1 +
 tools/testing/selftests/vm/config             |  1 +
 tools/testing/selftests/zram/config           |  2 ++
 14 files changed, 37 insertions(+)
 create mode 100644 tools/testing/selftests/cpu-hotplug/config
 create mode 100644 tools/testing/selftests/firmware/config
 create mode 100644 tools/testing/selftests/ftrace/config
 create mode 100644 tools/testing/selftests/ipc/config
 create mode 100644 tools/testing/selftests/memory-hotplug/config
 create mode 100644 tools/testing/selftests/mount/config
 create mode 100644 tools/testing/selftests/net/config
 create mode 100644 tools/testing/selftests/pstore/config
 create mode 100644 tools/testing/selftests/seccomp/config
 create mode 100644 tools/testing/selftests/static_keys/config
 create mode 100644 tools/testing/selftests/user/config
 create mode 100644 tools/testing/selftests/vm/config
 create mode 100644 tools/testing/selftests/zram/config

-- 
2.1.4

