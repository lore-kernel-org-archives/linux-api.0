From: Mark Williamson <mwilliamson@undo-software.com>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 15:38:24 +0100
Message-ID: <CAEVpBaLnV9xzDEa3ivNWkQWn4UYk3s1eeBFi2pn0=wGMFz+VYA@mail.gmail.com>
References: <CAEVpBa+7Yp+zCTczZqBd6Qp_uM7yy0i8YZfZkUbDeUsPpKtqRQ@mail.gmail.com>
	<CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA@mail.gmail.com>
	<CALCETrUkkbZaNGkcZMenciC7o9BO7U52LPXQwT+Q5TT8W2=uKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUkkbZaNGkcZMenciC7o9BO7U52LPXQwT+Q5TT8W2=uKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Konstantin Khlebnikov <khlebnikov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Seaborn <mseaborn@chromium.org>, Linux API <linux-api@vger.kernel.org>, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Fri, Apr 24, 2015 at 5:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Even though I've been accused (correctly?) of suggesting that, I'm not
> sure I like it anymore.  Suppose I map some anonymous memory, learn
> its (scrambled) pfn, then unmap it and remap a setuid file.  Now I can
> tell whether I've mapped the setuid file at the same pfn that was
> mapped as my anonymous memory.  IIRC that's sufficient for one of the
> variants of Mark's attack.

In fairness, you may have mentioned it but it's entirely possible you
didn't originate the suggestion and I quoted out of context.  Sorry
for implicating you ;-)

That's an attack that I hadn't considered when thinking about this
stuff.  Zeroing the page frame numbers is an easier patch, so
arguments in favour of that are a happy answer as far as I'm
concerned!

Thanks,
Mark
