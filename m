From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v8 08/10] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Thu, 17 Mar 2016 13:45:20 -0400
Message-ID: <56EAED30.3040503@linux.vnet.ibm.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160316204244.GB23966@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316204244.GB23966-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/16/2016 04:42 PM, Jarkko Sakkinen wrote:
> On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Berger wrote:
>> +
>> +/* above flags */
>> +#define VTPM_PROXY_FLAG_TPM2  1  /* emulator is TPM 2 */
>> +
>> +/* all supported flags */
>> +#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
> This can be moved inside the .c-file?

I can move that.

>
>> +
>> +#define VTPM_PROXY_MAGIC 0xa1
>> +
>> +#define VTPM_PROXY_IOC_NEW_DEV   _IOW(VTPM_PROXY_MAGIC, 0x00, \
>> +				      struct vtpm_proxy_new_dev)
> Could we simply replace these four lines with one line:
>
> #deifne VTPM_PROXY_IOC_NEW_DEV _IOW('t', 0x00, struct vtpm_proxy_new_dev);

Does this make it better?

>
> I changed the magic but does it matter?

I would keep the magic at '0xa1'. The documentation is written to '0xa1' 
now and seems to be good just as any other.

    Stefan
