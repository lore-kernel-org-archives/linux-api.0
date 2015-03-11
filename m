From: Mikael Pettersson <mikpelinux@gmail.com>
Subject: Re: [PATCH] Don't allow blocking of signals using sigreturn.
Date: Wed, 11 Mar 2015 22:43:50 +0100
Message-ID: <21760.46870.338764.599348@gargle.gargle.HOWL>
References: <20150311174204.GA5712@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150311174204.GA5712@pc.thejh.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

Jann Horn writes:
 > Or should I throw this patch away and write a patch
 > for the prctl() manpage instead that documents that
 > being able to call sigreturn() implies being able to
 > effectively call sigprocmask(), at least on some
 > architectures like X86?

Well, that is the semantics of sigreturn().  It is essentially
setcontext() [which includes the actions of sigprocmask()], but
with restrictions on parameter placement (at least on x86).

You could introduce some setting to restrict that aspect for
seccomp processes, but you can't change this for normal processes
without breaking things.
