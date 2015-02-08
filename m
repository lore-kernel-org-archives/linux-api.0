From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in sysfs
Date: Sun, 8 Feb 2015 10:32:13 +0200
Message-ID: <22CE403F-1EF2-4B52-8CA1-3CF18936CD35@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net> <20150206125916.GB26247@kroah.com> <20150206154157.GD1143@localhost.localdomain> <20150207040743.GB29944@kroah.com> <ACE69613-157F-4516-8499-EF8242D26736@gmail.com> <20150208024506.GC15396@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20150208024506.GC15396@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Laurence Oberman <oberman.l@gmail.com>, "Bryn M. Reeves" <bmr@redhat.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>
List-Id: linux-api@vger.kernel.org


> On 8.2.2015, at 4.45, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> On Sat, Feb 07, 2015 at 09:27:05PM -0500, Laurence Oberman wrote:
>> Hello
>> Its not going to be tens of thousands of devices. That count was an
>> aggregate based on 1000's of servers.
>> In reality its unlikely to ever be more than 100 tapes drives per
>> individual Linux kernel instance.
>> Therefore sysfs will be the valid way to do this and make the data
>> available to user space.
> 
> Even if it is only 2 tape drives, again, what's wrong with using the
> existing i/o statistic interfaces that all block devices have?  Don't go
> making special one-off interfaces for one type of device if at all
> possible.
> 
The tape driver does not have access to the block device i/o statistics because the tapes are not block devices but character devices. They use the Linux block subsystem enough to do i/o but this does not include access to the statistics counters.

The purpose of the suggested text vector format patch is to create statistics that have the same format as the existing i/o statistics that the block devices so that the existing tools can be used with minimal modifications. One alternative is, of course, to tie the st driver more into the Linux block device system. I have looked into this several times but have never seen how to do this in a simple enough way.

Thanks,
Kai

