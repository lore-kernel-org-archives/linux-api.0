From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Mon, 12 Sep 2016 19:56:56 +0200
Message-ID: <20160912175656.GA8935@laptop.thejh.net>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <CALCETrVJAib918qn9CL4Tvyfok-8eAHimYDabXUF=1Nsxo4-Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVJAib918qn9CL4Tvyfok-8eAHimYDabXUF=1Nsxo4-Pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, mainta
List-Id: linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 09:56:11AM -0700, Andy Lutomirski wrote:
> On Sep 11, 2016 5:29 PM, "Kyle Huey" <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org> wrote:
> >
> > rr (http://rr-project.org/), a userspace record-and-replay reverse-
> > execution debugger, would like to trap and emulate the CPUID instruction.
> > This would allow us to a) mask away certain hardware features that rr does
> > not support (e.g. RDRAND) and b) enable trace portability across machines
> > by providing constant results.
> >
> > Intel supports faulting on the CPUID instruction in newer processors. Bit
> > 31 of MSR_PLATFORM_INFO advertises support for this feature. It is
> > documented in detail in Section 2.3.2 of
> > http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf.
[...]
> If this bit is preserved on fork(), then no_new_privs must be checked
> (or it must be cleared on "unsafe" exec, but that's nasty).

I think you mean "preserved on execve()"?
