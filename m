From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 01 Apr 2009 14:20:58 -0700
Message-ID: <49D3DABA.2050001@zytor.com>
References: <49D071A8.4010703@petalogix.com> <200904011611.53355.arnd@arndb.de> <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com> <200904011704.13581.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <200904011704.13581.arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Newton <will.newton@gmail.com>, Geert Uytterhoeven <geert.uytterhoeven@gmail.com>, michal.simek@petalogix.com, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
List-Id: linux-api@vger.kernel.org

Arnd Bergmann wrote:
> 
> Unfortunately, there is no generic way to detect the word size yet,
> but every architecture uses its own preprocessor macro (__x86_64__,
> __s390x__, __ppc64__). We also can't use CONFIG_64BIT in an user-exported
> interface header file, because the use space can also be compiled for
> 32 bits when the kernel uses 64 bits.
> 

Actually, gcc does have the _LP64 and __SIZEOF_POINTER__ macros (as well 
as __CHAR_BIT__), although I don't know how far back it does have that. 
     If it has been with us for long enough it might be possible to 
switch over to using panarch macros.

	-hpa
