From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [Patch v3] firmware: dmi-sysfs: add SMBIOS entry point area raw
 attribute
Date: Tue, 3 Feb 2015 10:49:53 +0000
Message-ID: <20150203104953.GA6461@codeblueprint.co.uk>
References: <1422448763-17583-1-git-send-email-ivan.khoronzhuk@linaro.org>
 <54C906A9.1050001@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54C906A9.1050001-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 28 Jan, at 05:56:25PM, Ivan Khoronzhuk wrote:
> >diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
> >index e0f1cb3..61b6a38 100644
> >--- a/drivers/firmware/dmi-sysfs.c
> >+++ b/drivers/firmware/dmi-sysfs.c
> >@@ -29,6 +29,8 @@
> >  #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
> >  			      the top entry type is only 8 bits */
> >+static const u8 *smbios_raw_header;

There appears to be a mixture of u8 and unsigned char going on here, cf.
'smbios_header'.

While I'm pretty sure all architectures typedef them to be equivalent,
semantically, as a reviewer this makes me think there are type issues.

Is there any way to use one data type for the SMBIOS header?

> >@@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
> >  		goto err;
> >  	}
> >+	smbios_raw_header = dmi_get_smbios_entry_area(&size);
> >+	if (!smbios_raw_header) {
> >+		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
> >+		error = -ENODATA;
> >+		goto err;

Perhaps this should be -EINVAL? -ENODATA implies that if you try again
in the future data might be available, i.e. it's a temporary failure.
That's not the case here since the header is invalid.

-- 
Matt Fleming, Intel Open Source Technology Center
