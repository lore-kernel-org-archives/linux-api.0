From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC 7/7] mm: madvise support MADV_ANONYMOUS_FILTER and
 MADV_FILE_FILTER
Date: Tue, 28 May 2019 14:38:32 +0200
Message-ID: <20190528123832.GD1658@dhcp22.suse.cz>
References: <CAKOZuesnS6kBFX-PKJ3gvpkv8i-ysDOT2HE2Z12=vnnHQv0FDA@mail.gmail.com>
 <20190528084927.GB159710@google.com>
 <20190528090821.GU1658@dhcp22.suse.cz>
 <20190528103256.GA9199@google.com>
 <20190528104117.GW1658@dhcp22.suse.cz>
 <20190528111208.GA30365@google.com>
 <20190528112840.GY1658@dhcp22.suse.cz>
 <CAKOZuesCSrE0esqDDbo8x5u5rM-Uv_81jjBt1QRXFKNOUJu0aw@mail.gmail.com>
 <20190528115609.GA1658@dhcp22.suse.cz>
 <CAKOZuesnXGAsQgkB45n=jqwDRQ4_aoPiydmZxfxPmzO2p=cTow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuesnXGAsQgkB45n=jqwDRQ4_aoPiydmZxfxPmzO2p=cTow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue 28-05-19 05:18:48, Daniel Colascione wrote:
[...]
> The important requirement, I think, is that we need to support
> managing "memory-naive" uncooperative tasks (perhaps legacy ones
> written before cross-process memory management even became possible),
> and I think that the cooperative-vs-uncooperative distinction matters
> a lot more than the tgid of the thread doing the memory manipulation.
> (Although in our case, we really do need a separate tgid. :-))

Agreed here and that requires some sort of revalidation and failure on
"object has changed" in one form or another IMHO.
-- 
Michal Hocko
SUSE Labs
