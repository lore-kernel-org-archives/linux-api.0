From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under
 _GNU_SOURCE [BZ #10339]
Date: Wed, 17 Apr 2019 15:06:45 -0700
Message-ID: <ccdca9a0-f9b8-bee4-ecc6-57902f36ecd2@zytor.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
 <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
 <87imvker6t.fsf@oldenburg2.str.redhat.com>
 <db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
 <87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
 <A278227C-039B-49F4-B80D-650B785AE225@zytor.com>
 <87lg0az2xk.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-101487-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87lg0az2xk.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 4/16/19 2:59 AM, Florian Weimer wrote:
> * hpa:
> 
>> Using symbol versioning doesn't really help much since the real
>> problem is that struct termios can be passed around in userspace, and
>> the interfaces between user space libraries don't have any
>> versioning. However, my POC code deals with that too by only seeing
>> BOTHER when necessary, so if the structure is extended garbage in the
>> extra fields will be ignored unless new baud rates are in use.
> 
> That still doesn't solve the problem of changing struct offsets after a
> struct field of type struct termios.
> 
>> Exporting termios2 to user space feels a bit odd at this stage as it
>> would only be usable as a fallback on old glibc. Call it
>> kernel_termios2 at least.
> 
> I'm not sure why we should do that?  The kernel calls it struct termios2
> in its UAPI headers.  If that name is not appropriate, it should be
> changed first in the UAPI headers.
> 

It should; I believe the namespace we ought to use is struct
__kernel_termios[2].

"struct termios" defined in these headers is obviously completely wrong
for userspace.

	-hpa
