From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 3/3] firmware: fw_cfg: create directory hierarchy for
 fw_cfg file names
Date: Mon, 10 Aug 2015 11:32:45 -0700
Message-ID: <20150810183245.GB18817@kroah.com>
References: <cover.1439220623.git.somlo@cmu.edu>
 <1cadfcda3c31d7470f677656f9c914e9c4b7c0cd.1439220623.git.somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1cadfcda3c31d7470f677656f9c914e9c4b7c0cd.1439220623.git.somlo-D+Gtc/HYRWM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 10, 2015 at 12:31:20PM -0400, Gabriel L. Somlo wrote:
> From: "Gabriel Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
> 
> Each fw_cfg entry of type "file" has an associated 56-char,
> nul-terminated ASCII string which represents its name. While
> the fw_cfg device doesn't itself impose any specific naming
> convention, QEMU developers have traditionally used path name
> semantics (i.e. "etc/acpi/rsdp") to descriptively name the
> various fw_cfg "blobs" passed into the guest.
> 
> This patch attempts, on a best effort basis, to create a
> directory hierarchy representing the content of fw_cfg file
> names, under /sys/firmware/fw_cfg/by_name.
> 
> Upon successful creation of all directories representing the
> "dirname" portion of a fw_cfg file, a symlink will be created
> to represent the "basename", pointing at the appropriate
> /sys/firmware/fw_cfg/by_select entry. If a file name is not
> suitable for this procedure (e.g., if its basename or dirname
> components collide with an already existing dirname component
> or basename, respectively) the corresponding fw_cfg blob is
> skipped and will remain available in sysfs only by its selector
> key value.

Shouldn't all of this be done in userspace with the symlinks and all?
It seems like you are trying to duplicate the /dev/block/by-name and
such.  Policy decisions like symlinks and naming should be done there,
in userspace, and not directly in sysfs if at all possible.

Again, why can't this be a bunch of character device nodes?  It seems
like you want to access them that way (read/write, ioctl, etc.)

thanks,

greg k-h
