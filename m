From: Robert Foss <robert.foss@collabora.com>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 19 Sep 2016 20:27:23 -0400
Message-ID: <2bfaecf2-bf68-48b2-8a88-6e8997c229db@collabora.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
 <20160912120248.GK14524@dhcp22.suse.cz>
 <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
 <20160912171503.GB14997@dhcp22.suse.cz>
 <CAPz6YkVs5OjYY6bWzUh5sshrMRS+aFG9=F0ptLsmUb_RD3=pzg@mail.gmail.com>
 <20160913071208.GC31898@dhcp22.suse.cz>
 <CAPz6YkXq_QPffYgBJZGxZG9SboTVoCEH2qqCgAuB6YYj1e95ig@mail.gmail.com>
 <20160914091205.GD1612@dhcp22.suse.cz>
 <0769f0c7-7869-2b0f-faac-3b5cbdb6e401@collabora.com>
 <20160919193238.GA28639@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160919193238.GA28639@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, John Stultz <john.stultz@linaro.org>, Minchan Kim <minchan@kernel.org>, ross.zwisler@linux.intel.com, jmarchan@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Kees Cook <keescook@chromium.org>, oleg@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Mateusz Guzik <mguzik@redhat.com>, Janis Danisevskis <jdanis@google.com>, calvinowens@fb.com, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Seth Forshee <seth.forshee@canonical.com>
List-Id: linux-api@vger.kernel.org



On 2016-09-19 03:32 PM, Michal Hocko wrote:
> On Mon 19-09-16 11:16:31, Robert Foss wrote:
>> On 2016-09-14 05:12 AM, Michal Hocko wrote:
>>> On Tue 13-09-16 13:27:39, Sonny Rao wrote:
> [...]
>>>> Given that smaps
>>>> doesn't provide this in a straightforward way, what do you think is
>>>> the right way to provide this information?
>>>
>>> I would be tempted to sneak it into /proc/<pid>/statm because that looks
>>> like a proper place but getting this information is not for free
>>> performance wise so I am not really sure something that relies on this
>>> file would see unexpected stalls. Maybe this could be worked around by
>>> some caching... I would suggest to check who is actually using this file
>>> (top/ps etc...)
>>
>> What would this caching look like? Can any information be re-used between
>> vma walks?
>
> yes basically return the same value if called within HZ or something
> similar. But that assumes that statm latency really matters and it is
> called often enough.

Any single application querying more often than HZ, would presumably do 
so for accuracy reasons.
However for multiple applications that combined query more often than 
HZ, this would most definitely be halpful in terms of performance.

@Sonny, does chromiumos fall into the first or second category?
