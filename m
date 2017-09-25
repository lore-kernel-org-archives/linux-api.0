From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] pidmap(2)
Date: Mon, 25 Sep 2017 11:47:35 +0100
Message-ID: <CAEiveUdC6PLy0Gp-NYpzozwRS2GhSzaXLsdwQ-d+nXnry09C=w@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20170924200822.GB24368@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924200822.GB24368@avx2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Alexey,

On Sun, Sep 24, 2017 at 9:08 PM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> From: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>
>
> Implement system call for bulk retrieveing of pids in binary form.
>
> Using /proc is slower than necessary: 3 syscalls + another 3 for each thr=
ead +
> converting with atoi() + instantiating dentries and inodes.
>
> /proc may be not mounted especially in containers. Natural extension of
> hidepid=3D2 efforts is to not mount /proc at all.

Actually I am not sure if software will work if /proc is not mounted,
last time (years) I
checked glibc was doing extra checks during initialization using
/proc/self/* memory
inodes and it may fail. Also fexecve() glibc is implemented using
/proc/self/... so it
depends on which library and the use case for cloud containers...

Also for the natural extension of hidepid=3D2 where we only want pids insid=
e /proc
without kernel data, we have already a clean patch on top of the procfs
modernization [1] , this is the result of the previous months.


>
> It could be used by programs like ps, top or CRIU. Speed increase will
> become more drastic once combined with bulk retrieval of process statisti=
cs.

Yes the numbers are nice, seems that you want to move from filesystem sysca=
lls
on procfs, to only use direct syscalls, hmm this does not help to fix
procfs. Tools
like ps, top and others can be updated, but anyone can *continue* to use
open+read on procfs and access the data.

I think this will be a bit hard to fix from our side, since with your
patches you are
doing it from current context, where from procfs it will be from:
current+procfs mount context.

What if procfs is mounted with "ptracepids=3Dtrue" the new "hidepid=3D" but=
 whithout
"gid=3D" interaction, and then you read from /proc/<pid>/pidmap/* as sugges=
ted
by Andy ? /proc/<pid>/pidmap/{tasks|proc|children} I am not sure about the
PIDMAP_IGNORE_KTHREADS case...


> Benchmark:
>
>         N=3D1<<16 times
>         ~130 processes (~250 task_structs) on a regular desktop system
>         opendir + readdir + closedir /proc + the same for every /proc/$PI=
D/task
>         (roughly what htop(1) does) vs pidmap
>
>         /proc 16.80 =C2=B1 0.73%
>         pidmap 0.06 =C2=B1 0.31%

Thanks!


[1]  https://github.com/legionus/linux/commit/993a2a5b9af95b0ac901ff41d3212=
4b72ed676e3

P.S. for the procfs modernization we are planning patches next days.

--=20
tixxdz
