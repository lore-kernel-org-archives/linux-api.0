From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under
 _GNU_SOURCE [BZ #10339]
Date: Mon, 15 Apr 2019 14:22:37 -0300
Message-ID: <bfe6744f-7326-0a06-e43c-9f88abce7032@linaro.org>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
 <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
 <87imvker6t.fsf@oldenburg2.str.redhat.com>
 <db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
 <87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
 <A278227C-039B-49F4-B80D-650B785AE225@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101394-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <A278227C-039B-49F4-B80D-650B785AE225@zytor.com>
To: hpa@zytor.com, Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org



On 15/04/2019 12:53, hpa@zytor.com wrote:
> On April 12, 2019 12:50:41 AM PDT, Florian Weimer <fweimer@redhat.com> wrote:
>> * Adhemerval Zanella:
>>
>>> On 11/04/2019 08:07, Florian Weimer wrote:
>>>> * Adhemerval Zanella:
>>>>
>>>>> This allows us to adjust the baud rates to non-standard values
>> using termios
>>>>> interfaces without to resorting to add new headers and use a
>> different API
>>>>> (ioctl).
>>>>
>>>> How much symbol versioning will be required for this change?
>>>
>>> I think all interfaces that have termios as input for sparc and mips 
>>> (tcgetattr, tcsetattr, cfmakeraw, cfgetispeed, cfgetospeed,
>> cfsetispeed,
>>> cfsetospeed, cfsetspeed).
>>>
>>> Alpha will also need to use termios1 for pre-4.20 kernels.
>>
>> So only new symbol versions there?  Hmm.
>>
>>>>> As Peter Anvin has indicated, he create a POC [1] with the
>> aforementioned
>>>>> new interfaces.  It has not been rebased against master, more
>> specially against
>>>>> my termios refactor to simplify the multiple architecture header
>> definitions,
>>>>> but I intend to use as a base.
>>>>
>>>> Reference [1] is still missing. 8-(
>>>
>>> Oops... it is
>> https://git.zytor.com/users/hpa/glibc/termbaud.git/log/?h=wip.termbaud
>>
>> This doesn't really illuminate things.  “Drop explicit baud setting
>> interfaces in favor of cfenc|decspeed()” removes the new symbol version
>> for the cf* functions.
>>
>> My gut feeling is that it's safer to add new interfaces, based on the
>> actual kernel/userspace interface, rather than trying to fix up
>> existing
>> interfaces with symbol versioning.  The main reason is that code
>> involving serial interfaces is difficult to test, so it will take years
>> until we find the last application broken by the glibc interface bump.
>>
>> I don't feel strongly about this.  This came out of a request for
>> enabling TCGETS2 support downstream.  If I can't fix this upstream, I
>> will just reject that request.
>>
>> Thanks,
>> Florian
> 
> New interfaces are only necessary for the handful of architectures that don't have the speed fields *and* to space to put them in. 

Based on your WIP, it seems that both sparc and mips could be adapted.
Do we still have glibc supported architecture that would require compat
symbols?

> 
> Using symbol versioning doesn't really help much since the real problem is that struct termios can be passed around in userspace, and the interfaces between user space libraries don't have any versioning. However, my POC code deals with that too by only seeing BOTHER when necessary, so if the structure is extended garbage in the extra fields will be ignored unless new baud rates are in use.

Yeah, we discussed this earlier and if recall correctly it was not settled
that all architectures would allow the use to extra space for the new
fields. It seems the case, which makes the adaptation for termios2 even easier.

The question I have for kernel side is whether termios2 is fully compatible
with termios, meaning that if there is conner cases we need to handle in
userland.

> 
> My POC code deals with Alpha as well by falling back to the old interfaces if necessary and possible, otherwise return error.
> 
> Exporting termios2 to user space feels a bit odd at this stage as it would only be usable as a fallback on old glibc. Call it kernel_termios2 at least. ioctls using struct termios *must* be changed to kernel_termios anyway!
> 

I still prefer to avoid export it to userland and make it usable through
default termios, as your wip does.  My understanding is new interfaces 
should be semantic equal to current one with the only deviation that
non-standard baudrates will handled as its values.  The only issue I 
can foresee is if POSIX starts to export new bauds value.
