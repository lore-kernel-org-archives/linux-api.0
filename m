From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Wed, 14 Sep 2016 11:12:06 +0200
Message-ID: <20160914091205.GD1612@dhcp22.suse.cz>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
 <20160912120248.GK14524@dhcp22.suse.cz>
 <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
 <20160912171503.GB14997@dhcp22.suse.cz>
 <CAPz6YkVs5OjYY6bWzUh5sshrMRS+aFG9=F0ptLsmUb_RD3=pzg@mail.gmail.com>
 <20160913071208.GC31898@dhcp22.suse.cz>
 <CAPz6YkXq_QPffYgBJZGxZG9SboTVoCEH2qqCgAuB6YYj1e95ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPz6YkXq_QPffYgBJZGxZG9SboTVoCEH2qqCgAuB6YYj1e95ig@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Robert Foss <robert.foss@collabora.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, John Stultz <john.stultz@linaro.org>, Minchan Kim <minchan@kernel.org>, ross.zwisler@linux.intel.com, jmarchan@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Kees Cook <keescook@chromium.org>, oleg@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Mateusz Guzik <mguzik@redhat.com>, Janis Danisevskis <jdanis@google.com>, calvinowens@fb.com, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Seth Forshee <seth.forshee@canonical>
List-Id: linux-api@vger.kernel.org

On Tue 13-09-16 13:27:39, Sonny Rao wrote:
> On Tue, Sep 13, 2016 at 12:12 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 12-09-16 10:28:53, Sonny Rao wrote:
> >> On Mon, Sep 12, 2016 at 10:15 AM, Michal Hocko <mhocko@kernel.org> wrote:
> >> > On Mon 12-09-16 08:31:36, Sonny Rao wrote:
> > [...]
> >> >> but how about the other fields like Swap, Private_Dirty and
> >> >> Private_Shared?
> >> >
> >> > Private_Shared can be pretty confusing as well without the whole context
> >> > as well see my other emails in the original thread (just to remind
> >> > shmem/tmpfs makes all this really confusing).
> >>
> >> But this is exactly the issue -- RSS is can be just as confusing if
> >> you don't know something about the application.
> >
> > I agree that rss can be confusing but we will not make the situation any
> > better if we add yet another confusing metric.
> >
> >> I think the issue is
> >> how common that situation is, and you seem to believe that it's so
> >> uncommon that it's actually better to keep the information more
> >> difficult to get for those of us who know something about our systems.
> >>
> >> That's fine, I guess we just have to disagree here, thanks for look at this.
> >
> > I think you should just step back and think more about what exactly
> > you expect from the counter(s). I believe what you want is an
> > estimate of a freeable memory when the particular process dies or is
> > killed. That would mean resident single mapped private anonymous memory
> > + unlinked single mapped shareable mappings + single mapped swapped out
> > memory. Maybe I've missed something but it should be something along
> > those lines. Definitely something that the current smaps infrastructure
> > doesn't give you, though.
> 
> Yes your description of what we want is pretty good.  Having a
> reasonable lower bound on the estimate is fine, though we probably
> want to break out swapped out memory separately.

Why would you want to separate that?

> Given that smaps
> doesn't provide this in a straightforward way, what do you think is
> the right way to provide this information?

I would be tempted to sneak it into /proc/<pid>/statm because that looks
like a proper place but getting this information is not for free
performance wise so I am not really sure something that relies on this
file would see unexpected stalls. Maybe this could be worked around by
some caching... I would suggest to check who is actually using this file
(top/ps etc...)

If this would be unacceptable then a new file could be considered.
-- 
Michal Hocko
SUSE Labs
