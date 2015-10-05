From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] timerfd: expose uapi header
Date: Mon, 05 Oct 2015 16:57:21 +0200
Message-ID: <5414742.dPp9ExW9xv@wuerfel>
References: <1444056829-9118-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444056829-9118-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Gabriel Laskar <gabriel@lse.epita.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, Hans Verkuil <hans.verkuil@cisco.com>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, stephen hemminger <stephen@networkplumber.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, Masahiro Yamada <yamada.m@jp.panasonic.com>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Monday 05 October 2015 16:53:39 Gabriel Laskar wrote:
> this patch expose the timerfd apis to the userland. It is already in
> glibc header sys/timerfd.h but not synchronised, and missing the ioctl
> number definition.
> 
> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> 

What happens if you include both sys/timerfd.h and linux/timerfd.h then? 

> header-y += telephony.h
> header-y += termios.h
> header-y += thermal.h
>+header-y += tiemrfd.h
> header-y += time.h
> header-y += times.h
> header-y += timex.h

s/tiemrfd/timerfd/

	Arnd
