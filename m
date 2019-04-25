From: Jann Horn <jannh@google.com>
Subject: Re: [PATCHv3 16/27] x86/vdso: Switch image on setns()/unshare()/clone()
Date: Thu, 25 Apr 2019 19:53:08 +0200
Message-ID: <CAG48ez3M6aLNda+dmviba4CVDBSx0nTknp4JiophDKmqpHYh_A@mail.gmail.com>
References: <20190425161416.26600-1-dima@arista.com> <20190425161416.26600-17-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425161416.26600-17-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 6:15 PM Dmitry Safonov <dima@arista.com> wrote:
> As it has been discussed on timens RFC, adding a new conditional branch
> `if (inside_time_ns)` on VDSO for all processes is undesirable.
> It will add a penalty for everybody as branch predictor may mispredict
> the jump. Also there are instruction cache lines wasted on cmp/jmp.
>
> Those effects of introducing time namespace are very much unwanted
> having in mind how much work have been spent on micro-optimisation
> vdso code.
>
> Addressing those problems, there are two versions of VDSO's .so:
> for host tasks (without any penalty) and for processes inside of time
> namespace with clk_to_ns() that subtracts offsets from host's time.
>
> Whenever a user does setns()/unshare() or clone() with CLONE_TIMENS,
> change VDSO image in mm and zap existing VVAR/VDSO page tables.
> They will be re-faulted with corresponding image and VVAR offsets.
[...]
> +#ifdef CONFIG_TIME_NS
> +int vdso_join_timens(struct task_struct *task, bool inside_ns)

The parameter "inside_ns" is never used, right?

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
> +               if (vma_is_special_mapping(vma, &vvar_mapping))
> +                       zap_page_range(vma, vma->vm_start, size);
> +               if (vma_is_special_mapping(vma, &vdso_mapping))
> +                       zap_page_range(vma, vma->vm_start, size);

Nit: This could be rewritten as:

if (vma_is_special_mapping(vma, &vvar_mapping) ||
    vma_is_special_mapping(vma, &vdso_mapping))
        zap_page_range(vma, vma->vm_start, size);

> +       }
> +
> +       up_write(&mm->mmap_sem);
> +       return 0;
> +}
[...]
