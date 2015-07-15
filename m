From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 12/24] task_diag: add a new group to get tasks memory
 mappings (v2)
Date: Tue, 14 Jul 2015 22:02:19 -0400
Message-ID: <55A5BF2B.1040504@gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <1436172445-6979-13-git-send-email-avagin@openvz.org> <20150714180857.GC8088@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714180857.GC8088-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7/14/15 2:08 PM, Oleg Nesterov wrote:
> On 07/06, Andrey Vagin wrote:
>>
>> +static int task_vma_num(struct mm_struct *mm)
>> +{
>> +	struct vm_area_struct *vma;
>> +	int n_vma = 0;
>> +
>> +	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
>> +		return 0;
>> +
>> +	down_read(&mm->mmap_sem);
>> +	for (vma = mm->mmap; vma; vma = vma->vm_next, n_vma++)
>> +		;
>> +
>> +	up_read(&mm->mmap_sem);
>> +	mmput(mm);
>> +
>> +	return n_vma;
>> +}
>
> Hmm. How about
>
> 	int task_vma_num(struct mm_struct *mm)
> 	{
> 		return mm->map_count;
> 	}
>
> ?

makes sense. Thanks for the pointer.
