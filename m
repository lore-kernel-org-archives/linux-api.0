From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v7 08/10] tpm: TPM 2.0 CRB Interface
Date: Fri, 28 Nov 2014 12:23:51 -0500
Message-ID: <5478AFA7.6040200@linux.vnet.ibm.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1415713513-16524-9-git-send-email-jarkko.sakkinen@linux.intel.com> <5475DE81.50308@linux.vnet.ibm.com> <20141127154023.GD24791@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141127154023.GD24791-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/27/2014 10:40 AM, Jarkko Sakkinen wrote:
> On Wed, Nov 26, 2014 at 09:06:57AM -0500, Stefan Berger wrote:
>> On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
>>> tpm_crb is a driver for TPM 2.0 Command Response Buffer (CRB) Interface
>>> as defined in PC Client Platform TPM Profile (PTP) Specification.
>>>
>>> Only polling and single locality is supported as these are the limitations
>>> of the available hardware, Platform Trust Techonlogy (PTT) in Haswell
>>> CPUs.
>>>
>>> The driver always applies CRB with ACPI start because PTT reports using
>>> only ACPI start as start method but as a result of my testing it requires
>>> also CRB start.
>>>
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>> ---
>>>
[...]
>>> +static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>>> +{
>>> +	struct crb_priv *priv = chip->vendor.priv;
>>> +	struct crb_control_area *cca;
>>> +	u8 *cmd;
>>> +	int rc = 0;
>>> +
>>> +	cca = priv->cca;
>>> +
>>> +	if (len > le32_to_cpu(cca->cmd_size)) {
>>> +		dev_err(&chip->dev,
>>> +			"invalid command count value %x %zx\n",
>>> +			(unsigned int) len,
>>> +			(size_t) le32_to_cpu(cca->cmd_size));
>>> +		return -E2BIG;
>>> +	}
>>> +
>>> +	cmd = (u8 *) ((unsigned long) cca + le64_to_cpu(cca->cmd_pa) -
>>> +		      priv->cca_pa);
>> cca = priv->cca per statement above     -> cmd = cca + x - cca = x
>>
>> -> cmd = le64_to_cpu(cca->cmd_pa);
>>
>> Should do the trick, no ?
> Virtual address might be different where CCA is ioremapped.

My bad. Is the 'Command Address' then guaranteed to lie within the 
remapped area of the 'Control Area' or should there be a check whether 
you would need a separate remapping? It's not clear from the specs where 
it lies (2.1 4th paragraph: "They can all be in system RAM, or all be in 
device memory, or any combination"). Same is true for the 'Response 
Address'.  Maybe you should have the ioremapped address for the 'Command 
Address' calculated elsewhere and simplify the address calculation here 
to basically cmd = priv->command_address.

Make the address calculations in cbr_recv and crb_send look the same.

[So, (cca - priv->cca_pa)  calculates the offset of the remapping. 
Adding to this the address of the command buffer gives the ioremapped 
address of the command buffer, assuming it lies within that remapped area. ]


     Stefan

>
>>> +	memcpy(cmd, buf, len);
>>> +
>>> +	/* Make sure that cmd is populated before issuing start. */
>>> +	wmb();
>>> +
>>> +	cca->start = cpu_to_le32(1);
>>> +	rc = crb_do_acpi_start(chip);
