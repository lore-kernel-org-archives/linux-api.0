From: Jann Horn <jann@thejh.net>
Subject: [PATCH] seccomp.2: Add note about alarm(2) not being sufficient to
 limit runtime
Date: Thu, 12 Mar 2015 14:07:01 +0100
Message-ID: <20150312130701.GA11073@pc.thejh.net>
References: <20150311174204.GA5712@pc.thejh.net>
 <21760.46870.338764.599348@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21760.46870.338764.599348@gargle.gargle.HOWL>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikael Pettersson <mikpelinux@gmail.com>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 11, 2015 at 10:43:50PM +0100, Mikael Pettersson wrote:
> Jann Horn writes:
>  > Or should I throw this patch away and write a patch
>  > for the prctl() manpage instead that documents that
>  > being able to call sigreturn() implies being able to
>  > effectively call sigprocmask(), at least on some
>  > architectures like X86?
> 
> Well, that is the semantics of sigreturn().  It is essentially
> setcontext() [which includes the actions of sigprocmask()], but
> with restrictions on parameter placement (at least on x86).
> 
> You could introduce some setting to restrict that aspect for
> seccomp processes, but you can't change this for normal processes
> without breaking things.

Then I think it's probably better and easier to just document the existing
behavior? If a new setting would have to be introduced and developers would
need to be aware of that, it's probably easier to just tell everyone to use
SIGKILL.

Does this manpage patch look good?

---
 man2/seccomp.2 | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/man2/seccomp.2 b/man2/seccomp.2
index 702ceb8..f762d07 100644
--- a/man2/seccomp.2
+++ b/man2/seccomp.2
@@ -64,6 +64,31 @@ Strict secure computing mode is useful for number-crunching
 applications that may need to execute untrusted byte code, perhaps
 obtained by reading from a pipe or socket.
 
+Note that although the calling thread can no longer call
+.BR sigprocmask (2),
+it can use
+.BR sigreturn (2)
+to block all signals apart from
+.BR SIGKILL
+and
+.BR SIGSTOP .
+Therefore, to reliably terminate it,
+.BR SIGKILL
+has to be used, meaning that e.g.
+.BR alarm (2)
+is not sufficient for restricting its runtime. Instead, use
+.BR timer_create (2)
+with
+.BR SIGEV_SIGNAL
+and
+.BR sigev_signo
+set to
+.BR SIGKILL
+or use
+.BR setrlimit (2)
+to set the hard limit for
+.BR RLIMIT_CPU .
+
 This operation is available only if the kernel is configured with
 .BR CONFIG_SECCOMP
 enabled.
-- 
2.1.4
