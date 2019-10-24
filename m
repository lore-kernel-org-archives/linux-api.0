From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCHv7 18/33] lib/vdso: Add unlikely() hint into
 vdso_read_begin()
Date: Thu, 24 Oct 2019 14:14:19 +0100
Message-ID: <c749983f-24a8-a159-5e29-6fdd741f6023@arm.com>
References: <20191011012341.846266-1-dima@arista.com>
 <20191011012341.846266-19-dima@arista.com>
 <100f6921-9081-7eb0-7acc-f10cfb647c21@arm.com>
 <20191024061311.GA4541@gmail.com>
 <9aa9857e-ee1c-0117-bfcb-45fc6bcab866@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9aa9857e-ee1c-0117-bfcb-45fc6bcab866@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Andrei,

On 10/24/19 10:30 AM, Vincenzo Frascino wrote:
[...]
>> Here is my test:
>> https://github.com/avagin/vdso-perf
>>
>> It is calling clock_gettime() in a loop for three seconds and then
>> reports a number of iterations.
>>
> 
> I am happy to run the test on arm64 and provide some results.
>

Please find below the results:

clock            | before     | after      | diff
==================================================
monotonic          17326692     17951770     3.6%
monotonic-coarse   43624027     44215292     1.3%
monotonic-raw      17541809     17554932     0.1%
boottime           17334982     17954361     3.5%

The improvement for arm64 for monotonic and boottime is around 3.5%.

I created a pull request on github to send to you back the changes I had
to do to vdso-perf to cross-compile it on arm64 [1].

[1] https://github.com/avagin/vdso-perf/pull/1


>> Thanks,
>> Andrei
>>
> 

-- 
Regards,
Vincenzo
