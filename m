From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC 1/4] fs: Add generic file system event notifications
Date: Fri, 17 Apr 2015 15:41:44 +0200
Message-ID: <20150417134144.GA23905@quack.suse.cz>
References: <1429082147-4151-1-git-send-email-b.michalska@samsung.com>
 <1429082147-4151-2-git-send-email-b.michalska@samsung.com>
 <20150417113110.GD3116@quack.suse.cz>
 <553104E5.2040704@samsung.com>
 <55310957.3070101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55310957.3070101@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Beata Michalska <b.michalska@samsung.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, hughd@google.com, lczerner@redhat.com, hch@infradead.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, kyungmin.park@samsung.com, kmpark@infradead.org, Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri 17-04-15 09:23:35, Austin S Hemmelgarn wrote:
> On 2015-04-17 09:04, Beata Michalska wrote:
> >On 04/17/2015 01:31 PM, Jan Kara wrote:
> >>On Wed 15-04-15 09:15:44, Beata Michalska wrote:
> >>...
> >>>+static const match_table_t fs_etypes = {
> >>>+	{ FS_EVENT_INFO,    "info"  },
> >>>+	{ FS_EVENT_WARN,    "warn"  },
> >>>+	{ FS_EVENT_THRESH,  "thr"   },
> >>>+	{ FS_EVENT_ERR,     "err"   },
> >>>+	{ 0, NULL },
> >>>+};
> >>   Why are there these generic message types? Threshold messages make good
> >>sense to me. But not so much the rest. If they don't have a clear meaning,
> >>it will be a mess. So I also agree with a message like - "filesystem has
> >>trouble, you should probably unmount and run fsck" - that's fine. But
> >>generic "info" or "warning" doesn't really carry any meaning on its own and
> >>thus seems pretty useless to me. To explain a bit more, AFAIU this
> >>shouldn't be a generic logging interface where something like severity
> >>makes sense but rather a relatively specific interface notifying about
> >>events in filesystem userspace should know about so I expect relatively low
> >>number of types of events, not tens or even hundreds...
> >>
> >>								Honza
> >
> >Getting rid of those would simplify the configuration part, indeed.
> >So we would be left with 'generic' and threshold events.
> >I guess I've overdone this part.
> 
> For some filesystems, it may make sense to differentiate between a
> generic warning and an error.  For BTRFS and ZFS for example, if
> there is a csum error on a block, this will get automatically
> corrected in many configurations, and won't require anything like
> fsck to be run, but monitoring applications will still probably want
> to be notified.
   Sure, but in that case just create an event CORRECTED_CHECKSUM_ERROR and
use that. Then userspace knows what it should do with the event. No need to
hide it behind warning / error category.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
