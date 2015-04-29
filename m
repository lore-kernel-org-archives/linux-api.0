From: Greg KH <greg@kroah.com>
Subject: Re: [RFC v2 1/4] fs: Add generic file system event notifications
Date: Wed, 29 Apr 2015 17:55:22 +0200
Message-ID: <20150429155522.GA14723@kroah.com>
References: <20150428135653.GD9955@quack.suse.cz>
 <20150428140936.GA13406@kroah.com>
 <553F9D56.6030301@samsung.com>
 <20150428173900.GA16708@kroah.com>
 <5540822C.10000@samsung.com>
 <20150429074259.GA31089@quack.suse.cz>
 <20150429091303.GA4090@kroah.com>
 <5540BC2A.8010504@samsung.com>
 <20150429134505.GB15398@kroah.com>
 <5540FD3E.9050801@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5540FD3E.9050801@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Beata Michalska <b.michalska@samsung.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, hughd@google.com, lczerner@redhat.com, hch@infradead.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, kyungmin.park@samsung.com, kmpark@infradead.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 05:48:14PM +0200, Beata Michalska wrote:
> On 04/29/2015 03:45 PM, Greg KH wrote:
> > On Wed, Apr 29, 2015 at 01:10:34PM +0200, Beata Michalska wrote:
> >>>>> It needs to be done internally by the app but is doable.
> >>>>> The app knows what it is watching, so it can maintain the mappings.
> >>>>> So prior to activating the notifications it can call 'stat' on the mount point.
> >>>>> Stat struct gives the 'st_dev' which is the device id. Same will be reported
> >>>>> within the message payload (through major:minor numbers). So having this,
> >>>>> the app is able to get any other information it needs. 
> >>>>> Note that the events refer to the file system as a whole and they may not
> >>>>> necessarily have anything to do with the actual block device. 
> >>>
> >>> How are you going to show an event for a filesystem that is made up of
> >>> multiple block devices?
> >>
> >> AFAIK, for such filesystems there will be similar case with the anonymous
> >> major:minor numbers - at least the btrfs is doing so. Not sure we can
> >> differentiate here the actual block device. So in this case such events
> >> serves merely as a hint for the userspace.
> > 
> > "hint" seems like this isn't really going to work well.
> > 
> > Do you have userspace code that can properly map this back to the "real"
> > device that is causing problems?  Without that, this doesn't seem all
> > that useful as no one would be able to use those events.
> 
> I'm not sure we are on the same page here.
> This is about watching the file system rather than the 'real' device.
> Like the threshold notifications: you would like to know when you
> will be approaching certain level of available space for the tmpfs
> mounted on /tmp.  You do know you are watching the /tmp
> and you know that the dev numbers for this are 0:20 (or so). 
> (either through calling stat on /tmp or through reading the /proc/$$/mountinfo)
> With this interface you can setup threshold levels
> for /tmp. Then, once the limit is reached the event will be
> sent with those anonymous major:minor numbers.
> 
> I can provide a sample code which will demonstrate how this
> can be achieved.

Yes, example code would be helpful to understand this, thanks.

greg k-h
