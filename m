From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv4 09/28] timens: Shift /proc/uptime
Date: Sun, 16 Jun 2019 18:48:05 +0100
Message-ID: <6e675417-37ee-0799-60d9-f85812485842@gmail.com>
References: <20190612192628.23797-1-dima@arista.com>
 <20190612192628.23797-10-dima@arista.com>
 <alpine.DEB.2.21.1906141549560.1722@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1906141549560.1722@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 6/14/19 2:50 PM, Thomas Gleixner wrote:
> On Wed, 12 Jun 2019, Dmitry Safonov wrote:
> 
> Again, please use the usual prefix and bolt not everything to
> timens. timens: is the proper prefix for the actual time namespace core
> code.

Yep, will do.

Thanks,
          Dmitry
