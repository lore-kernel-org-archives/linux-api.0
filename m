From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit time_t conversion
Date: Wed, 15 Nov 2017 15:11:31 -0800
Message-ID: <CABeXuvpy1jbqjeUFHHX-MrJXQLA2QNYbAa6OX7qOpPp4q-mQYQ@mail.gmail.com>
References: <20171110224259.15930-1-deepa.kernel@gmail.com> <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, cohuck@redhat.com, David Miller <davem@davemloft.net>, Helge Deller <deller@gmx.de>, devel@driverdev.osuosl.org, gerald.schaefer@de.ibm.com, gregkh <gregkh@linuxfoundation.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jan Hoeppner <hoeppner@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Julian
List-Id: linux-api@vger.kernel.org

> I had on concern about x32, maybe we should check
> for "COMPAT_USE_64BIT_TIME" before zeroing out the tv_nsec
> bits.

Thanks, I think you are right. I had the check conditional on
CONFIG_64BIT_TIME and then removed as I forgot why I added it. :)

> Regarding CONFIG_COMPAT_TIME/CONFIG_64BIT_TIME, would
> it help to just leave out that part for now and unconditionally
> define '__kernel_timespec' as 'timespec' until we are ready to
> convert the architectures?

Another approach would be to use separate configs:

1. To indicate 64 bit time_t syscall support. This will be dependent
on architectures as CONFIG_64BIT_TIME.
We can delete this once all architectures have provided support for this.

2. Another config (maybe COMPAT_32BIT_TIME?) to be introduced later,
which will compile out all syscalls/ features that use 32 bit time_t.
This can help build a y2038 safe kernel later.

Would this work for everyone?

-Deepa
