From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Fri, 24 Apr 2015 09:27:03 -0700
Message-ID: <CA+55aFwx=mUtm3HWN=-=s23q3Q0CFDXiXPoeFKRzCN29dQ6oQw@mail.gmail.com>
References: <CAEVpBa+7Yp+zCTczZqBd6Qp_uM7yy0i8YZfZkUbDeUsPpKtqRQ@mail.gmail.com>
	<CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA@mail.gmail.com>
	<CALCETrUkkbZaNGkcZMenciC7o9BO7U52LPXQwT+Q5TT8W2=uKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUkkbZaNGkcZMenciC7o9BO7U52LPXQwT+Q5TT8W2=uKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 9:10 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
> Even though I've been accused (correctly?) of suggesting that, I'm not
> sure I like it anymore.  Suppose I map some anonymous memory, learn
> its (scrambled) pfn, then unmap it and remap a setuid file.  Now I can
> tell whether I've mapped the setuid file at the same pfn that was
> mapped as my anonymous memory.  IIRC that's sufficient for one of the
> variants of Mark's attack.

Ack. So we really do have to zero out the pfn entirely for security
reasons, and not just because it's less effort.

                         Linus
