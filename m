From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH v5] Documentation/arch: Add Documentation/arch-TODO
Date: Wed, 13 May 2015 15:18:36 +0200
Message-ID: <20150513131835.GJ1517@pd.tnic>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150513094756.GD11030@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 11:47:56AM +0200, Ingo Molnar wrote:
>  - introduce the '..' denotion (in the final table) to show features 
>    that cannot be supported by an architecture due to hardware 
>    dependencies:
> 
> 		   gcov-profile-all:---------------.
> 				THP:--------.      |
> 		      irq-time-acct:-.      |      |
> 				     |      |      |
> 		----------------------------------------
> 		  alpha           | TODO | TODO | TODO |
> 		  arc             | TODO |  ..  | TODO |
> 		  arm             |  ok  |  ok  |  ok  |
> 		  arm64           | TODO |  ok  |  ok  |
> 		  avr32           | TODO |  ..  | TODO |
> 		  blackfin        | TODO |  ..  | TODO |
> 		  c6x             | TODO |  ..  | TODO |
> 
>    so in the 'THP' column, if an architecture could in theory support 
>    THP, it's listed as 'TODO', if it cannot, it's listed as '..'.

Shouldn't exactly that explanation be in the text file itself too?

Also, how about s/TODO//g for less clutter:

+----------------------------------------------------------------------------------
+  alpha           |      |      |      |      |      |      |  ok  |  ok  |      |
+  arc             |  ok  |      |      |      |      |  ok  |  ok  |  ok  |      |
+  arm             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |      |  ok  |  ok  |
...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
