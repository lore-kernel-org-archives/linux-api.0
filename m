From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: + loop-add-ioctl-to-resize-a-loop-device.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:40:51 -0800
Message-ID: <200811212040.mALKep8u000660@imap1.linux-foundation.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomas-VOkecuvH9Oc@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org


The patch titled
     loop: add ioctl to resize a loop device
has been added to the -mm tree.  Its filename is
     loop-add-ioctl-to-resize-a-loop-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: loop: add ioctl to resize a loop device
From: J. R. Okajima <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>

Add the ability to 'resize' the loop device on the fly.

One practical application is a loop file with XFS filesystem, already
mounted: You can easily enlarge the file (append some bytes) and then call
ioctl(fd, LOOP_SET_CAPACITY, new); The loop driver will learn about the
new size and you can use xfs_growfs later on, which will allow you to use
full capacity of the loop file without the need to unmount.

Test app:

----------------------------------------------------------------------
/*
 * Copyright (C) 2005-2008 Junjiro Okajima
 *
 * This program, aufs is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

/*
 * $Id: logrow.c,v 1.1 2008/11/17 01:59:40 sfjro Exp $
 */

#include <linux/fs.h>
#include <linux/loop.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define _GNU_SOURCE
#include <getopt.h>

char *me;

void usage(FILE *f)
{
	fprintf(f, "%s [options] loop_dev [backend_file]\n"
		"-s, --set new_size_in_bytes\n"
		"\twhen backend_file is given, "
		"it will be expanded too while keeping the original contents\n",
		me);
}

struct option opts[] = {
	{
		.name		= "set",
		.has_arg	= 1,
		.flag		= NULL,
		.val		= 's'
	},
	{
		.name		= "help",
		.has_arg	= 0,
		.flag		= NULL,
		.val		= 'h'
	}
};

void err_size(char *name, __u64 old)
{
	fprintf(stderr, "size must be larger than current %s (%llu)\n",
		name, old);
}

int main(int argc, char *argv[])
{
	int fd, err, c, i, bfd;
	ssize_t ssz;
	size_t sz;
	__u64 old, new, append;
	char a[BUFSIZ];
	struct stat st;
	FILE *out;
	char *backend, *dev;

	err = EINVAL;
	out = stderr;
	me = argv[0];
	new = 0;
	while ((c = getopt_long(argc, argv, "s:h", opts, &i)) != -1) {
		switch (c) {
		case 's':
			errno = 0;
			new = strtoull(optarg, NULL, 0);
			if (errno) {
				err = errno;
				perror(argv[i]);
				goto out;
			}
			break;

		case 'h':
			err = 0;
			out = stdout;
			goto err;

		default:
			perror(argv[i]);
			goto err;
		}
	}

	if (optind < argc)
		dev = argv[optind++];
	else
		goto err;

	fd = open(dev, O_RDONLY);
	if (fd < 0) {
		err = errno;
		perror(dev);
		goto out;
	}

	err = ioctl(fd, BLKGETSIZE64, &old);
	if (err) {
		err = errno;
		perror("ioctl BLKGETSIZE64");
		goto out;
	}

	if (!new) {
		printf("%llu\n", old);
		goto out;
	}

	if (new < old) {
		err = EINVAL;
		err_size(dev, old);
		goto out;
	}

	if (optind < argc) {
		backend = argv[optind++];
		bfd = open(backend, O_WRONLY|O_APPEND);
		if (bfd < 0) {
			err = errno;
			perror(backend);
			goto out;
		}
		err = fstat(bfd, &st);
		if (err) {
			err = errno;
			perror(backend);
			goto out;
		}
		if (new < st.st_size) {
			err = EINVAL;
			err_size(backend, st.st_size);
			goto out;
		}
		append = new - st.st_size;
		sz = sizeof(a);
		while (append > 0) {
			if (append < sz)
				sz = append;
			ssz = write(bfd, a, sz);
			if (ssz != sz) {
				err = errno;
				perror(backend);
				goto out;
			}
			append -= sz;
		}
		err = fsync(bfd);
		if (err) {
			err = errno;
			perror(backend);
			goto out;
		}
	}

	err = ioctl(fd, LOOP_SET_CAPACITY, new);
	if (err) {
		err = errno;
		perror("ioctl LOOP_SET_CAPACITY");
	}
	goto out;

 err:
	usage(out);
 out:
	return err;
}

Signed-off-by: J. R. Okajima <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Signed-off-by: Tomas Matejicek <tomas-VOkecuvH9Oc@public.gmane.org>
Cc: <util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 drivers/block/loop.c |   26 ++++++++++++++++++++++++++
 include/linux/loop.h |    1 +
 2 files changed, 27 insertions(+)

diff -puN drivers/block/loop.c~loop-add-ioctl-to-resize-a-loop-device drivers/block/loop.c
--- a/drivers/block/loop.c~loop-add-ioctl-to-resize-a-loop-device
+++ a/drivers/block/loop.c
@@ -1139,6 +1139,28 @@ loop_get_status64(struct loop_device *lo
 	return err;
 }
 
+static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
+{
+	int err;
+	sector_t sec;
+	loff_t sz;
+
+	err = -ENXIO;
+	if (unlikely(lo->lo_state != Lo_bound))
+		goto out;
+	err = figure_loop_size(lo);
+	if (unlikely(err))
+		goto out;
+	sec = get_capacity(lo->lo_disk);
+	sz = sec << 9;
+	mutex_lock(&bdev->bd_mutex);
+	bd_set_size(bdev, sz);
+	mutex_unlock(&bdev->bd_mutex);
+
+ out:
+	return err;
+}
+
 static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
@@ -1168,6 +1190,9 @@ static int lo_ioctl(struct block_device 
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_SET_CAPACITY:
+		err = loop_set_capacity(lo, bdev);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1313,6 +1338,7 @@ static int lo_compat_ioctl(struct block_
 			lo, (struct compat_loop_info __user *) arg);
 		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
+	case LOOP_SET_CAPACITY:
 	case LOOP_CLR_FD:
 	case LOOP_GET_STATUS64:
 	case LOOP_SET_STATUS64:
diff -puN include/linux/loop.h~loop-add-ioctl-to-resize-a-loop-device include/linux/loop.h
--- a/include/linux/loop.h~loop-add-ioctl-to-resize-a-loop-device
+++ a/include/linux/loop.h
@@ -160,5 +160,6 @@ int loop_unregister_transfer(int number)
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_SET_CAPACITY	0x4C07
 
 #endif
_

Patches currently in -mm which might be from hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org are

nfsd-fix-vm-overcommit-crash-fix-2.patch
loop-add-ioctl-to-resize-a-loop-device.patch

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
