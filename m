From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Sun, 8 Feb 2015 10:45:06 +0800
Message-ID: <20150208024506.GC15396@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
 <20150206125916.GB26247@kroah.com>
 <20150206154157.GD1143@localhost.localdomain>
 <20150207040743.GB29944@kroah.com>
 <ACE69613-157F-4516-8499-EF8242D26736@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ACE69613-157F-4516-8499-EF8242D26736@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 07, 2015 at 09:27:05PM -0500, Laurence Oberman wrote:
> Hello
> Its not going to be tens of thousands of devices. That count was an
> aggregate based on 1000's of servers.
> In reality its unlikely to ever be more than 100 tapes drives per
> individual Linux kernel instance.
> Therefore sysfs will be the valid way to do this and make the data
> available to user space.

Even if it is only 2 tape drives, again, what's wrong with using the
existing i/o statistic interfaces that all block devices have?  Don't go
making special one-off interfaces for one type of device if at all
possible.

thanks,

greg k-h
