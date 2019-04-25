From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv3 12/27] x86/vdso: Restrict splitting VVAR VMA
Date: Thu, 25 Apr 2019 19:46:48 +0100
Message-ID: <fd6aa95f-3677-701d-0e42-314a04e75977@gmail.com>
References: <20190425161416.26600-1-dima@arista.com>
 <20190425161416.26600-13-dima@arista.com>
 <CAG48ez1NSNWx1vixsHrxkqyafEu1i=qC4dQwBLXc+gLnBM2Y0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1NSNWx1vixsHrxkqyafEu1i=qC4dQwBLXc+gLnBM2Y0Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, Dmitry Safonov <dima@arista.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org



On 4/25/19 7:41 PM, Jann Horn wrote:
> On Thu, Apr 25, 2019 at 6:17 PM Dmitry Safonov <dima@arista.com> wrote:
>> Although, time namespace can work with VVAR VMA split, it seems worth
>> to forbid splitting VVAR resulting in stricter ABI and reducing amount
>> of corner-cases to consider while working further on VDSO.
> [...]
>> diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
>> index babc4e7a519c..ff9875a4d53b 100644
>> --- a/arch/x86/entry/vdso/vma.c
>> +++ b/arch/x86/entry/vdso/vma.c
> [...]
>> +static int vvar_mremap(const struct vm_special_mapping *sm,
>> +               struct vm_area_struct *new_vma)
>> +{
>> +       unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
>> +       const struct vdso_image *image = current->mm->context.vdso_image;
> 
> Using current->mm in here is a bit awkward. So far the ->mremap
> handler can only be invoked for `current`, but still, maybe
> new_vma->vm_mm would be better here?

Yep, can do - also in vdso_mremap().
Though, it should be only stylistic as it's checked in
special_mapping_mremap() to be the same.

> 
>> +       if (new_size != -image->sym_vvar_start)
>> +               return -EINVAL;
>> +
>> +       return 0;
>> +}
> [...]
> 

Thanks,
          Dima
