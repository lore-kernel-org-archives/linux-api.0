From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC 1/4] fs: Add generic file system event notifications
Date: Fri, 17 Apr 2015 15:16:28 +0200
Message-ID: <20150417131628.GA21539@quack.suse.cz>
References: <1429082147-4151-1-git-send-email-b.michalska@samsung.com>
 <1429082147-4151-2-git-send-email-b.michalska@samsung.com>
 <20150417113110.GD3116@quack.suse.cz>
 <553104E5.2040704@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <553104E5.2040704-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Linux Filesystem Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 17-04-15 15:04:37, Beata Michalska wrote:
> On 04/17/2015 01:31 PM, Jan Kara wrote:
> > On Wed 15-04-15 09:15:44, Beata Michalska wrote:
> > Also I think that we should make it clear that each event type has
> > different set of arguments. For threshold events they'll be L1 & L2, for
> > other events there may be no arguments, for other events maybe something
> > else...
> > 
> 
> Currently only the threshold events use arguments -  not sure what arguments
> could be used for the remaining notifications. But any suggestions are welcomed.
  Me neither be someone will surely find something in future ;)

> > ...
> >> +static const match_table_t fs_etypes = {
> >> +	{ FS_EVENT_INFO,    "info"  },
> >> +	{ FS_EVENT_WARN,    "warn"  },
> >> +	{ FS_EVENT_THRESH,  "thr"   },
> >> +	{ FS_EVENT_ERR,     "err"   },
> >> +	{ 0, NULL },
> >> +};
> >   Why are there these generic message types? Threshold messages make good
> > sense to me. But not so much the rest. If they don't have a clear meaning,
> > it will be a mess. So I also agree with a message like - "filesystem has
> > trouble, you should probably unmount and run fsck" - that's fine. But
> > generic "info" or "warning" doesn't really carry any meaning on its own and
> > thus seems pretty useless to me. To explain a bit more, AFAIU this
> > shouldn't be a generic logging interface where something like severity
> > makes sense but rather a relatively specific interface notifying about
> > events in filesystem userspace should know about so I expect relatively low
> > number of types of events, not tens or even hundreds...
> > 
> 
> Getting rid of those would simplify the configuration part, indeed.
> So we would be left with 'generic' and threshold events.
> I guess I've overdone this part.
  Well, I would avoid defining anything that's not really used. So
currently you can define threshold events and we start with just those.
When someone hooks up filesystem error paths to send notification, we can
create event type for telling "filesystem corrupted". And so on... We just
have to be careful to document that new event types can be added and
userspace has to ignore events it does not understand.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
