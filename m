From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Mon, 01 Dec 2014 09:57:37 -0700
Message-ID: <547C9E01.9000606@osg.samsung.com>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au> <2940943.qiYEMaLEXx@wuerfel> <20141023081457.GE16267@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141023081457.GE16267@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/23/2014 02:14 AM, Cyrill Gorcunov wrote:
> On Thu, Oct 23, 2014 at 09:49:14AM +0200, Arnd Bergmann wrote:
>> On Thursday 23 October 2014 16:07:12 Michael Ellerman wrote:
>>> --- a/include/linux/kcmp.h
>>> +++ b/include/linux/kcmp.h
>>> @@ -1,17 +1,6 @@
>>>  #ifndef _LINUX_KCMP_H
>>>  #define _LINUX_KCMP_H
>>>  
>>> -/* Comparison type */
>>> -enum kcmp_type {
>>> -       KCMP_FILE,
>>> -       KCMP_VM,
>>> -       KCMP_FILES,
>>> -       KCMP_FS,
>>> -       KCMP_SIGHAND,
>>> -       KCMP_IO,
>>> -       KCMP_SYSVSEM,
>>> -
>>> -       KCMP_TYPES,
>>> -};
>>> +#include <uapi/linux/kcmp.h>
>>>  
>>>  #endif /* _LINUX_KCMP_H */
>>>
>>
>> If the file is empty except for the uapi include, I think it's better to
>> delete it completely. The include path logic should ensure we pick the
>> other one up.
> 
> Good point, somehow managed to miss this.
> 

Michael,

Are you planning to send v2 to address the comments?

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
