From: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Tue, 17 Oct 2017 14:39:02 +0200
Message-ID: <CA+M3ks6fNB+EA1p679nkRym3Geybm-xK65G5BKR+fLS9ge_Dgg@mail.gmail.com>
References: <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com> <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com> <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
 <20171004101720.ob5f467tro7agpcz@sirena.co.uk> <CA+M3ks5ZCUdTU5qU=Xi-MXXJQS6X-x=7qqs-5Myi7zeAAi8mJg@mail.gmail.com>
 <e3f91eff-df33-e203-2ce2-1f1dc98236ef@redhat.com> <20171009220858.zwbguqkamzmswqcq@sirena.co.uk>
 <dda39ec7-e1d7-8a11-2470-271cb7ba66e7@redhat.com> <20171010091151.rfdsphstboubm7ps@sirena.co.uk>
 <2a9246e0-eafa-7812-6cf4-2482ff1ed158@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2a9246e0-eafa-7812-6cf4-2482ff1ed158-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Riley Andrews <riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2017-10-17 0:09 GMT+02:00 Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On 10/10/2017 02:11 AM, Mark Brown wrote:
>> On Mon, Oct 09, 2017 at 05:10:37PM -0700, Laura Abbott wrote:
>>> On 10/09/2017 03:08 PM, Mark Brown wrote:
>>>> On Mon, Oct 09, 2017 at 02:25:47PM -0700, Laura Abbott wrote:
>>
>>>>> Anyway, to move this forward I think we need to see a proof of concept
>>>>> of using selinux to protect access to specific heaps.
>>
>>>> Aren't Unix permissions enough with separate files or am I
>>>> misunderstanding what you're looking to see a proof of concept for?
>>
>>> The goal is to be able to restrict heap access to certain services
>>> and selinux groups on Android so straight unix permissions aren't
>>> sufficient.
>>
>> Oh, there's Android users for this?  The users I was aware of were
>> non-Android.  Though even so I'd have thought that given that SELinux is
>> a superset of Unix file permissions it ought to be sufficient to be able
>> to use them.  I'd been thinking people were suggesting SELinux as a
>> replacement for file permissions, using the single file and the greater
>> capabilities of SELinux.
>>
> Unix file permissions are necessary but not sufficient, they
> can be used separately. Mostly what I want to see before
> merging this is an example that splitting the Ion heaps provides
> more protection than just keeping /dev/ion.
>

To give you an example on my system I have cma regions and so
2 heaps. One is for video decoding/encoding usage and one is dedicated
to display. The goal is to be sure to have enough memory for each devices

With only one /dev/ion nothing (except heap id mask) prohibed one video
apllication to use the cma region dedicated to display.
With one device per heaps I could change the permissions to be sure that
only display have access to the correct heap.
In android init.rc file I will have to change
  chmod 0666 /dev/ion
  chown system graphics /dev/ion

to something like
  chmod 0666 /dev/ion1
  chown system graphics /dev/ion1
  chmod 0666 /dev/ion2
  chown system media /dev/ion2

Android SEpolicy is defined like that
   allow { appdomain -isolated_app } ion_device:chr_file rw_file_perms;
which means that apps could have access to /dev/ion
with multiple devices we can imagine to protect some heap of being used by
the apps, for example like this
   allow { appdomain -isolated_app } ion_device0:chr_file {open ioctl};
   allow { system } ion_device1:chr_file {open ioctl};
  allow { media } ion_device2:chr_file {open ioctl};

Benjamin

> Thanks,
> Laura
