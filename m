From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCHv6 07/10] acpi/hmat: Register processor domain to its memory
Date: Wed, 20 Feb 2019 23:21:45 +0100
Message-ID: <CAJZ5v0izS-MBcC3ZsRKK59zWcJOMQ672sRuv_GCVrsYR36Wa8w@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-8-keith.busch@intel.com>
 <CAJZ5v0gjv0DZvYMTPBLnUmMtu8=g0zFd4x-cpP11Kzv+6XCwUw@mail.gmail.com> <9ab5d6ba-4cb6-a6f1-894d-d79b77c8bc21@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9ab5d6ba-4cb6-a6f1-894d-d79b77c8bc21@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Keith Busch <keith.busch@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 20, 2019 at 11:11 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/20/19 2:02 PM, Rafael J. Wysocki wrote:
> >> diff --git a/drivers/acpi/hmat/Kconfig b/drivers/acpi/hmat/Kconfig
> >> index c9637e2e7514..08e972ead159 100644
> >> --- a/drivers/acpi/hmat/Kconfig
> >> +++ b/drivers/acpi/hmat/Kconfig
> >> @@ -2,6 +2,7 @@
> >>  config ACPI_HMAT
> >>         bool "ACPI Heterogeneous Memory Attribute Table Support"
> >>         depends on ACPI_NUMA
> >> +       select HMEM_REPORTING
> > If you want to do this here, I'm not sure that defining HMEM_REPORTING
> > as a user-selectable option is a good idea.  In particular, I don't
> > really think that setting ACPI_HMAT without it makes a lot of sense.
> > Apart from this, the patch looks reasonable to me.
>
> I guess the question is whether we would want to allow folks to consume
> the HMAT inside the kernel while not reporting it out via
> HMEM_REPORTING.  We have some in-kernel users of the HMAT lined up like
> mitigations for memory-side caches.
>
> It's certainly possible that folks would want to consume those
> mitigations without anything in sysfs.  They might not even want or need
> NUMA support itself, for instance.
>
> So, what should we do?
>
> config HMEM_REPORTING
>         bool # no user-visible prompt
>         default y if ACPI_HMAT
>
> So folks can override in their .config, but they don't see a prompt?

Maybe it would be better to make HMEM_REPORTING do "select ACPI_HMAT if ACPI".

The mitigations could then do that too if they depend on HMAT and
ACPI_HMAT need not be user-visible at all.
