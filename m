From: Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Thu, 14 May 2015 13:55:17 +1000
Message-ID: <20150514035517.GA27285@drongo.ozlabs.ibm.com>
References: <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150513134842.GA1657@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 03:48:42PM +0200, Ingo Molnar wrote:
> 
> Updated patch attached - I've added a few more features to the last 
> table, and restructured the explanations, now every feature 
> description also lists the Kconfig variable that it's tracking, e.g.:
> 
>       irq time acct: HAVE_IRQ_TIME_ACCOUNTING

Regarding that one specifically, as far as I can see,
HAVE_IRQ_TIME_ACCOUNTING is only relevant for tick-based time
accounting.  If you have CONFIG_VIRT_CPU_ACCOUNTING you get accurate
irq time accounting with or without HAVE_IRQ_TIME_ACCOUNTING.  So how
about making this one:

	irq time acct: HAVE_IRQ_TIME_ACCOUNTING || VIRT_CPU_ACCOUNTING

That would make the "irq time acct" entry for powerpc be "ok".

Paul.
