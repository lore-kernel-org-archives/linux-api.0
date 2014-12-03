From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
Date: Tue, 02 Dec 2014 21:28:35 -0500
Message-ID: <547E7553.2050608@linux.vnet.ibm.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: christophe.ricard@gmail.com, josh.triplett@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Will Arthur <will.c.arthur@intel.com>, tpmdd-devel@lists.sourceforge.net, jason.gunthorpe@obsidianresearch.com, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:


> +
> +/**
> + * tpm2_startup() - send startup command to the TPM chip
> + * @chip:		TPM chip to use.
> + * @startup_type	startup type. The value is either
> + *			TPM_SU_CLEAR or TPM_SU_STATE.
> + *
> + * 0 is returned when the operation is successful. If a negative number is
> + * returned it remarks a POSIX error code. If a positive number is returned
> + * it remarks a TPM error.
> + */
> +int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
> +{
> +	struct tpm2_cmd cmd;
> +
> +	cmd.header.in = tpm2_startup_header;
> +
> +	cmd.params.startup_in.startup_type = startup_type;
> +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +				"attempting to start the TPM");
> +}

I suppose you need to send this command because your firmware does not 
do it ?Following TPM1.2 I guess the BIOS / UEFI should send this instead 
and sending it later would actually be wrong. Hm, I don't find from 
where you are calling this... do you need it ? Can you remove it?

    Stefan
