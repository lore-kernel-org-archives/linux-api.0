From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: use __kernel_timespec in timeout ABI
Date: Tue, 1 Oct 2019 12:08:16 -0600
Message-ID: <dc4fc8dc-0a6b-19a2-e85b-71fd1ad4c4ca@kernel.dk>
References: <20190930202055.1748710-1-arnd@arndb.de>
 <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
 <623e1d27-d3b1-3241-bfd4-eb94ce70da14@kernel.dk>
 <CAK8P3a3AAFXNmpQwuirzM+jgEQGj9tMC_5oaSs4CfiEVGmTkZg@mail.gmail.com>
 <874l0stpog.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874l0stpog.fsf@oldenburg2.str.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Stefan_B=c3=bchler?= <source@stbuehler.de>, Hannes Reinecke <hare@suse.com>, Jackie Liu <liuyun01@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>, Hristo Venev <hristo@venev.name>, linux-block <linux-block@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/1/19 10:07 AM, Florian Weimer wrote:
> * Arnd Bergmann:
> 
>> On Tue, Oct 1, 2019 at 5:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 10/1/19 8:09 AM, Jens Axboe wrote:
>>>> On 9/30/19 2:20 PM, Arnd Bergmann wrote:
>>>>> All system calls use struct __kernel_timespec instead of the old struct
>>>>> timespec, but this one was just added with the old-style ABI. Change it
>>>>> now to enforce the use of __kernel_timespec, avoiding ABI confusion and
>>>>> the need for compat handlers on 32-bit architectures.
>>>>>
>>>>> Any user space caller will have to use __kernel_timespec now, but this
>>>>> is unambiguous and works for any C library regardless of the time_t
>>>>> definition. A nicer way to specify the timeout would have been a less
>>>>> ambiguous 64-bit nanosecond value, but I suppose it's too late now to
>>>>> change that as this would impact both 32-bit and 64-bit users.
>>>>
>>>> Thanks for catching that, Arnd. Applied.
>>>
>>> On second thought - since there appears to be no good 64-bit timespec
>>> available to userspace, the alternative here is including on in liburing.
>>
>> What's wrong with using __kernel_timespec? Just the name?
>> I suppose liburing could add a macro to give it a different name
>> for its users.
> 
> Yes, mostly the name.
> 
> __ names are reserved for the C/C++ implementation (which does not
> include the kernel).  __kernel_timespec looks like an internal kernel
> type to the uninitiated, not a UAPI type.
> 
> Once we have struct timespec64 in userspace, you also end up with
> copying stuff around or introducing aliasing violations.
> 
> I'm not saying those concerns are valid, but you asked what's wrong with
> it. 8-)

FWIW, I do agree, __kernel_timespec sounds like an internal type, not
something apps should be using. timespec64 works a lot better for that.
Oh well.

-- 
Jens Axboe
