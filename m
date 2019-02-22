From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCHv6 07/10] acpi/hmat: Register processor domain to its memory
Date: Fri, 22 Feb 2019 11:21:37 -0800
Message-ID: <CAPcyv4jpP0CP-QxWDc_E1QwL736PLwh8ZPrnKJzVnYrAk++93g@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-8-keith.busch@intel.com>
 <CAJZ5v0gjv0DZvYMTPBLnUmMtu8=g0zFd4x-cpP11Kzv+6XCwUw@mail.gmail.com> <20190222184831.GF10237@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222184831.GF10237@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 22, 2019 at 10:48 AM Keith Busch <keith.busch@intel.com> wrote:
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
>
> If I do it the other way around, that's going to make HMEM_REPORTING
> complicated if a non-ACPI implementation wants to report HMEM
> properties.

Agree. If a platform supports these HMEM properties then they should
be reported. ACPI_HMAT is that opt-in for ACPI based platforms, and
other archs can do something similar. It's not clear that one would
ever want to opt-in to HMAT support and opt-out of reporting any of it
to userspace.
