From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 08:47:19 -0700
Message-ID: <CALCETrXqcO_Jz_9P5bHW7yBcxOXgTFveL9r4G8PO4XiHC8JhAg@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140615143500.GP179@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 7:35 AM, Rich Felker <dalias@libc.org> wrote:
> On Sun, Jun 15, 2014 at 04:25:37PM +0200, Mikael Pettersson wrote:
>> Andy Lutomirski writes:
>>  > The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
>>  > implements __vdso_findsym.
>>  >
>>  > This would make it easier for runtimes that don't otherwise implement
>>  > ELF loaders to use the vdso.
>>  >
>>  > Thoughts?
>>
>> I'm opposed to this based on the principle that the kernel should NOT
>> be a dumping ground for random code that user-space can and should
>> implement for itself.  As long as the vdso is correctly formatted ELF,
>> then parsing it is easy, and the kernel should not care at all if or
>> how user-space accesses it.
>
> Arguably, it was a mistake for the kernel to expose a virtual ELF to
> begin with, and it should just have exposed a "lookup function by
> name" operation to begin with. Yes this can be done in userspace, but
> I see it more as a matter of "fixing a broken API design".

Is the __vdso_findsym(name, version) approach good?  I don't know why
the vdso uses symbol versions at all, nor do I know why it uses weak
symbol aliases.  The vdso's "clock_gettime" isn't a drop-in
replacement for glibc's: it doesn't touch error, and it returns
negative error codes.

It might make more sense to promise that the vdso will never export to
functions with the same name but different versions and to just get
rid of the version field from __vdso_findsym.  I tried implementing
this; it's untested, but the text size is only 230 bytes :)

It might also make sense to look up by number.  Yes, it smells like
Windows DLLs, but it also looks awfully like Linux syscalls, which do
just fine using a call-by-number scheme.

--Andy
