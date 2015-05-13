From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v2 3/3] pagemap: switch to the new format and do some
 cleanup
Date: Wed, 13 May 2015 14:39:54 +0300
Message-ID: <5553380A.1040605@yandex-team.ru>
References: <20150512090156.24768.2521.stgit@buzz> <20150512094306.24768.51325.stgit@buzz> <20150512105431.GD18365@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150512105431.GD18365@node.dhcp.inet.fi>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mark Williamson <mwilliamson@undo-software.com>, Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Vlastimil Babka <vbabka@suse.cz>, Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel James <djames@undo-software.com>, Finn Grimwood <fgrimwood@undo-software.com>
List-Id: linux-api@vger.kernel.org

On 12.05.2015 13:54, Kirill A. Shutemov wrote:
> On Tue, May 12, 2015 at 12:43:06PM +0300, Konstantin Khlebnikov wrote:
>> This patch removes page-shift bits (scheduled to remove since 3.11) and
>> completes migration to the new bit layout. Also it cleans messy macro.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> ---
>>   fs/proc/task_mmu.c    |  152 ++++++++++++++++---------------------------------
>>   tools/vm/page-types.c |   29 +++------
>>   2 files changed, 58 insertions(+), 123 deletions(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 0b7a8ffec95f..66bc7207ce90 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -710,23 +710,6 @@ const struct file_operations proc_tid_smaps_operations = {
>>   	.release	= proc_map_release,
>>   };
>>
>> -/*
>> - * We do not want to have constant page-shift bits sitting in
>> - * pagemap entries and are about to reuse them some time soon.
>> - *
>> - * Here's the "migration strategy":
>> - * 1. when the system boots these bits remain what they are,
>> - *    but a warning about future change is printed in log;
>> - * 2. once anyone clears soft-dirty bits via clear_refs file,
>> - *    these flag is set to denote, that user is aware of the
>> - *    new API and those page-shift bits change their meaning.
>> - *    The respective warning is printed in dmesg;
>> - * 3. In a couple of releases we will remove all the mentions
>> - *    of page-shift in pagemap entries.
>> - */
>
> Wouldn't it be better to just have v2=1 by default for couple releases to
> see if anything breaks? This way we can revert easily if regression reported.
> I guess someone could miss this change coming if he didn't touch clear_refs.
>

I don't believe that constant PAGE_SHIFT bits are used by anybody. 
Recent change of permissions was much more destructive and there is just
one report about that. Kernel prints message at first pagemap open for
ten releases. I think that's enough.

-- 
Konstantin

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
