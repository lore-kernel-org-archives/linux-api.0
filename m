From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Wed, 10 Apr 2019 08:50:24 +0200
Message-ID: <87r2aaz74f.fsf@oldenburg2.str.redhat.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
	<EF5CE34B-1A82-4391-B07E-DB832814AD1C@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101297-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <EF5CE34B-1A82-4391-B07E-DB832814AD1C@zytor.com> (hpa's message
	of "Tue, 09 Apr 2019 09:02:06 -0600")
To: hpa@zytor.com
Cc: libc-alpha@sourceware.org, adhemerval.zanella@linaro.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* hpa:

> PowerPC doesn't need it at all.

Because the definition would be the same as struct termios?

I think we should still define struct termios2 using the struct termios
definition, and also define TCGETS2 and TCSETS2.  This way, applications
can use the struct termios2 type without affecting portability to POWER.

Thanks,
Florian
