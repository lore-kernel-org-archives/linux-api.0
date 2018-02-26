From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 01/24] docs: fpga: add a document for FPGA Device
 Feature List (DFL) Framework Overview
Date: Mon, 26 Feb 2018 16:48:55 -0600
Message-ID: <CANk1AXTOMWMV+3CEO7uzcfV6C6F=sNH=nHbxWGqgAb6VeqtSfA@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com> <1518513893-4719-2-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-2-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

The new overview and diagrams are a great improvement, thanks!

Some comments below.

> Add a document for FPGA Device Feature List (DFL) Framework Overview.
>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
> v2: added FME fpga-mgr/bridge/region platform driver to driver organization.
>     updated open discussion per current implementation.
>     fixed some typos.
> v3: use FPGA base region as container device instead of fpga-dev class.
>     split common enumeration code from pcie driver to functions exposed by
>     device feature list framework.
>     update FME performance reporting which supports both integrated (iperf/)
>     and discrete (dperf/) FPGA solutions.
> v4: rename this doc to Device Feature List (DFL) Framework Overview (dfl.txt)
>     add Device Feature List introduction and re-organize the content.
>     add description for port reset, bitstream_id/metadata and etc.
> ---
>  Documentation/fpga/dfl.txt | 382 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 382 insertions(+)
>  create mode 100644 Documentation/fpga/dfl.txt
>
> diff --git a/Documentation/fpga/dfl.txt b/Documentation/fpga/dfl.txt
> new file mode 100644
> index 0000000..28e4e22
> --- /dev/null
> +++ b/Documentation/fpga/dfl.txt
> @@ -0,0 +1,382 @@
> +===============================================================================
> +              FPGA Device Feature List (DFL) Framework Overview
> +-------------------------------------------------------------------------------
> +                Enno Luebbers <enno.luebbers@intel.com>
> +                Xiao Guangrong <guangrong.xiao@linux.intel.com>
> +                Wu Hao <hao.wu@intel.com>
> +
> +The Device Feature List (DFL) FPGA framework (and drivers according to this
> +this framework) hides the very details of low layer hardwares and provides
> +unified interfaces for userspace applications to configure, enumerate, open
> +and access FPGA accelerators on platforms implemented the DFL in the device
> +memory, and enables system level management functions such as FPGA
> +reconfiguration, power management and virtualization.

This is good, but could be clearer if you break this up into > 1 sentence.

Power management and virtualization are coming in the future, aren't
implemented here.  The upstream will push back on documentation of
features that aren't included in a patchset, since that can all
change.   The cover letter can mention the direction you intend to go
in the future.  The future patchsets can document whatever
functionality they add.  Noted below a few times also.

> +
> +Device Feature List (DFL) Overview
> +==================================
> +Device Feature List (DFL) defines a link list of feature headers within the

*linked

> +device MMIO space to provide an extensible way of adding features. Software can
> +walk through these predefined data structures to enumerate FPGA features:
> +FPGA Interface Unit (FIU), Accelerated Function Unit (AFU) and Private Features,
> +as illustrated below:
> +
> +    Header            Header            Header            Header
> + +----------+  +-->+----------+  +-->+----------+  +-->+----------+
> + |   Type   |  |   |  Type    |  |   |  Type    |  |   |  Type    |
> + |   FIU    |  |   | Private  |  |   | Private  |  |   | Private  |
> + +----------+  |   | Feature  |  |   | Feature  |  |   | Feature  |
> + | Next_DFH |--+   +----------+  |   +----------+  |   +----------+
> + +----------+      | Next_DFH |--+   | Next_DFH |--+   | Next_DFH |--> NULL
> + |    ID    |      +----------+      +----------+      +----------+
> + +----------+      |    ID    |      |    ID    |      |    ID    |
> + | Next_AFU |--+   +----------+      +----------+      +----------+
> + +----------+  |   | Feature  |      | Feature  |      | Feature  |
> + | Feature  |  |   | Region   |      | Region   |      | Region   |
> + | Region   |  |   +----------+      +----------+      +----------+
> + +----------+  |      Header
> +               +-->+----------+
> +                   |   Type   |
> +                   |   AFU    |
> +                   +----------+
> +                   |   GUID   |
> +                   +----------+
> +                   |  Feature |
> +                   |  Region  |
> +                   +----------+
> +

OK, yes, this is much more clear.

> +FPGA Interface Unit (FIU) represents a standalone functional unit for the
> +interface to FPGA, e.g the FPGA Management Engine (FME) and Port. (more

Nit, don't need the period after Port.

> +descriptions on FME and Port in later sections). Accelerated Function Unit (AFU)
> +represents a FPGA programmable region, and usually connects to a FIU as its

The AFU is always connected to a port (which is like an FPGA bridge), right?

> +child as illustrated above. Private Features are sub features of the FIUs/AFUs,
> +they could be various function blocks with different ID, but they are linked to
> +one list via the Next Device Feature Header (DFH) pointer as children. The
> +registers for actual functions are grouped as feature regions which always
> +follow the common header registers. The feature region located after the FIU
> +header, is named as header register set for given FIU type. e.g FME Header
> +Register Set.

Is there anything else in the Feature Region besides the register set?
 Why not just call it the Feature Register Set or Header Register Set
depending on whether it's in a FIU header or a private feature header?

> +
> +This Device Feature List provides a way of linking features together, it's
> +convenient for software to locate each feature by walking through this list,
> +and can be implemented in register regions of any FPGA device.
> +
> +FIU - FME (FPGA Management Engine)
> +==================================
> +The FPGA Management Engine performs power and thermal management, error
> +reporting, reconfiguration, performance reporting for integrated and discrete
> +solution, and other infrastructure functions. Each FPGA device only has one FME.

Currently only reconfiguration is supported.

By integrated, you are referring to FPGAs in SoC's?  Is there a reason
to mention "for integrated and discrete solution" here?

> +
> +User-space applications can acquire exclusive access to the FME using open(),
> +and release it using close().
> +
> +The following functions are exposed through ioctls:
> +
> + Get driver API version (FPGA_GET_API_VERSION)
> + Check for extensions (FPGA_CHECK_EXTENSION)
> + Assign port to PF (*FPGA_FME_PORT_ASSIGN)
> + Release port from PF (*FPGA_FME_PORT_RELEASE)
> + Program bitstream (FPGA_FME_PORT_PR)
> +
> +*FPGA_FME_PORT_ASSIGN/RELEASE are only used for FPGA virtualization. Please
> +refer to later section "FPGA Virtualization - PCIe" for more details.
> +
> +More functions are exposed through sysfs
> +(/sys/class/fpga_region/regionX/dfl-fme.n/):
> +
> + Read bitstream ID (bitstream_id)
> +     bitstream_id indicates version of the blue bitstream (static FPGA region).
> +
> + Read bitstream metadata (bitstream_metadata)
> +     bistream_metadata includes more detailed information of the blue bitstream
> +     (static FPGA region), e.g synthesis date and seed.
> +
> + Read number of ports (ports_num)
> +     one FPGA device may have more than 1 port, this sysfs interface indicates
> +     how many ports the FPGA device has.
> +
> + Read socket ID (socket_id)
> +     socket_id is only used in integrated solution, to indicate which socket
> +     the FPGA device belongs to.

Integrated?  Do you mean discrete FPGAs?  Confused here, sorry.  I
don't see this implemented in the patchset, so I'm not clear what this
will look like.  Should add this later when it is implemented.  Of
course, since you've mentioned this here, we could discuss it.

> +
> + Read performance counters (iperf/ and dperf/)
> + Power management (power_mgmt/)
> + Thermal management (thermal_mgmt/)
> + Error reporting (errors/)

These aren't implemented here, shouldn't be documented here.

> +
> +FIU - PORT
> +==========
> +A port represents the interface between the static FPGA fabric (the "blue
> +bitstream") and a partially reconfigurable region containing an AFU (the "green
> +bitstream"). It controls the communication from SW to the accelerator and
> +exposes features such as reset and debug. Each FPGA device may have more than
> +1 port.

I suggest adding that there is always one port per PR region (or AFU).

> +
> +AFU
> +===
> +An AFU is attached to a port FIU and exposes a fixed length MMIO region to be
> +used for accelerator-specific control registers.
> +
> +User-space applications can acquire exclusive access to an AFU attached to a
> +port by using open() on the port device node, and release it using close().
> +
> +The following functions are exposed through ioctls:
> +
> + Get driver API version (FPGA_GET_API_VERSION)
> + Check for extensions (FPGA_CHECK_EXTENSION)
> + Get port info (FPGA_PORT_GET_INFO)
> + Get MMIO region info (FPGA_PORT_GET_REGION_INFO)
> + Map DMA buffer (FPGA_PORT_DMA_MAP)
> + Unmap DMA buffer (FPGA_PORT_DMA_UNMAP)
> + Reset AFU (*FPGA_PORT_RESET)
> + Enable UMsg (FPGA_PORT_UMSG_ENABLE)
> + Disable UMsg (FPGA_PORT_UMSG_DISABLE)
> + Set UMsg mode (FPGA_PORT_UMSG_SET_MODE)
> + Set UMsg base address (FPGA_PORT_UMSG_SET_BASE_ADDR)

I think the last four aren't implemented in this patchset.  Generally
it's best if documentation covers what is currently implemented.  With
lists like this, you can add to the list as your future patchsets add
the functionality.

> +
> +*FPGA_PORT_RESET: reset the FPGA Port and its AFU. Userspace can do Port reset
> +at any time, e.g during DMA or Partial Reconfiguration. But it should never
> +cause any system level issue, only functional failure (e.g DMA or PR operation
> +failure) and be recoverable from the failure.

Thanks for noting this.

> +
> +User-space applications can also mmap() accelerator MMIO regions.
> +
> +More functions are exposed through sysfs:
> +(/sys/class/fpga_region/<regionX>/<dfl-port.m>/):
> +
> + Read Accelerator GUID (afu_id)
> + Error reporting (errors/)
> +
> +DFL Framework Overview
> +======================
> +
> +         +----------+    +--------+ +--------+ +--------+
> +         |   FME    |    |  AFU   | |  AFU   | |  AFU   |
> +         |  Module  |   | Module | | Module | | Module |
> +         +----------+    +--------+ +--------+ +--------+
> +                 +-----------------------+
> +                 | FPGA Container Device |    Device Feature List
> +                 |  (FPGA Base Region)   |         Framework
> +                 +-----------------------+
> +--------------------------------------------------------------------
> +               +----------------------------+
> +               |   FPGA Bus Device Module   |
> +               | (e.g PCIE/Platform Device) |
> +               +----------------------------+

This name almost sounds like it's adding a FPGA Bus.  How about DFL
Device Module?

> +                 +------------------------+
> +                 |  FPGA Hardware Device  |
> +                 +------------------------+
> +
> +DFL Framework in kernel provides common interfaces to create container device
> +(FPGA base region), discover feature devices and their private features from the
> +given Device Feature Lists, and create platform devices for feature devices
> +(e.g FME, Port and AFU) with related resources under the container device. It
> +also abstracts operations for the private features and exposes common ops to
> +feature device drivers.
> +
> +The FPGA Bus Device could be different devices e.g PCIe device, platform device
> +and etc. Its driver is always loaded first once the device is detected on its
> +own bus. This driver plays an infrastructural role in the driver architecture.
> +It locates the DFLs in the device memory, handles them and related resources
> +to common interfaces from DFL framework for enumeration. (Please refer to
> +drivers/fpga/dfl.c for detailed enumeration APIs).
> +
> +The FPGA Management Engine (FME) driver is a platform driver which is loaded
> +automatically after FME platform device creation from the PCIE driver.

Perhaps "...from the DFL device module" would be more genereric.

> It
> +provides the key features for FPGA management, including:
> +
> +       a) Power and thermal management, error reporting, performance reporting
> +          and other infrastructure functions. Users can access these functions
> +          via sysfs interfaces exposed by FME driver.

You should add this when it's implemented.

> +       b) Partial Reconfiguration. The FME driver creates FPGA manager, FPGA
> +          bridges and FPGA regions during PR sub feature initialization; Once
> +          it receives an FPGA_FME_PORT_PR ioctl from user, it invokes the
> +          common interface function from FPGA Region to complete the partial
> +          reconfiguration of the bitstream to the given port.
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
> +After feature platform devices creation, matched platform drivers will be loaded
> +automatically to handle different functionalities. Please refer to next sections
> +for detailed information on functional units which has been already implemented
> +under this DFL framework.
> +
> +Partial Reconfiguration
> +=======================
> +As mentioned above, accelerators can be reconfigured through partial
> +reconfiguration of a green bitstream file (GBS). The green bitstream must have
> +been generated for the exact blue bitstream and targeted reconfigurable region
> +(port) of the FPGA; otherwise, the reconfiguration operation will fail and
> +possibly cause system instability. This compatibility can be checked by
> +comparing the interface ID noted in the GBS header against the interface ID
> +exposed by the FME through sysfs (see above).

I think the method of checking compatibility changed and isn't
interface_id anymore.

> This check is usually done by
> +user-space before calling the reconfiguration IOCTL.
> +
> +FPGA virtualization - PCIe
> +==========================

This section can be added when virtualization support is added.

> +This section describes the virtualization support on DFL based FPGA device to
> +enable accessing an accelerator from applications running in a virtual machine
> +(VM). This section only describes the PCIe based FPGA device with SRIOV support.
> +
> +Features supported by the particular FPGA device are exposed through Device
> +Feature Lists, as illustrated below:
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
> +FME is always accessed through the physical function (PF).
> +
> +Ports (and related AFUs) are accessed via PF by default, but could be exposed
> +through virtual function (VF) devices via PCIe SRIOV. Each VF only contains
> +1 Port and 1 AFU for isolation. Users could assign individual VFs (accelerators)
> +created via PCIe SRIOV interface, to virtual machines.
> +
> +The driver organization in virtualization case is illustrated below:
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
> +        +-----------------------+       |       +-----------------------+
> +        | FPGA Container Device |       |       | FPGA Container Device |
> +        |  (FPGA Base Region)   |       |       |  (FPGA Base Region)   |
> +        +-----------------------+       |       +-----------------------+
> +          +------------------+          |         +------------------+
> +          | FPGA PCIE Module |          | Virtual | FPGA PCIE Module |
> +          +------------------+   Host   | Machine +------------------+
> + -------------------------------------- | ------------------------------
> +           +---------------+            |          +---------------+
> +           | PCI PF Device |            |          | PCI VF Device |
> +           +---------------+            |          +---------------+
> +
> +FPGA PCIe device driver is always loaded first once a FPGA PCIe PF or VF device
> +is detected. It:
> +
> +       a) finish enumeration on both FPGA PCIe PF and VF device using common
> +          interfaces from DFL framework.
> +       b) supports SRIOV.
> +
> +The FME device driver plays a management role in this driver architecture, it
> +provides ioctls to release Port from PF and assign Port to PF. After release
> +a port from PF, then it's safe to expose this port through a VF via PCIe SRIOV
> +sysfs interface.
> +
> +To enable accessing an accelerator from applications running in a VM, the
> +respective AFU's port needs to be assigned to a VF using the following steps:
> +
> +       a) The PF owns all AFU ports by default. Any port that needs to be
> +          reassigned to a VF must first be released through the
> +          FPGA_FME_PORT_RELEASE ioctl on the FME device.
> +
> +       b) Once N ports are released from PF, then user can use command below
> +          to enable SRIOV and VFs. Each VF owns only one Port with AFU.
> +
> +          echo N > $PCI_DEVICE_PATH/sriov_numvfs
> +
> +       c) Pass through the VFs to VMs
> +
> +       d) The AFU under VF is accessible from applications in VM (using the
> +          same driver inside the VF).
> +
> +Note that an FME can't be assigned to a VF, thus PR and other management
> +functions are only available via the PF.
> +
> +Device enumeration
> +==================
> +This section introduces how applications enumerate the fpga device from
> +the sysfs hierarchy under /sys/class/fpga_region.
> +
> +In the example below, two DFL based FPGA devices are installed in the host. Each
> +fpga device has one FME and two ports (AFUs).
> +
> +FPGA regions are created under /sys/class/fpga_region/
> +
> +       /sys/class/fpga_region/region0
> +       /sys/class/fpga_region/region1
> +       /sys/class/fpga_region/region2
> +       ...
> +
> +Application needs to search each regionX folder, if feature device is found,
> +(e.g "dfl-port.n" or "dfl-fme.m" is found), then it's the base
> +fpga region which represents the FPGA device.
> +
> +Each base region has one FME and two ports (AFUs) as child devices:
> +
> +       /sys/class/fpga_region/region0/dfl-fme.0
> +       /sys/class/fpga_region/region0/dfl-port.0
> +       /sys/class/fpga_region/region0/dfl-port.1
> +       ...
> +
> +       /sys/class/fpga_region/region3/dfl-fme.1
> +       /sys/class/fpga_region/region3/dfl-port.2
> +       /sys/class/fpga_region/region3/dfl-port.3
> +       ...
> +
> +In general, the FME/AFU sysfs interfaces are named as follows:
> +
> +       /sys/class/fpga_region/<regionX>/<dfl-fme.n>/
> +       /sys/class/fpga_region/<regionX>/<dfl-port.m>/
> +
> +with 'n' consecutively numbering all FMEs and 'm' consecutively numbering all
> +ports.
> +
> +The device nodes used for ioctl() or mmap() can be referenced through:
> +
> +       /sys/class/fpga_region/<regionX>/<dfl-fme.n>/dev
> +       /sys/class/fpga_region/<regionX>/<dfl-port.n>/dev
> +
> +Add new FIUs support
> +====================
> +It's possible that developers made some new function blocks (FIUs) under this
> +DFL framework, then new platform device driver needs to be developed for the
> +new feature dev (FIU) following the same way as existing feature dev drivers
> +(e.g FME and Port/AFU platform device driver). Besides that, it requires
> +modification on DFL framework enumeration code too, for new FIU type detection
> +and related platform devices creation.
> +
> +Add new private features support
> +================================
> +In some cases, we may need to add some new private features to existing FIUs
> +(e.g FME or Port). Developers don't need to touch enumeration code in DFL
> +framework, as each private feature will be parsed automatically, and related
> +mmio resources can be found under FIU platform device created by DFL framework.
> +Developer only needs to provide a sub feature driver with matched feature id.
> +FME Partial Reconfiguration Sub Feature driver (see drivers/fpga/dfl-fme-pr.c)
> +could be a reference.
> +
> +Open discussion
> +===============
> +FME driver exports one ioctl (FPGA_FME_PORT_PR) for partial reconfiguration to
> +user now. In the future, if unified user interfaces for reconfiguration are
> +added, FME driver should switch to them from ioctl interface.
> --
> 2.7.4
>
