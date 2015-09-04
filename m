From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 3/3] kselftest/inotify: add inotify_update_watch(2)
 test-cases
Date: Fri, 04 Sep 2015 16:42:17 +1000
Message-ID: <1441348937.13721.5.camel@ellerman.id.au>
References: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
	 <1441293027-3363-4-git-send-email-dh.herrmann@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441293027-3363-4-git-send-email-dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-09-03 at 17:10 +0200, David Herrmann wrote:
> diff --git a/tools/testing/selftests/inotify/Makefile b/tools/testing/selftests/inotify/Makefile
> new file mode 100644
> index 0000000..c205abb
> --- /dev/null
> +++ b/tools/testing/selftests/inotify/Makefile
> @@ -0,0 +1,14 @@
> +CC = $(CROSS_COMPILE)gcc

You don't need this, it's in lib.mk already.

> +CFLAGS += -I../../../../include/uapi/
> +CFLAGS += -I../../../../include/

Please don't include the unexported kernel headers in userspace programs.

It will sometimes work, but often not.

> +CFLAGS += -I../../../../usr/include/

This is good, it allows the test to build against the exported kernel headers, in
their default install location (usr/include). To install them run 'make
headers_install' in the top-level of the kernel tree.

It is sufficient to get the new syscall numbers you need, and is usually safe.

> +all:
> +	$(CC) $(CFLAGS) test_inotify.c -o test_inotify
> +
> +TEST_PROGS := test_inotify

You don't need to spell out the all rule, this is sufficient:

TEST_PROGS := test_inotify

all: $(TEST_PROGS)

> +
> +include ../lib.mk
> +
> +clean:
> +	$(RM) test_inotify test_file

You should either add a leading "-", or make this rm -f, so that when the files
don't exist rm doesn't give you an error.

> diff --git a/tools/testing/selftests/inotify/test_inotify.c b/tools/testing/selftests/inotify/test_inotify.c
> new file mode 100644
> index 0000000..094420a
> --- /dev/null
> +++ b/tools/testing/selftests/inotify/test_inotify.c
> @@ -0,0 +1,105 @@
> +/*
> + * inotify tests
> + */
> +
> +#define _GNU_SOURCE
> +#define __EXPORTED_HEADERS__

Please don't do that.

> +
> +#include <assert.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <inttypes.h>
> +#include <limits.h>
> +#include <linux/unistd.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/inotify.h>
> +#include <sys/syscall.h>
> +#include <unistd.h>
> +
> +#define TEST_FILE "./test_file"
> +
> +static int sys_inotify_update_watch(int fd, uint32_t wd, uint32_t mask)
> +{
> +	return syscall(__NR_inotify_update_watch, fd, wd, mask);
> +}
> +
> +static int read_inotify(int fd, struct inotify_event **out)
> +{
> +	union {
> +		struct inotify_event event;
> +		char buffer[sizeof(struct inotify_event) + NAME_MAX + 1];
> +	} buf;
> +	int r;
> +
> +	r = read(fd, &buf, sizeof(buf));
> +	if (r < 0)
> +		return r;
> +
> +	assert(r >= sizeof(struct inotify_event) && r <= sizeof(buf));
> +	*out = &buf.event;
> +	return r;
> +}
> +
> +/* test inotify_update_watch(2) */
> +static void test_update(void)
> +{
> +	struct inotify_event *event;
> +	int ifd, wd, fd, r;
> +
> +	ifd = inotify_init1(IN_CLOEXEC | IN_NONBLOCK);
> +	assert(ifd >= 0);
> +
> +	unlink(TEST_FILE);
> +
> +	/* try adding watch on non-existant file */
> +	wd = inotify_add_watch(ifd, TEST_FILE, IN_IGNORED);
> +	assert(wd < 0 && errno == ENOENT);
> +
> +	/* create file */
> +	fd = open(TEST_FILE, O_CREAT | O_CLOEXEC | O_EXCL, S_IRUSR);
> +	assert(fd >= 0);
> +
> +	/* add watch descriptor without IN_CLOSE */
> +	wd = inotify_add_watch(ifd, TEST_FILE, IN_IGNORED);
> +	assert(wd > 0);
> +
> +	/* close file */
> +	close(fd);
> +
> +	/* should not have gotten any event */
> +	r = read_inotify(ifd, &event);
> +	assert(r < 0 && errno == EAGAIN);
> +
> +	/* reopen file */
> +	fd = open(TEST_FILE, O_CLOEXEC | O_EXCL);
> +	assert(fd >= 0);
> +
> +	/* invalid flags must result in EINVAL */
> +	r = sys_inotify_update_watch(ifd, wd, -1);
> +	assert(r < 0 && errno == EINVAL);
> +
> +	/* update watch descriptor with IN_CLOSE */
> +	r = sys_inotify_update_watch(ifd, wd, IN_MASK_ADD | IN_CLOSE);
> +	assert(r >= 0);
> +
> +	/* close file */
> +	close(fd);
> +
> +	/* now we should have seen the event */
> +	r = read_inotify(ifd, &event);
> +	assert(r >= 0);
> +	assert(event->wd == wd);
> +	assert(event->mask & IN_CLOSE);
> +
> +	unlink(TEST_FILE);
> +	close(ifd);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	test_update();
> +	return 0;
> +}

You may as well just drop test_update() and put the whole test in main() ?

cheers
