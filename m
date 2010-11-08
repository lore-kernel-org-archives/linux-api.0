From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH v2 00/23] netoops support
Date: Mon, 08 Nov 2010 14:55:27 -0600
Message-ID: <1289249727.18612.228.camel@calx>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2010-11-08 at 12:31 -0800, Mike Waychison wrote:
> This patchset applies to v2.6.37-rc1.
> 
> The following series implements support for 'netoops', a simple driver that
> will deliver kmsg logs together with machine specifics over the network.
> 
> This driver is based on code used in Google's production server environment.
> We internally call the driver 'netdump', but are planning on changing the name
> to 'netoops' to follow the convention set by both the mtdoops and ramoops
> drivers.  We use these facilities to gather crash data from our entire fleet of
> machines in a light-weight manner.  We do things this way because it
> simply isn't feasible to gather full crash data off of every machine in
> the wild that decides it is time to die.
> 
> Currently, this driver only supports UDP over ipv4.
> 
> In order to handle configuration, the target support in netconsole is
> fixed, seperated out, and re-used by netoops.
> 
> I'm posting these patches in an effort to eventually get this sort of
> functionality mainlined.  I have tried to clean this code up internally, but
> there are still several unresolved issues that would need to be worked
> out as of this version.  In particular:
> 
>    * I am _NOT_ happy with the remaining userland ABIs presented in this
>      patchset.  Specifically the files "net_dump_now",
>      "net_dump_one_shot", "netdump_fw_version", "netdump_board_name" and
>      "netdump_boot_id" should be considered.  These files have been
>      cobbled together by a variety of engineers over the years, and they
>      aren't very pretty.  I present them none-the-less to express the
>      scope of the functionality that we would like to maintain.
> 
>    * I am _NOT_ happy with the data format of the transmitted packets.  It is
>      very specific to our server environment and currently:
> 
>       * is hard-coded to support both userland provided information (that may
>         not be applicable to others) and
> 
>       * only supports i386 and x86_64.
> 
> I'd like to resolve each of the above issues in subsequent versions of this
> patchset.  I need help in identifying what the ABI should look like in
> particular.
> 
> Patchset summary
> ================
> 
> Patches 1 through 4 inclusive are fixes to the existing netconsole code,
> adding locking consistency, fixing races and deadlocks.
> 
> Patches 5 through 14 inclusive splits the target configuration portion
> of netconsole out into a new component in net/core/netpoll_targets.c.
> 
> Patches 15 through 18 inclusive are core changes to support
> functionality in the netoops driver.
> 
> Patches 19 through 23 is the netoops driver itself, with different
> functional aspects broken out.
> 
>  1 - netconsole: Remove unneeded reference counting
>  2 - netconsole: Introduce locking over the netpoll fields
>  3 - netconsole: Introduce 'enabled' state-machine
>  4 - netconsole: Call netpoll_cleanup() in process context

>  5 - netconsole: Wrap the list and locking in a structure
>  6 - netconsole: Push configfs_subsystem into netpoll_targets
>  7 - netconsole: Move netdev_notifier into netpoll_targets
>  8 - netconsole: Split out netpoll_targets init/exit
>  9 - netconsole: Add pointer to netpoll_targets
> 10 - netconsole: Rename netconsole_target -> netpoll_target
> 11 - netconsole: Abstract away the subsystem name
> 12 - netpoll: Introduce netpoll_target configs
> 13 - netconsole: Move setting of default ports.
> 14 - netpoll: Move target code into netpoll_targets.c

This much of your set looks very nice to me, but I'd like to get some
more eyeballs on the first four. Dave?

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
