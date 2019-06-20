From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v1 1/4] mm: introduce MADV_COLD
Date: Thu, 20 Jun 2019 11:57:09 -0400
Message-ID: <CAEXW_YSY2GgW_Fp6VN2Qrf0Gr8c71DUgoTzZoq-V2=jFgDEDvQ@mail.gmail.com>
References: <20190603053655.127730-1-minchan@kernel.org> <20190603053655.127730-2-minchan@kernel.org>
 <20190604203841.GC228607@google.com> <20190610100904.GC55602@google.com>
 <20190612172104.GA125771@google.com> <20190613044824.GF55602@google.com>
 <20190619171340.GA83620@google.com> <20190620050132.GC105727@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620050132.GC105727@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, oleksandr@redhat.com, hdanton@sina.com, Vladimir Davydov <vdavydov.dev@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 1:01 AM Minchan Kim <minchan@kernel.org> wrote:
[snip]
> > > >
> > > > I think to fix this, what you should do is clear the PG_Idle flag if the
> > > > young/accessed PTE bits are set. If PG_Idle is already cleared, then you
> > > > don't need to do anything.
> > >
> > > I'm not sure. What does it make MADV_COLD special?
> > > How about MADV_FREE|MADV_DONTNEED?
> > > Why don't they clear PG_Idle if pte was young at tearing down pte?
> >
> > Good point, so it sounds like those (MADV_FREE|MADV_DONTNEED) also need to be fixed then?
>
> Not sure. If you want it, maybe you need to fix every pte clearing and pte_mkold
> part, which is more general to cover every sites like munmap, get_user_pages and
> so on. Anyway, I don't think it's related to this patchset.

Ok, I can look into this issue on my own when I get time. I'll add it
to my list. No problems with your patch otherwise from my side.

 -Joel
