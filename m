From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH tip/master ] ftracetest: Update kprobe-tracer testcases
 because of renaming do_fork
Date: Thu, 09 Jul 2015 19:10:12 +0900
Message-ID: <20150709101012.21228.45338.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-api@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Shuah Khan <shuahkh@osg.samsung.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

Since the commit 3033f14ab78c ("clone: support passing tls argument via
C rather than pt_regs magic") renames do_fork to _do_fork, the testcases
for kprobe-tracer doesn't work correctly on the latest kernel.

This fixes it by changing do_fork to _do_fork.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../ftrace/test.d/kprobe/add_and_remove.tc         |    2 +-
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |    2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |    2 +-
 .../ftrace/test.d/kprobe/kprobe_ftrace.tc          |   14 +++++++-------
 .../ftrace/test.d/kprobe/kretprobe_args.tc         |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index a5a4262..c3843ed 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -5,7 +5,7 @@
 
 echo 0 > events/enable
 echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
 grep myevent kprobe_events
 test -d events/kprobes/myevent
 echo > kprobe_events
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index d8c7bb6..74507db 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -5,7 +5,7 @@
 
 echo 0 > events/enable
 echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
 test -d events/kprobes/myevent
 echo 1 > events/kprobes/myevent/enable
 echo > kprobe_events && exit 1 # this must fail
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
index c45ee27..64949d4 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -5,7 +5,7 @@
 
 echo 0 > events/enable
 echo > kprobe_events
-echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
+echo 'p:testprobe _do_fork $stack $stack0 +0($stack)' > kprobe_events
 grep testprobe kprobe_events
 test -d events/kprobes/testprobe
 echo 1 > events/kprobes/testprobe/enable
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
index ab41d2b..d6f2f49 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -6,31 +6,31 @@ grep function available_tracers || exit_unsupported # this is configurable
 
 # prepare
 echo nop > current_tracer
-echo do_fork > set_ftrace_filter
+echo _do_fork > set_ftrace_filter
 echo 0 > events/enable
 echo > kprobe_events
-echo 'p:testprobe do_fork' > kprobe_events
+echo 'p:testprobe _do_fork' > kprobe_events
 
 # kprobe on / ftrace off
 echo 1 > events/kprobes/testprobe/enable
 echo > trace
 ( echo "forked")
 grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
 
 # kprobe on / ftrace on
 echo function > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
 
 # kprobe off / ftrace on
 echo 0 > events/kprobes/testprobe/enable
 echo > trace
 ( echo "forked")
 ! grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
 
 # kprobe on / ftrace on
 echo 1 > events/kprobes/testprobe/enable
@@ -38,14 +38,14 @@ echo function > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
 
 # kprobe on / ftrace off
 echo nop > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
 
 # cleanup
 echo nop > current_tracer
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
index 3171798..0d09546 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -5,7 +5,7 @@
 
 echo 0 > events/enable
 echo > kprobe_events
-echo 'r:testprobe2 do_fork $retval' > kprobe_events
+echo 'r:testprobe2 _do_fork $retval' > kprobe_events
 grep testprobe2 kprobe_events
 test -d events/kprobes/testprobe2
 echo 1 > events/kprobes/testprobe2/enable
