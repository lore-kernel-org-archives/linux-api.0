From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH RFC v2 0/4] mm/ksm: add option to automerge VMAs
Date: Wed, 15 May 2019 17:15:57 +0200
Message-ID: <20190515151557.GA23969@kroah.com>
References: <20190514131654.25463-1-oleksandr@redhat.com>
 <20190514144105.GF4683@dhcp22.suse.cz>
 <20190514145122.GG4683@dhcp22.suse.cz>
 <20190515062523.5ndf7obzfgugilfs@butterfly.localdomain>
 <20190515065311.GB16651@dhcp22.suse.cz>
 <20190515145151.GG16651@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515145151.GG16651@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>, linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 15, 2019 at 04:51:51PM +0200, Michal Hocko wrote:
> [Cc Suren and Minchan - the email thread starts here 20190514131654.25463-1-oleksandr@redhat.com]
> 
> On Wed 15-05-19 08:53:11, Michal Hocko wrote:
> [...]
> > I will try to comment on the interface itself later. But I have to say
> > that I am not impressed. Abusing sysfs for per process features is quite
> > gross to be honest.
> 
> I have already commented on this in other email. I consider sysfs an
> unsuitable interface for per-process API.

Wait, what?  A new sysfs file/directory per process?  That's crazy, no
one must have benchmarked it :)

And I agree, sysfs is not for that, please don't abuse it.  Proc is for
process apis.

thanks,

greg k-h
