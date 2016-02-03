From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v8 0/4] SysFS driver for QEMU fw_cfg device
Date: Wed, 3 Feb 2016 22:47:29 +0000
Message-ID: <20160203224729.GB15385@codeblueprint.co.uk>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453990994-17801-1-git-send-email-somlo-D+Gtc/HYRWM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ehabkost-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 28 Jan, at 09:23:10AM, Gabriel L. Somlo wrote:
> From: "Gabriel Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
> 
> Allow access to QEMU firmware blobs, passed into the guest VM via
> the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
> size, and fw_cfg key), as well as the raw binary blob data may be
> accessed.
> 
> The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
> selected based on overall similarity to the type of information
> exposed under /sys/firmware/dmi/entries/...
> 
> This functionality is primarily intended to serve as a host->guest
> configuration data transfer mechanism that is both:
> 
>         - asynchronous: the host doesn't need to wait for the guest
>                         to be ready to accept data (e.g., by starting
>                         an agent daemon)
> 
>         - out-of-band:  there is no need to commandeer a guest element
>                         normally visible and available to the guest user
>                         (e.g., kernel cmdline, mounting floppy/cdrom, etc.)
> 
> QEMU now allows arbitrary fw_cfg blobs to be added via the command line,
> so it would be nice to make them easy to retrieve from within the guest
> OS, and the niceset and easiest way I can think of is
> 
>         cat /sys/firmware/qemu-fw-cfg/.../<some-blob-name>/raw
> 
> New since v7:
> 
> 	- kbuild testbot complained about a warning on ia64, so limit
> 	  the availability of fw_cfg in Kconfig to only architectures
> 	  on which QEMU makes it available, which include:
> 
> 		(ARM || ARM64 || PPC_PMAC || SPARC || X86)

This is looking pretty good now. Does anyone have remaining
objections before this gets merged?
