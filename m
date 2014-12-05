From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
Date: Fri, 5 Dec 2014 15:54:17 +0900
Message-ID: <20141205065417.GA3358@bbox>
References: <5480E715.3020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5480E715.3020900@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rth@twiddle.net" <rth@twiddle.net>, "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>, "mattst88@gmail.com" <mattst88@gmail.com>, Ralf Baechle <ralf@linux-mips.org>, "jejb@parisc-linux.org" <jejb@parisc-linux.org>, "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>, "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>, Arnd Bergmann <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
> For uapi, need try to let all macros have same value, and MADV_FREE is
> added into main branch recently, so need redefine MADV_FREE for it.
> 
> At present, '8' can be shared with all architectures, so redefine it to
> '8'.
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>


Hello Chen,

Thanks for looking at this.
Feel free to add my sign.

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
