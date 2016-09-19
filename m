From: Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 19 Sep 2016 13:15:32 -0700
Message-ID: <CAPz6YkVuqb4HbAgNRhZzCXWN-RZC8EeUFz1XR3N3dhdo9zE__Q@mail.gmail.com>
References: <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
 <20160912171503.GB14997@dhcp22.suse.cz> <CAPz6YkVs5OjYY6bWzUh5sshrMRS+aFG9=F0ptLsmUb_RD3=pzg@mail.gmail.com>
 <20160913071208.GC31898@dhcp22.suse.cz> <CAPz6YkXq_QPffYgBJZGxZG9SboTVoCEH2qqCgAuB6YYj1e95ig@mail.gmail.com>
 <20160914091205.GD1612@dhcp22.suse.cz> <0769f0c7-7869-2b0f-faac-3b5cbdb6e401@collabora.com>
 <20160919193238.GA28639@dhcp22.suse.cz> <20160919194001.GE2903@pc.thejh.net>
 <20160919195109.GB28639@dhcp22.suse.cz> <20160919195619.GF2903@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160919195619.GF2903@pc.thejh.net>
Sender: linux-doc-owner@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: Michal Hocko <mhocko@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, John Stultz <john.stultz@linaro.org>, Minchan Kim <minchan@kernel.org>, ross.zwisler@linux.intel.com, jmarchan@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Kees Cook <keescook@chromium.org>, oleg@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Mateusz Guzik <mguzik@redhat.com>, Janis Danisevskis <jdanis@google.com>, calvinowens@fb.com, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Seth Forshee <seth.forshee@canonical.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 19, 2016 at 12:56 PM, Jann Horn <jann@thejh.net> wrote:
> On Mon, Sep 19, 2016 at 09:51:13PM +0200, Michal Hocko wrote:
>> [not sure why the CC list was trimmed - do no do that please unless you
>>  have a strong reason for that - if this was not intentional please
>>  restpre it]
>
> Ah, sorry, pressed the wrong key.
>
>
>> On Mon 19-09-16 21:40:01, Jann Horn wrote:
>> > On Mon, Sep 19, 2016 at 09:32:38PM +0200, Michal Hocko wrote:
>> > > On Mon 19-09-16 11:16:31, Robert Foss wrote:
>> > > > On 2016-09-14 05:12 AM, Michal Hocko wrote:
>> > > > > On Tue 13-09-16 13:27:39, Sonny Rao wrote:
>> > > [...]
>> > > > > > Given that smaps
>> > > > > > doesn't provide this in a straightforward way, what do you think is
>> > > > > > the right way to provide this information?
>> > > > >
>> > > > > I would be tempted to sneak it into /proc/<pid>/statm because that looks
>> > > > > like a proper place but getting this information is not for free
>> > > > > performance wise so I am not really sure something that relies on this
>> > > > > file would see unexpected stalls. Maybe this could be worked around by
>> > > > > some caching... I would suggest to check who is actually using this file
>> > > > > (top/ps etc...)
>> > > >
>> > > > What would this caching look like? Can any information be re-used between
>> > > > vma walks?
>> > >
>> > > yes basically return the same value if called within HZ or something
>> > > similar. But that assumes that statm latency really matters and it is
>> > > called often enough.
>> >
>> > That sounds horrible. If some application decides that they want to check
>> > statm directly after some action or so (like after program startup), this is
>> > going to give them a very bad time. That probably doesn't happen
>> > often - but still.
>> >
>> > I can already imagine some developer going "yeah, that usleep()... that's
>> > because the kernel API returns stale information for a couple milliseconds
>> > after we do something *shrug*".
>> >
>> > What are you trying to optimize for? Ten users on the same machine, each of
>> > which is running "top" because it looks so great?
>>
>> Please try to read what I wrote again. I didn't say this would be
>> needed. The idea was that _if_ /proc/<pid>/statm is used very _often_
>> than some caching might help to reduce the overhead. Especially when you
>> consider that the information is not precise anyway. It can change
>> anytime while you are doing the address space walk.

Just thinking out loud here -- I haven't looked closely at the code so
please bear with me :-)

Instead of checking when the last read was and returning old data,
what about a scheme where we still have a timestamp for last stat read
on and any changes to that address space invalidate the timestamp.

The invalidation could be racy because we're not too concerned about
immediate accuracy -- so just a write.   The main issue I could see
which this is that it could cause the cacheline holding this timestamp
to bounce around a lot?  Maybe there's an existing solution in the
page table locking that could be leveraged here to at least maintain
whatever scalability enhancements are present for this type of
situation where there are many updates happening in parallel.
