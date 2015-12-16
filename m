From: Richard Weinberger <richard@nod.at>
Subject: Re: [RFC v5 0/8] Additional kmsg devices
Date: Wed, 16 Dec 2015 08:47:35 +0100
Message-ID: <56711717.60704@nod.at>
References: <1445941723-20388-1-git-send-email-p.osmialowsk@samsung.com>
 <1450223166.4142.34.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1450223166.4142.34.camel@perches.com>
Sender: linux-doc-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Am 16.12.2015 um 00:46 schrieb Joe Perches:
> On Tue, 2015-10-27 at 11:28 +0100, Paul Osmialowski wrote:
>> Dear All,
>>
>> This is the fifth iteration of Marcin Niesluchowski's serie of patches
>> extending kmsg interface with ability to dynamically create (and destroy)
>> kmsg-like devices which can be used by userspace for logging.
>>
>> This iteration introduces two changes:
>>
>> 1. selftests are rearranged to use kselftest.h API
>>
>> 2. A disputed  patch "add predefined _PID, _TID, _COMM keywords to kmsg*
>>    log dict" is removed - no chance it will be ever accepted. It is not
>>    critical for this patchset as a whole.
>>
>> Best regards,
>> Paul
>>
>> Marcin Niesluchowski (6):
>>   printk: add one function for storing log in proper format
>>   kmsg: introduce additional kmsg devices support
>>   kmsg: add additional buffers support to memory class
>>   kmsg: add function for adding and deleting additional buffers
>>   kmsg: add ioctl for adding and deleting kmsg* devices
>>   kmsg: add ioctl for kmsg* devices operating on buffers
>>
>> Paul Osmialowski (2):
>>   printk: extract kmsg-related routines from printk.c to kmsg.c
>>   kmsg: selftests
>>
> 
> Andrew?  Are you or anyone else interested in picking up this patchset?

I know I'm repeating myself. But this should be done in userspace.

Thanks,
//richard
