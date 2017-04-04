From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Tue, 4 Apr 2017 11:11:03 -0700
Message-ID: <b2b1b4fe-18ea-7643-09c0-312fd8f4b4d8@zytor.com>
References: <20170404174727.35478-1-thgarnie@google.com>
 <20170404174727.35478-2-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170404174727.35478-2-thgarnie@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>
Cc: linux-s390@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 04/04/17 10:47, Thomas Garnier wrote:
> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for x86.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>  
> +	/*
> +	 * If address limit is not based on user-mode, jump to slow path for
> +	 * additional security checks.
> +	 */
> +	movq	$TASK_SIZE_MAX, %rcx
> +	cmp	%rcx, TASK_addr_limit(%r11)
> +	jnz	1f
> +
>  	LOCKDEP_SYS_EXIT

Nitpick: use jne not jnz when comparing for equality.  Same instruction
but more readable.

	-hpa
