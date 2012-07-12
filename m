From: Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V3 1/2] driver: add PPI support in tpm driver
Date: Thu, 12 Jul 2012 09:45:29 -0500
Message-ID: <20120712144529.GA32640@linux.vnet.ibm.com>
References: <1340203963.24516.2.camel@localhost>
 <20120711152430.GC21153@linux.vnet.ibm.com>
 <953B7F5DA8C0F44CBD2621D8763F4F600C8A32@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <953B7F5DA8C0F44CBD2621D8763F4F600C8A32-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Xiaoyan" <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cihula, Joseph" <joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org" <m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org>, "shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2012 at 02:38:56AM +0000, Zhang, Xiaoyan wrote:
> Hi Kent,
> 
> Thanks for your comment on the patch. But there's some confusion on my side.
> You mentioned not to change the tpm driver name. But the driver is linked from tpm.c and tpm_ppi.c, so I should change the original tpm.c file name, right? Is it acceptable to change tpm.c to tpm_common.c or tpm_utils.c or else?

  I think you can just add tpm_ppi.c like this:

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index beac52f6..96b9222 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -4,7 +4,7 @@
 obj-$(CONFIG_TCG_TPM) += tpm.o
 ifdef CONFIG_ACPI
        obj-$(CONFIG_TCG_TPM) += tpm_bios.o
-       tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
+       tpm_bios-objs += tpm_eventlog.o tpm_acpi.o tpm_ppi.o
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o

Kent

> 
> Thanks,
> Xiaoyan
