From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v9 4/8] tpm: rename chip->dev to chip->pdev
Date: Thu, 4 Dec 2014 21:49:41 +0100
Message-ID: <201412042149.41813.PeterHuewe@gmx.de>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-5-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417672518-4530-5-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:14 schrieb Jarkko Sakkinen:
> Rename chip->dev to chip->pdev to make it explicit that this not the
> character device but actually represents the platform device.
>=20
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-chip.c         |  4 ++--
>  drivers/char/tpm/tpm-dev.c          | 10 +++++-----
>  drivers/char/tpm/tpm-interface.c    | 29 +++++++++++++++------------=
--
>  drivers/char/tpm/tpm-sysfs.c        |  6 +++---
>  drivers/char/tpm/tpm.h              |  4 ++--
>  drivers/char/tpm/tpm_atmel.c        | 14 +++++++-------
>  drivers/char/tpm/tpm_i2c_atmel.c    | 16 ++++++++--------
>  drivers/char/tpm/tpm_i2c_infineon.c |  6 +++---
>  drivers/char/tpm/tpm_i2c_nuvoton.c  | 22 +++++++++++-----------
>  drivers/char/tpm/tpm_i2c_stm_st33.c | 14 +++++++-------
>  drivers/char/tpm/tpm_infineon.c     | 22 +++++++++++-----------
>  drivers/char/tpm/tpm_nsc.c          | 20 ++++++++++----------
>  drivers/char/tpm/tpm_ppi.c          |  4 ++--
>  drivers/char/tpm/tpm_tis.c          | 14 +++++++-------
>  14 files changed, 93 insertions(+), 92 deletions(-)
>=20
:(

With CONFIG_OF set I get a compile error.

drivers/char/tpm/tpm_i2c_stm_st33.c: In Funktion =BBtpm_stm_i2c_of_requ=
est_resources=AB:
drivers/char/tpm/tpm_i2c_stm_st33.c:649:3: Fehler: Inkompatibler Typ f=FC=
r Argument 1 von =BBdev_err=AB
In file included from include/linux/pci.h:30:0,
                 from drivers/char/tpm/tpm_i2c_stm_st33.c:32:
include/linux/device.h:1044:5: Anmerkung: =BBconst struct device *=AB e=
rwartet, aber Argument hat Typ =BBstruct device=AB
drivers/char/tpm/tpm_i2c_stm_st33.c:662:3: Fehler: Inkompatibler Typ f=FC=
r Argument 1 von =BBdev_err=AB
In file included from include/linux/pci.h:30:0,
                 from drivers/char/tpm/tpm_i2c_stm_st33.c:32:
include/linux/device.h:1044:5: Anmerkung: =BBconst struct device *=AB e=
rwartet, aber Argument hat Typ =BBstruct device=AB
scripts/Makefile.build:263: recipe for target 'drivers/char/tpm/tpm_i2c=
_stm_st33.o' failed
make[3]: *** [drivers/char/tpm/tpm_i2c_stm_st33.o] Error 1
scripts/Makefile.build:404: recipe for target 'drivers/char/tpm' failed
make[2]: *** [drivers/char/tpm] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/char' failed
make[1]: *** [drivers/char] Error 2
Makefile:929: recipe for target 'drivers' failed
make: *** [drivers] Error 2


Sorry,
Peter
