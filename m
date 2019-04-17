From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under
 _GNU_SOURCE [BZ #10339]
Date: Wed, 17 Apr 2019 15:04:55 -0700
Message-ID: <8f05dc10-02ea-327f-f984-98b91a0b195d@zytor.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
 <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
 <87imvker6t.fsf@oldenburg2.str.redhat.com>
 <db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
 <87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
 <A278227C-039B-49F4-B80D-650B785AE225@zytor.com>
 <bfe6744f-7326-0a06-e43c-9f88abce7032@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-101486-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <bfe6744f-7326-0a06-e43c-9f88abce7032@linaro.org>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>, Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 4/15/19 10:22 AM, Adhemerval Zanella wrote:
>>
>> New interfaces are only necessary for the handful of architectures that don't have the speed fields *and* to space to put them in. 
> 
> Based on your WIP, it seems that both sparc and mips could be adapted.
> Do we still have glibc supported architecture that would require compat
> symbols?
> 
>>
>> Using symbol versioning doesn't really help much since the real problem is that struct termios can be passed around in userspace, and the interfaces between user space libraries don't have any versioning. However, my POC code deals with that too by only seeing BOTHER when necessary, so if the structure is extended garbage in the extra fields will be ignored unless new baud rates are in use.
> 
> Yeah, we discussed this earlier and if recall correctly it was not settled
> that all architectures would allow the use to extra space for the new
> fields. It seems the case, which makes the adaptation for termios2 even easier.
> 
> The question I have for kernel side is whether termios2 is fully compatible
> with termios, meaning that if there is conner cases we need to handle in
> userland.
> 

It depends on what you mean with "fully compatible."

Functionality-wise, the termios2 interfaces are a strict superset. There
is not, however, any guarantee that struct kernel_termios2 *contains* a
contiguous binary equivalent to struct kernel_termios (in fact, on most
architectures, it doesn't.)

>>
>> My POC code deals with Alpha as well by falling back to the old interfaces if necessary and possible, otherwise return error.
>>
>> Exporting termios2 to user space feels a bit odd at this stage as it would only be usable as a fallback on old glibc. Call it kernel_termios2 at least. ioctls using struct termios *must* be changed to kernel_termios anyway!
>>
> 
> I still prefer to avoid export it to userland and make it usable through
> default termios, as your wip does.  My understanding is new interfaces 
> should be semantic equal to current one with the only deviation that
> non-standard baudrates will handled as its values.  The only issue I 
> can foresee is if POSIX starts to export new bauds value.
> 

... which will be easy to handle: just define a Bxxxx constant with the
value equal to the baud rate.

	-hhpa
