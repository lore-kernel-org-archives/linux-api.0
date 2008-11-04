From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v8][PATCH 0/12] Kernel based checkpoint/restart
Date: Tue, 4 Nov 2008 12:44:36 -0600
Message-ID: <20081104184436.GA16328@us.ibm.com>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1225374675-22850-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org):
> Basic checkpoint-restart [C/R]: v8 adds support for "external" checkpoint
> and improves documentation. Older announcements below.

The following test-program seems to reliably trigger a bug.  Run it in a
new set of namespaces, i.e.
	ns_exec -cmpiuU ./runme > /tmp/o
then control-c it.  The second time I do that, I get the dcache.c:666
BUG().

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/syscall.h>

#define __NR_checkpoint 333
int main (int argc, char *argv[])
{
	pid_t pid = getpid();
	int ret;

	close(0); close(2);
	ret = syscall (__NR_checkpoint, pid, STDOUT_FILENO, 0);

	if (ret < 0)
		perror ("checkpoint");
	else
		printf ("checkpoint id %d\n", ret);

	sleep(200);
	return (ret > 0 ? 0 : 1);
}

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
