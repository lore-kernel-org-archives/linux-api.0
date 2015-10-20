From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH RFC v3 2/2] pidns: introduce syscall getvpid
Date: Tue, 20 Oct 2015 13:04:23 +0300
Message-ID: <562611A7.7070606@yandex-team.ru>
References: <20150925135246.27620.97496.stgit@buzz>
 <20150925135247.27620.37109.stgit@buzz>
 <87d1x25vng.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d1x25vng.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 28.09.2015 19:57, Eric W. Biederman wrote:
> Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> writes:
>
>> If pid is negative then getvpid() returns pid of parent task for -pid.
>
> Now that I am noticing this.  I don't think I have seen any discussion
> about justifying a syscall getting another processes parent pid.  My
> apologies if I just missed it.
>

Sorry for late response. This completely fell out of my mind after LinuxCon.

> Why do we want the the parent pid?  We can we usefully do with it?
> Is proc really that bad of an interface?
>
> Fetching a parent pid feels like a separate logical operation
> from pid translation.  Which makes me a bit uneasy about this
> part of the conversation.

Yep proc interface is bad. /proc/$pid/stat is almost impossible to
parse without flaws because task could set second field "comm" into
any string and fake ppid  - for example ") Z 1". /proc/$pid/status
is better but it has more information and thus slower.

This trick for distant getppid looks cheap useful:
in this interface space of negative pids is free for use.

>
>> Examples:
>> getvpid(pid, ns, -1)      - get pid in our pid namespace
>> getvpid(pid, -1, ns)      - get pid in container
>> getvpid(pid, -1, ns) > 0  - is pid is reachable from container?
>> getvpid(1, ns1, ns2) > 0  - is ns1 inside ns2?
>> getvpid(1, ns1, ns2) == 0 - is ns1 outside ns2?
>> getvpid(1, ns, -1)        - get init task of pid-namespace
>> getvpid(-1, ns, -1)       - get reaper of init task in parent pid-namespace
>> getvpid(-pid, -1, -1)     - get ppid by pid
>
> As I step back and pay attention to this case I am half wondering if
> perhaps what would be most useful is a file descriptor that refers
> to a pid and an updated set of system calls that takes pid file
> descriptors instead of pids.

Fd which pins pids isn't a good idea.

I think it's better to refer (but not hold) task rather than pid.
For example inode of taskfd will hold small buffer for task exit
status: task holds reference to its own taskfd inode and populates
status when exits. Here will be no zombies and delayed reaping.

Something like:

task_fd = clonefd()
                      ...
select(...)
                      exit(...)
pread(task_fd, &status_rusage_etc, sizeof, 0);
close(task_fd);

Task pid also could be part of structure in that fd. Potentially it
could provide the same information as /proc/$pid/... in effective
binary format: we can read only required fields of structure and
kernel can skip unneeded calculations.

>
> Something like:
>
>      getpidfd(int pidnsfd, pid_t pid);
>
>      waitfd(int pidfd, int *status, int options, struct rusage *rusage);
>
>      killfd(int pidfd, int sig);
>
>      clonefd(...);
>
> And perhaps:
>      pid_nr_ns(int pidnsfd, int pidfd);
>
>      parentfd(int pidfd);
>
> Eric
>

-- 
Konstantin
