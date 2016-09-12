From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 12 Sep 2016 10:28:53 -0700
Message-ID: <CAPz6YkVs5OjYY6bWzUh5sshrMRS+aFG9=F0ptLsmUb_RD3=pzg@mail.gmail.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
 <20160912120248.GK14524@dhcp22.suse.cz> <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
 <20160912171503.GB14997@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160912171503.GB14997-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Janis Danisevskis <jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, calvinowens-b10kYP2dOMg@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, tixxdz@g
List-Id: linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 10:15 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon 12-09-16 08:31:36, Sonny Rao wrote:
>> On Mon, Sep 12, 2016 at 5:02 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > On Mon 05-09-16 16:14:06, robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org wrote:
>> >> From: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
>> >>
>> >> This series provides the /proc/PID/totmaps feature, which
>> >> summarizes the information provided by /proc/PID/smaps for
>> >> improved performance and usability reasons.
>> >>
>> >> A use case is to speed up monitoring of memory consumption in
>> >> environments where RSS isn't precise.
>> >>
>> >> For example Chrome tends to many processes which have hundreds of VMAs
>> >> with a substantial amount of shared memory, and the error of using
>> >> RSS rather than PSS tends to be very large when looking at overall
>> >> memory consumption.  PSS isn't kept as a single number that's exported
>> >> like RSS, so to calculate PSS means having to parse a very large smaps
>> >> file.
>> >>
>> >> This process is slow and has to be repeated for many processes, and we
>> >> found that the just act of doing the parsing was taking up a
>> >> significant amount of CPU time, so this patch is an attempt to make
>> >> that process cheaper.
>> >
>> > I still maintain my concerns about a single pss value. It might work in
>> > a very specific situations where the consumer knows what is shared but
>> > other than that the value can be more misleading than helpful. So a NACK
>> > from me until I am shown that this is usable in general and still
>> > helpful.
>>
>> I know you think Pss isn't useful in general (though I'll point out
>> two other independent people said they found it useful)
>
> sure, and one of them admitted that the value is useful because they
> _know_ the resource. The other was quite vague for me to understand
> all the details. Please, try to understand that once you provide a user
> API then it will carved in stone. If the interface is poor and ambigous
> it will bite us later. One very specific usecase doesn't justify
> something that might be really misleading for 90% of cases.
>
>> but how about the other fields like Swap, Private_Dirty and
>> Private_Shared?
>
> Private_Shared can be pretty confusing as well without the whole context
> as well see my other emails in the original thread (just to remind
> shmem/tmpfs makes all this really confusing).

But this is exactly the issue -- RSS is can be just as confusing if
you don't know something about the application.  I think the issue is
how common that situation is, and you seem to believe that it's so
uncommon that it's actually better to keep the information more
difficult to get for those of us who know something about our systems.

That's fine, I guess we just have to disagree here, thanks for look at this.

>
> --
> Michal Hocko
> SUSE Labs
