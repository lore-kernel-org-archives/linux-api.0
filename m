From: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Tue, 14 Nov 2017 19:24:22 +0100
Message-ID: <95f902ea-3e97-0280-2d52-28cadef7806d@redhat.com>
References: <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com>
 <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com>
 <20171114160541.GC3165@worktop.lehotels.local>
 <CALCETrVpBocmrd+R5-R-d+QBvp6h8iZkjo7Xjy6V6x1rPfh25w@mail.gmail.com>
 <alpine.DEB.2.20.1711141713050.2044@nanos>
 <CALCETrXpR7ai047pHtdQe5J+FpuFO5ekeeEqLUt1wVLopyNt_Q@mail.gmail.com>
 <20171114163159.GD3165@worktop.lehotels.local>
 <6f9f57fa-8057-cdbe-231b-20920b3b3670@redhat.com>
 <20171114174049.GF3165@worktop.lehotels.local>
 <ada6faaf-9e94-439f-57f2-3b9179cb4bea@redhat.com>
 <20171114181732.bwahj6woik27trou@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114181732.bwahj6woik27trou-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux@armlinux.o>
List-Id: linux-api@vger.kernel.org

On 11/14/2017 07:17 PM, Peter Zijlstra wrote:
> On Tue, Nov 14, 2017 at 07:01:55PM +0100, Daniel Bristot de Oliveira wrote:
>> On 11/14/2017 06:40 PM, Peter Zijlstra wrote:
>>> On Tue, Nov 14, 2017 at 06:17:13PM +0100, Daniel Bristot de Oliveira wrote:
>>>
>>>> IIRC, if the dest cpu is idle and the system is with idle=poll, no IPI
>>>> is fired as well, but that is not a very common case.
>>>
>>> You're thinking about wake from idle? That is almost always without IPI,
>>> even without idle=poll.
>>>
>>
>> I meant the resched_curr(rq) of an rq on another CPU. If the dest is
>> idle && idle=poll, the IPI will not be send.
> 
> I'm saying the IPI will not be send even without idle=poll. MWAIT based
> idle will also have TIF_POLLING_NRFLAG set.
> 

Yeah! you are right! I missed that point... sorry :-)

-- Daniel
