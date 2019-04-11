From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under
 _GNU_SOURCE [BZ #10339]
Date: Thu, 11 Apr 2019 09:53:30 -0300
Message-ID: <db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
 <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
 <87imvker6t.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101343-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87imvker6t.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, hpa@zytor.com, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org



On 11/04/2019 08:07, Florian Weimer wrote:
> * Adhemerval Zanella:
> 
>> This allows us to adjust the baud rates to non-standard values using termios
>> interfaces without to resorting to add new headers and use a different API
>> (ioctl).
> 
> How much symbol versioning will be required for this change?

I think all interfaces that have termios as input for sparc and mips 
(tcgetattr, tcsetattr, cfmakeraw, cfgetispeed, cfgetospeed, cfsetispeed,
cfsetospeed, cfsetspeed).

Alpha will also need to use termios1 for pre-4.20 kernels.

> 
>> As Peter Anvin has indicated, he create a POC [1] with the aforementioned
>> new interfaces.  It has not been rebased against master, more specially against
>> my termios refactor to simplify the multiple architecture header definitions,
>> but I intend to use as a base.
> 
> Reference [1] is still missing. 8-(

Oops... it is https://git.zytor.com/users/hpa/glibc/termbaud.git/log/?h=wip.termbaud

> 
> Thanks,
> Florian
> 
