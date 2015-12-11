From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 26/34] mm: implement new mprotect_key() system call
Date: Fri, 11 Dec 2015 21:13:55 +0100
Message-ID: <566B2E83.4070002@gmail.com>
References: <20151204011424.8A36E365@viggo.jf.intel.com> <20151204011500.69487A6C@viggo.jf.intel.com> <5662894B.7090903@gmail.com> <5665B767.8020802@sr71.net> <56680BA6.20406@gmail.com> <56684D3B.5050805@sr71.net> <CAKgNAkiZHny4amNcamN+q6pxdanG9aMMA4H_pekA7+RDuoUvEA@mail.gmail.com> <56685F42.8070109@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <56685F42.8070109@sr71.net>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "x86@kernel.org" <x86@kernel.org>, dave.hansen@linux.intel.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/09/2015 06:05 PM, Dave Hansen wrote:
> On 12/09/2015 08:45 AM, Michael Kerrisk (man-pages) wrote:
>>>>>> * Explanation of what a protection domain is.
>>>>
>>>> A protection domain is a unique view of memory and is represented by the
>>>> value in the PKRU register.
>> Out something about this in pkey(7), but explain what you mean by a
>> "unique view of memory".
> 
> Let's say there are only two protection keys: 0 and 1.  There are two
> disable bits per protection key (Access and Write Disable), so a two-key
> PKRU looks like:
> 
> |   PKEY0   |   PKEY1   |
> | AD0 | WD0 | AD1 | WD1 |
> 
> In this example, there are 16 possible protection domains, one for each
> possible combination of the 4 rights-disable bits.
> 
> "Changing a protection domain" would mean changing (setting or clearing)
> the value of any of those 4 bits.  Each unique value of PKRU represents
> a view of memory, or unique protection domain.

Again, some of this could make its way into pkey(7). And I guess there
are useful nuggets for that page to be found in Jon's article at
https://lwn.net/Articles/667156/

Thanks,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
