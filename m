From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated TPMs
Date: Wed, 9 Mar 2016 10:01:05 -0800
Message-ID: <CALCETrXDfHRdFnqK15o1yD8106sn4e6Susr9j7=GGi4sb-p0qQ@mail.gmail.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com> <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457545170-30120-9-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 9, 2016 at 9:39 AM, Stefan Berger
<stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> This patch implements a driver for supporting multiple emulated TPMs in a
> system.
>
> The driver implements a device /dev/vtpmx that is used to created
> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
> is accessed using a file descriptor returned by an ioctl.
> The device /dev/tpmX is the usual TPM device created by the core TPM
> driver. Applications or kernel subsystems can send TPM commands to it
> and the corresponding server-side file descriptor receives these
> commands and delivers them to an emulated TPM.

Nifty!

Is anyone considering writing a modification or replacement of
trousers that creates claims the real tpm and exposes a vtpm that
handles multiplexing internally?  Does the vtpm driver intelligently
support multiple simultaneous clients?

--Andy
