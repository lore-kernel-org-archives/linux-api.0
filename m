From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 01/22] docs: fpga: add a document for Intel FPGA driver overview
Date: Wed, 12 Jul 2017 09:51:32 -0500
Message-ID: <CANk1AXTDVVRG05H9kwZujFYGGS=AjQ2cdfrBm=bRNz9S7p6R6w@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-2-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-2-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> Add a document for Intel FPGA driver overview.
>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ----
> v2: added FME fpga-mgr/bridge/region platform driver to driver organization.
>     updated open discussion per current implementation.
>     fixed some typos.
> ---
>  Documentation/fpga/intel-fpga.txt | 256 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 256 insertions(+)
>  create mode 100644 Documentation/fpga/intel-fpga.txt
>
> diff --git a/Documentation/fpga/intel-fpga.txt b/Documentation/fpga/intel-fpga.txt
> new file mode 100644
> index 0000000..4a29470
> --- /dev/null
> +++ b/Documentation/fpga/intel-fpga.txt
> @@ -0,0 +1,256 @@
> +===============================================================================
> +                    Intel FPGA driver Overview
> +-------------------------------------------------------------------------------
> +                Enno Luebbers <enno.luebbers@intel.com>
> +                Xiao Guangrong <guangrong.xiao@linux.intel.com>
> +                Wu Hao <hao.wu@intel.com>
> +
> +The Intel FPGA driver provides interfaces for userspace applications to
> +configure, enumerate, open, and access FPGA accelerators on platforms equipped
> +with Intel(R) FPGA PCIe based solutions and enables system level management
> +functions such as FPGA reconfiguration, power management, and virtualization.
> +
> +HW Architecture
> +===============
> +From the OS's point of view, the FPGA hardware appears as a regular PCIe device.
> +The FPGA device memory is organized using a predefined data structure (Device
> +Feature List). Features supported by the particular FPGA device are exposed
> +through these data structures, as illustrated below:
> +
> +  +-------------------------------+  +-------------+
> +  |              PF               |  |     VF      |
> +  +-------------------------------+  +-------------+
> +      ^            ^         ^              ^
> +      |            |         |              |
> ++-----|------------|---------|--------------|-------+
> +|     |            |         |              |       |
> +|  +-----+     +-------+ +-------+      +-------+   |
> +|  | FME |     | Port0 | | Port1 |      | Port2 |   |
> +|  +-----+     +-------+ +-------+      +-------+   |
> +|                  ^         ^              ^       |
> +|                  |         |              |       |
> +|              +-------+ +------+       +-------+   |
> +|              |  AFU  | |  AFU |       |  AFU  |   |
> +|              +-------+ +------+       +-------+   |
> +|                                                   |
> +|                 FPGA PCIe Device                  |
> ++---------------------------------------------------+
> +
> +The driver supports PCIe SR-IOV to create virtual functions (VFs) which can be
> +used to assign individual accelerators to virtual machines.
> +
> +FME (FPGA Management Engine)
> +============================
> +The FPGA Management Engine performs power and thermal management, error
> +reporting, reconfiguration, performance reporting, and other infrastructure
> +functions. Each FPGA has one FME, which is always accessed through the physical
> +function (PF).
> +
> +User-space applications can acquire exclusive access to the FME using open(),
> +and release it using close().
> +
> +The following functions are exposed through ioctls:
> +
> +       Get driver API version (FPGA_GET_API_VERSION)
> +       Check for extensions (FPGA_CHECK_EXTENSION)
> +       Assign port to PF (FPGA_FME_PORT_ASSIGN)
> +       Release port from PF (FPGA_FME_PORT_RELEASE)
> +       Program bitstream (FPGA_FME_PORT_PR)
> +

I was hoping the API mailing list might have an opinion about this,
but I think adding ioctls to the kernel is discouraged.  Could these
be sysfs?

> +More functions are exposed through sysfs
> +(/sys/class/fpga/fpga.n/intel-fpga-fme.n/):
> +
> +       Read bitstream ID (bitstream_id)
> +       Read bitstream metadata (bitstream_metadata)
> +       Read number of ports (ports_num)
> +       Read socket ID (socket_id)
> +       Read performance counters (perf/)
> +       Power management (power_mgmt/)
> +       Thermal management (thermal_mgmt/)
> +       Error reporting (errors/)
> +
> +PORT
> +====
> +A port represents the interface between the static FPGA fabric (the "blue
> +bitstream") and a partially reconfigurable region containing an AFU (the "green
> +bitstream"). It controls the communication from SW to the accelerator and
> +exposes features such as reset and debug.
> +
> +A PCIe device may have several ports and each port can be released from PF by
> +FPGA_FME_PORT_RELEASE ioctl on FME, and exposed through a VF via PCIe sriov
> +sysfs interface.
> +
> +AFU
> +===
> +An AFU is attached to a port and exposes a 256k MMIO region to be used for
> +accelerator-specific control registers.
> +
> +User-space applications can acquire exclusive access to an AFU attached to a
> +port by using open() on the port device node, and release it using close().
> +
> +The following functions are exposed through ioctls:
> +
> +       Get driver API version (FPGA_GET_API_VERSION)
> +       Check for extensions (FPGA_CHECK_EXTENSION)
> +       Get port info (FPGA_PORT_GET_INFO)
> +       Get MMIO region info (FPGA_PORT_GET_REGION_INFO)
> +       Map DMA buffer (FPGA_PORT_DMA_MAP)
> +       Unmap DMA buffer (FPGA_PORT_DMA_UNMAP)
> +       Reset AFU (FPGA_PORT_RESET)
> +       Enable UMsg (FPGA_PORT_UMSG_ENABLE)
> +       Disable UMsg (FPGA_PORT_UMSG_DISABLE)
> +       Set UMsg mode (FPGA_PORT_UMSG_SET_MODE)
> +       Set UMsg base address (FPGA_PORT_UMSG_SET_BASE_ADDR)
> +
> +User-space applications can also mmap() accelerator MMIO regions.
> +
> +More functions are exposed through sysfs:
> +(/sys/class/fpga/fpga.n/intel-fpga-port.m/):
> +
> +       Read Accelerator GUID (afu_id)
> +       Error reporting (errors/)
> +
> +Partial Reconfiguration
> +=======================
> +As mentioned above, accelerators can be reconfigured through partial
> +reconfiguration of a green bitstream file (GBS). The green bitstream must have
> +been generated for the exact blue bitstream and targeted reconfigurable region
> +(port) of the FPGA; otherwise, the reconfiguration operation will fail and
> +possibly cause system instability. This compatibility can be checked by
> +comparing the interface ID noted in the GBS header against the interface ID
> +exposed by the FME through sysfs (see above). This check is usually done by
> +user-space before calling the reconfiguration IOCTL.
> +
> +FPGA virtualization
> +===================
> +To enable accessing an accelerator from applications running in a VM, the
> +respective AFU's port needs to be assigned to a VF using the following steps:
> +
> + a) The PF owns all AFU ports by default. Any port that needs to be reassigned
> + to a VF must be released from PF firstly through the FPGA_FME_PORT_RELEASE
> + ioctl on the FME device.
> +
> + b) Once N ports are released from PF, then user can use below command to
> + enable SRIOV and VFs. Each VF owns only one Port with AFU.
> +
> + echo N > $PCI_DEVICE_PATH/sriov_numvfs
> +
> + c) Pass through the VFs to VMs
> +
> + d) The AFU under VF is accessible from applications in VM (using the same
> + driver inside the VF).
> +
> +Note the an FME can't be assigned to a VF, thus PR and other management
> +functions are only available via the PF.
> +
> +
> +Driver organization
> +===================
> +
> +  +-------++------++------+             |
> +  | FME   || FME  || FME  |             |
> +  | FPGA  || FPGA || FPGA |             |
> +  |Manager||Bridge||Region|             |
> +  +-------++------++------+             |
> +  +-----------------------+  +--------+ |             +--------+
> +  |          FME          |  |  AFU   | |             |  AFU   |
> +  |         Module        |  | Module | |             | Module |
> +  +-----------------------+  +--------+ |             +--------+
> +        +-----------------------+       |      +-----------------------+
> +        | FPGA Container Device |       |      | FPGA Container Device |
> +        +-----------------------+       |      +-----------------------+
> +          +------------------+          |         +------------------+
> +          | FPGA PCIE Module |          | Virtual | FPGA PCIE Module |
> +          +------------------+   Host   | Machine +------------------+
> + -------------------------------------- | ------------------------------
> +           +---------------+            |          +---------------+
> +           | PCI PF Device |            |          | PCI VF Device |
> +           +---------------+            |          +---------------+
> +
> +The FPGA devices appear as regular PCIe devices; thus, the FPGA PCIe device
> +driver is always loaded first once a FPGA PCIE PF or VF device is detected. This
> +driver plays an infrastructural role in the driver architecture.  It:
> +
> +       a) creates FPGA container device as parent of the feature devices.
> +       b) walks through the Device Feature List, which is implemented in PCIE
> +          device BAR memory, to discover feature devices and their sub features
> +          and create platform device for them under the container device.
> +       c) supports SRIOV.
> +       d) introduces the feature device infrastructure, which abstracts
> +          operations for sub features and exposes common functions to feature
> +          device drivers.
> +
> +The FPGA Management Engine (FME) driver is a platform driver which is loaded
> +automatically after FME platform device creation from the PCIE driver. It
> +provides the key features for FPGA management, including:
> +
> +       a) Power and thermal management, error reporting, performance reporting
> +          and other infrastructure functions. Users can access these functions
> +          via sysfs interfaces exposed by FME driver.
> +       b) Partial Reconfiguration. The FME driver creates platform devices
> +          for FPGA manager, FPGA bridges and FPGA regions during PR sub
> +          feature initialization; Once it receives an FPGA_FME_PORT_PR ioctl
> +          from user, it invokes the common interface function from FPGA Region
> +          to complete the partial reconfiguration of the bitstream to the given
> +          port.
> +       c) Port management for virtualization. The FME driver introduces two
> +          ioctls, FPGA_FME_PORT_RELEASE (releases given port from PF) and
> +          FPGA_FME_PORT_ASSIGN (assigns the port back to PF). Once the port is
> +          released from the PF, it can be assigned to the VF through the SRIOV
> +          interfaces provided by PCIE driver. (Refer to "FPGA virtualization"
> +          for more details).
> +
> +Similar to the the FME driver, the FPGA Accelerated Function Unit (AFU) driver
> +is probed once the AFU platform device is created. The main function of this
> +module is to provide an interface for userspace applications to access the
> +individual accelerators, including basic reset control on port, AFU MMIO region
> +export, dma buffer mapping service, UMsg notification, and remote debug
> +functions (see above).
> +
> +
> +Device enumeration
> +==================
> +This section introduces how applications enumerate the fpga device from
> +the sysfs hierarchy under /sys/class/fpga.
> +
> +In the example below, two Intel(R) FPGA devices are installed in the host. Each
> +fpga device has one FME and two ports (AFUs).
> +
> +For each FPGA device, a device director is created under /sys/class/fpga/:
> +
> +       /sys/class/fpga/fpga.0
> +       /sys/class/fpga/fpga.1
> +
> +The Intel(R) FPGA device driver exposes "intel-fpga-dev" as the FPGA's name.
> +Application can retrieve name information via the sysfs interface:
> +
> +       /sys/class/fpga/fpga.0/name
> +
> +Each node has one FME and two ports (AFUs) as child devices:
> +
> +       /sys/class/fpga/fpga.0/intel-fpga-fme.0
> +       /sys/class/fpga/fpga.0/intel-fpga-port.0
> +       /sys/class/fpga/fpga.0/intel-fpga-port.1
> +
> +       /sys/class/fpga/fpga.1/intel-fpga-fme.1
> +       /sys/class/fpga/fpga.1/intel-fpga-port.2
> +       /sys/class/fpga/fpga.1/intel-fpga-port.3
> +
> +In general, the FME/AFU sysfs interfaces are named as follows:
> +
> +       /sys/class/fpga/<fpga.n>/<intel-fpga-fme.n>/
> +       /sys/class/fpga/<fpga.n>/<intel-fpga-port.m>/
> +
> +with 'n' consecutively numbering all FMEs and 'm' consecutively numbering all
> +ports.
> +
> +The device nodes used for ioctl() or mmap() can be referenced through:
> +
> +       /sys/class/fpga/<fpga.n>/<intel-fpga-port.n>/dev
> +       /sys/class/fpga/<fpga.n>/<intel-fpga-fme.n>/dev
> +
> +Open discussion
> +===============
> +FME driver exports one ioctl (FPGA_FME_PORT_PR) for partial reconfiguration to
> +user now. In the future, if unified user interfaces for reconfiguration are
> +added, FME driver should switch to them from ioctl interface.

Adding an ioctl that will go away in the future?

I think we are going to have to find a different interface for doing
partial reconfiguration.  There was a recent conversation on the
mailing list regarding adding a header to the raw bitstream and
probably using sysfs to present that to the kernel.  I'm working on
getting an RFC together for that.

Alan Tull
