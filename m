From: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Fri, 15 Dec 2017 00:10:29 +0100
Message-ID: <CAG48ez0z124816RCtXxtZzYfF+uw4uAnnB2JgN_afwYV32bs4w@mail.gmail.com>
References: <20171213092550.2774-1-mhocko@kernel.org> <20171213093110.3550-1-mhocko@kernel.org>
 <20171213093110.3550-2-mhocko@kernel.org> <CAG48ez0JZ3PVW3vgSXDmDijS+a_5bSX9qNuyggnsB6JTSkKngA@mail.gmail.com>
 <b4fb7b3a-e53e-bf87-53c5-186751a14f4e@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b4fb7b3a-e53e-bf87-53c5-186751a14f4e-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 15, 2017 at 12:06 AM, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/13/2017 06:52 PM, Jann Horn wrote:
>> On Wed, Dec 13, 2017 at 10:31 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> [...]
>>> +.IP
>>> +Furthermore, this option is extremely hazardous (when used on its own), because
>>> +it forcibly removes pre-existing mappings, making it easy for a multi-threaded
>>> +process to corrupt its own address space.
>>
>> I think this is worded unfortunately. It is dangerous if used
>> incorrectly, and it's a good tool when used correctly.
>>
>> [...]
>>> +Thread B need not create a mapping directly; simply making a library call
>>> +that, internally, uses
>>> +.I dlopen(3)
>>> +to load some other shared library, will
>>> +suffice. The dlopen(3) call will map the library into the process's address
>>> +space. Furthermore, almost any library call may be implemented using this
>>> +technique.
>>> +Examples include brk(2), malloc(3), pthread_create(3), and the PAM libraries
>>> +(http://www.linux-pam.org).
>>
>> This is arkward. This first mentions dlopen(), which is a very niche
>> case, and then just very casually mentions the much bigger
>> problem that tons of library functions can allocate memory through
>> malloc(), causing mmap() calls, sometimes without that even being
>> a documented property of the function.
>>
>
> Hi Jann,
>
> Here is some proposed new wording, to address your two comments above. What do
> you think of this:
>
> NOTE:  this  option  can  be hazardous (when used on its own), because it
> forcibly removes pre-existing mappings,  making  it  easy  for  a  multi-
> threaded  process to corrupt its own address space. For example, thread A
> looks through /proc/<pid>/maps and locates an  available  address  range,
> while  thread  B simultaneously acquires part or all of that same address
> range. Thread A then calls mmap(MAP_FIXED), effectively  overwriting  the
> mapping that thread B created.
>
> Thread B need not create a mapping directly; simply making a library call
> whose implementation calls malloc(3), mmap(), or dlopen(3) will  suffice,
> because those calls all create new mappings.

Thanks! That sounds better to me.

>>> +.IP
>>> +Newer kernels
>>> +(Linux 4.16 and later) have a
>>> +.B MAP_FIXED_SAFE
>>> +option that avoids the corruption problem; if available, MAP_FIXED_SAFE
>>> +should be preferred over MAP_FIXED.
>>
>> This is bad advice. MAP_FIXED is completely safe if you use it on an address
>> range you've allocated, and it is used in this way by core system libraries to
>> place multiple VMAs in virtually contiguous memory, for example:
> [...]
>> MAP_FIXED is a better solution for these usecases than MAP_FIXED_SAFE,
>> or whatever it ends up being called. Please remove this advice or, better,
>> clarify what MAP_FIXED should be used for (creation of virtually contiguous
>> VMAs) and what MAP_FIXED_SAFE should be used for (attempting to
>> allocate memory at a fixed address for some reason, with a failure instead of
>> the normal fallback to using a different address).
>>
>
> Rather than risk another back-and-forth with Michal (who doesn't want any advice
> on how to use this safely, in the man page), I've simply removed this advice
> entirely.

Makes sense.
