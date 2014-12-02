From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [CFT][PATCH 3/3] userns: Unbreak the unprivileged remount tests
Date: Tue, 02 Dec 2014 14:30:07 -0600
Message-ID: <87r3whx0a8.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <874mtdyexp.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 02 Dec 2014 14:28:18 -0600")
Sender: stable-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


A security fix in caused the way the unprivileged remount tests were
using user namespaces to break.  Tweak the way user namespaces are
being used so the test works again.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

This is what it takes to fix a broken application, in it's full glory.
This fix works even if new functionality does not exist.

 tools/testing/selftests/mount/unprivileged-remount-test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 9669d375625a..d47227494137 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -144,13 +144,12 @@ static void create_and_enter_userns(void)
 			strerror(errno));
 	}
 
+	if (access("/proc/self/setgroups", F_OK) == 0) {
+		write_file("/proc/self/setgroups", "0");
+	}
 	write_file("/proc/self/uid_map", "0 %d 1", uid);
 	write_file("/proc/self/gid_map", "0 %d 1", gid);
 
-	if (setgroups(0, NULL) != 0) {
-		die("setgroups failed: %s\n",
-			strerror(errno));
-	}
 	if (setgid(0) != 0) {
 		die ("setgid(0) failed %s\n",
 			strerror(errno));
-- 
1.9.1
