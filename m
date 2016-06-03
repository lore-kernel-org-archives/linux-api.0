From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/8] x86, pkeys: allocation/free syscalls
Date: Thu, 2 Jun 2016 19:26:03 -0500
Message-ID: <5499ff55-ae0f-e54c-05fd-b1e76dc05a89@gmail.com>
References: <20160531152814.36E0B9EE@viggo.jf.intel.com>
 <20160531152822.FE8D405E@viggo.jf.intel.com>
 <20160601123705.72a606e7@lwn.net> <574F386A.8070106@sr71.net>
 <CAKgNAkiyD_2tAxrBxirxViViMUsfLRRqQp5HowM58dG21LAa7Q@mail.gmail.com>
 <574F7B16.4080906@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574F7B16.4080906-gkUM19QKKo4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/01/2016 07:17 PM, Dave Hansen wrote:
> On 06/01/2016 05:11 PM, Michael Kerrisk (man-pages) wrote:
>>>>>>
>>>>>> If I read this right, it doesn't actually remove any pkey restrictions
>>>>>> that may have been applied while the key was allocated.  So there could be
>>>>>> pages with that key assigned that might do surprising things if the key is
>>>>>> reallocated for another use later, right?  Is that how the API is intended
>>>>>> to work?
>>>>
>>>> Yeah, that's how it works.
>>>>
>>>> It's not ideal.  It would be _best_ if we during mm_pkey_free(), we
>>>> ensured that no VMAs under that mm have that vma_pkey() set.  But, that
>>>> search would be potentially expensive (a walk over all VMAs), or would
>>>> force us to keep a data structure with a count of all the VMAs with a
>>>> given key.
>>>>
>>>> I should probably discuss this behavior in the manpages and address it
>> s/probably//
>>
>> And, did I miss it. Was there an updated man-pages patch in the latest
>> series? I did not notice it.
> 
> There have been to changes to the patches that warranted updating the
> manpages until now.  I'll send the update immediately.

Do those updated pages include discussion of the point noted above?
I could not see it mentioned there.

Just by the way, the above behavior seems to offer possibilities
for users to shoot themselves in the foot, in a way that has security
implications. (Or do I misunderstand?)

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
