From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv5 25/37] x86/vdso: Switch image on setns()/clone()
Date: Wed, 31 Jul 2019 22:34:26 -0700
Message-ID: <CALCETrUpOhTCQkhB3S73LBFAiTp07PwXP32Q6Bn0m2LTqiw9hA@mail.gmail.com>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-26-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-26-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu@openvz.org, Linux API <linux-api@vger.ke>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista.com> wrote:
>
> As it has been discussed on timens RFC, adding a new conditional branch
> `if (inside_time_ns)` on VDSO for all processes is undesirable.
> It will add a penalty for everybody as branch predictor may mispredict
> the jump. Also there are instruction cache lines wasted on cmp/jmp.


>
> +#ifdef CONFIG_TIME_NS
> +int vdso_join_timens(struct task_struct *task)
> +{
> +       struct mm_struct *mm = task->mm;
> +       struct vm_area_struct *vma;
> +
> +       if (down_write_killable(&mm->mmap_sem))
> +               return -EINTR;
> +
> +       for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +               unsigned long size = vma->vm_end - vma->vm_start;
> +
> +               if (vma_is_special_mapping(vma, &vvar_mapping) ||
> +                   vma_is_special_mapping(vma, &vdso_mapping))
> +                       zap_page_range(vma, vma->vm_start, size);
> +       }

This is, unfortunately, fundamentally buggy.  If any thread is in the
vDSO or has the vDSO on the stack (due to a signal, for example), this
will crash it.  I can think of three solutions:

1. Say that you can't setns() if you have other mms and ignore the
signal issue.  Anything with green threads will disapprove.  It's also
rather gross.

2. Make it so that you can flip the static branch safely.  As in my
other email, you'll need to deal with CoW somehow,

3. Make it so that you can't change timens, or at least that you can't
turn timens on or off, without execve() or fork().

BTW, that static branch probably needs to be aligned to a cache line
or something similar to avoid all the nastiness with trying to poke
text that might be concurrently executing.  This will be a mess.
