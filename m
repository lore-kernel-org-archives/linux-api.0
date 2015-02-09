From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Mon, 09 Feb 2015 10:13:07 +0100
Message-ID: <54D87A23.40703@gmail.com>
References: <54D08483.40209@suse.cz> <20150203105301.GC14259@node.dhcp.inet.fi> <54D0B43D.8000209@suse.cz> <54D0F56A.9050003@gmail.com> <54D22298.3040504@suse.cz> <CAKgNAkgOOCuzJz9whoVfFjqhxM0zYsz94B1+oH58SthC5Ut9sg@mail.gmail.com> <54D2508A.9030804@suse.cz> <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com> <20150205010757.GA20996@blaptop> <54D4E098.8050004@gmail.com> <20150209064600.GA32300@blaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150209064600.GA32300@blaptop>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: mtk.manpages@gmail.com, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

Hello Minchan

On 02/09/2015 07:46 AM, Minchan Kim wrote:
> Hello, Michael
> 
> On Fri, Feb 06, 2015 at 04:41:12PM +0100, Michael Kerrisk (man-pages) wrote:
>> On 02/05/2015 02:07 AM, Minchan Kim wrote:
>>> Hello,
>>>
>>> On Wed, Feb 04, 2015 at 08:24:27PM +0100, Michael Kerrisk (man-pages) wrote:
>>>> On 4 February 2015 at 18:02, Vlastimil Babka <vbabka@suse.cz> wrote:
>>>>> On 02/04/2015 03:00 PM, Michael Kerrisk (man-pages) wrote:

[...]

>>> And we should make error section, too.
>>> "locked" covers mlock(2) and you said you will add hugetlb. Then,
>>> VM_PFNMAP? In that case, it fails. How can we say about VM_PFNMAP?
>>> special mapping for some drivers?
>>
>> I'm open for offers on what to add.
> 
> I suggests from quote "LWN" http://lwn.net/Articles/162860/
> "*special mapping* which is not made up of "normal" pages.
> It is usually created by device drivers which map special memory areas
> into user space"

Thanks. I've added mention of VM_PFNMAP in the discussion of both 
MADV_DONTNEED and MADV_REMOVE, and noted that both of those
operations will give an error when applied to VM_PFNMAP pages.

Cheers,

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
