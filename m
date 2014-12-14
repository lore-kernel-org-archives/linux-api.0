From: peterhuewe-Mmb7MZpHnFY@public.gmane.org
Subject: Re: [PATCH v10 1/8] tpm: merge duplicate transmit_cmd() functions
Date: Sun, 14 Dec 2014 16:31:10 +0100
Message-ID: <889c95a4-ae60-44db-be8a-fd56a9497c78@email.android.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com> <548D98B8.3010003@linux.vnet.ibm.com> <1418569030.9230.7.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418569030.9230.7.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 14. Dezember 2014 15:57:10 MEZ, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>On Sun, 2014-12-14 at 09:03 -0500, Stefan Berger wrote:
>> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
>> > Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
>> > Added "tpm_" prefix for consistency sake. Changed cmd parameter as
>> > opaque. This enables to use separate command structures for TPM1
>> > and TPM2 commands in future. Loose coupling works fine here.
>> >
>> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > Reviewed-by: Jasob Gunthorpe <jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> > Reviewed-by: Stephan Berger <stephan.berger-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Not quite ... Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
>Oops. Peter, I guess you could fix those or? My apologies.
>
>>      Stefan
>
>/Jarkko
I'll fix this,
No problem.
Peter
-- 
Sent from my mobile.
