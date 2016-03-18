From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 08/10] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Fri, 18 Mar 2016 10:52:00 +0200
Message-ID: <20160318085200.GA5604@intel.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160316204244.GB23966@intel.com>
 <56EAED30.3040503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56EAED30.3040503@linux.vnet.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 17, 2016 at 01:45:20PM -0400, Stefan Berger wrote:
> On 03/16/2016 04:42 PM, Jarkko Sakkinen wrote:
> >On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Berger wrote:
> >>+
> >>+/* above flags */
> >>+#define VTPM_PROXY_FLAG_TPM2  1  /* emulator is TPM 2 */
> >>+
> >>+/* all supported flags */
> >>+#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
> >This can be moved inside the .c-file?
> 
> I can move that.
> 
> >
> >>+
> >>+#define VTPM_PROXY_MAGIC 0xa1
> >>+
> >>+#define VTPM_PROXY_IOC_NEW_DEV   _IOW(VTPM_PROXY_MAGIC, 0x00, \
> >>+				      struct vtpm_proxy_new_dev)
> >Could we simply replace these four lines with one line:
> >
> >#deifne VTPM_PROXY_IOC_NEW_DEV _IOW('t', 0x00, struct vtpm_proxy_new_dev);
> 
> Does this make it better?
> 
> >
> >I changed the magic but does it matter?
> 
> I would keep the magic at '0xa1'. The documentation is written to '0xa1' now
> and seems to be good just as any other.

OK. Works for me. Keep the ioctl definition as it is.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I can move the constant. You don't have to send a new patch version
anymore. I start keeping this patch in my master but will not merge it
to next before 4.6-rc5 so at the moment it would be scheduled for 4.7.
Does this sound good for you?

Further improvemnts should be sent as separate fixup patches.

>    Stefan

/Jarkko
