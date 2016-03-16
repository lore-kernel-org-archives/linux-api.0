From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v8 08/10] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Wed, 16 Mar 2016 09:49:57 -0400
Message-ID: <56E96485.2000100@linux.vnet.ibm.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160316120916.GA14820@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316120916.GA14820-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/16/2016 08:09 AM, Jarkko Sakkinen wrote:
> On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Berger wrote:
>> This patch implements a proxy driver for supporting multiple emulated TPMs
>> in a system.
>>
>> The driver implements a device /dev/vtpmx that is used to created
>> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
>> is accessed using a file descriptor returned by an ioctl.
>> The device /dev/tpmX is the usual TPM device created by the core TPM
>> driver. Applications or kernel subsystems can send TPM commands to it
>> and the corresponding server-side file descriptor receives these
>> commands and delivers them to an emulated TPM.
>>
>> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Alternative to this would be to have /dev/vtpmx create:
>
> * /dev/vtpm0 for the server
> * /dev/tpm0 for the client
>
> This is how David Howell's PoC worked and that's why I want
> to make this alternative visible.

My initial implementation had this as well.

>
> The server could even respawn without container noticing it.
> This solution have better availability properties.

A TPM should be stable enough to not have to be respawned...

     Stefan
