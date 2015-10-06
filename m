From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v4 1/4] mm, documentation: clarify /proc/pid/status VmSwap
 limitations
Date: Tue, 6 Oct 2015 09:05:23 +0200
Message-ID: <561372B3.60504@suse.cz>
References: <1443792951-13944-1-git-send-email-vbabka@suse.cz>
 <1443792951-13944-2-git-send-email-vbabka@suse.cz>
 <alpine.LSU.2.11.1510041756330.15067@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.11.1510041756330.15067@eggly.anvils>
Sender: owner-linux-mm@kvack.org
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, Jerome Marchand <jmarchan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

On 10/05/2015 03:05 AM, Hugh Dickins wrote:
> On Fri, 2 Oct 2015, Vlastimil Babka wrote:
>> --- a/Documentation/filesystems/proc.txt
>> +++ b/Documentation/filesystems/proc.txt
>> @@ -239,6 +239,8 @@ Table 1-2: Contents of the status files (as of 4.1)
>>    VmPTE                       size of page table entries
>>    VmPMD                       size of second level page tables
>>    VmSwap                      size of swap usage (the number of referred swapents)
>> +                             by anonymous private data (shmem swap usage is not
>> +                             included)
>
> I have difficulty in reading "size of swap usage (the number of referred
> swapents) by anonymous private data (shmem swap usage is not included)".
>
> Luckily, VmSwap never was "the number of referred swapents", it's in kB.
> So I suggest                    amount of swap used by anonymous private data
>                                  (shmem swap usage is not included)

Good point, thanks!

> for which you can assume Acked-by: Hugh Dickins <hughd@google.com>
>
> Hugh
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
