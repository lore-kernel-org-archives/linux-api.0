From: "Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org)"
	<gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 08:10:20 -0700
Message-ID: <20150624151020.GD7925@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3F8E9E02@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3F8E9E02@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 24, 2015 at 06:54:35AM +0000, Seymour, Shane M wrote:
> 
> Convert DRIVER_ATTR macros to DRIVER_ATTR_RO requested by
> Greg KH. Also switched to using scnprintf instead of snprintf
> per Documentation/filesystems/sysfs.txt.
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Shane Seymour <shane.seymour@hp.com>
> ---
> This patch was implemented on top of the previous patch to
> convert to using driver attr groups.
> 
> Changes from v1:
> - switched to scnprintf from sprintf after feedback from Sergey
> Senozhatsky.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
