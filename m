From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 1 Apr 2009 19:55:52 +0200
Message-ID: <200904011955.53235.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com> <200903301717.57184.arnd@arndb.de> <200904011611.53355.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <200904011611.53355.arnd@arndb.de>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Cc: michal.simek@petalogix.com, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
List-Id: linux-api@vger.kernel.org

On Wednesday 01 April 2009, Arnd Bergmann wrote:
> +/* fs/readdir.c */
> +#define __NR3264_getdents __LINE__
> +__SC_3264(__NR3264_getdents, sys_getdents64, sys_getdents)

Just noticed myself that getdents64 changed more than just off_t
(namely the file type) and should be used even on 64-bit platforms,
so I'm putting sys_getdents into my deprecated list now.

	Arnd <><
