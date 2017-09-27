From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 2/2] pidmap(2)
Date: Wed, 27 Sep 2017 08:04:26 -0700
Message-ID: <CALCETrUJbVSPTpVqmHRTcELUCjAnQWVcsG7urcQgoHv13a+aOQ@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20170924200822.GB24368@avx2>
 <CALCETrWTJmfS6gBHonKFUKYMtcXuQ9XXmWRdP0aP9Mpv7J9=nw@mail.gmail.com> <20170926184643.GC14724@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170926184643.GC14724@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Djalal Harouni <tixxdz@gmail.com>, Alexey Gladkov <gladkov.alexey@gmail.com>, Tatsiana Brouka <Tatsiana_Brouka@epam.com>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 26, 2017 at 11:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wro=
te:
> On Sun, Sep 24, 2017 at 02:27:00PM -0700, Andy Lutomirski wrote:
>> On Sun, Sep 24, 2017 at 1:08 PM, Alexey Dobriyan <adobriyan@gmail.com> w=
rote:
>> > From: Tatsiana Brouka <Tatsiana_Brouka@epam.com>
>> >
>> > Implement system call for bulk retrieveing of pids in binary form.
>> >
>> > Using /proc is slower than necessary: 3 syscalls + another 3 for each =
thread +
>> > converting with atoi() + instantiating dentries and inodes.
>> >
>> > /proc may be not mounted especially in containers. Natural extension o=
f
>> > hidepid=3D2 efforts is to not mount /proc at all.
>> >
>> > It could be used by programs like ps, top or CRIU. Speed increase will
>> > become more drastic once combined with bulk retrieval of process stati=
stics.
>> >
>> > Benchmark:
>> >
>> >         N=3D1<<16 times
>> >         ~130 processes (~250 task_structs) on a regular desktop system
>> >         opendir + readdir + closedir /proc + the same for every /proc/=
$PID/task
>> >         (roughly what htop(1) does) vs pidmap
>> >
>> >         /proc 16.80 =C4=85 0.73%
>> >         pidmap 0.06 =C4=85 0.31%
>> >
>> > PIDMAP_* flags are modelled after /proc/task_diag patchset.
>> >
>> >
>> > PIDMAP(2)                  Linux Programmer's Manual                 P=
IDMAP(2)
>> >
>> > NAME
>> >        pidmap - get allocated PIDs
>> >
>> > SYNOPSIS
>> >        long pidmap(pid_t pid, int *pids, unsigned int count , unsigned=
 int start, int flags);
>>
>> I think we will seriously regret a syscall that does this.  Djalal is
>> working on fixing the turd that is hidepid, and this syscall is
>> basically incompatible with ever fixing hidepids.  I think that, to
>> make it less regrettable, it needs to take an fd to a proc mount as a
>> parameter.  This makes me wonder why it's a syscall at all -- why not
>> just create a new file like /proc/pids?
>
> See reply to fdmap(2).
>
> pidmap(2) is indeed more complex case exactly because of
> pid/tgid/tid/everything else + pidnamespaces + ->hide_pid.
> However the problem remains: query task tree without all the bullshit.
> C/R people succumbed with /proc/*/children, it was a mistake IMO.

Your syscall cannot be implemented sanely.  It doesn't remove bullshit
-- it adds bullshit.  NAK.
