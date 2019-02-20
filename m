From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCHv6 07/10] acpi/hmat: Register processor domain to its memory
Date: Wed, 20 Feb 2019 23:02:01 +0100
Message-ID: <CAJZ5v0gjv0DZvYMTPBLnUmMtu8=g0zFd4x-cpP11Kzv+6XCwUw@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-8-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214171017.9362-8-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 14, 2019 at 6:10 PM Keith Busch <keith.busch@intel.com> wrote:
>
> If the HMAT Subsystem Address Range provides a valid processor proximity
> domain for a memory domain, or a processor domain matches the performance
> access of the valid processor proximity domain, register the memory
> target with that initiator so this relationship will be visible under
> the node's sysfs directory.
>
> By registering only the best performing relationships, this provides the
> most useful information applications may want to know when considering
> which CPU they should run on for a given memory node, or which memory
> node they should allocate memory from for a given CPU.
>
> Since HMAT requires valid address ranges have an equivalent SRAT entry,
> verify each memory target satisfies this requirement.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/acpi/hmat/Kconfig |   1 +
>  drivers/acpi/hmat/hmat.c  | 396 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 396 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/hmat/Kconfig b/drivers/acpi/hmat/Kconfig
> index c9637e2e7514..08e972ead159 100644
> --- a/drivers/acpi/hmat/Kconfig
> +++ b/drivers/acpi/hmat/Kconfig
> @@ -2,6 +2,7 @@
>  config ACPI_HMAT
>         bool "ACPI Heterogeneous Memory Attribute Table Support"
>         depends on ACPI_NUMA
> +       select HMEM_REPORTING

If you want to do this here, I'm not sure that defining HMEM_REPORTING
as a user-selectable option is a good idea.  In particular, I don't
really think that setting ACPI_HMAT without it makes a lot of sense.
Apart from this, the patch looks reasonable to me.
