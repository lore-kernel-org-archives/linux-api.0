From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC v2 0/4] mm/ksm: add option to automerge VMAs
Date: Wed, 15 May 2019 16:51:51 +0200
Message-ID: <20190515145151.GG16651@dhcp22.suse.cz>
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
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

[Cc Suren and Minchan - the email thread starts here 20190514131654.25463-1-oleksandr@redhat.com]

On Wed 15-05-19 08:53:11, Michal Hocko wrote:
[...]
> I will try to comment on the interface itself later. But I have to say
> that I am not impressed. Abusing sysfs for per process features is quite
> gross to be honest.

I have already commented on this in other email. I consider sysfs an
unsuitable interface for per-process API. Not to mention this particular
one is very KSM specific while the question about setting different
hints on memory of a remote process is a more generic question. As
already mentioned there are usecases where people would like to say
that a certain memory is cold from outside of the process context (e.g.
monitor application). So essentially a form of a user space memory
management. And this usecase sounds a bit similar to me and having a
common api sounds more sensible to me.

One thing we were discussing at LSFMM this year was a way to either
provide madvise_remote(pid, addr, length, advice) or a fadvise
alternative over /proc/<pid>/map_vmas/<range> file descriptors
(essentially resembling the existing map_files api) to achieve such a
functionality. This is still a very rough idea but the api would sound
much more generic to me and it would allow much wider range of usecases.

But maybe I am completely wrong and this is just opens a can of worms
that we do not want.
-- 
Michal Hocko
SUSE Labs
