From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 3/3] kdbus: Ability to run kdbus test by executable binary name
Date: Thu, 24 Sep 2015 14:07:36 +0200
Message-ID: <1443096456-1527-4-git-send-email-p.osmialowsk@samsung.com>
References: <1443096456-1527-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1443096456-1527-1-git-send-email-p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

With this applied, you can make a symlink (or copy) of kdbus-test
executable binary and name it according to given test name.

Useful for testing features introduced by previous patches.

Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 tools/testing/selftests/kdbus/kdbus-test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kdbus/kdbus-test.c b/tools/testing/selftests/kdbus/kdbus-test.c
index 37f05bb..473cb1b 100644
--- a/tools/testing/selftests/kdbus/kdbus-test.c
+++ b/tools/testing/selftests/kdbus/kdbus-test.c
@@ -834,6 +834,7 @@ int main(int argc, char *argv[])
 		ARG_UIDMAP,
 		ARG_GIDMAP,
 	};
+	char *exec = basename(argv[0]);
 
 	kdbus_args = malloc(sizeof(*kdbus_args));
 	if (!kdbus_args) {
@@ -863,6 +864,10 @@ int main(int argc, char *argv[])
 
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
