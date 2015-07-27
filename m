From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Mon, 27 Jul 2015 12:18:57 -0700
Message-ID: <CAGXu5jLPT-2c_H3kjCzbVgRKQO0xMskVd7JcAMmWZSmFgzZ4ng@mail.gmail.com>
References: <cover.1437303956.git.vdavydov@parallels.com>
	<20150721163402.43ad2527d9b8caa476a1c9e1@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150721163402.43ad2527d9b8caa476a1c9e1@linux-foundation.org>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Andres Lagar-Cavilla <andreslc@google.com>, Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 4:34 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 19 Jul 2015 15:31:09 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:
>> To mark a page idle one should set the bit corresponding to the
>>    page by writing to the file. A value written to the file is OR-ed with the
>>    current bitmap value. Only user memory pages can be marked idle, for other
>>    page types input is silently ignored. Writing to this file beyond max PFN
>>    results in the ENXIO error. Only available when CONFIG_IDLE_PAGE_TRACKING is
>>    set.
>>
>>    This file can be used to estimate the amount of pages that are not
>>    used by a particular workload as follows:
>>
>>    1. mark all pages of interest idle by setting corresponding bits in the
>>       /proc/kpageidle bitmap
>>    2. wait until the workload accesses its working set
>>    3. read /proc/kpageidle and count the number of bits set
>
> Security implications.  This interface could be used to learn about a
> sensitive application by poking data at it and then observing its
> memory access patterns.  Perhaps this is why the proc files are
> root-only (whcih I assume is sufficient).  Some words here about the
> security side of things and the reasoning behind the chosen permissions
> would be good to have.

As long as this stays true-root-only, I think it should be safe enough.

>>  * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
>>    memory cgroup each page is charged to, indexed by PFN.
>
> Actually "closest online ancestor".  This also should be in the
> interface documentation.
>
>> Only available when CONFIG_MEMCG is set.
>
> CONFIG_MEMCG and CONFIG_IDLE_PAGE_TRACKING I assume?
>
>>
>>    This file can be used to find all pages (including unmapped file
>>    pages) accounted to a particular cgroup. Using /proc/kpageidle, one
>>    can then estimate the cgroup working set size.
>>
>> For an example of using these files for estimating the amount of unused
>> memory pages per each memory cgroup, please see the script attached
>> below.
>
> Why were these put in /proc anyway?  Rather than under /sys/fs/cgroup
> somewhere?  Presumably because /proc/kpageidle is useful in non-memcg
> setups.

Do we need a /proc/vm/ for holding these kinds of things? We're
collecting a lot there. Or invent some way for this to be sensible in
/sys?

-Kees

-- 
Kees Cook
Chrome OS Security
