From: Florian Weimer <fweimer@redhat.com>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Wed, 28 Nov 2018 10:41:00 +0100
Message-ID: <87efb5h74j.fsf@oldenburg.str.redhat.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
	<20181115140441.GA2171@altlinux.org>
	<CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
	<20181115153008.GC2171@altlinux.org>
	<CAK8P3a38zcMikOiaHXrKbc3URL6-6kETk=1F-Bx7LywPyRh=yg@mail.gmail.com>
	<87d0qrooj3.fsf@oldenburg.str.redhat.com>
	<CAK8P3a3pVS3_70PQ+SeiSZtqXFcb5HON0QGRypWfu=cfLPgN=w@mail.gmail.com>
	<87r2f5h7kk.fsf@oldenburg.str.redhat.com>
	<67B157B9-80B0-4862-87F4-F03DECBD58CC@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-97621-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <67B157B9-80B0-4862-87F4-F03DECBD58CC@brauner.io> (Christian
	Brauner's message of "Wed, 28 Nov 2018 22:36:49 +1300")
To: Christian Brauner <christian@brauner.io>
Cc: libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> The intention has always been to start a
> file descriptor process API off of that.
> If we land my procfd_signal() patchset we are in good shape for
> procfd_wait(), imho.

How does this interact with SIGCHLD and the wait system call (or any
wait function without an explicitly specified PID)?

I understand that I have somewhat conflicting requirements, but in terms
of relative priorities, launching a process without spurious signals and
wait notifications would probably offer the larger benefit.

Thanks,
Florian
