From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: New syscall: leftpad()
Date: Fri, 1 Apr 2016 10:06:05 +0200
Message-ID: <56FE2BED.2060402@nod.at>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
 <56FDB478.4020609@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56FDB478.4020609-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am 01.04.2016 um 01:36 schrieb Randy Dunlap:
> Please be more careful in your description...

I'm very sorry. Will do a v2 soon. ;-)

> On 03/31/16 15:33, Richard Weinberger wrote:
>> Recent happenings in the node.js community showed how fragile software is when
>> it comes to dependencies of fundamental algorithms like leftpad[1].
>> A node.js package which provided ledpad vanished and broke a lot of software.
> 
>                                    leftpad
> 
>> This raised our attention and we came to the conclusion that it is the kernel's
>> job to provide such functionality such that node.js based applications can in future
>> rely in Linux's "don't break userspace" rule.
>> We hope that glibc and Andoid's bionic will soon offer wrapper functions for this
> 
>                          Android's
> 
>> new leftpad system call.
>> We put leftpad into the kernel not only because of Linux's stable ABI,
>> also for performance reasons.
>> As everyone knows, within the kernel everything is faster and better.
>> Leftpad has millions of users, so it has to be as fast as possible.
>> This new system call will also help making services like left-pad.io[2]
>> faster and more reliable. If the leftpad() system call gets adopted by a wider user base
>> it might also make sense to add a generic npm() system call which acts like ioctl()
>> where kernel modules can register new functions that are often used by node.js.
>> Such functions might be, is_array(), is_int(), etc.
> 
> 

Thanks,
//richard
