From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 6/8] kdbus: TEST_CREATE_CONN now does no depend on TEST_CREATE_BUS
Date: Wed, 08 Jul 2015 12:25:08 +0200
Message-ID: <1436351110-5902-7-git-send-email-p.osmialowsk@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

Without this patch, it is impossible to specify test case able to
connect to a bus already created (e.g. by 'test-daemon' test case), you can
only specify:

1) TEST_CREATE_BUS which creates new bus, or
2) TEST_CREATE_CONN OR'ed with TEST_CREATE_BUS which creates new bus and
creates connection to it.

This patch adds the missing ability to specify TEST_CREATE_CONN alone.

It will be used by a new test case (will be added by separate commit) which
is supposed to connect to already started test-daemon case.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 tools/testing/selftests/kdbus/kdbus-test.c | 21 +++++++++++++++++++++
 tools/testing/selftests/kdbus/kdbus-util.c | 18 +++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kdbus/kdbus-test.c b/tools/testing/selftests/kdbus/kdbus-test.c
index 294e82a..d3a656f 100644
--- a/tools/testing/selftests/kdbus/kdbus-test.c
+++ b/tools/testing/selftests/kdbus/kdbus-test.c
@@ -309,6 +309,27 @@ static int test_prepare_env(const struct kdbus_test *t,
 	}
 
 	if (t->flags & TEST_CREATE_CONN) {
+		if (!env->buspath) {
+			char *s = NULL;
+			char *n = NULL;
+			int ret;
+
+			if (!args->busname) {
+				n = unique_name("test-bus");
+				ASSERT_RETURN(n);
+			}
+
+			ret = kdbus_create_bus(-1,
+					       args->busname ?: n,
+					       0,
+					       0, &s);
+			free(n);
+			ASSERT_RETURN(ret == 0);
+
+			asprintf(&env->buspath, "%s/%s/bus", args->root, s);
+			free(s);
+		}
+		ASSERT_RETURN(env->buspath);
 		env->conn = kdbus_hello(env->buspath, 0, NULL, 0);
 		ASSERT_RETURN(env->conn);
 	}
diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
index 29a0cb1..26104ca 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.c
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -141,7 +141,7 @@ int kdbus_create_bus(int control_fd, const char *name,
 			char str[64];
 		} name;
 	} bus_make;
-	int ret;
+	int ret = 0;
 
 	memset(&bus_make, 0, sizeof(bus_make));
 	bus_make.bp.size = sizeof(bus_make.bp);
@@ -171,13 +171,17 @@ int kdbus_create_bus(int control_fd, const char *name,
 			     bus_make.attach[1].size +
 			     bus_make.name.size;
 
-	kdbus_printf("Creating bus with name >%s< on control fd %d ...\n",
-		     name, control_fd);
+	if (control_fd != -1) {
+		kdbus_printf(
+			"Creating bus with name >%s< on control fd %d ...\n",
+			name, control_fd);
 
-	ret = kdbus_cmd_bus_make(control_fd, &bus_make.cmd);
-	if (ret < 0) {
-		kdbus_printf("--- error when making bus: %d (%m)\n", ret);
-		return ret;
+		ret = kdbus_cmd_bus_make(control_fd, &bus_make.cmd);
+		if (ret < 0) {
+			kdbus_printf("--- error when making bus: %d (%m)\n",
+				     ret);
+			return ret;
+		}
 	}
 
 	if (ret == 0 && path)
-- 
1.9.1
