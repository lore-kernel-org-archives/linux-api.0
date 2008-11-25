From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: [take2] Inotify: nested attributes test application.
Date: Tue, 25 Nov 2008 22:44:20 +0300
Message-ID: <20081125194420.GA24835@ioremap.net>
References: <20081125194234.GA24449@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081125194234.GA24449-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>, David Newall <davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

$ ./iotest -h
Usage: ./iotest -f path -t <tid> -p <pid> -i <io details> -n <name> -h <help>

$ ./iotest -f /tmp/ -t -i
2008-11-25 22:40:30.201286 pid: 1928, tid: 1928, name: /tmp/, wd: 1, mask: 303, attributes: pid: 0, tid: 1, io: 1, name: 0.
event: 2, wd: 1, cookie: 0, len: 36.
	tid: 1672.
	io details: start: 0, size: 0.

$ echo qwe11 > /tmp/test

-- 
	Evgeniy Polyakov

--mYCpIKhGyMATD0i+
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="iotest.c"

/*
 * 2007+ Copyright (c) Evgeniy Polyakov <johnpol-9fLWQ3dKdXwox3rIn2DAYQ@public.gmane.org>
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#define _GNU_SOURCE
#define __USE_FILE_OFFSET64
#define __USE_LARGEFILE64
#define _FILE_OFFSET_BITS	64

#include <sys/ioctl.h>
#include <sys/time.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>
#include <stdarg.h>

#include <linux/types.h>
#include <linux/inotify.h>
#include <linux/unistd.h>

#include <asm/unistd.h>

extern int inotify_add_watch(int __fd, const char *__name, unsigned int __mask);

void iotest_log(const char *f, ...)
{
	char str[64];
	struct tm tm;
	struct timeval tv;
	va_list ap;

	gettimeofday(&tv, NULL);
	localtime_r((time_t *)&tv.tv_sec, &tm);
	strftime(str, sizeof(str), "%F %R:%S", &tm);

	fprintf(stderr, "%s.%lu ", str, tv.tv_usec);

	va_start(ap, f);
	vfprintf(stderr, f, ap);
	va_end(ap);

	fflush(stderr);
}

#define iotest_err(f, a...) iotest_log(f ": %s [%d].\n", ##a, strerror(errno), errno)

static void iotest_usage(char *p)
{
	fprintf(stderr, "Usage: %s -f path -t <tid> -p <pid> -i <io details> -n <name> -h <help>\n", p);
}

int main(int argc, char *argv[])
{
	int fd, ch, err;
	int tid, pid, io, name, wd;
	char *file;
	unsigned int mask;
	char buf[4096];
	void *data;
	struct inotify_event *e;
	struct inotify_attribute *a;
	struct inotify_io_details *det;
	unsigned int id;

	file = NULL;
	tid = 0;
	pid = 0;
	io = 0;
	name = 0;

	while ((ch = getopt(argc, argv, "f:tpinh")) != -1) {
		switch (ch) {
			case 'f':
				file = optarg;
				break;
			case 't':
				tid = 1;
				break;
			case 'p':
				pid = 1;
				break;
			case 'i':
				io = 1;
				break;
			case 'n':
				name = 1;
				break;
			case 'h':
			default:
				iotest_usage(argv[0]);
				return -1;
		}
	}

	if (!file) {
		fprintf(stderr, "You have to provide file to watch IO against.\n");
		iotest_usage(argv[0]);
		return -1;
	}

	fd = syscall(__NR_inotify_init1, IN_ATTRS);
	if (fd < 0) {
		iotest_err("Failed to call inotify_init1");
		return -1;
	}

	if (tid) {
		id = INOTIFY_ATTR_TID;
		err = ioctl(fd, TIOCSETD, &id, 4);
		if (err) {
			iotest_err("Failed to setup TID attribute");
			return err;
		}
	}
	
	if (pid) {
		id = INOTIFY_ATTR_PID;
		err = ioctl(fd, TIOCSETD, &id, 4);
		if (err) {
			iotest_err("Failed to setup PID attribute");
			return err;
		}
	}
	
	if (io) {
		id = INOTIFY_ATTR_IO;
		err = ioctl(fd, TIOCSETD, &id, 4);
		if (err) {
			iotest_err("Failed to setup IO attribute");
			return err;
		}
	}
	
	if (name) {
		id = INOTIFY_ATTR_NAME;
		err = ioctl(fd, TIOCSETD, &id, 4);
		if (err) {
			iotest_err("Failed to setup name attribute");
			return err;
		}
	}

	mask = IN_MODIFY | IN_CREATE | IN_DELETE | IN_ACCESS;
	wd = inotify_add_watch(fd, file, mask);
	if (wd < 0) {
		iotest_err("Failed to add %x watch for file '%s'", mask, file);
		return -1;
	}

	iotest_log("pid: %d, tid: %d, name: %s, wd: %d, mask: %x, attributes: "
			"pid: %d, tid: %d, io: %d, name: %d.\n",
			getpid(), syscall(__NR_gettid), file, wd, mask,
			pid, tid, io, name);

	while (1) {
		sleep(5);
		data = buf;
		err = read(fd, buf, sizeof(buf));
		if (err <= 0) {
			iotest_err("Failed to read event");
			return err;
		}

		e = data;
		printf("event: %x, wd: %d, cookie: %u, len: %u.\n", e->mask, e->wd, e->cookie, e->len);

		data += sizeof(struct inotify_event);
		while (e->len) {
			a = data;

			switch (a->id) {
				case INOTIFY_ATTR_PID:
					id = *(unsigned int *)a->data;
					printf("       pid: %u.\n", id);
					break;
				case INOTIFY_ATTR_TID:
					id = *(unsigned int *)a->data;
					printf("       tid: %u.\n", id);
					break;
				case INOTIFY_ATTR_IO:
					det = (struct inotify_io_details *)a->data;
					printf("       io details: start: %llu, size: %llu.\n",
							(unsigned long long)det->start,
							(unsigned long long)det->size);
					break;
				case INOTIFY_ATTR_NAME:
					printf("       name: %s.\n", (char *)a->data);
					break;
				default:
					printf("       unsupported id: %u, size: %u.\n", a->id, a->size);
					break;
			}

			data += a->size + sizeof(struct inotify_attribute);
			e->len -= a->size + sizeof(struct inotify_attribute);
		}
	}

	close(fd);
	return 0;
}


--mYCpIKhGyMATD0i+--
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
