From: "Tautschnig, Michael" <tautschn-vV1OtcyAfmbQXOPxS62xeg@public.gmane.org>
Subject: Re: [PATCH] Syscall arguments are unsigned long (full registers)
Date: Mon, 4 Jul 2016 14:47:10 +0000
Message-ID: <ED0D99E6-1A18-4263-B227-7105313FA6AC@amazon.com>
References: <A9946D15-1553-417B-BD0C-6C65AA2122B3@amazon.com>
 <20160704142802.GL25121@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704142802.GL25121-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <3A71F8FC21DBC040B554DA45DA6940A8-QNDEzFLNp3/SUeElwK9/Pw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jaswinder Singh <jaswinder-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks a lot for the immediate feedback.

> On 4 Jul 2016, at 16:28, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> On Mon, Jul 04, 2016 at 01:52:58PM +0000, Tautschnig, Michael wrote:
>> All syscall arguments are passed in as types of the same byte size as
>> unsigned long (width of full registers). Using a smaller type without a
>> cast may result in losing bits of information. In all other instances
>> apart from the ones fixed by the patch the code explicitly introduces
>> type casts (using, e.g., SYSCALL_DEFINE1).
>> 
>> While goto-cc reported these problems at build time, it is noteworthy
>> that the calling conventions specified in the System V AMD64 ABI do
>> ensure that parameters 1-6 are passed via registers, thus there is no
>> implied risk of misaligned stack access.
> 
> Does this actually fix anything?
> 

It will ensure the behaviour on 32 and 64-bit systems is consistent, i.e.,
no truncation occurs. This is to ensure that future uses of these syscalls
do not face surprises.

> It seems a big dangerous to me, potentially breaking some existing
> binaries that rely on these arguments being truncated.
> 

Would an analysis of all current call sites be of help? It seems impossible
to tell whether any modules outside the kernel tree using this functionality
rely on the (seemingly broken) behaviour.

Of course I could also provide a patch that introduces explicit type casts
to document the truncation.

Best,
Michael
