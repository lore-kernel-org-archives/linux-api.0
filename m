From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 4/4] arm64/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Thu, 9 Mar 2017 16:26:13 +0000
Message-ID: <20170309162613.GN21222@n2100.armlinux.org.uk>
References: <20170309012456.5631-1-thgarnie@google.com>
 <20170309012456.5631-4-thgarnie@google.com>
 <20170309122354.GB6320@leverpostej>
 <CAJcbSZGCFhUx79=bMkOxDRvbfuHmVBWU02HBgEU9T2s7mTChAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-6975-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZGCFhUx79=bMkOxDRvbfuHmVBWU02HBgEU9T2s7mTChAw@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Thomas Garnier <thgarnie@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel
List-Id: linux-api@vger.kernel.org

On Thu, Mar 09, 2017 at 07:56:49AM -0800, Thomas Garnier wrote:
> On Thu, Mar 9, 2017 at 4:23 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > We generally stick to lower case for the arm64 assembly macros. If we
> > need this, we should stick to the existing convention.
> >
> >> +/* Similar to set_fs(USER_DS) in verify_pre_usermode_state without a warning. */
> >> +.macro VERIFY_PRE_USERMODE_STATE
> >> +     mov     x1, #TASK_SIZE_64
> >> +     str     x1, [tsk, #TSK_TI_ADDR_LIMIT]
> >> +.endm
> >
> > We need arm64's set_fs() to configure UAO, too, so this is much weaker
> > than set_fs(), and will leave __{get,put}_user and
> > __copy_{to,from}_user() able to access kernel memory.
> >
> > We don't currently have an asm helper to clear UAO, and unconditionally
> > poking that on exception return is liable to be somewhat expensive.
> >
> > Also, given we're only trying to catch this in syscalls, I'm afraid I
> > don't see what we gain by doing this in the entry assembly.
> >
> 
> I optimized all architectures from the arm (32-bit) discussion. I will
> come back to a simple bl to the verify function. Thanks!

I wouldn't call what you've done on ARM an "optimisation", because my
comment about making the fast path worthless still stands.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
