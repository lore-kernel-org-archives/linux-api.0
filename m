From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv6 06/10] node: Add memory-side caching attributes
Date: Fri, 22 Feb 2019 11:13:17 -0700
Message-ID: <20190222181316.GE10237@localhost.localdomain>
References: <20190214171017.9362-1-keith.busch@intel.com>
 <20190214171017.9362-7-keith.busch@intel.com>
 <16221be9-2f60-3a39-fd6c-5299cd94dc02@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16221be9-2f60-3a39-fd6c-5299cd94dc02@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 22, 2019 at 11:22:12AM +0100, Brice Goglin wrote:
> Le 14/02/2019 à 18:10, Keith Busch a écrit :
> > +What:		/sys/devices/system/node/nodeX/memory_side_cache/indexY/associativity
> > +Date:		December 2018
> > +Contact:	Keith Busch <keith.busch@intel.com>
> > +Description:
> > +		The caches associativity: 0 for direct mapped, non-zero if
> > +		indexed.
> 
> 
> Should we rename "associativity" into "indexing" or something else?
>
> When I see "associativity" that contains 0, I tend to interpret this as
> the associativity value itself, which would mean fully-associative here
> (as in CPU-side cache "ways_of_associativity" attribute), while actually
> 0 means direct-mapped (ie 1-associative) with yout semantics.
> 
> Brice

Yes, that's a good suggestion.
