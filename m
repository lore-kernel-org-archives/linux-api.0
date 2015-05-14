From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH v2 3/4] mm, shmem: Add shmem resident memory accounting
Date: Thu, 14 May 2015 16:31:17 +0300
Message-ID: <CALYGNiOoNz0m_Eb36v2oMkRmAKzX97ZqhFM1kdMaF7bKVsuPHA@mail.gmail.com>
References: <1427474441-17708-1-git-send-email-vbabka@suse.cz>
	<1427474441-17708-4-git-send-email-vbabka@suse.cz>
	<55158EB5.5040301@yandex-team.ru>
	<5554844F.4070709@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5554844F.4070709@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Jerome Marchand <jmarchan@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 2:17 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 03/27/2015 06:09 PM, Konstantin Khlebnikov wrote:
>>
>> On 27.03.2015 19:40, Vlastimil Babka wrote:
>>>
>>> From: Jerome Marchand <jmarchan@redhat.com>
>>>
>>> Currently looking at /proc/<pid>/status or statm, there is no way to
>>> distinguish shmem pages from pages mapped to a regular file (shmem
>>> pages are mapped to /dev/zero), even though their implication in
>>> actual memory use is quite different.
>>> This patch adds MM_SHMEMPAGES counter to mm_rss_stat to account for
>>> shmem pages instead of MM_FILEPAGES.
>>>
>>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>> ---
>>
>>
>>
>>> --- a/include/linux/mm_types.h
>>> +++ b/include/linux/mm_types.h
>>> @@ -327,9 +327,12 @@ struct core_state {
>>>    };
>>>
>>>    enum {
>>> -       MM_FILEPAGES,
>>> -       MM_ANONPAGES,
>>> -       MM_SWAPENTS,
>>> +       MM_FILEPAGES,   /* Resident file mapping pages */
>>> +       MM_ANONPAGES,   /* Resident anonymous pages */
>>> +       MM_SWAPENTS,    /* Anonymous swap entries */
>>> +#ifdef CONFIG_SHMEM
>>> +       MM_SHMEMPAGES,  /* Resident shared memory pages */
>>> +#endif
>>
>>
>> I prefer to keep that counter unconditionally:
>> kernel has MM_SWAPENTS even without CONFIG_SWAP.
>
>
> Hmm, so just for consistency? I don't see much reason to make life harder
> for tiny systems, especially when it's not too much effort.

Profit is vague, I guess slab anyway will round size to the next
cacheline or power-of-two.
That conditional (non)existence just adds unneeded code lines.

>
>>
>>>         NR_MM_COUNTERS
>>>    };
>>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
