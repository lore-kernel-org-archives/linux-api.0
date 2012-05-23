From: "Zhang, Xiaoyan" <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Add PPI support in tpm driver
Date: Wed, 23 May 2012 03:33:58 +0000
Message-ID: <953B7F5DA8C0F44CBD2621D8763F4F6005F797@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org" <m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org>, "shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cihula, Joseph" <joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The series of patches add PPI support in linux kernel.

The Physical Presence Interface enables the OS and the BIOS to cooperate to provide a simple and straightforward platform user experience for administering the TPM without sacrificing security.

PATCH 1: drivers: Add PPI support in tpm driver
PATCH 2: Documentation: sysfs for physical presence interface
