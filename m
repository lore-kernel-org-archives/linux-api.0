From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Mon, 11 Mar 2019 22:06:19 +0000
Message-ID: <yw1xwol52hic.fsf@mansr.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
        <20190305091904.GB8256@zn.tnic>
        <20190305122218.GD13380@bombadil.infradead.org>
        <20190305134347.4be2449c@alans-desktop>
        <20190305145717.GD8256@zn.tnic>
        <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
        <20190305173134.GE8256@zn.tnic>
        <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
        <20190305181138.GG8256@zn.tnic> <20190305181808.GH8256@zn.tnic>
        <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com>
        <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
        <yw1xa7i14btw.fsf@mansr.com>
        <CAHk-=whD1SumZUBQeuMT-GcciwPxg_jW_TsPAmokYp3sGGCGhA@mail.gmail.com>
        <yw1x5zsp473a.fsf@mansr.com>
        <CAHk-=wiU7xacTqDfm-x29-meyJWNd_X95K0T8FQMcDgy-yo3Qw@mail.gmail.com>
        <yw1x1s3d42ia.fsf@mansr.com>
        <CAK8P3a031d9mSOxVmCAGcrbdaCE8N3R4e2Smtxp-Z+cautTAvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a031d9mSOxVmCAGcrbdaCE8N3R4e2Smtxp-Z+cautTAvg@mail.gmail.com>
        (Arnd Bergmann's message of "Mon, 11 Mar 2019 22:34:26 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Matt Turner <mattst88@gmail.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-api@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Mon, Mar 11, 2019 at 8:47 PM Måns Rullgård <mans@mansr.com> wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> > On Mon, Mar 11, 2019 at 11:08 AM Måns Rullgård <mans@mansr.com> wrote:
>> >>
>> >> The latest version I have is 5.1, and that uses ECOFF.
>> >
>> > ECOFF _is_ a.out as far as Linux is concerned.
>> >
>> > So Linux basically treats ECOFF as "regular a.out with just some
>> > header extensions".
>> >
>> > We don't have any specific support for ECOFF.
>> >
>> > I _think_. Again, it's been years and years.
>>
>> Right, which is why killing a.out entirely would have the unfortunate
>> effect of also removing the OSF/1 compatibility on Alpha.
>>
>> If we are to support Alpha as an architecture at all, it makes sense to
>> support the things people actually use it for.
>>
>> Now, personally I can live without it.  I just don't like to see
>> features removed without due consideration.
>
> The main historic use case I've heard of was running Netscape
> Navigator on Alpha Linux, before there was an open source version.
> Doing this today to connect to the open internet is probably
> a bit pointless, but there may be other use cases.

Once upon a time, I used it to run Matlab.

> Looking at the system call table in the kernel
> (arch/alpha/kernel/syscalls/syscall.tbl), we seem to support a
> specific subset that was required for a set of applications, and
> not much more. Old system calls (osf_old_open, osf_execve,
> osf_old_sigaction) are listed but not implemented, and the same
> is true for most of the later calls (osf_fuser, osf_sigsendset,
> osf_waitid, osf_signal, ...), just the ones in the middle are there.
> This would also indicate that it never really worked as a
> general-purpose emulation layer but was only there for a specific
> set of applications.

It works for many applications, though I did have to add a few syscalls
myself (yes, I sent patches).

> Another data point I have is that osf1 emulation was broken
> between linux-4.13 and linux-4.16 without anyone noticing, see
> 47669fb6b595 ("alpha: osf_sys.c: fix put_tv32 regression").

That's interesting, but it doesn't mean nobody is using it.  I tend to
run the LTS branches and switch to a new one only once it seems to have
settled a bit, so when 4.16 was released, I was probably still running
4.9.  I don't think I'm the only one using this strategy.

-- 
Måns Rullgård
