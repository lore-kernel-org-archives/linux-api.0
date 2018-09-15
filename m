From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 4/5] pselect6: use __kernel_timespec
Date: Sat, 15 Sep 2018 17:27:59 +0200
Message-ID: <CAK8P3a2Kkm2ubg_MVN_BJL=s7qpUB1-np=9zVpcJ2U-aPAJswg@mail.gmail.com>
References: <20180915050843.19183-1-deepa.kernel@gmail.com> <20180915050843.19183-5-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180915050843.19183-5-deepa.kernel@gmail.com>
Sender: owner-linux-aio@kvack.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 15, 2018 at 7:09 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:

> +#if defined(CONFIG_64BIT_TIME)
> +
> +COMPAT_SYSCALL_DEFINE6(pselect6_time64, int, n, compat_ulong_t __user *, inp,
> +       compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
> +       struct __kernel_timespec __user *, tsp, void __user *, sig)

I got a link error here since compat_sys_pselect6_time64 and
compat_sys_ppoll_time64 are only defined when CONFIG_64BIT_TIME
is set.

I did not think we would select this symbol on arm64, is that a mistake
on my side, or should the #ifdef check be removed?

      Arnd

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
