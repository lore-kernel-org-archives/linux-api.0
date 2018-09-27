From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Thu, 27 Sep 2018 23:41:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809272335430.8118@nanos.tec.linutronix.de>
References: <20180919205037.9574-1-dima@arista.com>        <874lej6nny.fsf@xmission.com>        <20180924205119.GA14833@outlook.office365.com>        <874leezh8n.fsf@xmission.com>        <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrey Vagin <avagin@virtuozzo.com>, Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey Dobriyan <ado>
List-Id: linux-api@vger.kernel.org

On Thu, 27 Sep 2018, Thomas Gleixner wrote:
> Add time skew via NTP/PTP into the picture and you might have to adjust
> timers as well, because you need to guarantee that they are not expiring
> early.
> 
> I haven't looked through Dimitry's patches yet, but I don't see how this
> can work at all without introducing subtle issues all over the place.

And just a quick scan tells me that this is broken. Timers will expire
early or late. The latter is acceptible to some extent, but larger delays
might come with surprise. Expiring early is an absolute nono.

Thanks,

	tglx
