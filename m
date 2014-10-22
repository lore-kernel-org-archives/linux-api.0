From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Aw: [PATCH v1 0/3] tpm: prepare for TPM2
Date: Wed, 22 Oct 2014 18:34:02 +0200
Message-ID: <trinity-cda2c5de-5cfe-4522-ac24-466d34965655-1413995642086@3capp-gmx-bs09>
References: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413995036-22497-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Jarkko,

> Jarkko Sakkinen (3):
> tpm: merge duplicate transmit_cmd() functions
> tpm: two-phase chip management functions
> tpm: fix multiple race conditions in tpm_ppi.c

the patchset introduces a sparse error:
  CHECK   /home/phuewe/linux-2.6-host/drivers/char/tpm/tpm_tis.c
/home/phuewe/linux-2.6-host/drivers/char/tpm/tpm_tis.c:783:39: warning: Using plain integer as NULL pointer
/home/phuewe/linux-2.6-host/drivers/char/tpm/tpm_tis.c:868:39: warning: Using plain integer as NULL pointer

apart from that I'll review it this evening.

Thanks,
Peter
