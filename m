From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Wed, 20 Dec 2017 15:41:05 -0700
Message-ID: <20171220224105.GA27258@linux.intel.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Box, David E" <david.e.box-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Anaczkowski,
 Lukasz" <lukasz.anaczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Moore,
 Robert" <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Odzioba,
 Lukasz" <lukasz.odzioba-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Schmauss, Erik" <erik.schmauss-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linuxppc-dev <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, "Kogut,
 Jaroslaw" <Jaroslaw.Kogut-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "Koss,
 Marcin" <marcin.koss-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brice Goglin <brice.goglin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nachi
List-Id: linux-api@vger.kernel.org

On Wed, Dec 20, 2017 at 02:29:56PM -0800, Dan Williams wrote:
> On Wed, Dec 20, 2017 at 1:24 PM, Ross Zwisler
> <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > On Wed, Dec 20, 2017 at 01:16:49PM -0800, Matthew Wilcox wrote:
> >> On Wed, Dec 20, 2017 at 12:22:21PM -0800, Dave Hansen wrote:
> >> > On 12/20/2017 10:19 AM, Matthew Wilcox wrote:
> >> > > I don't know what the right interface is, but my laptop has a set of
> >> > > /sys/devices/system/memory/memoryN/ directories.  Perhaps this is the
> >> > > right place to expose write_bw (etc).
> >> >
> >> > Those directories are already too redundant and wasteful.  I think we'd
> >> > really rather not add to them.  In addition, it's technically possible
> >> > to have a memory section span NUMA nodes and have different performance
> >> > properties, which make it impossible to represent there.
> >> >
> >> > In any case, ACPI PXM's (Proximity Domains) are guaranteed to have
> >> > uniform performance properties in the HMAT, and we just so happen to
> >> > always create one NUMA node per PXM.  So, NUMA nodes really are a good fit.
> >>
> >> I think you're missing my larger point which is that I don't think this
> >> should be exposed to userspace as an ACPI feature.  Because if you do,
> >> then it'll also be exposed to userspace as an openfirmware feature.
> >> And sooner or later a devicetree feature.  And then writing a portable
> >> program becomes an exercise in suffering.
> >>
> >> So, what's the right place in sysfs that isn't tied to ACPI?  A new
> >> directory or set of directories under /sys/devices/system/memory/ ?
> >
> > Oh, the current location isn't at all tied to acpi except that it happens to
> > be named 'hmat'.  When it was all named 'hmem' it was just:
> >
> > /sys/devices/system/hmem
> >
> > Which has no ACPI-isms at all.  I'm happy to move it under
> > /sys/devices/system/memory/hmat if that's helpful, but I think we still have
> > the issue that the data represented therein is still pulled right from the
> > HMAT, and I don't know how to abstract it into something more platform
> > agnostic until I know what data is provided by those other platforms.
> >
> > For example, the HMAT provides latency information and bandwidth information
> > for both reads and writes.  Will the devicetree/openfirmware/etc version have
> > this same info, or will it be just different enough that it won't translate
> > into whatever I choose to stick in sysfs?
> 
> For the initial implementation do we need to have a representation of
> all the performance data? Given that
> /sys/devices/system/node/nodeX/distance is the only generic
> performance attribute published by the kernel today it is already the
> case that applications that need to target specific memories need to
> go parse information that is not provided by the kernel by default.
> The question is can those specialized applications stay special and go
> parse the platform specific data sources, like raw HMAT, directly, or
> do we expect general purpose applications to make use of this data? I
> think a firmware-id to numa-node translation facility
> (/sys/devices/system/node/nodeX/fwid) is a simple start that we can
> build on with more information as specific use cases arise.

We don't represent all the performance data, we only represent the data for
local initiator/target pairs.  I do think that this is useful to have in sysfs
because it provides a way to easily answer the most commonly asked questions
(or at least what I'm guessing will be the most commmonly asked queststions),
i.e. "given a CPU, what are the speeds of the various types of memory attached
to it", and "given a chunk of memory, how fast is it and to which CPU is it
local"?  By providing this base level of information I'm hoping to prevent
most applications from having to parse the HMAT directly.

The question of whether or not to include this local performance information
was one of the main questions of the initial RFC patch series, and I did get
feedback (albiet off-list) that the local performance information was
valuable to at least some users.  I did intentionally structure my (now very
short) set so that the performance information was added as a separate patch,
so we can get to the place you're talking about where we only provide firmware
id <=> proximity domain mappings by just leaving off the last patch in the
series.

I'm personally still of the opinion though that this last patch does add
value.
