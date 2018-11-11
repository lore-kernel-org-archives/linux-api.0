From: Willy Tarreau <w@1wt.eu>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 09:17:25 +0100
Message-ID: <20181111081725.GA30248@1wt.eu>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97130-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 11, 2018 at 07:55:30AM +0100, Michael Kerrisk (man-pages) wrote:
> [1] https://sourceware.org/bugzilla/show_bug.cgi?id=6399 is a
>     longstanding example.

This one was a sad read and shows that applications will continue to
suffer from glibc's prehistorical view on operating systems and will
continue to have to define their own syscall wrappers to exploit the
full potential of the modern operating systems they execute on. This
reminds me when one had to write their own spinlocks and atomics many
years ago. Seeing comments suggesting an application should open
/proc/$PID makes me really wonder if people actually want to use slow
and insecure applications designed this way. Bah, after all, this
wipes quite a bit of the shame I feel every time I do something to
bypass it :-/

The sad thing is that the energy wasted arguing in the bug above could
have been better spent designing and implementing a generic solution
to expose syscalls without depending on glibc's politics anymore.

Willy
