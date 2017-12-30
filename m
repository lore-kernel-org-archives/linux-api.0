From: Brice Goglin <brice.goglin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Sat, 30 Dec 2017 10:19:29 +0100
Message-ID: <74a585de-c825-b568-ee14-c8799b9d6238@gmail.com>
References: <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com>
 <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
 <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
 <71317994-af66-a1b2-4c7a-86a03253cf62@gmail.com>
 <20171230065845.GD27959@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171230065845.GD27959-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Anaczkowski, Lukasz" <lukasz.anaczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Box, David E" <david.e.box-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kogut, Jaroslaw" <Jaroslaw.Kogut-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Koss, Marcin" <marcin.koss-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Koziej, Artur" <artur.koziej-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lahtinen, Joonas" <joonas.lahtinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Moore, Robert" <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Odzioba, Lukasz" <lukasz.odzioba-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Schmauss, Erik" <erik.schmauss@intel.c>
List-Id: linux-api@vger.kernel.org



Le 30/12/2017 à 07:58, Matthew Wilcox a écrit :
> On Wed, Dec 27, 2017 at 10:10:34AM +0100, Brice Goglin wrote:
>>> Perhaps we can enlist /proc/iomem or a similar enumeration interface
>>> to tell userspace the NUMA node and whether the kernel thinks it has
>>> better or worse performance characteristics relative to base
>>> system-RAM, i.e. new IORES_DESC_* values. I'm worried that if we start
>>> publishing absolute numbers in sysfs userspace will default to looking
>>> for specific magic numbers in sysfs vs asking the kernel for memory
>>> that has performance characteristics relative to base "System RAM". In
>>> other words the absolute performance information that the HMAT
>>> publishes is useful to the kernel, but it's not clear that userspace
>>> needs that vs a relative indicator for making NUMA node preference
>>> decisions.
>> Some HPC users will benchmark the machine to discovery actual
>> performance numbers anyway.
>> However, most users won't do this. They will want to know relative
>> performance of different nodes. If you normalize HMAT values by dividing
>> them with system-RAM values, that's likely OK. If you just say "that
>> node is faster than system RAM", it's not precise enough.
> So "this memory has 800% bandwidth of normal" and "this memory has 70%
> bandwidth of normal"?

I guess that would work.
Brice
