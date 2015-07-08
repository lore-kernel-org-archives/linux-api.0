From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 8/8] kdbus: Ability to run kdbus test by executable binary name
Date: Wed, 08 Jul 2015 12:25:10 +0200
Message-ID: <1436351110-5902-9-git-send-email-p.osmialowsk@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

With this applied, you can do following:

$ cp kdbus-test daemon
$ cp kdbus-test send

Then run 'daemon' in one shell session:

$ ./daemon --bus test

...and 'send' in another:

$ ./send --bus test

Useful for testing features introduced by previous patches.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 tools/testing/selftests/kdbus/kdbus-test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kdbus/kdbus-test.c b/tools/testing/selftests/kdbus/kdbus-test.c
index 5a296da..9efbc5f 100644
--- a/tools/testing/selftests/kdbus/kdbus-test.c
+++ b/tools/testing/selftests/kdbus/kdbus-test.c
@@ -829,6 +829,7 @@ int main(int argc, char *argv[])
 		ARG_UIDMAP,
 		ARG_GIDMAP,
 	};
+	char *exec = basename(argv[0]);
 
 	kdbus_args = malloc(sizeof(*kdbus_args));
 	if (!kdbus_args) {
@@ -858,6 +859,10 @@ int main(int argc, char *argv[])
 
 	srand(time(NULL));
 
+	if (strcmp(exec, "kdbus-test") != 0) {
+		kdbus_args->test = exec;
+	}
+
 	while ((t = getopt_long(argc, argv, "hxfm:r:t:b:w:a", options, NULL)) >= 0) {
 		switch (t) {
 		case 'x':
-- 
1.9.1
