From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Mon, 15 Apr 2019 14:28:48 +0200
Message-ID: <87lg0b311b.fsf@oldenburg2.str.redhat.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
	<284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
	<87imvker6t.fsf@oldenburg2.str.redhat.com>
	<db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
	<87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101380-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87lg0fbr1q.fsf@oldenburg2.str.redhat.com> (Florian Weimer's
	message of "Fri, 12 Apr 2019 09:50:41 +0200")
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: libc-alpha@sourceware.org, hpa@zytor.com, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* Florian Weimer:

> My gut feeling is that it's safer to add new interfaces, based on the
> actual kernel/userspace interface, rather than trying to fix up existing
> interfaces with symbol versioning.  The main reason is that code
> involving serial interfaces is difficult to test, so it will take years
> until we find the last application broken by the glibc interface bump.
>
> I don't feel strongly about this.  This came out of a request for
> enabling TCGETS2 support downstream.  If I can't fix this upstream, I
> will just reject that request.

Any further comments on this matter?

Thanks,
Florian
