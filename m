From: Mark Williamson <mwilliamson@undo-software.com>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Fri, 24 Apr 2015 17:43:08 +0100
Message-ID: <CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Seaborn <mseaborn@chromium.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Konstantin Khlebnikov <khlebnikov@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

Hi Mark,

On Fri, Apr 24, 2015 at 4:26 PM, Mark Seaborn <mseaborn@chromium.org> wrote:
> I'm curious, what do you use the physical page addresses for?
>
> Since you pointed to http://undo-software.com, which talks about
> reversible debugging tools, I can guess you would use the soft-dirty
> flag to implement copy-on-write snapshotting.  I'm guessing you might
> use physical page addresses for determining when the same page is
> mapped twice (in the same process or different processes)?

That's pretty much it.  Actually, we're effectively using the physical
addresses to emulate soft-dirty.  For certain operations (e.g. some
system calls) we need to track what memory has changed since we last
looked at the process state.  We have a mechanism that forks a child
process, runs the system call, then refers to pagemap to figure out
what's been modified.

Currently, our mechanism compares the physical addresses of pages
before and after the syscall so that we can see which pages got CoWed.
This is perhaps a slightly "unconventional" use of the interface but
we support kernels that predate the soft-dirty mechanism and (as far
as we know) this is probably the best way we can answer "What got
changed?" on those releases.

Using the soft-dirty mechanism where available should make our code
both cleaner and faster, so if we can fix the pagemap file to allow
that then we'll be quite happy!

Cheers,
Mark
