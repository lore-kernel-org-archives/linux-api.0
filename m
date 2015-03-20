From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V7] Allow compaction of unevictable pages
Date: Fri, 20 Mar 2015 15:17:03 -0700
Message-ID: <20150320151703.dfd116931ddb397ade8bfd8c@linux-foundation.org>
References: <1426859390-10974-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1426859390-10974-1-git-send-email-emunson@akamai.com>
Sender: linux-doc-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>, linux-doc@vger.kernel.org, linux-rt-users@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 20 Mar 2015 09:49:50 -0400 Eric B Munson <emunson@akamai.com> wrote:

> Currently, pages which are marked as unevictable are protected from
> compaction, but not from other types of migration.  The POSIX real time
> extension explicitly states that mlock() will prevent a major page
> fault, but the spirit of this is that mlock() should give a process the
> ability to control sources of latency, including minor page faults.
> However, the mlock manpage only explicitly says that a locked page will
> not be written to swap and this can cause some confusion.  The
> compaction code today does not give a developer who wants to avoid swap
> but wants to have large contiguous areas available any method to achieve
> this state.  This patch introduces a sysctl for controlling compaction
> behavior with respect to the unevictable lru.  Users that demand no page
> faults after a page is present can set compact_unevictable_allowed to 0
> and users who need the large contiguous areas can enable compaction on
> locked memory by leaving the default value of 1.

Do we really really really need the /proc knob?  We're already
migrating these pages so users of mlock will occasionally see some
latency - how likely is it that this patch will significantly damage
anyone?

