From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated
 TPMs
Date: Thu, 10 Mar 2016 12:38:18 -0500
Message-ID: <56E1B10A.1030008@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <CALCETrXDfHRdFnqK15o1yD8106sn4e6Susr9j7=GGi4sb-p0qQ@mail.gmail.com>
 <56E0DD47.50208@linux.vnet.ibm.com>
 <CALCETrWz8pir1o0Gj1FVsvojfmFb8XZRKfJWdS-A8R9SbudiRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWz8pir1o0Gj1FVsvojfmFb8XZRKfJWdS-A8R9SbudiRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/09/2016 09:57 PM, Andy Lutomirski wrote:
> On Wed, Mar 9, 2016 at 6:34 PM, Stefan Berger
> <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>> On 03/09/2016 01:01 PM, Andy Lutomirski wrote:
>>> On Wed, Mar 9, 2016 at 9:39 AM, Stefan Berger
>>> <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>>>> This patch implements a driver for supporting multiple emulated TPMs in a
>>>> system.
>>>>
>>>> The driver implements a device /dev/vtpmx that is used to created
>>>> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
>>>> is accessed using a file descriptor returned by an ioctl.
>>>> The device /dev/tpmX is the usual TPM device created by the core TPM
>>>> driver. Applications or kernel subsystems can send TPM commands to it
>>>> and the corresponding server-side file descriptor receives these
>>>> commands and delivers them to an emulated TPM.
>>> Nifty!
>>>
>>> Is anyone considering writing a modification or replacement of
>>> trousers that creates claims the real tpm and exposes a vtpm that
>>> handles multiplexing internally?  Does the vtpm driver intelligently
>>> support multiple simultaneous clients?
>>
>> The vtpm driver allows to use an independent trousers instance in each
>> container.
>>
>> Using the VTPM_NEW_DEV ioctl the container mgmt. stack can create a
>> /dev/tpmX (X=0,1,2,...) device and a file descriptor. The file descriptor is
>> passed to a vTPM instance, the /dev/tpmX is moved into the container,
>> meaning a device with the same major/minor numbers is created in the
>> container. This then allows each container to talk to an independent vTPM.
>> The vTPM can either be 1.2 or 2.
> What I meant was:
>
> If two clients connect to the same vTPM slave node, can the master
> program tell requests from the two clients apart?  If so, great!  If
> not, then I'd consider that to be somewhat sad.

vTPM slave node being /dev/tpmX? TPM types of devices can currently only 
be opened by one application. This can for example be TSS/trousers, 
which then offers an API to applications for sending TPM commands. That 
only one application is allowed is a limitation of the existing driver.

    Stefan
