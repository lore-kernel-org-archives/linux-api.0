From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Thu, 23 Jan 2020 10:13:39 +0100
Message-ID: <20200123091339.GI29276@dhcp22.suse.cz>
References: <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
 <20200119161431.GA94410@google.com>
 <20200120075825.GH18451@dhcp22.suse.cz>
 <20200121183212.GF140922@google.com>
 <20200122082853.GS29276@dhcp22.suse.cz>
 <20200123014131.GA249784@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200123014131.GA249784@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: sspatil@google.com, kirill@shutemov.name, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, oleksandr@redhat.com, surenb@google.com, timmurray@google.com, dancol@google.com, sonnyrao@google.com, bgeffon@google.com, hannes@cmpxchg.org, shakeelb@google.com, joaodias@google.com, ktkhai@virtuozzo.com, christian.brauner@ubuntu.com, sjpark@amazon.de
List-Id: linux-api@vger.kernel.org

On Wed 22-01-20 17:41:31, Minchan Kim wrote:
[...]
> What do you want to see further?

Either a consensus that it is sufficient to have an inherently racy
interface that requires some form of external sychronization or
a robust interface that can cope with races in a sensible way.
And no, having a flag for future extension is definitely not the
way how a new API should be added. Seriously!

-- 
Michal Hocko
SUSE Labs
