From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 6/6] tools/quota/project_quota: sample tool for early
 adopters
Date: Wed, 11 Feb 2015 18:11:53 +0300
Message-ID: <20150211151153.6717.51053.stgit@buzz>
References: <20150211151146.6717.62017.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150211151146.6717.62017.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Li Xi <pkuelelixi@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Usage: ./project_quota <command> <path> [args]...
Commands:
  init    <path>                initialize quota file
  on      <path>                turn on
  off     <path>                turn off
  info    <path>                show project, usage and limits
  project <path> [<id>]         get / set project id
  limit   <path> [<bytes>]      get / set space limit
  ilimit  <path> [<inodes>]     get / set inodes limit


How to enable feature using debugfs tool:
# debugfs
debugfs:  open -w <disk>
debugfs:  feature +FEATURE_R12
debugfs:  quit
# mount ...
# project_quota init <mountpoint>
# project_quota on <mountpoint>

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 tools/quota/.gitignore      |    1 
 tools/quota/Makefile        |    6 +
 tools/quota/project_quota.c |  324 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 331 insertions(+)
 create mode 100644 tools/quota/.gitignore
 create mode 100644 tools/quota/Makefile
 create mode 100644 tools/quota/project_quota.c

diff --git a/tools/quota/.gitignore b/tools/quota/.gitignore
new file mode 100644
index 0000000..4aacefc
--- /dev/null
+++ b/tools/quota/.gitignore
@@ -0,0 +1 @@
+project_quota
diff --git a/tools/quota/Makefile b/tools/quota/Makefile
new file mode 100644
index 0000000..0c3daef
--- /dev/null
+++ b/tools/quota/Makefile
@@ -0,0 +1,6 @@
+CFLAGS=-Wall -W
+
+project_quota:
+
+clean:
+	rm project_quota
diff --git a/tools/quota/project_quota.c b/tools/quota/project_quota.c
new file mode 100644
index 0000000..ca7f49a
--- /dev/null
+++ b/tools/quota/project_quota.c
@@ -0,0 +1,324 @@
+/*
+ * project_quota: Tool for project disk quota manipulations
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should find a copy of v2 of the GNU General Public License somewhere on
+ * your Linux system; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Copyright (C) 2015 Yandex LLC
+ *
+ * Authors: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
+ */
+
+#define _FILE_OFFSET_BITS 64
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <err.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/quota.h>
+#include <sys/quota.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mount.h>
+
+#ifndef F_LINUX_SPECIFIC_BASE
+#define F_LINUX_SPECIFIC_BASE	1024
+#endif
+
+#ifndef F_GET_PROJECT
+#define F_GET_PROJECT  (F_LINUX_SPECIFIC_BASE + 11)
+#define F_SET_PROJECT  (F_LINUX_SPECIFIC_BASE + 12)
+#endif
+
+#ifndef PRJQUOTA
+#define PRJQUOTA 2
+#endif
+
+/* First generic header */
+struct v2_disk_dqheader {
+	__le32 dqh_magic;	/* Magic number identifying file */
+	__le32 dqh_version;	/* File version */
+};
+
+/* Header with type and version specific information */
+struct v2_disk_dqinfo {
+	__le32 dqi_bgrace;	/* Time before block soft limit becomes hard limit */
+	__le32 dqi_igrace;	/* Time before inode soft limit becomes hard limit */
+	__le32 dqi_flags;	/* Flags for quotafile (DQF_*) */
+	__le32 dqi_blocks;	/* Number of blocks in file */
+	__le32 dqi_free_blk;	/* Number of first free block in the list */
+	__le32 dqi_free_entry;	/* Number of block with at least one free entry */
+};
+
+#define PROJECT_QUOTA_FILE	"quota.project"
+#define PROJECT_QUOTA_MAGIC	0xd9c03f14
+
+static int find_mountpoint(const char *path, struct stat *path_st,
+		char **device, char **fstype, char **root_path)
+{
+	struct stat dev_st;
+	char *buf = NULL, *ptr, *real_device;
+	unsigned major, minor;
+	size_t len;
+	FILE *file;
+
+	if (stat(path, path_st))
+		return -1;
+
+	*root_path = malloc(PATH_MAX + 1);
+
+	/* since v2.6.26 */
+	file = fopen("/proc/self/mountinfo", "r");
+	if (!file)
+		goto parse_mounts;
+	while (getline(&buf, &len, file) > 0) {
+		sscanf(buf, "%*d %*d %u:%u %*s %s", &major, &minor, *root_path);
+		if (makedev(major, minor) != path_st->st_dev)
+			continue;
+		ptr = strstr(buf, " - ") + 3;
+		*fstype = strdup(strsep(&ptr, " "));
+		*device = strdup(strsep(&ptr, " "));
+		goto found;
+	}
+
+parse_mounts:
+	/* for older versions */
+	file = fopen("/proc/mounts", "r");
+	if (!file)
+		goto not_found;
+	while (getline(&buf, &len, file) > 0) {
+		ptr = buf;
+		strsep(&ptr, " ");
+		if (*buf != '/' || stat(buf, &dev_st) ||
+		    dev_st.st_rdev != path_st->st_dev)
+			continue;
+		strcpy(*root_path, strsep(&ptr, " "));
+		*fstype = strdup(strsep(&ptr, " "));
+		*device = strdup(buf);
+		goto found;
+	}
+not_found:
+	free(*root_path);
+	errno = ENODEV;
+	return -1;
+
+found:
+	real_device = realpath(*device, NULL);
+	if (real_device) {
+		free(*device);
+		*device = real_device;
+	}
+	return 0;
+}
+
+static int init_project_quota(const char *quota_path)
+{
+	struct {
+		struct v2_disk_dqheader header;
+		struct v2_disk_dqinfo info;
+		char zero[1024 * 2 - 8 * 4];
+	} quota_init = {
+		.header = {
+			.dqh_magic = PROJECT_QUOTA_MAGIC,
+			.dqh_version = 1,
+		},
+		.info = {
+			.dqi_bgrace = 7 * 24 * 60 * 60,
+			.dqi_igrace = 7 * 24 * 60 * 60,
+			.dqi_flags = 0,
+			.dqi_blocks = 2, /* header and root */
+			.dqi_free_blk = 0,
+			.dqi_free_entry = 0,
+		},
+		.zero = {0, },
+	};
+	int fd;
+
+	fd = open(quota_path, O_CREAT|O_RDWR|O_EXCL, 0600);
+	if (fd < 0)
+		return fd;
+	write(fd, &quota_init, sizeof(quota_init));
+	fsync(fd);
+	close(fd);
+	return 0;
+}
+
+static int get_project_id(const char *path, unsigned *project_id)
+{
+	int fd, ret;
+
+	fd = open(path, O_PATH);
+	if (fd < 0)
+		return fd;
+	ret = fcntl(fd, F_GET_PROJECT, project_id);
+	close(fd);
+	return ret;
+}
+
+static int set_project_id(const char *path, unsigned project_id)
+{
+	int fd, ret;
+
+	fd = open(path, O_PATH);
+	if (fd < 0)
+		return fd;
+	ret = fcntl(fd, F_SET_PROJECT, project_id);
+	close(fd);
+	return ret;
+}
+
+static void get_project_quota(const char *device, unsigned project_id,
+		struct if_dqblk *quota)
+{
+	if (quotactl(QCMD(Q_GETQUOTA, PRJQUOTA), device,
+				project_id, (caddr_t)quota))
+		err(2, "cannot get project quota \"%u\" at \"%s\"",
+				project_id, device);
+}
+
+static void set_project_quota(const char *device, unsigned project_id,
+		struct if_dqblk *quota)
+{
+	if (quotactl(QCMD(Q_SETQUOTA, PRJQUOTA),
+		     device, project_id, (caddr_t)quota))
+		err(2, "cannot set project quota \"%u\" at \"%s\"",
+				project_id, device);
+}
+
+int main (int argc, char **argv) {
+	char *cmd, *path, *device, *fstype, *root_path;
+	struct if_dqblk quota;
+	struct stat path_st;
+	unsigned project_id;
+
+	if (argc < 3)
+		goto usage;
+
+	cmd = argv[1];
+	path = argv[2];
+	if (find_mountpoint(path, &path_st, &device, &fstype, &root_path))
+		err(2, "cannot find mountpoint for \"%s\"", path);
+
+	if (!strcmp(cmd, "limit") || !strcmp(cmd, "ilimit") ||
+	    !strcmp(cmd, "info") || !strcmp(cmd, "parent")) {
+		if (get_project_id(path, &project_id))
+			err(2, "cannot get project id for \"%s\"", path);
+	}
+
+	if (!strcmp(cmd, "init")) {
+		if (S_ISDIR(path_st.st_mode))
+			asprintf(&path, "%s/%s", path, PROJECT_QUOTA_FILE);
+
+		if (init_project_quota(path))
+			err(2, "cannot init project quota file \"%s\"", path);
+
+	} else if (!strcmp(cmd, "on")) {
+		struct v2_disk_dqheader header;
+		int fd, format;
+
+		if (S_ISDIR(path_st.st_mode))
+			asprintf(&path, "%s/%s", path, PROJECT_QUOTA_FILE);
+
+		fd = open(path, O_RDONLY);
+		if (fd < 0)
+			err(2, "cannot open quota file \"%s\"", path);
+		if (read(fd, &header, sizeof(header)) != sizeof(header))
+			err(2, "cannot read quota file \"%s\"", path);
+		close(fd);
+
+		if (header.dqh_magic != PROJECT_QUOTA_MAGIC)
+			errx(2, "wrong quota file magic");
+
+		if (header.dqh_version == 1)
+			format = QFMT_VFS_V1;
+		else
+			errx(2, "unsupported quota file version");
+
+		if (mount(NULL, root_path, NULL, MS_REMOUNT, "prjquota"))
+			err(2, "cannot remount \"%s\"", root_path);
+
+		if (quotactl(QCMD(Q_QUOTAON, PRJQUOTA), device,
+					format, (caddr_t)path))
+			err(2, "cannot turn on project quota for %s", device);
+
+	} else if (!strcmp(cmd, "off")) {
+
+		if (quotactl(QCMD(Q_QUOTAOFF, PRJQUOTA), device, 0, NULL))
+			err(2, "cannot turn off project quota for %s", device);
+
+	} else if (!strcmp(cmd, "project")) {
+		if (argc < 4) {
+			if (get_project_id(path, &project_id))
+				err(2, "cannot get project id for \"%s\"", path);
+			printf("%u\n", project_id);
+		} else {
+			project_id = atoi(argv[3]);
+			if (set_project_id(path, project_id))
+				err(2, "cannot set project id for \"%s\"", path);
+		}
+	} else if (!strcmp(cmd, "limit")) {
+		if (argc < 4) {
+			get_project_quota(device, project_id, &quota);
+			printf("%lld\n", quota.dqb_bhardlimit * QIF_DQBLKSIZE);
+		} else {
+			quota.dqb_bhardlimit = atoll(argv[3]) / QIF_DQBLKSIZE;
+			quota.dqb_bsoftlimit = 0;
+			quota.dqb_valid = QIF_BLIMITS;
+			set_project_quota(device, project_id, &quota);
+		}
+	} else if (!strcmp(cmd, "ilimit")) {
+		if (argc < 4) {
+			get_project_quota(device, project_id, &quota);
+			printf("%lld\n", quota.dqb_ihardlimit);
+		} else {
+			quota.dqb_ihardlimit = atoll(argv[3]);
+			quota.dqb_isoftlimit = 0;
+			quota.dqb_valid = QIF_ILIMITS;
+			set_project_quota(device, project_id, &quota);
+		}
+	} else if (!strcmp(cmd, "info")) {
+		get_project_quota(device, project_id, &quota);
+		printf("project   %u\n", project_id);
+		printf("usage     %llu\n", quota.dqb_curspace);
+		printf("limit     %llu\n", quota.dqb_bhardlimit * QIF_DQBLKSIZE);
+		printf("inodes    %llu\n", quota.dqb_curinodes);
+		printf("ilimit    %llu\n", quota.dqb_ihardlimit);
+	} else {
+		warnx("Unknown command \"%s\"", cmd);
+		goto usage;
+	}
+
+	free(device);
+	free(fstype);
+	free(root_path);
+
+	return 0;
+
+usage:
+	fprintf(stderr, "Usage: %s <command> <path> [args]...\n"
+			"Commands:\n"
+			"  init    <path>                initialize quota file\n"
+			"  on      <path>                turn on\n"
+			"  off     <path>                turn off\n"
+			"  info    <path>                show project, usage and limits\n"
+			"  project <path> [<id>]         get / set project id\n"
+			"  limit   <path> [<bytes>]      get / set space limit\n"
+			"  ilimit  <path> [<inodes>]     get / set inodes limit\n",
+			argv[0]);
+	return 2;
+}
