From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under
 _GNU_SOURCE [BZ #10339]
Date: Wed, 17 Apr 2019 21:22:27 +0000
Message-ID: <alpine.DEB.2.21.1904172121500.14148@digraph.polyomino.org.uk>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <libc-alpha-return-101482-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, hpa@zytor.com, adhemerval.zanella@linaro.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On Tue, 9 Apr 2019, Florian Weimer wrote:

> diff --git a/sysdeps/unix/sysv/linux/Makefile b/sysdeps/unix/sysv/linux/Makefile
> index 52ac6ad484..4cb5e4f0d2 100644
> --- a/sysdeps/unix/sysv/linux/Makefile
> +++ b/sysdeps/unix/sysv/linux/Makefile
> @@ -156,6 +156,7 @@ endif
>  
>  ifeq ($(subdir),termios)
>  sysdep_headers += termio.h
> +tests += tst-termios2
>  endif

This is missing the addition of bits/termios2-struct.h to the installed 
headers.

-- 
Joseph S. Myers
joseph@codesourcery.com
