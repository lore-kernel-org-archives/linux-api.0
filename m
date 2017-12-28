From: Ozgur <ozgur@goosey.org>
Subject: Re: rtc: sysfs: move sysfs interface to Documentation/ABI
Date: Thu, 28 Dec 2017 21:30:14 +0300
Message-ID: <4310831514485814@web18g.yandex.ru>
References: <20171228133132.GA3927@mordor.localdomain>
         <434381514470951@web50o.yandex.ru>
         <480511514471013@web35j.yandex.ru> <20171228150027.GA11300@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171228150027.GA11300@mordor.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Aishwarya Pant <aishpant@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, "linux-rtc@vger.kernel.org" <linux-rtc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org



28.12.2017, 18:00, "Aishwarya Pant" <aishpant@gmail.com>:
> On Thu, Dec 28, 2017 at 05:23:33PM +0300, Ozgur wrote:
>>  28.12.2017, 17:22, "Ozgur" <okaratas@yandex.com>:
>>  > 28.12.2017, 16:31, "Aishwarya Pant" <aishpant@gmail.com>:
>>  >>  Hi
>>
>>   Hello,
>>
>>  >>  In Documentation/rtc.txt, there is a description of the sysfs
>>  >>  interface which could be moved to Documentation/ABI.
>>  >>
>>  >>  Would such a change be useful?
>>  >>
>>  >>  The ABI documentation format looks like the following:
>>  >>
>>  >>  What: (the full sysfs path of the attribute)
>>  >>  Date: (date of creation)
>>  >>  KernelVersion: (kernel version it first showed up in)
>>  >>  Contact: (primary contact)
>>  >>  Description: (long description on usage)
>>  >>
>>  >>  I am doing this in an exercise to move sysfs ABI interfaces (which are
>>  >>  documented) to their right place i.e. in Documentation/ABI along with the rest.
>>
>>   Do I understand right? Are you want to make the rtc.txt part the same format as ABI folder?
>>   for example create to RTC folder and add /dev/rtc what, date, kernelversion, contact right?
>
> Yes I mentioned just the sysfs interface. But both ioctl and sysfs interface
> should be there in Documentation/ABI. There could a new file called sysfs-rtc in
> Documentation/ABI/stable with both these interfaces.

Hello,

I think the ABI maintainer is API group but I think you have contact to linux documentation team. 
maybe, Greg provide a  give information:

>>   This can be a good idea and I can help.
>
> Sure thanks. I can maybe send a patch with these changes.
>
> One question: who should be the primary contact for this ABI?

I add linux-api mailing lists. So, please send a your patch linux-kernel and linux-api mailing lists.

Ozgur

>>  >>  Aishwarya
>>
>>  Ozgur
