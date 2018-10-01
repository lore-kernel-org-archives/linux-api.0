From: Andrey Vagin <avagin@virtuozzo.com>
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Mon, 1 Oct 2018 23:20:47 +0000
Message-ID: <20181001232033.GA31324@outlook.office365.com>
References: <20180919205037.9574-1-dima@arista.com>
 <874lej6nny.fsf@xmission.com> <20180924205119.GA14833@outlook.office365.com>
 <874leezh8n.fsf@xmission.com> <20180925014150.GA6302@outlook.office365.com>
 <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1809272335430.8118@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809272335430.8118@nanos.tec.linutronix.de>
Content-Language: en-US
Content-ID: <8C46EDA933FB6941ACA5110F5EB9E607@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 11:41:49PM +0200, Thomas Gleixner wrote:
> On Thu, 27 Sep 2018, Thomas Gleixner wrote:
> > Add time skew via NTP/PTP into the picture and you might have to adjust
> > timers as well, because you need to guarantee that they are not expirin=
g
> > early.
> >=20
> > I haven't looked through Dimitry's patches yet, but I don't see how thi=
s
> > can work at all without introducing subtle issues all over the place.
>=20
> And just a quick scan tells me that this is broken. Timers will expire
> early or late. The latter is acceptible to some extent, but larger delays
> might come with surprise. Expiring early is an absolute nono.

Do you mean that we have to adjust all timers after changing offset for
CLOCK_MONOTONIC or CLOCK_BOOTTIME? Our idea is that offsets for
monotonic and boot times will be set immediately after creating a time
namespace before using any timers.

It is interesting to think what a use-case for changing these offsets
after creating timers. It may be useful for testing needs. A user sets a
timer in an hour and then change a clock offset forward and check that a
test application handles the timer properly.

>=20
> Thanks,
>=20
> 	tglx
>=20
