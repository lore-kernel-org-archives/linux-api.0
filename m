From: Roland McGrath <roland@redhat.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed,  1 Apr 2009 14:32:19 -0700 (PDT)
Message-ID: <20090401213219.7B324FC3AB@magilla.sf.frob.com>
References: <49D071A8.4010703@petalogix.com>
	<200904011611.53355.arnd@arndb.de>
	<87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
	<200904011704.13581.arnd@arndb.de>
	<49D3DABA.2050001@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: H. Peter Anvin's message of  Wednesday, 1 April 2009 14:20:58 -0700 <49D3DABA.2050001@zytor.com>
Sender: linux-arch-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@gmail.com>, Geert Uytterhoeven <geert.uytterhoeven@gmail.com>, michal.simek@petalogix.com, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
List-Id: linux-api@vger.kernel.org

> Actually, gcc does have the _LP64 and __SIZEOF_POINTER__ macros (as well 
> as __CHAR_BIT__), although I don't know how far back it does have that. 
>      If it has been with us for long enough it might be possible to 
> switch over to using panarch macros.

Worst case the oldest compilers had <limits.h> and 
"#if ULONG_MAX == 0xffffffffUL", though I wouldn't like
myself to be using a setup where <limits.h> got pulled in.


Thanks,
Roland
