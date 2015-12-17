From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [PATCH v3 1/2] selftests: create test-specific kconfig fragments
Date: Thu, 17 Dec 2015 17:57:52 +0800
Message-ID: <1450346273-31633-3-git-send-email-bamvor.zhangjian@linaro.org>
References: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, shuahkh@osg.samsung.com, yann.morin.1998@free.fr, khilman@linaro.org, tyler.baker@linaro.org, broonie@kernel.org, mpe@ellerman.id.au, dvhart@infradead.org, Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

Create the config file in each directory of testcase which need
more kernel configuration than the default defconfig. User could
use these configs with merge_config.sh script:

Enable config for specific testcases:
(export ARCH=xxx #for cross compiling)
./scripts/kconfig/merge_config.sh .config \
		tools/testing/selftests/xxx/config

Enable configs for all testcases:
(export ARCH=xxx #for cross compiling)
./scripts/kconfig/merge_config.sh .config \
		tools/testing/selftests/*/config

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
---
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
 13 files changed, 26 insertions(+)
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

diff --git a/tools/testing/selftests/cpu-hotplug/config b/tools/testing/selftests/cpu-hotplug/config
new file mode 100644
index 0000000..e6ab090
--- /dev/null
+++ b/tools/testing/selftests/cpu-hotplug/config
@@ -0,0 +1,2 @@
+CONFIG_NOTIFIER_ERROR_INJECTION=y
+CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
diff --git a/tools/testing/selftests/firmware/config b/tools/testing/selftests/firmware/config
new file mode 100644
index 0000000..c8137f7
--- /dev/null
+++ b/tools/testing/selftests/firmware/config
@@ -0,0 +1 @@
+CONFIG_TEST_FIRMWARE=y
diff --git a/tools/testing/selftests/ftrace/config b/tools/testing/selftests/ftrace/config
new file mode 100644
index 0000000..ef82146
--- /dev/null
+++ b/tools/testing/selftests/ftrace/config
@@ -0,0 +1 @@
+CONFIG_FTRACE=y
diff --git a/tools/testing/selftests/ipc/config b/tools/testing/selftests/ipc/config
new file mode 100644
index 0000000..0702447
--- /dev/null
+++ b/tools/testing/selftests/ipc/config
@@ -0,0 +1,2 @@
+CONFIG_EXPERT=y
+CONFIG_CHECKPOINT_RESTORE=y
diff --git a/tools/testing/selftests/memory-hotplug/config b/tools/testing/selftests/memory-hotplug/config
new file mode 100644
index 0000000..2fde301
--- /dev/null
+++ b/tools/testing/selftests/memory-hotplug/config
@@ -0,0 +1,4 @@
+CONFIG_MEMORY_HOTPLUG=y
+CONFIG_MEMORY_HOTPLUG_SPARSE=y
+CONFIG_NOTIFIER_ERROR_INJECTION=y
+CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
diff --git a/tools/testing/selftests/mount/config b/tools/testing/selftests/mount/config
new file mode 100644
index 0000000..b5d881e
--- /dev/null
+++ b/tools/testing/selftests/mount/config
@@ -0,0 +1,2 @@
+CONFIG_USER_NS=y
+CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
new file mode 100644
index 0000000..e57b4ac
--- /dev/null
+++ b/tools/testing/selftests/net/config
@@ -0,0 +1,3 @@
+CONFIG_USER_NS=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_TEST_BPF=m
diff --git a/tools/testing/selftests/pstore/config b/tools/testing/selftests/pstore/config
new file mode 100644
index 0000000..6a8e5a9
--- /dev/null
+++ b/tools/testing/selftests/pstore/config
@@ -0,0 +1,4 @@
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_PSTORE=y
+CONFIG_PSTORE_PMSG=y
+CONFIG_PSTORE_CONSOLE=y
diff --git a/tools/testing/selftests/seccomp/config b/tools/testing/selftests/seccomp/config
new file mode 100644
index 0000000..db1e11b
--- /dev/null
+++ b/tools/testing/selftests/seccomp/config
@@ -0,0 +1,2 @@
+CONFIG_SECCOMP=y
+CONFIG_SECCOMP_FILTER=y
diff --git a/tools/testing/selftests/static_keys/config b/tools/testing/selftests/static_keys/config
new file mode 100644
index 0000000..d538fb7
--- /dev/null
+++ b/tools/testing/selftests/static_keys/config
@@ -0,0 +1 @@
+CONFIG_TEST_STATIC_KEYS=m
diff --git a/tools/testing/selftests/user/config b/tools/testing/selftests/user/config
new file mode 100644
index 0000000..784ed84
--- /dev/null
+++ b/tools/testing/selftests/user/config
@@ -0,0 +1 @@
+CONFIG_TEST_USER_COPY=m
diff --git a/tools/testing/selftests/vm/config b/tools/testing/selftests/vm/config
new file mode 100644
index 0000000..698c7ed
--- /dev/null
+++ b/tools/testing/selftests/vm/config
@@ -0,0 +1 @@
+CONFIG_USERFAULTFD=y
diff --git a/tools/testing/selftests/zram/config b/tools/testing/selftests/zram/config
new file mode 100644
index 0000000..e0cc47e
--- /dev/null
+++ b/tools/testing/selftests/zram/config
@@ -0,0 +1,2 @@
+CONFIG_ZSMALLOC=y
+CONFIG_ZRAM=m
-- 
2.1.4
