From: Mark Seaborn <mseaborn@chromium.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Fri, 24 Apr 2015 08:26:52 -0700
Message-ID: <CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Williamson <mwilliamson@undo-software.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Konstantin Khlebnikov <khlebnikov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

On 24 April 2015 at 08:01, Mark Williamson
<mwilliamson@undo-software.com> wrote:
> In our use of /proc/PID/pagemap, we currently make use of the physical
> pageframe addresses.  We should be able to work with a scrambled
> representation of these (Andy Lutomirski suggested this in the
> original discussion - https://lkml.org/lkml/2015/3/16/1273) so long as
> the scrambling remained consistent during the lifetime of the open
> pagemap file.  Alternatively, if physical addresses were simply zeroed
> (also suggested by Pavel Emelyanov -
> https://lkml.org/lkml/2015/3/9/871) we would be able to change our
> code to rely only on the soft-dirty flag and thus still work
> correctly.

I'm curious, what do you use the physical page addresses for?

Since you pointed to http://undo-software.com, which talks about
reversible debugging tools, I can guess you would use the soft-dirty
flag to implement copy-on-write snapshotting.  I'm guessing you might
use physical page addresses for determining when the same page is
mapped twice (in the same process or different processes)?

Cheers,
Mark
