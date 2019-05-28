From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] [RFC] Remove bdflush syscall stub
Date: Tue, 28 May 2019 12:25:09 +0200
Message-ID: <mvmr28idgfu.fsf@linux-m68k.org>
References: <20190528101012.11402-1-chrubis@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528101012.11402-1-chrubis@suse.cz> (Cyril Hrubis's message
        of "Tue, 28 May 2019 12:10:12 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, Michal Simek <monstr@monstr.eu>, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mai 28 2019, Cyril Hrubis <chrubis@suse.cz> wrote:

> I've tested the patch on i386. Before the patch calling bdflush() with
> attempt to tune a variable returned 0 and after the patch the syscall
> fails with EINVAL.

Should be ENOSYS, doesn't it?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
