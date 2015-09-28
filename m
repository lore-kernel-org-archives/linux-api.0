From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH RFC v3 2/2] pidns: introduce syscall getvpid
Date: Mon, 28 Sep 2015 11:57:39 -0500
Message-ID: <87d1x25vng.fsf@x220.int.ebiederm.org>
References: <20150925135246.27620.97496.stgit@buzz>
	<20150925135247.27620.37109.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150925135247.27620.37109.stgit@buzz> (Konstantin Khlebnikov's
	message of "Fri, 25 Sep 2015 16:52:47 +0300")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> writes:

> If pid is negative then getvpid() returns pid of parent task for -pid.

Now that I am noticing this.  I don't think I have seen any discussion
about justifying a syscall getting another processes parent pid.  My
apologies if I just missed it.

Why do we want the the parent pid?  We can we usefully do with it?
Is proc really that bad of an interface?

Fetching a parent pid feels like a separate logical operation
from pid translation.  Which makes me a bit uneasy about this
part of the conversation.

> Examples:
> getvpid(pid, ns, -1)      - get pid in our pid namespace
> getvpid(pid, -1, ns)      - get pid in container
> getvpid(pid, -1, ns) > 0  - is pid is reachable from container?
> getvpid(1, ns1, ns2) > 0  - is ns1 inside ns2?
> getvpid(1, ns1, ns2) == 0 - is ns1 outside ns2?
> getvpid(1, ns, -1)        - get init task of pid-namespace
> getvpid(-1, ns, -1)       - get reaper of init task in parent pid-namespace
> getvpid(-pid, -1, -1)     - get ppid by pid

As I step back and pay attention to this case I am half wondering if
perhaps what would be most useful is a file descriptor that refers
to a pid and an updated set of system calls that takes pid file
descriptors instead of pids.

Something like:

    getpidfd(int pidnsfd, pid_t pid);
    
    waitfd(int pidfd, int *status, int options, struct rusage *rusage);
    
    killfd(int pidfd, int sig);
    
    clonefd(...);
    
And perhaps:
    pid_nr_ns(int pidnsfd, int pidfd);

    parentfd(int pidfd);

Eric
