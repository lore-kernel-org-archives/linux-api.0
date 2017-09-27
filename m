From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Wed, 27 Sep 2017 08:03:42 -0700
Message-ID: <CALCETrWTTe2X6O5HQMWJC84yXNBJ+eERJoDZMowq8X1L0q7pEQ@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
 <20170926190018.GA30898@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926190018.GA30898@avx2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>, Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 26, 2017 at 12:00 PM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Mon, Sep 25, 2017 at 09:42:58AM +0200, Michael Kerrisk (man-pages) wro=
te:
>> [Not sure why original author is not in CC; added]
>>
>> Hello Alexey,
>>
>> On 09/24/2017 10:06 PM, Alexey Dobriyan wrote:
>> > From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
>> >
>> > Implement system call for bulk retrieveing of opened descriptors
>> > in binary form.
>> >
>> > Some daemons could use it to reliably close file descriptors
>> > before starting. Currently they close everything upto some number
>> > which formally is not reliable. Other natural users are lsof(1) and CR=
IU
>> > (although lsof does so much in /proc that the effect is thoroughly bur=
ied).
>> >
>> > /proc, the only way to learn anything about file descriptors may not b=
e
>> > available. There is unavoidable overhead associated with instantiating
>> > 3 dentries and 3 inodes and converting integers to strings and back.
>> >
>> > Benchmark:
>> >
>> >     N=3D1<<22 times
>> >     4 opened descriptors (0, 1, 2, 3)
>> >     opendir+readdir+closedir /proc/self/fd vs fdmap
>> >
>> >     /proc 8.31 =C4=85 0.37%
>> >     fdmap 0.32 =C4=85 0.72%
>>
>> From the text above, I'm still trying to understand: whose problem
>> does this solve? I mean, we've lived with the daemon-close-all-files
>> technique forever (and I'm not sure that performance is really an
>> important issue for the daemon case) .
>
>> And you say that the effect for lsof(1) will be buried.
>
> If only fdmap(2) is added, then effect will be negligible for lsof
> because it has to go through /proc anyway.
>
> The idea is to start process. In ideal world, only bynary system calls
> would exist and shells could emulate /proc/* same way bash implement
> /dev/tcp

Then start the process by doing it for real and making it obviously
useful.  We should not add a pair of vaguely useful, rather weak
syscalls just to start a process of modernizing /proc.

>
>> So, who does this new system call
>> really help? (Note: I'm not saying don't add the syscall, but from
>> explanation given here, it's not clear why we should.)
>
> For fdmap(2) natural users are lsof(), CRIU.

lsof does:

int
main(argc, argv)
        int argc;
        char *argv[];
{
...
        if ((MaxFd =3D (int) GET_MAX_FD()) < 53)
            MaxFd =3D 53;
        for (i =3D 3; i < MaxFd; i++)
            (void) close(i);

The solution isn't to wrangle fdmap(2) into this code.  The solution
is to remove the code entirely.
