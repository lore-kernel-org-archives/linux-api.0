From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]Fix: 32bit binary has 64bit address of stack vma
Date: Fri, 9 Jan 2009 16:27:07 -0800
Message-ID: <604427e00901091627n7c909abt6aa1f01c181ad65d__36147.7115577602$1231547336$gmane$org@mail.gmail.com>
References: <604427e00901051539x52ab85bcua94cd8036e5b619a@mail.gmail.com>
	 <604427e00901081840pa6dcc41u9a7a5c69302c7b60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <604427e00901081840pa6dcc41u9a7a5c69302c7b60-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm@linux-foundation>
List-Id: linux-api@vger.kernel.org

friendly ping...

On Thu, Jan 8, 2009 at 6:40 PM, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Jan 5, 2009 at 3:39 PM, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> Fix 32bit binary get 64bit stack vma offset.
>>
>> 32bit binary running on 64bit system, the /proc/pid/maps shows for the
>> vma represents stack get a 64bit adress:
>> ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]
>>
>> Signed-off-by:  Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> fs/exec.c                     |    5 +-
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 4e834f1..8c3eff4 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -517,6 +517,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
>>        unsigned long length = old_end - old_start;
>>        unsigned long new_start = old_start - shift;
>>        unsigned long new_end = old_end - shift;
>> +       unsigned long new_pgoff = new_start >> PAGE_SHIFT;
>>        struct mmu_gather *tlb;
>>
>>        BUG_ON(new_start > new_end);
>> @@ -531,7 +532,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
>>        /*
>>         * cover the whole range: [new_start, old_end)
>>         */
>> -       vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL);
>> +       vma_adjust(vma, new_start, old_end, new_pgoff, NULL);
>>
>>        /*
>>         * move the page tables downwards, on failure we rely on
>> @@ -564,7 +565,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
>>        /*
>>         * shrink the vma to just the new range.
>>         */
>> -       vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
>> +       vma_adjust(vma, new_start, new_end, new_pgoff, NULL);
>>
>>        return 0;
>>  }
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
