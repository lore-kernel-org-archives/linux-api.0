From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC v2 0/4] mm/ksm: add option to automerge VMAs
Date: Wed, 15 May 2019 08:53:11 +0200
Message-ID: <20190515065311.GB16651@dhcp22.suse.cz>
References: <20190514131654.25463-1-oleksandr@redhat.com>
 <20190514144105.GF4683@dhcp22.suse.cz>
 <20190514145122.GG4683@dhcp22.suse.cz>
 <20190515062523.5ndf7obzfgugilfs@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515062523.5ndf7obzfgugilfs@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

On Wed 15-05-19 08:25:23, Oleksandr Natalenko wrote:
[...]
> > > Please make sure to describe a usecase that warrants adding a new
> > > interface we have to maintain for ever.
> 
> I think of two major consumers of this interface:
> 
> 1) hosts, that run containers, especially similar ones and especially in
> a trusted environment;
> 
> 2) heavy applications, that can be run in multiple instances, not
> limited to opensource ones like Firefox, but also those that cannot be
> modified.

This is way too generic. Please provide something more specific. Ideally
with numbers. Why those usecases cannot use an existing interfaces.
Remember you are trying to add a new user interface which we will have
to maintain for ever.

I will try to comment on the interface itself later. But I have to say
that I am not impressed. Abusing sysfs for per process features is quite
gross to be honest.

-- 
Michal Hocko
SUSE Labs
