From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Fri, 20 Jun 2014 08:55:01 -0700
Message-ID: <CALCETrWnQyCk5vhDj-yAhRdAFOtFKSU6H-E_=LBC+FbA2REhrg@mail.gmail.com>
References: <21405.44257.742122.786960@gargle.gargle.HOWL> <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com> <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com> <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org> <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
 <20140616143801.GJ5714@two.firstfloor.org> <CAKOQZ8zk8KfkObSZg8fmhZXm9nXQSneOywvV-NBj=N-tNWjNPg@mail.gmail.com>
 <20140616154228.GB179@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140616154228.GB179@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Ian Lance Taylor <iant@golang.org>, Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 16, 2014 at 8:42 AM, Rich Felker <dalias@libc.org> wrote:
> On Mon, Jun 16, 2014 at 08:31:39AM -0700, Ian Lance Taylor wrote:
>> On Mon, Jun 16, 2014 at 7:38 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> I think this issue started when some of the Go developers questioned
>> >> why the kernel needed to provide a very complex interface--parsing an
>> >> ELF shared shared library--for very simple functionality--looking up
>> >> the address of a magic function.  This approach has required special
>> >> support not just in Go, but also in the dynamic linker and gdb, and
>> >> does not work well for statically linked binaries.  The support in gdb
>> >> is perhaps a good idea, but elsewhere it does not make sense.
>> >>
>> >> So why not provide a simple interface?
>> >
>> > What good would it do now that everyone already supports it?
>>
>> Do statically linked binaries use the vDSO calls?
>
> Under glibc, I believe so (not checked). Under musl, yes, and even in
> the dynamic-linked case we use the same code that's used for static
> linking rather than trying to get the dynamic linker to do them
> correctly. I still have some cruft lying around from where (in the
> past) we tried to do it via the dynamic linker, but I'm probably going
> to remove that and make the vdso behave as RTLD_LOCAL so that there's
> no risk of weird symbols it exports interfering with the application
> (applications could still make it global via an explicit dlopen). The
> only reason for keeping it around at all in the dynamic linker is for
> the sake of gdb.
>

What about backtrace_symbols, dl_addr, and the unwinder (e.g.
siglongjmp)?  It would be nice to wean the vdso off of frame pointers
some day.

--Andy
