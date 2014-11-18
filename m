From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v7 06/10] tpm: fix: move sysfs attributes to the correct
 place.
Date: Tue, 18 Nov 2014 11:29:11 +0200
Message-ID: <20141118092911.GA17459@intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415713513-16524-7-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415713513-16524-7-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 11, 2014 at 03:45:09PM +0200, Jarkko Sakkinen wrote:
> The sysfs attributes of the TPM device were created to the platform
> device directory that owns the character device instead of placing
> them correctly to the directory of the character device,
> 
> They were also created in a racy way so that character device might
> become visible before sysfs attributes become available.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

For this patch there are at least these open items:

- Paths in Documentation/ABI/stable/sysfs-class-tpm should be updated.
- I moved attributes described in the documentation to the character
  device sysfs-directory from platform device sysfs directory. I don't
  believe this is a mentionable breakage because they weren't machine
  readable anyway. This should be however explicitly stated in the
  commit message.
- What should be done with PPI sysfs attributes? They are also in wrong
  place.
- What should be done with the BIOS log? They are also in wrong place.

I think this patch is really the key change to sort out before pulling the
patch set to the maintainer tree. 

/Jarkko
