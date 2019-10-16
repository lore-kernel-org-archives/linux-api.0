From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv7 01/33] ns: Introduce Time Namespace
Date: Wed, 16 Oct 2019 14:57:59 +0100
Message-ID: <4f60ac96-c684-e4a8-e60d-e90c658db025@gmail.com>
References: <20191011012341.846266-1-dima@arista.com>
 <20191011012341.846266-2-dima@arista.com>
 <80af93da-d497-81de-2a2a-179bb3bc852d@arm.com>
 <alpine.DEB.2.21.1910161230070.2046@nanos.tec.linutronix.de>
 <5f4c2f29-ca68-b19c-017f-d23730f6e871@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5f4c2f29-ca68-b19c-017f-d23730f6e871@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On 10/16/19 11:44 AM, Vincenzo Frascino wrote:
> On 10/16/19 11:39 AM, Thomas Gleixner wrote:
[..]
>> config TIME_NS
>> 	bool "TIME namespace"
>> 	depends on GENERIC_VDSO_TIME_NS
>> 	default y
>>
>> and in lib/vdso/Kconfig
>>
>> config GENERIC_VDSO_TIME_NS
>> 	bool
>>
>> and let architectures which have support for the VDSO bits select it.
>>
> 
> Agreed, this is even better.

Thanks, will fix in v8,
          Dmitry
