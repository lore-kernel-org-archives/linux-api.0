From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting multiple emulated
 TPMs
Date: Thu, 7 Apr 2016 11:49:44 -0400
Message-ID: <57068198.6050407@linux.vnet.ibm.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160407123539.GA17489@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407123539.GA17489-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/07/2016 08:35 AM, Jarkko Sakkinen wrote:
> On Tue, Mar 29, 2016 at 02:19:12PM -0400, Stefan Berger wrote:
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
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Thanks. So I can post a v10 where I have to re-introduce the priv field 
but put it into the tpm_chip struct. Obviously it needs this field. I am 
not sure whether you'll let me take the Reviewed-by and Tested-by, though?

    Stefan
