From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] Introduce MADV_COLD and MADV_PAGEOUT
Date: Thu, 13 Jun 2019 13:51:42 +0900
Message-ID: <20190613045142.GG55602@google.com>
References: <20190610111252.239156-1-minchan@kernel.org>
 <21cf2918-ba0e-aae1-a20e-36ee1ad4f704@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21cf2918-ba0e-aae1-a20e-36ee1ad4f704@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Mon, Jun 10, 2019 at 11:03:00AM -0700, Dave Hansen wrote:
> I'd really love to see the manpages for these new flags.  The devil is
> in the details of our promises to userspace.

I'm waiting comments from reviewers since I have fixed what they point
out from the previous version.

I will add manpage material in respin after the getting more feedback.
Thanks.
