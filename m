From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Wed, 20 Dec 2017 13:16:49 -0800
Message-ID: <20171220211649.GA32200@bombadil.infradead.org>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, "Box, David E" <david.e.box@intel.com>, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Koss, Marcin" <marcin.koss@intel.com>, "Koziej, Artur" <artur.koziej@intel.com>, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Schmauss, Erik" <erik.schmauss@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, Andrew Morton <akpm@linux->
List-Id: linux-api@vger.kernel.org

On Wed, Dec 20, 2017 at 12:22:21PM -0800, Dave Hansen wrote:
> On 12/20/2017 10:19 AM, Matthew Wilcox wrote:
> > I don't know what the right interface is, but my laptop has a set of
> > /sys/devices/system/memory/memoryN/ directories.  Perhaps this is the
> > right place to expose write_bw (etc).
> 
> Those directories are already too redundant and wasteful.  I think we'd
> really rather not add to them.  In addition, it's technically possible
> to have a memory section span NUMA nodes and have different performance
> properties, which make it impossible to represent there.
> 
> In any case, ACPI PXM's (Proximity Domains) are guaranteed to have
> uniform performance properties in the HMAT, and we just so happen to
> always create one NUMA node per PXM.  So, NUMA nodes really are a good fit.

I think you're missing my larger point which is that I don't think this
should be exposed to userspace as an ACPI feature.  Because if you do,
then it'll also be exposed to userspace as an openfirmware feature.
And sooner or later a devicetree feature.  And then writing a portable
program becomes an exercise in suffering.

So, what's the right place in sysfs that isn't tied to ACPI?  A new
directory or set of directories under /sys/devices/system/memory/ ?
