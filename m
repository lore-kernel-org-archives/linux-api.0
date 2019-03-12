From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCHv7 10/10] doc/mm: New documentation for memory
 performance
Date: Tue, 12 Mar 2019 13:37:56 +0000
Message-ID: <20190312133756.000066c7@huawei.com>
References: <20190227225038.20438-1-keith.busch@intel.com>
        <20190227225038.20438-11-keith.busch@intel.com>
        <20190311113843.00006b47@huawei.com>
        <20190311201632.GG10411@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311201632.GG10411@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <kbusch@kernel.org>
Cc: "Busch, Keith" <keith.busch@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, 11 Mar 2019 14:16:33 -0600
Keith Busch <kbusch@kernel.org> wrote:

> On Mon, Mar 11, 2019 at 04:38:43AM -0700, Jonathan Cameron wrote:
> > On Wed, 27 Feb 2019 15:50:38 -0700
> > Keith Busch <keith.busch@intel.com> wrote:
> >   
> > > Platforms may provide system memory where some physical address ranges
> > > perform differently than others, or is side cached by the system.  
> > The magic 'side cached' term still here in the patch description, ideally
> > wants cleaning up.
> >   
> > > 
> > > Add documentation describing a high level overview of such systems and the
> > > perforamnce and caching attributes the kernel provides for applications  
> > performance
> >   
> > > wishing to query this information.
> > > 
> > > Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> > > Signed-off-by: Keith Busch <keith.busch@intel.com>  
> > 
> > A few comments inline. Mostly the weird corner cases that I miss understood
> > in one of the earlier versions of the code.
> > 
> > Whilst I think perhaps that one section could be tweaked a tiny bit I'm basically
> > happy with this if you don't want to.
> > 
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >   
> > > ---
> > >  Documentation/admin-guide/mm/numaperf.rst | 164 ++++++++++++++++++++++++++++++
> > >  1 file changed, 164 insertions(+)
> > >  create mode 100644 Documentation/admin-guide/mm/numaperf.rst
> > > 
> > > diff --git a/Documentation/admin-guide/mm/numaperf.rst b/Documentation/admin-guide/mm/numaperf.rst
> > > new file mode 100644
> > > index 000000000000..d32756b9be48
> > > --- /dev/null
> > > +++ b/Documentation/admin-guide/mm/numaperf.rst
> > > @@ -0,0 +1,164 @@
> > > +.. _numaperf:
> > > +
> > > +=============
> > > +NUMA Locality
> > > +=============
> > > +
> > > +Some platforms may have multiple types of memory attached to a compute
> > > +node. These disparate memory ranges may share some characteristics, such
> > > +as CPU cache coherence, but may have different performance. For example,
> > > +different media types and buses affect bandwidth and latency.
> > > +
> > > +A system supports such heterogeneous memory by grouping each memory type
> > > +under different domains, or "nodes", based on locality and performance
> > > +characteristics.  Some memory may share the same node as a CPU, and others
> > > +are provided as memory only nodes. While memory only nodes do not provide
> > > +CPUs, they may still be local to one or more compute nodes relative to
> > > +other nodes. The following diagram shows one such example of two compute
> > > +nodes with local memory and a memory only node for each of compute node:
> > > +
> > > + +------------------+     +------------------+
> > > + | Compute Node 0   +-----+ Compute Node 1   |
> > > + | Local Node0 Mem  |     | Local Node1 Mem  |
> > > + +--------+---------+     +--------+---------+
> > > +          |                        |
> > > + +--------+---------+     +--------+---------+
> > > + | Slower Node2 Mem |     | Slower Node3 Mem |
> > > + +------------------+     +--------+---------+
> > > +
> > > +A "memory initiator" is a node containing one or more devices such as
> > > +CPUs or separate memory I/O devices that can initiate memory requests.
> > > +A "memory target" is a node containing one or more physical address
> > > +ranges accessible from one or more memory initiators.
> > > +
> > > +When multiple memory initiators exist, they may not all have the same
> > > +performance when accessing a given memory target. Each initiator-target
> > > +pair may be organized into different ranked access classes to represent
> > > +this relationship.   
> > 
> > This concept is a bit vague at the moment. Largely because only access0
> > is actually defined.  We should definitely keep a close eye on any others
> > that are defined in future to make sure this text is still valid.
> > 
> > I can certainly see it being used for different ideas of 'best' rather
> > than simply best and second best etc.  
> 
> I tried to make the interface flexible to future extension, but I'm
> still not sure how potential users would want to see something like
> all pair-wise attributes, so I had some trouble trying to capture that
> in words.

Agreed, it is definitely non obvious.  We might end up with something
totally different like Jerome is proposing anyway.  Let's address
this when it happens!

>  
> > > The highest performing initiator to a given target
> > > +is considered to be one of that target's local initiators, and given
> > > +the highest access class, 0. Any given target may have one or more
> > > +local initiators, and any given initiator may have multiple local
> > > +memory targets.
> > > +
> > > +To aid applications matching memory targets with their initiators, the
> > > +kernel provides symlinks to each other. The following example lists the
> > > +relationship for the access class "0" memory initiators and targets, which is
> > > +the of nodes with the highest performing access relationship::
> > > +
> > > +	# symlinks -v /sys/devices/system/node/nodeX/access0/targets/
> > > +	relative: /sys/devices/system/node/nodeX/access0/targets/nodeY -> ../../nodeY  
> > 
> > So this one perhaps needs a bit more description - I would put it after initiators
> > which precisely fits the description you have here now.
> > 
> > "targets contains those nodes for which this initiator is the best possible initiator."
> > 
> > which is subtly different form
> > 
> > "targets contains those nodes to which this node has the highest
> > performing access characteristics."
> > 
> > For example in my test case:
> > * 4 nodes with local memory and cpu, 1 node remote and equal distant from all of the
> >   initiators,
> > 
> > targets for the compute nodes contains both themselves and the remote node, to which
> > the characteristics are of course worse. As you point out before, we need to look
> > in 
> > node0/access0/targets/node0/access0/initiators 
> > node0/access0/targets/node4/access0/initiators 
> > to get the relevant characteristics and work out that node0 is 'nearer' itself
> > (obviously this is a bit of a silly case, but we could have no memory node0 and
> > be talking about node4 and node5.
> > 
> > I am happy with the actual interface, this is just a question about whether we can tweak
> > this text to be slightly clearer.  
> 
> Sure, I mention this in patch 4's commit message. Probably worth
> repeating here:
> 
>     A memory initiator may have multiple memory targets in the same access
>     class. The target memory's initiators in a given class indicate the
>     nodes access characteristics share the same performance relative to other
>     linked initiator nodes. Each target within an initiator's access class,
>     though, do not necessarily perform the same as each other.
That sounds good to me.
