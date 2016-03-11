From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Fri, 11 Mar 2016 12:20:58 +0200
Message-ID: <20160311102058.GB10270@intel.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160310163915.GA4863@intel.com>
	<56E1AF9F.3010409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E1AF9F.3010409-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2016 at 12:32:15PM -0500, Stefan Berger wrote:
> On 03/10/2016 11:39 AM, Jarkko Sakkinen wrote:
> >+/* above flags */
> >+#define VTPM_FLAG_TPM2           1  /* emulator is TPM 2 */
> >+
> >+/* all supported flags */
> >+#define VTPM_FLAGS_ALL  (VTPM_FLAG_TPM2)
> >+
> >+#define VTPM_TPM 0xa0

A better name would be VTPM_IOC_MAGIC. You should also update
Documentation/ioctl/ioctl-number.txt.

> >+
> >+#define VTPM_NEW_DEV         _IOW(VTPM_TPM, 0x00, struct vtpm_new_dev)
> >I'd rather use VTPM_IOC_NEW_DEV.
> 
> What about the name of the structure ? vtpm_ioc_new_dev?

If I look at other subsystems like drm the common practice is either
name the ioctl as VTPM_NEW_DEV_IOCTL or VTPM_IOC_NEW_DEV and not have
suffix or postfix in the parameter struct. I would just copy that
convention here.

>    Stefan

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
