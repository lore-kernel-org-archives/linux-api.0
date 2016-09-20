From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 19 Sep 2016 17:29:56 -0700
Message-ID: <CAPz6YkWWUJLPauKZ6yQuVfZY0etNM+LSU4Z0TW+Lj8xHPnkcuQ@mail.gmail.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
 <20160912120248.GK14524@dhcp22.suse.cz> <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
 <20160912171503.GB14997@dhcp22.suse.cz> <CAPz6YkVs5OjYY6bWzUh5sshrMRS+aFG9=F0ptLsmUb_RD3=pzg@mail.gmail.com>
 <20160913071208.GC31898@dhcp22.suse.cz> <CAPz6YkXq_QPffYgBJZGxZG9SboTVoCEH2qqCgAuB6YYj1e95ig@mail.gmail.com>
 <20160914091205.GD1612@dhcp22.suse.cz> <0769f0c7-7869-2b0f-faac-3b5cbdb6e401@collabora.com>
 <20160919193238.GA28639@dhcp22.suse.cz> <2bfaecf2-bf68-48b2-8a88-6e8997c229db@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2bfaecf2-bf68-48b2-8a88-6e8997c229db-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Janis Danisevskis <jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, calvinowens-b10kYP2dOMg@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 19, 2016 at 5:27 PM, Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org> wrote:
>
>
> On 2016-09-19 03:32 PM, Michal Hocko wrote:
>>
>> On Mon 19-09-16 11:16:31, Robert Foss wrote:
>>>
>>> On 2016-09-14 05:12 AM, Michal Hocko wrote:
>>>>
>>>> On Tue 13-09-16 13:27:39, Sonny Rao wrote:
>>
>> [...]
>>>>>
>>>>> Given that smaps
>>>>> doesn't provide this in a straightforward way, what do you think is
>>>>> the right way to provide this information?
>>>>
>>>>
>>>> I would be tempted to sneak it into /proc/<pid>/statm because that looks
>>>> like a proper place but getting this information is not for free
>>>> performance wise so I am not really sure something that relies on this
>>>> file would see unexpected stalls. Maybe this could be worked around by
>>>> some caching... I would suggest to check who is actually using this file
>>>> (top/ps etc...)
>>>
>>>
>>> What would this caching look like? Can any information be re-used between
>>> vma walks?
>>
>>
>> yes basically return the same value if called within HZ or something
>> similar. But that assumes that statm latency really matters and it is
>> called often enough.
>
>
> Any single application querying more often than HZ, would presumably do so
> for accuracy reasons.
> However for multiple applications that combined query more often than HZ,
> this would most definitely be halpful in terms of performance.
>
> @Sonny, does chromiumos fall into the first or second category?

It's a single application -- and it definitely doesn't query at HZ --
especially given how long it takes to gather the data :-)
