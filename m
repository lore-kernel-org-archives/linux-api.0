From: Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [PATCH 1/2] driver: add PPI support in tpm driver
Date: Tue, 12 Jun 2012 13:57:32 -0500
Message-ID: <CAM0nabHV6CepQyXeVZiv2XT9WHPgMy=prdK-8fNgyrCZ4v6dSg@mail.gmail.com>
References: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>, "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>, "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "hpa@zytor.com" <hpa@zytor.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Cihula, Joseph" <joseph.cihula@intel.com>, "Wei, Gang" <gang.wei@intel.com>
List-Id: linux-api@vger.kernel.org

Hi Xiaoyan,

On Tue, May 22, 2012 at 10:34 PM, Zhang, Xiaoyan
<xiaoyan.zhang@intel.com> wrote:
> From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
>
> The Physical Presence Interface enables the OS and the BIOS to cooper=
ate
> and provides a simple and straightforward platform user experience fo=
r
> administering the TPM without sacrificing security.
>
> Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
> ---
> =A0drivers/char/tpm/tpm.c | =A0462 ++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A0drivers/char/tpm/tpm.h | =A0 18 ++
> =A02 files changed, 480 insertions(+), 0 deletions(-)

  This code looks clean - my only suggestion would be to add an #ifdef
CONFIG_ACPI around it so it compiles out on ppc.

Kent

--=20
IBM LTC Security
