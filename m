From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] headers_check: don't warn about kexec.h
Date: Tue, 13 Jan 2015 17:19:19 +0100
Message-ID: <12825174.7oxZXDxNhV@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
List-Id: linux-api@vger.kernel.org

We've been getting this warning for ages:

./usr/include/linux/kexec.h:61: userspace cannot reference function or variable defined in the kernel

There is no proper fix for this file, as the declaration is meant for
user space, not for the kernel, so we should work around it the
same way that we treat the seqbuf_dump() definition.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 62320f93e903..fb051848667c 100755
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -69,6 +69,10 @@ sub check_declarations
 	if ($line =~ m/^void seqbuf_dump\(void\);/) {
 		return;
 	}
+	# user-only declaration from kexec.h
+	if ($line =~ m/^extern int kexec_load/) {
+		return;
+	}
 	if ($line =~ m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
 			      "userspace cannot reference function or " .
