From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH xfsprogs] xfs_io: add support for linkat() AT_LINK_REPLACE
Date: Wed, 29 Jan 2020 00:58:29 -0800
Message-ID: <ff4b873f356ed8ff63ee582bc57c4babea947159.1580253398.git.osandov__132.861656469174$1580288332$gmane$org@fb.com>
References: <cover.1580251857.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1580251857.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 io/link.c         | 24 ++++++++++++++++++++----
 man/man8/xfs_io.8 |  9 ++++++++-
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/io/link.c b/io/link.c
index f4f4b139..3fc3e24d 100644
--- a/io/link.c
+++ b/io/link.c
@@ -12,6 +12,9 @@
 #ifndef AT_EMPTY_PATH
 #define AT_EMPTY_PATH	0x1000
 #endif
+#ifndef AT_LINK_REPLACE
+#define AT_LINK_REPLACE	0x10000
+#endif
 
 static cmdinfo_t flink_cmd;
 
@@ -22,6 +25,7 @@ flink_help(void)
 "\n"
 "link the open file descriptor to the supplied filename\n"
 "\n"
+" -f -- overwrite the target filename if it exists (AT_LINK_REPLACE)\n"
 "\n"));
 }
 
@@ -30,10 +34,22 @@ flink_f(
 	int		argc,
 	char		**argv)
 {
-	if (argc != 2)
+	int		flags = AT_EMPTY_PATH;
+	int		c;
+
+	while ((c = getopt(argc, argv, "f")) != EOF) {
+		switch (c) {
+		case 'f':
+			flags |= AT_LINK_REPLACE;
+			break;
+		default:
+			return command_usage(&flink_cmd);
+		}
+	}
+	if (optind != argc - 1)
 		return command_usage(&flink_cmd);
 
-	if (linkat(file->fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) < 0) {
+	if (linkat(file->fd, "", AT_FDCWD, argv[optind], flags) < 0) {
 		perror("flink");
 		return 0;
 	}
@@ -46,9 +62,9 @@ flink_init(void)
 	flink_cmd.name = "flink";
 	flink_cmd.cfunc = flink_f;
 	flink_cmd.argmin = 1;
-	flink_cmd.argmax = 1;
+	flink_cmd.argmax = -1;
 	flink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
-	flink_cmd.args = _("filename");
+	flink_cmd.args = _("[-f] filename");
 	flink_cmd.oneline =
 		_("link the open file descriptor to the supplied filename");
 	flink_cmd.help = flink_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c69b295d..f79b3a59 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -807,8 +807,15 @@ for the full list) is available via the
 .B help
 command.
 .TP
-.BI "flink " path
+.BI "flink [ \-f ]" " path"
 Link the currently open file descriptor into the filesystem namespace.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-f
+overwrite the target path if it exists (AT_LINK_REPLACE).
+.PD
+.RE
 .TP
 .BR stat " [ " \-v "|" \-r " ]"
 Selected statistics from
-- 
2.25.0
