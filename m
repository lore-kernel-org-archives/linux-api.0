From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 17/23] y2038: time: avoid timespec usage in settimeofday()
Date: Thu, 14 Nov 2019 15:35:35 +0100
Message-ID: <CAK8P3a0qm1FW+mqcMvzyb8WVvqtF-POMpir+WVezEObaYLCCRg@mail.gmail.com>
References: <20191108210236.1296047-1-arnd@arndb.de> <20191108211323.1806194-8-arnd@arndb.de>
 <alpine.DEB.2.21.1911132250010.2507@nanos.tec.linutronix.de>
 <CAK8P3a2bxDZVKgcJoa99wr3tDyYckQAdk2f=RnL4vTFPjm3tXQ@mail.gmail.com> <alpine.DEB.2.21.1911141457120.2507@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911141457120.2507@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, John Stultz <john.stultz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, Corey Minyard <cminyard@mvista.com>, zhengbin <zhengbin13@huawei.com>, Li RongQing <lirongqing@baidu.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 14, 2019 at 3:04 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 14 Nov 2019, Arnd Bergmann wrote:
> > On Wed, Nov 13, 2019 at 10:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > My idea was to not duplicate the range check that is done
> > in do_sys_settimeofday64() and again in do_settimeofday64:
> >
> >         if (!timespec64_valid_settod(ts))
> >                 return -EINVAL;
> >
> > The only check we should need in addition to this is to ensure
> > that passing an invalid tv_usec number doesn't become an
> > unexpectedly valid tv_nsec after the multiplication.
>
> Right, but please add a proper comment as you/we are going to scratch heads
> 4 weeks from now when staring at that check and wondering why it is
> incomplete.

Ok, done. I had just uploaded the branch with the fixup for
the __user pointer access in the same patch, but that version
had introduced another typo. I hope the version I uploaded
now has all known issues addressed for tomorrow's linux-next.

      Arnd
