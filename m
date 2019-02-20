From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCHv6 08/10] acpi/hmat: Register performance attributes
Date: Wed, 20 Feb 2019 23:04:19 +0100
Message-ID: <CAJZ5v0giQ+Xbjem-FLsYGestzBq9BpmpaQk8Zsa7-ry+Z=1gWw@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-9-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214171017.9362-9-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 14, 2019 at 6:10 PM Keith Busch <keith.busch@intel.com> wrote:
>
> Save the best performance access attributes and register these with the
> memory's node if HMAT provides the locality table. While HMAT does make
> it possible to know performance for all possible initiator-target
> pairings, we export only the local pairings at this time.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/hmat/hmat.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
> index b29f7160c7bb..6833c4897ff4 100644
> --- a/drivers/acpi/hmat/hmat.c
> +++ b/drivers/acpi/hmat/hmat.c
> @@ -549,12 +549,27 @@ static __init void hmat_register_target_initiators(struct memory_target *target)
>         }
>  }
>
> +static __init void hmat_register_target_perf(struct memory_target *target)
> +{
> +       unsigned mem_nid = pxm_to_node(target->memory_pxm);
> +
> +       if (!target->hmem_attrs.read_bandwidth &&
> +           !target->hmem_attrs.read_latency &&
> +           !target->hmem_attrs.write_bandwidth &&
> +           !target->hmem_attrs.write_latency)
> +               return;
> +
> +       node_set_perf_attrs(mem_nid, &target->hmem_attrs, 0);
> +}
> +
>  static __init void hmat_register_targets(void)
>  {
>         struct memory_target *target;
>
> -       list_for_each_entry(target, &targets, node)
> +       list_for_each_entry(target, &targets, node) {
>                 hmat_register_target_initiators(target);
> +               hmat_register_target_perf(target);
> +       }
>  }
>
>  static __init void hmat_free_structures(void)
> --
> 2.14.4
>
