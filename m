From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Wed, 14 Sep 2016 11:52:15 -0700
Message-ID: <CALCETrWo2XcOvnWOwU4oS-pU1+KL2PnoHa0pdFX=PA3xeM7eqg@mail.gmail.com>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <CALCETrVJAib918qn9CL4Tvyfok-8eAHimYDabXUF=1Nsxo4-Pw@mail.gmail.com> <CAP045ApLcQXZP44wry8mofLz2ip1vQbvpnhCjQZsT+JxXmVEzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAP045ApLcQXZP44wry8mofLz2ip1vQbvpnhCjQZsT+JxXmVEzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>, Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maintainer:X86 ARCHITECTURE (32-BIT
List-Id: linux-api@vger.kernel.org

On Tue, Sep 13, 2016 at 11:13 PM, Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Sep 12, 2016 at 9:56 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> You should explicitly check that, if the
>> feature is set under Xen PV, then the MSR actually works as
>> advertised.  This may require talking to the Xen folks to make sure
>> you're testing the right configuration.
>
> This is interesting.  When running under Xen PV the kernel is allowed
> to read the real value of MSR_PLATFORM_INFO and see that CPUID
> faulting is supported.  But as you suggested, writing to
> MSR_MISC_FEATURES_ENABLES doesn't actually enable CPUID faulting, at
> least not in any way that works.
>
> It's not obvious to me how to test this, because when this feature
> works, CPUID only faults in userspace, not in the kernel.  Is there
> existing code somewhere that runs tests like this in userspace?
>

Andrew, Boris: should we expect Xen PV to do anything sensible when we
write to MSR_PLATFORM_INFO to turn on CPUID faulting?  Should the Xen
PV rdmsr hooks or perhaps the hypervisor mask out the feature if it
isn't going to be supported?

--Andy
