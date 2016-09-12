From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Mon, 12 Sep 2016 14:07:43 -0700
Message-ID: <CALCETrXg4qo+oeq7xqMv9n9RehQ3jGjifJRK90jD=n-2r6=qaA@mail.gmail.com>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <CALCETrVJAib918qn9CL4Tvyfok-8eAHimYDabXUF=1Nsxo4-Pw@mail.gmail.com> <20160912175656.GA8935@laptop.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160912175656.GA8935@laptop.thejh.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, Linux API <linux-api@vger.kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>, Vlastimil Babka <vbabka@suse.cz>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Mateusz Guzik <mguzik@redhat.com>, Alex Thorlton <athorlton@sgi.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Dmitry Vyukov <dvyukov@google.com>, Jiri Slaby <jslaby@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ben Segall <bsegall@go>
List-Id: linux-api@vger.kernel.org

On Sep 12, 2016 10:57 AM, "Jann Horn" <jann@thejh.net> wrote:
>
> On Mon, Sep 12, 2016 at 09:56:11AM -0700, Andy Lutomirski wrote:
> > On Sep 11, 2016 5:29 PM, "Kyle Huey" <me@kylehuey.com> wrote:
> > >
> > > rr (http://rr-project.org/), a userspace record-and-replay reverse-
> > > execution debugger, would like to trap and emulate the CPUID instruction.
> > > This would allow us to a) mask away certain hardware features that rr does
> > > not support (e.g. RDRAND) and b) enable trace portability across machines
> > > by providing constant results.
> > >
> > > Intel supports faulting on the CPUID instruction in newer processors. Bit
> > > 31 of MSR_PLATFORM_INFO advertises support for this feature. It is
> > > documented in detail in Section 2.3.2 of
> > > http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf.
> [...]
> > If this bit is preserved on fork(), then no_new_privs must be checked
> > (or it must be cleared on "unsafe" exec, but that's nasty).
>
> I think you mean "preserved on execve()"?

Indeed.

So it should have defined and tested behavior on fork() and execve().
Maybe fork() should preserve the flag after all.

--Andy
