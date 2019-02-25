From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv6 07/10] acpi/hmat: Register processor domain to its
 memory
Date: Mon, 25 Feb 2019 09:51:18 -0700
Message-ID: <20190225165118.GK10237@localhost.localdomain>
References: <20190214171017.9362-1-keith.busch@intel.com>
 <20190214171017.9362-8-keith.busch@intel.com>
 <CAJZ5v0gjv0DZvYMTPBLnUmMtu8=g0zFd4x-cpP11Kzv+6XCwUw@mail.gmail.com>
 <20190222184831.GF10237@localhost.localdomain>
 <CAJZ5v0hfQ5HWT0kfaOxSbpJvdqotsMWVBCZ6wiL4Tnuy+O5O7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hfQ5HWT0kfaOxSbpJvdqotsMWVBCZ6wiL4Tnuy+O5O7Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 24, 2019 at 08:59:45PM +0100, Rafael J. Wysocki wrote:
> On Fri, Feb 22, 2019 at 7:48 PM Keith Busch <keith.busch@intel.com> wrote:
> > If I do it the other way around, that's going to make HMEM_REPORTING
> > complicated if a non-ACPI implementation wants to report HMEM
> > properties.
> 
> But the mitigations that Dave was talking about get in the way, don't they?
> 
> Say there is another Kconfig option,CACHE_MITIGATIONS, to enable them.
> Then you want ACPI_HMAT to be set when that it set and you also want
> ACPI_HMAT to be set when HMEM_REPORTING and ACPI_NUMA are both set.
> 
> OTOH, you may not want HMEM_REPORTING to be set when CACHE_MITIGATIONS
> is set, but that causes ACPI_HMAT to be set and which means that
> ACPI_HMAT alone will not be sufficient to determine the
> HMEM_REPORTING value.

I can't think of when we'd want to suppress reporting these attributes
to user space, but I can split HMAT enabling so it doesn't depend on
HMEM_REPORTING just in case there really is an in-kernel user that
definitely does not want the same attributes exported.

> Now, if you prompt for HMEM_REPORTING and make it depend on ACPI_NUMA,
> then ACPI_HMAT can be selected by that (regardless of the
> CACHE_MITIGATIONS value).
> 
> And if someone wants to use HMEM_REPORTING without ACPI_NUMA, it can
> be made depend on whatever new option is there for that non-ACPI
> mechanism.
> 
> There might be a problem if someone wanted to enable the alternative
> way of HMEM_REPORTING if ACPI_NUMA was set (in which case HMAT would
> have to be ignored even if it was present), but in that case there
> would need to be an explicit way to choose between HMAT and non-HMAT
> anyway.
> 
> In any case, I prefer providers to be selected by consumers and not
> the other way around, in case there are multiple consumers for one
> provider.

Well, the HMEM_REPORTING fundamentally has no dependency on any of these
things and I've put some effort into making this part provider agnostic.
I will change it if this concern is gating acceptance, but I don't
think it's as intuitive for generic interfaces to be the selector for
implementation specific providers.
