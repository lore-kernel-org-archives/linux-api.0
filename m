From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 26/34] mm: implement new mprotect_key() system call
Date: Wed, 9 Dec 2015 17:45:03 +0100
Message-ID: <CAKgNAkiZHny4amNcamN+q6pxdanG9aMMA4H_pekA7+RDuoUvEA@mail.gmail.com>
References: <20151204011424.8A36E365@viggo.jf.intel.com> <20151204011500.69487A6C@viggo.jf.intel.com>
 <5662894B.7090903@gmail.com> <5665B767.8020802@sr71.net> <56680BA6.20406@gmail.com>
 <56684D3B.5050805@sr71.net>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56684D3B.5050805-gkUM19QKKo4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dave,

On 9 December 2015 at 16:48, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org> wrote:
> Hi Michael,
>
> Thanks for all the comments!  I'll fix most of it when I post a new
> version of the manpage, but I have a few general questions.
>
> On 12/09/2015 03:08 AM, Michael Kerrisk (man-pages) wrote:
>>>
>>> +is the protection or storage key to assign to the memory.
>>
>> Why "protection or storage key" here? This phrasing seems a
>> little ambiguous to me, given that we also have a 'prot'
>> argument.  I think it would be clearer just to say
>> "protection key". But maybe I'm missing something.
>
> x86 calls it a "protection key" while powerpc calls it a "storage key".
>  They're called "protection keys" consistently inside the kernel.
>
> Should we just stick to one name in the manpages?

Yes. But perhaps you could note the alternate name in the pkey(7) page.

>> * A general overview of why this functionality is useful.
>
> Any preference on a central spot to do the general overview?  Does it go
> in one of the manpages I'm already modifying, or a new one?

How about we add one more page, pkey(7) that gives the overview and
also summarizes the APIs.

>> * A note on which architectures support/will support
>>   this functionality.
>
> x86 only for now.  We might get powerpc support down the road somewhere.

Supported architectures can be listed in pkey(7).

>> * Explanation of what a protection domain is.
>
> A protection domain is a unique view of memory and is represented by the
> value in the PKRU register.

Out something about this in pkey(7), but explain what you mean by a
"unique view of memory".

>> * Explanation of how a process (thread?) changes its
>>   protection domain.
>
> Changing protection domains is done by pkey_set() system call, or by
> using the WRPKRU instruction.  The system call is preferred and less
> error-prone since it enforces that a protection is allocated before its
> access protection can be modified.

Details (perhaps not the WRPKRU bit) that should go in pkey(7).

>> * Explanation of the relationship between page permission
>>   bits (PROT_READ/PROT_WRITE/PROTE_EXEC) and
>>   PKEY_DISABLE_ACCESS and PKEY_DISABLE_WRITE.
>>   It's still not clear to me. Do the PKEY_* bits
>>   override the PROT_* bits. Or, something else?
>
> Protection keys add access restrictions in addition to existing page
> permissions.  They can only take away access; they never grant
> additional access.

This belongs in pkey(7) :-).

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
