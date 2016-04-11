From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Mon, 11 Apr 2016 12:14:03 -0600
Message-ID: <20160411181403.GB371@obsidianresearch.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160407123539.GA17489@intel.com>
	<57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160411084358.GB11322-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 11, 2016 at 11:43:58AM +0300, Jarkko Sakkinen wrote:
> On Thu, Apr 07, 2016 at 11:49:44AM -0400, Stefan Berger wrote:
> > On 04/07/2016 08:35 AM, Jarkko Sakkinen wrote:
> > >On Tue, Mar 29, 2016 at 02:19:12PM -0400, Stefan Berger wrote:
> > >>This patch implements a proxy driver for supporting multiple emulated TPMs
> > >>in a system.
> > >>
> > >>The driver implements a device /dev/vtpmx that is used to created
> > >>a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
> > >>is accessed using a file descriptor returned by an ioctl.
> > >>The device /dev/tpmX is the usual TPM device created by the core TPM
> > >>driver. Applications or kernel subsystems can send TPM commands to it
> > >>and the corresponding server-side file descriptor receives these
> > >>commands and delivers them to an emulated TPM.
> > >>
> > >>Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > >>CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >>CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >>CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > >Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > Thanks. So I can post a v10 where I have to re-introduce the priv field but
> > put it into the tpm_chip struct. Obviously it needs this field. I am not
> > sure whether you'll let me take the Reviewed-by and Tested-by, though?
> 
> Lets hold for them then. I'll do retest when I get the new series.

Lets just fix the sysfs stuff the same way we fixed ppi and be done
with this issue.

Something that looks kinda like this untested thing:

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index a7c3473c3421..51e898be4307 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -36,7 +36,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 	int i, rc;
 	char *str = buf;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	tpm_cmd.header.in = tpm_readpubek_header;
 	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
@@ -92,7 +92,7 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	ssize_t rc;
 	int i, j, num_pcrs;
 	char *str = buf;
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
 			"attempting to determine the number of PCRS");
@@ -222,7 +222,7 @@ static DEVICE_ATTR_RO(caps);
 static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 	if (chip == NULL)
 		return 0;
 
@@ -234,7 +234,7 @@ static DEVICE_ATTR_WO(cancel);
 static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	if (chip->duration[TPM_LONG] == 0)
 		return 0;
@@ -251,7 +251,7 @@ static DEVICE_ATTR_RO(durations);
 static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_chip *chip = to_tpm_chip(dev);
 
 	return sprintf(buf, "%d %d %d %d [%s]\n",
 		       jiffies_to_usecs(chip->timeout_a),
@@ -283,22 +283,33 @@ static const struct attribute_group tpm_dev_group = {
 
 int tpm_sysfs_add_device(struct tpm_chip *chip)
 {
-	int err;
-	err = sysfs_create_group(&chip->dev.parent->kobj,
-				 &tpm_dev_group);
+	const struct attribute **i;
 
-	if (err)
-		dev_err(&chip->dev,
-			"failed to create sysfs attributes, %d\n", err);
-	return err;
+	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return 0;
+
+	for (i = tpm_dev_attrs; *i != NULL; ++i) {
+		rc = __compat_only_sysfs_link_entry_to_kobj(
+		    &chip->dev.parent->kobj, &chip->dev.kobj, (*i)->name);
+		if (rc && rc != -ENOENT) {
+			tpm_sysfs_del_device(chip);
+			return rc;
+		}
+	}
+
+	return 0;
 }
 
 void tpm_sysfs_del_device(struct tpm_chip *chip)
 {
-	/* The sysfs routines rely on an implicit tpm_try_get_ops, this
-	 * function is called before ops is null'd and the sysfs core
-	 * synchronizes this removal so that no callbacks are running or can
-	 * run again
+	const struct attribute **i;
+
+	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
+	 * is called before ops is null'd and the sysfs core synchronizes this
+	 * removal so that no callbacks are running or can run again
 	 */
-	sysfs_remove_group(&chip->dev.parent->kobj, &tpm_dev_group);
+
+	for (i = tpm_dev_attrs; *i != NULL; ++i)
+		sysfs_remove_link(&chip->dev.parent->kobj, (*i)->name);
 }

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
