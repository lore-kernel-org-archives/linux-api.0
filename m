From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCHv6 06/10] node: Add memory-side caching attributes
Date: Fri, 22 Feb 2019 10:20:08 -0800
Message-ID: <CAPcyv4itkDiPYAqkT4e0i8nQXKAEZCUQsFk8jACEJ__tZwUh3Q@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-7-keith.busch@intel.com>
 <29336223-b86e-3aca-ee5a-276d1c404b96@inria.fr> <20190222180944.GD10237@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222180944.GD10237@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 22, 2019 at 10:09 AM Keith Busch <keith.busch@intel.com> wrote:
>
> On Fri, Feb 22, 2019 at 11:12:38AM +0100, Brice Goglin wrote:
> > Le 14/02/2019 =C3=A0 18:10, Keith Busch a =C3=A9crit :
> > > +What:              /sys/devices/system/node/nodeX/memory_side_cache/=
indexY/size
> > > +Date:              December 2018
> > > +Contact:   Keith Busch <keith.busch@intel.com>
> > > +Description:
> > > +           The size of this memory side cache in bytes.
> >
> >
> > Hello Keith,
> >
> > CPU-side cache size is reported in kilobytes:
> >
> > $ cat
> > /sys/devices/system/cpu/cpu0/cache/index*/size
> >
> > 32K
> > 32K
> > 256K
> > 4096K
> >
> > Can you do the same of memory-side caches instead of reporting bytes?
>
> Ok, will do.

Ugh, please no. Don't optimize sysfs for human consumption. That 'K'
now needs to be parsed.
