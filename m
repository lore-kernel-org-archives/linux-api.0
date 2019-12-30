From: J Freyensee <why2jjj.linux@gmail.com>
Subject: Re: [PATCH v6 07/10] proc: flush task dcache entries from all procfs
 instances
Date: Mon, 30 Dec 2019 14:03:29 -0800
Message-ID: <8d85ba43-0759-358e-137d-246107bac747@gmail.com>
References: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
 <20191225125151.1950142-8-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191225125151.1950142-8-gladkov.alexey@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-api@vger.kernel.org

snip

.

.

.

>   
> +#ifdef CONFIG_PROC_FS
> +static inline void pidns_proc_lock(struct pid_namespace *pid_ns)
> +{
> +	down_write(&pid_ns->rw_proc_mounts);
> +}
> +
> +static inline void pidns_proc_unlock(struct pid_namespace *pid_ns)
> +{
> +	up_write(&pid_ns->rw_proc_mounts);
> +}
> +
> +static inline void pidns_proc_lock_shared(struct pid_namespace *pid_ns)
> +{
> +	down_read(&pid_ns->rw_proc_mounts);
> +}
> +
> +static inline void pidns_proc_unlock_shared(struct pid_namespace *pid_ns)
> +{
> +	up_read(&pid_ns->rw_proc_mounts);
> +}
> +#else /* !CONFIG_PROC_FS */
> +
Apologies for my newbie question. I couldn't help but notice all these 
function calls are assuming that the parameter struct pid_namespace 
*pid_ns will never be NULL.  Is that a good assumption?

I don't have the background in this code to answer on my own, but I 
thought I'd raise the question.

Thanks,
Jay
