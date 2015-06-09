From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v5 05/21] libnvdimm: control (ioctl) messages for
	libnvdimm bus and dimm devices
Date: Tue, 9 Jun 2015 08:34:18 +0200
Message-ID: <20150609063418.GB9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001435.4506.42614.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150602001435.4506.42614.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 01, 2015 at 08:14:35PM -0400, Dan Williams wrote:
> Most discovery/configuration of the libnvdimm-subsystem is done via
> sysfs attributes.  However, some libnvdimm buses, particularly the
> ACPI.NFIT bus, define a small set of messages that can be passed to the
> platform.  For convenience we derive the initial libnvdimm-ioctl command
> formats directly from the NFIT DSM Interface Example formats.

Why not merge these into the extensive sysfs interface?
