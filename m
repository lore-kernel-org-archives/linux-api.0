From: hpa@zytor.com
Subject: Re: [PATCHv5 25/37] x86/vdso: Switch image on setns()/clone()
Date: Wed, 31 Jul 2019 23:09:20 -0700
Message-ID: <4D0E6734-066D-4A72-A119-2FD6482F857D@zytor.com>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-26-dima@arista.com> <CALCETrUpOhTCQkhB3S73LBFAiTp07PwXP32Q6Bn0m2LTqiw9hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUpOhTCQkhB3S73LBFAiTp07PwXP32Q6Bn0m2LTqiw9hA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Dmitry Safonov <dima@arista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On July 31, 2019 10:34:26 PM PDT, Andy Lutomirski <luto@kernel=2Eorg> wrote=
:
>On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista=2Ecom> wrote:
>>
>> As it has been discussed on timens RFC, adding a new conditional
>branch
>> `if (inside_time_ns)` on VDSO for all processes is undesirable=2E
>> It will add a penalty for everybody as branch predictor may
>mispredict
>> the jump=2E Also there are instruction cache lines wasted on cmp/jmp=2E
>
>
>>
>> +#ifdef CONFIG_TIME_NS
>> +int vdso_join_timens(struct task_struct *task)
>> +{
>> +       struct mm_struct *mm =3D task->mm;
>> +       struct vm_area_struct *vma;
>> +
>> +       if (down_write_killable(&mm->mmap_sem))
>> +               return -EINTR;
>> +
>> +       for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
>> +               unsigned long size =3D vma->vm_end - vma->vm_start;
>> +
>> +               if (vma_is_special_mapping(vma, &vvar_mapping) ||
>> +                   vma_is_special_mapping(vma, &vdso_mapping))
>> +                       zap_page_range(vma, vma->vm_start, size);
>> +       }
>
>This is, unfortunately, fundamentally buggy=2E  If any thread is in the
>vDSO or has the vDSO on the stack (due to a signal, for example), this
>will crash it=2E  I can think of three solutions:
>
>1=2E Say that you can't setns() if you have other mms and ignore the
>signal issue=2E  Anything with green threads will disapprove=2E  It's als=
o
>rather gross=2E
>
>2=2E Make it so that you can flip the static branch safely=2E  As in my
>other email, you'll need to deal with CoW somehow,
>
>3=2E Make it so that you can't change timens, or at least that you can't
>turn timens on or off, without execve() or fork()=2E
>
>BTW, that static branch probably needs to be aligned to a cache line
>or something similar to avoid all the nastiness with trying to poke
>text that might be concurrently executing=2E  This will be a mess=2E

Since we are talking about different physical addresses I believe we shoul=
d be okay as long as they don't cross page boundaries, and even if they do =
it can be managed with proper page invalidation sequencing =E2=80=93 it's n=
ot like the problems of having to deal with XMC on live pages like in the k=
ernel=2E

Still, you really need each instruction sequence to be present, with the o=
nly difference being specific patch sites=2E

Any fundamental reason this can't be strictly data driven? Seems odd to me=
 if it couldn't, but I might be missing something obvious=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
