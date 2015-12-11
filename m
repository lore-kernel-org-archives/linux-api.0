From: Brian Norris <computersforpeace@gmail.com>
Subject: [RFC] selftests: report proper exit statuses
Date: Fri, 11 Dec 2015 15:15:06 -0800
Message-ID: <1449875706-106875-1-git-send-email-computersforpeace@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

There are several places where we don't report proper exit statuses, and
this can have consequences -- for instance, the gen_kselftest_tar.sh
script might try to produce a tarball for you, even if the 'make' or
'make install' steps didn't complete properly.

This is only an RFC (and really, it's more like a bug report), since I'm
not really satisfied with my solution. It's probably not exhaustive, and
there seem to be some major other deficiencies (e.g., verbose/useless
output during build and run, non-paralle build, shell for-loops sidestep
some normal 'make' behavior). I could try to address them, but I'm not
sure how much effort I'd care to put in, and I'm not sure if there are
others who have a more comprehensive plan for cleaning up this
directory.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 tools/testing/selftests/Makefile             |  6 +++---
 tools/testing/selftests/gen_kselftest_tar.sh | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c8edff6803d1..f89893c590d5 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -44,7 +44,7 @@ endif
 
 all:
 	for TARGET in $(TARGETS); do \
-		make -C $$TARGET; \
+		make -C $$TARGET || exit 1; \
 	done;
 
 run_tests: all
@@ -54,7 +54,7 @@ run_tests: all
 
 hotplug:
 	for TARGET in $(TARGETS_HOTPLUG); do \
-		make -C $$TARGET; \
+		make -C $$TARGET || exit 1; \
 	done;
 
 run_hotplug: hotplug
@@ -79,7 +79,7 @@ ifdef INSTALL_PATH
 	@# Ask all targets to install their files
 	mkdir -p $(INSTALL_PATH)
 	for TARGET in $(TARGETS); do \
-		make -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install; \
+		make -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install || exit 1; \
 	done;
 
 	@# Ask all targets to emit their test scripts
diff --git a/tools/testing/selftests/gen_kselftest_tar.sh b/tools/testing/selftests/gen_kselftest_tar.sh
index 17d5bd0c0936..160da4e82936 100755
--- a/tools/testing/selftests/gen_kselftest_tar.sh
+++ b/tools/testing/selftests/gen_kselftest_tar.sh
@@ -44,12 +44,14 @@ main()
 
 # Run install using INSTALL_KSFT_PATH override to generate install
 # directory
-./kselftest_install.sh
-tar $copts kselftest${ext} $install_dir
+./kselftest_install.sh || return
+tar $copts kselftest${ext} $install_dir || return
 echo "Kselftest archive kselftest${ext} created!"
+}
 
+main "$@"
+ret=$?
 # clean up install directory
 rm -rf kselftest
-}
 
-main "$@"
+exit $ret
-- 
2.6.0.rc2.230.g3dd15c0
