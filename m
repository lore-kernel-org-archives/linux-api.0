From: Tim Bird <tim.bird@sonymobile.com>
Subject: [PATCH] kselftest: Move the docs to the Documentation dir
Date: Wed, 19 Nov 2014 16:16:16 -0800
Message-ID: <546D32D0.9090206@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


Also, adjust the formatting a bit, and expand the section about using
TARGETS= on the make command line.

Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
---
 Documentation/kselftest.txt        | 69 ++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/README.txt | 61 ---------------------------------
 2 files changed, 69 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/kselftest.txt
 delete mode 100644 tools/testing/selftests/README.txt

diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
new file mode 100644
index 0000000..a87d840
--- /dev/null
+++ b/Documentation/kselftest.txt
@@ -0,0 +1,69 @@
+Linux Kernel Selftests
+
+The kernel contains a set of "self tests" under the tools/testing/selftests/
+directory. These are intended to be small unit tests to exercise individual
+code paths in the kernel.
+
+On some systems, hot-plug tests could hang forever waiting for cpu and
+memory to be ready to be offlined. A special hot-plug target is created
+to run full range of hot-plug tests. In default mode, hot-plug tests run
+in safe mode with a limited scope. In limited mode, cpu-hotplug test is
+run on a single cpu as opposed to all hotplug capable cpus, and memory
+hotplug test is run on 2% of hotplug capable memory instead of 10%.
+
+Running the selftests (hotplug tests are run in limited mode)
+=============================================================
+
+To build the tests:
+  $ make -C tools/testing/selftests
+
+
+To run the tests:
+  $ make -C tools/testing/selftests run_tests
+
+To build and run the tests with a single command, use:
+  $ make kselftest
+
+- note that some tests will require root privileges.
+
+
+Running a subset of selftests
+========================================
+You can use the "TARGETS" variable on the make command line to specify
+single test to run, or a list of tests to run.
+
+To run only tests targeted for a single subsystem:
+  $  make -C tools/testing/selftests TARGETS=ptrace run_tests
+
+You can specify multiple tests to build and run:
+  $  make TARGETS="size timers" kselftest
+
+See the top-level tools/testing/selftests/Makefile for the list of all
+possible targets.
+
+
+Running the full range hotplug selftests
+========================================
+
+To build the hotplug tests:
+  $ make -C tools/testing/selftests hotplug
+
+To run the hotplug tests:
+  $ make -C tools/testing/selftests run_hotplug
+
+- note that some tests will require root privileges.
+
+
+Contributing new tests
+======================
+
+In general, the rules for for selftests are
+
+ * Do as much as you can if you're not root;
+
+ * Don't take too long;
+
+ * Don't break the build on any architecture, and
+
+ * Don't cause the top-level "make run_tests" to fail if your feature is
+   unconfigured.
diff --git a/tools/testing/selftests/README.txt b/tools/testing/selftests/README.txt
deleted file mode 100644
index 2660d5f..0000000
--- a/tools/testing/selftests/README.txt
+++ /dev/null
@@ -1,61 +0,0 @@
-Linux Kernel Selftests
-
-The kernel contains a set of "self tests" under the tools/testing/selftests/
-directory. These are intended to be small unit tests to exercise individual
-code paths in the kernel.
-
-On some systems, hot-plug tests could hang forever waiting for cpu and
-memory to be ready to be offlined. A special hot-plug target is created
-to run full range of hot-plug tests. In default mode, hot-plug tests run
-in safe mode with a limited scope. In limited mode, cpu-hotplug test is
-run on a single cpu as opposed to all hotplug capable cpus, and memory
-hotplug test is run on 2% of hotplug capable memory instead of 10%.
-
-Running the selftests (hotplug tests are run in limited mode)
-=============================================================
-
-To build the tests:
-
-  $ make -C tools/testing/selftests
-
-
-To run the tests:
-
-  $ make -C tools/testing/selftests run_tests
-
-- note that some tests will require root privileges.
-
-To run only tests targeted for a single subsystem: (including
-hotplug targets in limited mode)
-
-  $  make -C tools/testing/selftests TARGETS=cpu-hotplug run_tests
-
-See the top-level tools/testing/selftests/Makefile for the list of all possible
-targets.
-
-Running the full range hotplug selftests
-========================================
-
-To build the tests:
-
-  $ make -C tools/testing/selftests hotplug
-
-To run the tests:
-
-  $ make -C tools/testing/selftests run_hotplug
-
-- note that some tests will require root privileges.
-
-Contributing new tests
-======================
-
-In general, the rules for for selftests are
-
- * Do as much as you can if you're not root;
-
- * Don't take too long;
-
- * Don't break the build on any architecture, and
-
- * Don't cause the top-level "make run_tests" to fail if your feature is
-   unconfigured.
-- 
1.8.2.2
