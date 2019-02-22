From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv6 06/10] node: Add memory-side caching attributes
Date: Fri, 22 Feb 2019 11:09:45 -0700
Message-ID: <20190222180944.GD10237@localhost.localdomain>
References: <20190214171017.9362-1-keith.busch@intel.com>
 <20190214171017.9362-7-keith.busch@intel.com>
 <29336223-b86e-3aca-ee5a-276d1c404b96@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <29336223-b86e-3aca-ee5a-276d1c404b96@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 22, 2019 at 11:12:38AM +0100, Brice Goglin wrote:
> Le 14/02/2019 à 18:10, Keith Busch a écrit :
> > +What:		/sys/devices/system/node/nodeX/memory_side_cache/indexY/size
> > +Date:		December 2018
> > +Contact:	Keith Busch <keith.busch@intel.com>
> > +Description:
> > +		The size of this memory side cache in bytes.
> 
> 
> Hello Keith,
> 
> CPU-side cache size is reported in kilobytes:
> 
> $ cat
> /sys/devices/system/cpu/cpu0/cache/index*/size                                             
> 
> 32K
> 32K
> 256K
> 4096K
> 
> Can you do the same of memory-side caches instead of reporting bytes?

Ok, will do.
