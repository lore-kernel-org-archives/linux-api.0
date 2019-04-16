From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Tue, 16 Apr 2019 11:59:03 +0200
Message-ID: <87lg0az2xk.fsf@oldenburg2.str.redhat.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
	<284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
	<87imvker6t.fsf@oldenburg2.str.redhat.com>
	<db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
	<87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
	<A278227C-039B-49F4-B80D-650B785AE225@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101424-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <A278227C-039B-49F4-B80D-650B785AE225@zytor.com> (hpa's message
	of "Mon, 15 Apr 2019 08:53:02 -0700")
To: hpa@zytor.com
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* hpa:

> Using symbol versioning doesn't really help much since the real
> problem is that struct termios can be passed around in userspace, and
> the interfaces between user space libraries don't have any
> versioning. However, my POC code deals with that too by only seeing
> BOTHER when necessary, so if the structure is extended garbage in the
> extra fields will be ignored unless new baud rates are in use.

That still doesn't solve the problem of changing struct offsets after a
struct field of type struct termios.

> Exporting termios2 to user space feels a bit odd at this stage as it
> would only be usable as a fallback on old glibc. Call it
> kernel_termios2 at least.

I'm not sure why we should do that?  The kernel calls it struct termios2
in its UAPI headers.  If that name is not appropriate, it should be
changed first in the UAPI headers.

Thanks,
Florian
