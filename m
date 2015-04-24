From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Fri, 24 Apr 2015 09:08:15 -0700
Message-ID: <CA+55aFymwdHBs02GQkqQYwYF9Ru5dMKd4=2whLUfPwZSPU7ZGA@mail.gmail.com>
References: <CAEVpBa+7Yp+zCTczZqBd6Qp_uM7yy0i8YZfZkUbDeUsPpKtqRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEVpBa+7Yp+zCTczZqBd6Qp_uM7yy0i8YZfZkUbDeUsPpKtqRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Williamson <mwilliamson@undo-software.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Konstantin Khlebnikov <khlebnikov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, Mark Seaborn <mseaborn@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 7:55 AM, Mark Williamson
<mwilliamson@undo-software.com> wrote:
>
> Although I've marked this as a "Regression", we do realise there are
> legitimate security concerns over the original implementation of this
> interface.  Still, given the kernel's strong stance on preserving userspace
> interfaces, we thought we ought to flag this quickly as something that has
> changed application-relevant behaviour.

So the one exception to the regression rule is "security fixes", but
even for security fixes we do try to be as reasonable as humanly
possible to make them not break things.

Now, as you mentioned, one option is to not outright disallow accesses
to the /proc/PID/pagemap, but to at least hide the page frame numbers.
However, I don't believe that we have a good enough scrambling model
to make that reasonable. Remember: any attacker will be able to see
our scrambling code, so it would need to be both cryptographically
secure *and* use a truly random per-VM secret key. Quite frankly,
that's a _lot_ of effort for dubious gain...

So the "just show physical addresses as zero for non-root users"
(instead of the outright ban on opening the file) is likely the only
really viable alternative.

It sounds like that could work for you. So if you can modify the app
to do that, and send me a tested kernel patch that moves the
permission check into the read phase (remember to use the open-time
credentials in "file->f_cred" rather than the read-time credentials in
"current" - otherwise you can trick some suid program to read the fily
that an unauthorized user opened), then we can have this fixed. Does
that sound reasonable?

                      Linus
