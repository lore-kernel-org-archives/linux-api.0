From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 02/28] timens: Add timens_offsets
Date: Fri, 14 Jun 2019 15:11:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906141510100.1722@nanos.tec.linutronix.de>
References: <20190612192628.23797-1-dima@arista.com> <20190612192628.23797-3-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612192628.23797-3-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 12 Jun 2019, Dmitry Safonov wrote:

> From: Andrei Vagin <avagin@openvz.org>
> 
> Introduce offsets for time namespace. They will contain an adjustment
> needed to convert clocks to/from host's.
> 
> Allocate one page for each time namespace that will be premapped into
> userspace among vvar pages.
> index 000000000000..7d7cb68ea778
> --- /dev/null
> +++ b/include/linux/timens_offsets.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_TIME_OFFSETS_H
> +#define _LINUX_TIME_OFFSETS_H
> +
> +struct timens_offsets {
> +};

That empty struct which is nowhere used looks odd. Can you move that to the
patch which actually makes use of it?

Thanks,

	tglx
