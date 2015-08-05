From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv3 1/1] Documentation: describe how to add a system call
Date: Wed, 5 Aug 2015 18:21:31 +0200
Message-ID: <20150805162131.GB16341@amd>
References: <1438353346-67177-1-git-send-email-drysdale@google.com>
 <1438353346-67177-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438353346-67177-2-git-send-email-drysdale@google.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Josh Triplett <josh@joshtriplett.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

Hi!

> Add a document describing the process of adding a new system call,
> including the need for a flags argument for future compatibility, and
> covering 32-bit/64-bit concerns (albeit in an x86-centric way).
> 
> Signed-off-by: David Drysdale <drysdale@google.com>
> Reviewed-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Reviewed-by: Eric B Munson <emunson@akamai.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  Documentation/adding-syscalls.txt | 531 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 531 insertions(+)
>  create mode 100644 Documentation/adding-syscalls.txt

We usually align documentation to less than 80 columns, afaict.

> +call.  To make sure that userspace programs can safely use flags between kernel
> +versions, check whether the flags value holds any unknown flags, and reject the
> +sycall (with EINVAL) if it does:

syscall?

> +New system call proposals, like any change to the kernel's API, should always
> +be cc'ed to linux-api@vger.kernel.org

. at and of sentence?

> +System Calls Returning Elsewhere
> +--------------------------------
> +
> +For most system calls, once the system call is complete the user program
> +continues exactly where it left off -- at the next instruction, with the same
> +stack and registers as before the system call, and with the same virtual
> +memory space.

Umm. Normally we place return value in register. And I'm not sure.. do
syscalls preserve registers that are normally caller-clobbered in the ABI?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
