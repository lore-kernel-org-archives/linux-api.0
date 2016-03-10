From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated
 TPMs
Date: Wed, 9 Mar 2016 21:34:47 -0500
Message-ID: <56E0DD47.50208@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <CALCETrXDfHRdFnqK15o1yD8106sn4e6Susr9j7=GGi4sb-p0qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXDfHRdFnqK15o1yD8106sn4e6Susr9j7=GGi4sb-p0qQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 03/09/2016 01:01 PM, Andy Lutomirski wrote:
> On Wed, Mar 9, 2016 at 9:39 AM, Stefan Berger
> <stefanb@linux.vnet.ibm.com> wrote:
>> This patch implements a driver for supporting multiple emulated TPMs in a
>> system.
>>
>> The driver implements a device /dev/vtpmx that is used to created
>> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
>> is accessed using a file descriptor returned by an ioctl.
>> The device /dev/tpmX is the usual TPM device created by the core TPM
>> driver. Applications or kernel subsystems can send TPM commands to it
>> and the corresponding server-side file descriptor receives these
>> commands and delivers them to an emulated TPM.
> Nifty!
>
> Is anyone considering writing a modification or replacement of
> trousers that creates claims the real tpm and exposes a vtpm that
> handles multiplexing internally?  Does the vtpm driver intelligently
> support multiple simultaneous clients?

The vtpm driver allows to use an independent trousers instance in each 
container.

Using the VTPM_NEW_DEV ioctl the container mgmt. stack can create a 
/dev/tpmX (X=0,1,2,...) device and a file descriptor. The file 
descriptor is passed to a vTPM instance, the /dev/tpmX is moved into the 
container, meaning a device with the same major/minor numbers is created 
in the container. This then allows each container to talk to an 
independent vTPM. The vTPM can either be 1.2 or 2.

    Stefan
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
