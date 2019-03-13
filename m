From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCHv8 05/10] node: Add heterogenous memory access attributes
Date: Thu, 14 Mar 2019 00:15:56 +0100
Message-ID: <CAJZ5v0hun3u8wswpM93GPW6M+VZ4u9Txz5C1JuG1D7h3uP4_2w@mail.gmail.com>
References: <20190311205606.11228-1-keith.busch@intel.com> <20190311205606.11228-6-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311205606.11228-6-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Brice Goglin <Brice.Goglin@inria.fr>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 9:55 PM Keith Busch <keith.busch@intel.com> wrote:
>
> Heterogeneous memory systems provide memory nodes with different latency
> and bandwidth performance attributes. Provide a new kernel interface
> for subsystems to register the attributes under the memory target
> node's initiator access class. If the system provides this information,
> applications may query these attributes when deciding which node to
> request memory.
>
> The following example shows the new sysfs hierarchy for a node exporting
> performance attributes:
>
>   # tree -P "read*|write*"/sys/devices/system/node/nodeY/accessZ/initiators/
>   /sys/devices/system/node/nodeY/accessZ/initiators/
>   |-- read_bandwidth
>   |-- read_latency
>   |-- write_bandwidth
>   `-- write_latency
>
> The bandwidth is exported as MB/s and latency is reported in
> nanoseconds. The values are taken from the platform as reported by the
> manufacturer.
>
> Memory accesses from an initiator node that is not one of the memory's
> access "Z" initiator nodes linked in the same directory may observe
> different performance than reported here. When a subsystem makes use
> of this interface, initiators of a different access number may not have
> the same performance relative to initiators in other access numbers, or
> omitted from the any access class' initiators.
>
> Descriptions for memory access initiator performance access attributes
> are added to sysfs stable documentation.
>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  Documentation/ABI/stable/sysfs-devices-node | 28 ++++++++++++++
>  drivers/base/Kconfig                        |  8 ++++
>  drivers/base/node.c                         | 59 +++++++++++++++++++++++++++++
>  include/linux/node.h                        | 26 +++++++++++++
>  4 files changed, 121 insertions(+)
>
> diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
> index 433bcc04e542..735a40a3f9b2 100644
> --- a/Documentation/ABI/stable/sysfs-devices-node
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -114,3 +114,31 @@ Contact:   Keith Busch <keith.busch@intel.com>
>  Description:
>                 The directory containing symlinks to memory targets that
>                 this initiator node has class "Y" access.
> +
> +What:          /sys/devices/system/node/nodeX/accessY/initiators/read_bandwidth
> +Date:          December 2018
> +Contact:       Keith Busch <keith.busch@intel.com>
> +Description:
> +               This node's read bandwidth in MB/s when accessed from
> +               nodes found in this access class's linked initiators.
> +
> +What:          /sys/devices/system/node/nodeX/accessY/initiators/read_latency
> +Date:          December 2018
> +Contact:       Keith Busch <keith.busch@intel.com>
> +Description:
> +               This node's read latency in nanoseconds when accessed
> +               from nodes found in this access class's linked initiators.
> +
> +What:          /sys/devices/system/node/nodeX/accessY/initiators/write_bandwidth
> +Date:          December 2018
> +Contact:       Keith Busch <keith.busch@intel.com>
> +Description:
> +               This node's write bandwidth in MB/s when accessed from
> +               found in this access class's linked initiators.
> +
> +What:          /sys/devices/system/node/nodeX/accessY/initiators/write_latency
> +Date:          December 2018
> +Contact:       Keith Busch <keith.busch@intel.com>
> +Description:
> +               This node's write latency in nanoseconds when access
> +               from nodes found in this class's linked initiators.
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 059700ea3521..a7438a58c250 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -149,6 +149,14 @@ config DEBUG_TEST_DRIVER_REMOVE
>           unusable. You should say N here unless you are explicitly looking to
>           test this functionality.
>
> +config HMEM_REPORTING
> +       bool
> +       default n
> +       depends on NUMA
> +       help
> +         Enable reporting for heterogenous memory access attributes under
> +         their non-uniform memory nodes.
> +
>  source "drivers/base/test/Kconfig"
>
>  config SYS_HYPERVISOR
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 6f4097680580..2de546a040a5 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -71,6 +71,9 @@ struct node_access_nodes {
>         struct device           dev;
>         struct list_head        list_node;
>         unsigned                access;
> +#ifdef CONFIG_HMEM_REPORTING
> +       struct node_hmem_attrs  hmem_attrs;
> +#endif
>  };
>  #define to_access_nodes(dev) container_of(dev, struct node_access_nodes, dev)
>
> @@ -148,6 +151,62 @@ static struct node_access_nodes *node_init_node_access(struct node *node,
>         return NULL;
>  }
>
> +#ifdef CONFIG_HMEM_REPORTING
> +#define ACCESS_ATTR(name)                                                 \
> +static ssize_t name##_show(struct device *dev,                            \
> +                          struct device_attribute *attr,                  \
> +                          char *buf)                                      \
> +{                                                                         \
> +       return sprintf(buf, "%u\n", to_access_nodes(dev)->hmem_attrs.name); \
> +}                                                                         \
> +static DEVICE_ATTR_RO(name);
> +
> +ACCESS_ATTR(read_bandwidth)
> +ACCESS_ATTR(read_latency)
> +ACCESS_ATTR(write_bandwidth)
> +ACCESS_ATTR(write_latency)
> +
> +static struct attribute *access_attrs[] = {
> +       &dev_attr_read_bandwidth.attr,
> +       &dev_attr_read_latency.attr,
> +       &dev_attr_write_bandwidth.attr,
> +       &dev_attr_write_latency.attr,
> +       NULL,
> +};
> +
> +/**
> + * node_set_perf_attrs - Set the performance values for given access class
> + * @nid: Node identifier to be set
> + * @hmem_attrs: Heterogeneous memory performance attributes
> + * @access: The access class the for the given attributes
> + */
> +void node_set_perf_attrs(unsigned int nid, struct node_hmem_attrs *hmem_attrs,
> +                        unsigned access)
> +{
> +       struct node_access_nodes *c;
> +       struct node *node;
> +       int i;
> +
> +       if (WARN_ON_ONCE(!node_online(nid)))
> +               return;
> +
> +       node = node_devices[nid];
> +       c = node_init_node_access(node, access);
> +       if (!c)
> +               return;
> +
> +       c->hmem_attrs = *hmem_attrs;
> +       for (i = 0; access_attrs[i] != NULL; i++) {
> +               if (sysfs_add_file_to_group(&c->dev.kobj, access_attrs[i],
> +                                           "initiators")) {
> +                       pr_info("failed to add performance attribute to node %d\n",
> +                               nid);
> +                       break;
> +               }
> +       }
> +}
> +#endif
> +
>  #define K(x) ((x) << (PAGE_SHIFT - 10))
>  static ssize_t node_read_meminfo(struct device *dev,
>                         struct device_attribute *attr, char *buf)
> diff --git a/include/linux/node.h b/include/linux/node.h
> index bb288817ed33..4139d728f8b3 100644
> --- a/include/linux/node.h
> +++ b/include/linux/node.h
> @@ -20,6 +20,32 @@
>  #include <linux/list.h>
>  #include <linux/workqueue.h>
>
> +/**
> + * struct node_hmem_attrs - heterogeneous memory performance attributes
> + *
> + * @read_bandwidth:    Read bandwidth in MB/s
> + * @write_bandwidth:   Write bandwidth in MB/s
> + * @read_latency:      Read latency in nanoseconds
> + * @write_latency:     Write latency in nanoseconds
> + */
> +struct node_hmem_attrs {
> +       unsigned int read_bandwidth;
> +       unsigned int write_bandwidth;
> +       unsigned int read_latency;
> +       unsigned int write_latency;
> +};
> +
> +#ifdef CONFIG_HMEM_REPORTING
> +void node_set_perf_attrs(unsigned int nid, struct node_hmem_attrs *hmem_attrs,
> +                        unsigned access);
> +#else
> +static inline void node_set_perf_attrs(unsigned int nid,
> +                                      struct node_hmem_attrs *hmem_attrs,
> +                                      unsigned access)
> +{
> +}
> +#endif
> +
>  struct node {
>         struct device   dev;
>         struct list_head access_list;
> --
> 2.14.4
>
