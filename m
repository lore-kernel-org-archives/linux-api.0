From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 14:02:01 -0700
Message-ID: <CA+55aFzW52u-LahoBA5kDs47rgeTGU_KF_GUrx+XSUDzeQD3=g@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
	<CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
	<20150429193622.GA11892@node.dhcp.inet.fi>
	<CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
	<CALYGNiN6kU5xgEAfbs4VVXsVKmMN+uCStrQoLh6gFCzBxJfy+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiN6kU5xgEAfbs4VVXsVKmMN+uCStrQoLh6gFCzBxJfy+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, Mark Seaborn <mseaborn@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 1:44 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>
> This's no longer true. After recent fixes for "anon_vma endless growing" new vma
> might reuse old anon_vma from grandparent vma.

Oh well. I guess that was too simple.

If Mark is ok with the rule that "it's not reliably if you have two
nested forks" (ie it only works if you exec for every fork you do), it
should still work, right? It sounds like Mark doesn't necessarily need
to handle the *generic* case.

                       Linus
