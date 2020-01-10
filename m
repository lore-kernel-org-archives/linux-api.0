From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCHv8 00/34] kernel: Introduce Time Namespace
Date: Fri, 10 Jan 2020 09:52:37 +0000
Message-ID: <1f81e2ef-93fb-926e-9953-c529675e6f4b@arm.com>
References: <20191112012724.250792-1-dima@arista.com>
 <20191121180555.GA440967@gmail.com>
 <CAJwJo6ahGVHHgwFsPyjbY1PgmHs+D+A2Cma03ogvQGr+mPqYAw@mail.gmail.com>
 <87y2ug9w1h.fsf@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y2ug9w1h.fsf@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Dmitry Safonov <0x7f454c46@gmail.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: Dmitry Safonov <dima@arista.com>, Andrei Vagin <avagin@gmail.com>, open list <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, crml <criu@openvz.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Thomas,

On 1/9/20 9:09 PM, Thomas Gleixner wrote:
> Dmitry Safonov <0x7f454c46@gmail.com> writes:
> 
>> Gentle ping, in case you have time to look at this.
> 
> I'm looking at it and so far I'm quite happy.
> 
> Andy, Vincenco any opinions?
> 

I started looking at them after the holidays, in general I am happy with what I
have seen till now.

I would like to complete some testing especially on the platforms that are not
touched by this patchset to make sure that there are no side effects on the
unified vDSOs and then I think I am ok with the series.

> Thanks,
> 
>         tglx
> 

-- 
Regards,
Vincenzo
