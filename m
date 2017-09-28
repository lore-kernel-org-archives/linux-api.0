From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Thu, 28 Sep 2017 09:26:44 +0200
Message-ID: <CAKgNAkh4LsGEQOconE8vF9xD1ix1+MPqvrOa0ozvgjB+S2tQPw@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
 <20170926190018.GA30898@avx2> <CALCETrWTTe2X6O5HQMWJC84yXNBJ+eERJoDZMowq8X1L0q7pEQ@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWTTe2X6O5HQMWJC84yXNBJ+eERJoDZMowq8X1L0q7pEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 27 September 2017 at 17:03, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, Sep 26, 2017 at 12:00 PM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>> On Mon, Sep 25, 2017 at 09:42:58AM +0200, Michael Kerrisk (man-pages) wr=
ote:
>>> [Not sure why original author is not in CC; added]
>>>
>>> Hello Alexey,
>>>
>>> On 09/24/2017 10:06 PM, Alexey Dobriyan wrote:
>>> > From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
>>> >
>>> > Implement system call for bulk retrieveing of opened descriptors
>>> > in binary form.
>>> >
>>> > Some daemons could use it to reliably close file descriptors
>>> > before starting. Currently they close everything upto some number
>>> > which formally is not reliable. Other natural users are lsof(1) and C=
RIU
>>> > (although lsof does so much in /proc that the effect is thoroughly bu=
ried).
>>> >
>>> > /proc, the only way to learn anything about file descriptors may not =
be
>>> > available. There is unavoidable overhead associated with instantiatin=
g
>>> > 3 dentries and 3 inodes and converting integers to strings and back.
>>> >
>>> > Benchmark:
>>> >
>>> >     N=3D1<<22 times
>>> >     4 opened descriptors (0, 1, 2, 3)
>>> >     opendir+readdir+closedir /proc/self/fd vs fdmap
>>> >
>>> >     /proc 8.31 =C4=85 0.37%
>>> >     fdmap 0.32 =C4=85 0.72%
>>>
>>> From the text above, I'm still trying to understand: whose problem
>>> does this solve? I mean, we've lived with the daemon-close-all-files
>>> technique forever (and I'm not sure that performance is really an
>>> important issue for the daemon case) .
>>
>>> And you say that the effect for lsof(1) will be buried.
>>
>> If only fdmap(2) is added, then effect will be negligible for lsof
>> because it has to go through /proc anyway.
>>
>> The idea is to start process. In ideal world, only bynary system calls
>> would exist and shells could emulate /proc/* same way bash implement
>> /dev/tcp
>
> Then start the process by doing it for real and making it obviously
> useful.  We should not add a pair of vaguely useful, rather weak
> syscalls just to start a process of modernizing /proc.

I concur.

Alexey, you still have not wxplained who specifically needs this
right now, and how, precisely, they plan to use the new system calls.
It is all very arm-wavey so far.

Thanks,

Michael
