From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC v2 0/4] mm/ksm: add option to automerge VMAs
Date: Wed, 15 May 2019 16:24:19 +0200
Message-ID: <20190515142419.GD16651@dhcp22.suse.cz>
References: <20190514131654.25463-1-oleksandr@redhat.com>
 <20190514144105.GF4683@dhcp22.suse.cz>
 <20190514145122.GG4683@dhcp22.suse.cz>
 <20190515062523.5ndf7obzfgugilfs@butterfly.localdomain>
 <20190515065311.GB16651@dhcp22.suse.cz>
 <20190515073723.wbr522cpyjfelfav@butterfly.localdomain>
 <20190515083321.GC16651@dhcp22.suse.cz>
 <20190515085158.hyuamrxkxhjhx6go@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515085158.hyuamrxkxhjhx6go@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

On Wed 15-05-19 10:51:58, Oleksandr Natalenko wrote:
> On Wed, May 15, 2019 at 10:33:21AM +0200, Michal Hocko wrote:
> > > For my current setup with 2 Firefox instances I get 100 to 200 MiB saved
> > > for the second instance depending on the amount of tabs.
> > 
> > What does prevent Firefox (an opensource project) to be updated to use
> > the explicit merging?
> 
> This was rather an example of a big project. Other big projects may be
> closed source, of course.

Again, specific examples are usually considered a much better
justification than "something might use the feature".

[...]

> > OK, this makes more sense. Please note that there are other people who
> > would like to see certain madvise operations to be done on a remote
> > process - e.g. to allow external memory management (Android would like
> > to control memory aging so something like MADV_DONTNEED without loosing
> > content and more probably) and potentially other madvise operations.
> > Or maybe we need a completely new interface other than madvise.
> 
> I didn't know about those intentions. Could you please point me to a
> relevant discussion so that I can check the details?

I am sorry I do not have any specific links to patches under discussion.
We have discussed that topic at LSFMM this year
(https://lwn.net/Articles/787217/) and Google guys should be sending
something soon.
-- 
Michal Hocko
SUSE Labs
