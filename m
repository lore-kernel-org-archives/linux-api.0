From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCHv8 07/10] acpi/hmat: Register processor domain to its memory
Date: Fri, 29 Mar 2019 14:15:03 -0700
Message-ID: <CAPcyv4j5bLiUtmjdnjt7KNOtNm4sRHWp=5T3m1bWD=U1zBXeqQ@mail.gmail.com>
References: <20190311205606.11228-1-keith.busch@intel.com> <20190311205606.11228-8-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311205606.11228-8-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Brice Goglin <Brice.Goglin@inria.fr>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 1:55 PM Keith Busch <keith.busch@intel.com> wrote:
>
> If the HMAT Subsystem Address Range provides a valid processor proximity
> domain for a memory domain, or a processor domain matches the performance
> access of the valid processor proximity domain, register the memory
> target with that initiator so this relationship will be visible under
> the node's sysfs directory.
>
> Since HMAT requires valid address ranges have an equivalent SRAT entry,
> verify each memory target satisfies this requirement.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/acpi/hmat/Kconfig |   3 +-
>  drivers/acpi/hmat/hmat.c  | 392 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 393 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/hmat/Kconfig b/drivers/acpi/hmat/Kconfig
> index 2f7111b7af62..13cddd612a52 100644
> --- a/drivers/acpi/hmat/Kconfig
> +++ b/drivers/acpi/hmat/Kconfig
> @@ -4,4 +4,5 @@ config ACPI_HMAT
>         depends on ACPI_NUMA
>         help
>          If set, this option has the kernel parse and report the
> -        platform's ACPI HMAT (Heterogeneous Memory Attributes Table).
> +        platform's ACPI HMAT (Heterogeneous Memory Attributes Table),
> +        and register memory initiators with their targets.
> diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
> index 4758beb3b2c1..01a6eddac6f7 100644
> --- a/drivers/acpi/hmat/hmat.c
> +++ b/drivers/acpi/hmat/hmat.c
> @@ -13,11 +13,105 @@
>  #include <linux/device.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
> +#include <linux/list_sort.h>
>  #include <linux/node.h>
>  #include <linux/sysfs.h>
>
>  static __initdata u8 hmat_revision;
>
> +static __initdata LIST_HEAD(targets);
> +static __initdata LIST_HEAD(initiators);
> +static __initdata LIST_HEAD(localities);
> +
> +/*
> + * The defined enum order is used to prioritize attributes to break ties when
> + * selecting the best performing node.
> + */
> +enum locality_types {
> +       WRITE_LATENCY,
> +       READ_LATENCY,
> +       WRITE_BANDWIDTH,
> +       READ_BANDWIDTH,
> +};
> +
> +static struct memory_locality *localities_types[4];
> +
> +struct memory_target {
> +       struct list_head node;
> +       unsigned int memory_pxm;
> +       unsigned int processor_pxm;
> +       struct node_hmem_attrs hmem_attrs;
> +};
> +
> +struct memory_initiator {
> +       struct list_head node;
> +       unsigned int processor_pxm;
> +};
> +
> +struct memory_locality {
> +       struct list_head node;
> +       struct acpi_hmat_locality *hmat_loc;
> +};
> +
> +static __init struct memory_initiator *find_mem_initiator(unsigned int cpu_pxm)
> +{
> +       struct memory_initiator *initiator;
> +
> +       list_for_each_entry(initiator, &initiators, node)
> +               if (initiator->processor_pxm == cpu_pxm)
> +                       return initiator;
> +       return NULL;
> +}
> +
> +static __init struct memory_target *find_mem_target(unsigned int mem_pxm)
> +{
> +       struct memory_target *target;
> +
> +       list_for_each_entry(target, &targets, node)
> +               if (target->memory_pxm == mem_pxm)
> +                       return target;
> +       return NULL;

The above implementation assumes that every SRAT entry has a unique
@mem_pxm. I don't think that's valid if the memory map is sparse,
right?
