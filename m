From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 2/2] pidmap(2)
Date: Sun, 24 Sep 2017 14:27:00 -0700
Message-ID: <CALCETrWTJmfS6gBHonKFUKYMtcXuQ9XXmWRdP0aP9Mpv7J9=nw@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20170924200822.GB24368@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924200822.GB24368@avx2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Sep 24, 2017 at 1:08 PM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
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
>
> It could be used by programs like ps, top or CRIU. Speed increase will
> become more drastic once combined with bulk retrieval of process statisti=
cs.
>
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
>
> PIDMAP_* flags are modelled after /proc/task_diag patchset.
>
>
> PIDMAP(2)                  Linux Programmer's Manual                 PIDM=
AP(2)
>
> NAME
>        pidmap - get allocated PIDs
>
> SYNOPSIS
>        long pidmap(pid_t pid, int *pids, unsigned int count , unsigned in=
t start, int flags);

I think we will seriously regret a syscall that does this.  Djalal is
working on fixing the turd that is hidepid, and this syscall is
basically incompatible with ever fixing hidepids.  I think that, to
make it less regrettable, it needs to take an fd to a proc mount as a
parameter.  This makes me wonder why it's a syscall at all -- why not
just create a new file like /proc/pids?

--Andy
