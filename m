From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv3 15/27] x86/vdso: Allocate timens vdso
Date: Thu, 25 Apr 2019 20:05:50 +0100
Message-ID: <169526ff-8331-6db6-e67a-8ffbbfa678cd@gmail.com>
References: <20190425161416.26600-1-dima@arista.com>
 <20190425161416.26600-16-dima@arista.com>
 <CAG48ez3nT_RtaHrjpKPRZDYTyzxX49QBZXJ+u2AZmFy5Wao4wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3nT_RtaHrjpKPRZDYTyzxX49QBZXJ+u2AZmFy5Wao4wQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, Dmitry Safonov <dima@arista.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On 4/25/19 7:32 PM, Jann Horn wrote:
> On Thu, Apr 25, 2019 at 6:14 PM Dmitry Safonov <dima@arista.com> wrote:
>>
>> As it has been discussed on timens RFC, adding a new conditional branch
>> `if (inside_time_ns)` on VDSO for all processes is undesirable.
>> It will add a penalty for everybody as branch predictor may mispredict
>> the jump. Also there are instruction cache lines wasted on cmp/jmp.
>>
>> Those effects of introducing time namespace are very much unwanted
>> having in mind how much work have been spent on micro-optimisation
>> vdso code.
>>
>> The propose is to allocate a second vdso code with dynamically
>> patched out (disabled by static_branch) timens code on boot time.
>>
>> Allocate another vdso and copy original code.
> [...]
>> diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
>> index 80cbb2167eba..6aae9c0d400d 100644
>> --- a/arch/x86/entry/vdso/vma.c
>> +++ b/arch/x86/entry/vdso/vma.c
> [...]
>>  static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
>>                       struct vm_area_struct *vma, struct vm_fault *vmf)
>>  {
>>         const struct vdso_image *image = vma->vm_mm->context.vdso_image;
>> +       unsigned long offset = vmf->pgoff << PAGE_SHIFT;
>>
>>         if (!image || (vmf->pgoff << PAGE_SHIFT) >= image->size)
>>                 return VM_FAULT_SIGBUS;
>>
>> -       vmf->page = virt_to_page(image->text + (vmf->pgoff << PAGE_SHIFT));
>> +       if (current_timens_offsets() && image->text_timens)
> 
> I'm pretty sure that accessing `current` in here is wrong. AFAIK this
> fault handler can be invoked on remote processes, through interfaces
> like /proc/$pid/mem and process_vm_readv(); in that case, the kernel
> should install a page based on the time namespace of the target
> process, not based on the time namespace of the caller.

Oh yeah, I see, smells bogus.
Will try to redesign it..

> 
>> +               vmf->page = vmalloc_to_page(image->text_timens + offset);
>> +       else
>> +               vmf->page = virt_to_page(image->text + offset);
>> +
>>         get_page(vmf->page);
>>         return 0;
>>  }
> [...]
> 

Thanks,
          Dima
