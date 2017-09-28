From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Thu, 28 Sep 2017 08:02:23 -0700
Message-ID: <CALCETrW_8BHRtL5qPr4JHe_7TptEwc_4ZoDiuhZZE6Ph979YKQ@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
 <20170926190018.GA30898@avx2> <CALCETrWTTe2X6O5HQMWJC84yXNBJ+eERJoDZMowq8X1L0q7pEQ@mail.gmail.com>
 <CAKgNAkh4LsGEQOconE8vF9xD1ix1+MPqvrOa0ozvgjB+S2tQPw@mail.gmail.com> <CACVxJT_B4m-O66haETWkFVx5AgGqDbM-K-53odJ0bRp0_2xhrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACVxJT_B4m-O66haETWkFVx5AgGqDbM-K-53odJ0bRp0_2xhrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 28, 2017 at 3:55 AM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 9/28/17, Michael Kerrisk (man-pages) <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 27 September 2017 at 17:03, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
>>>> The idea is to start process. In ideal world, only bynary system calls
>>>> would exist and shells could emulate /proc/* same way bash implement
>>>> /dev/tcp
>>>
>>> Then start the process by doing it for real and making it obviously
>>> useful.  We should not add a pair of vaguely useful, rather weak
>>> syscalls just to start a process of modernizing /proc.
>
> Before doing it for real it would be nice to have at least a nod
> from people in charge that syscalls which return binary
> information are OK. Otherwise some EIATF guy will just say
> "NAK /proc is fine, it always was fine".

There's nothing inherently wrong with syscalls that return binary
information.  There is something wrong with reinventing the world with
insufficient justification, though.

/proc may be old, clunky, and kind of slow, but it has a lot of good
things going for it.  It supports access control (DAC and MAC).  It
handles namespacing in a way that's awkward but supported by all the
existing namespace managers.  It may soon support mount options, which
is rather important.

I feel like we've been discussing this performance issue for over a
year, and I distinctly recall discussing it in Santa Fe.  I suggested
a two-pronged approach:

1. Add a new syscall that will, in a single call, open, read, and
close a proc file and maybe even a regular non-proc file.  Like this:

long readfileat(int dirfd, const char *path, void *buf, size_t len, int flags);

2. Where needed, add new /proc files with lighter-weight
representations.  I think we discussed something that's like status
but in nl_attr format.

This doesn't end up with a bunch of code duplication the way that a
full-blown syscall-based reimplementation would.  It supports all the
/proc features rather than just a subset.  It fully respects access
control, future mount options, and the potential lack of a /proc
mount.

>
> Or look from another angle: sched_setaffinity exists but there is
> no /proc counterpart, shells must use taskset(1) and world didn't end.

sched_setaffinity() modifies the caller.  /proc wouldn't have made much sense.

>
>> I concur.
>>
>> Alexey, you still have not wxplained who specifically needs this
>> right now, and how, precisely, they plan to use the new system calls.
>> It is all very arm-wavey so far.
>
> It is not if you read even example program in the original patch.
> Any program which queries information about file descriptors
> will benefit both in CPU and memory usage.
>
> void closefrom(int start)
> {
>         int fd[1024];
>         int n;
>
>         while ((n = fdmap(0, fd, sizeof(fd)/sizeof(fd[0]), start)) > 0) {
>                 unsigned int i;
>
>                 for (i = 0; i < n; i++)
>                         close(fd[i]);
>
>                 start = fd[n - 1] + 1;
>         }
> }
>
> CRIU naturally to know everything about descriptors of target processes:
> It does:
>
> int predump_task_files(int pid)
> {
>         struct dirent *de;
>         DIR *fd_dir;
>         int ret = -1;
>
>         pr_info("Pre-dump fds for %d)\n", pid);
>
>         fd_dir = opendir_proc(pid, "fd");
>         if (!fd_dir)
>                 return -1;
>
>         while ((de = readdir(fd_dir))) {
>                 if (dir_dots(de))
>                         continue;
>
>                 if (predump_one_fd(pid, atoi(de->d_name)))
>                         goto out;
>         }
>
>         ret = 0;
> out:
>         closedir(fd_dir);
>         return ret;
> }
>
> which is again inefficient.

And /proc/PID/fds would solve this.
