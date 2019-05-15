From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH RFC v2 0/4] mm/ksm: add option to automerge VMAs
Date: Wed, 15 May 2019 09:37:23 +0200
Message-ID: <20190515073723.wbr522cpyjfelfav@butterfly.localdomain>
References: <20190514131654.25463-1-oleksandr@redhat.com>
 <20190514144105.GF4683@dhcp22.suse.cz>
 <20190514145122.GG4683@dhcp22.suse.cz>
 <20190515062523.5ndf7obzfgugilfs@butterfly.localdomain>
 <20190515065311.GB16651@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515065311.GB16651@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

Hi.

On Wed, May 15, 2019 at 08:53:11AM +0200, Michal Hocko wrote:
> On Wed 15-05-19 08:25:23, Oleksandr Natalenko wrote:
> [...]
> > > > Please make sure to describe a usecase that warrants adding a new
> > > > interface we have to maintain for ever.
> > 
> > I think of two major consumers of this interface:
> > 
> > 1) hosts, that run containers, especially similar ones and especially in
> > a trusted environment;
> > 
> > 2) heavy applications, that can be run in multiple instances, not
> > limited to opensource ones like Firefox, but also those that cannot be
> > modified.
> 
> This is way too generic. Please provide something more specific. Ideally
> with numbers. Why those usecases cannot use an existing interfaces.
> Remember you are trying to add a new user interface which we will have
> to maintain for ever.

For my current setup with 2 Firefox instances I get 100 to 200 MiB saved
for the second instance depending on the amount of tabs.

1 FF instance with 15 tabs:

$ echo "$(cat /sys/kernel/mm/ksm/pages_sharing) * 4 / 1024" | bc
410

2 FF instances, second one has 12 tabs (all the tabs are different):

$ echo "$(cat /sys/kernel/mm/ksm/pages_sharing) * 4 / 1024" | bc
592

At the very moment I do not have specific numbers for containerised
workload, but those should be similar in case the containers share
similar/same runtime (like multiple Node.js containers etc).

Answering your question regarding using existing interfaces, since
there's only one, madvise(2), this requires modifying all the
applications one wants to de-duplicate. In case of containers with
arbitrary content or in case of binary-only apps this is pretty hard if
not impossible to do properly.

> I will try to comment on the interface itself later. But I have to say
> that I am not impressed. Abusing sysfs for per process features is quite
> gross to be honest.

Sure, please do.

Thanks for your time and inputs.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
