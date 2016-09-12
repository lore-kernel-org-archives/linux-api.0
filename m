From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 12 Sep 2016 19:15:04 +0200
Message-ID: <20160912171503.GB14997@dhcp22.suse.cz>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
 <20160912120248.GK14524@dhcp22.suse.cz>
 <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Robert Foss <robert.foss@collabora.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, John Stultz <john.stultz@linaro.org>, Minchan Kim <minchan@kernel.org>, ross.zwisler@linux.intel.com, jmarchan@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Kees Cook <keescook@chromium.org>, oleg@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Mateusz Guzik <mguzik@redhat.com>, Janis Danisevskis <jdanis@google.com>, calvinowens@fb.com, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, seth.forshee@canonical.com, tixxdz@g
List-Id: linux-api@vger.kernel.org

On Mon 12-09-16 08:31:36, Sonny Rao wrote:
> On Mon, Sep 12, 2016 at 5:02 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 05-09-16 16:14:06, robert.foss@collabora.com wrote:
> >> From: Robert Foss <robert.foss@collabora.com>
> >>
> >> This series provides the /proc/PID/totmaps feature, which
> >> summarizes the information provided by /proc/PID/smaps for
> >> improved performance and usability reasons.
> >>
> >> A use case is to speed up monitoring of memory consumption in
> >> environments where RSS isn't precise.
> >>
> >> For example Chrome tends to many processes which have hundreds of VMAs
> >> with a substantial amount of shared memory, and the error of using
> >> RSS rather than PSS tends to be very large when looking at overall
> >> memory consumption.  PSS isn't kept as a single number that's exported
> >> like RSS, so to calculate PSS means having to parse a very large smaps
> >> file.
> >>
> >> This process is slow and has to be repeated for many processes, and we
> >> found that the just act of doing the parsing was taking up a
> >> significant amount of CPU time, so this patch is an attempt to make
> >> that process cheaper.
> >
> > I still maintain my concerns about a single pss value. It might work in
> > a very specific situations where the consumer knows what is shared but
> > other than that the value can be more misleading than helpful. So a NACK
> > from me until I am shown that this is usable in general and still
> > helpful.
> 
> I know you think Pss isn't useful in general (though I'll point out
> two other independent people said they found it useful)

sure, and one of them admitted that the value is useful because they
_know_ the resource. The other was quite vague for me to understand
all the details. Please, try to understand that once you provide a user
API then it will carved in stone. If the interface is poor and ambigous
it will bite us later. One very specific usecase doesn't justify
something that might be really misleading for 90% of cases.

> but how about the other fields like Swap, Private_Dirty and
> Private_Shared?

Private_Shared can be pretty confusing as well without the whole context
as well see my other emails in the original thread (just to remind
shmem/tmpfs makes all this really confusing).

-- 
Michal Hocko
SUSE Labs
