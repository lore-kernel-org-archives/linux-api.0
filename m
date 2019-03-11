From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Mon, 11 Mar 2019 22:12:50 +0000
Message-ID: <yw1xsgvt2h7h.fsf@mansr.com>
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
        <CAHk-=wj3v41CWH+3ry3+vrkjAEcyGojtevpsZDbiXVvpv1nTkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wj3v41CWH+3ry3+vrkjAEcyGojtevpsZDbiXVvpv1nTkA@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 11 Mar 2019 14:45:27 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Matt Turner <mattst88@gmail.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Mar 11, 2019 at 2:34 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> The main historic use case I've heard of was running Netscape
>> Navigator on Alpha Linux, before there was an open source version.
>> Doing this today to connect to the open internet is probably
>> a bit pointless, but there may be other use cases.
>
> The _really_ main version was that I decided to make my life easier
> for the initial alpha port by trying to run basic (tested) OSF/1
> binaries directly.
>
> Netscape may have been one of the binaries people actually ended up
> using, but it's probably not a reason any more, since the internet has
> moved past that anyway.
>
>> Looking at the system call table in the kernel
>> (arch/alpha/kernel/syscalls/syscall.tbl), we seem to support a
>> specific subset that was required for a set of applications, and
>> not much more.
>
> Yeah, it never supported arbitrary binaries, particularly since
> there's often lots of other issues too with running things like that
> (ie filesystem layout etc). It worked for normal fairly well behaved
> stuff, but wasn't ever a full OSF/1 emulation environment.
>
> I _suspect_ nobody actually runs any OSF/1 binaries any more, but it
> would obviously be good to verify that. Your argument that timeval
> handling was broken _may_ be an indication of that (or may just mean
> very few apps care).

Does it count if I fire up an Alpha and run a few OSF/1 binaries right
now? :-)

-- 
Måns Rullgård
