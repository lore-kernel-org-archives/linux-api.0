From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Mon, 6 Jul 2015 12:40:10 -0700
Message-ID: <CA+55aFxjuufbJpn+MngBzO3QyaYQm_ZNsgQY3VqPpguVpzOk6A@mail.gmail.com>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
	<20150706160706.GA22015@zurbaran.home>
	<CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3D3E3474@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B3D3E3474-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 6, 2015 at 11:59 AM, Winkler, Tomas <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Nope, 4.1 is fine. This is my travel laptop for the last almost two
>> years. Best laptop I've ever had (I like them small and light).
>
> If this two years old that's probably not HSW, can you send out the exact HW info, mostly pci device ids are in interest.

Oh, it's Haswell. It's a i5-4200u. And no, it's not quite two years
old, but it's from fall-2013.

And it's literally all Intel (series 8 mobile chipset) with a intel
7260 wireless. A whole lot of 8086 there:

  [torvalds@vaio ~]$ lspci -n
  00:00.0 0600: 8086:0a04 (rev 09)
  00:02.0 0300: 8086:0a16 (rev 09)
  00:03.0 0403: 8086:0a0c (rev 09)
  00:14.0 0c03: 8086:9c31 (rev 04)
  00:16.0 0780: 8086:9c3a (rev 04)
  00:1b.0 0403: 8086:9c20 (rev 04)
  00:1c.0 0604: 8086:9c14 (rev e4)
  00:1c.3 0604: 8086:9c16 (rev e4)
  00:1d.0 0c03: 8086:9c26 (rev 04)
  00:1f.0 0601: 8086:9c43 (rev 04)
  00:1f.2 0106: 8086:9c03 (rev 04)
  00:1f.3 0c05: 8086:9c22 (rev 04)
  01:00.0 0280: 8086:08b1 (rev 6b)

> This should be loaded only if you have NFC on the board or it bailed out more cleanly before.
> There is a file under debugfs mei0/meclients , if you can send out the dump we can see what
> we support on that platform.

  [torvalds@vaio ~]$ sudo cat /sys/kernel/debug/mei0/meclients
    |id|fix|         UUID                       |con|msg len|sb|refc|
   0|42|  0|b638ab7e-94e2-4ea2-a552-d1c54b627f04|  1|   2048| 0|   2|
   1|41|  0|fbf6fcf1-96cf-4e2e-a6a6-1bab8cbe36b1|  3|  15360| 0|   2|
   2|40|  0|3c4852d6-d47b-4f46-b05e-b5edc1aa440e|  1|   4096| 0|   2|
   3|39|  0|0bb17a78-2a8e-4c50-94d4-50266723775c|  1|    312| 0|   4|
   4|38|  0|d2de1625-382d-417d-48a4-efabba8a1206|  5|    312| 0|   2|
   5|37|  0|3c4852d6-d47b-4f46-b05e-b5edc1aa430a|  1|   4096| 0|   2|
   6|36|  0|f908627d-13bf-4a04-b91f-a64e9245323d|  1|  12388| 0|   2|
   7|35|  0|8c2f4425-77d6-4755-aca3-891fdbc66a58|  1|   1328| 0|   2|
   8|34|  0|3893448c-eab6-4f4c-b23c-57c2c4658dfc|  2|     64| 0|   2|
   9|33|  0|309dcde8-ccb1-4062-8f78-600115a34327|  1|    512| 0|   2|
  10|32|  0|8e6a6715-9abc-4043-88ef-9e39c6f63e0f|  2|   2048| 0|   2|
  11| 8|  1|bf3cb4da-4045-4f9b-838d-8cbcfb21a107|  0|   1328| 1|   2|
  12| 7|  1|55213584-9a29-4916-badf-0fb7ed682aeb|  0|   2048| 1|   2|
  13| 5|  1|fa8f55e8-ab22-42dd-b916-7dce39002574|  1|   4096| 1|   2|

> Frankly, if you are not using any of the pro or NFC you don't really need that loaded.

Yeah. Except I will not be releasing a kernel that I can tell is buggy
on my own hardware, so it really doesn't matter.

So that commit gets reverted unless somebody figures out what's wrong.

If *I* see problems from my very limited hardware testing, I guarantee
that others will see them too. And others will not be able to
necessarily bisect and test things, they'll just say "it hangs" and
maybe never try Linux any more than that.

So bugs I can see myself end up being stuff that I revert pretty much
immediately. I don't run odd hardware.

> The question if the module get bound to the NFC me client?

.. and how would that show up?

              Linus
