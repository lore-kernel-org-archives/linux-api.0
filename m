From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Fri, 24 Apr 2015 09:10:45 -0700
Message-ID: <CALCETrUkkbZaNGkcZMenciC7o9BO7U52LPXQwT+Q5TT8W2=uKQ@mail.gmail.com>
References: <CAEVpBa+7Yp+zCTczZqBd6Qp_uM7yy0i8YZfZkUbDeUsPpKtqRQ@mail.gmail.com>
 <CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Williamson <mwilliamson@undo-software.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Konstantin Khlebnikov <khlebnikov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Seaborn <mseaborn@chromium.org>, Linux API <linux-api@vger.kernel.org>, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 9:08 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 24, 2015 at 7:55 AM, Mark Williamson
> <mwilliamson@undo-software.com> wrote:
>>
>> Although I've marked this as a "Regression", we do realise there are
>> legitimate security concerns over the original implementation of this
>> interface.  Still, given the kernel's strong stance on preserving userspace
>> interfaces, we thought we ought to flag this quickly as something that has
>> changed application-relevant behaviour.
>
> So the one exception to the regression rule is "security fixes", but
> even for security fixes we do try to be as reasonable as humanly
> possible to make them not break things.
>
> Now, as you mentioned, one option is to not outright disallow accesses
> to the /proc/PID/pagemap, but to at least hide the page frame numbers.
> However, I don't believe that we have a good enough scrambling model
> to make that reasonable. Remember: any attacker will be able to see
> our scrambling code, so it would need to be both cryptographically
> secure *and* use a truly random per-VM secret key. Quite frankly,
> that's a _lot_ of effort for dubious gain...

Even though I've been accused (correctly?) of suggesting that, I'm not
sure I like it anymore.  Suppose I map some anonymous memory, learn
its (scrambled) pfn, then unmap it and remap a setuid file.  Now I can
tell whether I've mapped the setuid file at the same pfn that was
mapped as my anonymous memory.  IIRC that's sufficient for one of the
variants of Mark's attack.

--Andy
