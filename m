From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCHv6 07/10] acpi/hmat: Register processor domain to its memory
Date: Sun, 24 Feb 2019 20:59:45 +0100
Message-ID: <CAJZ5v0hfQ5HWT0kfaOxSbpJvdqotsMWVBCZ6wiL4Tnuy+O5O7Q@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-8-keith.busch@intel.com>
 <CAJZ5v0gjv0DZvYMTPBLnUmMtu8=g0zFd4x-cpP11Kzv+6XCwUw@mail.gmail.com> <20190222184831.GF10237@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222184831.GF10237@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 22, 2019 at 7:48 PM Keith Busch <keith.busch@intel.com> wrote:
>
> On Wed, Feb 20, 2019 at 11:02:01PM +0100, Rafael J. Wysocki wrote:
> > On Thu, Feb 14, 2019 at 6:10 PM Keith Busch <keith.busch@intel.com> wrote:
> > >  config ACPI_HMAT
> > >         bool "ACPI Heterogeneous Memory Attribute Table Support"
> > >         depends on ACPI_NUMA
> > > +       select HMEM_REPORTING
> >
> > If you want to do this here, I'm not sure that defining HMEM_REPORTING
> > as a user-selectable option is a good idea.  In particular, I don't
> > really think that setting ACPI_HMAT without it makes a lot of sense.
> > Apart from this, the patch looks reasonable to me.
>
> I'm trying to implement based on the feedback, but I'm a little confused.
>
> As I have it at the moment, HMEM_REPORTING is not user-prompted, so
> another option needs to turn it on. I have ACPI_HMAT do that here.
>
> So when you say it's a bad idea to make HMEM_REPORTING user selectable,
> isn't it already not user selectable?

I thought that HMEM_REPORTING was user-prompted initially, by bad if it wasn't.

> If I do it the other way around, that's going to make HMEM_REPORTING
> complicated if a non-ACPI implementation wants to report HMEM
> properties.

But the mitigations that Dave was talking about get in the way, don't they?

Say there is another Kconfig option,CACHE_MITIGATIONS, to enable them.
Then you want ACPI_HMAT to be set when that it set and you also want
ACPI_HMAT to be set when HMEM_REPORTING and ACPI_NUMA are both set.

OTOH, you may not want HMEM_REPORTING to be set when CACHE_MITIGATIONS
is set, but that causes ACPI_HMAT to be set and which means that
ACPI_HMAT alone will not be sufficient to determine the
HMEM_REPORTING value.

Now, if you prompt for HMEM_REPORTING and make it depend on ACPI_NUMA,
then ACPI_HMAT can be selected by that (regardless of the
CACHE_MITIGATIONS value).

And if someone wants to use HMEM_REPORTING without ACPI_NUMA, it can
be made depend on whatever new option is there for that non-ACPI
mechanism.

There might be a problem if someone wanted to enable the alternative
way of HMEM_REPORTING if ACPI_NUMA was set (in which case HMAT would
have to be ignored even if it was present), but in that case there
would need to be an explicit way to choose between HMAT and non-HMAT
anyway.

In any case, I prefer providers to be selected by consumers and not
the other way around, in case there are multiple consumers for one
provider.
