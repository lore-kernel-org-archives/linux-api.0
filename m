From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCHv6 09/10] acpi/hmat: Register memory side cache attributes
Date: Wed, 20 Feb 2019 23:05:51 +0100
Message-ID: <CAJZ5v0i6ZD0azWmLWkuzt4Sms+L8+wvKYao8-JCJp0zOgjdx5A@mail.gmail.com>
References: <20190214171017.9362-1-keith.busch@intel.com> <20190214171017.9362-10-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214171017.9362-10-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 14, 2019 at 6:10 PM Keith Busch <keith.busch@intel.com> wrote:
>
> Register memory side cache attributes with the memory's node if HMAT
> provides the side cache iniformation table.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/hmat/hmat.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
> index 6833c4897ff4..e2a15f53fe45 100644
> --- a/drivers/acpi/hmat/hmat.c
> +++ b/drivers/acpi/hmat/hmat.c
> @@ -314,6 +314,7 @@ static __init int hmat_parse_cache(union acpi_subtable_headers *header,
>                                    const unsigned long end)
>  {
>         struct acpi_hmat_cache *cache = (void *)header;
> +       struct node_cache_attrs cache_attrs;
>         u32 attrs;
>
>         if (cache->header.length < sizeof(*cache)) {
> @@ -327,6 +328,37 @@ static __init int hmat_parse_cache(union acpi_subtable_headers *header,
>                 cache->memory_PD, cache->cache_size, attrs,
>                 cache->number_of_SMBIOShandles);
>
> +       cache_attrs.size = cache->cache_size;
> +       cache_attrs.level = (attrs & ACPI_HMAT_CACHE_LEVEL) >> 4;
> +       cache_attrs.line_size = (attrs & ACPI_HMAT_CACHE_LINE_SIZE) >> 16;
> +
> +       switch ((attrs & ACPI_HMAT_CACHE_ASSOCIATIVITY) >> 8) {
> +       case ACPI_HMAT_CA_DIRECT_MAPPED:
> +               cache_attrs.associativity = NODE_CACHE_DIRECT_MAP;
> +               break;
> +       case ACPI_HMAT_CA_COMPLEX_CACHE_INDEXING:
> +               cache_attrs.associativity = NODE_CACHE_INDEXED;
> +               break;
> +       case ACPI_HMAT_CA_NONE:
> +       default:
> +               cache_attrs.associativity = NODE_CACHE_OTHER;
> +               break;
> +       }
> +
> +       switch ((attrs & ACPI_HMAT_WRITE_POLICY) >> 12) {
> +       case ACPI_HMAT_CP_WB:
> +               cache_attrs.write_policy = NODE_CACHE_WRITE_BACK;
> +               break;
> +       case ACPI_HMAT_CP_WT:
> +               cache_attrs.write_policy = NODE_CACHE_WRITE_THROUGH;
> +               break;
> +       case ACPI_HMAT_CP_NONE:
> +       default:
> +               cache_attrs.write_policy = NODE_CACHE_WRITE_OTHER;
> +               break;
> +       }
> +
> +       node_add_cache(pxm_to_node(cache->memory_PD), &cache_attrs);
>         return 0;
>  }
>
> --
> 2.14.4
>
