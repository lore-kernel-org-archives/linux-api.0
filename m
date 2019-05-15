From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH RFC v2 0/4] mm/ksm: add option to automerge VMAs
Date: Wed, 15 May 2019 10:51:58 +0200
Message-ID: <20190515085158.hyuamrxkxhjhx6go@butterfly.localdomain>
References: <20190514131654.25463-1-oleksandr@redhat.com>
 <20190514144105.GF4683@dhcp22.suse.cz>
 <20190514145122.GG4683@dhcp22.suse.cz>
 <20190515062523.5ndf7obzfgugilfs@butterfly.localdomain>
 <20190515065311.GB16651@dhcp22.suse.cz>
 <20190515073723.wbr522cpyjfelfav@butterfly.localdomain>
 <20190515083321.GC16651@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515083321.GC16651@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 15, 2019 at 10:33:21AM +0200, Michal Hocko wrote:
> > For my current setup with 2 Firefox instances I get 100 to 200 MiB saved
> > for the second instance depending on the amount of tabs.
> 
> What does prevent Firefox (an opensource project) to be updated to use
> the explicit merging?

This was rather an example of a big project. Other big projects may be
closed source, of course.

And yes, with regard to FF specifically I think nothing prevents it from
being modified appropriately.

> > Answering your question regarding using existing interfaces, since
> > there's only one, madvise(2), this requires modifying all the
> > applications one wants to de-duplicate. In case of containers with
> > arbitrary content or in case of binary-only apps this is pretty hard if
> > not impossible to do properly.
> 
> OK, this makes more sense. Please note that there are other people who
> would like to see certain madvise operations to be done on a remote
> process - e.g. to allow external memory management (Android would like
> to control memory aging so something like MADV_DONTNEED without loosing
> content and more probably) and potentially other madvise operations.
> Or maybe we need a completely new interface other than madvise.

I didn't know about those intentions. Could you please point me to a
relevant discussion so that I can check the details?

> In general, having a more generic API that would cover more usecases is
> definitely much more preferable than one ad-hoc API that handles a very
> specific usecase. So please try to think about a more generic

Yup, I see now. Since you are aware of ongoing intentions, please do Cc
those people then and/or let me know about previous discussions please.
That way thinking of how a new API should be implemented (be it a sysfs
file or something else) should be easier and more visible.

Thanks.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
