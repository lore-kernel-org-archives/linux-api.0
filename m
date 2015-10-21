From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] HID: roccat: Fixed resubmit: Deprecating most Roccat
 sysfs attributes
Date: Wed, 21 Oct 2015 11:55:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1510211155170.21100@pobox.suse.cz>
References: <1444921209.2900.17.camel@neuromancer.tessier-ashpool>  <20151015184944.GA1226@kroah.com> <1445087428.2322.10.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445087428.2322.10.camel@neuromancer.tessier-ashpool>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-api@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-api@vger.kernel.org

On Sat, 17 Oct 2015, Stefan Achatz wrote:

> Deprecates all Roccat sysfs attributes except the ones for the old Kone by moving
> abi descriptions from testing to obsolete.
> For most devices everything can be done using the hidraw ioctls HIDIOCGFEATURE
> and HIDIOCSFEATURE, so I would suggest future removal of device specific drivers.
> The userspace tools don't use these attributes for a year now.
> The first Kone is not fully HID-compliant and will still need a module.

Ok, I am queuing this in for-4.4/roccat-sysfs-deprecation, let's see how 
this goes.

Thanks,

-- 
Jiri Kosina
SUSE Labs
