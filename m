From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v9][PATCH 00/13] Kernel based checkpoint/restart
Date: Tue, 11 Nov 2008 23:03:19 -0600
Message-ID: <20081112050319.GA3687@us.ibm.com>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1226335060-7061-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org):
> Checkpoint-restart (c/r): v9 adds support for multiple processes.
> (rebase to v2.6.28-rc3).
> 
> We'd like to see these make their way into -mm. All comments have
> been addressed in this version. Please pull at least the first 11
> patches, as they are similar to before.

With the trivial fix to patch 5 I sent earlier, I've been running the
following e2loop.sh for a few hours with no problems (the counter is at
2412).  Also did 500 concurrent checkpoints of the same process.

Oren, can you re-post an updated patch 5?

Andrew, would you mind (once Oren reposts patch 5) giving the
first 11 patches a chance in -mm?

thanks,
-serge

===============
e2loop.sh:
===============
cnt=1
/usr/src/ns_exec -m /root/e2 &
while [ 1 ]; do
        /usr/src/cr `pidof e2` o.$cnt
        kill -9 `pidof e2`
        echo 5 > /root/e2out
        cntin=`cat /root/e2out`
        echo "i reset e2out to $cntin"
        #/usr/src/rstr < /root/o.$cnt &
        /usr/src/ns_exec -m /usr/src/rstr /root/o.$cnt &
        cnt=$((cnt+1))
        sleep 10
        cntin=`cat /root/e2out`
        echo "cnt is $cnt, e2out has $cntin"
done

===============
e2.c:
===============
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
	int cnt=0;
	FILE *f;
	char fnam[20];

	close(0); close(1); close(2); close(3);
	f = fopen("e2out", "r");
	if (!f)
		cnt = 1;
	else {
		fscanf(f, "%d", &cnt);
		fclose(f);
	}
	for (;;) {
		sleep(5);
		f = fopen("e2out", "w");
		if (!f)
			return 1;
		fprintf(f, "%d", ++cnt);
		fclose(f);
	}
	return 0;
}
