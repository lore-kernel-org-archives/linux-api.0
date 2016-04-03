From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86: Add a turbo mode sysctl
Date: Sun, 3 Apr 2016 12:12:04 +0200
Message-ID: <20160403101204.GC19007@pd.tnic>
References: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto@kernel.org>
 <alpine.DEB.2.11.1604011803390.3978@nanos>
 <CALCETrUfy-yZ6FD7J3AwhP7KB5eZ+YRMrKS_CyNDLvJwmiC49g@mail.gmail.com>
 <alpine.DEB.2.11.1604031151040.3978@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1604031151040.3978@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 03, 2016 at 11:55:34AM +0200, Thomas Gleixner wrote:
> While at it can you please make a turbo = 0 call when we hit a WARN/BUG/Panic
> so the messages spill slower over the screen?

Good idea!

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
