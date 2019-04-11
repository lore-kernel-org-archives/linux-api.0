From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Thu, 11 Apr 2019 13:07:06 +0200
Message-ID: <87imvker6t.fsf@oldenburg2.str.redhat.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
	<284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101341-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org> (Adhemerval
	Zanella's message of "Wed, 10 Apr 2019 17:24:17 -0300")
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: libc-alpha@sourceware.org, hpa@zytor.com, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* Adhemerval Zanella:

> This allows us to adjust the baud rates to non-standard values using termios
> interfaces without to resorting to add new headers and use a different API
> (ioctl).

How much symbol versioning will be required for this change?

> As Peter Anvin has indicated, he create a POC [1] with the aforementioned
> new interfaces.  It has not been rebased against master, more specially against
> my termios refactor to simplify the multiple architecture header definitions,
> but I intend to use as a base.

Reference [1] is still missing. 8-(

Thanks,
Florian
