From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v2 1/4] fs: Add generic file system event notifications
Date: Wed, 29 Apr 2015 15:45:05 +0200
Message-ID: <20150429134505.GB15398@kroah.com>
References: <553E50EB.3000402@samsung.com>
 <20150427153711.GA23428@kroah.com>
 <20150428135653.GD9955@quack.suse.cz>
 <20150428140936.GA13406@kroah.com>
 <553F9D56.6030301@samsung.com>
 <20150428173900.GA16708@kroah.com>
 <5540822C.10000@samsung.com>
 <20150429074259.GA31089@quack.suse.cz>
 <20150429091303.GA4090@kroah.com>
 <5540BC2A.8010504@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5540BC2A.8010504-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 01:10:34PM +0200, Beata Michalska wrote:
> >>> It needs to be done internally by the app but is doable.
> >>> The app knows what it is watching, so it can maintain the mappings.
> >>> So prior to activating the notifications it can call 'stat' on the mount point.
> >>> Stat struct gives the 'st_dev' which is the device id. Same will be reported
> >>> within the message payload (through major:minor numbers). So having this,
> >>> the app is able to get any other information it needs. 
> >>> Note that the events refer to the file system as a whole and they may not
> >>> necessarily have anything to do with the actual block device. 
> > 
> > How are you going to show an event for a filesystem that is made up of
> > multiple block devices?
> 
> AFAIK, for such filesystems there will be similar case with the anonymous
> major:minor numbers - at least the btrfs is doing so. Not sure we can
> differentiate here the actual block device. So in this case such events
> serves merely as a hint for the userspace.

"hint" seems like this isn't really going to work well.

Do you have userspace code that can properly map this back to the "real"
device that is causing problems?  Without that, this doesn't seem all
that useful as no one would be able to use those events.

> At this point a user might decide to run some scanning tools.

You can't run a scanning tool on a tmpfs :)

So what can a user do with information about one of these "virtual"
filesystems that it can't directly see or access?

> We might extend the scope of the
> info being sent, though I would consider this as a nice-to-have but not
> required for this initial version of notifications. The filesystems
> might also want to decide to send their own custom messages so it is
> possible for filesystems like btrfs to send more detailed information
> using the new genetlink multicast group.
> >>   Or you can use /proc/self/mountinfo for the mapping. There you can see
> >> device numbers, real device names if applicable and mountpoints. This has
> >> the advantage that it works even if filesystem mountpoints change.
> > 
> > Ok, then that brings up my next question, how does this handle
> > namespaces?  What namespace is the event being sent in?  block devices
> > aren't namespaced, but the mount points are, is that going to cause
> > problems?
> > 
> 
> The path should get resolved properly (as from root level). though I must
> admit I'm not sure if there will be no issues when it comes to the network
> namespaces. I'll double check it. Any hints though are more than welcomed :)

What is "root level" here?  You can mount things in different namespaces
all over the place.

This is going to get really complex very quickly :(

I still think you should tie this to an existing sysfs device, which
handles the namespace issues for you, and it also handles the fact that
userspace can properly identify the device, if at all possible.

thanks,

greg k-h
