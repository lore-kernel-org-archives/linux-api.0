From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sat, 14 Jun 2014 15:38:48 -0700
Message-ID: <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net> <20140614213000.GO179@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140614213000.GO179@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 14, 2014 at 2:30 PM, Rich Felker <dalias@libc.org> wrote:
> On Sat, Jun 14, 2014 at 11:16:42AM -0700, Andy Lutomirski wrote:
>> The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
>> implements __vdso_findsym.
>>
>> This would make it easier for runtimes that don't otherwise implement
>> ELF loaders to use the vdso.
>>
>> Thoughts?
>>
>> If people like the basic concept, I'll finish it, write up
>> documentation and a selftest.  If people don't like it, I'll drop it.
>
> I like the idea. I don't think it's immediately useful, since
> libraries wanting to use vdso will likely want to support older
> kernels that don't yet have this, and thus need to include their own
> vdso parsing code. However, if we could get this in now, it would be
> very useful a few years down the line where optimizing for old kernels
> is not an important goal. I'd certainly like to be able to drop the
> ELF parsing code from musl to reduce static binary size. And I could
> see other projects possibly using it just to avoid the issue of ever
> adding ELF parsing code in the first place.
>

Hmm.  I hadn't thought of this as a size win, but I guess it could be
if there are static binaries around.

This patch currently generates 488 bytes on text with my toolchain.
More than half of that is garbage needed to deal with the symbol
version tables, and I should be able to move a decent fraction of it
to vdso2c and therefore out of the kernel and vdso images.

--Andy
