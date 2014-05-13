From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Tue, 13 May 2014 15:10:59 -0700
Message-ID: <53729873.2030805@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel> <536D406D.2080508@zytor.com> <4366326.1D6xUnlac7@wuerfel> <536D46AD.3070608@zytor.com> <20140509223837.GB5725@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140509223837.GB5725@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/09/2014 03:38 PM, Josh Triplett wrote:
> On Fri, May 09, 2014 at 02:20:45PM -0700, H. Peter Anvin wrote:
>> On 05/09/2014 02:12 PM, Arnd Bergmann wrote:
>>>
>>>> However, if we're going to have these devices I'm wondering if having
>>>> /dev/portw and /dev/portl (or something like that) might not make sense,
>>>> rather than requiring a system call per transaction.
>>>
>>> Actually the behavior of /dev/port for >1 byte writes seems questionable
>>> already: There are very few devices on which writing to consecutive
>>> port numbers makes sense. Normally you just want to write a series
>>> of bytes (or 16/32 bit words) into the same port number instead,
>>> as the outsb()/outsw()/outsl() functions do.
>>>
>>
>> Indeed.  I missed the detail that it increments the port index; it is
>> virtually guaranteed to be bogus.
> 
> Exactly.  It might make sense to have ioport8/ioport16/ioport32 devices
> that accept arbitrary-length reads and writes (divisible by the size)
> and do the equivalent of the string I/O instructions outs/ins, but for
> the moment I'd like to add the single device that people always seem to
> want and can't get from /dev/port.  If someone's doing enough writes
> that doing a syscall per in/out instruction seems like too much
> overhead, they can write a real device driver or use ioperm/iopl.
> 

I really have a problem with the logic "our current interface is wrong,
so let's introduce another wrong interface which solves a narrow use
case".  In some ways it would actually be *better* to use an ioctl
interface on /dev/port in that case...

	-hpa
