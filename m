From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Wed, 11 Feb 2015 11:32:01 +0000
Message-ID: <20150211113200.GA5864@localhost.localdomain>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
 <20150206125916.GB26247@kroah.com>
 <20150206154157.GD1143@localhost.localdomain>
 <20150207040743.GB29944@kroah.com>
 <20150210142719.GA1437@localhost.localdomain>
 <20150210223027.GA27269@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150210223027.GA27269@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 11, 2015 at 06:30:27AM +0800, Greg KH wrote:
> On Tue, Feb 10, 2015 at 02:27:20PM +0000, Bryn M. Reeves wrote:
> > On Sat, Feb 07, 2015 at 12:07:43PM +0800, Greg KH wrote:
> > 
> > $ cat /sys/fs/selinux/avc/cache_stats 
> > lookups hits misses allocations reclaims frees
> > 18938916 18921707 17209 17209 17328 22215
> > 38164283 38146514 17769 17769 16800 19049
> > 18078108 18056991 21117 21117 21344 19305
> > 15168204 15150079 18125 18125 17776 13149
> > 0 0 0 0 0 0
> > 0 0 0 0 0 0
> > 0 0 0 0 0 0
> > 0 0 0 0 0 0
> > 
> > $ cat /sys/fs/selinux/avc/hash_stats
> > entries: 506
> > buckets used: 290/512
> > longest chain: 5
> 
> Ugh, those look like they should be debugfs interfaces.  Thanks, I'll
> add them to my list of things to nag people about...

Actually looking properly these are outside sysfs:

$ mount | grep selinux
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)

So everything below the mount point is in their own vfstype.

Regards,
Bryn.

