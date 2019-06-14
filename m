From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 17/28] x86/vdso: Switch image on
 setns()/unshare()/clone()
Date: Fri, 14 Jun 2019 16:05:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906141603500.1722@nanos.tec.linutronix.de>
References: <20190612192628.23797-1-dima@arista.com> <20190612192628.23797-18-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612192628.23797-18-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 12 Jun 2019, Dmitry Safonov wrote:
>  
> +#ifdef CONFIG_TIME_NS
> +int vdso_join_timens(struct task_struct *task)
> +{
> +	struct mm_struct *mm = task->mm;
> +	struct vm_area_struct *vma;
> +
> +	if (down_write_killable(&mm->mmap_sem))
> +		return -EINTR;
> +
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		unsigned long size = vma->vm_end - vma->vm_start;
> +
> +		if (vma_is_special_mapping(vma, &vvar_mapping) ||
> +		    vma_is_special_mapping(vma, &vdso_mapping))
> +			zap_page_range(vma, vma->vm_start, size);
> +	}
> +
> +	up_write(&mm->mmap_sem);
> +	return 0;
> +}
> +#else /* CONFIG_TIME_NS */
> +int vdso_join_timens(struct task_struct *task)
> +{
> +	return -ENXIO;
> +}

Is that else path really required? The callsite is only compiled when
CONFIG_TIME_NS is enabled, right?

Thanks,

	tglx
