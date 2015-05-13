From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v2 1/3] pagemap: add mmap-exclusive bit for marking pages
 mapped only here
Date: Wed, 13 May 2015 13:59:41 +0300
Message-ID: <55532E9D.1040702@yandex-team.ru>
References: <20150512090156.24768.2521.stgit@buzz> <20150512094303.24768.10282.stgit@buzz> <20150512104055.GB18365@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150512104055.GB18365@node.dhcp.inet.fi>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mark Williamson <mwilliamson@undo-software.com>, Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Vlastimil Babka <vbabka@suse.cz>, Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel James <djames@undo-software.com>, Finn Grimwood <fgrimwood@undo-software.com>
List-Id: linux-api@vger.kernel.org

On 12.05.2015 13:40, Kirill A. Shutemov wrote:
> On Tue, May 12, 2015 at 12:43:03PM +0300, Konstantin Khlebnikov wrote:
>> This patch sets bit 56 in pagemap if this page is mapped only once.
>> It allows to detect exclusively used pages without exposing PFN:
>>
>> present file exclusive state
>> 0       0    0         non-present
>> 1       1    0         file page mapped somewhere else
>> 1       1    1         file page mapped only here
>> 1       0    0         anon non-CoWed page (shared with parent/child)
>> 1       0    1         anon CoWed page (or never forked)
>
> Probably, worth noting that file-private pages are anon in this context.
>

You mean there's another kind of CoW pages? Yep, but from the kernel
point of view these pages are the same. Anyway Userspace could look
into /proc/*/maps and see is there any file beyond anon vma.

-- 
Konstantin

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
