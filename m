From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Thu, 28 Sep 2017 12:55:49 +0200
Message-ID: <CACVxJT_B4m-O66haETWkFVx5AgGqDbM-K-53odJ0bRp0_2xhrQ@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
 <20170926190018.GA30898@avx2> <CALCETrWTTe2X6O5HQMWJC84yXNBJ+eERJoDZMowq8X1L0q7pEQ@mail.gmail.com>
 <CAKgNAkh4LsGEQOconE8vF9xD1ix1+MPqvrOa0ozvgjB+S2tQPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkh4LsGEQOconE8vF9xD1ix1+MPqvrOa0ozvgjB+S2tQPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Djalal Harouni <tixxdz@gmail.com>, Alexey Gladkov <gladkov.alexey@gmail.com>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>, Tatsiana Brouka <Tatsiana_Brouka@epam.com>
List-Id: linux-api@vger.kernel.org

On 9/28/17, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
> On 27 September 2017 at 17:03, Andy Lutomirski <luto@amacapital.net> wrote:

>>> The idea is to start process. In ideal world, only bynary system calls
>>> would exist and shells could emulate /proc/* same way bash implement
>>> /dev/tcp
>>
>> Then start the process by doing it for real and making it obviously
>> useful.  We should not add a pair of vaguely useful, rather weak
>> syscalls just to start a process of modernizing /proc.

Before doing it for real it would be nice to have at least a nod
from people in charge that syscalls which return binary
information are OK. Otherwise some EIATF guy will just say
"NAK /proc is fine, it always was fine".

Or look from another angle: sched_setaffinity exists but there is
no /proc counterpart, shells must use taskset(1) and world didn't end.

> I concur.
>
> Alexey, you still have not wxplained who specifically needs this
> right now, and how, precisely, they plan to use the new system calls.
> It is all very arm-wavey so far.

It is not if you read even example program in the original patch.
Any program which queries information about file descriptors
will benefit both in CPU and memory usage.

void closefrom(int start)
{
	int fd[1024];
	int n;

	while ((n = fdmap(0, fd, sizeof(fd)/sizeof(fd[0]), start)) > 0) {
		unsigned int i;

		for (i = 0; i < n; i++)
			close(fd[i]);

		start = fd[n - 1] + 1;
	}
}

CRIU naturally to know everything about descriptors of target processes:
It does:

int predump_task_files(int pid)
{
        struct dirent *de;
        DIR *fd_dir;
        int ret = -1;

        pr_info("Pre-dump fds for %d)\n", pid);

        fd_dir = opendir_proc(pid, "fd");
        if (!fd_dir)
                return -1;

        while ((de = readdir(fd_dir))) {
                if (dir_dots(de))
                        continue;

                if (predump_one_fd(pid, atoi(de->d_name)))
                        goto out;
        }

        ret = 0;
out:
        closedir(fd_dir);
        return ret;
}

which is again inefficient.
