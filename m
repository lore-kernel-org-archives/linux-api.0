From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Mon, 11 Mar 2019 19:47:25 +0000
Message-ID: <yw1x1s3d42ia.fsf@mansr.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiU7xacTqDfm-x29-meyJWNd_X95K0T8FQMcDgy-yo3Qw@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 11 Mar 2019 12:03:18 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k@lists.linux-m68k.org
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Mar 11, 2019 at 11:08 AM Måns Rullgård <mans@mansr.com> wrote:
>>
>> The latest version I have is 5.1, and that uses ECOFF.
>
> ECOFF _is_ a.out as far as Linux is concerned.
>
> So Linux basically treats ECOFF as "regular a.out with just some
> header extensions".
>
> We don't have any specific support for ECOFF.
>
> I _think_. Again, it's been years and years.

Right, which is why killing a.out entirely would have the unfortunate
effect of also removing the OSF/1 compatibility on Alpha.

If we are to support Alpha as an architecture at all, it makes sense to
support the things people actually use it for.

Now, personally I can live without it.  I just don't like to see
features removed without due consideration.

-- 
Måns Rullgård
