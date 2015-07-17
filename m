From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/2] capabilities: Ambient capabilities
Date: Fri, 17 Jul 2015 15:40:57 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507171539590.13763@east.gentwo.org>
References: <cover.1436903028.git.luto@kernel.org> <9f660ee708e58892bfa7012b6b9c840298e24544.1436903028.git.luto@kernel.org> <alpine.LRH.2.11.1507152033420.8351@namei.org> <CALCETrWMBZ0p7P1FvtrYp5ChJXvvRzy0JpjS8KwUUa5m9gqgQA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWMBZ0p7P1FvtrYp5ChJXvvRzy0JpjS8KwUUa5m9gqgQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is a test program that can be used to verify the functionality.


------ ambient_test.c -----------------------


/*
 * Test program for the ambient capabilities. This program spawns a shell
 * that allows running processes with a defined set of capabilities.
 *
 * (C) 2015 Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
 * Released under: GPL v3 or later.
 *
 *
 * Compile using:
 *
 *	gcc -o ambient_test ambient_test.o -lcap-ng
 *
 * This program must have the following capabilities to run properly:
 * Permissions for CAP_NET_RAW, CAP_NET_ADMIN, CAP_SYS_NICE
 *
 * A command to equip the binary with the right caps is:
 *
 *	setcap cap_net_raw,cap_net_admin,cap_sys_nice+p ambient_test
 *
 *
 * To get a shell with additional caps that can be inherited by other processes:
 *
 *	./ambient_test /bin/bash
 *
 *
 * Verifying that it works:
 *
 * From the bash spawed by ambient_test run
 *
 *	cat /proc/$$/status
 *
 * and have a look at the capabilities.
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <cap-ng.h>
#include <sys/prctl.h>
#include <linux/capability.h>

/*
 * Definitions from the kernel header files. These are going to be removed
 * when the /usr/include files have these defined.
 */
#define PR_CAP_AMBIENT 47
#define PR_CAP_AMBIENT_IS_SET 1
#define PR_CAP_AMBIENT_RAISE 2
#define PR_CAP_AMBIENT_LOWER 3
#define PR_CAP_AMBIENT_CLEAR_ALL 4

static void set_ambient_cap(int cap)
{
	int rc;

	capng_get_caps_process();
	rc = capng_update(CAPNG_ADD, CAPNG_INHERITABLE, cap);
	if (rc) {
		printf("Cannot add inheritable cap\n");
		exit(2);
	}
	capng_apply(CAPNG_SELECT_CAPS);

	/* Note the two 0s at the end. Kernel checks for these */
	if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, cap, 0, 0)) {
		perror("Cannot set cap");
		exit(1);
	}
}

int main(int argc, char **argv)
{
	int rc;

	set_ambient_cap(CAP_NET_RAW);
	set_ambient_cap(CAP_NET_ADMIN);
	set_ambient_cap(CAP_SYS_NICE);

	printf("Ambient_test forking shell\n");
	if (execv(argv[1], argv + 1))
		perror("Cannot exec");

	return 0;
}
