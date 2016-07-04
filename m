From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Syscall arguments are unsigned long (full registers)
Date: Mon, 04 Jul 2016 13:23:58 -0700
Message-ID: <C76180AF-6FEA-4AA4-9324-439A3456FBB0@zytor.com>
References: <A9946D15-1553-417B-BD0C-6C65AA2122B3@amazon.com> <C22BF648-D579-4B23-8BF6-C18033433F22@zytor.com> <C9F705AD-41A0-48CF-8A3E-507C12EB5D0E@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C9F705AD-41A0-48CF-8A3E-507C12EB5D0E-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tautschnig, Michael" <tautschn-vV1OtcyAfmbQXOPxS62xeg@public.gmane.org>
Cc: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jaswinder Singh <jaswinder-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On July 4, 2016 1:13:21 PM PDT, "Tautschnig, Michael" <tautschn-vV1OtcyAfmbQXOPxS62xeg@public.gmane.org> wrote:
>
>> On 4 Jul 2016, at 20:27, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> 
>> On July 4, 2016 6:52:58 AM PDT, "Tautschnig, Michael"
><tautschn-vV1OtcyAfmbQXOPxS62xeg@public.gmane.org> wrote:
>>> All syscall arguments are passed in as types of the same byte size
>as
>>> unsigned long (width of full registers). Using a smaller type
>without a
>>> cast may result in losing bits of information. In all other
>instances
>>> apart from the ones fixed by the patch the code explicitly
>introduces
>>> type casts (using, e.g., SYSCALL_DEFINE1).
>>> 
>>> While goto-cc reported these problems at build time, it is
>noteworthy
>>> that the calling conventions specified in the System V AMD64 ABI do
>>> ensure that parameters 1-6 are passed via registers, thus there is
>no
>>> implied risk of misaligned stack access.
>>> 
>>> 
>[...]
>> 
>> Wrong.  Syscall arguments aren't necessarily full registers, and on
>x86 truncation is already done by the callee, so we don't need any
>special handing.  Some other architectures have other constraints. 
>
>Ok - I'm assuming I have thus misunderstood
>eb974c62565072e10c1422eb3205f5b611dd99a1 ? Supposedly all those
>SYSCALL_DEFINEx are required for other architectures only?
>
>Best,
>Michael

That, and tracing.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
