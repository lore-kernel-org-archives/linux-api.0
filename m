From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] x86: always use SYSCALL_DEFINE*
Date: Tue, 13 Mar 2018 14:16:01 -0700
Message-ID: <CAG48ez1RBhBbH8jHwseeZMQwdKciLdjYhoy3O9yDs8WEpMk2TQ@mail.gmail.com>
References: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Cc: "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 10, 2018 at 12:55 PM, Tautschnig, Michael
<tautschn@amazon.co.uk> wrote:
> All syscall arguments are passed in as types of the same byte size as
> unsigned long (width of full registers). Using a smaller type without a
> cast may result in losing bits of information. SYSCALL_DEFINE* introduce
> adequate type casts. All definitions of syscalls in x86 except for those
> patched here have already been using the appropriate SYSCALL_DEFINE*.
[...]
> diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
> index 2f72330..d98b2a3 100644
> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -23,7 +23,8 @@
>  /*
>   * this changes the io permissions bitmap in the current task.
>   */
> -asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
> +SYSCALL_DEFINE3(sys_ioperm, unsigned long, from, unsigned long, num, int,
> +               turn_on)

Shouldn't this be "SYSCALL_DEFINE3(ioperm, [...]", without the "sys_"?
