From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Fri, 22 Dec 2017 15:57:41 -0800
Message-ID: <CAPcyv4j95rWmFM5NDvoRJakwVE5YUgcipQW2Ju+40+FD6vYs+Q@mail.gmail.com>
References: <20171214130032.GK16951@dhcp22.suse.cz> <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org> <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org> <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com> <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
 <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com> <20171222232231.GA26715@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20171222232231.GA26715@linux.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Brice Goglin <brice.goglin@gmail.com>, Matthew Wilcox <willy@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Michal Hocko <mhocko@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, "Box, David E" <david.e.box@intel.com>, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Koss, Marcin" <marcin.koss@intel.com>, "Koziej, Artur" <artur.koziej@intel.com>, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Schmauss, Erik" <erik.schmauss@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 22, 2017 at 3:22 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Dec 22, 2017 at 02:53:42PM -0800, Dan Williams wrote:
>> On Thu, Dec 21, 2017 at 12:31 PM, Brice Goglin <brice.goglin@gmail.com> =
wrote:
>> > Le 20/12/2017 =C3=A0 23:41, Ross Zwisler a =C3=A9crit :
>> [..]
>> > Hello
>> >
>> > I can confirm that HPC runtimes are going to use these patches (at lea=
st
>> > all runtimes that use hwloc for topology discovery, but that's the vas=
t
>> > majority of HPC anyway).
>> >
>> > We really didn't like KNL exposing a hacky SLIT table [1]. We had to
>> > explicitly detect that specific crazy table to find out which NUMA nod=
es
>> > were local to which cores, and to find out which NUMA nodes were
>> > HBM/MCDRAM or DDR. And then we had to hide the SLIT values to the
>> > application because the reported latencies didn't match reality. Quite
>> > annoying.
>> >
>> > With Ross' patches, we can easily get what we need:
>> > * which NUMA nodes are local to which CPUs? /sys/devices/system/node/
>> > can only report a single local node per CPU (doesn't work for KNL and
>> > upcoming architectures with HBM+DDR+...)
>> > * which NUMA nodes are slow/fast (for both bandwidth and latency)
>> > And we can still look at SLIT under /sys/devices/system/node if really
>> > needed.
>> >
>> > And of course having this in sysfs is much better than parsing ACPI
>> > tables that are only accessible to root :)
>>
>> On this point, it's not clear to me that we should allow these sysfs
>> entries to be world readable. Given /proc/iomem now hides physical
>> address information from non-root we at least need to be careful not
>> to undo that with new sysfs HMAT attributes.
>
> This enabling does not expose any physical addresses to userspace.  It on=
ly
> provides performance numbers from the HMAT and associates them with exist=
ing
> NUMA nodes.  Are you worried that exposing performance numbers to non-roo=
t
> users via sysfs poses a security risk?

It's an information disclosure that's not clear we need to make to
non-root processes.

I'm more worried about userspace growing dependencies on the absolute
numbers when those numbers can change from platform to platform.
Differentiated memory on one platform may be the common memory pool on
another.

To me this has parallels with storage device hinting where
specifications like T10 have a complex enumeration of all the
performance hints that can be passed to the device, but the Linux
enabling effort aims for a sanitzed set of relative hints that make
sense. It's more flexible if userspace specifies a relative intent
rather than an absolute performance target. Putting all the HMAT
information into sysfs gives userspace more information than it could
possibly do anything reasonable, at least outside of specialized apps
that are hand tuned for a given hardware platform.
