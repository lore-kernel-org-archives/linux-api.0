From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v1 1/4] syscalls: Restore address limit after a syscall
Date: Wed, 8 Mar 2017 14:27:18 -0800
Message-ID: <CAJcbSZG21d3=1w5eiWtxUF4ooDiGPZc7wOExPsGiB3D3wTUFLQ@mail.gmail.com>
References: <20170308213844.131877-1-thgarnie@google.com> <20170308215814.GG21222@n2100.armlinux.org.uk>
 <CALCETrX1RpjZxdo1aauQa8hGQPO1Dzn5gU6NoT1CvSKo8ea1uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6939-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrX1RpjZxdo1aauQa8hGQPO1Dzn5gU6NoT1CvSKo8ea1uQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stanislav Kinsburskiy <skinsbursky@virt>
List-Id: linux-api@vger.kernel.org

That make sense. I will optimize each architecture to not require a call.

On Wed, Mar 8, 2017 at 2:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Mar 8, 2017 at 1:58 PM, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
>> On Wed, Mar 08, 2017 at 01:38:41PM -0800, Thomas Garnier wrote:
>>> This patch prevents a syscall to modify the address limit of the
>>> caller. The address limit is kept by the syscall wrapper and restored
>>> just after the syscall ends.
>>
>> I would much rather architectures were given the opportunity to code up
>> checks like this efficiently (iow, inline in the exit path assembly),
>> rather than having to unconditionally call an additional function on
>> every syscall, with its register saving overheads.
>>
>
> Me too.  I think the two config choices should be:
>
> (a) BUG_ON(!segment_eq(...));
>
> (b) No generic check at all -- arch code will handle it
>
> --Andy



-- 
Thomas
