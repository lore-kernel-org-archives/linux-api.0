From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Tue, 14 Mar 2017 02:40:51 -0700
Message-ID: <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com>
References: <20170311000501.46607-1-thgarnie@google.com>
 <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com>
 <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-7022-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>
List-Id: linux-api@vger.kernel.org

On 03/13/17 17:04, H. Peter Anvin wrote:
> On 03/11/17 01:42, Ingo Molnar wrote:
>>>  
>>> +	/*
>>> +	 * Check user-mode state on fast path return, the same check is done
>>> +	 * under the slow path through syscall_return_slowpath.
>>> +	 */
>>> +#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>>> +	call	verify_pre_usermode_state
>>> +#else
>>> +	/*
>>> +	 * Similar to set_fs(USER_DS) in verify_pre_usermode_state without a
>>> +	 * warning.
>>> +	 */
>>> +	movq	PER_CPU_VAR(current_task), %rax
>>> +	movq	$TASK_SIZE_MAX, %rcx
>>> +	cmp	%rcx, TASK_addr_limit(%rax)
>>> +	jz	1f
>>> +	movq	%rcx, TASK_addr_limit(%rax)
>>> +1:
>>> +#endif
>>> +
> 
> How about simply doing...
> 
> 	movq	PER_CPU_VAR(current_task), %rax
> 	movq	$TASK_SIZE_MAX, %rcx
> #ifdef CONFIG_BUG_ON_DATA_CORRUPTION
> 	cmpq	%rcx, TASK_addr_limit(%rax)
> 	jne	syscall_return_slowpath
> #else
> 	movq	%rcx, TASK_addr_limit(%rax)
> #endif
> 
> ... and let the slow path take care of BUG.  This should be much faster,
> even with the BUG, and is simpler to boot.
> 

In fact, we could even to the cmpq/jne unconditionally.  I'm guessing
the occasional branch mispredict will be offset by occasionally touching
a clean cacheline in the case of an unconditional store.

Since this is something that should never happen, performance doesn't
matter.

	-hpa
