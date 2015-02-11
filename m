From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [Patch v4] firmware: dmi-sysfs: add SMBIOS entry point area
 attribute
Date: Wed, 11 Feb 2015 14:43:21 +0000
Message-ID: <20150211144321.GB4665@codeblueprint.co.uk>
References: <1423069563-26467-1-git-send-email-ivan.khoronzhuk@linaro.org>
 <54D9D4B0.7020803@linaro.org>
 <20150211141703.GA4665@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150211141703.GA4665@codeblueprint.co.uk>
Sender: linux-doc-owner@vger.kernel.org
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 11 Feb, at 02:17:03PM, Matt Fleming wrote:
> On Tue, 10 Feb, at 11:51:44AM, Ivan Khoronzhuk wrote:
> > 
> > If you are Ok with this patch, could you please pickup it?
> 
> Applied, thanks Ivan!

Btw this patch doesn't apply cleanly, the reject looks like this,

--- drivers/firmware/dmi_scan.c
+++ drivers/firmware/dmi_scan.c
@@ -537,6 +543,8 @@
 		dmi_ver &= 0xFFFFFF;
 		dmi_len = get_unaligned_le32(buf + 12);
 		dmi_base = get_unaligned_le64(buf + 16);
+		smbios_header_size = buf[6];
+		memcpy(smbios_header, buf, smbios_header_size);
 
 		/*
 		 * The 64-bit SMBIOS 3.0 entry point no longer has a field

What version of the kernel did you base this patch on? The conflict is
trivial to fixup and I've done so and pushed it out on the EFI 'next'
branch, but I wanted to call out this conflict explicitly.

-- 
Matt Fleming, Intel Open Source Technology Center
