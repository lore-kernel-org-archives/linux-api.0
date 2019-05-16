From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH RFC 0/5] mm/ksm, proc: introduce remote madvise
Date: Thu, 16 May 2019 16:21:42 +0200
Message-ID: <20190516142142.qti3zfevuf67dedn@butterfly.localdomain>
References: <20190516094234.9116-1-oleksandr@redhat.com>
 <20190516104412.GN16651@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190516104412.GN16651@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi.

On Thu, May 16, 2019 at 12:44:12PM +0200, Michal Hocko wrote:
> On Thu 16-05-19 11:42:29, Oleksandr Natalenko wrote:
> [...]
> > * to mark all the eligible VMAs as mergeable, use:
> > 
> >    # echo merge > /proc/<pid>/madvise
> > 
> > * to unmerge all the VMAs, use:
> > 
> >    # echo unmerge > /proc/<pid>/madvise
> 
> Please do not open a new thread until a previous one reaches some
> conclusion. I have outlined some ways to go forward in
> http://lkml.kernel.org/r/20190515145151.GG16651@dhcp22.suse.cz.
> I haven't heard any feedback on that, yet you open a 3rd way in a
> different thread. This will not help to move on with the discussion.
> 
> Please follow up on that thread.

Sure, I will follow the thread once and if there are responses. Consider
this one to be an intermediate summary of current suggestions and also
an indication that it is better to have the code early for public eyes.

Thank you.

> -- 
> Michal Hocko
> SUSE Labs

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
