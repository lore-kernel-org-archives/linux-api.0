From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V2 0/2] Create specific kconfig for kselftest
Date: Tue, 17 Nov 2015 22:34:15 +0800
Message-ID: <1447770857-9883-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There is a discussion about improving the usability of kselftest by
creating test-specific kconfig in recent kernel Summit. Furthormore,
there are different approaches to do it:

1) keep test-specific kconfig fragments inside each selftest so that
merge_configs.sh could build up a kernel that can test the specific
or all feature(s).

2) In the main menu, have an additional option/flag for each feature
that should be enabled when ksefltests are wanted.  Similar to the
CONFIG_COMPILE_TEST flag.

Patch 1/2: do option 1. Hope it is a good start for discussion.

Patch 2/2: add config option(kselftest-mergeconfig) in make file as a
helper to merge all the test config dependecies to .config.

Changes since v1[1]:
1.  Add kselftest-mergeconfig in scripts/kconfig/Makefile according
    to the suggestion from Michael.

[1] http://www.spinics.net/lists/linux-api/msg15533.html

Bamvor Jian Zhang (2):
  selftests: create test-specific kconfig fragments
  scripts/kconfig/Makefile: add kselftest-mergeconfig

 scripts/kconfig/Makefile                      | 9 +++++++++
 tools/testing/selftests/cpu-hotplug/config    | 2 ++
 tools/testing/selftests/firmware/config       | 1 +
 tools/testing/selftests/ftrace/config         | 1 +
 tools/testing/selftests/ipc/config            | 2 ++
 tools/testing/selftests/memory-hotplug/config | 4 ++++
 tools/testing/selftests/mount/config          | 2 ++
 tools/testing/selftests/net/config            | 3 +++
 tools/testing/selftests/pstore/config         | 4 ++++
 tools/testing/selftests/seccomp/config        | 2 ++
 tools/testing/selftests/static_keys/config    | 1 +
 tools/testing/selftests/user/config           | 1 +
 tools/testing/selftests/vm/config             | 1 +
 tools/testing/selftests/zram/config           | 2 ++
 14 files changed, 35 insertions(+)
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
1.8.4.5
