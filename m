From: Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Wed, 14 Sep 2016 20:42:23 +0100
Message-ID: <15829dd7-387c-0eba-4301-7b2b53a3a2cc@citrix.com>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
 <CALCETrVJAib918qn9CL4Tvyfok-8eAHimYDabXUF=1Nsxo4-Pw@mail.gmail.com>
 <CAP045ApLcQXZP44wry8mofLz2ip1vQbvpnhCjQZsT+JxXmVEzg@mail.gmail.com>
 <CALCETrWo2XcOvnWOwU4oS-pU1+KL2PnoHa0pdFX=PA3xeM7eqg@mail.gmail.com>
 <e7b0b419-ed32-e35b-2f7b-eee71834fafd@oracle.com>
 <2c7b1052-be5a-f776-60e5-23136cd7443c@citrix.com>
 <CALCETrUkmiwLDD0V-b5woDncOzdqZaS4Pg5EnneXD4ZEN7ttbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUkmiwLDD0V-b5woDncOzdqZaS4Pg5EnneXD4ZEN7ttbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrey Ryabinin <aryabinin@virtuozzo.>
List-Id: linux-api@vger.kernel.org

On 14/09/2016 20:36, Andy Lutomirski wrote:
> On Wed, Sep 14, 2016 at 12:28 PM, Andrew Cooper
> <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
>> On 14/09/2016 20:23, Boris Ostrovsky wrote:
>>> On 09/14/2016 02:52 PM, Andy Lutomirski wrote:
>>>> On Tue, Sep 13, 2016 at 11:13 PM, Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org> wrote:
>>>>> On Mon, Sep 12, 2016 at 9:56 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>>>> You should explicitly check that, if the
>>>>>> feature is set under Xen PV, then the MSR actually works as
>>>>>> advertised.  This may require talking to the Xen folks to make sure
>>>>>> you're testing the right configuration.
>>>>> This is interesting.  When running under Xen PV the kernel is allowed
>>>>> to read the real value of MSR_PLATFORM_INFO and see that CPUID
>>>>> faulting is supported.  But as you suggested, writing to
>>>>> MSR_MISC_FEATURES_ENABLES doesn't actually enable CPUID faulting, at
>>>>> least not in any way that works.
>>>>>
>>>>> It's not obvious to me how to test this, because when this feature
>>>>> works, CPUID only faults in userspace, not in the kernel.  Is there
>>>>> existing code somewhere that runs tests like this in userspace?
>>>>>
>>>> Andrew, Boris: should we expect Xen PV to do anything sensible when we
>>>> write to MSR_PLATFORM_INFO to turn on CPUID faulting?  Should the Xen
>>>> PV rdmsr hooks or perhaps the hypervisor mask out the feature if it
>>>> isn't going to be supported?
>>> The hypervisor uses CPUID faulting so we shouldn't advertise this
>>> feature to guests.
>> In the case that the hardware has faulting, or for any HVM guest, the
>> extra cost to making the feature available to the guest is a single
>> conditional test in the cpuid path.  This is about as close to zero as a
>> feature gets.  We really should be offering the feature to guests, and
>> have it actually working.  The issue here is that it is leaking when we
>> weren't intending to offer it.
> As long as Xen can fix this one way or the other in reasonably short
> order, I think I'm okay with having Linux incorrectly think it works
> on old Xen hypervisors.

For now, unilaterally hiding CPUID faulting is easy, and simple to backport.

Making the feature available for guests to use is slightly more tricky,
as the toolstack still depends on not being faulted to construct HVM
domains properly.  This is the subject of my current CPUID project,
which will result in dom0 being no more special than any other domain
(in terms of hypervisor-side cpuid handling).

~Andrew
